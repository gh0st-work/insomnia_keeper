import json
import time
from decimal import Decimal

import requests
from django.core.management.base import BaseCommand

from insomnia_keeper_main.models import *


class Command(BaseCommand):
    help = 'Collect exchange rates'

    def handle(self, *args, **options):

        def get_fiat_rate(from_currency: str, to_currency: str) -> Decimal:
            success = False
            result = None
            while not success:
                try:
                    url = 'https://api.exchangerate.host/convert'  # super project
                    response = requests.get(url, {
                        'from': from_currency,
                        'to': to_currency,
                        'places': 50
                    })
                    data = response.json()
                    if data['success']:
                        result = Decimal(data['info']['rate'])
                        success = True
                except BaseException as ex:
                    print(ex)
                time.sleep(1)
            return result

        def get_crypto_usd_rate(currency: str) -> Decimal:
            success = False
            result = None
            while not success:
                try:
                    url = 'https://api.coinbase.com/v2/exchange-rates'
                    response = requests.get(url, {
                        'currency': currency
                    })
                    data = response.json()
                    result = Decimal(data['data']['rates']['USD'])
                    success = True
                except BaseException as ex:
                    print(ex)
                time.sleep(1)
            return result

        fiat_rates = {
            'usd_rub': get_fiat_rate('USD', 'RUB'),
            'usd_eur': get_fiat_rate('USD', 'EUR'),
        }
        crypto_rates = {
            'btc_usd': get_crypto_usd_rate('BTC'),
            'eth_usd': get_crypto_usd_rate('ETH'),
            'ton_usd': get_crypto_usd_rate('TONCOIN'),
        }
        Global.objects.filter(active=True).update(**{
            f'{rate_key}_exchange_rate': rate
            for rate_key, rate in {**fiat_rates, **crypto_rates}.items()
        })
