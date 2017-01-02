package com.tao.www.controller.sql;

import com.jfinal.core.Controller;

public class AuthorityControllerSql extends Controller{
	
	
	public String authorityListSql = "select aid,aname from t_authority where apath='#'";
	/**
	 * 初始化页面，获取所有的Authority的方法所对应的sql语句
	 */
	public String sqlExpectSelect1 = "from t_authority ta left join t_authority pta on ta.aparent=pta.aid";
	String search = getPara("search");
	public String sqlExpectSelect2 = "from t_authority ta left join t_authority pta on ta.aparent=pta.aid  where ta.aname like '%"+search+"%'";
	//分页所对应的sql语句
	public String authorityPageSql = "select ta.aid aid,ta.aname aname,ta.apath apath,pta.aname paname,ta.atype atype,ta.aparent aparent";
	
	public String authorityListSql1 = "select a.aid aid,a.aname aname,"
			+ "a.aparent aparent,a.apath apath,ra.rid rid from "
			+ " t_authority a left join t_role_authority ra on a.aid=ra.aid group by a.aid";
}
