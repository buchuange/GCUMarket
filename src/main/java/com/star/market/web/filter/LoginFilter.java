package com.star.market.web.filter;

import  com.star.market.vo.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        // 进入到验证有没有登录过的过滤器

        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String path = request.getServletPath();

        // 不应该被拦截的资源，自动放行请求
        if (path.contains("login.jsp")) {
            filterChain.doFilter(request, response);
        } else {  // 其它资源必须验证有没有登录过
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            // 如果user不为null, 说明登录过
            if (user != null) {
                filterChain.doFilter(request, response);
            } else {  // 没有登录过

                // 重定向到登录页
                String contextPath = request.getContextPath(); // /项目名
                response.sendRedirect(contextPath + "/manager_login.jsp");
            }
        }
    }
}
