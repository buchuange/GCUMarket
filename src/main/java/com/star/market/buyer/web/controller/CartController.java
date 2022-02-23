package com.star.market.buyer.web.controller;

import com.star.market.buyer.domain.Buyer;
import com.star.market.buyer.domain.OrderInfo;
import com.star.market.buyer.domain.OrderItem;
import com.star.market.buyer.service.OrderService;
import com.star.market.buyer.service.ShoppingCartService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/buyer/cart")
public class CartController {

    @Resource(name = "shoppingCartService")
    private ShoppingCartService shoppingCartService;

    @Resource(name = "orderService")
    private OrderService orderService;

    @ResponseBody
    @RequestMapping("/pageList")
    public List<OrderItem> pageList(HttpSession session) {

        Buyer buyer = (Buyer) session.getAttribute("user");

        String buyerId = buyer.getId();

        List<OrderItem> list = shoppingCartService.getCartList(buyerId);

        return list;
    }

    @ResponseBody
    @RequestMapping("/generateOrder")
    public Map<String, Object> generateOrder(HttpSession session, OrderInfo order, String[] id) {

        Buyer buyer = (Buyer) session.getAttribute("user");

        boolean flag = orderService.generateOrder(buyer, order, id);
        Map<String, Object> map = new HashMap<>();

        map.put("success", flag);
        return map;
    }
}
