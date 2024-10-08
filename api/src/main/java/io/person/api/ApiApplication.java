package io.person.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.CrossOrigin;

@SpringBootApplication
@CrossOrigin
public class ApiApplication {
	/**
	 * The main method serves as the entry point for the Spring Boot application.
	 * It launches the application by invoking the run method on [SpringApplication](https://spring.io/projects/spring-boot),
	 * passing in the ApiApplication class and command-line arguments.
	 *
	 * @param args Command-line arguments passed to the application.
	 */
	public static void main(String[] args) {
		SpringApplication.run(ApiApplication.class, args);
	}

}