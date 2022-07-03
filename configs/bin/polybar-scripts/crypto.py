#!/usr/bin/env python3

import configparser
import sys
import requests
from decimal import Decimal
from os.path import expanduser

config = configparser.ConfigParser()

# File must be opened with utf-8 explicitly
with open(expanduser('~/.config/polybar/crypto-config'), 'r', encoding='utf-8') as f:
    config.read_file(f)

# Everything except the general section
currencies = [x for x in config.sections() if x != 'general']

for currency in currencies:
    try:
        icon = config[currency]['icon']

        price_round = 2
        if 'price_round' in config[currency]:
            price_round = int(config[currency]['price_round'])

        price = round(Decimal(requests.get(f'https://api.binance.com/api/v3/ticker/price?symbol={currency}').json()['price']), price_round)
        percentage = round(Decimal(requests.get(f'https://api.binance.com/api/v3/ticker/24hr?symbol={currency}').json()['priceChangePercent']), 2)

        if 'click' in config[currency]:
            sys.stdout.write(f"%{{A1:{config[currency]['click']}:}}")

        display_opt = 'both'
        if 'display' in config['general']:
            display_opt = config['general']['display']

        if display_opt == 'both':
            sys.stdout.write(f'{icon} {price}/{percentage:+}%')
        elif display_opt == 'percentage':
            sys.stdout.write(f'{icon} {percentage:+}%')
        elif display_opt == 'price':
            sys.stdout.write(f'{icon} {price}')

        if 'click' in config[currency]:
            sys.stdout.write(f'%{{A}}')

        if currency != currencies[-1]:
            sys.stdout.write('  ')
    except requests.exceptions.ConnectionError as e:
        sys.stdout.write('not connected')
        break
