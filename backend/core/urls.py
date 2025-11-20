from django.contrib import admin
from django.urls import path, include
from rest_framework.routers import DefaultRouter


admin.site.site_header = "Адміністрування Аптеки"
admin.site.site_title = "Аптека Адмін"
admin.site.index_title = "Ласкаво просимо в систему управління"

urlpatterns = [
    path('admin/', admin.site.urls),
]

# Імпортуємо всі наші Views (Контролери)
from products.views import CategoryViewSet, ManufacturerViewSet, ProductViewSet
from users.views import ClientViewSet, ClientTypeViewSet, RoleViewSet, PrescriptionViewSet
from orders.views import OrderViewSet, OrderItemViewSet
from notifications.views import NotificationViewSet, PharmacyViewSet

router = DefaultRouter()

router.register(r'categories', CategoryViewSet)
router.register(r'manufacturers', ManufacturerViewSet)
router.register(r'products', ProductViewSet)

router.register(r'clients', ClientViewSet)
router.register(r'client-types', ClientTypeViewSet)
router.register(r'roles', RoleViewSet)
router.register(r'prescriptions', PrescriptionViewSet)

router.register(r'orders', OrderViewSet)
router.register(r'order-items', OrderItemViewSet)

router.register(r'notifications', NotificationViewSet)
router.register(r'pharmacies', PharmacyViewSet)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include(router.urls)),
]