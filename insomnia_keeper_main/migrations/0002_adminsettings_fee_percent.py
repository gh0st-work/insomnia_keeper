# Generated by Django 4.0.2 on 2022-03-11 22:19

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('insomnia_keeper_main', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='adminsettings',
            name='fee_percent',
            field=models.DecimalField(decimal_places=2, default=1, max_digits=5, verbose_name='Комиссия %'),
        ),
    ]
