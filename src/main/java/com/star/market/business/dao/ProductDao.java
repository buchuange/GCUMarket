package com.star.market.business.dao;

import com.star.market.business.domain.Product;

import java.util.List;
import java.util.Map;

public interface ProductDao {
    int save(Product product);

    int getTotalByCondition(Map<String, Object> map);

    List<Product> getProductListByCondition(Map<String, Object> map);

    int updateStatus(Product product);

    Product getProductById(String id);

    int updateInfo(Product product);

    int delete(String[] id);

    int getTotal(Map<String, Object> map);

    List<Product> getShoppingList(Map<String, Object> map);

    int updateInventory(Map<String, Object> map);

    int addInventory(Map<String, Object> map);
}
