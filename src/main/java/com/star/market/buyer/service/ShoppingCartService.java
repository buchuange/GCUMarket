package com.star.market.buyer.service;

import com.star.market.buyer.domain.OrderItem;
import com.star.market.vo.PaginationVO;

import java.util.List;

public interface ShoppingCartService {
    boolean saveCart(OrderItem item);

    boolean saveOrder(OrderItem item, String createBy, String contactsPhone, String orderDestination);

    List<OrderItem> getCartList(String buyerId);

    List<OrderItem> showTransactionList(String productId);

    PaginationVO<OrderItem> pageList(int pageNum, int pageSize, OrderItem item);

    boolean deliverGoods(String id);
}
