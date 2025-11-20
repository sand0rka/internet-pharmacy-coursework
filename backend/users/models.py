from django.db import models


class Role(models.Model):
    name = models.CharField(max_length=50, verbose_name="Назва ролі")

    def __str__(self):
        return self.name


class ClientType(models.Model):
    name = models.CharField(max_length=50, verbose_name="Тип (статус)")
    discount_percent = models.DecimalField(max_digits=5, decimal_places=2, verbose_name="Знижка %")

    def __str__(self):
        return self.name


class Client(models.Model):
    email = models.EmailField(unique=True, verbose_name="E-mail")
    password_hash = models.CharField(max_length=255, verbose_name="Хеш пароля")
    name = models.CharField(max_length=255, verbose_name="ПІБ")
    phone = models.CharField(max_length=20, verbose_name="Телефон")

    client_type = models.ForeignKey(ClientType, on_delete=models.SET_NULL, null=True, verbose_name="Тип клієнта")
    roles = models.ManyToManyField(Role, verbose_name="Ролі")

    def __str__(self):
        return self.name


class Prescription(models.Model):
    issue_date = models.DateField(verbose_name="Дата видачі")
    file_path = models.CharField(max_length=500, verbose_name="Шлях до файлу")  # Спрощено для початку

    client = models.ForeignKey(Client, on_delete=models.CASCADE, related_name='prescriptions', verbose_name="Клієнт")

    def __str__(self):
        return f"Рецепт від {self.issue_date}"