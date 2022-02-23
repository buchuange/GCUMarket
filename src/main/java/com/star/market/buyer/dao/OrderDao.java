package com.star.market.buyer.dao;

import com.star.market.buyer.domain.OrderInfo;
import com.star.market.buyer.domain.OrderItem;

import java.util.List;
import java.util.Map;

public interface OrderDao {
    int save(OrderInfo order);

    int getTotalByCondition(Map<String, Object> map);

    List<OrderInfo> getOrderListByCondition(Map<String, Object> map);

    int updateStatus(Map<String, Object> map);

    OrderInfo getInfo(String orderNumber);
}
