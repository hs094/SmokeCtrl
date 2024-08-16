package io.person.api;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
public interface UserRepository extends JpaRepository<User, String> {
    @Query("SELECT u FROM User u WHERE u.email = :email AND u.pwd = :pwd AND u.loginid = :loginid AND u.name = :name AND u.age = :age AND u.sex = :sex AND u.phone = :phone AND u.designation = :designation AND u.qualification = :qualification AND u.user_type = :user_type AND u.active = :active")
    User findByAllAttributes(
            @Param("email") String email,
            @Param("pwd") String pwd,
            @Param("loginid") String loginid,
            @Param("name") String name,
            @Param("age") Integer age,
            @Param("sex") String sex,
            @Param("phone") String phone,
            @Param("designation") String designation,
            @Param("qualification") String qualification,
            @Param("user_type") String user_type,
            @Param("active") Boolean active);

    @Query("SELECT u FROM User u WHERE u.loginid = :loginid")
    User findByLoginId(@Param("loginid") String loginid);
    User findByEmailAndPwd(String email, String pwd);
}
