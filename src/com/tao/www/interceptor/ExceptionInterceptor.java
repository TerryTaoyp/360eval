package com.tao.www.interceptor;

//import javax.servlet.http.HttpServletRequest;

import com.jfinal.aop.Interceptor;
import com.jfinal.aop.Invocation;
import com.jfinal.core.Controller;

public class ExceptionInterceptor implements Interceptor{
	@SuppressWarnings("unused")
	public void intercept(Invocation ai) {
		Controller controller = ai.getController();
		//HttpServletRequest request = controller.getRequest();
		try {
			ai.invoke();
		} catch (Exception e) {
			System.out.println("产生异常!");
			e.printStackTrace();
		}
	}
}
