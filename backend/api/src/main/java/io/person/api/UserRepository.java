package io.person.api;

import org.springframework.data.jpa.repository.JpaRepository;

//public interface UserRepository extends JpaRepository<User,Integer> {
//	User findByAllAttributes(String email, String password, String loginid, String name, Integer age, String sex, String phone, String desgn, String qual, String usertype, Boolean active); 
////    User findByEmailAndPassword(String email,String password);
//}

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserRepository extends JpaRepository<User, Integer> {
    
    @Query("SELECT u FROM User u WHERE u.email = :email AND u.password = :password AND u.loginid = :loginid AND u.name = :name AND u.age = :age AND u.sex = :sex AND u.phone = :phone AND u.desgn = :desgn AND u.qual = :qual AND u.usertype = :usertype AND u.active = :active")
    User findByAllAttributes(
        @Param("email") String email, 
        @Param("password") String password, 
        @Param("loginid") String loginid, 
        @Param("name") String name, 
        @Param("age") Integer age, 
        @Param("sex") String sex, 
        @Param("phone") String phone, 
        @Param("desgn") String desgn, 
        @Param("qual") String qual, 
        @Param("usertype") String usertype, 
        @Param("active") Boolean active
    );
    User findByEmailAndPassword(String email, String password);
}
