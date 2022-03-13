import json
import time
from decimal import Decimal
import requests
from django.core.management.base import BaseCommand

from insomnia_keeper_main.models import *
import tonweb.management as ton


class Command(BaseCommand):
    help = 'Collect exchange rates'

    def handle(self, *args, **options):
        ton.create_wallet()

