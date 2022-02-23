package com.star.market.buyer.service.impl;

import com.star.market.business.dao.ProductDao;
import com.star.market.buyer.dao.OrderDao;
import com.star.market.buyer.dao.ShoppingCartDao;
import com.star.market.buyer.domain.Buyer;
import com.star.market.buyer.domain.OrderInfo;
import com.star.market.buyer.domain.OrderItem;
import com.star.market.buyer.service.OrderService;
import com.star.market.utils.DateTimeUtil;
import com.star.market.utils.UUIDUtil;
import com.star.market.vo.PaginationVO;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

@Service("orderService")
public class OrderServiceImpl implements OrderService {

    @Resource(name = "shoppingCartDao")
    private ShoppingCartDao shoppingCartDao;

    @Resource(name = "orderDao")
    private OrderDao orderDao;

    @Resource(name = "productDao")
    private ProductDao productDao;


    @Transactional
    @Override
    public boolean generateOrder(Buyer buyer, OrderInfo order, String[] id) {

        boolean flag = true;

        String orderNumber = UUIDUtil.getUUID();

        order.setOrderNumber(orderNumber);
        order.setBuyerId(buyer.getId());
        order.setOrderStatus("进行中");
        order.setCreateTime(DateTimeUtil.getSysTime());
        order.setCreateBy(buyer.getRealName());

        int count1 = orderDao.save(order);
        if (count1 != 1) {
            flag = false;
        }

        for (String cartId: id) {

            Map<String, Object> map = new HashMap<>();
            map.put("id", cartId);
            map.put("orderNumber", orderNumber);
            int count2 = shoppingCartDao.updatePayStatus(map);
            if (count2 != 1) {
                flag = false;
            }

            OrderItem item = shoppingCartDao.getCartById(cartId);

            Map<String, Object> map1 = new HashMap<>();
            map1.put("id", item.getProductId());
            map1.put("goodsNumber", item.getGoodsNumber());
            map1.put("editTime", DateTimeUtil.getSysTime());
            map1.put("editBy", buyer.getRealName());

            int count3 = productDao.updateInventory(map1);
            if (count3 != 1) {
                flag = false;
            }

        }
        return flag;
    }


    @Override
    public PaginationVO<OrderInfo> pageList(int pageNum, int pageSize, OrderInfo info) {

        pageNum = (pageNum - 1) * pageSize;

        Map<String, Object> map = new HashMap<>();
        map.put("pageNum", pageNum);
        map.put("pageSize", pageSize);
        map.put("buyerId", info.getBuyerId());
        map.put("orderNumber", info.getOrderNumber());

        int total = orderDao.getTotalByCondition(map);
        List<OrderInfo> dataList= orderDao.getOrderListByCondition(map);

        PaginationVO<OrderInfo> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        return vo;
    }

    @Override
    public List<OrderItem> getGoodsList(String orderNumber) {

        List<OrderItem> list = shoppingCartDao.getGoodsList(orderNumber);

        return list;
    }

    @Override
    public boolean confirmHarvest(String id, String orderNumber, String editBy) {

        boolean flag = true;

        int count = shoppingCartDao.confirmHarvest(id);
        if (count != 1) {
            flag = false;
        }

        boolean isUpdate = true;
        List<OrderItem> list = shoppingCartDao.getGoodsList(orderNumber);
        Iterator<OrderItem> iterator = list.iterator();
        while (iterator.hasNext()) {
            OrderItem item = iterator.next();
            if (!"2".equals(item.getDeliveryStatus())) {
                isUpdate = false;
            }
        }

        if (isUpdate) {
            Map<String, Object> map = new HashMap<>();
            map.put("orderStatus", "交易完成");
            map.put("orderNumber", orderNumber);
            map.put("editTime", DateTimeUtil.getSysTime());
            map.put("editBy", editBy);

            int count1 = orderDao.updateStatus(map);
            if (count1 != 1) {
                flag = false;
            }
        }

        return flag;
    }

    @Transactional
    @Override
    public boolean cancelOrder(String id, String editBy) {
        boolean flag = true;

        int count = shoppingCartDao.cancelOrder(id);
        if (count != 1) {
            flag = false;
        }

        OrderItem item = shoppingCartDao.getCartById(id);

        Map<String, Object> map = new HashMap<>();
        map.put("id", item.getProductId());
        map.put("goodsNumber", item.getGoodsNumber());
        map.put("editTime", DateTimeUtil.getSysTime());
        map.put("editBy", editBy);

        int count2 = productDao.addInventory(map);

        if (count2 != 1) flag = false;

        return flag;
    }

    @Override
    public OrderInfo getInfo(String orderNumber) {

        OrderInfo info = orderDao.getInfo(orderNumber);

        return info;
    }
}
