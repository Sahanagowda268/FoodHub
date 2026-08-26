<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.User" %>
<%
    User user = (User) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>FoodHub | Delivery Location</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
<style>
.bg-delivery {
    background-image: url('${pageContext.request.contextPath}/images/delivery-bg.jpg');
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed;
}
.form-container {
    width: 100%;
    max-width: 800px;
    margin: 60px auto;
    padding: 40px;
    background: var(--card);
    border-radius: var(--border-radius);
    box-shadow: var(--shadow);
    border: 1px solid var(--border);
}
h2 {
    text-align: center;
    margin-bottom: 25px;
    color: var(--primary);
    font-weight: 700;
}
.radio-group { margin-bottom: 20px; }
.radio-group label {
    display: block;
    padding: 20px;
    border: 2px solid var(--border);
    border-radius: 10px;
    margin-bottom: 15px;
    cursor: pointer;
    transition: 0.3s;
    background: white;
}
.radio-group label:hover {
    border-color: var(--primary);
    background: var(--accent);
}
.radio-group input[type="radio"] { margin-right: 12px; transform: scale(1.2); accent-color: var(--primary); }
.custom-address { display: none; margin-top: 15px; }
</style>
<script>
    function toggleCustomAddress() {
        var customRadio = document.getElementById("customAddressRadio");
        var customAddressDiv = document.getElementById("customAddressDiv");
        var customAddressInput = document.getElementById("customAddressInput");
        
        if (customRadio.checked) {
            customAddressDiv.style.display = "block";
            customAddressInput.setAttribute("required", "required");
            customAddressInput.focus();
        } else {
            customAddressDiv.style.display = "none";
            customAddressInput.removeAttribute("required");
        }
    }
</script>
</head>
<body class="bg-delivery">
    <jsp:include page="navbar.jsp" />
    
    <div class="container">
        <div class="form-container">
            <h2>Delivery Details 📍</h2>
            <p style="text-align:center; color:var(--muted); margin-bottom:30px;">Please confirm your contact details and delivery address.</p>
            <form action="${pageContext.request.contextPath}/checkout.jsp" method="post">
                
                <div style="display:flex; gap:20px; margin-bottom:25px;">
                    <div style="flex:1;">
                        <label style="display:block; margin-bottom:8px; font-weight:600; color:#555;">Full Name</label>
                        <input type="text" name="customerName" class="form-control" value="<%= user.getUsername() %>" required style="width:100%; padding:15px; border:1px solid #ddd; border-radius:8px;">
                    </div>
                    <div style="flex:1;">
                        <label style="display:block; margin-bottom:8px; font-weight:600; color:#555;">Phone Number</label>
                        <input type="text" name="phoneNumber" class="form-control" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" required placeholder="10-digit mobile number" style="width:100%; padding:15px; border:1px solid #ddd; border-radius:8px;">
                    </div>
                </div>

                <label style="display:block; margin-bottom:15px; font-weight:600; color:#555;">Select Address</label>
                <div class="radio-group">
                    <label>
                        <input type="radio" name="addressType" value="default" checked onclick="toggleCustomAddress()">
                        <strong style="color:var(--text); font-size:16px;">Saved Registered Address:</strong><br>
                        <span style="color:var(--muted); margin-left:28px; display:inline-block; margin-top:8px;"><%= user.getAddress() %></span>
                    </label>
                    <label>
                        <input type="radio" name="addressType" value="custom" id="customAddressRadio" onclick="toggleCustomAddress()">
                        <strong style="color:var(--text); font-size:16px;">Deliver to a different address</strong>
                    </label>
                </div>
                
                <div class="custom-address form-group" id="customAddressDiv">
                    <input type="text" name="customAddress" id="customAddressInput" class="form-control" placeholder="Enter full delivery address..." style="width:100%; padding:15px; border:1px solid #ddd; border-radius:8px;">
                </div>
                
                <input type="hidden" name="defaultAddress" value="<%= user.getAddress() %>">
                
                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 15px; padding:18px; font-size:18px; font-weight:700; border-radius:8px;">Proceed to Payment</button>
            </form>
        </div>
    </div>
    
    <footer> © 2026 FoodHub | Delicious Food Delivered Fast </footer>
</body>
</html>
