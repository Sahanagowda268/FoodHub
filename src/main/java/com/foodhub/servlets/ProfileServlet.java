package com.foodhub.servlets;

import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.foodhub.DAO.UserDAO;
import com.foodhub.DAOImpl.UserDAOImpl;
import com.foodhub.model.User;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public ProfileServlet() {
        this.userDAO = new UserDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        
        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String address = request.getParameter("address");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        
        Date dob = null;
        if (dateOfBirthStr != null && !dateOfBirthStr.trim().isEmpty()) {
            try {
                dob = Date.valueOf(dateOfBirthStr);
            } catch (IllegalArgumentException e) {
                e.printStackTrace();
            }
        }
        
        loggedInUser.setUsername(username);
        loggedInUser.setPhone(phone);
        loggedInUser.setGender(gender);
        loggedInUser.setAddress(address);
        loggedInUser.setDateOfBirth(dob);
        
        userDAO.updateUserProfile(loggedInUser);
        
        // Update session
        session.setAttribute("loggedInUser", loggedInUser);
        
        request.setAttribute("msg", "Profile updated successfully!");
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
}
