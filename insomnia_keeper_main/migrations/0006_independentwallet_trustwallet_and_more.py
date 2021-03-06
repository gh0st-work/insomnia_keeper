# Generated by Django 4.0.3 on 2022-03-19 17:45

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('insomnia_keeper_main', '0005_alter_adminsettings_sendgrid_api_key_and_more'),
    ]

    operations = [
        migrations.CreateModel(
            name='IndependentWallet',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('currency', models.CharField(choices=[('ton', 'Toncoin')], max_length=10, verbose_name='Валюта')),
                ('address', models.CharField(max_length=1000, verbose_name='Адрес')),
                ('segwit_address', models.CharField(blank=True, max_length=1000, null=True, verbose_name='SegWit Адрес')),
                ('public_key', models.CharField(blank=True, max_length=10000, null=True, verbose_name='Public key')),
                ('private_key', models.CharField(max_length=10000, verbose_name='Private key')),
            ],
        ),
        migrations.CreateModel(
            name='TrustWallet',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('mnemonic', models.CharField(max_length=1000, verbose_name='Mnemonic')),
                ('btc_address', models.CharField(max_length=1000, verbose_name='Bitcoin address')),
                ('ltc_address', models.CharField(max_length=1000, verbose_name='Litecoin address')),
                ('doge_address', models.CharField(max_length=1000, verbose_name='Dogecoin address')),
                ('dash_address', models.CharField(max_length=1000, verbose_name='Dash address')),
                ('via_address', models.CharField(max_length=1000, verbose_name='Viacoin address')),
                ('grs_address', models.CharField(max_length=1000, verbose_name='Groestlcoin address')),
                ('dgb_address', models.CharField(max_length=1000, verbose_name='DigiByte address')),
                ('mona_address', models.CharField(max_length=1000, verbose_name='Monacoin address')),
                ('dcr_address', models.CharField(max_length=1000, verbose_name='Decred address')),
                ('eth_address', models.CharField(max_length=1000, verbose_name='Ethereum address')),
                ('etc_address', models.CharField(max_length=1000, verbose_name='Ethereum Classic address')),
                ('icx_address', models.CharField(max_length=1000, verbose_name='ICON address')),
                ('atom_address', models.CharField(max_length=1000, verbose_name='Cosmos address')),
                ('zec_address', models.CharField(max_length=1000, verbose_name='Zcash address')),
                ('firo_address', models.CharField(max_length=1000, verbose_name='Firo address')),
                ('xrp_address', models.CharField(max_length=1000, verbose_name='XRP address')),
                ('bch_address', models.CharField(max_length=1000, verbose_name='Smart Bitcoin Cash address')),
                ('xlm_address', models.CharField(max_length=1000, verbose_name='Stellar address')),
                ('btg_address', models.CharField(max_length=1000, verbose_name='Bitcoin Gold address')),
                ('xno_address', models.CharField(max_length=1000, verbose_name='Nano address')),
                ('rvn_address', models.CharField(max_length=1000, verbose_name='Ravencoin address')),
                ('poa_address', models.CharField(max_length=1000, verbose_name='POA Network address')),
                ('eos_address', models.CharField(max_length=1000, verbose_name='EOS address')),
                ('trx_address', models.CharField(max_length=1000, verbose_name='Tron address')),
                ('fio_address', models.CharField(max_length=1000, verbose_name='FIO address')),
                ('nim_address', models.CharField(max_length=1000, verbose_name='Nimiq address')),
                ('algo_address', models.CharField(max_length=1000, verbose_name='Algorand address')),
                ('iotx_address', models.CharField(max_length=1000, verbose_name='IoTeX address')),
                ('zil_address', models.CharField(max_length=1000, verbose_name='Zilliqa address')),
                ('luna_address', models.CharField(max_length=1000, verbose_name='Terra address')),
                ('dot_address', models.CharField(max_length=1000, verbose_name='Polkadot address')),
                ('near_address', models.CharField(max_length=1000, verbose_name='NEAR address')),
                ('aion_address', models.CharField(max_length=1000, verbose_name='Aion address')),
                ('ksm_address', models.CharField(max_length=1000, verbose_name='Kusama address')),
                ('ae_address', models.CharField(max_length=1000, verbose_name='Aeternity address')),
                ('kava_address', models.CharField(max_length=1000, verbose_name='Kava address')),
                ('fil_address', models.CharField(max_length=1000, verbose_name='Filecoin address')),
                ('blz_address', models.CharField(max_length=1000, verbose_name='Bluzelle address')),
                ('band_address', models.CharField(max_length=1000, verbose_name='BandChain address')),
                ('theta_address', models.CharField(max_length=1000, verbose_name='Theta address')),
                ('sol_address', models.CharField(max_length=1000, verbose_name='Solana address')),
                ('egld_address', models.CharField(max_length=1000, verbose_name='Elrond address')),
                ('bnb_address', models.CharField(max_length=1000, verbose_name='Smart Chain address')),
                ('vet_address', models.CharField(max_length=1000, verbose_name='VeChain address')),
                ('clo_address', models.CharField(max_length=1000, verbose_name='Callisto address')),
                ('neo_address', models.CharField(max_length=1000, verbose_name='NEO address')),
                ('tomo_address', models.CharField(max_length=1000, verbose_name='TomoChain address')),
                ('tt_address', models.CharField(max_length=1000, verbose_name='Thunder Token address')),
                ('one_address', models.CharField(max_length=1000, verbose_name='Harmony address')),
                ('rose_address', models.CharField(max_length=1000, verbose_name='Oasis address')),
                ('ont_address', models.CharField(max_length=1000, verbose_name='Ontology address')),
                ('xtz_address', models.CharField(max_length=1000, verbose_name='Tezos address')),
                ('ada_address', models.CharField(max_length=1000, verbose_name='Cardano address')),
                ('kin_address', models.CharField(max_length=1000, verbose_name='Kin address')),
                ('qtum_address', models.CharField(max_length=1000, verbose_name='Qtum address')),
                ('nas_address', models.CharField(max_length=1000, verbose_name='Nebulas address')),
                ('go_address', models.CharField(max_length=1000, verbose_name='GoChain address')),
                ('nuls_address', models.CharField(max_length=1000, verbose_name='NULS address')),
                ('flux_address', models.CharField(max_length=1000, verbose_name='Zelcash address')),
                ('wan_address', models.CharField(max_length=1000, verbose_name='Wanchain address')),
                ('waves_address', models.CharField(max_length=1000, verbose_name='Waves address')),
                ('matic_address', models.CharField(max_length=1000, verbose_name='Polygon address')),
                ('rune_address', models.CharField(max_length=1000, verbose_name='THORChain address')),
                ('oeth_address', models.CharField(max_length=1000, verbose_name='Optimism address')),
                ('areth_address', models.CharField(max_length=1000, verbose_name='Arbitrum address')),
                ('ht_address', models.CharField(max_length=1000, verbose_name='ECO Chain address')),
                ('avax_address', models.CharField(max_length=1000, verbose_name='Avalanche C-Chain address')),
                ('xdai_address', models.CharField(max_length=1000, verbose_name='xDai address')),
                ('ftm_address', models.CharField(max_length=1000, verbose_name='Fantom address')),
                ('cro_address', models.CharField(max_length=1000, verbose_name='Cronos Chain address')),
                ('celo_address', models.CharField(max_length=1000, verbose_name='Celo address')),
                ('ron_address', models.CharField(max_length=1000, verbose_name='Ronin address')),
                ('osmo_address', models.CharField(max_length=1000, verbose_name='Osmosis address')),
                ('xec_address', models.CharField(max_length=1000, verbose_name='ECash address')),
            ],
        ),
        migrations.RemoveField(
            model_name='resetpasswordverification',
            name='user',
        ),
        migrations.RemoveField(
            model_name='wallet',
            name='owner',
        ),
        migrations.RemoveField(
            model_name='adminsettings',
            name='notification_mails',
        ),
        migrations.RemoveField(
            model_name='adminsettings',
            name='sendgrid_api_key',
        ),
        migrations.RemoveField(
            model_name='adminsettings',
            name='sendgrid_sender_email',
        ),
        migrations.RemoveField(
            model_name='keeper',
            name='btc_wallet_address',
        ),
        migrations.RemoveField(
            model_name='keeper',
            name='btc_wallet_balance',
        ),
        migrations.RemoveField(
            model_name='keeper',
            name='eth_wallet_address',
        ),
        migrations.RemoveField(
            model_name='keeper',
            name='eth_wallet_balance',
        ),
        migrations.RemoveField(
            model_name='keeper',
            name='ton_wallet_address',
        ),
        migrations.RemoveField(
            model_name='keeper',
            name='ton_wallet_balance',
        ),
        migrations.RemoveField(
            model_name='profile',
            name='status',
        ),
        migrations.RemoveField(
            model_name='profile',
            name='tag',
        ),
        migrations.AlterField(
            model_name='profile',
            name='user',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL, verbose_name='Пользователь'),
        ),
        migrations.AlterField(
            model_name='transaction',
            name='currency',
            field=models.CharField(choices=[('btc', 'Bitcoin'), ('ltc', 'Litecoin'), ('doge', 'Dogecoin'), ('dash', 'Dash'), ('via', 'Viacoin'), ('grs', 'Groestlcoin'), ('dgb', 'DigiByte'), ('mona', 'Monacoin'), ('dcr', 'Decred'), ('eth', 'Ethereum'), ('etc', 'Ethereum Classic'), ('icx', 'ICON'), ('atom', 'Cosmos'), ('zec', 'Zcash'), ('firo', 'Firo'), ('xrp', 'XRP'), ('bch', 'Smart Bitcoin Cash'), ('xlm', 'Stellar'), ('btg', 'Bitcoin Gold'), ('xno', 'Nano'), ('rvn', 'Ravencoin'), ('poa', 'POA Network'), ('eos', 'EOS'), ('trx', 'Tron'), ('fio', 'FIO'), ('nim', 'Nimiq'), ('algo', 'Algorand'), ('iotx', 'IoTeX'), ('zil', 'Zilliqa'), ('luna', 'Terra'), ('dot', 'Polkadot'), ('near', 'NEAR'), ('aion', 'Aion'), ('ksm', 'Kusama'), ('ae', 'Aeternity'), ('kava', 'Kava'), ('fil', 'Filecoin'), ('blz', 'Bluzelle'), ('band', 'BandChain'), ('theta', 'Theta'), ('sol', 'Solana'), ('egld', 'Elrond'), ('bnb', 'Smart Chain'), ('vet', 'VeChain'), ('clo', 'Callisto'), ('neo', 'NEO'), ('tomo', 'TomoChain'), ('tt', 'Thunder Token'), ('one', 'Harmony'), ('rose', 'Oasis'), ('ont', 'Ontology'), ('xtz', 'Tezos'), ('ada', 'Cardano'), ('kin', 'Kin'), ('qtum', 'Qtum'), ('nas', 'Nebulas'), ('go', 'GoChain'), ('nuls', 'NULS'), ('flux', 'Zelcash'), ('wan', 'Wanchain'), ('waves', 'Waves'), ('matic', 'Polygon'), ('rune', 'THORChain'), ('oeth', 'Optimism'), ('areth', 'Arbitrum'), ('ht', 'ECO Chain'), ('avax', 'Avalanche C-Chain'), ('xdai', 'xDai'), ('ftm', 'Fantom'), ('cro', 'Cronos Chain'), ('celo', 'Celo'), ('ron', 'Ronin'), ('osmo', 'Osmosis'), ('xec', 'ECash'), ('ton', 'Toncoin')], max_length=10, verbose_name='Валюта'),
        ),
        migrations.DeleteModel(
            name='EmailVerification',
        ),
        migrations.DeleteModel(
            name='ResetPasswordVerification',
        ),
        migrations.DeleteModel(
            name='Wallet',
        ),
        migrations.AddField(
            model_name='trustwallet',
            name='owner',
            field=models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='insomnia_keeper_main.profile', verbose_name='Владелец'),
        ),
        migrations.AddField(
            model_name='independentwallet',
            name='owner',
            field=models.ForeignKey(on_delete=django.db.models.deletion.PROTECT, to='insomnia_keeper_main.profile', verbose_name='Владелец'),
        ),
        migrations.AddField(
            model_name='keeper',
            name='ton_wallet',
            field=models.ForeignKey(default=None, on_delete=django.db.models.deletion.PROTECT, related_name='keeper_ton_independent_wallet', to='insomnia_keeper_main.independentwallet', verbose_name='Toncoin Independent Wallet'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='keeper',
            name='trust_wallet',
            field=models.ForeignKey(default=None, on_delete=django.db.models.deletion.PROTECT, related_name='keeper_trust_wallet', to='insomnia_keeper_main.trustwallet', verbose_name='Trust Wallet'),
            preserve_default=False,
        ),
    ]
