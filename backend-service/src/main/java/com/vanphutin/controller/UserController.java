package com.vanphutin.controller;

import com.vanphutin.controller.request.UserCreationRequest;
import com.vanphutin.controller.request.UserPasswordRequest;
import com.vanphutin.controller.request.UserUpdateRequest;
import com.vanphutin.controller.response.UserPageResponse;
import com.vanphutin.controller.response.UserResponse;
import com.vanphutin.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
@Slf4j(topic = "USER-CONTROLLER")
public class UserController {
    private final UserService userService; //  có 3 cách ["1:toan tu new' 2:RequiredArgsConstructor, 3:Autowirde]

    @Operation(summary = "Create User", description = "API add new user")
    @PostMapping("/add")
    public ResponseEntity<Object> createUser(@RequestBody UserCreationRequest request){
        Map<String,Object> result = new LinkedHashMap<>();
        result.put("status",HttpStatus.CREATED.value());
        result.put("message","User created successfully");
        result.put("data",userService.save(request));


        return new ResponseEntity<>(result,HttpStatus.CREATED);
    }

    @Operation(summary = "Update User", description = "API upd  user")
    @PutMapping("/upd")
    public Map<String, Object> updateUser(@RequestBody UserUpdateRequest request){
        log.info("Updating user: {}", request);

        userService.update(request);

        Map<String,Object> result = new LinkedHashMap<>();
        result.put("status",HttpStatus.ACCEPTED.value());
        result.put("message","User Updated successfully");
        result.put("data", "");
        return result;
    }

    @Operation(summary = "Change password User", description = "API change password user")
    @PatchMapping("/change-pwd")
    public Map<String, Object> changePassword(@RequestBody UserPasswordRequest request){
        log.info("Changing user: {}", request);

        userService.changePassword(request);

        Map<String,Object> result = new LinkedHashMap<>();
        result.put("status",HttpStatus.NO_CONTENT.value());
        result.put("message","Change password successfully");
        result.put("data", "");
        return result;
    }

    @Operation(summary = "Detele User", description = "API delete user")
    @DeleteMapping("/del/{userId}")
    public Map<String, Object> deleteUser(@PathVariable("userId") Long userId){
        log.info("Deleting user: {}", userId);

        userService.delete(userId);
        Map<String,Object> result = new LinkedHashMap<>();
        result.put("status",HttpStatus.NO_CONTENT.value());
        result.put("message","User deleted successfully");
        result.put("data", "");
        return result;
    }

    @Operation(summary = "Get user detail ", description = "API get user detail")
    @GetMapping("{userId}")
    public Map<String, Object> getUserDetails(@PathVariable("userId") Long userId){
        log.info("Getting user detail: {}", userId);
        Map<String,Object> result = new LinkedHashMap<>();
        result.put("status",HttpStatus.ACCEPTED.value());
        result.put("message","User detail successfully");
        result.put("data",userService.findById(userId));
        return result;
    }

    @Operation(summary = "Get user list ", description = "API get user list")
    @GetMapping("/list")
    public  Map<String, Object>  getUserList(@RequestParam(required = false) String keyword,
                                        @RequestParam(required = false) String sort,
                                        @RequestParam(defaultValue = "0") int page,
                                        @RequestParam(defaultValue = "20") int size) {
        log.info("Getting user list: {}", keyword);

        UserPageResponse users = userService.findAll(keyword, sort, page, size);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("status", HttpStatus.OK.value());
        result.put("message", "Users list successfully");
        result.put("data", users);

        return result;
    }

}
