package com.star.market.buyer.web.controller;

import com.star.market.business.domain.ProductRemark;
import com.star.market.business.service.ProductRemarkService;
import com.star.market.buyer.domain.OrderInfo;
import com.star.market.buyer.domain.OrderItem;
import com.star.market.buyer.service.OrderService;
import com.star.market.vo.PaginationVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/buyer/order")
public class OrderController {

    @Resource(name = "orderService")
    private OrderService orderService;

    @Resource(name = "productRemarkService")
    private ProductRemarkService productRemarkService;

    @ResponseBody
    @RequestMapping("/pageList")
    public PaginationVO<OrderInfo> pageList(int pageNum, int pageSize, OrderInfo info) {

        PaginationVO<OrderInfo> vo = orderService.pageList(pageNum, pageSize, info);

        return vo;
    }

    @ResponseBody
    @RequestMapping("/getGoodsList")
    public List<OrderItem> getGoodsList(String orderNumber) {

        List<OrderItem> list = orderService.getGoodsList(orderNumber);

        return list;
    }

    @ResponseBody
    @RequestMapping("/cancelOrder")
    public Map<String, Object> cancelOrder(String id, String editBy) {

        boolean flag = orderService.cancelOrder(id, editBy);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }


    @ResponseBody
    @RequestMapping(value = "/confirmHarvest")
    public Map<String, Object> confirmHarvest(String id, String orderNumber, String editBy) {

        boolean flag = orderService.confirmHarvest(id, orderNumber, editBy);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }

    @ResponseBody
    @RequestMapping("/updateRemark")
    public Map<String, Object> updateRemark(ProductRemark remark) {

        boolean flag = productRemarkService.addRemark(remark);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }
}
