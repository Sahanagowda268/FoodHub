package com.foodhub.DAO;

import com.foodhub.model.User;
import java.util.List;

public interface UserDAO {
    void addUser(User user);
    User getUser(int userId);
    User getUserByEmail(String email);
    void updateUser(User user);
    void deleteUser(int userId);
    List<User> getAllUsers();
}
