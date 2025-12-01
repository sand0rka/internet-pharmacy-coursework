# Internet Pharmacy System

Coursework project for the "Software Documentation and Design Patterns" discipline.

## Project Description

This project is a web-based information system for an online pharmacy ("EcoPharmacy"). It allows users to browse medication catalogs, search for products, manage a shopping cart, place orders, and track their purchase history. The system includes a loyalty program and automated notifications.

The project consists of two main parts:
1.  **Backend:** A RESTful API built with Django.
2.  **Frontend:** A single-page web application built with Flutter.

## Technology Stack

### Backend
* **Language:** Python 3
* **Framework:** Django, Django REST Framework (DRF)
* **Database:** PostgreSQL
* **Tools:** django-filter, Faker, django-jazzmin

### Frontend
* **Framework:** Flutter (Web)
* **Architecture:** Clean Architecture (separation of Models, Services, Screens, and Widgets)

## Implemented Design Patterns (GoF)

The system architecture utilizes Object-Oriented Design principles and implements the following patterns:

1.  **Strategy Pattern**
    * **Purpose:** To handle flexible discount calculations.
    * **Implementation:** The logic calculates the final order price based on the client's tier (Standard, Social, Premium). Social clients receive specific discounts on social program products, while Premium clients receive a flat discount on the total.
    * **Location:** `backend/orders/services.py`

2.  **Builder Pattern**
    * **Purpose:** To encapsulate the complex construction of an Order object.
    * **Implementation:** The `OrderBuilder` class handles step-by-step order creation, including validation of stock availability, prescription requirements verification, bonus point deduction, and transactional saving.
    * **Location:** `backend/orders/builders.py`

3.  **Observer Pattern**
    * **Purpose:** To implement a reactive notification system.
    * **Implementation:** Utilizes Django Signals. When a product's stock quantity is updated from 0 to a positive number, the system automatically creates notifications for all subscribed clients.
    * **Location:** `backend/products/signals.py`

## Functional Requirements

* **Catalog:** Search by name, category, and manufacturer. Filtering by price range, availability, and prescription status.
* **Ordering:** Shopping cart management, delivery selection (Courier or Pickup), address input.
* **User Account:** Order history tracking, loyalty status view, bonus points balance.
* **Security:** Prescription validation for restricted medicines.
