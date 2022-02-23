package com.star.market.settings.domain;

import com.star.market.vo.User;

import java.util.Objects;

public class Manager extends User {

    private String id;
    private String loginAct;
    private String realName;
    private String loginPwd;
    private String email;
    private String allowIps;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLoginAct() {
        return loginAct;
    }

    public void setLoginAct(String loginAct) {
        this.loginAct = loginAct;
    }

    public String getRealName() {
        return realName;
    }

    public void setRealName(String realName) {
        this.realName = realName;
    }

    public String getLoginPwd() {
        return loginPwd;
    }

    public void setLoginPwd(String loginPwd) {
        this.loginPwd = loginPwd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAllowIps() {
        return allowIps;
    }

    public void setAllowIps(String allowIps) {
        this.allowIps = allowIps;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Manager manager = (Manager) o;
        return Objects.equals(id, manager.id) &&
                Objects.equals(loginAct, manager.loginAct) &&
                Objects.equals(realName, manager.realName) &&
                Objects.equals(loginPwd, manager.loginPwd) &&
                Objects.equals(email, manager.email) &&
                Objects.equals(allowIps, manager.allowIps);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, loginAct, realName, loginPwd, email, allowIps);
    }
}
