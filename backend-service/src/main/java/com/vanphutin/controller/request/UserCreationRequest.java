package com.vanphutin.controller.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Data
public class UserCreationRequest implements Serializable {

    @NotBlank(message = "username must be not blank")
    private String username;

    @Email(message = "Email invalid")
    private String email;
    private String bio;
    private String location;
    private String website;

}
