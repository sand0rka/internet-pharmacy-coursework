from django.db import models


class Pharmacy(models.Model):
    address = models.CharField(max_length=255, verbose_name="Адреса")
    working_hours = models.CharField(max_length=100, verbose_name="Графік роботи")

    def __str__(self):
        return self.address


class Notification(models.Model):
    message = models.TextField(verbose_name="Повідомлення")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="Дата створення")
    is_read = models.BooleanField(default=False, verbose_name="Прочитано")

    client = models.ForeignKey('users.Client', on_delete=models.CASCADE, verbose_name="Клієнт")

    def __str__(self):
        return f"Сповіщення для {self.client}"