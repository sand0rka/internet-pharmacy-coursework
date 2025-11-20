from django.contrib import admin
from .models import Notification, Pharmacy

@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = ('client', 'message', 'is_read', 'created_at')
    list_filter = ('is_read',)

@admin.register(Pharmacy)
class PharmacyAdmin(admin.ModelAdmin):
    list_display = ('address', 'working_hours')