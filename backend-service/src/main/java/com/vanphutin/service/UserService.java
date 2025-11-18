package com.vanphutin.service;

import com.vanphutin.controller.request.UserCreationRequest;
import com.vanphutin.controller.request.UserPasswordRequest;
import com.vanphutin.controller.response.UserResponse;
import org.springframework.stereotype.Service;

import java.util.List;

public interface UserService {
    List<UserResponse> findAll();

    UserResponse  findById(Long id);

    UserResponse  findByUsername(String username);

    UserResponse  findByEmail(String email);

    long save(UserCreationRequest req);

    void update(UserCreationRequest req);

    void changePassword(UserPasswordRequest req);

    void delete(Long id);
}
