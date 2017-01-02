package com.tao.www.controller;


import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.tao.www.model.DepartmentResult;
import com.tao.www.model.Employee;
import com.tao.www.model.EmployeeResult;
import com.tao.www.model.SatisfyResult;
import com.tao.www.model.Statistic;

public class StatisticController extends Controller {

	public void index(){
		this.render("statistic.jsp");
	}
	//@Before(LoginValidator. class) //数据校验拦截器
	//statistic Statistic
	public void getStatisticList(){
		String search = getPara("search");
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from t_statistic";
		}else{
			sqlExpectSelect = "from t_statistic where sname like '%"+search+"%'";
		}
		System.out.println("sqlExpectSelect:"+sqlExpectSelect);
		//分页查
		Page<Statistic> statisticPage = Statistic.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				//"select sid,sname,date_format(stime,'%Y-%m-%d') stime,"
				//+ "date_format(etime,'%Y-%m-%d') etime,stype,sisactive",
				"select *",
				sqlExpectSelect);
		int total = statisticPage.getTotalRow();
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(statisticPage.getList())+"}");
		this.renderJson(sb.toString());
	}
	
	
	public void addStatistic(){
		Statistic statistic = getModel(Statistic.class);
		statistic.save();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void editStatistic(){
		Statistic statistic = getModel(Statistic.class);
		statistic.update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void updateStatistic(){
		int sid = getParaToInt("sid");
		int sisactive = getParaToInt("sisactive");
		//如果当前这个要设置为启用,则把之前的启用的设置为停用
		if(sisactive==1){
			Statistic sc = 	Statistic.dao.findFirst("select * from t_statistic where sisactive=1");
			if(sc!=null){
				sc.set("sisactive", 0).update();
			}
			//修改当前状态
			sc = Statistic.dao.findById(sid).set("sisactive", sisactive);
			setSessionAttr("sc", sc);
			sc.update();
		}else{//如果停用则删除会话中的sc
			Statistic sc = Statistic.dao.findById(sid).set("sisactive", sisactive);
			sc.update();
			removeSessionAttr("sc");
		}
		
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void removeStatistic(){
		int sid = getParaToInt("sid");
		Statistic.dao.deleteById(sid);
		renderJson("{\"message\":\"success!\"}");
	}
	public void batchRemoveStatistic(){
		String[] sidStrArr = getPara("sids").split(",");
		for(String sid : sidStrArr){
			Statistic.dao.deleteById(sid);
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void dataManage(){
		List<String> typeList= new ArrayList<String>();
		typeList.add("满意度测评");
		typeList.add("部门测评");
		typeList.add("部门经理测评");
		typeList.add("普通员工测评");
		List<Statistic> statisticList= Statistic.dao.find("select sid,sname from t_statistic");
		setAttr("statisticList", statisticList);
		setAttr("typeList", typeList);
		int type = getParaToInt("type",0);
		int sid = getParaToInt("sid",0);
		String name = getPara("name","").trim();
		setAttr("type", type);
		setAttr("sid", sid);
		setAttr("name", name);
		List<Model> rList = null;
		Employee em = Employee.dao.findFirst("select eid from t_employee where zname='"+name+"'");
		if(em!=null){
			if(type==1){//满意度测评
				/*Db.update("delete FROM  t_satisfy_result_detail WHERE srid = "
						+ "(SELECT srid from t_satisfy_result where eid="+em.getLong("eid")+")");
				Db.update("delet from  t_satisfy_result where eid="+em.getLong("eid"));*/
				
				SatisfyResult sr = SatisfyResult.dao.findFirst("select sr.srid id,sc.sname eval,sr.srtotal total from t_satisfy_result sr "
						+ "inner join t_statistic sc on sr.sid=sc.sid where sr.eid ="+em.getLong("eid"));
				sr.put("obj", "长春担保");
				sr.put("type","满意度测评");
				sr.put("typeParam",1);
				rList = new ArrayList<Model>();
				rList.add(sr);
				
				
			}else if(type==2){//部门测评
				List<DepartmentResult> dr = DepartmentResult.dao.find("select dr.drid id,d.dname obj,sc.sname eval,dr.drtotal total from t_department_result dr "
						+ "inner join t_statistic sc on dr.sid=sc.sid "
						+ "inner join t_department d on dr.did = d.did "
						+ "where dr.eid ="+em.getLong("eid"));
				rList = new ArrayList<Model>();
				for(DepartmentResult d:dr){
					d.put("type","部门测评");
					d.put("typeParam",2);
					rList.add(d);
				}
			}else if(type==3){//部门经理测评
				List<EmployeeResult> edr = EmployeeResult.dao.find("select er.erid id,e.zname obj,sc.sname eval,er.ertotal total from t_employee_result er "
						+ "inner join t_statistic sc on er.sid=sc.sid "
						+ "inner join t_employee e on er.eid = e.eid "
						+ "inner join t_employee_role el on er.eid = el.eid "
						+ "inner join t_role r on el.rid =r.rid "
						+ "where er.erothereid = "
						+ em.getLong("eid")
						+ " and r.rname like '%部%门%经%理%'");
				rList = new ArrayList<Model>();
				for(EmployeeResult ed:edr){
					ed.put("type","部门经理测评");
					ed.put("typeParam",3);
					rList.add(ed);
				}
			}else if(type==4){//普通员工测评
				List<EmployeeResult> eer = EmployeeResult.dao.find("select er.erid id,e.zname obj,sc.sname eval,er.ertotal total from t_employee_result er "
						+ "inner join t_statistic sc on er.sid=sc.sid "
						+ "inner join t_employee e on er.eid = e.eid "
						+ "inner join t_employee_role el on er.eid = el.eid "
						+ "inner join t_role r on el.rid =r.rid "
						+ "where er.erothereid = "
						+ em.getLong("eid")
						+ " and r.rname like '%普%通%员%工%'");
				rList = new ArrayList<Model>();
				for(EmployeeResult ee:eer){
					ee.put("type","普通员工测评");
					ee.put("typeParam",4);
					rList.add(ee);
				}
			}
		}
		setAttr("rList", rList);
		render("dataManage.jsp");
	}
	
	public void remove(){
		int type = getParaToInt("type",0);
		int id = getParaToInt("id",0);
		
		if(type==1){//满意度测评
			Db.update("delete FROM  t_satisfy_result_detail WHERE srid = "+id);
			Db.update("delete from  t_satisfy_result where srid="+id);
		}else if(type==2){//部门测评
			Db.update("delete FROM  t_department_result_detail WHERE drid = "+id);
			Db.update("delete from  t_department_result where drid="+id);
		}else if(type==3){//部门经理测评
			Db.update("delete FROM  t_employee_result_detail WHERE erid = "+id);
			Db.update("delete from  t_employee_result where erid="+id);
		}else if(type==4){//部门员工 测评
			Db.update("delete FROM  t_employee_result_detail WHERE erid = "+id);
			Db.update("delete from  t_employee_result where erid="+id);
		}
		
		this.renderJson("{\"message\":\"success\"}");
	}
	
}
