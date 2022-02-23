package com.star.market.business.web.controller;

import com.star.market.business.domain.Business;
import com.star.market.business.domain.Product;
import com.star.market.business.domain.ProductRemark;
import com.star.market.business.service.ProductRemarkService;
import com.star.market.business.service.ProductService;
import com.star.market.buyer.domain.OrderItem;
import com.star.market.buyer.service.ShoppingCartService;
import com.star.market.utils.DateTimeUtil;
import com.star.market.utils.UUIDUtil;
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
@RequestMapping("/workbench/business/product")
public class ProductController {

    @Resource(name = "productService")
    private ProductService productService;

    @Resource(name = "productRemarkService")
    private ProductRemarkService productRemarkService;

    @Resource(name = "shoppingCartService")
    private ShoppingCartService shoppingCartService;


    @ResponseBody
    @RequestMapping("/save")
    public Map<String, Object> save(HttpSession session, Product product) {

        Business business = (Business) session.getAttribute("user");

        String businessId = business.getId();
        String createBy = business.getContacts();

        product.setId(UUIDUtil.getUUID());
        product.setBusinessId(businessId);
        product.setCreateBy(createBy);
        product.setCreateTime(DateTimeUtil.getSysTime());

        boolean flag = productService.save(product);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }

    @ResponseBody
    @RequestMapping("/pageList")
    public PaginationVO<Product> pageList(int pageNum, int pageSize, Product product) {

        PaginationVO<Product> vo = productService.pageList(pageNum, pageSize, product);

        return vo;
    }

    @ResponseBody
    @RequestMapping("/updateStatus")
    public Map<String, Object> updateStatus(HttpSession session, Product product) {

        Business business = (Business) session.getAttribute("user");

        product.setEditBy(business.getContacts());
        product.setEditTime(DateTimeUtil.getSysTime());

        boolean flag = productService.updateStatus(product);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }

    @ResponseBody
    @RequestMapping("/getProductById")
    public Product getProductById(String id) {

        Product product = productService.getProductById(id);

        return product;
    }

    @ResponseBody
    @RequestMapping("/update")
    public Map<String, Object> update(HttpSession session, Product product, String categoryName) {

        Business business = (Business) session.getAttribute("user");

        product.setEditBy(business.getContacts());
        product.setEditTime(DateTimeUtil.getSysTime());

        boolean flag = productService.updateInfo(product);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }

    @ResponseBody
    @RequestMapping("/delete")
    public Map<String, Object> delete(String[] id) {

        boolean flag = productService.delete(id);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }

    @RequestMapping("/detail")
    public ModelAndView detail(String id) {

        ModelAndView mv = new ModelAndView();

        Product product = productService.getProductById(id);
        String status = product.getStatus();
        if ("0".equals(status)) {
            product.setStatus("该商品已下架");
        } else {
            product.setStatus("该商品正在上架售卖");
        }
        mv.addObject("product", product);
        mv.setViewName("detail.jsp");

        return mv;
    }

    @ResponseBody
    @RequestMapping("/getRemarkListByPId")
    public List<ProductRemark> getRemarkListByPId(String productId) {

        List<ProductRemark> list = productRemarkService.getRemarkListByPId(productId);
        return list;
    }

    @ResponseBody
    @RequestMapping("/deleteProductRemark")
    public Map<String, Object> deleteProductRemark(String id) {


        boolean flag = productRemarkService.deleteProductRemark(id);

        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);
        return map;
    }

    @ResponseBody
    @RequestMapping("/showTransactionList")
    public List<OrderItem> showTransactionList(String productId) {

        List<OrderItem> list = shoppingCartService.showTransactionList(productId);

        return list;
    }
}
