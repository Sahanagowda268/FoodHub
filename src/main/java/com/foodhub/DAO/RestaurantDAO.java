package com.foodhub.DAO;

import com.foodhub.model.Restaurant;
import java.util.List;

public interface RestaurantDAO {
    void addRestaurant(Restaurant restaurant);
    Restaurant getRestaurant(int restaurantId);
    void updateRestaurant(Restaurant restaurant);
    void deleteRestaurant(int restaurantId);
    List<Restaurant> getAllRestaurants();
}
