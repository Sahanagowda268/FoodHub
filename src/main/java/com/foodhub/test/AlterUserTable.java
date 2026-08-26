package com.foodhub.test;

import com.foodhub.utility.DBConnection;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;

public class AlterUserTable {
    public static void main(String[] args) {
        String addPhone = "ALTER TABLE `user` ADD COLUMN `phone` VARCHAR(20)";
        String addGender = "ALTER TABLE `user` ADD COLUMN `gender` VARCHAR(15)";
        String addDob = "ALTER TABLE `user` ADD COLUMN `date_of_birth` DATE";

        try (Connection connection = DBConnection.getConnection();
             Statement stmt = connection.createStatement()) {
            
            try {
                stmt.execute(addPhone);
                System.out.println("Added phone column.");
            } catch (SQLException e) {
                System.out.println("phone column might already exist: " + e.getMessage());
            }

            try {
                stmt.execute(addGender);
                System.out.println("Added gender column.");
            } catch (SQLException e) {
                System.out.println("gender column might already exist: " + e.getMessage());
            }

            try {
                stmt.execute(addDob);
                System.out.println("Added date_of_birth column.");
            } catch (SQLException e) {
                System.out.println("date_of_birth column might already exist: " + e.getMessage());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
