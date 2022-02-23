package com.star.market.settings.service.impl;

import com.star.market.exception.LoginException;
import com.star.market.exception.UpdatePwdException;
import com.star.market.settings.dao.ManagerDao;
import com.star.market.settings.domain.Manager;
import com.star.market.settings.service.ManagerService;
import com.star.market.utils.MD5Util;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

@Service("managerService")
public class ManagerServiceImpl implements ManagerService {

    @Resource(name = "managerDao")
    private ManagerDao managerDao;

    @Override
    public Manager login(String loginAct, String loginPwd, String ip) throws LoginException {

        Map<String, String> map = new HashMap<>();
        map.put("loginAct", loginAct);
        map.put("loginPwd", loginPwd);

        Manager manager = managerDao.login(map);

        if (manager == null) {
            throw new LoginException("账号或密码错误，请重新输入！");
        }

        String allowIps = manager.getAllowIps();
        if (!allowIps.contains(ip)) {
            throw new LoginException("IP地址受限，不允许访问本站！");
        }
        return manager;
    }

    @Override
    public boolean updatePwd(Manager manager, String oldPwd, String newPwd, String id) throws UpdatePwdException {

        boolean flag = true;

        oldPwd = MD5Util.getMD5(oldPwd);
        String loginPwd = manager.getLoginPwd();
        if (!oldPwd.equals(loginPwd)) {
            throw new UpdatePwdException("旧密码错误，请重新输入！");
        }

        newPwd = MD5Util.getMD5(newPwd);
        int count = managerDao.updatePwd(newPwd, id);
        if (count != 1) {
            flag = false;
        }

        return flag;
    }
}
