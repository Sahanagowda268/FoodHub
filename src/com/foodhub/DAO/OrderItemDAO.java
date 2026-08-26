package com.foodhub.DAO;

import com.foodhub.model.OrderItem;
import java.util.List;

public interface OrderItemDAO {
    void addOrderItem(OrderItem item);
    OrderItem getOrderItem(int orderItemId);
    void updateOrderItem(OrderItem item);
    void deleteOrderItem(int orderItemId);
    List<OrderItem> getAllOrderItems();
    List<OrderItem> getOrderItemsByOrder(int orderId);
}
