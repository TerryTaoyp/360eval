package com.tao.www.controller;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.EmployeeQuestionBasic;
import com.tao.www.model.EmployeeQuestionStandard;

public class EmployeeQuestionStandardController extends Controller {


	public void index(){
		this.render("employeeQuestionStandard.jsp");
	}
	//@Before(LoginValidator. class) //数据校验拦截器
	public void getEmployeeQuestionStandardList(){
		String eqbid = getPara("eqbid");
		String search = getPara("search");
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from t_employee_question_standard eqs "
					+ "inner join t_employee_question_basic eqb on eqs.eqbid=eqb.eqbid where eqs.eqbid="+eqbid;
		}else{
			sqlExpectSelect = "from t_employee_question_standard eqs "
					+ "inner join t_employee_question_basic eqb on eqs.eqbid=eqb.eqbid where eqs.eqbid="+eqbid
					+" and eqs.eqsname like '%"+search+"%'";
		}
		
		System.out.println("sqlExpectSelect:"+sqlExpectSelect);
		//分页查
		Page<EmployeeQuestionStandard> employeeQuestionStandardPage = EmployeeQuestionStandard.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"select eqs.*,eqb.eqbbasic eqbbasic",
				sqlExpectSelect);
		int total = employeeQuestionStandardPage.getTotalRow();
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(employeeQuestionStandardPage.getList())+"}");
		this.renderJson(sb.toString());
	}
	
	
	public void addEmployeeQuestionStandard(){
		EmployeeQuestionStandard employeeQuestionStandard = getModel(EmployeeQuestionStandard.class);
		long eqbid = employeeQuestionStandard.getLong("eqbid");
		long eqsscale = employeeQuestionStandard.getLong("eqsscale");
		EmployeeQuestionBasic eqb = EmployeeQuestionBasic.dao.findById(eqbid);
		eqb.set("eqbscale", eqsscale+eqb.getLong("eqbscale")).update(); //更新当前的要素比重
		employeeQuestionStandard.save();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void updateEmployeeQuestionStandard(){
		EmployeeQuestionStandard employeeQuestionStandard = getModel(EmployeeQuestionStandard.class);
		int oldeqsscale = getParaToInt("oldeqsscale");
		long eqbid = employeeQuestionStandard.getLong("eqbid");
		long eqsscale = employeeQuestionStandard.getLong("eqsscale");
		EmployeeQuestionBasic eqb = EmployeeQuestionBasic.dao.findById(eqbid);
		eqb.set("eqbscale", eqsscale-oldeqsscale+eqb.getLong("eqbscale")).update(); //更新当前的要素比重
		employeeQuestionStandard.update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void removeEmployeeQuestionStandard(){
		int eqsid = getParaToInt("eqsid");//标准的id
		int eqbid = getParaToInt("eqbid");//要素的id
		int eqsscale = getParaToInt("eqsscale");//标准的比重
		EmployeeQuestionStandard.dao.deleteById(eqsid);
		EmployeeQuestionBasic eqb = EmployeeQuestionBasic.dao.findById(eqbid);
		eqb.set("eqbscale", eqb.getLong("eqbscale")-eqsscale).update(); //更新当前的要素比重
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchRemoveEmployeeQuestionStandard(){
		String[] eqsidStrArr = getPara("eqsids").split(",");
		String[] eqsscaleStrArr = getPara("eqsscales").split(",");
		int eqbid = getParaToInt("eqbid");//要素的id
		int total = 0;
		int index = 0;
		for(String eqsid : eqsidStrArr){
			EmployeeQuestionStandard.dao.deleteById(eqsid);
			total += Integer.parseInt(eqsscaleStrArr[index]);
			index++;
		}
		EmployeeQuestionBasic eqb = EmployeeQuestionBasic.dao.findById(eqbid);
		eqb.set("eqbscale", eqb.getLong("eqbscale")-total).update(); //更新当前的要素比重
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void getRemainNum(){
		int dtid = getParaToInt("dtid");
		int rid = getParaToInt("rid");
		int eqsid = getParaToInt("eqsid");
		Number rNum = Db.queryNumber("select SUM(eqs.eqsscale) rNum from "
				+ "t_employee_question_standard eqs "
				+ "inner join t_employee_question_basic eqb  on eqs.eqbid=eqb.eqbid where (eqb.dtid=" + dtid
				+" or eqb.eqbiscommon=1) and eqb.rid=" + rid + " and eqs.eqsid!="+ eqsid) ;
		int nowNum = 100;
		if(rNum!=null){
			nowNum = nowNum -rNum.intValue();
		}
		this.renderJson("{\"remainNum\":"+nowNum+"}");
	}
}
