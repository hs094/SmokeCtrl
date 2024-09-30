# Commands
1. conda create -n bot python=3.9
2. conda activate bot
3. pip install django llama-cpp-python 
4. Run server on 8888:-> python manage.py runserver 8888

Note: Check in Postman using This:-> 
```
 curl -X POST http://localhost:8888/api/chat/ \
     -d "message=what is the meaning of life?"
```
 
# From DockerFile
1. docker build -t llama-django-server .
2. docker run -p 8000:8000 llama-django-server

## Summary
- Django allows you to create a robust web framework for building APIs.
- Docker helps containerize the Django project, making it portable and easy to run across different environments.
- LangChain and llama-cpp-python integrate well to provide language generation functionality, making this setup a powerful local server for LLaMA models.