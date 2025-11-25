package com.vanphutin.controller.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.ToString;

import java.io.Serializable;

@Getter
@ToString
public class UserUpdateRequest implements Serializable {

    @NotNull(message = "id must be not blank")
    @Min(value = 1, message = "userId must be equal or greater than 1")
    private long id;

    @NotBlank(message = "username must be not blank")
    private String username;

    @Email(message = "Email invalid")
    private String email;

    private String bio;
    private String location;
    private String website;

}