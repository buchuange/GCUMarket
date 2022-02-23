package com.star.market.business.web.controller;

import com.star.market.business.domain.Business;
import com.star.market.business.service.BusinessService;
import com.star.market.exception.LoginException;
import com.star.market.exception.UpdatePwdException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/business/user")
public class BusinessController {

    @Resource(name = "businessService")
    private BusinessService businessService;

    @ResponseBody
    @RequestMapping("/login")
    public Map<String, Object> login(HttpSession session, String loginAct, String loginPwd) throws LoginException {

        Business business = businessService.login(loginAct, loginPwd);

        session.setAttribute("user", business);
        Map<String, Object> map = new HashMap<>();
        map.put("success", true);

        return map;
    }

    @ResponseBody
    @RequestMapping("/updatePwd")
    public Map<String, Object> updatePwd(HttpSession session, String oldPwd, String newPwd, String id) throws UpdatePwdException {

        Business business = (Business) session.getAttribute("user");
        boolean flag = businessService.updatePwd(business, oldPwd, newPwd, id);

        session.removeAttribute("user");
        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }
}
