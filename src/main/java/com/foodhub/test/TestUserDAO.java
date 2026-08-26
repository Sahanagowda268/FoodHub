package com.foodhub.test;
import com.foodhub.DAOImpl.UserDAOImpl;
import com.foodhub.model.User;
import java.sql.Timestamp;
import java.time.Instant;
public class TestUserDAO {
    public static void main(String[] args) {
        UserDAOImpl dao = new UserDAOImpl();
        System.out.println("Registering user...");
        User u = new User(0, "Test", "pass123", "test@test.com", "Addr", "Customer", Timestamp.from(Instant.now()), Timestamp.from(Instant.now()));
        dao.addUser(u);
        System.out.println("Fetching user...");
        User fetched = dao.getUserByEmail("test@test.com");
        if (fetched == null) {
            System.out.println("USER NOT FOUND! ADD USER FAILED?");
        } else {
            System.out.println("User found! Password matches: " + fetched.getPassword().equals("pass123"));
            System.out.println("Email: " + fetched.getEmail());
            System.out.println("Password: " + fetched.getPassword());
        }
    }
}
