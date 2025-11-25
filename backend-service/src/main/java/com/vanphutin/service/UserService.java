package com.vanphutin.service;

import com.vanphutin.controller.request.UserCreationRequest;
import com.vanphutin.controller.request.UserPasswordRequest;
import com.vanphutin.controller.request.UserUpdateRequest;
import com.vanphutin.controller.response.UserPageResponse;
import com.vanphutin.controller.response.UserResponse;
import org.springframework.stereotype.Service;

import java.util.List;

public interface UserService {
    UserPageResponse findAll(String keyword, String sort, int page, int size);

    UserResponse  findById(Long id);

    UserResponse  findByUsername(String username);

    UserResponse  findByEmail(String email);

    long save(UserCreationRequest req);

    void update(UserUpdateRequest req);

    void changePassword(UserPasswordRequest req);

    void delete(Long id);
}
