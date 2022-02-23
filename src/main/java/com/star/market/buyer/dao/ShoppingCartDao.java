package com.star.market.buyer.dao;

import com.star.market.buyer.domain.OrderItem;

import java.util.List;
import java.util.Map;

public interface ShoppingCartDao {
    int saveCart(OrderItem item);

    List<OrderItem> getCartList(String buyerId);

    OrderItem getCartById(String cartId);

    int updatePayStatus(Map<String, Object> map);

    List<OrderItem> getGoodsList(String orderNumber);

    int confirmHarvest(String id);

    List<OrderItem> showTransactionList(String productId);

    int cancelOrder(String id);

    int getTotalByCondition(Map<String, Object> map);

    List<OrderItem> getSaleListByCondition(Map<String, Object> map);

    int deliverGoods(String id);
}
