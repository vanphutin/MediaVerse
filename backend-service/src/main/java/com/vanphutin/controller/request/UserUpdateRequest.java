package com.vanphutin.controller.request;

import lombok.Getter;
import lombok.ToString;

import java.io.Serializable;

@Getter
@ToString
public class UserUpdateRequest implements Serializable {

    private long id;
    private String username;
    private String email;
    private String bio;
    private String location;
    private String website;

}