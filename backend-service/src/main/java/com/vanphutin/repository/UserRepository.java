package com.vanphutin.repository;

import com.vanphutin.model.UserEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserRepository extends JpaRepository<UserEntity,Long> {

    @Query("""
       SELECT u FROM UserEntity u
       WHERE u.status = 'ACTIVE' AND (
           LOWER(u.username) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
           LOWER(u.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
           LOWER(u.website) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
           LOWER(u.bio) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
           LOWER(u.location) LIKE LOWER(CONCAT('%', :keyword, '%'))
       )
       """)
    Page<UserEntity> searchByKeyword(String keyword, Pageable  pageable);

}
