import datetime
import os
import random
import re
import uuid
from decimal import Decimal
from io import BytesIO
from typing import Dict, Tuple, List

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


def dict_to_choices(dict: Dict[str, str]) -> List[Tuple[str, str]]:
    return [
        (key, value)
        for key, value in dict.items()
    ]


def choice_to_verbose(keyword, choices):
    for choice in choices:
        if choice[0] == keyword:
            return choice[1]


class AdminSettings(models.Model):
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
    usd_eur_exchange_rate = models.DecimalField('1 USD -> x EUR курс', decimal_places=100, max_digits=200,
                                                default=Decimal(0.914))
    btc_usd_exchange_rate = models.DecimalField('1 BTC -> x USD курс', decimal_places=100, max_digits=200,
                                                default=Decimal(38902))
    eth_usd_exchange_rate = models.DecimalField('1 ETH -> x USD курс', decimal_places=100, max_digits=200,
                                                default=Decimal(2577))
    ton_usd_exchange_rate = models.DecimalField('1 TON -> x USD курс', decimal_places=100, max_digits=200,
                                                default=Decimal(1.86))

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
    ACCESS_STATUS_CHOICES = [
        ('default', 'Обычный'),
        ('admin', 'Админ'),
    ]
    user = models.ForeignKey(User, verbose_name='Пользователь', on_delete=models.CASCADE)
    created = models.DateTimeField('Дата создания', auto_now_add=True)
    access_status = models.CharField('Права', default='default', choices=ACCESS_STATUS_CHOICES, max_length=100)

    def __str__(self):
        return f'{self.user.username}'

    class Meta:
        verbose_name = 'Профиль'
        verbose_name_plural = 'Профили'


TRUST_WALLET_COINS = {
    'btc': 'Bitcoin',
    'ltc': 'Litecoin',
    'doge': 'Dogecoin',
    'dash': 'Dash',
    'via': 'Viacoin',
    'grs': 'Groestlcoin',
    'dgb': 'DigiByte',
    'mona': 'Monacoin',
    'dcr': 'Decred',
    'eth': 'Ethereum',
    'etc': 'Ethereum Classic',
    'icx': 'ICON',
    'atom': 'Cosmos',
    'zec': 'Zcash',
    'firo': 'Firo',
    'xrp': 'XRP',
    'bch': 'Smart Bitcoin Cash',
    'xlm': 'Stellar',
    'btg': 'Bitcoin Gold',
    'xno': 'Nano',
    'rvn': 'Ravencoin',
    'poa': 'POA Network',
    'eos': 'EOS',
    'trx': 'Tron',
    'fio': 'FIO',
    'nim': 'Nimiq',
    'algo': 'Algorand',
    'iotx': 'IoTeX',
    'zil': 'Zilliqa',
    'luna': 'Terra',
    'dot': 'Polkadot',
    'near': 'NEAR',
    'aion': 'Aion',
    'ksm': 'Kusama',
    'ae': 'Aeternity',
    'kava': 'Kava',
    'fil': 'Filecoin',
    'blz': 'Bluzelle',
    'band': 'BandChain',
    'theta': 'Theta',
    'sol': 'Solana',
    'egld': 'Elrond',
    'bnb': 'Smart Chain',
    'vet': 'VeChain',
    'clo': 'Callisto',
    'neo': 'NEO',
    'tomo': 'TomoChain',
    'tt': 'Thunder Token',
    'one': 'Harmony',
    'rose': 'Oasis',
    'ont': 'Ontology',
    'xtz': 'Tezos',
    'ada': 'Cardano',
    'kin': 'Kin',
    'qtum': 'Qtum',
    'nas': 'Nebulas',
    'go': 'GoChain',
    'nuls': 'NULS',
    'flux': 'Zelcash',
    'wan': 'Wanchain',
    'waves': 'Waves',
    'matic': 'Polygon',
    'rune': 'THORChain',
    'oeth': 'Optimism',
    'areth': 'Arbitrum',
    'ht': 'ECO Chain',
    'avax': 'Avalanche C-Chain',
    'xdai': 'xDai',
    'ftm': 'Fantom',
    'cro': 'Cronos Chain',
    'celo': 'Celo',
    'ron': 'Ronin',
    'osmo': 'Osmosis',
    'xec': 'ECash',
}

