package io.person.api;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.validation.constraints.NotNull;

import lombok.Data;

@Entity
@Data
public class User {

    @Id
    private String userid;

    @NotNull
    private String loginid;

    @NotNull
    private String pwd;

    @NotNull
    private String name;

    @NotNull
    private Integer age;

    @NotNull
    private String sex;

    @NotNull
    private String phone;

    @NotNull
    private String email;

    @NotNull
    private String designation;

    @NotNull
    private String qualification;

    @NotNull
    private String user_type;

    @NotNull
    private Boolean active;

    public void setUserid(String userid) {
        this.userid = userid;
    }

    public String getEmail() {
        return this.email;
    }

    public String getPwd() {
        return this.pwd;
    }

    public String getLoginid() {
        return this.loginid;
    }

    public void print() {
        System.out.println(userid);

        System.out.println(loginid);

        System.out.println(pwd);

        System.out.println(name);

        System.out.println(age);

        System.out.println(sex);

        System.out.println(phone);

        System.out.println(email);

        System.out.println(designation);

        System.out.println(qualification);

        System.out.println(user_type);

        System.out.println(active);
    }
}
