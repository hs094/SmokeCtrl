package com.telmed.api.auth.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Getter
@Entity
@Data
@Table(name = "app_user")  // Change the table name to avoid conflict
public class User {
    @Setter
    @NotNull
    @Id
    private String userid;

    @NotNull
    private String loginid;

    @NotNull
    private String pwd;

    @NotNull
    private String name;

    @NotNull
    private String email;

    @NotNull
    private Integer age;

    @NotNull
    private String sex;

    @NotNull
    private String phone;

    @NotNull
    private String designation;

    @NotNull
    private String qualification;

    @NotNull
    private String userType;

    @NotNull
    private Boolean active;

}
