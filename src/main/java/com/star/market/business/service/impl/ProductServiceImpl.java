package com.star.market.business.service.impl;

import com.star.market.business.dao.ProductDao;
import com.star.market.business.domain.Product;
import com.star.market.business.service.ProductService;
import com.star.market.vo.PaginationVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("productService")
public class ProductServiceImpl implements ProductService {

    @Resource(name = "productDao")
    private ProductDao productDao;

    @Override
    public boolean save(Product product) {

        boolean flag = true;

        int count = productDao.save(product);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }

    @Override
    public PaginationVO<Product> pageList(int pageNum, int pageSize, Product product) {

        pageNum = (pageNum - 1) * pageSize;

        Map<String, Object> map = new HashMap<>();

        map.put("pageNum", pageNum);
        map.put("pageSize", pageSize);
        map.put("name", product.getName());
        map.put("category", product.getCategory());
        map.put("businessId", product.getBusinessId());

        int total = productDao.getTotalByCondition(map);

        List<Product> dataList = productDao.getProductListByCondition(map);

        PaginationVO<Product> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        return vo;
    }

    @Override
    public boolean updateStatus(Product product) {

        boolean flag = true;

        int count = productDao.updateStatus(product);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }

    @Override
    public Product getProductById(String id) {

        Product product = productDao.getProductById(id);
        return product;
    }

    @Override
    public boolean updateInfo(Product product) {
        boolean flag = true;

        int count = productDao.updateInfo(product);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }

    @Override
    public boolean delete(String[] id) {

        boolean flag = true;

        int count = productDao.delete(id);

        if (count != id.length) {
            flag = false;
        }

        return flag;
    }

    @Override
    public PaginationVO<Product> getShoppingList(int pageNum, int pageSize, Product product) {

        pageNum = (pageNum - 1) * pageSize;

        Map<String, Object> map = new HashMap<>();
        map.put("pageNum", pageNum);
        map.put("pageSize", pageSize);
        map.put("name", product.getName());
        map.put("category", product.getCategory());

        int total = productDao.getTotal(map);

        List<Product> dataList = productDao.getShoppingList(map);

        PaginationVO<Product> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        return vo;
    }
}
