# Steps to Run the PostgreSQL Server in Docker Container
Check if the ``db`` folder has the ```Dockerfile``` with specified Configuration.
## Requirements
Have ```docker``` and ```docker-compose```, installed in your machine.
## Commands
1. **Build the Docker Image:** Run the following command to build the Docker image. Replace my_postgres_image with a name of your choice.
    ```
    docker build -t my_postgres_image .
    ```
2. **Run the Docker Container:** Use the following command to run a container from the image you just built. Replace your_password with a secure password of your choice.
    ```
    docker run --name my_postgres_container -p 5432:5432 -d my_postgres_image
    ```
    If you wish to pass the container parameters using a 
    `.env` file you can the use the below command.
    
    ```
    docker run --name my_postgres_container --env-file .env -p 5432:5432 -d my_postgres_image
    ```
3. **To access a running PostgreSQL container** using docker exec, you can use the following command. This command allows you to open a shell session inside the container and interact with the PostgreSQL database using the psql command-line tool.
    ```
    docker exec -it my_postgres_container psql -U postgres
    ```
