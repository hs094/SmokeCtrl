# iMediXcare
### iMediXcare — A mobile-based telemedicine cum digital healthcare system.
iMediXcare is an open-source web-based system. It is developed for providing remote consultation to the patients. 

- #### Platform and environment details
    The system is built on the Java platform. The required technologies and software are following:
   
    ```sh
    - JDK 17
    - Flutter 9
    - MySQL 8.4.2
    - Spring Boot
    ```
    
- #### Steps to Run the Application
    First, go to directory `frontend/telemedic/` and open a terminal window here:
    ```sh
    flutter pub get
    flutter run
    ```
    Second, go to directory `backend/api/` and open a new terminal window here: (SpringBoot Backend is built for Maven Built Tool Automation).
    ```sh
    mvn clean install
    mvn spring-boot:run
    ```
     
