from django.urls import path
from . import views

urlpatterns = [
    # Define a URL pattern for the chat endpoint
    path('chat/', views.generate_response, name='generate_response'),
]
