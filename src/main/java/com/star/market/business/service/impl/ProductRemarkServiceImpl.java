package com.star.market.business.service.impl;

import com.star.market.business.dao.ProductRemarkDao;
import com.star.market.business.domain.ProductRemark;
import com.star.market.business.service.ProductRemarkService;
import com.star.market.utils.DateTimeUtil;
import com.star.market.utils.UUIDUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("productRemarkService")
public class ProductRemarkServiceImpl implements ProductRemarkService {

    @Resource(name = "productRemarkDao")
    private ProductRemarkDao productRemarkDao;

    @Override
    public boolean addRemark(ProductRemark remark) {

        boolean flag = true;

        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateTimeUtil.getSysTime());

        int count = productRemarkDao.addRemark(remark);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }

    @Override
    public List<ProductRemark> getRemarkListByPId(String productId) {

        List<ProductRemark> list = productRemarkDao.getRemarkListByPId(productId);

        return list;
    }

    @Override
    public boolean deleteProductRemark(String id) {

        boolean flag = true;

        int count = productRemarkDao.deleteProductRemark(id);
        if (count != 1) {
            flag = false;
        }

        return flag;
    }
}
