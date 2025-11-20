from django.core.exceptions import ValidationError
from django.db import transaction

from .models import Order, OrderItem


class OrderBuilder:

    def __init__(self):
        self._client = None
        self._pharmacy = None
        self._delivery_type = 'pickup'
        self._items = []

    def set_client(self, client):
        self._client = client
        return self

    def set_delivery(self, delivery_type, pharmacy=None):
        self._delivery_type = delivery_type
        if delivery_type == 'pickup':
            self._pharmacy = pharmacy
        return self

    def add_item(self, product, quantity=1):
        if product.stock_quantity < quantity:
            raise ValidationError(f"Недостатньо товару {product.name} на складі!")

        self._items.append({
            'product': product,
            'quantity': quantity,
            'price': product.price
        })
        return self

    def build(self):
        if not self._client:
            raise ValidationError("Клієнт обов'язковий для замовлення!")

        if not self._items:
            raise ValidationError("Замовлення не може бути пустим!")

        with transaction.atomic():
            order = Order.objects.create(
                client=self._client,
                delivery_type=self._delivery_type,
                pharmacy=self._pharmacy,
                status='new',
                total_amount=0
            )

            total = 0
            for item in self._items:
                product = item['product']
                qty = item['quantity']
                price = item['price']

                OrderItem.objects.create(
                    order=order,
                    product=product,
                    quantity=qty,
                    price_per_unit=price
                )

                product.stock_quantity -= qty
                product.save()

                total += price * qty

            order.total_amount = total
            order.save()

            return order
