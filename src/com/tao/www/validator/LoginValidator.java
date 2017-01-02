package com.tao.www.validator;

import com.jfinal.core.Controller;
import com.jfinal.validate.Validator;

public class LoginValidator extends Validator {
	protected void validate(Controller c) {
		//validateRequiredString("userName", "nameMsg", "请输入用户名");
		validateString("userName", 3, 20, "nameMsg", "范围为3-20");
	}
	
	protected void handleError(Controller c) {
		c.keepPara("userName");
		//默认约定  错误返回页 视图名为 当前方法名
		c.render("/index.jsp");
	}
}