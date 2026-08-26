<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.foodhub.model.Restaurant, com.foodhub.DAOImpl.RestaurantDAOImpl" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>FoodHub | Craving Something Delicious?</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
<style>
/* Global Resets */
html { scroll-behavior: smooth; }
body {
    margin: 0;
    font-family: 'Outfit', sans-serif;
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@1,700&display=swap');

/* Zomato-style Hero Section */
.hero-wrapper {
    padding: 0;
    width: 100%;
    margin: 0;
}
.hero-card {
    position: relative;
    width: 100%;
    height: 75vh;
    min-height: 550px;
    border-radius: 0;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: none;
    background-color: #111; /* Fallback before video loads */
}
.hero-video {
    position: absolute;
    top: 0; left: 0; width: 100%; height: 100%;
    object-fit: cover;
    z-index: 1;
}
.hero-overlay {
    position: absolute;
    top: 0; left: 0; right: 0; bottom: 0;
    background: rgba(0, 0, 0, 0.65); /* Darker overlay for text readability */
    z-index: 2;
}
.hero-content {
    position: relative;
    z-index: 3;
    text-align: center;
    color: white;
    max-width: 800px;
    padding: 20px;
}
.hero-content h1 {
    font-family: 'Playfair Display', serif;
    font-size: 76px;
    font-weight: 700;
    font-style: italic;
    margin-bottom: 25px;
    line-height: 1.2;
}
.color-green { color: #4caf50; }
.color-orange { color: #ff9800; }
.color-red { color: #f44336; }

.hero-content p {
    font-size: 22px;
    color: #f0f0f0;
    margin-bottom: 40px;
    line-height: 1.6;
    font-family: 'Outfit', sans-serif;
}
.hero-features {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
    justify-content: center;
    margin-bottom: 40px;
}
.feature-item {
    display: flex;
    align-items: center;
    gap: 8px;
    background: rgba(255, 255, 255, 0.1);
    padding: 12px 20px;
    border-radius: 50px;
    font-size: 15px;
    font-weight: 700;
    color: white;
    border: 1px solid rgba(255, 255, 255, 0.3);
    backdrop-filter: blur(5px);
}
.hero-buttons {
    display: flex; gap: 15px; justify-content: center;
}
.btn-primary-large {
    display: inline-block;
    padding: 18px 45px;
    background-color: var(--primary);
    color: white;
    text-decoration: none;
    font-size: 18px;
    font-weight: 700;
    border-radius: 50px;
    transition: all 0.3s ease;
    box-shadow: var(--shadow);
}
.btn-primary-large:hover {
    background-color: var(--secondary);
    transform: translateY(-3px);
}
.btn-outline-large {
    display: inline-block;
    padding: 18px 45px;
    background-color: transparent;
    color: white;
    text-decoration: none;
    font-size: 18px;
    font-weight: 700;
    border-radius: 50px;
    transition: all 0.3s ease;
    border: 2px solid white;
}
.btn-outline-large:hover {
    background-color: white;
    color: var(--primary);
    transform: translateY(-3px);
}

@media (max-width: 1024px) {
    .hero-content h1 { font-size: 52px; }
}

/* Section Containers */
.section {
    padding: 80px 5%;
    max-width: 1400px;
    margin: 0 auto;
}
.section-title {
    text-align: center;
    font-size: 32px;
    font-weight: 800;
    color: var(--primary);
    margin-bottom: 10px;
}
.section-subtitle {
    text-align: center;
    font-size: 16px;
    color: #666;
    margin-bottom: 50px;
}

/* Feature Cards */
.features-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 30px;
}
.feature-card {
    background: white;
    padding: 30px 20px;
    border-radius: 12px;
    text-align: center;
    box-shadow: 0 10px 30px rgba(0,0,0,0.05);
    transition: transform 0.3s ease;
    border: 1px solid #eee;
}
.feature-card:hover {
    transform: translateY(-5px);
}
.feature-icon {
    font-size: 48px;
    margin-bottom: 20px;
}
.feature-card h3 {
    font-size: 20px;
    color: #333;
    margin-bottom: 15px;
}
.feature-card p {
    font-size: 14px;
    color: #666;
    line-height: 1.5;
}

/* Restaurant Grid Styles */
.restaurant-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 30px;
}
@media (max-width: 1024px) {
    .restaurant-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}
@media (max-width: 650px) {
    .restaurant-grid {
        grid-template-columns: 1fr;
    }
}
.restaurant-card {
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    transition: transform 0.3s, box-shadow 0.3s;
    border: 1px solid #f0f0f0;
    text-decoration: none;
    color: inherit;
    display: flex;
    flex-direction: column;
}
.restaurant-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 12px 24px rgba(0,0,0,0.1);
}
.restaurant-card img {
    width: 100%;
    aspect-ratio: 16 / 9;
    object-fit: cover;
}
.card-content {
    padding: 16px;
    display: flex;
    flex-direction: column;
    flex-grow: 1;
}
.card-content h2 {
    font-size: 18px;
    margin: 0 0 4px 0;
    font-weight: 700;
    color: #333;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.cuisine, .address {
    color: #666;
    font-size: 13px;
    margin: 0 0 4px 0;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}
.address { margin-bottom: 15px; }

.info-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: auto;
    border-top: 1px dashed #eee;
    padding-top: 12px;
}
.rating {
    background: var(--primary);
    color: white;
    padding: 4px 8px;
    border-radius: 4px;
    font-weight: 700;
    font-size: 13px;
}
.time {
    color: #555;
    font-size: 13px;
    font-weight: 500;
}
</style>
</head>
<body>

    <!-- Navbar -->
    <jsp:include page="navbar.jsp" />

    <!-- Hero Section -->
    <div class="hero-wrapper">
        <div class="hero-card">
            <video autoplay loop muted playsinline class="hero-video">
                <source src="${pageContext.request.contextPath}/images/Home/11131968-hd_2160_3840_25fps.mp4" type="video/mp4">
            </video>
            <div class="hero-overlay"></div>
            
            <div class="hero-content">
                <h1>
                    <span class="color-green">Good Food.</span> <br>
                    <span class="color-orange">Great Mood.</span> <br>
                    <span class="color-red">Delivered Fast.</span>
                </h1>
                <p>Discover delicious meals from your favourite restaurants and get them delivered fresh to your doorstep.</p>
                <div class="hero-features">
                    <div class="feature-item">⚡ 30-Min Express</div>
                    <div class="feature-item">🍽️ Top Restaurants</div>
                    <div class="feature-item">❤️ Fresh & Delicious</div>
                </div>
                <div class="hero-buttons">
                    <a href="#restaurants-section" class="btn-outline-large">Explore Restaurants</a>
                    <a href="#restaurants-section" class="btn-primary-large">Order Now</a>
                </div>
            </div>
        </div>
    </div>

    <!-- All Restaurants Section -->
    <div id="restaurants-section" style="padding: 80px 5%; width: 100%; box-sizing: border-box;">
        <h2 class="section-title">Popular Restaurants</h2>
        <p class="section-subtitle">Discover the best places to satisfy your cravings.</p>
        
        <div class="restaurant-grid">
        <%
            RestaurantDAOImpl restaurantDAOImpl = new RestaurantDAOImpl();
            List<Restaurant> allrestaurants = restaurantDAOImpl.getAllRestaurants();
            if(allrestaurants != null && !allrestaurants.isEmpty()) {
                for (Restaurant restaurant : allrestaurants) {
        %>
            <a href="${pageContext.request.contextPath}/menu?restaurantId=<%= restaurant.getRestaurantId() %>" class="restaurant-card">
                <img src="${pageContext.request.contextPath}/<%=restaurant.getImagePath() %>" alt="<%=restaurant.getName() %>">
                <div class="card-content">
                    <h2><%=restaurant.getName() %></h2>
                    <div class="cuisine"><%= restaurant.getCuisineType() %></div>
                    <div class="address"><%= restaurant.getAddress() %></div>

                    <div class="info-row">
                        <span class="rating"><%=restaurant.getRating() %> ★</span>
                        <span class="time"><%= restaurant.getDeliveryTime() %> mins</span>
                    </div>
                </div>
            </a>
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
    </div>

    <!-- Trending Dishes Section -->
    <div id="trending-section" style="padding: 80px 5%; width: 100%; box-sizing: border-box;">
        <h2 class="section-title">Trending Dishes</h2>
        <p class="section-subtitle">Your next favourite bite is just a click away.</p>
        
        <div class="restaurant-grid">
        <%
            com.foodhub.DAOImpl.MenuDAOImpl menuDAOImpl = new com.foodhub.DAOImpl.MenuDAOImpl();
            List<com.foodhub.model.Menu> allMenus = menuDAOImpl.getAllMenus();
            if(allMenus != null && !allMenus.isEmpty()) {
                int count = 0;
                for (com.foodhub.model.Menu m : allMenus) {
                    if (count >= 6) break;
                    if (!m.getIsAvailable()) continue;
        %>
            <a href="${pageContext.request.contextPath}/menu?restaurantId=<%= m.getRestaurantId() %>" class="restaurant-card" style="text-decoration: none;">
                <img src="${pageContext.request.contextPath}/<%=m.getImagePath() %>" alt="<%=m.getItemName() %>">
                <div class="card-content">
                    <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom: 8px;">
                        <h2 style="margin:0;"><%=m.getItemName() %></h2>
                        <span style="color:var(--primary); font-weight:800; font-size:18px;">₹<%=m.getPrice() %></span>
                    </div>
                    <div class="cuisine" style="white-space: normal; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical;"><%= m.getDescription() %></div>
                    
                    <div class="info-row" style="margin-top:auto; padding-top:15px; border-top:none;">
                        <button class="btn-primary" style="width:100%; padding:12px; border-radius:8px; border:none; cursor:pointer; font-weight:700;">Order Now</button>
                    </div>
                </div>
            </a>
        <%
                    count++;
                }
            }
        %>
        </div>
    </div>

    <!-- Features Section -->
    <div class="section" style="background-color: #fff; max-width: 100%; padding-left: 5%; padding-right: 5%;">
        <h2 class="section-title">Why Choose FoodHub?</h2>
        <p class="section-subtitle">We make ordering food as enjoyable as eating it.</p>
        
        <div class="features-grid" style="max-width: 1400px; margin: 0 auto;">
            <div class="feature-card">
                <div class="feature-icon">🚀</div>
                <h3>Fast Delivery</h3>
                <p>Fresh food delivered quickly to your doorstep while it's still hot.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🍽️</div>
                <h3>Top Restaurants</h3>
                <p>Explore a massive variety of top restaurants and cuisines all in one place.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">❤️</div>
                <h3>Easy Ordering</h3>
                <p>A simple, flawless ordering experience from start to finish.</p>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🔒</div>
                <h3>Secure Checkout</h3>
                <p>Your payments are completely secure with our trusted checkout process.</p>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <jsp:include page="footer.jsp" />

</body>
</html>
