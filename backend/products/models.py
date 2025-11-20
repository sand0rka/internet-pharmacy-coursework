from django.db import models


class Category(models.Model):
    name = models.CharField(max_length=255, verbose_name="Назва категорії")

    def __str__(self):
        return self.name


class Manufacturer(models.Model):
    name = models.CharField(max_length=255, verbose_name="Назва виробника")
    country = models.CharField(max_length=255, verbose_name="Країна")

    def __str__(self):
        return self.name


class Product(models.Model):
    name = models.CharField(max_length=255, verbose_name="Назва товару")
    description = models.TextField(verbose_name="Опис")
    price = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Ціна")
    stock_quantity = models.IntegerField(default=0, verbose_name="Кількість на складі")
    is_prescription = models.BooleanField(default=False, verbose_name="За рецептом")

    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='products', verbose_name="Категорія")
    manufacturer = models.ForeignKey(Manufacturer, on_delete=models.CASCADE, related_name='products',
                                     verbose_name="Виробник")
    subscribers = models.ManyToManyField('users.Client', related_name='subscribed_products', blank=True,
                                         verbose_name="Підписані клієнти")

    def __str__(self):
        return self.name
