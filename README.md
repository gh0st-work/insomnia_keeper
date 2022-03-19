# insomnia_keeper

Extremely easy crypto keeper with support of free market, transfers and payments.


## Info
**STAGE: DEVELOPMENT**

Backend TODO:
- [x] Project set up
- [x] Users
- [x] Exchange rates
- [x] Trust Wallet core 
- [ ] Crypto management
- [ ] Market
- [ ] Payments
- [ ] Fit frontend needs
- [ ] Rating?
- [ ] Card-to-card payments?

Frontend TODO:
- [ ] Auth screen
  - [ ] Agreement about "F*ck war, make peace, w33d, love & money"
- [ ] Intro screen
- [ ] Wallets and balances listing
- [ ] Transfer/payments page
- [ ] Market listing page
- [ ] Create market request page
- [ ] Market transfer page
- [ ] Rating?
- [ ] Card-to-card payments?

## Development
### Backend
- `python -m venv venv`
- `pip install -r requirements.txt`
- install [wallet core py](https://github.com/phuang/wallet-core-python) and run codegen/generator.py
- `python manage.py makemigrations`
- `python manage.py migrate`
- `python manage.py createsuperuser`
- `python manage.py runserver 0.0.0.0:8000`
- go to `http://localhost:8000/admin/`

### Frontend
In progress...

## Deploy
In progress...
