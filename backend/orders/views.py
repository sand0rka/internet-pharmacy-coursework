from django.core.exceptions import ValidationError
from django.shortcuts import get_object_or_404
from rest_framework import viewsets, status
from rest_framework.response import Response

from notifications.models import Pharmacy
from products.models import Product
from users.models import Client
from .builders import OrderBuilder
from .models import Order, OrderItem
from .serializers import OrderSerializer, OrderItemSerializer


class OrderViewSet(viewsets.ModelViewSet):
    queryset = Order.objects.all().order_by('-id')
    serializer_class = OrderSerializer
    filterset_fields = ['client']

    def create(self, request, *args, **kwargs):
        try:
            data = request.data
            client_id = data.get('client')
            delivery_type = data.get('delivery_type', 'pickup')
            pharmacy_id = data.get('pharmacy')
            address = data.get('delivery_address')
            items_data = data.get('items', [])

            builder = OrderBuilder()

            client = get_object_or_404(Client, pk=client_id)
            builder.set_client(client)

            pharmacy = None
            if pharmacy_id:
                pharmacy = Pharmacy.objects.get(pk=pharmacy_id)

            builder.set_delivery(delivery_type, pharmacy, address)

            for item in items_data:
                product_id = item.get('product')
                quantity = int(item.get('quantity', 1))
                product = get_object_or_404(Product, pk=product_id)
                builder.add_item(product, quantity)

            order = builder.build()
            serializer = self.get_serializer(order)
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        except ValidationError as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class OrderItemViewSet(viewsets.ModelViewSet):
    queryset = OrderItem.objects.all()
    serializer_class = OrderItemSerializer
