package com.star.market.business.web.controller;

import com.star.market.buyer.domain.OrderInfo;
import com.star.market.buyer.domain.OrderItem;
import com.star.market.buyer.service.OrderService;
import com.star.market.buyer.service.ShoppingCartService;
import com.star.market.vo.PaginationVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/workbench/business/transaction")
public class TransactionController {

    @Resource(name = "shoppingCartService")
    private ShoppingCartService shoppingCartService;

    @Resource(name = "orderService")
    private OrderService orderService;

    @ResponseBody
    @RequestMapping("/pageList")
    public PaginationVO<OrderItem> pageList(int pageNum, int pageSize, OrderItem item) {

        PaginationVO<OrderItem> vo = shoppingCartService.pageList(pageNum, pageSize, item);

        return vo;
    }

    @ResponseBody
    @RequestMapping("/getInfo")
    public OrderInfo getInfo(String orderNumber) {

        OrderInfo info = orderService.getInfo(orderNumber);

        return info;
    }

    @ResponseBody
    @RequestMapping("/deliverGoods")
    public Map<String, Object> deliverGoods(String id) {

        boolean flag = shoppingCartService.deliverGoods(id);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }
}
