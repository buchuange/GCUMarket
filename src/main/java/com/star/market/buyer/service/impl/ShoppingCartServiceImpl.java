package com.star.market.buyer.service.impl;

import com.star.market.business.dao.ProductDao;
import com.star.market.business.domain.Product;
import com.star.market.buyer.dao.OrderDao;
import com.star.market.buyer.dao.ShoppingCartDao;
import com.star.market.buyer.domain.OrderInfo;
import com.star.market.buyer.domain.OrderItem;
import com.star.market.buyer.service.ShoppingCartService;
import com.star.market.utils.UUIDUtil;
import com.star.market.vo.PaginationVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("shoppingCartService")
public class ShoppingCartServiceImpl implements ShoppingCartService {

    @Resource(name = "shoppingCartDao")
    private ShoppingCartDao shoppingCartDao;

    @Resource(name = "orderDao")
    private OrderDao orderDao;

    @Resource(name = "productDao")
    private ProductDao productDao;

    @Override
    public boolean saveCart(OrderItem item) {

        boolean flag = true;

        double goodsAmount = item.getGoodsNumber() * item.getGoodsPrice();

        item.setGoodsAmount(goodsAmount);
        item.setPayStatus("0");

        int count = shoppingCartDao.saveCart(item);

        if (count != 1) {
            flag = false;
        }
        return flag;
    }

    @Transactional
    @Override
    public boolean saveOrder(OrderItem item, String createBy, String contactsPhone, String orderDestination) {

        boolean flag = true;

        String orderNumber = UUIDUtil.getUUID();
        double goodsAmount = item.getGoodsNumber() * item.getGoodsPrice();

        item.setGoodsAmount(goodsAmount);
        item.setOrderNumber(orderNumber);
        item.setPayStatus("1");

        int count = shoppingCartDao.saveCart(item);
        if (count != 1) {
            flag = false;
        }

        OrderInfo order = new OrderInfo();
        order.setBuyerId(item.getBuyerId());
        order.setContactsPhone(contactsPhone);
        order.setOrderNumber(orderNumber);
        order.setOrderDestination(orderDestination);
        order.setOrderPrice(goodsAmount);
        order.setOrderStatus("进行中");
        order.setCreateTime(item.getCreateTime());
        order.setCreateBy(createBy);

        int count2 = orderDao.save(order);
        if (count2 != 1) {
            flag = false;
        }

        Map<String, Object> map = new HashMap<>();
        map.put("id", item.getProductId());
        map.put("goodsNumber", item.getGoodsNumber());
        map.put("editTime", item.getCreateTime());
        map.put("editBy", createBy);

        int count3 = productDao.updateInventory(map);
        if (count3 != 1) {
            flag = false;
        }

        return flag;
    }

    @Override
    public List<OrderItem> getCartList(String buyerId) {

        List<OrderItem> list = shoppingCartDao.getCartList(buyerId);

        return list;
    }

    @Override
    public List<OrderItem> showTransactionList(String productId) {

        List<OrderItem> list = shoppingCartDao.showTransactionList(productId);

        return list;
    }

    @Override
    public PaginationVO<OrderItem> pageList(int pageNum, int pageSize, OrderItem item) {

        pageNum = (pageNum - 1) * pageSize;

        Map<String, Object> map = new HashMap<>();

        map.put("pageNum", pageNum);
        map.put("pageSize", pageSize);
        map.put("goodsName", item.getGoodsName());
        map.put("businessId", item.getBusinessId());

        int total = shoppingCartDao.getTotalByCondition(map);

        List<OrderItem> dataList = shoppingCartDao.getSaleListByCondition(map);

        PaginationVO<OrderItem> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        return vo;
    }

    @Override
    public boolean deliverGoods(String id) {
        boolean flag = true;

        int count = shoppingCartDao.deliverGoods(id);
        if (count != 1) {
            flag = false;
        }

        return flag;
    }
}
