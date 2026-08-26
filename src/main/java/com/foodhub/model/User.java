package com.foodhub.model;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String username;
    private String email;
    private String password;
    private String phone;
    private String address;
    private String role;
    private Timestamp createdDate;
    private Timestamp lastLoginDate;
    private String gender;
    private java.sql.Date dateOfBirth;

    public User() {}

    public User(int userId, String username, String password, String email, String address, String role, Timestamp createdDate, Timestamp lastLoginDate) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.address = address;
        this.role = role;
        this.createdDate = createdDate;
        this.lastLoginDate = lastLoginDate;
    }

    public User(int userId, String username, String password, String email, String address, String role, Timestamp createdDate, Timestamp lastLoginDate, String phone, String gender, java.sql.Date dateOfBirth) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
        this.address = address;
        this.role = role;
        this.createdDate = createdDate;
        this.lastLoginDate = lastLoginDate;
        this.phone = phone;
        this.gender = gender;
        this.dateOfBirth = dateOfBirth;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Timestamp getCreatedDate() { return createdDate; }
    public void setCreatedDate(Timestamp createdDate) { this.createdDate = createdDate; }

    public Timestamp getLastLoginDate() { return lastLoginDate; }
    public void setLastLoginDate(Timestamp lastLoginDate) { this.lastLoginDate = lastLoginDate; }
    
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    
    public java.sql.Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(java.sql.Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }
}
