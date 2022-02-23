package com.star.market.settings.web.controller;

import com.star.market.business.domain.Business;
import com.star.market.business.service.BusinessService;
import com.star.market.settings.domain.Manager;
import com.star.market.vo.PaginationVO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/workbench/settings/business")
public class BusinessAccessController {

    @Resource(name = "businessService")
    private BusinessService businessService;

    @ResponseBody
    @RequestMapping("/pageList")
    public PaginationVO<Business> pageList(int pageNum, int pageSize, Business business) {

        // 展现商家列表
        PaginationVO<Business> vo = businessService.pageList(pageNum, pageSize, business);

        return vo;
    }

    @ResponseBody
    @RequestMapping("/updateStatus")
    public Map<String, Object> updateStatus(HttpSession session, String id, String lockState) {

        Manager manager = (Manager) session.getAttribute("user");

        String editBy = manager.getRealName();

        boolean flag = businessService.updateStatus(editBy, id, lockState);
        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }

    @RequestMapping("/detail")
    public ModelAndView detail(String id) {
        ModelAndView mv = new ModelAndView();

        Business business = businessService.getBusinessById(id);
        mv.addObject("business", business);
        mv.setViewName("detail.jsp");

        return mv;
    }

    @ResponseBody
    @RequestMapping("/getBusinessById")
    public Business getBusinessById(String id) {
        Business business = businessService.getBusinessById(id);
        return business;
    }

    @ResponseBody
    @RequestMapping("/updateExpireTime")
    public Map<String, Object> updateExpireTime(HttpSession session,Business business) {

        Manager manager = (Manager) session.getAttribute("user");

        String editBy = manager.getRealName();

        business.setEditBy(editBy);
        boolean flag = businessService.updateExpireTime(business);
        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }
}
