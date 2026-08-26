package com.foodhub.DAO;

import com.foodhub.model.Menu;
import java.util.List;

public interface MenuDAO {
    void addMenu(Menu menu);
    Menu getMenu(int menuId);
    void updateMenu(Menu menu);
    void deleteMenu(int menuId);
    List<Menu> getAllMenus();
    List<Menu> getMenusByRestaurant(int restaurantId);
}
