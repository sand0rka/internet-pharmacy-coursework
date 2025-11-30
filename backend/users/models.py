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
    bonus_points = models.DecimalField(max_digits=10, decimal_places=2, default=0.00, verbose_name="Бонусні бали")
    client_type = models.ForeignKey(ClientType, on_delete=models.SET_NULL, null=True, verbose_name="Тип клієнта")
    roles = models.ManyToManyField(Role, verbose_name="Ролі")

    def __str__(self):
        return self.name


class Prescription(models.Model):
    issue_date = models.DateField(verbose_name="Дата видачі")
    product = models.ForeignKey('products.Product', on_delete=models.CASCADE, verbose_name="Ліки", null=True)
    client = models.ForeignKey(Client, on_delete=models.CASCADE, related_name='prescriptions', verbose_name="Клієнт")

    def __str__(self):
        product_name = self.product.name if self.product else "Невідомі ліки"
        return f"Рецепт на {product_name} для {self.client.name}"
