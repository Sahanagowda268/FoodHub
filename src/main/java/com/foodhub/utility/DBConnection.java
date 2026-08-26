package com.foodhub.utility;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/tap_foods";
    private static final String USER = "root";
    private static final String PASSWORD = "Sahana@123";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    public static Connection getConnection() {

        Connection connection = null;

        try {

            Class.forName(DRIVER);

            connection = DriverManager.getConnection(URL, USER, PASSWORD);

            System.out.println("Database Connected Successfully");

        } catch (ClassNotFoundException | SQLException e) {

            e.printStackTrace();

        }

        return connection;
    }
}