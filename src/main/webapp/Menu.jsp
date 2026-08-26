<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Set, com.foodhub.model.Menu" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FoodHub | Menu</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
<style>
body { font-family: 'Outfit', sans-serif; }
/* ---------- Header ---------- */
.header {
    background: linear-gradient(135deg, var(--primary), var(--secondary));
    color: white;
    text-align: center;
    padding: 80px 20px 100px;
}
.header h1 { font-size: 42px; font-weight: 800; color: white; margin-bottom:15px; }
.header p { font-size: 18px; opacity: 0.9; color: #e0d5e1; }

/* ---------- Search ---------- */
.search {
    width: 90%;
    max-width: 1200px;
    margin: -35px auto 50px auto;
    position: relative;
    z-index: 10;
}
.search input {
    width: 100%;
    padding: 20px 30px;
    border-radius: 50px;
    border: 1px solid #eee;
    box-shadow: 0 10px 30px rgba(0,0,0,0.08);
    font-size: 16px;
    outline: none;
    font-family: inherit;
}
.search input:focus { border-color: #2D1B2E; }

/* ---------- Menu Grid ---------- */
.menu-container {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 30px;
    padding-bottom: 60px;
    max-width: 1400px;
    margin: 0 auto;
    padding-left: 5%;
    padding-right: 5%;
}

.card {
    background: white;
    border-radius: 16px;
    overflow: hidden;
    box-shadow: 0 10px 20px rgba(0,0,0,0.05);
    transition: transform 0.3s, box-shadow 0.3s;
    border: 1px solid #eee;
    display: flex;
    flex-direction: column;
}
.card:hover {
    transform: translateY(-8px);
    box-shadow: 0 15px 30px rgba(0,0,0,0.1);
}

.card img {
    width: 100%;
    height: 220px;
    object-fit: cover;
}
.content { padding: 25px; flex: 1; display: flex; flex-direction: column; }
.content h3 { font-size: 20px; margin-bottom: 10px; font-weight: 700; color: var(--text); }
.price { color: var(--primary); font-size: 22px; font-weight: 800; display: block; margin-bottom: 10px; }
.desc { margin-bottom: 20px; color: var(--muted); font-size: 14px; line-height: 1.5; }

.action-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: auto;
    margin-bottom: 15px;
}
.qty-control {
    display: flex;
    align-items: center;
    border: 1px solid #eee;
    border-radius: 25px;
    overflow: hidden;
    background: var(--border);
    padding: 2px;
}
.qty-btn {
    background: transparent;
    border: none;
    padding: 8px 15px;
    cursor: pointer;
    font-weight: bold;
    color: var(--text);
    transition: 0.2s;
}
.qty-btn:hover { background: var(--accent); border-radius: 20px; }
.qty-input {
    width: 30px;
    text-align: center;
    border: none;
    font-size: 16px;
    font-weight: 600;
    pointer-events: none;
    background: transparent;
}
.fav-btn {
    font-size: 24px;
    text-decoration: none;
    transition: transform 0.2s;
}
.fav-btn.empty { filter: grayscale(100%); opacity: 0.5; }

</style>
</head>
<body>

<jsp:include page="navbar.jsp" />

<div class="header">
    <h1>Restaurant Menu</h1>
    <p>Delicious food waiting for you!</p>
</div>

<div class="search">
    <input type="text" placeholder="🔍 Search menu items...">
</div>

<div class="menu-container">
<%
    List<Menu> menuList = (List<Menu>) request.getAttribute("menuList");
    Set<Integer> favSet = (Set<Integer>) request.getAttribute("favSet");
    if (favSet == null) favSet = new java.util.HashSet<>();
    if(menuList != null && !menuList.isEmpty()) {
        for(Menu item : menuList) {
            boolean isFav = favSet.contains(item.getMenuId());
%>
    <div class="card">
        <img src="${pageContext.request.contextPath}/<%= item.getImagePath() %>" alt="<%= item.getItemName() %>">
        <div class="content">
            <h3><%= item.getItemName() %></h3>
            <span class="price">₹<%= item.getPrice() %></span>
            <p class="desc"><%= item.getDescription() %></p>

            <% if(item.getIsAvailable()) { %>
                <form action="${pageContext.request.contextPath}/cart" method="post" style="display:flex; flex-direction:column; height:100%;">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                    <div class="action-row">
                        <div class="qty-control">
                            <button type="button" class="qty-btn" onclick="this.nextElementSibling.stepDown()">-</button>
                            <input type="number" name="quantity" class="qty-input" value="1" min="1" max="20" readonly>
                            <button type="button" class="qty-btn" onclick="this.previousElementSibling.stepUp()">+</button>
                        </div>
                        <a href="${pageContext.request.contextPath}/favourite?action=<%= isFav ? "remove" : "add" %>&menuId=<%= item.getMenuId() %>" class="fav-btn <%= isFav ? "" : "empty" %>" title="<%= isFav ? "Remove from Favourites" : "Add to Favourites" %>">
                            <%= isFav ? "❤️" : "🤍" %>
                        </a>
                    </div>
                    <% if (session.getAttribute("loggedInUser") != null) { %>
                        <button type="submit" class="btn btn-secondary" style="margin-top:auto;">Add to Cart 🛒</button>
                    <% } else { %>
                        <a href="${pageContext.request.contextPath}/login.jsp?redirect=menu?restaurantId=<%= request.getParameter("restaurantId") %>" class="btn btn-secondary" style="margin-top:auto; box-sizing: border-box;">Add to Cart 🛒</a>
                    <% } %>
                </form>
            <% } else { %>
                <div class="action-row" style="margin-top:auto;">
                    <span class="badge badge-unavailable">Not Available</span>
                    <a href="${pageContext.request.contextPath}/favourite?action=<%= isFav ? "remove" : "add" %>&menuId=<%= item.getMenuId() %>" class="fav-btn <%= isFav ? "" : "empty" %>" style="margin-left:auto;">
                        <%= isFav ? "❤️" : "🤍" %>
                    </a>
                </div>
                <button class="btn btn-secondary" style="background:#ccc; color:white; cursor:not-allowed;" disabled>Add to Cart 🛒</button>
            <% } %>
        </div>
    </div>
<%
        }
    } else {
%>
    <p style="text-align:center; width:100%; grid-column: 1 / -1; padding:40px; color:#666;">No menu items available for this restaurant.</p>
<%
    }
%>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>
