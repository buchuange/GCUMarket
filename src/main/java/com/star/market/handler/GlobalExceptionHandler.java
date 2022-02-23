package com.star.market.handler;

import com.star.market.exception.LoginException;
import com.star.market.exception.UpdatePwdException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {


    @ResponseBody
    @ExceptionHandler(LoginException.class)
    public Map<String, Object> dealLoginException(LoginException e) {

        e.printStackTrace();

        String msg = e.getMessage();

        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        map.put("msg", msg);

        return map;
    }

    @ResponseBody
    @ExceptionHandler(UpdatePwdException.class)
    public Map<String, Object> dealUpdatePwdException(UpdatePwdException e) {

        String msg = e.getMessage();

        Map<String, Object> map = new HashMap<>();
        map.put("success", false);
        map.put("msg", msg);

        return map;
    }

    @ExceptionHandler
    public void doOtherException(Exception e) {
        e.printStackTrace();
    }
}
