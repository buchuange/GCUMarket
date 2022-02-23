package com.star.market.settings.web.controller;

import com.star.market.exception.LoginException;
import com.star.market.exception.UpdatePwdException;
import com.star.market.settings.domain.Manager;
import com.star.market.settings.service.ManagerService;
import com.star.market.utils.MD5Util;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/settings/user")
public class ManagerController {

    @Resource(name = "managerService")
    private ManagerService managerService;

    @ResponseBody
    @RequestMapping("/login")
    public Map<String, Object> login(HttpServletRequest request, String loginAct, String loginPwd) throws LoginException {

        loginPwd = MD5Util.getMD5(loginPwd);

        String ip = request.getRemoteAddr();
        Manager manager = managerService.login(loginAct, loginPwd, ip);

        request.getSession().setAttribute("user", manager);

        Map<String, Object> map = new HashMap<>();
        map.put("success", true);

        return map;
    }

    @ResponseBody
    @RequestMapping("/updatePwd")
    public Map<String, Object> updatePwd(HttpSession session, String oldPwd, String newPwd, String id) throws UpdatePwdException {

        Manager manager = (Manager) session.getAttribute("user");

        boolean flag = managerService.updatePwd(manager, oldPwd, newPwd, id);

        session.removeAttribute("user");
        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }
}
