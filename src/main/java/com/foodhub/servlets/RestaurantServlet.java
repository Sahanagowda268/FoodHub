package com.foodhub.servlets;

import java.io.IOException;
import java.util.List;

import com.foodhub.DAOImpl.RestaurantDAOImpl;
import com.foodhub.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/restaurant")
public class RestaurantServlet extends HttpServlet{
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		RestaurantDAOImpl restaurantDAOImpl= new RestaurantDAOImpl();
		List<Restaurant> allrestaurants= restaurantDAOImpl.getAllRestaurants();
		
		for (Restaurant restaurant : allrestaurants) {
			System.out.println(restaurant);
		}
		
		req.setAttribute("allrestaurants", allrestaurants);
		
		RequestDispatcher rd= req.getRequestDispatcher("Restaurant.jsp");
		rd.forward(req, resp);
	}

}
