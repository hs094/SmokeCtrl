package io.person.api;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserRepository extends JpaRepository<User, String> {
    User findByLoginid(String loginid);
    
    @Query("SELECT u FROM User u WHERE u.loginid = :loginid AND u.pwd = :pwd")
    User findByLoginidAndPwd(@Param("loginid") String loginid, @Param("pwd") String pwd);

    @Query("SELECT u FROM User u WHERE u.email = :email AND u.pwd = :pwd")
    User findByEmailAndPwd(@Param("email") String email, @Param("pwd") String pwd);

    @Query("SELECT u FROM User u WHERE u.loginid = :loginid AND u.email = :email")
    User findByLoginidAndEmail(@Param("loginid") String loginid, @Param("email") String email);

    User findByEmailAndName(String email, String name);
}
