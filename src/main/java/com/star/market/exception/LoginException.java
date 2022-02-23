package com.star.market.exception;

public class LoginException extends Exception{

    public LoginException() {
        System.out.println("你好");
        System.out.println("你好1");
        System.out.println("你好2");
    }

    public LoginException(String message) {
        super(message);
    }
}
