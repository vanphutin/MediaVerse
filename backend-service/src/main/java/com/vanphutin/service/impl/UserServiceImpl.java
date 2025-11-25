package com.vanphutin.service.impl;

import com.vanphutin.common.Role;
import com.vanphutin.common.UserStatus;
import com.vanphutin.controller.request.UserCreationRequest;
import com.vanphutin.controller.request.UserPasswordRequest;
import com.vanphutin.controller.request.UserUpdateRequest;
import com.vanphutin.controller.response.UserPageResponse;
import com.vanphutin.controller.response.UserResponse;
import com.vanphutin.exception.ResourceNotFoundException;
import com.vanphutin.model.UserEntity;
import com.vanphutin.repository.UserRepository;
import com.vanphutin.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
@Slf4j(topic = "USER-SERVICE")
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;


    @Override
    public UserPageResponse findAll(String keyword, String sort, int page, int size) {



        Sort.Order order =  new Sort.Order(Sort.Direction.ASC, "id");
        if(StringUtils.hasLength(sort)){
            Pattern  pattern = Pattern.compile("(\\w+?)(:)(.*)"); // tencoc:asc|desc
            Matcher matcher = pattern.matcher(sort);
            if(matcher.find()){
                String columnName = matcher.group(1);

                if(matcher.group(3).equalsIgnoreCase("asc")){
                    order = new Sort.Order(Sort.Direction.ASC,columnName);
                }else {
                    order= new Sort.Order(Sort.Direction.DESC,columnName);
                }
            }
        }


        // xu li truong hop FE muon trang bat dau voi page = 1
        int pageNo = 0;
        if(page > 0){
            pageNo = page - 1;
        }

        // paging
        Pageable pageable = PageRequest.of(pageNo, size, Sort.by(order));
        Page<UserEntity> entityPage = null;
        if(StringUtils.hasLength(keyword)){
            entityPage = userRepository.searchByKeyword(keyword, pageable);

        }else{
            entityPage = userRepository.findAll(pageable);
        }


        UserPageResponse userPageResponse = getUserPageResponse(page, size, entityPage);

        return userPageResponse;
    }



    @Override
    public UserResponse findById(Long id) {
        UserEntity userEntity = getUserEntity(id);

        return UserResponse.builder()
                .userId(id)
                .username(userEntity.getUsername())
                .email(userEntity.getEmail())
                .avatarUrl(userEntity.getAvatarUrl())
                .role(userEntity.getRole())
                .status((userEntity.getStatus()))
                .bio(userEntity.getBio())
                .location(userEntity.getLocation())
                .website(userEntity.getWebsite())
                .createdAt(userEntity.getCreateAt())
                .lastLogin(userEntity.getLastLogin())
                .build();

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
    @Transactional
    public void update(UserUpdateRequest req) {
        // get user by id
        UserEntity user = getUserEntity(req.getId());

        user.setUsername(req.getUsername());
        user.setEmail(req.getEmail());
        user.setBio(req.getBio());
        user.setLocation(req.getLocation());
        user.setWebsite(req.getWebsite());

        userRepository.save(user);
        // set data

        // save to db

    }

    @Override
    public void changePassword(UserPasswordRequest req) {
        log.info("Changing UserPasswordRequest",req);

        // get user by id
        UserEntity user = getUserEntity(req.getId());
        if(req.getPassword().equals(req.getConfirmPassword())) {
            user.setPassword(passwordEncoder.encode(req.getConfirmPassword()));
        }

        userRepository.save(user);
    }

    @Override
    public void delete(Long id) {
        log.info("delete UserRequest",id);

        //userRepository.deleteById(id);

        // get user by id
        UserEntity user = getUserEntity(id);
        user.setStatus(UserStatus.BANNED);
        userRepository.save(user);
    }

    /**
     * get user by id
     * @param id
     * @return
     */
    private UserEntity getUserEntity(Long id){
        return userRepository.findById(id).orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }

    /***
     * Convert userEntity to UserResponse
     * @param page
     * @param size
     * @param userEntities
     * @return
     */
    private static UserPageResponse getUserPageResponse(int page, int size, Page<UserEntity> userEntities) {
        List<UserResponse> userList = userEntities.stream().map(entity -> UserResponse.builder()
                .userId(entity.getId())
                .username(entity.getUsername())
                .email(entity.getEmail())
                .avatarUrl(entity.getAvatarUrl())
                .role(entity.getRole())
                .status((entity.getStatus()))
                .bio(entity.getBio())
                .location(entity.getLocation())
                .website(entity.getWebsite())
                .createdAt(entity.getCreateAt())
                .lastLogin(entity.getLastLogin())
                .build()

        ).toList();

        UserPageResponse userPageResponse = new UserPageResponse();
        userPageResponse.setPageNumber(page);
        userPageResponse.setPageSize(size);
        userPageResponse.setTotalElements(userEntities.getNumberOfElements());
        userPageResponse.setTotalPage(userEntities.getTotalPages());
        userPageResponse.setUsers(userList);
        return userPageResponse;
    }
}
