package io.person.api;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.Data;

@Entity
@Data
public class User {
    @Id
    @GeneratedValue
    Integer id;

    String email;
    String password;
    String loginid;
    String name;
    Integer age;
    String sex;
    String phone;
    String desgn;
    String qual;
    String usertype;
    Boolean active;


}