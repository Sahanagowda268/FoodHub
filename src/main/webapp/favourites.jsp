<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.foodhub.model.Menu" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>FoodHub | Your Favourites</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
<style>
/* Favourites Page Styling */
body { font-family: 'Outfit', sans-serif; }
.page-container {
    max-width: 1400px;
    margin: 40px auto;
    padding: 0 5%;
}
.page-title {
    font-size: 32px;
    font-weight: 800;
    color: var(--primary);
    margin-bottom: 30px;
    border-bottom: 2px solid #eee;
    padding-bottom: 15px;
}

/* Empty State */
.empty-state {
    text-align: center;
    padding: 60px 20px;
    background: white;
    border-radius: 16px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.05);
}
.empty-state img {
    width: 250px;
    max-width: 100%;
    margin-bottom: 20px;
}
.empty-state h2 {
    color: var(--primary);
    margin-bottom: 10px;
}
.empty-state p {
    color: #666;
    margin-bottom: 25px;
    font-size: 16px;
}

/* Favourites Grid */
.fav-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 30px;
}
.fav-card {
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 4px 15px rgba(0,0,0,0.05);
    transition: transform 0.3s, box-shadow 0.3s;
    display: flex;
    flex-direction: column;
}
.fav-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0,0,0,0.1);
}
.fav-img-wrapper {
    position: relative;
    height: 200px;
}
.fav-img-wrapper img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}
.fav-remove {
    position: absolute;
    top: 15px;
    right: 15px;
    background: white;
    color: var(--danger);
    width: 36px;
    height: 36px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    text-decoration: none;
    font-size: 20px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    transition: 0.3s;
}
.fav-remove:hover {
    background: var(--accent);
    transform: scale(1.1);
}
.fav-content {
    padding: 20px;
    flex: 1;
    display: flex;
    flex-direction: column;
}
    font-size: 18px;
    font-weight: 700;
    color: var(--text);
    margin-bottom: 10px;
}
.fav-price {
    font-size: 18px;
    color: var(--primary);
    font-weight: 700;
    margin-bottom: 15px;
}
.fav-actions {
    margin-top: auto;
}
.btn-add-cart {
    display: block;
    width: 100%;
    text-align: center;
    background: var(--primary);
    color: white;
    padding: 10px;
    text-decoration: none;
    border-radius: 8px;
    font-weight: 600;
    border: none;
    cursor: pointer;
    transition: 0.3s;
}
.btn-add-cart:hover {
    background: var(--secondary);
}
</style>
</head>
<body>

    <jsp:include page="navbar.jsp" />

    <div class="page-container">
        <h1 class="page-title">Your Favourites ❤️</h1>
        <p style="color:#666; font-size:16px; margin-top:-20px; margin-bottom:30px;">All the dishes you love, saved in one place.</p>

        <%
            List<Menu> favMenus = (List<Menu>) request.getAttribute("favouriteMenus");
            if (favMenus == null || favMenus.isEmpty()) {
        %>
            <div class="empty-state">
                <img src="${pageContext.request.contextPath}/images/empty-fav.png" alt="Empty Favourites">
                <h2>Nothing saved yet ❤️</h2>
                <p>Save your favourite dishes and they'll appear here.</p>
                <a href="${pageContext.request.contextPath}/#restaurants-section" class="btn-primary" style="display:inline-block; padding:12px 25px; border-radius:30px; text-decoration:none;">Explore Restaurants</a>
            </div>
        <%
            } else {
        %>
            <div class="fav-grid">
                <% for (Menu menu : favMenus) { %>
                    <div class="fav-card">
                        <div class="fav-img-wrapper">
                            <img src="${pageContext.request.contextPath}/<%= menu.getImagePath() %>" alt="<%= menu.getItemName() %>">
                            <a href="${pageContext.request.contextPath}/favourite?action=remove&menuId=<%= menu.getMenuId() %>" class="fav-remove" title="Remove from Favourites">❤️</a>
                        </div>
                        <div class="fav-content">
                            <h3 class="fav-title"><%= menu.getItemName() %></h3>
                            <div class="fav-price">₹<%= menu.getPrice() %></div>
                            
                            <div class="fav-actions">
                                <form action="${pageContext.request.contextPath}/cart" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="add">
                                    <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" class="btn-add-cart">Add to Cart 🛒</button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <jsp:include page="footer.jsp" />

</body>
</html>
