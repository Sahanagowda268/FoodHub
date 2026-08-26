<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.User" %>
<%
    User user = (User) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>FoodHub | Profile</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
<style>
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Outfit:wght@400;600;700&display=swap');

body {
    font-family: 'Outfit', sans-serif;
    margin: 0;
    min-height: 100vh;
    background: url('${pageContext.request.contextPath}/images/2.jpg') center/cover no-repeat fixed;
    color: white;
}
body::before {
    content: '';
    position: fixed;
    top: 0; left: 0; right: 0; bottom: 0;
    background: rgba(0, 0, 0, 0.55);
    z-index: 0;
}

.page-container {
    position: relative;
    z-index: 1;
    max-width: 750px;
    margin: 50px auto;
    padding: 0 20px;
}

.profile-card {
    background: rgba(255, 255, 255, 0.08);
    backdrop-filter: blur(18px);
    -webkit-backdrop-filter: blur(18px);
    border-radius: 24px;
    padding: 45px 40px;
    box-shadow: 0 15px 50px rgba(0, 0, 0, 0.3);
    border: 1px solid rgba(255, 255, 255, 0.15);
}

.profile-avatar-section { text-align: center; margin-bottom: 35px; }
.profile-avatar {
    width: 110px; height: 110px; border-radius: 50%;
    background: linear-gradient(135deg, #ff6b35, #f7c948);
    color: white;
    font-size: 44px; line-height: 110px;
    font-weight: 700; margin: 0 auto 18px auto;
    box-shadow: 0 8px 25px rgba(255, 107, 53, 0.4);
    font-family: 'Playfair Display', serif;
}
.profile-name {
    font-size: 26px; font-weight: 700; color: white;
    margin-bottom: 6px; letter-spacing: 0.5px;
}
.profile-email { font-size: 14px; color: rgba(255,255,255,0.7); }

.profile-list { margin-bottom: 35px; }
.profile-list-item {
    display: flex; justify-content: space-between; align-items: center;
    padding: 18px 0; border-bottom: 1px solid rgba(255,255,255,0.1);
}
.profile-list-item:last-child { border-bottom: none; }
.item-label {
    display: flex; align-items: center; gap: 12px;
    color: rgba(255,255,255,0.8); font-size: 15px; font-weight: 600;
}
.item-value { flex: 1; text-align: right; }
.item-value input, .item-value select {
    width: 100%; max-width: 300px; text-align: right;
    border: none; background: transparent; font-size: 15px;
    color: white; font-weight: 600; font-family: inherit;
    outline: none; padding: 5px;
}
.item-value input::placeholder { color: rgba(255,255,255,0.4); }
.item-value input:focus, .item-value select:focus {
    border-bottom: 2px solid #ff6b35;
}
.item-value select { color: white; }
.item-value select option { color: #333; background: white; }

.profile-buttons { display: flex; gap: 20px; }
.btn-edit, .btn-logout {
    flex: 1; padding: 16px; border-radius: 12px; font-size: 16px;
    font-weight: 700; text-align: center; text-decoration: none; border: none; cursor: pointer; transition: 0.3s;
}
.btn-edit {
    background: linear-gradient(135deg, #ff6b35, #e84118);
    color: white;
    box-shadow: 0 6px 20px rgba(255, 107, 53, 0.35);
}
.btn-edit:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(255, 107, 53, 0.5); }
.btn-logout {
    background: rgba(255,255,255,0.1);
    color: white;
    border: 1px solid rgba(255,255,255,0.25);
    backdrop-filter: blur(5px);
}
.btn-logout:hover { background: rgba(255,255,255,0.2); transform: translateY(-2px); }

/* Role & date (read-only values) */
.readonly-value { color: #ff6b35; font-weight: 700; font-size: 15px; }
.date-value { color: rgba(255,255,255,0.7); font-weight: 600; font-size: 15px; }
</style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    
    <div class="page-container">
        <div class="profile-card">
            
            <%
                String firstLetter = user.getUsername() != null && !user.getUsername().isEmpty() ? user.getUsername().substring(0,1).toUpperCase() : "U";
            %>
            <div class="profile-avatar-section">
                <div class="profile-avatar"><%= firstLetter %></div>
                <div class="profile-name"><%= user.getUsername() %></div>
                <div class="profile-email">✉️ <%= user.getEmail() %></div>
            </div>
            
            <% String msg = (String) request.getAttribute("msg"); if(msg != null) { %>
                <div style="background:#e8f5e9; color:#2e7d32; padding:15px; text-align:center; border-radius:8px; margin-bottom:25px; font-weight:600;"><%= msg %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/profile" method="post">
                <div class="profile-list">
                    <div class="profile-list-item">
                        <div class="item-label">👤 Full Name</div>
                        <div class="item-value"><input type="text" name="username" value="<%= user.getUsername() %>" required></div>
                    </div>
                    <div class="profile-list-item">
                        <div class="item-label">📱 Phone Number</div>
                        <div class="item-value"><input type="text" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" placeholder="Enter phone"></div>
                    </div>
                    <div class="profile-list-item">
                        <div class="item-label">🚻 Gender</div>
                        <div class="item-value">
                            <select name="gender" dir="rtl">
                                <option value="">Select Gender</option>
                                <option value="Male" <%= "Male".equals(user.getGender()) ? "selected" : "" %>>Male</option>
                                <option value="Female" <%= "Female".equals(user.getGender()) ? "selected" : "" %>>Female</option>
                                <option value="Other" <%= "Other".equals(user.getGender()) ? "selected" : "" %>>Other</option>
                            </select>
                        </div>
                    </div>
                    <div class="profile-list-item">
                        <div class="item-label">🎂 Date of Birth</div>
                        <div class="item-value"><input type="date" name="dateOfBirth" value="<%= user.getDateOfBirth() != null ? user.getDateOfBirth().toString() : "" %>"></div>
                    </div>
                    <div class="profile-list-item">
                        <div class="item-label">📍 Saved Address</div>
                        <div class="item-value"><input type="text" name="address" value="<%= user.getAddress() %>" required></div>
                    </div>
                    <div class="profile-list-item">
                        <div class="item-label">💼 Account Role</div>
                        <div class="item-value readonly-value"><%= user.getRole() != null ? user.getRole() : "Customer" %></div>
                    </div>
                    <div class="profile-list-item">
                        <div class="item-label">📅 Account Created</div>
                        <div class="item-value date-value"><%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(user.getCreatedDate()) %></div>
                    </div>
                </div>
                
                <div class="profile-buttons">
                    <button type="submit" class="btn-edit">👤 Edit Profile</button>
                    <a href="${pageContext.request.contextPath}/logout" class="btn-logout">↪ Logout</a>
                </div>
            </form>
        </div>
    </div>
    
    <jsp:include page="footer.jsp" />
</body>
</html>
