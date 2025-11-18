package com.vanphutin.service.impl;

import com.vanphutin.common.Role;
import com.vanphutin.common.UserStatus;
import com.vanphutin.controller.request.UserCreationRequest;
import com.vanphutin.controller.request.UserPasswordRequest;
import com.vanphutin.controller.response.UserResponse;
import com.vanphutin.model.UserEntity;
import com.vanphutin.repository.UserRepository;
import com.vanphutin.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Slf4j(topic = "USER-SERVICE")
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;

    @Override
    public List<UserResponse> findAll() {
        return List.of();
    }

    @Override
    public UserResponse findById(Long id) {
        return null;
    }

    @Override
    public UserResponse findByUsername(String username) {
        return null;
    }

    @Override
    public UserResponse findByEmail(String email) {
        return null;
    }

    @Override
    @Transactional
    public long save(UserCreationRequest req) {
        log.info("save UserRequest");
        UserEntity user = new UserEntity();
        user.setUsername(req.getUsername());
        user.setEmail(req.getEmail());
        user.setBio(req.getBio());
        user.setLocation(req.getLocation());
        user.setWebsite(req.getWebsite());
        user.setRole(Role.NORMAL);
        user.setStatus(UserStatus.NORMAL);

        userRepository.save(user);
        return user.getId();
    }

    @Override
    public void update(UserCreationRequest req) {

    }

    @Override
    public void changePassword(UserPasswordRequest req) {

    }

    @Override
    public void delete(Long id) {

    }
}
