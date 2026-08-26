package com.foodhub.servlets;

import java.util.List;
import java.io.IOException;

import com.foodhub.DAOImpl.MenuDAOImpl;
import com.foodhub.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet{
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int restaurantId= Integer.parseInt(req.getParameter("restaurantId"));
		MenuDAOImpl menuDAOImpl = new MenuDAOImpl();
		
		
		
		List<Menu> allMenusByRestaurant = menuDAOImpl.getMenusByRestaurant(restaurantId);
		req.setAttribute("menuList", allMenusByRestaurant);
		
		java.util.Set<Integer> favSet = new java.util.HashSet<>();
		com.foodhub.model.User user = (com.foodhub.model.User) req.getSession().getAttribute("loggedInUser");
		if (user != null) {
		    com.foodhub.DAOImpl.FavouriteDAOImpl favDAO = new com.foodhub.DAOImpl.FavouriteDAOImpl();
		    java.util.List<com.foodhub.model.Favourite> favs = favDAO.getFavouritesByUser(user.getUserId());
		    for (com.foodhub.model.Favourite f : favs) {
		        favSet.add(f.getMenuId());
		    }
		}
		req.setAttribute("favSet", favSet);
		
		jakarta.servlet.RequestDispatcher rd = req.getRequestDispatcher("Menu.jsp");
		rd.forward(req, resp);
	}

}
