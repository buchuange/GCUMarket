package com.star.market.settings.web.controller;

import com.star.market.buyer.domain.Buyer;
import com.star.market.buyer.service.BuyerService;
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
@RequestMapping("/workbench/settings/buyer")
public class BuyerAccessController {

    @Resource(name = "buyerService")
    private BuyerService buyerService;

    @ResponseBody
    @RequestMapping("/pageList")
    public PaginationVO<Buyer> pageList(int pageNum, int pageSize, String name) {

        PaginationVO<Buyer> vo = buyerService.pageList(pageNum, pageSize, name);

        return vo;
    }

    @ResponseBody
    @RequestMapping("/updateStatus")
    public Map<String, Object> updateStatus(HttpSession session, String id, String lockState) {

        Manager manager = (Manager) session.getAttribute("user");

        String editBy = manager.getRealName();

        boolean flag = buyerService.updateStatus(editBy, id, lockState);
        Map<String, Object> map = new HashMap<>();
        map.put("success", flag);

        return map;
    }

    @RequestMapping("/detail")
    public ModelAndView detail(String id) {
        ModelAndView mv = new ModelAndView();

        Buyer buyer = buyerService.getBuyerById(id);
        mv.addObject("buyer", buyer);
        mv.setViewName("detail.jsp");

        return mv;
    }
}
