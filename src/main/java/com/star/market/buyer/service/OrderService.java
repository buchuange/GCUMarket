package com.star.market.buyer.service;

import com.star.market.buyer.domain.Buyer;
import com.star.market.buyer.domain.OrderInfo;
import com.star.market.buyer.domain.OrderItem;
import com.star.market.vo.PaginationVO;

import java.util.List;

public interface OrderService {

    boolean generateOrder(Buyer buyer, OrderInfo order, String[] id);

    PaginationVO<OrderInfo> pageList(int pageNum, int pageSize, OrderInfo info);

    List<OrderItem> getGoodsList(String orderNumber);

    boolean confirmHarvest(String id, String orderNumber, String editBy);

    boolean cancelOrder(String id, String editBy);

    OrderInfo getInfo(String orderNumber);
}
