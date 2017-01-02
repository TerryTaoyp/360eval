package com.tao.www.controller;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.Progress;
import com.tao.www.model.Statistic;

public class ProgressController extends Controller {

	public void index(){
		Statistic sc = getSessionAttr("sc");
		long sid = 0L;
		if(sc!=null){
			sid = sc.getLong("sid");
		}
		long evalTotal = Db.queryLong("select count(eid) from t_progress where sid="+sid);//查询当前测评下已经参与测评的人的总数
		long eeTotal = Db.queryLong("select count(e.eid) from t_employee e "
				+ "INNER JOIN t_employee_role er on e.eid=er.eid "
				+ "INNER JOIN t_role r on r.rid=er.rid "
				+ "where e.isactive=1 "
				+ "and r.rname not like '%董%事%长%' and r.rname not like '%系%统%管%理%员%'");//当前能够参与测评的人的数量
		setAttr("evalTotal", evalTotal);
		setAttr("eeTotal", eeTotal);
		this.render("progress.jsp");
	}
	
	public void getProgressList(){
		String search = getPara("search");
		String sqlExpectSelect = null;
		Statistic sc = getSessionAttr("sc");
		long sid = 0L;
		if(sc!=null){
			sid = sc.getLong("sid");
		}
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from  t_employee e inner join t_department d on e.did=d.did "
					+ "INNER JOIN t_employee_role er on e.eid=er.eid "
					+ "INNER JOIN t_role r on r.rid=er.rid "
					+ "left join t_progress p  on e.eid=p.eid "
					+ "where e.isactive=1 and (p.sid="+sid+" or p.sid is null) ";
		}else{ 
			sqlExpectSelect = "from  t_employee e inner join t_department d on e.did=d.did "
					+ "INNER JOIN t_employee_role er on e.eid=er.eid "
					+ "INNER JOIN t_role r on r.rid=er.rid "
					+ "left join t_progress p  on e.eid=p.eid "
					+ "where e.isactive=1 and (e.zname like '%"+search+"%' or d.dname like '%"+search+"%') "
					+ "and (p.sid="+sid+" or p.sid is null) ";
		}
		sqlExpectSelect += " and r.rname not like '%董%事%长%' and r.rname not like "
				+ "'%系%统%管%理%员%' group by e.eid order by d.did,r.rid";
		//System.out.println(sqlExpectSelect);
		//分页查
		Page<Progress> progressPage = Progress.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"select e.eid,e.did,group_concat(r.rname SEPARATOR '|') rname,p.pid,p.siseval,concat(dpnum,concat('/',dtnum)) dnum,"
				+ "concat(edpnum,concat('/',edtnum)) ednum,concat(eepnum,concat('/',eetnum)) eenum,e.zname,d.dname",
				sqlExpectSelect);
		int total = progressPage.getTotalRow();
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(progressPage.getList())+"}");
		this.renderJson(sb.toString());
	}
	
	public void addOrUpdateProgress(){
		Statistic sc = getSessionAttr("sc");
		if(sc!=null){
			//先去查看进度表里面有没有数据
			int eid = getParaToInt("eid");
			int did = getParaToInt("did");
			long sid = sc.getLong("sid");
			String rName = getPara("rname").trim();//要生成或修改进度的角色的名称
			Progress ps = Progress.dao.findFirst("select * from t_progress where sid="+sid
					+" and eid="+eid);
			boolean isExist = true;
			if(ps==null){
				ps = new Progress();
				isExist = false;//如果为空则标记原来不存在,这个时候是save,否则update
			}
			String str2 = "直属副总经理";
		
				/*
				 * 2.部门测评,根据角色去确定
				 */
				String sqlExpectSelect1 = null;
				//当前登录人只有一个直属副总经理角色,就从对应配置表里取他能测评的部门
				if(str2.indexOf(rName.trim())>-1){
					sqlExpectSelect1 = "select count(ed.did) from t_employee_department ed "
							+ "inner join t_department d on ed.did=d.did where ed.eid= "+eid;
				}else{
					sqlExpectSelect1 = "select count(did) from t_department d where 1=1 ";
				}
				//应测评部门数,实际测评数
				ps.set("dtnum", Db.queryLong(sqlExpectSelect1));
				
				/**
				 * 3.部门经理评价,也根据角色去确定
				 */
				String sqlExpectSelect2 = null;
				if(str2.indexOf(rName.trim())>-1){
					StringBuffer ed = new StringBuffer();
					ed.append("select count(eid) from ( select e.*,dt.dtid,r.rid,d.dname  FROM t_employee_employee ee ")
					   .append("INNER JOIN t_employee e on ee.eeid=e.eid ")
					   .append("INNER JOIN t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid  ")
					   .append("INNER JOIN t_employee_role er on ee.eeid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%部%门%经%理%' and e.isactive=1 and ee.eid="+eid)
					   .append(" UNION ")
					   .append("select e.*,dt.dtid,r.rid,d.dname from t_employee_department ed ")
					   .append("INNER JOIN t_employee e on ed.did=e.did ")
					   .append("inner join t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
					   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%部%门%经%理%' and e.isactive=1 and ed.eid="+eid+" ) aa");
					sqlExpectSelect2 = ed.toString();
				}else{
					//其他角色可以测评所有部门经理
					sqlExpectSelect2 = "select count(eid) from (select e.*,dt.dtid,r.rid,d.dname from t_employee e "
							+ "inner join t_employee_role er on e.eid=er.eid "
							+ "inner join t_department d on d.did=e.did "
							+ "inner join t_department_type dt on dt.dtid=d.dtid "
							+ "inner join t_role r on er.rid=r.rid where r.rname like '%部%门%经%理%' "
							+ "and e.isactive=1) aa";
				}
				//应测评部门经理数,实际测评数
				ps.set("edtnum", Db.queryLong(sqlExpectSelect2));
				
				/**
				 * 4.普通员工评价,也根据角色去确定
				 */
				//先去查询额外配置表
				StringBuffer ee = new StringBuffer();
				ee.append("select count(eid) from ( select e.*,dt.dtid,r.rid,d.dname  FROM t_employee_employee ee ")
				   .append("INNER JOIN t_employee e on ee.eeid=e.eid ")
				   .append("INNER JOIN t_department d on e.did=d.did ")
				   .append("inner join t_department_type dt on dt.dtid=d.dtid  ")
				   .append("INNER JOIN t_employee_role er on ee.eeid=er.eid ")
				   .append("INNER JOIN t_role r on r.rid=er.rid ")
				   .append("where r.rname like '%普%通%员%工%' and e.isactive=1 and ee.eid="+eid);
				//如果角色里面还有部门经理或者普通员工角色,则加入该角色对应部门的员工列表
				if(rName.contains("部门经理")||rName.contains("普通员工")){
					ee.append(" UNION ")
					   .append("select e.*,dt.dtid,r.rid,d.dname from t_employee e ")
					   .append("inner join t_employee_role er on e.eid=er.eid  ")
					   .append("inner join t_department d on d.did=e.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
					   .append("inner join t_role r on er.rid=r.rid where r.rname like '%员%工%' ")
					   .append("and e.isactive=1 and d.did="+did);
				}
			    ee.append(" ) aa");
			    //应测评普通员工数,实际测评数
				ps.set("eetnum", Db.queryLong(ee.toString()));
				
				if(isExist){
					//如果存在,则只通过查询去更新应参评的数量
					ps.update();
				}else{
					/*
					 * 1.满意度测评,直接设置为未测评
					 */
					//如果不存在
					//满意度未测评
					ps.set("sid", sid);
					ps.set("eid", eid);
					ps.set("siseval", 0);
					ps.set("dpnum", 0);
					ps.set("edpnum", 0);
					ps.set("eepnum", 0);
					ps.save();
					
				}
			}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
}
