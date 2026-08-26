package com.foodhub.DAO;

import com.foodhub.model.Favourite;
import java.util.List;

public interface FavouriteDAO {
    void addFavourite(int userId, int menuId);
    void removeFavourite(int userId, int menuId);
    List<Favourite> getFavouritesByUser(int userId);
    boolean isFavourite(int userId, int menuId);
}
