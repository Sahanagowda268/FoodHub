<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.User" %>
<%
    User navUser = (User) session.getAttribute("loggedInUser");
    String currentURI = request.getRequestURI();
%>
<style>
/* Modern Navbar Styles */
.navbar {
    background: var(--primary);
    height: 75px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 0 5%;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    border-bottom: 3px solid var(--secondary);
    position: sticky;
    top: 0;
    z-index: 1000;
    font-family: 'Outfit', sans-serif;
}

.navbar-logo {
    font-size: 24px;
    font-weight: 800;
    color: white;
    text-decoration: none;
    display: flex;
    align-items: center;
    gap: 8px;
    letter-spacing: -0.5px;
}

.navbar-logo span {
    color: white;
}

.nav-right {
    display: flex;
    align-items: center;
    gap: 40px;
}

.nav-links {
    display: flex;
    list-style: none;
    gap: 25px;
    margin: 0;
    padding: 0;
    align-items: center;
}

.nav-links li a {
    text-decoration: none;
    color: white;
    font-size: 15px;
    font-weight: 600;
    transition: color 0.3s ease;
    display: flex;
    align-items: center;
    gap: 6px;
}

.nav-links li a:hover, .nav-links li a.active {
    color: var(--accent);
}

.nav-auth {
    display: flex;
    align-items: center;
    gap: 15px;
}

.nav-auth a {
    text-decoration: none;
    font-size: 14px;
    font-weight: 600;
    border-radius: 20px;
    padding: 8px 18px;
    transition: all 0.3s ease;
}

.btn-signin {
    color: var(--primary);
    background: white;
    border: 1px solid white;
}

.btn-signin:hover {
    background: var(--accent);
}

.btn-register {
    color: white;
    background: var(--secondary);
    border: 1px solid var(--secondary);
    box-shadow: var(--shadow);
}

.btn-register:hover {
    background: #104214;
    transform: translateY(-1px);
}

.btn-logout {
    color: var(--danger);
    background: #ffebee;
    border: 1px solid transparent;
}

.btn-logout:hover {
    background: #ffcdd2;
}

/* Mobile menu icon */
.mobile-menu-btn {
    display: none;
    background: none;
    border: none;
    font-size: 24px;
    color: white;
    cursor: pointer;
}

@media (max-width: 900px) {
    .nav-center { display: none; }
    .nav-auth { display: none; }
    .mobile-menu-btn { display: block; }
}
</style>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="navbar-logo">🍴 <span>FoodHub</span></a>
    
    <button class="mobile-menu-btn">☰</button>
    
    <div class="nav-right">
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/" class="<%= currentURI.equals(request.getContextPath() + "/") || currentURI.endsWith("index.jsp") ? "active" : "" %>">🏠 Home</a></li>
            <li><a href="${pageContext.request.contextPath}/#restaurants-section" class="<%= currentURI.endsWith("/restaurant") || currentURI.endsWith("/menu") ? "active" : "" %>">🍽️ Restaurants</a></li>
            
            <% if (navUser != null) { %>
                <li><a href="${pageContext.request.contextPath}/profile" class="<%= currentURI.endsWith("/profile") ? "active" : "" %>">👤 Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/orders" class="<%= currentURI.endsWith("/orders") || currentURI.endsWith("orders.jsp") ? "active" : "" %>">📦 Orders</a></li>
                <li><a href="${pageContext.request.contextPath}/favourite" class="<%= currentURI.endsWith("/favourite") || currentURI.endsWith("favourites.jsp") ? "active" : "" %>">❤️ Favourites</a></li>
            <% } %>
            <li><a href="${pageContext.request.contextPath}/cart.jsp" class="<%= currentURI.endsWith("/cart.jsp") ? "active" : "" %>">🛒 Cart</a></li>
        </ul>
        
        <div class="nav-auth">
            <% if (navUser != null) { %>
                <a href="${pageContext.request.contextPath}/logout" class="btn-logout">Logout</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn-signin">Sign In</a>
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn-register">Register</a>
            <% } %>
        </div>
    </div>
</nav>

<!-- Including Chatbot Globally -->
<jsp:include page="chatbot.jsp" />
