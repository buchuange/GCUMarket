package com.star.market.business.dao;

import com.star.market.business.domain.Business;

import java.util.List;
import java.util.Map;

public interface BusinessDao {

    Business login(Map<String, String> map);

    int updatePwd(Map<String, String> map);

    int getTotalByCondition(Map<String, Object> map);

    List<Business> getBusinessListByCondition(Map<String, Object> map);

    int updateStatus(Map<String, String> map);

    Business getBusinessById(String id);

    int updateExpireTime(Business business);
}
