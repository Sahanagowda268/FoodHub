<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("loggedInUser") != null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>FoodHub | Login</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css">
<style>
body {
    background-image: url('${pageContext.request.contextPath}/images/hero-bg.jpg');
    background-size: cover;
    background-position: center;
    background-attachment: fixed;
    height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    margin: 0;
    font-family: 'Outfit', sans-serif;
}
.overlay {
    position: absolute;
    top: 0; left: 0; width: 100%; height: 100%;
    background: rgba(0, 0, 0, 0.4);
    z-index: 1;
}
.glass-panel {
    position: relative;
    z-index: 2;
    width: 450px;
    max-width: 90%;
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(15px);
    -webkit-backdrop-filter: blur(15px);
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 20px;
    padding: 40px;
    box-shadow: 0 25px 45px rgba(0, 0, 0, 0.2);
    color: white;
}
.glass-panel h2 {
    font-size: 32px;
    margin: 0 0 10px 0;
    font-weight: 800;
    text-align: center;
}
.subtitle {
    text-align: center;
    margin-bottom: 30px;
    font-size: 15px;
    color: #ffffff;
}
.form-group {
    margin-bottom: 20px;
}
.form-group label {
    display: block;
    font-size: 14px;
    font-weight: 600;
    margin-bottom: 8px;
    color: #ffffff;
}
.form-group input {
    width: 100%;
    padding: 14px 18px;
    background: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 10px;
    font-size: 15px;
    color: white;
    outline: none;
    transition: all 0.3s;
    box-sizing: border-box;
    font-family: inherit;
}
.form-group input::placeholder {
    color: #f8f9fa;
}
.form-group input:focus {
    background: rgba(255, 255, 255, 0.2);
    border-color: rgba(255, 255, 255, 0.5);
    box-shadow: 0 0 15px rgba(255, 255, 255, 0.1);
}
.btn-login {
    width: 100%;
    padding: 15px;
    background: var(--primary);
    color: white;
    border: none;
    border-radius: 10px;
    font-size: 16px;
    font-weight: 700;
    cursor: pointer;
    margin-top: 10px;
    transition: 0.3s;
    box-shadow: var(--shadow);
}
.btn-login:hover {
    background: var(--secondary);
    transform: translateY(-2px);
}
.register-link {
    text-align: center;
    margin-top: 25px;
    font-size: 14px;
    color: #ffffff;
}
.register-link a {
    color: #fff;
    text-decoration: none;
    font-weight: 700;
    border-bottom: 1px solid white;
}
.register-link a:hover {
    color: #ecfdf5;
}
.error { 
    background: rgba(229, 57, 53, 0.2);
    border: 1px solid rgba(229, 57, 53, 0.5);
    color: #ffcdd2; 
    padding: 12px;
    border-radius: 10px;
    text-align: center; 
    margin-bottom: 20px; 
    font-size: 14px;
    font-weight: 600;
}
.home-link {
    display: block;
    text-align: center;
    margin-top: 15px;
    color: #ffffff;
    text-decoration: none;
    font-size: 13px;
}
.home-link:hover { text-decoration: underline; }
</style>
</head>
<body>
    <div class="overlay"></div>
    
    <div class="glass-panel">
        <h2>FoodHub</h2>
        <div class="subtitle">Sign in to continue your food journey</div>
        
        <% 
            String error = (String) request.getAttribute("error");
            if(error != null) { 
        %>
            <div class="error"><%= error %></div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/login" method="post">
            <% 
                String redirectParam = request.getParameter("redirect");
                if (redirectParam != null && !redirectParam.isEmpty()) { 
            %>
                <input type="hidden" name="redirect" value="<%= redirectParam.replace("\"", "&quot;") %>">
            <% } %>
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="Enter your email" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn-login">Login</button>
        </form>
        <div class="register-link">
            Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp">Register here</a>
        </div>
        <a href="${pageContext.request.contextPath}/" class="home-link">&larr; Back to Home</a>
    </div>
</body>
</html>
