package com.vanphutin.controller.response;

import com.vanphutin.common.Role;
import com.vanphutin.common.UserStatus;
import lombok.*;

import java.util.Date;

@Data
@Getter
@Setter
@Builder
@AllArgsConstructor
public class UserResponse {

    private Long userId;
    private String username;
    private String email;

    private String avatarUrl;
    private Role role;
    private UserStatus status;

    private String bio;
    private String location;
    private String website;

    private Date createdAt;
    private Date lastLogin;
}
