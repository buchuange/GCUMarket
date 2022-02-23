package com.star.market.settings.service;

import com.star.market.exception.LoginException;
import com.star.market.exception.UpdatePwdException;
import com.star.market.settings.domain.Manager;

public interface ManagerService {

    Manager login(String loginAct, String loginPwd, String ip) throws LoginException;

    boolean updatePwd(Manager manager, String oldPwd, String newPwd, String id) throws UpdatePwdException;
}
