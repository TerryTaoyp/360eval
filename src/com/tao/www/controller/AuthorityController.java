package com.tao.www.controller;

import java.util.ArrayList;
import java.util.List;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.controller.method.AuthorityControllerMethod;
import com.tao.www.controller.sql.AuthorityControllerSql;
import com.tao.www.model.Authority;
import com.tao.www.model.RoleToAuthority;

public class AuthorityController extends Controller {
	AuthorityControllerMethod authorityControllerMethod = new AuthorityControllerMethod();
	public String message = "{\"message\":\"success!\"}";
	public void index(){
		this.render("authority.jsp");
	}
	
	public void init(){
		this.renderJson(JsonKit.toJson(authorityControllerMethod.tinit()));
	}
	
	//@Before(LoginValidator. class) //数据校验拦截器
	/**
	 * 获得Authority列表
	 */
	public void getAuthorityList(){
		StringBuffer sb = authorityControllerMethod.tgetAuthorityList();
		this.renderJson(sb.toString());
	}
	
	/**
	 * 增加Authority
	 */
	public void addAuthority(){
		authorityControllerMethod.taddAuthority();
		this.renderJson(message);
	}
	
	/**
	 * 更新Authority
	 */
	public void updateAuthority(){
		authorityControllerMethod.tupdateAuthority();
		this.renderJson(message);
	}
	
	public void removeAuthority(){
		authorityControllerMethod.tremoveAuthority();
		this.renderJson(message);
	}
	
	public void batchRemoveAuthority(){
		authorityControllerMethod.tbatchRemoveAuthority();
		this.renderJson(message);
	}
	
	//获取菜单
	public void getMenu(){
		//renderJson(getTree(0));
		List<Authority> al = getSessionAttr("auList");
		renderJson( authorityControllerMethod.getTree2(al));
	}
	
	public void getAuthorityTree(){
		StringBuffer sb = authorityControllerMethod.getAuthorityTree();
		this.renderJson(sb.toString());
	}
}
