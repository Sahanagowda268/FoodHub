package com.foodhub.test;
import com.foodhub.utility.DBConnection;
import java.sql.*;
public class TestDB {
    public static void main(String[] args) throws Exception {
        try (Connection c = DBConnection.getConnection();
             Statement s = c.createStatement();
             ResultSet rs = s.executeQuery("SELECT * FROM user")) {
             while(rs.next()) {
                 System.out.println("ID=" + rs.getInt("user_id") + ", email=" + rs.getString("email") + ", pass=" + rs.getString("password"));
             }
        }
    }
}
