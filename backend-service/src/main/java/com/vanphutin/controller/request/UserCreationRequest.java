package com.vanphutin.controller.request;

import lombok.Data;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Data
public class UserCreationRequest implements Serializable {

    private String username;
    private String email;
    private String bio;
    private String location;
    private String website;

}
