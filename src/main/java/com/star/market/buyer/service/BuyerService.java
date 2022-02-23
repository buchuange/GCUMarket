package com.star.market.buyer.service;

import com.star.market.buyer.domain.Buyer;
import com.star.market.exception.LoginException;
import com.star.market.exception.UpdatePwdException;
import com.star.market.vo.PaginationVO;

public interface BuyerService {
    Buyer login(String loginAct, String loginPwd) throws LoginException;

    boolean updatePwd(Buyer buyer, String oldPwd, String newPwd, String id) throws UpdatePwdException;

    PaginationVO<Buyer> pageList(int pageNum, int pageSize, String name);

    boolean updateStatus(String editBy, String id, String lockState);

    Buyer getBuyerById(String id);
}
