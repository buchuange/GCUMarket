package com.star.market.business.service;

import com.star.market.business.domain.ProductRemark;

import java.util.List;

public interface ProductRemarkService {
    boolean addRemark(ProductRemark remark);

    List<ProductRemark> getRemarkListByPId(String productId);

    boolean deleteProductRemark(String id);
}
