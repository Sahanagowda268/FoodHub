package com.foodhub.DAO;

import com.foodhub.model.OrderTable;
import java.util.List;

public interface OrderTableDAO {
    int addOrder(OrderTable order);
    OrderTable getOrder(int orderId);
    void updateOrder(OrderTable order);
    void deleteOrder(int orderId);
    List<OrderTable> getAllOrders();
    List<OrderTable> getOrdersByUser(int userId);
}