TRUST_WALLET_COINS_CHOICES = dict_to_choices(TRUST_WALLET_COINS)

INDEPENDENT_COINS = {
    'ton': 'Toncoin'
}

INDEPENDENT_COINS_CHOICES = dict_to_choices(INDEPENDENT_COINS)

COINS = {**TRUST_WALLET_COINS, **INDEPENDENT_COINS}

COINS_CHOICES = dict_to_choices(COINS)


class IndependentWallet(models.Model):
    owner = models.ForeignKey(Profile, verbose_name='Владелец', on_delete=models.PROTECT)
    currency = models.CharField('Валюта', choices=INDEPENDENT_COINS_CHOICES, max_length=10)
    address = models.CharField('Адрес', max_length=1000)
    segwit_address = models.CharField('SegWit Адрес', max_length=1000, null=True, blank=True)
    public_key = models.CharField('Public key', max_length=10000, null=True, blank=True)
    private_key = models.CharField('Private key', max_length=10000)


class TrustWallet(models.Model):
    owner = models.ForeignKey(Profile, verbose_name='Владелец', on_delete=models.PROTECT)
    mnemonic = models.CharField('Mnemonic', max_length=10 ** 3)
    btc_address = models.CharField('Bitcoin address', max_length=10 ** 3)
    ltc_address = models.CharField('Litecoin address', max_length=10 ** 3)
    doge_address = models.CharField('Dogecoin address', max_length=10 ** 3)
    dash_address = models.CharField('Dash address', max_length=10 ** 3)
    via_address = models.CharField('Viacoin address', max_length=10 ** 3)
    grs_address = models.CharField('Groestlcoin address', max_length=10 ** 3)
    dgb_address = models.CharField('DigiByte address', max_length=10 ** 3)
    mona_address = models.CharField('Monacoin address', max_length=10 ** 3)
    dcr_address = models.CharField('Decred address', max_length=10 ** 3)
    eth_address = models.CharField('Ethereum address', max_length=10 ** 3)
    etc_address = models.CharField('Ethereum Classic address', max_length=10 ** 3)
    icx_address = models.CharField('ICON address', max_length=10 ** 3)
    atom_address = models.CharField('Cosmos address', max_length=10 ** 3)
    zec_address = models.CharField('Zcash address', max_length=10 ** 3)
    firo_address = models.CharField('Firo address', max_length=10 ** 3)
    xrp_address = models.CharField('XRP address', max_length=10 ** 3)
    bch_address = models.CharField('Smart Bitcoin Cash address', max_length=10 ** 3)
    xlm_address = models.CharField('Stellar address', max_length=10 ** 3)
    btg_address = models.CharField('Bitcoin Gold address', max_length=10 ** 3)
    xno_address = models.CharField('Nano address', max_length=10 ** 3)
    rvn_address = models.CharField('Ravencoin address', max_length=10 ** 3)
    poa_address = models.CharField('POA Network address', max_length=10 ** 3)
    eos_address = models.CharField('EOS address', max_length=10 ** 3)
    trx_address = models.CharField('Tron address', max_length=10 ** 3)
    fio_address = models.CharField('FIO address', max_length=10 ** 3)
    nim_address = models.CharField('Nimiq address', max_length=10 ** 3)
    algo_address = models.CharField('Algorand address', max_length=10 ** 3)
    iotx_address = models.CharField('IoTeX address', max_length=10 ** 3)
    zil_address = models.CharField('Zilliqa address', max_length=10 ** 3)
    luna_address = models.CharField('Terra address', max_length=10 ** 3)
    dot_address = models.CharField('Polkadot address', max_length=10 ** 3)
    near_address = models.CharField('NEAR address', max_length=10 ** 3)
    aion_address = models.CharField('Aion address', max_length=10 ** 3)
    ksm_address = models.CharField('Kusama address', max_length=10 ** 3)
    ae_address = models.CharField('Aeternity address', max_length=10 ** 3)
    kava_address = models.CharField('Kava address', max_length=10 ** 3)
    fil_address = models.CharField('Filecoin address', max_length=10 ** 3)
    blz_address = models.CharField('Bluzelle address', max_length=10 ** 3)
    band_address = models.CharField('BandChain address', max_length=10 ** 3)
    theta_address = models.CharField('Theta address', max_length=10 ** 3)
    sol_address = models.CharField('Solana address', max_length=10 ** 3)
    egld_address = models.CharField('Elrond address', max_length=10 ** 3)
    bnb_address = models.CharField('Smart Chain address', max_length=10 ** 3)
    vet_address = models.CharField('VeChain address', max_length=10 ** 3)
    clo_address = models.CharField('Callisto address', max_length=10 ** 3)
    neo_address = models.CharField('NEO address', max_length=10 ** 3)
    tomo_address = models.CharField('TomoChain address', max_length=10 ** 3)
    tt_address = models.CharField('Thunder Token address', max_length=10 ** 3)
    one_address = models.CharField('Harmony address', max_length=10 ** 3)
    rose_address = models.CharField('Oasis address', max_length=10 ** 3)
    ont_address = models.CharField('Ontology address', max_length=10 ** 3)
    xtz_address = models.CharField('Tezos address', max_length=10 ** 3)
    ada_address = models.CharField('Cardano address', max_length=10 ** 3)
    kin_address = models.CharField('Kin address', max_length=10 ** 3)
    qtum_address = models.CharField('Qtum address', max_length=10 ** 3)
    nas_address = models.CharField('Nebulas address', max_length=10 ** 3)
    go_address = models.CharField('GoChain address', max_length=10 ** 3)
    nuls_address = models.CharField('NULS address', max_length=10 ** 3)
    flux_address = models.CharField('Zelcash address', max_length=10 ** 3)
    wan_address = models.CharField('Wanchain address', max_length=10 ** 3)
    waves_address = models.CharField('Waves address', max_length=10 ** 3)
    matic_address = models.CharField('Polygon address', max_length=10 ** 3)
    rune_address = models.CharField('THORChain address', max_length=10 ** 3)
    oeth_address = models.CharField('Optimism address', max_length=10 ** 3)
    areth_address = models.CharField('Arbitrum address', max_length=10 ** 3)
    ht_address = models.CharField('ECO Chain address', max_length=10 ** 3)
    avax_address = models.CharField('Avalanche C-Chain address', max_length=10 ** 3)
    xdai_address = models.CharField('xDai address', max_length=10 ** 3)
    ftm_address = models.CharField('Fantom address', max_length=10 ** 3)
    cro_address = models.CharField('Cronos Chain address', max_length=10 ** 3)
    celo_address = models.CharField('Celo address', max_length=10 ** 3)
    ron_address = models.CharField('Ronin address', max_length=10 ** 3)
    osmo_address = models.CharField('Osmosis address', max_length=10 ** 3)
    xec_address = models.CharField('ECash address', max_length=10 ** 3)


class Keeper(models.Model):
    owner = models.ForeignKey(Profile, verbose_name='Владелец', on_delete=models.PROTECT)
    ton_wallet = models.ForeignKey(IndependentWallet, verbose_name='Toncoin Independent Wallet', on_delete=models.PROTECT, related_name='keeper_ton_independent_wallet')
    trust_wallet = models.ForeignKey(TrustWallet, verbose_name='Trust Wallet', on_delete=models.PROTECT, related_name='keeper_trust_wallet')

    def __str__(self):
        return f'{self.owner.user.username}'


class Transaction(models.Model):
    currency = models.CharField('Валюта', choices=COINS_CHOICES, max_length=10)
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
