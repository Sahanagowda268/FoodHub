package com.foodhub.servlets;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;

import com.foodhub.DAOImpl.UserDAOImpl;
import com.foodhub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String address = req.getParameter("address");
        
        User user = new User(
            0,
            username,
            password,
            email,
            address,
            "Customer",
            Timestamp.from(Instant.now()),
            Timestamp.from(Instant.now())
        );
        
        UserDAOImpl userDAO = new UserDAOImpl();
        userDAO.addUser(user);
        
        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }
}
