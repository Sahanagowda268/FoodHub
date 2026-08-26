<%@ page import="java.util.List, com.foodhub.DAOImpl.RestaurantDAOImpl, com.foodhub.DAOImpl.MenuDAOImpl, com.foodhub.model.Restaurant, com.foodhub.model.Menu" %>
<%
try {
    RestaurantDAOImpl rDao = new RestaurantDAOImpl();
    MenuDAOImpl mDao = new MenuDAOImpl();
    List<Restaurant> allR = rDao.getAllRestaurants();
    if (allR != null) {
        for(int i=0; i<allR.size(); i++) {
            Restaurant r = allR.get(i);
            out.print("\"" + r.getRestaurantId() + "\": {");
            out.print("name: \"" + r.getName() + "\", ");
            out.print("menus: [");
            List<Menu> menus = mDao.getMenusByRestaurant(r.getRestaurantId());
            if (menus != null) {
                for(int j=0; j<menus.size(); j++) {
                    Menu m = menus.get(j);
                    out.print("{ name: \"" + m.getItemName() + "\", price: " + m.getPrice() + " }");
                    if (j < menus.size() - 1) out.print(",");
                }
            }
            out.print("]");
            out.print("}");
            if (i < allR.size() - 1) out.print(",");
        }
    }
} catch(Exception e) {
    out.print("Error: " + e.getMessage());
}
%>
