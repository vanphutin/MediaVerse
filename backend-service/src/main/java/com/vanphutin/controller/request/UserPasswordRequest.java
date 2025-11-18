package com.vanphutin.controller.request;

import lombok.Data;

import java.io.Serializable;

@Data
public class UserPasswordRequest implements Serializable {
    private Long id;
    private String password;
    private String confirmPassword;
}
