package com.tao.www.handler;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.jfinal.handler.Handler;

public class PostfixSkipHandler extends Handler { 

	@Override
	public void handle(String target, HttpServletRequest request,HttpServletResponse response, boolean[] isHandled) {
			int index = target.lastIndexOf(".jsp");
		    if (index != -1)
		      target = target.substring(0, index);
		    nextHandler.handle(target, request, response, isHandled);
		
	}
	}