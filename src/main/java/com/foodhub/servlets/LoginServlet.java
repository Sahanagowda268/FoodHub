package com.foodhub.servlets;

import java.io.IOException;

import com.foodhub.DAOImpl.UserDAOImpl;
import com.foodhub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        
        UserDAOImpl userDAO = new UserDAOImpl();
        User user = userDAO.getUserByEmail(email);
        
        if (user != null && user.getPassword().equals(password)) {
            HttpSession session = req.getSession();
            session.setAttribute("loggedInUser", user);
            
            String redirectUrl = req.getParameter("redirect");
            if (redirectUrl != null && !redirectUrl.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/" + redirectUrl);
            } else {
                resp.sendRedirect(req.getContextPath() + "/");
            }
        } else {
            req.setAttribute("error", "Invalid email or password");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}
