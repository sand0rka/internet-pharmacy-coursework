from django.contrib import admin
from .models import Client, Role, ClientType, Prescription

@admin.register(Client)
class ClientAdmin(admin.ModelAdmin):
    list_display = ('name', 'email', 'phone', 'client_type')
    search_fields = ('name', 'email')

admin.site.register(Role)
admin.site.register(ClientType)
admin.site.register(Prescription)