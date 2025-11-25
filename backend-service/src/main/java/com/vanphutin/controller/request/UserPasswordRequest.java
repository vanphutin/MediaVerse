package com.vanphutin.controller.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.io.Serializable;

@Data
public class UserPasswordRequest implements Serializable {

    @NotNull(message = "id must be not blank")
    @Min(value = 1, message = "userId must be equal or greater than 1")
    private Long id;

    @NotBlank(message = "password must be not blank")
    private String password;

    @NotBlank(message = "confirmPassword must be not blank")
    private String confirmPassword;
}
