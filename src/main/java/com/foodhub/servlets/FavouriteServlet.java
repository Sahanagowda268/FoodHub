package com.foodhub.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.foodhub.DAOImpl.FavouriteDAOImpl;
import com.foodhub.DAOImpl.MenuDAOImpl;
import com.foodhub.model.Favourite;
import com.foodhub.model.Menu;
import com.foodhub.model.User;

@WebServlet("/favourite")
public class FavouriteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String menuIdStr = req.getParameter("menuId");
        String returnUrl = req.getHeader("referer");
        
        FavouriteDAOImpl favDAO = new FavouriteDAOImpl();
        
        if (action != null && menuIdStr != null) {
            try {
                int menuId = Integer.parseInt(menuIdStr);
                
                if (action.equals("add")) {
                    favDAO.addFavourite(user.getUserId(), menuId);
                } else if (action.equals("remove")) {
                    favDAO.removeFavourite(user.getUserId(), menuId);
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
            
            if (returnUrl != null) {
                resp.sendRedirect(returnUrl);
            } else {
                resp.sendRedirect(req.getContextPath() + "/restaurant");
            }
        } else {
            // View Favourites Logic
            List<Favourite> userFavs = favDAO.getFavouritesByUser(user.getUserId());
            List<Menu> favouriteMenus = new ArrayList<>();
            MenuDAOImpl menuDAO = new MenuDAOImpl();
            
            for (Favourite f : userFavs) {
                Menu m = menuDAO.getMenu(f.getMenuId());
                if (m != null) {
                    favouriteMenus.add(m);
                }
            }
            
            req.setAttribute("favouriteMenus", favouriteMenus);
            req.getRequestDispatcher("/favourites.jsp").forward(req, resp);
        }
    }
}
