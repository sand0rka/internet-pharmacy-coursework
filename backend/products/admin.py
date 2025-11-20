from django.contrib import admin
from .models import Category, Manufacturer, Product

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('name',)

@admin.register(Manufacturer)
class ManufacturerAdmin(admin.ModelAdmin):
    list_display = ('name', 'country')

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'price', 'stock_quantity', 'category', 'is_prescription')
    list_filter = ('category', 'manufacturer', 'is_prescription')
    search_fields = ('name',)