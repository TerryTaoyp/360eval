package com.tao.www.controller;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.Grade;

public class GradeController extends Controller {


	public void index(){
		this.render("grade.jsp");
	}
	//@Before(LoginValidator. class) //数据校验拦截器
	public void getGradeList(){
		String search = getPara("search");
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from t_grade";
		}else{
			sqlExpectSelect = "from t_grade where gname like '%"+search+"%'";
		}
		System.out.println("sqlExpectSelect:"+sqlExpectSelect);
		//分页查
		Page<Grade> gradePage = Grade.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"select *",
				sqlExpectSelect);
		int total = gradePage.getTotalRow();
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(gradePage.getList())+"}");
		this.renderJson(sb.toString());
		
	}
	
	
	public void addGrade(){
		Grade grade = getModel(Grade.class);
		grade.save();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void updateGrade(){
		Grade grade = getModel(Grade.class);
		grade.update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void removeGrade(){
		int gid = getParaToInt("gid");
		Grade.dao.deleteById(gid);
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchRemoveGrade(){
		String[] gidStrArr = getPara("gids").split(",");
		for(String gid : gidStrArr){
			Grade.dao.deleteById(gid);
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
}
