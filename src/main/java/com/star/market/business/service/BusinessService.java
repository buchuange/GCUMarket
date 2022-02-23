package com.star.market.business.service;

import com.star.market.business.domain.Business;
import com.star.market.exception.LoginException;
import com.star.market.exception.UpdatePwdException;
import com.star.market.vo.PaginationVO;

public interface BusinessService {
    Business login(String loginAct, String loginPwd) throws LoginException;

    boolean updatePwd(Business business, String oldPwd, String newPwd, String id) throws UpdatePwdException;

    PaginationVO<Business> pageList(int pageNum, int pageSize, Business business);

    boolean updateStatus(String editBy, String id, String lockState);

    Business getBusinessById(String id);

    boolean updateExpireTime(Business business);
}
