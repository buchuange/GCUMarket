package com.star.market.buyer.service.impl;

import com.star.market.buyer.dao.BuyerDao;
import com.star.market.buyer.domain.Buyer;
import com.star.market.buyer.service.BuyerService;
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

@Service("buyerService")
public class BuyerServiceImpl implements BuyerService {

    @Resource(name = "buyerDao")
    private BuyerDao buyerDao;
    @Override
    public Buyer login(String loginAct, String loginPwd) throws LoginException {

        loginPwd = MD5Util.getMD5(loginPwd);

        Map<String, String> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);

        Buyer buyer = buyerDao.login(map);

        if (buyer == null) {
            throw new LoginException("账号或密码错误，请重新输入！");
        }

        String lockState = buyer.getLockState();
        if ("0".equals(lockState)) {
            throw new LoginException("账号涉嫌违规操作已被冻结，请联系管理员！");
        }
        return buyer;
    }

    @Override
    public boolean updatePwd(Buyer buyer, String oldPwd, String newPwd, String id) throws UpdatePwdException {

        boolean flag = true;

        oldPwd = MD5Util.getMD5(oldPwd);

        String loginPwd = buyer.getLoginPwd();
        if (!oldPwd.equals(loginPwd)) {
            throw new UpdatePwdException("旧密码错误，请重新输入！");
        }

        String editTime = DateTimeUtil.getSysTime();
        String editBy = buyer.getRealName();
        newPwd = MD5Util.getMD5(newPwd);

        Map<String, String> map = new HashMap<>();
        map.put("newPwd", newPwd);
        map.put("id", buyer.getId());
        map.put("editBy", editBy);
        map.put("editTime", editTime);

        int count = buyerDao.updatePwd(map);
        if (count != 1) {
            flag = false;
        }

        return flag;
    }

    @Override
    public PaginationVO<Buyer> pageList(int pageNum, int pageSize, String name) {

        pageNum = (pageNum - 1) * pageSize;

        Map<String, Object> map = new HashMap<>();
        map.put("pageNum", pageNum);
        map.put("pageSize", pageSize);
        map.put("name", name);

        int total = buyerDao.getTotalByCondition(map);
        List<Buyer> dataList = buyerDao.getBuyerListByCondition(map);

        PaginationVO<Buyer> vo = new PaginationVO<>();
        vo.setDataList(dataList);
        vo.setTotal(total);
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

        int count = buyerDao.updateStatus(map);
        if (count != 1) {
            flag = false;
        }
        return flag;
    }

    @Override
    public Buyer getBuyerById(String id) {

        Buyer buyer = buyerDao.getBuyerById(id);
        String status = buyer.getLockState();
        if ("0".equals(status)) {
            buyer.setLockState("账号已被封号");
        } else {
            buyer.setLockState("账号正常启用");
        }
        return buyer;
    }
}
