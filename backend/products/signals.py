from django.db.models.signals import pre_save, post_save
from django.dispatch import receiver

from notifications.models import Notification
from .models import Product


@receiver(pre_save, sender=Product)
def check_stock_change(sender, instance, **kwargs):
    if instance.pk:
        try:
            old_instance = Product.objects.get(pk=instance.pk)
            instance._old_stock = old_instance.stock_quantity
        except Product.DoesNotExist:
            instance._old_stock = 0
    else:
        instance._old_stock = 0


@receiver(post_save, sender=Product)
def notify_clients_on_stock(sender, instance, created, **kwargs):
    old_stock = getattr(instance, '_old_stock', 0)
    new_stock = instance.stock_quantity

    if old_stock == 0 and new_stock > 0:
        message = f"Товар '{instance.name}' знову в наявності! Ціна: {instance.price} грн."

        clients = instance.subscribers.all()
        notifications = []
        for client in clients:
            notifications.append(
                Notification(client=client, message=message)
            )

        Notification.objects.bulk_create(notifications)
        print(f"--- OBSERVER: Створено {len(notifications)} сповіщень про товар {instance.name} ---")
