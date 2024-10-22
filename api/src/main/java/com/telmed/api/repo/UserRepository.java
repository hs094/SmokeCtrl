package com.telmed.api.repo;
import com.telmed.api.repo.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.query.Param;

public interface UserRepository extends JpaRepository<User, String> {
    User findUserByLoginid(String loginid);

    User findUserByLoginidAndPwd(@Param("loginid") String loginid, @Param("pwd") String password);

    User findByEmailAndPwd(@Param("email") String email, @Param("pwd") String pwd);
//
    User findByLoginidAndEmail(@Param("loginid") String loginid, @Param("email") String email);
//
    User findByEmailAndName(String email, String name);
}