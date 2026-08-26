<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
/* Footer Styles */
.footer {
    background-color: var(--secondary);
    color: white;
    padding: 60px 5% 30px;
    margin-top: 60px;
    font-family: 'Outfit', sans-serif;
}

.footer-content {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    gap: 40px;
    margin-bottom: 40px;
}

.footer-section {
    flex: 1;
    min-width: 150px;
}

.footer-section.brand {
    flex: 2;
    min-width: 250px;
}

.footer-logo {
    font-size: 28px;
    font-weight: 700;
    color: white;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 15px;
}

.footer-logo span {
    color: var(--accent);
}

.footer-desc {
    font-size: 14px;
    line-height: 1.6;
    color: #ccc;
    max-width: 300px;
}

.footer-section h3 {
    font-size: 18px;
    font-weight: 600;
    margin-bottom: 20px;
    color: white;
}

.footer-links {
    list-style: none;
    padding: 0;
    margin: 0;
}

.footer-links li {
    margin-bottom: 12px;
}

.footer-links a {
    color: #ccc;
    text-decoration: none;
    font-size: 14px;
    transition: color 0.3s ease;
}

.footer-links a:hover {
    color: white;
}

.footer-contact p {
    font-size: 14px;
    color: #ccc;
    margin-bottom: 12px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.footer-contact a {
    color: #ccc;
    text-decoration: none;
    transition: color 0.3s;
}

.footer-contact a:hover {
    color: white;
}

.footer-bottom {
    text-align: center;
    padding-top: 30px;
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    font-size: 14px;
    color: #aaa;
}

@media (max-width: 768px) {
    .footer-content {
        flex-direction: column;
    }
}
</style>

<footer class="footer">
    <div class="footer-content">
        <!-- Brand Section -->
        <div class="footer-section brand">
            <a href="${pageContext.request.contextPath}/" class="footer-logo">🍴 <span>FoodHub</span></a>
            <p class="footer-desc">Bringing delicious food from your favourite restaurants straight to your doorstep.</p>
        </div>
        
        <!-- Quick Links -->
        <div class="footer-section">
            <h3>Quick Links</h3>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                <li><a href="${pageContext.request.contextPath}/#restaurants-section">Restaurants</a></li>
                <li><a href="${pageContext.request.contextPath}/favourite">Favourites</a></li>
                <li><a href="${pageContext.request.contextPath}/cart.jsp">Cart</a></li>
                <li><a href="${pageContext.request.contextPath}/orders">Orders</a></li>
                <li><a href="${pageContext.request.contextPath}/profile">Profile</a></li>
            </ul>
        </div>
        
        <!-- Account -->
        <div class="footer-section">
            <h3>Account</h3>
            <ul class="footer-links">
                <% if(session.getAttribute("loggedInUser") == null) { %>
                    <li><a href="${pageContext.request.contextPath}/login.jsp">Sign In</a></li>
                    <li><a href="${pageContext.request.contextPath}/register.jsp">Register</a></li>
                <% } else { %>
                    <li><a href="${pageContext.request.contextPath}/profile">My Profile</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
                <% } %>
            </ul>
        </div>
        
        <!-- Support -->
        <div class="footer-section">
            <h3>Support</h3>
            <ul class="footer-links">
                <li><a href="#">Help</a></li>
                <li><a href="#">Contact Us</a></li>
                <li><a href="#">FAQ</a></li>
            </ul>
        </div>
        
        <!-- Contact -->
        <div class="footer-section footer-contact">
            <h3>Contact</h3>
            <p>📧 <a href="mailto:support@foodhub.com">support@foodhub.com</a></p>
            <p>📞 +91 XXXXX XXXXX</p>
            <p>📍 Bengaluru, Karnataka</p>
        </div>
    </div>
    
    <div class="footer-bottom">
        &copy; 2026 FoodHub. All rights reserved.
    </div>
</footer>
