package com.vanphutin.controller;

import com.vanphutin.controller.request.UserCreationRequest;
import com.vanphutin.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class UserController {
    private final UserService userService; //  có 3 cách ["1:toan tu new' 2:RequiredArgsConstructor, 3:Autowirde]

    @PostMapping("/add")
    public ResponseEntity<Object> createUser(@RequestBody UserCreationRequest request){
        Map<String,Object> result = new LinkedHashMap<>();
        result.put("status",HttpStatus.CREATED.value());
        result.put("message","User created successfully");
        result.put("data",userService.save(request));


        return new ResponseEntity<>(result,HttpStatus.CREATED);
    }

}
