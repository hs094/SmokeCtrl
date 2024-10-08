# urls.py
from django.urls import path
from .views import GenerateResponseView

urlpatterns = [
    path('chat/', GenerateResponseView.as_view(), name='generate_response'),
]
