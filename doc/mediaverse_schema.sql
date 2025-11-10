-- StreamHub Database Schema
-- Version 2.0 - Complete Database Design
-- Author: AI Assistant
-- Description: Complete database schema for music/video streaming platform with social features

-- Create database
CREATE DATABASE IF NOT EXISTS streamhub;
USE streamhub;

-- ============================
--   STREAMHUB MYSQL SCHEMA
--   Compatible with HeidiSQL
-- ============================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS streamhub
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE streamhub;


-- =========================================
-- 1. USERS
-- =========================================
CREATE TABLE users (
    user_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    avatar_url VARCHAR(255) DEFAULT 'https://bla.edu.vn/wp-content/uploads/2025/09/avatar-fb.jpg',
    role ENUM('NORMAL','VIP','ADMIN') DEFAULT 'NORMAL',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ACTIVE','BANNED') DEFAULT 'ACTIVE',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    bio TEXT,
    location VARCHAR(100),
    website VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- =========================================
-- 2. VIDEOS
-- =========================================
CREATE TABLE videos (
    video_id VARCHAR(20) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    artist VARCHAR(100) NOT NULL,
    duration INT NOT NULL,
    thumbnail VARCHAR(255) NOT NULL,
    is_vip_only BOOLEAN DEFAULT FALSE,
    view_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    description TEXT,
    tags JSON,
    source ENUM('YOUTUBE','DEEZER','LOCAL') DEFAULT 'YOUTUBE',
    quality_available JSON,
    INDEX idx_artist (artist),
    INDEX idx_created_at (created_at),
    INDEX idx_view_count (view_count)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- =========================================
-- 3. ROOMS
-- =========================================
CREATE TABLE rooms (
    room_id VARCHAR(50) PRIMARY KEY,
    video_id VARCHAR(20) NOT NULL,
    host_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    max_participants INT DEFAULT 50,
    room_name VARCHAR(255) NOT NULL,
    description TEXT,
    is_private BOOLEAN DEFAULT FALSE,
    password VARCHAR(255),
    current_position FLOAT DEFAULT 0,
    is_playing BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (video_id) REFERENCES videos(video_id) ON DELETE CASCADE,
    FOREIGN KEY (host_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_host_id (host_id),
    INDEX idx_is_active (is_active),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- =========================================
-- 4. ROOM PARTICIPANTS
-- =========================================
CREATE TABLE room_participants (
    room_id VARCHAR(50) NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    role ENUM('HOST','GUEST') DEFAULT 'GUEST',
    is_online BOOLEAN DEFAULT TRUE,
    last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    permissions JSON,
    PRIMARY KEY (room_id, user_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_online (is_online)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- =========================================
-- 5. MESSAGES
-- =========================================
CREATE TABLE messages (
    message_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_id VARCHAR(50) NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    content TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_edited BOOLEAN DEFAULT FALSE,
    edited_at TIMESTAMP NULL,
    reply_to_message_id BIGINT UNSIGNED NULL,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reply_to_message_id) REFERENCES messages(message_id) ON DELETE SET NULL,
    INDEX idx_room_id (room_id),
    INDEX idx_user_id (user_id),
    INDEX idx_sent_at (sent_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- =========================================
-- 6. REACTIONS
-- =========================================
CREATE TABLE reactions (
    reaction_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_id VARCHAR(50) NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    emoji VARCHAR(10) NOT NULL,
    timestamp_in_video FLOAT DEFAULT 0,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_room_id (room_id),
    INDEX idx_user_id (user_id),
    INDEX idx_sent_at (sent_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- =========================================
-- 7. WATCH HISTORY
-- =========================================
CREATE TABLE watch_history (
    history_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    video_id VARCHAR(20) NOT NULL,
    watched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    progress_seconds INT DEFAULT 0,
    is_finished BOOLEAN DEFAULT FALSE,
    watch_count INT DEFAULT 1,
    last_position FLOAT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (video_id) REFERENCES videos(video_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_video (user_id, video_id),
    INDEX idx_user_id (user_id),
    INDEX idx_watched_at (watched_at),
    INDEX idx_is_finished (is_finished)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- =========================================
-- 8. PLAYLISTS
-- =========================================
CREATE TABLE playlists (
    playlist_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    description TEXT,
    is_public BOOLEAN DEFAULT FALSE,
    thumbnail VARCHAR(255),
    view_count INT DEFAULT 0,
    tags JSON,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_public (is_public),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- =========================================
-- 9. PLAYLIST ITEMS
-- =========================================
CREATE TABLE playlist_items (
    playlist_id BIGINT UNSIGNED NOT NULL,
    video_id VARCHAR(20) NOT NULL,
    position INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    added_by BIGINT UNSIGNED,
    PRIMARY KEY (playlist_id, video_id),
    FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id) ON DELETE CASCADE,
    FOREIGN KEY (video_id) REFERENCES videos(video_id) ON DELETE CASCADE,
    FOREIGN KEY (added_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_position (position),
    INDEX idx_added_at (added_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- =========================================
-- 10. VIP ACCESS
-- =========================================
CREATE TABLE vip_access (
    vip_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    package ENUM('MONTHLY','YEARLY','LIFETIME') NOT NULL,
    payment_id VARCHAR(255),
    payment_status ENUM('PENDING','COMPLETED','FAILED','CANCELLED') DEFAULT 'PENDING',
    amount DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'USD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_end_date (end_date),
    INDEX idx_payment_status (payment_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- =========================================
-- 11. COMMENTS
-- =========================================
CREATE TABLE comments (
    comment_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    video_id VARCHAR(20) NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_edited BOOLEAN DEFAULT FALSE,
    is_deleted BOOLEAN DEFAULT FALSE,
    like_count INT DEFAULT 0,
    reply_to_comment_id BIGINT UNSIGNED NULL,
    FOREIGN KEY (video_id) REFERENCES videos(video_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reply_to_comment_id) REFERENCES comments(comment_id) ON DELETE SET NULL,
    INDEX idx_video_id (video_id),
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- =========================================
-- 12. GENRES
-- =========================================
CREATE TABLE genres (
    genre_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    thumbnail VARCHAR(255),
    color_hex VARCHAR(7) DEFAULT '#e11d48',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_name (name),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



-- =========================================
-- 13. VIDEO GENRES JUNCTION
-- =========================================
CREATE TABLE video_genres (
    video_id VARCHAR(20) NOT NULL,
    genre_id BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (video_id, genre_id),
    FOREIGN KEY (video_id) REFERENCES videos(video_id) ON DELETE CASCADE,
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id) ON DELETE CASCADE,
    INDEX idx_genre_id (genre_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




-- =========================================
-- 14. REPORTS
-- =========================================
CREATE TABLE reports (
    report_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    reported_by BIGINT UNSIGNED NOT NULL,
    target_type ENUM('USER','VIDEO','COMMENT') NOT NULL,
    target_id VARCHAR(50) NOT NULL,
    reason TEXT NOT NULL,
    status ENUM('PENDING','REVIEWED','RESOLVED') DEFAULT 'PENDING',
    reviewed_by BIGINT UNSIGNED,
    reviewed_at TIMESTAMP NULL,
    resolution TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reported_by) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_reported_by (reported_by),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




-- =========================================
-- 15. NOTIFICATIONS
-- =========================================
CREATE TABLE notifications (
    notification_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    type ENUM('INVITE','COMMENT','VIP','SYSTEM','FRIEND_REQUEST','LIKE') NOT NULL,
    content TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    related_id VARCHAR(50),
    related_type VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




-- =========================================
-- 16. LIKES
-- =========================================
CREATE TABLE likes (
    like_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    video_id VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (video_id) REFERENCES videos(video_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_video_like (user_id, video_id),
    INDEX idx_user_id (user_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




-- =========================================
-- 17. ADVERTISEMENTS
-- =========================================
CREATE TABLE advertisements (
    ad_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    media_url VARCHAR(255) NOT NULL,
    target_url VARCHAR(255),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    priority INT DEFAULT 0,
    click_count INT DEFAULT 0,
    impression_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_is_active (is_active),
    INDEX idx_start_date (start_date),
    INDEX idx_end_date (end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




-- =========================================
-- 18. ADMIN LOGS
-- =========================================
CREATE TABLE admin_logs (
    log_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    admin_id BIGINT UNSIGNED NOT NULL,
    action VARCHAR(255) NOT NULL,
    target VARCHAR(100),
    target_id VARCHAR(50),
    details TEXT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_admin_id (admin_id),
    INDEX idx_created_at (created_at),
    INDEX idx_action (action)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




-- =========================================
-- 19. USER SESSIONS
-- =========================================
CREATE TABLE user_sessions (
    session_id VARCHAR(255) PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at),
    INDEX idx_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;




-- =========================================
-- 20. USER SETTINGS
-- =========================================
CREATE TABLE user_settings (
    user_id BIGINT UNSIGNED PRIMARY KEY,
    theme ENUM('light','dark') DEFAULT 'dark',
    language VARCHAR(10) DEFAULT 'vi',
    auto_play BOOLEAN DEFAULT TRUE,
    quality_preference VARCHAR(10) DEFAULT '720p',
    subtitles_enabled BOOLEAN DEFAULT FALSE,
    notifications_enabled BOOLEAN DEFAULT TRUE,
    privacy_profile ENUM('public','friends','private') DEFAULT 'friends',
    data_collection BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



SET FOREIGN_KEY_CHECKS = 1;


-- Insert sample data

-- Sample users
INSERT INTO users (username, email, password, role, avatar_url) VALUES
('nguyenvana', 'nguyenvana@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'VIP', 'https://kimi-web-img.moonshot.cn/img/wallpapers.com/c23297985670466ca60cd05bd9122fbfff6797b1.jpg'),
('alexsmith', 'alex@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'NORMAL', 'https://kimi-web-img.moonshot.cn/img/marketplace.canva.cn/0de2366b53c0b344fd7a756cefcf4ddd621b65da.png'),
('sarahjones', 'sarah@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'NORMAL', 'https://kimi-web-img.moonshot.cn/img/cdn.pixabay.com/d09c626102733b1e4329dbb8767a2fca419c2ae5.png'),
('mikewilson', 'mike@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'ADMIN', 'https://kimi-web-img.moonshot.cn/img/thumbnails.yayimages.com/26b6049405790bf3252a1cf50dc97f4e00633905.jpg');

-- Sample videos
INSERT INTO videos (video_id, title, artist, duration, thumbnail, is_vip_only, view_count) VALUES
('summer2024', 'Summer Vibes Mix 2024', 'Various Artists', 225, 'https://kimi-web-img.moonshot.cn/img/c4.wallpaperflare.com/ac3930860e5d9c2137ed125e9259dd40078a57ed.jpg', FALSE, 2100000),
('nightdrive', 'Night Drive', 'Electronic Dreams', 252, 'https://kimi-web-img.moonshot.cn/img/i.ytimg.com/34a0bc80f81554595d26ba57f022f36d6525849a.jpg', FALSE, 1800000),
('acousticsess', 'Acoustic Sessions', 'Indie Folk', 323, 'https://kimi-web-img.moonshot.cn/img/www.groundguitar.com/bd1e3783e91472867698c3172c6b04bd9db15d69.jpg', TRUE, 956000),
('pophits2024', 'Pop Hits 2024', 'Top Charts', 198, 'https://kimi-web-img.moonshot.cn/img/c4.wallpaperflare.com/c9784a76416ad67bf73b95bef58c4bd2e6c9c31c.jpg', FALSE, 3200000);

-- Sample genres
INSERT INTO genres (name, description, thumbnail, color_hex) VALUES
('Pop', 'Popular music genre', 'https://example.com/genres/pop.jpg', '#e11d48'),
('Rock', 'Rock music and its subgenres', 'https://example.com/genres/rock.jpg', '#3b82f6'),
('Electronic', 'Electronic and EDM music', 'https://example.com/genres/electronic.jpg', '#10b981'),
('Hip Hop', 'Hip hop and rap music', 'https://example.com/genres/hiphop.jpg', '#f59e0b'),
('Jazz', 'Jazz and blues music', 'https://example.com/genres/jazz.jpg', '#8b5cf6'),
('Classical', 'Classical and orchestral music', 'https://example.com/genres/classical.jpg', '#6b7280');

-- Link videos to genres
INSERT INTO video_genres (video_id, genre_id) VALUES
('summer2024', 1), -- Pop
('nightdrive', 3), -- Electronic
('acousticsess', 1), -- Pop
('pophits2024', 1); -- Pop

-- Sample playlists
INSERT INTO playlists (user_id, name, description, is_public) VALUES
(1, 'Nhạc Pop yêu thích', 'Những bài hát pop hay nhất', TRUE),
(1, 'Chill Evening', 'Nhạc thư giãn buổi tối', FALSE),
(2, 'EDM Party', 'Nhạc EDM sôi động', TRUE),
(3, 'Acoustic Collection', 'Nhạc acoustic nhẹ nhàng', TRUE);

-- Sample playlist items
INSERT INTO playlist_items (playlist_id, video_id, position, added_by) VALUES
(1, 'summer2024', 1, 1),
(1, 'pophits2024', 2, 1),
(2, 'nightdrive', 1, 1),
(3, 'summer2024', 1, 2),
(4, 'acousticsess', 1, 3);

-- Sample watch history
INSERT INTO watch_history (user_id, video_id, progress_seconds, is_finished, watch_count) VALUES
(1, 'summer2024', 225, TRUE, 5),
(1, 'nightdrive', 189, FALSE, 3),
(2, 'summer2024', 225, TRUE, 2),
(3, 'acousticsess', 290, FALSE, 1);

-- Sample likes
INSERT INTO likes (user_id, video_id) VALUES
(1, 'summer2024'),
(1, 'nightdrive'),
(2, 'summer2024'),
(3, 'acousticsess'),
(4, 'pophits2024');

-- Sample comments
INSERT INTO comments (video_id, user_id, content, like_count) VALUES
('summer2024', 2, 'Bài này hay quá! 🎵', 5),
('summer2024', 3, 'Perfect for summer vibes! ☀️', 3),
('nightdrive', 4, 'Love this mix! 🔥', 8);

-- Sample VIP access
INSERT INTO vip_access (user_id, start_date, end_date, package, payment_status, amount) VALUES
(1, '2024-01-01', '2024-12-31', 'YEARLY', 'COMPLETED', 99.99),
(2, '2024-06-01', '2024-07-01', 'MONTHLY', 'COMPLETED', 9.99);

-- Sample user settings
INSERT INTO user_settings (user_id, theme, language, auto_play, quality_preference) VALUES
(1, 'dark', 'vi', TRUE, '1080p'),
(2, 'dark', 'en', TRUE, '720p'),
(3, 'light', 'vi', FALSE, '720p'),
(4, 'dark', 'en', TRUE, '4K');

-- Create views for common queries
CREATE VIEW user_stats AS
SELECT 
    u.user_id,
    u.username,
    u.role,
    COUNT(DISTINCT wh.video_id) as videos_watched,
    SUM(wh.watch_count) as total_views,
    SUM(CASE WHEN wh.is_finished THEN 1 ELSE 0 END) as videos_finished,
    COUNT(DISTINCT p.playlist_id) as playlists_created,
    COUNT(DISTINCT l.video_id) as videos_liked
FROM users u
LEFT JOIN watch_history wh ON u.user_id = wh.user_id
LEFT JOIN playlists p ON u.user_id = p.user_id
LEFT JOIN likes l ON u.user_id = l.user_id
GROUP BY u.user_id;

CREATE VIEW video_stats AS
SELECT 
    v.video_id,
    v.title,
    v.artist,
    v.view_count,
    COUNT(DISTINCT wh.user_id) as unique_viewers,
    COUNT(DISTINCT l.user_id) as likes_count,
    COUNT(DISTINCT c.comment_id) as comments_count,
    AVG(CASE WHEN wh.is_finished THEN 1 ELSE 0 END) * 100 as completion_rate
FROM videos v
LEFT JOIN watch_history wh ON v.video_id = wh.video_id
LEFT JOIN likes l ON v.video_id = l.video_id
LEFT JOIN comments c ON v.video_id = c.video_id
GROUP BY v.video_id;

-- Create stored procedures
DELIMITER //

CREATE PROCEDURE create_room(
    IN p_host_id BIGINT UNSIGNED,
    IN p_video_id VARCHAR(20),
    IN p_room_name VARCHAR(255),
    IN p_description TEXT,
    IN p_is_private BOOLEAN,
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE room_id VARCHAR(50);
    SET room_id = CONCAT('room_', UNIX_TIMESTAMP());
    
    INSERT INTO rooms (room_id, video_id, host_id, room_name, description, is_private, password)
    VALUES (room_id, p_video_id, p_host_id, p_room_name, p_description, p_is_private, p_password);
    
    INSERT INTO room_participants (room_id, user_id, role)
    VALUES (room_id, p_host_id, 'HOST');
    
    SELECT room_id;
END//

CREATE PROCEDURE join_room(
    IN p_room_id VARCHAR(50),
    IN p_user_id BIGINT UNSIGNED
)
BEGIN
    DECLARE participant_count INT;
    DECLARE max_participants INT;
    
    SELECT COUNT(*), r.max_participants 
    INTO participant_count, max_participants
    FROM room_participants rp
    JOIN rooms r ON rp.room_id = r.room_id
    WHERE rp.room_id = p_room_id AND rp.is_online = TRUE;
    
    IF participant_count < max_participants THEN
        INSERT INTO room_participants (room_id, user_id)
        VALUES (p_room_id, p_user_id)
        ON DUPLICATE KEY UPDATE is_online = TRUE, last_seen = CURRENT_TIMESTAMP;
        
        SELECT 'SUCCESS' as status, 'Joined room successfully' as message;
    ELSE
        SELECT 'ERROR' as status, 'Room is full' as message;
    END IF;
END//

CREATE PROCEDURE update_watch_progress(
    IN p_user_id BIGINT UNSIGNED,
    IN p_video_id VARCHAR(20),
    IN p_progress_seconds INT,
    IN p_is_finished BOOLEAN
)
BEGIN
    INSERT INTO watch_history (user_id, video_id, progress_seconds, is_finished)
    VALUES (p_user_id, p_video_id, p_progress_seconds, p_is_finished)
    ON DUPLICATE KEY UPDATE 
        progress_seconds = p_progress_seconds,
        is_finished = p_is_finished,
        watch_count = watch_count + 1,
        watched_at = CURRENT_TIMESTAMP;
END//

DELIMITER ;

-- Create triggers
DELIMITER //

CREATE TRIGGER update_video_view_count
AFTER INSERT ON watch_history
FOR EACH ROW
BEGIN
    UPDATE videos 
    SET view_count = view_count + 1 
    WHERE video_id = NEW.video_id;
END//

CREATE TRIGGER update_comment_count
AFTER INSERT ON comments
FOR EACH ROW
BEGIN
    IF NEW.is_deleted = FALSE THEN
        UPDATE videos 
        SET view_count = view_count + 1 
        WHERE video_id = NEW.video_id;
    END IF;
END//

CREATE TRIGGER update_like_count
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE videos 
    SET view_count = view_count + 1 
    WHERE video_id = NEW.video_id;
END//

CREATE TRIGGER check_vip_status
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    IF NEW.role = 'VIP' THEN
        IF NOT EXISTS (SELECT 1 FROM vip_access WHERE user_id = NEW.user_id AND end_date > CURDATE()) THEN
            SET NEW.role = 'NORMAL';
        END IF;
    END IF;
END//

DELIMITER ;

-- Create indexes for better performance
CREATE INDEX idx_video_is_vip ON videos(is_vip_only);
CREATE INDEX idx_room_video_id ON rooms(video_id);
CREATE INDEX idx_message_content ON messages(content(255));
CREATE INDEX idx_comment_content ON comments(content(255));
CREATE INDEX users_username_idx ON users(username);
CREATE INDEX users_email_idx ON users(email);

-- Set foreign key checks back
SET FOREIGN_KEY_CHECKS = 1;

-- Grant permissions (adjust according to your setup)
-- GRANT ALL PRIVILEGES ON streamhub.* TO 'streamhub_user'@'localhost' IDENTIFIED BY 'your_password';
-- FLUSH PRIVILEGES;

-- Display success message
SELECT 'StreamHub Database Schema created successfully!' as message;
SELECT 'Version: 2.0' as version;
SELECT 'Tables created: 20' as tables_count;
SELECT 'Views created: 2' as views_count;
SELECT 'Stored procedures created: 3' as procedures_count;
SELECT 'Triggers created: 4' as triggers_count;