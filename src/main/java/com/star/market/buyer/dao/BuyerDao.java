package com.star.market.buyer.dao;

import com.star.market.buyer.domain.Buyer;

import java.util.List;
import java.util.Map;

public interface BuyerDao {

    Buyer login(Map<String, String> map);

    int updatePwd(Map<String, String> map);

    int getTotalByCondition(Map<String, Object> map);

    List<Buyer> getBuyerListByCondition(Map<String, Object> map);

    int updateStatus(Map<String, String> map);

    Buyer getBuyerById(String id);
}
