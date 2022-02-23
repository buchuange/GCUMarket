package com.star.market.business.dao;

import com.star.market.business.domain.ProductRemark;

import java.util.List;

public interface ProductRemarkDao {
    int addRemark(ProductRemark remark);

    List<ProductRemark> getRemarkListByPId(String productId);

    int deleteProductRemark(String id);
}
