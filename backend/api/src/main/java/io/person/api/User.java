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

    public String getPassword() {
        return this.pwd;
    }
}
