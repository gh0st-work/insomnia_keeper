import datetime
import os
import random
import re
import uuid
from decimal import Decimal
from io import BytesIO
from typing import Dict, Tuple

from ckeditor.fields import RichTextField
from django.conf import settings
from django.contrib.auth.models import User
from django.core.files import File
from django.core.files.base import ContentFile
from django.core.files.storage import FileSystemStorage
from django.core.files.uploadedfile import InMemoryUploadedFile
from django.core.validators import RegexValidator
from django.db import models
from django.db.models.signals import post_save, pre_save, pre_delete
from django.dispatch import receiver
from django.template.loader import get_template
from django.utils import timezone

try:
    from uwsgidecorators import spool
except:
    def spool(func):
        def func_wrapper(**arguments):
            return func(arguments)

        return func_wrapper


def send_mail(subject, template, email, context_args):
    # plaintext = get_template(f'emails/txt/{template}.txt')
    htmly = get_template(f'emails/ru/{template}.html')
    fixed = Global.objects.get(active=True)
    admin_settings = AdminSettings.objects.get(active=True)
    context = {'fixed': fixed, 'STATIC_URL': settings.STATIC_URL}
    context.update(context_args)
    # text_content = plaintext.render(context)
    html_content = htmly.render(context)
    if settings.LOCAL:
        print(f'\n\n\n'
              f'Key: {context["key"]}'
              f'\n\n\n')
    else:
        # msg = EmailMultiAlternatives(subject, text_content, '{} <noreply@{}>'.format(fixed.site_name, fixed.base), [email])
        # msg.attach_alternative(html_content, "text/html")
        # msg.send()

        message = Mail(
            from_email=admin_settings.sendgrid_sender_email,
            to_emails=email,
            subject=subject,
            html_content=html_content
        )
        done = False
        retry = 3
        while not done:
            sg = SendGridAPIClient(admin_settings.sendgrid_api_key)
            response = sg.send(message)
            if response.status_code in range(200, 300):
                done = True
            else:
                retry -= 1
            if retry <= 0:
                done = True
                print(f'\n'
                      f'Email не отправлен.'
                      f'\n'
                      f'Ответ: [{response.status_code}] {response.body}.'
                      f'\n')


def select_storage():
    return FileSystemStorage()


def resize_image(image_field, resize_to: Tuple[int, int] = (1280, 720)):
    img = Image.open(image_field.file.file)
    buffer = BytesIO()
    img.thumbnail(resize_to)
    img = img.convert('RGB')
    img.save(buffer, format='JPEG', losseless=False, quality=80, method=6)
    jpeg_image_name = '.'.join(image_field.name.split('.')[:-1]) + '.jpeg'
    image_field.save(
        jpeg_image_name,
        InMemoryUploadedFile(
            buffer,
            None,
            jpeg_image_name,
            'image/jpeg',
            img.size,
            None,
        ),
        save=False
    )


def add_webp_image(image_field, image_webp_field):
    img = Image.open(image_field.file.file)
    buffer = BytesIO()
    img = img.convert('RGB')
    img.save(buffer, format='WEBP', losseless=False, quality=80, method=6)
    webp_image_name = '.'.join(image_field.name.split('.')[:-1]) + '.webp'
    image_webp_field.save(
        webp_image_name,
        InMemoryUploadedFile(
            buffer,
            None,
            webp_image_name,
            'image/webp',
            img.size,
            None,
        ),
        save=False
    )


def verbose_choice(keyword, choices):
    for choice in choices:
        if choice[0] == keyword:
            return choice[1]


class AdminSettings(models.Model):
    notification_mails = models.TextField('Email-ы для оповещений через Enter', blank=True, null=True)  # Some data
    sendgrid_api_key = models.CharField('SendGrid API key',
                                        default='',
                                        max_length=1000)
    sendgrid_sender_email = models.CharField('SendGrid Sender Email', default='', max_length=1000)
    fee_percent = models.DecimalField('Комиссия %', decimal_places=2, max_digits=5, default=1)
    active = models.BooleanField('Активно', default=True)

    class Meta:
        verbose_name = 'Пресет админских настроек'
        verbose_name_plural = 'Админские настройки'

    def save(self, *args, **kwargs):
        if self.fee_percent < 0:
            raise Exception('Коммисия % должна быть больше или равна нулю')
        if self.fee_percent > 10:
            raise Exception('Коммисия % должна меньше 10')
        if self.active:
            AdminSettings.objects.filter(active=self.active).update(active=False)
        super(AdminSettings, self).save(*args, **kwargs)

    def __str__(self):
        if self.active:
            return 'Активный пресет админских настроек'
        else:
            return f'Пресет админских настроек {self.id}'


