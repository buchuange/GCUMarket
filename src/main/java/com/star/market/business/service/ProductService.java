package com.star.market.business.service;

import com.star.market.business.domain.Product;
import com.star.market.vo.PaginationVO;

public interface ProductService {
    boolean save(Product product);

    PaginationVO<Product> pageList(int pageNum, int pageSize, Product product);

    boolean updateStatus(Product product);

    Product getProductById(String id);

    boolean updateInfo(Product product);

    boolean delete(String[] id);

    PaginationVO<Product> getShoppingList(int pageNum, int pageSize, Product product);
}
