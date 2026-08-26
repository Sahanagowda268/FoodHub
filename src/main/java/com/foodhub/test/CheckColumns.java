package com.foodhub.test;
import com.foodhub.utility.DBConnection;
import java.sql.*;
public class CheckColumns {
    public static void main(String[] args) {
        try (Connection c = DBConnection.getConnection();
             Statement s = c.createStatement();
             ResultSet rs = s.executeQuery("SELECT * FROM user LIMIT 1")) {
            ResultSetMetaData rsmd = rs.getMetaData();
            int count = rsmd.getColumnCount();
            System.out.println("Columns in 'user' table:");
            for (int i = 1; i <= count; i++) {
                System.out.println(rsmd.getColumnName(i));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