class Global(models.Model):
    """ Глобальные настройки """
    phone_number = models.CharField('Контактный номер телефона', max_length=20)
    whatsapp_number = models.PositiveBigIntegerField('WhatsApp номер',
                                                     help_text='В междунарожном формате, подробнее <a href="https://faq.whatsapp.com/general/chats/how-to-use-click-to-chat" target="_blank">тут</a>',
                                                     blank=True, null=True)
    instagram_username = models.CharField('Instagram username', max_length=200, blank=True, null=True)
    telegram_link = models.CharField('Telegram link', max_length=200, blank=True, null=True)
    facebook_username = models.CharField('Facebook username', help_text='https://facebook.com/<ваш username>/',
                                         max_length=50, blank=True, null=True)
    usd_rub_exchange_rate = models.DecimalField('1 USD -> x RUB курс', decimal_places=100, max_digits=200, default=120)
    usd_eur_exchange_rate = models.DecimalField('1 USD -> x EUR курс', decimal_places=100, max_digits=200, default=Decimal(0.914))
    btc_usd_exchange_rate = models.DecimalField('1 BTC -> x USD курс', decimal_places=100, max_digits=200, default=Decimal(38902))
    eth_usd_exchange_rate = models.DecimalField('1 ETH -> x USD курс', decimal_places=100, max_digits=200, default=Decimal(2577))
    ton_usd_exchange_rate = models.DecimalField('1 TON -> x USD курс', decimal_places=100, max_digits=200, default=Decimal(1.86))

    active = models.BooleanField('Активно', default=True)

    class Meta:
        verbose_name = 'Пресет настройки'
        verbose_name_plural = 'Глобальные настройки'

    def save(self, *args, **kwargs):
        if self.active:
            Global.objects.filter(active=self.active).update(active=False)
        super(Global, self).save(*args, **kwargs)

    def __str__(self):
        if self.active:
            return 'Активный пресет настроек'
        else:
            return 'Пресет настроек %s' % self.id


class Rules(models.Model):
    content = RichTextField('Правила', null=True, blank=True)
    active = models.BooleanField('Активно', default=True)

    class Meta:
        verbose_name = 'Пресет правил'
        verbose_name_plural = 'Правила'

    def save(self, *args, **kwargs):
        if self.active:
            Rules.objects.filter(active=self.active).update(active=False)
        super(Rules, self).save(*args, **kwargs)

    def __str__(self):
        if self.active:
            return 'Активные правила'
        else:
            return 'Пресет правил %s' % self.id


class Profile(models.Model):
    """ Профиль """
    STATUS_CHOICES = [
        ('activation', 'Отправленна ссылка активации'),
        ('active', 'Активен'),
    ]
    ACCESS_STATUS_CHOICES = [
        ('default', 'Обычный'),
        ('admin', 'Админ'),
    ]
    user = models.OneToOneField(User, verbose_name='Пользователь', on_delete=models.CASCADE)
    tag = models.CharField('Тег', max_length=150, unique=True)
    created = models.DateTimeField('Дата создания', auto_now_add=True)
    status = models.CharField('Статус', default='activation', max_length=10, choices=STATUS_CHOICES)
    access_status = models.CharField('Права', default='default', choices=ACCESS_STATUS_CHOICES, max_length=100)

    def __str__(self):
        return f'{self.tag} ({self.user.email})'

    class Meta:
        verbose_name = 'Профиль'
        verbose_name_plural = 'Профили'


def generate_key(
        model,
        field_name,
        size: int = 6,
) -> str:
    allowed_chars = 'qwertyuiopasdfghjklzxcvbnm0123456789'
    while True:
        new_key = ''.join(random.choice(allowed_chars) for _ in range(size))
        if not model.objects.filter(**{field_name: new_key}).count():
            break
    return new_key


