<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.foodhub.model.Restaurant" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FoodHub | Restaurants</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
<style>
body { font-family: 'Outfit', sans-serif; }
/* ---------- Header ---------- */
.page-header {
    background: linear-gradient(135deg, var(--primary), var(--secondary));
    color: white;
    text-align: center;
    padding: 80px 20px 100px;
}
.page-header h1 {
    font-size: 42px;
    margin-bottom: 15px;
    font-weight: 800;
    color: white;
}
.page-header p {
    font-size: 18px;
    opacity: 0.9;
    color: #e0d5e1;
    max-width: 1000px;
    margin: 0 auto;
}

/* ---------- Search ---------- */
.search-box {
    width: 90%;
    max-width: 1200px;
    margin: -35px auto 50px auto;
    position: relative;
    z-index: 10;
}
.search-box input {
    width: 100%;
    padding: 20px 30px;
    border: 1px solid #eee;
    border-radius: 50px;
    font-size: 16px;
    outline: none;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
    font-family: inherit;
    transition: 0.3s;
}
.search-box input:focus {
    border-color: var(--primary);
    box-shadow: var(--shadow);
}

/* ---------- Restaurant Grid ---------- */
.restaurant-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 30px;
    padding-bottom: 60px;
    max-width: 1400px;
    margin: 0 auto;
    padding-left: 5%;
    padding-right: 5%;
}

.restaurant-card {
    background: white;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 10px 20px rgba(0,0,0,0.05);
    transition: transform 0.3s, box-shadow 0.3s;
    border: 1px solid #eee;
}
.restaurant-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 15px 30px rgba(0,0,0,0.1);
}
.restaurant-card img {
    width: 100%;
    height: 220px;
    object-fit: cover;
}
.card-content {
    padding: 25px;
}
.card-content h2 {
    font-size: 22px;
    margin-bottom: 12px;
    font-weight: 700;
    color: var(--primary);
}
.info-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
    font-size: 14px;
}
.rating {
    background: var(--accent);
    color: var(--primary);
    padding: 6px 12px;
    border-radius: 20px;
    font-weight: 700;
}
.time {
    color: var(--primary);
    font-weight: 700;
    background: var(--accent);
    padding: 6px 12px;
    border-radius: 20px;
}
.cuisine, .address {
    color: var(--text);
    font-size: 14px;
    margin-bottom: 8px;
    line-height: 1.5;
}
.address { margin-bottom: 20px; }

</style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <header class="page-header">
        <h1>All Restaurants</h1>
        <p>Browse our complete list of partner restaurants and discover exactly what you're craving today.</p>
    </header>

    <div class="search-box">
        <input type="text" placeholder="🔍 Search for a restaurant or cuisine...">
    </div>
    
    <div class="restaurant-grid">
    <%
        List<Restaurant> allrestaurants = (List<Restaurant>)request.getAttribute("allrestaurants");
        if(allrestaurants != null && !allrestaurants.isEmpty()) {
            for (Restaurant restaurant : allrestaurants) {
    %>
        <div class="restaurant-card">
            <img src="${pageContext.request.contextPath}/<%=restaurant.getImagePath() %>" alt="<%=restaurant.getName() %>">
            <div class="card-content">
                <h2><%=restaurant.getName() %></h2>

                <div class="info-row">
                    <span class="rating">⭐ <%=restaurant.getRating() %></span>
                    <span class="time">⏱ <%= restaurant.getDeliveryTime() %> mins</span>
                </div>

                <div class="cuisine">
                    <b>Cuisine:</b> <%= restaurant.getCuisineType() %>
                </div>
                <div class="address">
                    <b>📍</b> <%= restaurant.getAddress() %>
                </div>

                <a href="${pageContext.request.contextPath}/menu?restaurantId=<%= restaurant.getRestaurantId() %>" class="btn btn-primary" style="display:block; width:100%;">View Menu</a>
            </div>
        </div>
    <%
            }
        } else {
    %>
        <div style="grid-column: 1 / -1; text-align: center; padding: 40px; color: #666;">
            No restaurants found.
        </div>
    <%
        }
    %>
    </div>

    <jsp:include page="footer.jsp" />

</body>
</html>