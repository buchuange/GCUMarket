package com.star.market.settings.dao;

import com.star.market.settings.domain.Manager;
import org.apache.ibatis.annotations.Param;

import java.util.Map;

public interface ManagerDao {

    Manager login(Map<String, String> map);

    int updatePwd(@Param("newPwd") String newPwd, @Param("id") String id);
}
