package com.foodhub.servlets;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

import com.foodhub.DAOImpl.MenuDAOImpl;
import com.foodhub.model.CartItem;
import com.foodhub.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if(action == null) {
            req.getRequestDispatcher("cart.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new LinkedHashMap<>();
        }

        if ("add".equals(action)) {
            int menuId = Integer.parseInt(req.getParameter("menuId"));
            if (cart.containsKey(menuId)) {
                CartItem item = cart.get(menuId);
                item.setQuantity(item.getQuantity() + 1);
            } else {
                MenuDAOImpl menuDAO = new MenuDAOImpl();
                Menu menu = menuDAO.getMenu(menuId);
                if(menu != null) {
                    CartItem newItem = new CartItem(menu.getMenuId(), menu.getRestaurantId(), menu.getItemName(), menu.getPrice(), 1);
                    cart.put(menuId, newItem);
                }
            }
        } else if ("remove".equals(action)) {
            int menuId = Integer.parseInt(req.getParameter("menuId"));
            cart.remove(menuId);
        }

        session.setAttribute("cart", cart);
        resp.sendRedirect(req.getContextPath() + "/cart.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        
        String action = req.getParameter("action");
        Map<Integer, CartItem> cart = (Map<Integer, CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new java.util.LinkedHashMap<>();
        }
        
        if (action != null) {
            int menuId = Integer.parseInt(req.getParameter("menuId"));
            
            if ("add".equals(action)) {
                int quantity = 1;
                String qtyStr = req.getParameter("quantity");
                if (qtyStr != null) {
                    quantity = Integer.parseInt(qtyStr);
                }
                
                if (cart.containsKey(menuId)) {
                    CartItem item = cart.get(menuId);
                    item.setQuantity(item.getQuantity() + quantity);
                } else {
                    MenuDAOImpl menuDAO = new MenuDAOImpl();
                    Menu menu = menuDAO.getMenu(menuId);
                    if(menu != null) {
                        CartItem newItem = new CartItem(menu.getMenuId(), menu.getRestaurantId(), menu.getItemName(), menu.getPrice(), quantity);
                        cart.put(menuId, newItem);
                    }
                }
            } else if ("update".equals(action)) {
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                if (quantity > 0) {
                    if (cart.containsKey(menuId)) {
                        cart.get(menuId).setQuantity(quantity);
                    }
                } else {
                    cart.remove(menuId);
                }
            } else if ("increment".equals(action)) {
                if (cart.containsKey(menuId)) {
                    CartItem item = cart.get(menuId);
                    item.setQuantity(item.getQuantity() + 1);
                }
            } else if ("decrement".equals(action)) {
                if (cart.containsKey(menuId)) {
                    CartItem item = cart.get(menuId);
                    if (item.getQuantity() > 1) {
                        item.setQuantity(item.getQuantity() - 1);
                    }
                }
            } else if ("remove".equals(action)) {
                cart.remove(menuId);
            }
        }
        
        session.setAttribute("cart", cart);
        resp.sendRedirect(req.getContextPath() + "/cart.jsp");
    }
}
