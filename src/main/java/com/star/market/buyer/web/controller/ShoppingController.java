package com.star.market.buyer.web.controller;

import com.star.market.business.domain.Product;
import com.star.market.business.domain.ProductRemark;
import com.star.market.business.service.ProductRemarkService;
import com.star.market.business.service.ProductService;
import com.star.market.buyer.domain.Buyer;
import com.star.market.buyer.domain.OrderItem;
import com.star.market.buyer.service.ShoppingCartService;
import com.star.market.vo.PaginationVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/workbench/buyer/shopping")
public class ShoppingController {

    @Resource(name = "productService")
    private ProductService productService;

    @Resource(name = "shoppingCartService")
    private ShoppingCartService shoppingCartService;

    @Resource(name = "productRemarkService")
    private ProductRemarkService productRemarkService;

    @ResponseBody
    @RequestMapping("/pageList")
    public PaginationVO<Product> pageList(int pageNum, int pageSize, Product product) {

        PaginationVO<Product> vo = productService.getShoppingList(pageNum, pageSize, product);

        return vo;
    }

    @RequestMapping("/detail")
    public ModelAndView detail(String id) {

        ModelAndView mv = new ModelAndView();
        Product product = productService.getProductById(id);
        mv.addObject("product", product);
        mv.setViewName("detail.jsp");

        return mv;
    }

    @ResponseBody
    @RequestMapping("/saveCart")
    public Map<String, Object> saveCart(OrderItem item) {

        boolean flag = shoppingCartService.saveCart(item);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }

    @ResponseBody
    @RequestMapping("/saveOrder")
    public Map<String, Object> saveOrder(HttpSession session, OrderItem item, String contactsPhone, String orderDestination) {

        Buyer buyer = (Buyer) session.getAttribute("user");
        String createBy = buyer.getRealName();

        boolean flag = shoppingCartService.saveOrder(item, createBy, contactsPhone, orderDestination);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }

    @ResponseBody
    @RequestMapping("/getRemarkListByPId")
    public List<ProductRemark> getRemarkListByPId(String productId) {

        List<ProductRemark> list = productRemarkService.getRemarkListByPId(productId);

        return list;
    }
}
