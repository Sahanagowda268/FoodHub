package com.foodhub.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.foodhub.DAOImpl.OrderTableDAOImpl;
import com.foodhub.DAOImpl.RestaurantDAOImpl;
import com.foodhub.model.OrderTable;
import com.foodhub.model.Restaurant;
import com.foodhub.model.User;

@WebServlet("/orders")
public class OrderHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        
        OrderTableDAOImpl orderDAO = new OrderTableDAOImpl();
        List<OrderTable> orders = orderDAO.getOrdersByUser(user.getUserId());
        
        // Sort orders by date descending (newest first)
        orders.sort((o1, o2) -> o2.getOrderDate().compareTo(o1.getOrderDate()));

        // Fetch Restaurant names for display
        RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();
        Map<Integer, String> restaurantNames = new HashMap<>();
        
        for (OrderTable order : orders) {
            if (!restaurantNames.containsKey(order.getRestaurantId())) {
                Restaurant r = restaurantDAO.getRestaurant(order.getRestaurantId());
                if (r != null) {
                    restaurantNames.put(order.getRestaurantId(), r.getName());
                } else {
                    restaurantNames.put(order.getRestaurantId(), "Unknown Restaurant");
                }
            }
        }
        
        req.setAttribute("orders", orders);
        req.setAttribute("restaurantNames", restaurantNames);
        req.getRequestDispatcher("/orders.jsp").forward(req, resp);
    }
}
