from django.db import models


class Order(models.Model):
    order_date = models.DateTimeField(auto_now_add=True, verbose_name="Дата замовлення")
    status = models.CharField(max_length=50, default='new', verbose_name="Статус")
    total_amount = models.DecimalField(max_digits=10, decimal_places=2, default=0.00, verbose_name="Сума")
    delivery_type = models.CharField(max_length=50, verbose_name="Тип доставки")
    delivery_address = models.CharField(max_length=255, blank=True, null=True, verbose_name="Адреса доставки")

    client = models.ForeignKey('users.Client', on_delete=models.CASCADE, verbose_name="Клієнт")
    pharmacy = models.ForeignKey('notifications.Pharmacy', on_delete=models.SET_NULL, null=True, blank=True,
                                 verbose_name="Аптека (для самовивозу)")

    def __str__(self):
        return f"Замовлення №{self.pk}"


class OrderItem(models.Model):
    quantity = models.IntegerField(default=1, verbose_name="Кількість")
    price_per_unit = models.DecimalField(max_digits=10, decimal_places=2, verbose_name="Ціна за одиницю")

    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items', verbose_name="Замовлення")
    product = models.ForeignKey('products.Product', on_delete=models.PROTECT, verbose_name="Товар")

    def __str__(self):
        return f"{self.quantity} x {self.product}"