class EmailVerification(models.Model):
    """ Ключи подтверждения email """
    user = models.ForeignKey(User, verbose_name='Пользователь', on_delete=models.CASCADE)
    new_email = models.EmailField('Новый e-mail', max_length=120)
    key = models.CharField('Ключ подтверждения', max_length=500, null=True, blank=True)
    created = models.DateTimeField('Дата создания', auto_now_add=True)

    def save(self, *args, **kwargs):
        if not self.key:
            self.key = generate_key(EmailVerification, 'key')
        super().save(*args, **kwargs)

    def __str__(self):
        return self.user.email

    class Meta:
        verbose_name = 'Ключ подверждения email'
        verbose_name_plural = 'Ключи подверждения email'


class ResetPasswordVerification(models.Model):
    """ Ключи подтверждения сброса пароля """
    user = models.ForeignKey(User, verbose_name='Пользователь', on_delete=models.CASCADE)
    key = models.CharField('Ключ подтверждения', max_length=500, null=True, blank=True)
    created = models.DateTimeField('Дата создания', auto_now_add=True)

    def save(self, *args, **kwargs):
        if not self.key:
            self.key = generate_key(ResetPasswordVerification, 'key')
        super().save(*args, **kwargs)

    def __str__(self):
        return self.user.email

    class Meta:
        verbose_name = 'Ключ подверждения сброса пароля'
        verbose_name_plural = 'Ключи подверждения сброса пароля'


CURRENCY_TYPES = [
    ('btc', 'Bitcoin'),
    ('eth', 'Etherium'),
    ('ton', 'Toncoin'),
]


class Wallet(models.Model):
    owner = models.ForeignKey(Profile, verbose_name='Владелец', on_delete=models.PROTECT)
    currency = models.CharField('Валюта', choices=CURRENCY_TYPES, max_length=10)
    address = models.CharField('Адрес', max_length=1000)
    segwit_address = models.CharField('SegWit Адрес', max_length=1000, null=True, blank=True)
    private_key = models.CharField('Private key', max_length=10000)


class Keeper(models.Model):
    owner = models.ForeignKey(Profile, verbose_name='Владелец', on_delete=models.PROTECT)
    btc_wallet = models.ForeignKey(Wallet, verbose_name='Bitcoin адрес', null=True, blank=True, on_delete=models.PROTECT, related_name='keeper_btc_wallet')
    eth_wallet = models.ForeignKey(Wallet, verbose_name='Etherium адрес', null=True, blank=True, on_delete=models.PROTECT, related_name='keeper_etc_wallet')
    ton_wallet = models.ForeignKey(Wallet, verbose_name='Toncoin адрес', null=True, blank=True, on_delete=models.PROTECT, related_name='keeper_ton_wallet')

    def __str__(self):
        return f'{self.owner.tag} ({self.owner.user.email})'


class Transaction(models.Model):
    currency = models.CharField('Валюта', choices=CURRENCY_TYPES, max_length=10)
    amount = models.DecimalField('Количество', max_digits=200, decimal_places=100, default=0)
    from_keeper = models.ForeignKey(Keeper, verbose_name='Кипер отправителя', on_delete=models.PROTECT, related_name='transaction_from_keeper')
    to_address = models.CharField('Адрес получателя', null=True, blank=True, max_length=1000)
    to_keeper = models.ForeignKey(Keeper, verbose_name='Кипер получателя', on_delete=models.PROTECT, related_name='transaction_to_keeper', null=True, blank=True)
    created = models.DateTimeField('Дата создания', auto_now_add=True)

    def save(self, *args, **kwargs):
        if self.amount <= 0:
            raise Exception('Количество должно быть больше 0')
        if not self.to_address and not self.to_keeper:
            raise Exception('Укажите адрес или кипер')
        super().save(*args, **kwargs)

    def __str__(self):
        to_text = (self.to_address if self.to_address else self.to_keeper)
        return f'{self.from_keeper} ({self.amount} {self.currency}) -> {to_text}'

    class Meta:
        verbose_name = 'Транзакция'
        verbose_name_plural = 'Транзакции'


class Error(models.Model):
    pathname = models.CharField('Путь', max_length=1000, blank=True, null=True)
    stack = models.TextField('Трейс', max_length=5000, blank=True, null=True)
    info = models.TextField('Информация', max_length=1000, blank=True, null=True)
    created = models.DateTimeField('Дата создания', auto_now_add=True)

    def __str__(self):
        return f'{self.pathname} - {self.created.strftime("%d.%m.%y %H:%M:%S")}'

    class Meta:
        verbose_name = 'Ошибка фронта'
        verbose_name_plural = 'Ошибки фронта'
