from rest_framework import viewsets

from .models import Notification, Pharmacy
from .serializers import NotificationSerializer, PharmacySerializer


class NotificationViewSet(viewsets.ModelViewSet):
    queryset = Notification.objects.all().order_by('-created_at')
    serializer_class = NotificationSerializer
    filterset_fields = ['client', 'is_read']


class PharmacyViewSet(viewsets.ModelViewSet):
    queryset = Pharmacy.objects.all()
    serializer_class = PharmacySerializer
