package com.star.market.business.service.impl;

import com.star.market.business.dao.BusinessDao;
import com.star.market.business.domain.Business;
import com.star.market.business.service.BusinessService;
import com.star.market.exception.LoginException;
import com.star.market.exception.UpdatePwdException;
import com.star.market.utils.DateTimeUtil;
import com.star.market.utils.MD5Util;
import com.star.market.vo.PaginationVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service("businessService")
public class BusinessServiceImpl implements BusinessService {

    @Resource(name = "businessDao")
    private BusinessDao businessDao;
    @Override
    public Business login(String loginAct, String loginPwd) throws LoginException {

        loginPwd = MD5Util.getMD5(loginPwd);

        Map<String, String> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);

        Business business = businessDao.login(map);

        if (business == null) {
            throw new LoginException("账号或密码错误，请重新输入！");
        }

        String expireTime = business.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime) < 0) {
            throw new LoginException("账号已失效，请联系管理员！");
        }

        String lockState = business.getLockState();
        if ("0".equals(lockState)) {
            throw new LoginException("账号涉嫌违规操作已被冻结，请联系管理员！");
        }
        return business;
    }

    @Override
    public boolean updatePwd(Business business, String oldPwd, String newPwd, String id) throws UpdatePwdException {

        boolean flag = true;

        oldPwd = MD5Util.getMD5(oldPwd);

        String loginPwd = business.getLoginPwd();
        if (!oldPwd.equals(loginPwd)) {
            throw new UpdatePwdException("旧密码错误，请重新输入！");
        }

        String editTime = DateTimeUtil.getSysTime();
        String editBy = business.getContacts();
        newPwd = MD5Util.getMD5(newPwd);

        Map<String, String> map = new HashMap<>();
        map.put("newPwd", newPwd);
        map.put("id", business.getId());
        map.put("editBy", editBy);
        map.put("editTime", editTime);

        int count = businessDao.updatePwd(map);
        if (count != 1) {
            flag = false;
        }

        return flag;
    }

    @Override
    public PaginationVO<Business> pageList(int pageNum, int pageSize, Business business) {


        pageNum = (pageNum - 1) * pageSize;

        Map<String, Object> map = new HashMap<>();
        map.put("name", business.getName());
        map.put("contacts", business.getContacts());
        map.put("pageNum", pageNum);
        map.put("pageSize", pageSize);

        int total = businessDao.getTotalByCondition(map);

        List<Business> dataList = businessDao.getBusinessListByCondition(map);

        PaginationVO<Business> vo = new PaginationVO<>();
        vo.setTotal(total);
        vo.setDataList(dataList);

        return vo;
    }

    @Override
    public boolean updateStatus(String editBy, String id, String lockState) {

        boolean flag = true;

        String editTime = DateTimeUtil.getSysTime();

        Map<String, String> map = new HashMap<>();
        map.put("id", id);
        map.put("lockState", lockState);
        map.put("editTime", editTime);
        map.put("editBy", editBy);

        int count = businessDao.updateStatus(map);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }

    @Override
    public Business getBusinessById(String id) {

        Business business = businessDao.getBusinessById(id);

        String status = business.getLockState();
        if ("0".equals(status)) {
            business.setLockState("账号已被封号");
        } else {
            business.setLockState("账号正常启用");
        }

        return business;
    }

    @Override
    public boolean updateExpireTime(Business business) {
        boolean flag = true;

        String editTime = DateTimeUtil.getSysTime();
        business.setEditTime(editTime);

        int count = businessDao.updateExpireTime(business);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }
}
