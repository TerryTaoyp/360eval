package com.tao.www.controller;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.TotalScale;

public class TotalScaleController extends Controller {


	public void index(){
		this.render("totalScale.jsp");
	}
	//@Before(LoginValidator. class) //数据校验拦截器
	public void getTotalScaleList(){
		String search = getPara("search");
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from t_total_scale";
		}else{
			sqlExpectSelect = "from t_total_scale where tsname like '%"+search+"%'";
		}
		System.out.println("sqlExpectSelect:"+sqlExpectSelect);
		//分页查
		Page<TotalScale> totalScalePage = TotalScale.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"select *",
				sqlExpectSelect);
		int total = totalScalePage.getTotalRow();
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(totalScalePage.getList())+"}");
		this.renderJson(sb.toString());
		
	}
	public void updateTotalScale(){
		TotalScale totalScale = getModel(TotalScale.class);
		totalScale.update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void getRemainNum(){
		String tstype = getPara("tstype");
		int tsid = getParaToInt("tsid");
		Number rNum = Db.queryNumber("select SUM(tsscale) rNum from t_total_scale where tstype='"+tstype+
				"' and tsid!=" + tsid);
		int nowNum = 100;
		if(rNum!=null){
			nowNum = nowNum -rNum.intValue();
		}
		this.renderJson("{\"remainNum\":"+nowNum+"}");
	}
}
