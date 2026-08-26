<%@ page import="java.sql.*, com.foodhub.utility.DBConnection" %>
<%
try (Connection conn = DBConnection.getConnection();
     Statement stmt = conn.createStatement()) {
    ResultSet rs = stmt.executeQuery("SHOW TABLES");
    out.print("Tables: ");
    while(rs.next()) {
        out.print(rs.getString(1) + ", ");
    }
    
    out.print("<br>Trying SELECT * FROM favourite WHERE user_id = 1: ");
    try {
        ResultSet rs2 = stmt.executeQuery("SELECT * FROM favourite WHERE user_id = 1");
        while(rs2.next()) {
            out.print("fav_id=" + rs2.getInt(1) + " ");
        }
    } catch(Exception e) {
        out.print("Error: " + e.getMessage());
    }
} catch (Exception e) {
    out.print("Connection Error: " + e.getMessage());
}
%>
