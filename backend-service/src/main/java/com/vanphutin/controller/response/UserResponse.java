package com.vanphutin.controller.response;

import lombok.Data;
import java.util.Date;

@Data
public class UserResponse {

    private Long userId;
    private String username;
    private String email;

    private String avatarUrl;
    private String role;
    private String status;

    private String bio;
    private String location;
    private String website;

    private Date createdAt;
    private Date lastLogin;
}
