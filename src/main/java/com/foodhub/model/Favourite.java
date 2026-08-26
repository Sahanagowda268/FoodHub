package com.foodhub.model;

public class Favourite {
    private int favouriteId;
    private int userId;
    private int menuId;

    public Favourite() {}

    public Favourite(int favouriteId, int userId, int menuId) {
        this.favouriteId = favouriteId;
        this.userId = userId;
        this.menuId = menuId;
    }

    public int getFavouriteId() { return favouriteId; }
    public void setFavouriteId(int favouriteId) { this.favouriteId = favouriteId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getMenuId() { return menuId; }
    public void setMenuId(int menuId) { this.menuId = menuId; }
}
