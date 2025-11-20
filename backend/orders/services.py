from abc import ABC, abstractmethod
from decimal import Decimal

class IDiscountStrategy(ABC):
    @abstractmethod
    def calculate_discount(self, amount: Decimal) -> Decimal:
        pass


class NoDiscountStrategy(IDiscountStrategy):
    """Звичайний клієнт: знижка 0 грн"""
    def calculate_discount(self, amount: Decimal) -> Decimal:
        return Decimal('0.00')

class SocialDiscountStrategy(IDiscountStrategy):
    """Соціальний: знижка 5%"""
    def calculate_discount(self, amount: Decimal) -> Decimal:
        return amount * Decimal('0.05')

class PremiumDiscountStrategy(IDiscountStrategy):
    """Преміум: знижка 15%"""
    def calculate_discount(self, amount: Decimal) -> Decimal:
        return amount * Decimal('0.15')


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
    def calculate_final_price(amount: Decimal, client_type_name: str) -> Decimal:
        strategy = DiscountCalculator.get_strategy(client_type_name)
        discount = strategy.calculate_discount(amount)
        return amount - discount