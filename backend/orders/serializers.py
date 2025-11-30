from rest_framework import serializers

from products.serializers import ProductSerializer
from .models import Order, OrderItem
from .services import DiscountCalculator


class OrderItemSerializer(serializers.ModelSerializer):
    product_details = ProductSerializer(source='product', read_only=True)

    class Meta:
        model = OrderItem
        fields = '__all__'


class OrderSerializer(serializers.ModelSerializer):
    items = OrderItemSerializer(many=True, read_only=True)

    final_price_with_discount = serializers.SerializerMethodField()

    class Meta:
        model = Order
        fields = '__all__'

    def get_final_price_with_discount(self, obj):
        items = obj.items.all()

        client_type_name = "Standard"
        if obj.client and obj.client.client_type:
            client_type_name = obj.client.client_type.name

        return DiscountCalculator.calculate_final_price(items, client_type_name)
        client_type_name = "Standard"
        if obj.client and obj.client.client_type:
            client_type_name = obj.client.client_type.name

        return DiscountCalculator.calculate_final_price(total, client_type_name)
