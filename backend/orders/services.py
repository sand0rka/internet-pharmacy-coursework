from abc import ABC, abstractmethod
from decimal import Decimal


class IDiscountStrategy(ABC):
    @abstractmethod
    def calculate_discount(self, items) -> Decimal:
        pass


class NoDiscountStrategy(IDiscountStrategy):
    def calculate_discount(self, items) -> Decimal:
        return Decimal('0.00')


class SocialDiscountStrategy(IDiscountStrategy):
    def calculate_discount(self, items) -> Decimal:
        discount = Decimal('0.00')
        for item in items:
            if hasattr(item, 'product'):
                product = item.product
                price = item.price_per_unit
                qty = item.quantity
            else:
                product = item['product']
                price = item['price']
                qty = item['quantity']

            if product.is_social_program:
                discount += (price * qty) * Decimal('0.20')

        return discount


class PremiumDiscountStrategy(IDiscountStrategy):
    def calculate_discount(self, items) -> Decimal:
        total = Decimal('0.00')
        for item in items:
            if hasattr(item, 'product'):
                total += item.price_per_unit * item.quantity
            else:
                total += item['price'] * item['quantity']

        return total * Decimal('0.15')


class DiscountCalculator:
    @staticmethod
    def get_strategy(client_type_name: str) -> IDiscountStrategy:
        if client_type_name == 'Social':
            return SocialDiscountStrategy()
        elif client_type_name == 'Premium':
            return PremiumDiscountStrategy()
        else:
            return NoDiscountStrategy()

    @staticmethod
    def calculate_final_price(items, client_type_name: str) -> Decimal:
        strategy = DiscountCalculator.get_strategy(client_type_name)

        total = Decimal('0.00')
        for item in items:
            if hasattr(item, 'product'):
                total += item.price_per_unit * item.quantity
            else:
                total += item['price'] * item['quantity']

        discount = strategy.calculate_discount(items)
        return total - discount
