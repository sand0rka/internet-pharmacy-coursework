from rest_framework import serializers
from .models import Client, ClientType, Role, Prescription

class RoleSerializer(serializers.ModelSerializer):
    class Meta:
        model = Role
        fields = '__all__'

class ClientTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = ClientType
        fields = '__all__'

class ClientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Client
        fields = '__all__'

class PrescriptionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Prescription
        fields = '__all__'