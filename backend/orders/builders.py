from decimal import Decimal

from django.core.exceptions import ValidationError
from django.db import transaction

from users.models import Prescription
from .models import Order, OrderItem


class OrderBuilder:
    def __init__(self):
        self._client = None
        self._pharmacy = None
        self._delivery_type = 'pickup'
        self._address = None
        self._items = []
        self._use_bonuses = False

    def set_client(self, client):
        self._client = client
        return self

    def set_delivery(self, delivery_type, pharmacy=None, address=None):
        self._delivery_type = delivery_type
        if delivery_type == 'pickup':
            self._pharmacy = pharmacy
        else:
            self._address = address
        return self

    def use_bonuses(self, use: bool):
        self._use_bonuses = use
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

        for item in self._items:
            product = item['product']
            if product.is_prescription:
                has_rx = Prescription.objects.filter(
                    client=self._client,
                    product=product
                ).exists()

                if not has_rx:
                    raise ValidationError(f"Товар '{product.name}' вимагає рецепту! Зверніться до лікаря.")

        with transaction.atomic():
            order = Order.objects.create(
                client=self._client,
                delivery_type=self._delivery_type,
                pharmacy=self._pharmacy,
                delivery_address=self._address,
                status='new',
                total_amount=0
            )

            total = Decimal('0.00')
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

            bonuses_to_use = Decimal('0.00')

            if self._use_bonuses and self._client.bonus_points > 0:
                available = self._client.bonus_points
                if available >= total:
                    bonuses_to_use = total
                    total = Decimal('0.00')
                else:
                    bonuses_to_use = available
                    total -= available

                self._client.bonus_points -= bonuses_to_use
                self._client.save()

            order.bonuses_used = bonuses_to_use
            order.total_amount = total
            order.save()

            if total > 0:
                client_type_name = self._client.client_type.name
                if client_type_name == 'Premium':
                    bonus_percent = Decimal('0.10')
                elif client_type_name == 'Social':
                    bonus_percent = Decimal('0.05')
                else:
                    bonus_percent = Decimal('0.01')

                bonuses_earned = total * bonus_percent
                self._client.bonus_points += bonuses_earned
                self._client.save()

            return order
