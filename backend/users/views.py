from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.response import Response

from .models import Client, ClientType, Role, Prescription
from .serializers import ClientSerializer, ClientTypeSerializer, RoleSerializer, PrescriptionSerializer


class ClientViewSet(viewsets.ModelViewSet):
    queryset = Client.objects.all()
    serializer_class = ClientSerializer

    @action(detail=False, methods=['post'])
    def login(self, request):
        email = request.data.get('email')
        password = request.data.get('password')

        if not email or not password:
            return Response({'error': 'Email і пароль обов\'язкові'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            client = Client.objects.get(email=email, password_hash=password)
            serializer = self.get_serializer(client)
            return Response(serializer.data)
        except Client.DoesNotExist:
            return Response({'error': 'Невірний email або пароль'}, status=status.HTTP_401_UNAUTHORIZED)

    @action(detail=False, methods=['post'])
    def register(self, request):
        name = request.data.get('name')
        email = request.data.get('email')
        phone = request.data.get('phone')
        password = request.data.get('password')

        if not all([name, email, phone, password]):
            return Response({'error': 'Всі поля обов\'язкові'}, status=status.HTTP_400_BAD_REQUEST)

        if Client.objects.filter(email=email).exists():
            return Response({'error': 'Такий email вже зареєстрований'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            default_type = ClientType.objects.first()

            client = Client.objects.create(
                name=name,
                email=email,
                phone=phone,
                password_hash=password,
                client_type=default_type
            )

            client_role = Role.objects.filter(name='ROLE_CLIENT').first()
            if client_role:
                client.roles.add(client_role)

            serializer = self.get_serializer(client)
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)


class ClientTypeViewSet(viewsets.ModelViewSet):
    queryset = ClientType.objects.all()
    serializer_class = ClientTypeSerializer


class RoleViewSet(viewsets.ModelViewSet):
    queryset = Role.objects.all()
    serializer_class = RoleSerializer


class PrescriptionViewSet(viewsets.ModelViewSet):
    queryset = Prescription.objects.all()
    serializer_class = PrescriptionSerializer
    filterset_fields = ['client']
