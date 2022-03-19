from django.contrib import admin

from .models import *


def register_models(models_list):
    for model, fields in models_list.items():
        model_fields = []
        search_model_fields = []

        for field in model._meta.fields:
            if field.name in fields:
                model_fields.append(field.name)
                if field.__class__ in [models.CharField, models.EmailField, models.TextField]:
                    search_model_fields.append(field.name)

        class Admin(admin.ModelAdmin):
            list_display = ['__str__', *model_fields]
            list_filter = model_fields
            search_fields = ['__str__', *search_model_fields]

        admin.site.register(model, Admin)


register_models({
    AdminSettings: [],
    Global: [],
    Profile: ['user', 'tag', 'access_status', 'status', 'created'],
    Keeper: ['owner', 'btc_wallet_address', 'eth_wallet_address', 'ton_wallet_address'],
    Transaction: ['currency', 'amount', 'from_keeper', 'to_keeper', 'to_address', 'created'],
    Error: ['pathname', 'os_name', 'browser_name', 'created'],
})
