import json
from typing import *

from django.contrib.auth.password_validation import validate_password
from django.db.models import Q
from rest_framework import serializers

from insomnia_keeper_main.models import *


class GlobalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Global
        fields = '__all__'


class UserSerializer(serializers.ModelSerializer):
    username = serializers.CharField()
    password = serializers.CharField(min_length=8, write_only=True)

    class Meta:
        model = User
        fields = (
            'username',
        )


class ProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer()


    class Meta:
        model = Profile
        fields = ['id', 'access_status']


class SignUpSerializer(serializers.Serializer):
    username = serializers.EmailField()
    password = serializers.CharField()

    def validate_password(self, value: str) -> str:
        """Validate whether the password meets all django validator requirements."""
        validate_password(value)
        return value


def serialize_errors(serializer_errors):
    errors = []
    for field_name, field_errors in serializer_errors.items():
        for field_error in field_errors:
            errors.append(field_error)
    return errors


class ErrorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Error
        fields = '__all__'


