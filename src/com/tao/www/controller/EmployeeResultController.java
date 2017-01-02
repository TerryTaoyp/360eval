package com.tao.www.controller;

import java.io.File;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;






import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.EdCollection;
import com.tao.www.model.EeCollection;
import com.tao.www.model.Employee;
import com.tao.www.model.EmployeeResult;
import com.tao.www.model.EmployeeResultDetail;
import com.tao.www.model.Progress;
import com.tao.www.model.Statistic;
import com.tao.www.model.TotalScale;
import com.tao.www.plugin.HSSFUtil;

public class EmployeeResultController extends Controller {


	public void addEmployeeResult(){
		Integer[] eqsids = this.getParaValuesToInt("eqsids");//这是所有问题的id
		Integer[] eqsscales = this.getParaValuesToInt("eqsscales");//这是所有问题的比重
		int eid = getParaToInt("eid"); //当前被测评人id
		int dtid = getParaToInt("dtid"); //当前被测评人部门类型id
		int rid = getParaToInt("rid"); //当前被测评人部门角色id
		int erdweight = 0;
		long erid = 0; //部门经理结果主键
		int eoid = 0; //选项id
		
		
		Integer[] erdweights = new Integer[eqsids.length];
		int allZero = 0;//得分为零的所有比例之和
		int allZeroCount = 0; //得分为零的个数
		for(int i=0;i<eqsids.length;i++){
			erdweights[i] = getParaToInt("erdweight"+eqsids[i]);//获取到对应的得分
			if(erdweights[i]==0){
				allZero += eqsscales[i]; //加入到为零的总计中
				eqsscales[i] = 0; //然后将当前比例置0
				allZeroCount++;
			}
		}
		int remaind = eqsscales.length - allZeroCount; //剩余不为零的比例个数
		float fenshu = ((float)allZero)/remaind;
		Float[] eqsscalesFloat = new Float[eqsscales.length];
		for(int j=0;j<eqsscales.length;j++){
			if(eqsscales[j]!=0){
				eqsscalesFloat[j] =eqsscales[j]+ fenshu; //均摊为零的比例
			}else{
				eqsscalesFloat[j] = 0f;
			}
		}
		//先插入到部门经理结果表
		Statistic sc = getSessionAttr("sc");
		Employee ee = getSessionAttr("ee");
		EmployeeResult er = null;
		if(sc!=null&&ee!=null){
			//当前用户erothereid 被评人eid 当前测评sid
			EmployeeResult oldEr = EmployeeResult.dao.findFirst("select * from t_employee_result where "
					+ "erothereid="+ee.getLong("eid")+" and sid="+sc.getLong("sid")+" and eid="+eid);
			if(oldEr==null){
				//如果是第一次测评
				 er = new EmployeeResult()
					.set("sid",sc.getLong("sid"))
					.set("erothereid",ee.getLong("eid"))
					.set("eid",eid)
					.set("rid",rid)
					.set("dtid", dtid)
					.set("erftime", new Date());
				er.save();
				erid = er.getLong("erid");
				//更新进度表
				long sid = sc.getLong("sid");
				long seid = ee.getLong("eid");
				//先去查看进度表里面有没有数据
				Progress ps = Progress.dao.findFirst("select * from t_progress where sid="+sid
						+" and eid="+seid);
				if(ps!=null){
					String evalType = getPara("evalType").trim();
					if(evalType.equals("ed")){
						ps.set("edpnum", ps.getLong("edpnum")+1).update();//实际测评部门经理数加1
					}else if(evalType.equals("ee")){
						ps.set("eepnum", ps.getLong("eepnum")+1).update();//实际测评普通员工数加1
					}
				}
			}else{
				//如果是重新测评的话,需要将结果详细表数据删除
				Db.update("delete from t_employee_result_detail where erid ="+oldEr.getLong("erid"));
				erid = oldEr.getLong("erid");
			}
			float total = 0;
			int index = 0;
			for(int i=0;i<eqsids.length;i++){
				erdweight = getParaToInt("erdweight"+eqsids[i]);
				total+= erdweight*eqsscalesFloat[index]/100.0f;
				eoid = getParaToInt("eo"+eqsids[i]);
				EmployeeResultDetail erd = new EmployeeResultDetail()
						.set("erid",erid)
						.set("eqsid", eqsids[i])
						.set("eoid",eoid)
						.set("erdscale", eqsscalesFloat[i])
						.set("erdweight", erdweight);
				erd.save();
				index++;
			}
			//最后再更新结果表里的总分数据
			DecimalFormat df = new DecimalFormat("######0.00");   
			if(oldEr==null){
				er.set("ertotal", df.format(total)).update();
			}else{
				oldEr.set("ertotal", df.format(total)).update();
			}
			
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void submitEmployeeResult(){
		int erid = getParaToInt("erid");
		EmployeeResult.dao.findById(erid).set("erissubmit", 1).update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchSubmitEmployeeResult(){
		String[] eridStrArr = getPara("erids").split(",");
		for(String erid : eridStrArr){
			EmployeeResult.dao.findById(erid).set("erissubmit", 1).update();
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	//普通员工结果列表
	public void getEeList(){
		Employee ee = getSessionAttr("ee");
		String rName = getSessionAttr("rName");//角色名称
		
		String search = getPara("search")==null?"":getPara("search");
		String sqlExpectSelect = null;
		StringBuffer sb = new StringBuffer();
		
		if(ee!=null&&rName!=null){
			if(rName.contains("系统管理员")||rName.contains("董事长")
					||(rName.contains("总经理")&&!rName.contains("直属副总经理"))){
				StringBuffer tsb = new StringBuffer();
				tsb.append("from (select e.*,dt.dtid,r.rid,d.dname from t_employee e ")
				   .append("inner join t_department d on e.did=d.did ")
				   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
				   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
				   .append("INNER JOIN t_role r on r.rid=er.rid ")
				   .append("where r.rname like '%普%通%员%工%' and e.isactive=1")
				   .append(" and e.zname like '%"+search+"%') aa order by aa.dname");
				sqlExpectSelect = tsb.toString();
			}else{
				if(rName.equals("直属副总经理")){//只能查看自己管理的普通员工还有额外配置的
					StringBuffer tsb = new StringBuffer();
					tsb
					   /*.append("from ( select e.*,dt.dtid,r.rid,d.dname  FROM t_employee_employee ee ")
					   .append("INNER JOIN t_employee e on ee.eeid=e.eid ")
					   .append("INNER JOIN t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid  ")
					   .append("INNER JOIN t_employee_role er on ee.eeid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%普%通%员%工%' and e.isactive=1 and ee.eid="+ee.getLong("eid"))
					   .append(" and e.zname like '%"+search+"%'")
					   .append(" UNION ")*/
					   .append("from ( select e.*,dt.dtid,r.rid,d.dname from t_employee_department ed ")
					   .append("INNER JOIN t_employee e on ed.did=e.did ")
					   .append("inner join t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
					   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%普%通%员%工%' and e.isactive=1 and ed.eid="+ee.getLong("eid"))
					   .append(" and e.zname like '%"+search+"%') aa order by aa.dname");
					sqlExpectSelect = tsb.toString();
				}else if(rName.equals("部门经理")||rName.equals("部门副经理")){//只能查看自己还有额外配置的
					StringBuffer tsb = new StringBuffer();
					tsb//这里是额外配置的
					   /*.append("from ( select e.*,dt.dtid,r.rid,d.dname  FROM t_employee_employee ee ")
					   .append("INNER JOIN t_employee e on ee.eeid=e.eid ")
					   .append("INNER JOIN t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid  ")
					   .append("INNER JOIN t_employee_role er on ee.eeid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%普%通%员%工%' and e.isactive=1 and ee.eid="+ee.getLong("eid"))
					   .append(" and e.zname like '%"+search+"%'")
					   .append(" UNION ") */
					   //下面是自己部门的
					   .append("from (select e.*,dt.dtid,r.rid,d.dname from t_employee e ")
					   .append("inner join t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
					   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%普%通%员%工%' and e.isactive=1 and e.did="+ee.getLong("did"))
					   .append(") aa order by aa.dname");
					sqlExpectSelect = tsb.toString();
				}else if(rName.contains("直属副总经理")&&(rName.contains("部门经理")||rName.contains("部门副经理"))){
					StringBuffer tsb = new StringBuffer();
					tsb//这里是额外配置的
					   /*.append("from ( select e.*,dt.dtid,r.rid,d.dname  FROM t_employee_employee ee ")
					   .append("INNER JOIN t_employee e on ee.eeid=e.eid ")
					   .append("INNER JOIN t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid  ")
					   .append("INNER JOIN t_employee_role er on ee.eeid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%普%通%员%工%' and e.isactive=1 and ee.eid="+ee.getLong("eid"))
					   .append(" and e.zname like '%"+search+"%'")
					   .append(" UNION ") */
					   //下面是自己部门的
					   .append("from ( select e.*,dt.dtid,r.rid,d.dname from t_employee e ")
					   .append("inner join t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
					   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%普%通%员%工%' and e.isactive=1 and e.did="+ee.getLong("did"))
					    .append(" UNION ") 
					   //这里是所管理的部门的
					   .append("select e.*,dt.dtid,r.rid,d.dname from t_employee_department ed ")
					   .append("INNER JOIN t_employee e on ed.did=e.did ")
					   .append("inner join t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
					   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%普%通%员%工%' and e.isactive=1 and ed.eid="+ee.getLong("eid"))
					   .append(" and e.zname like '%"+search+"%') aa order by aa.dname");
					sqlExpectSelect = tsb.toString();
				}else{
					//普通员工只能查看自己的
					StringBuffer tsb = new StringBuffer();
					tsb.append("from (select e.*,dt.dtid,r.rid,d.dname from t_employee e ")
					   .append("inner join t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
					   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%普%通%员%工%' and e.isactive=1")
					   .append(" and e.zname like '%"+search+"%'")
					   .append(" and e.eid="+ee.getLong("eid")+") aa order by aa.dname");
					sqlExpectSelect = tsb.toString();
				}
			}
			
			System.out.println("select * " + sqlExpectSelect);
			
			Page<Employee> employeePage = Employee.dao.paginate(
					getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
					getParaToInt("limit", 50),
					"select *",
					sqlExpectSelect);
			int total = employeePage.getTotalRow();
			sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(employeePage.getList())+"}");
			this.renderJson(sb.toString());
			
		}else{
			sb.append("{\"total\":\""+0+"\"").append(",\"rows\":"+"[]"+"}");
			this.renderJson(sb.toString());
		}
	}
	
	//部门经理结果列表
	public void getEdList(){
		Employee ee = getSessionAttr("ee");
		String rName = getSessionAttr("rName");//角色名称
		
		String search = getPara("search")==null?"":getPara("search");
		String sqlExpectSelect = null;
		StringBuffer sb = new StringBuffer();
		
		if(ee!=null&&rName!=null){
			if(rName.contains("系统管理员")||rName.contains("董事长")
					||(rName.contains("总经理")&&!rName.contains("直属副总经理"))){
				StringBuffer tsb = new StringBuffer();
				tsb.append("from (select e.*,dt.dtid,r.rid,d.dname from t_employee e ")
				   .append("inner join t_department d on e.did=d.did ")
				   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
				   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
				   .append("INNER JOIN t_role r on r.rid=er.rid ")
				   .append("where r.rname like '%部%门%经%理%' and e.isactive=1")
				   .append(" and e.zname like '%"+search+"%') aa order by aa.dname");
				sqlExpectSelect = tsb.toString();
			}else{
				if(rName.equals("直属副总经理")){//只能查看自己管理的部门经理还有额外配置的
					StringBuffer tsb = new StringBuffer();
					tsb
					   /*.append("from ( select e.*,dt.dtid,r.rid,d.dname  FROM t_employee_employee ee ")
					   .append("INNER JOIN t_employee e on ee.eeid=e.eid ")
					   .append("INNER JOIN t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid  ")
					   .append("INNER JOIN t_employee_role er on ee.eeid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%部%门%经%理%' and e.isactive=1 and ee.eid="+ee.getLong("eid"))
					   .append(search!=null&&search.length()>0?" and e.zname like '%"+search+"%'":" ")
					   .append(" UNION ")*/
					   .append("from ( select e.*,dt.dtid,r.rid,d.dname from t_employee_department ed ")
					   .append("INNER JOIN t_employee e on ed.did=e.did ")
					   .append("inner join t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
					   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%部%门%经%理%' and e.isactive=1 and ed.eid="+ee.getLong("eid"))
					   .append(" and e.zname like '%"+search+"%') aa order by aa.dname");
					sqlExpectSelect = tsb.toString();
				}else if(rName.equals("部门经理")||rName.equals("部门副经理")){//只能查看自己还有额外配置的
					StringBuffer tsb = new StringBuffer();
					tsb//这里是额外配置的
					  /* .append("from ( select e.*,dt.dtid,r.rid,d.dname  FROM t_employee_employee ee ")
					   .append("INNER JOIN t_employee e on ee.eeid=e.eid ")
					   .append("INNER JOIN t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid  ")
					   .append("INNER JOIN t_employee_role er on ee.eeid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%部%门%经%理%' and e.isactive=1 and ee.eid="+ee.getLong("eid"))
					   .append(" and e.zname like '%"+search+"%'")
					   .append(" UNION ") */
					   //下面是自己的
					   .append("from ( select e.*,dt.dtid,r.rid,d.dname from t_employee e ")
					   .append("inner join t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
					   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%部%门%经%理%' and e.isactive=1 and e.eid="+ee.getLong("eid"))
					   .append(" and e.zname like '%"+search+"%') aa order by aa.dname");
					sqlExpectSelect = tsb.toString();
				}else if(rName.contains("直属副总经理")&&(rName.contains("部门经理")||rName.contains("部门副经理"))){
					StringBuffer tsb = new StringBuffer();
					tsb
					   /*.append("from ( select e.*,dt.dtid,r.rid,d.dname  FROM t_employee_employee ee ")
					   .append("INNER JOIN t_employee e on ee.eeid=e.eid ")
					   .append("INNER JOIN t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid  ")
					   .append("INNER JOIN t_employee_role er on ee.eeid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%部%门%经%理%' and e.isactive=1 and ee.eid="+ee.getLong("eid"))
					   .append(" and e.zname like '%"+search+"%'")
					   .append(" UNION ")*/
					   .append("from ( select e.*,dt.dtid,r.rid,d.dname from t_employee_department ed ")
					   .append("INNER JOIN t_employee e on ed.did=e.did ")
					   .append("inner join t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
					   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%部%门%经%理%' and e.isactive=1 and ed.eid="+ee.getLong("eid"))
					   .append(" and e.zname like '%"+search+"%'")
					   .append(" UNION ") 
					   //下面是自己的
					   .append("select e.*,dt.dtid,r.rid,d.dname from t_employee e ")
					   .append("inner join t_department d on e.did=d.did ")
					   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
					   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
					   .append("INNER JOIN t_role r on r.rid=er.rid ")
					   .append("where r.rname like '%部%门%经%理%' and e.isactive=1 and e.eid="+ee.getLong("eid"))
					   .append(" and e.zname like '%"+search+"%') aa order by aa.dname");
					sqlExpectSelect = tsb.toString();
				}
			}
			
			System.out.println("select * " + sqlExpectSelect);
			
			Page<Employee> employeePage = Employee.dao.paginate(
					getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
					getParaToInt("limit", 50),
					"select *",
					sqlExpectSelect);
			int total = employeePage.getTotalRow();
			sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(employeePage.getList())+"}");
			this.renderJson(sb.toString());
			
		}else{
			sb.append("{\"total\":\""+0+"\"").append(",\"rows\":"+"[]"+"}");
			this.renderJson(sb.toString());
		}
	}
	
	/*//普通员工测评结果
	public void getEeResult(){
		int eid = getParaToInt("eid");
		int sid = getParaToInt("sid");
		StringBuffer sb = new StringBuffer();
		sb.append( "SELECT " ) 
		  .append( "eqbbasic,eqsscale,eqsstandard,eqsid, " ) 	
		  .append( "SUM(IF(etype='自评',average,0)) AS mye, " ) 	
		  .append( "SUM(IF(etype='上级',average,0)) AS upe,  " ) 	
		  .append( "SUM(IF(etype='其他部门同事',average,0)) AS othere,  " ) 	
		  .append( "SUM(IF(etype='部门同事',average,0)) AS departe " ) 	
		  .append( "FROM( " ) 	
		  .append( "SELECT eqb.eqbbasic, " )
		  .append( "CONCAT(eqs.eqsscale,'%') eqsscale, " )
		  .append( "eqs.eqsstandard, " )
		  .append( "getetype(er.eid,er.erothereid) etype, " )
		  .append( "round(avg(erd.erdweight*eqs.eqsscale/100),2) average, " ) 
		  .append( "er.eid,er.erothereid,r.rname,eqs.eqsid " ) 
		  .append( "from t_employee_result_detail erd " ) 
		  .append( "INNER JOIN t_employee_result er on er.erid=erd.erid " ) 
		  .append( "INNER JOIN t_employee_question_standard eqs on eqs.eqsid=erd.eqsid " ) 
		  .append( "INNER JOIN t_employee_question_basic eqb on eqb.eqbid=eqs.eqbid " ) 
		  .append( "INNER JOIN t_employee_role erl on erl.eid = er.erothereid " ) 
		  .append( "INNER JOIN t_role r on r.rid = erl.rid " ) 
		  .append( "where er.eid="+ eid + " and er.sid=" + sid ) 
		  .append( " GROUP BY eqs.eqsid,etype,r.rname " ) 
		  .append( ") a GROUP BY eqsid " );
		
		List<EmployeeResult> eeRtList = EmployeeResult.dao.find(sb.toString());
		
		setAttr("size", eeRtList.size());
        setAttr("eeRtList", eeRtList);
        
        render("eeResult.jsp");
		
	}*/
	
	//普通员工测评结果
	public void getEeResult(){
		int eid = getParaToInt("eid");
		int sid = getParaToInt("sid");
		StringBuffer sb = new StringBuffer();
		sb.append( "SELECT * from t_ee_collection where sid ="+sid) 
		  .append( " and eid=" + eid )
		  .append(" order by eqbbasic");
		
		List<EeCollection> eeRtList = EeCollection.dao.find(sb.toString());
		
		setAttr("size", eeRtList.size());
		setAttr("eeRtList", eeRtList);
		
		List<TotalScale> tsList = TotalScale.dao.find("select * from t_total_scale where tstype like '%普通员工测评%'");
        String tsname = null;
        long tsscale = 0;
        for(TotalScale ts : tsList){
        	tsname = ts.getStr("tsname");
        	tsscale = ts.getLong("tsscale");
        	if(tsname.contains("自评")){
        		setAttr("myeTsscale", tsscale);
        	}else if(tsname.contains("上级")){
        		setAttr("upeTsscale", tsscale);
        	}else if(tsname.contains("其他部门")){
        		setAttr("othereTsscale", tsscale);
        	}else if(tsname.contains("部门同事")){
        		setAttr("departeTsscale", tsscale);
        	}
        }
		render("eeResult.jsp");
	}

	/*//部门经理测评结果
	public void getEdResult(){
		int eid = getParaToInt("eid");
		int sid = getParaToInt("sid");
		StringBuffer sb = new StringBuffer();
		sb.append( "SELECT " ) 
		  .append( "eqbbasic,eqsscale,eqsstandard,eqsid, " ) 	
		  .append( "SUM(IF(dtype='自评',average,0)) AS myd, " ) 	
		  .append( "SUM(IF(dtype='上级',average,0)) AS upd,  " ) 	
		  .append( "SUM(IF(dtype='其他部门同事',average,0)) AS otherd,  " ) 	
		  .append( "SUM(IF(dtype='下属',average,0)) AS departd " ) 	
		  .append( "FROM( " ) 	
		  .append( "SELECT eqb.eqbbasic, " )
		  .append( "CONCAT(eqs.eqsscale,'%') eqsscale, " )
		  .append( "eqs.eqsstandard, " )
		  .append( "getdtype(er.eid,er.erothereid) dtype, " )
		  .append( "round(avg(erd.erdweight*eqs.eqsscale/100),2) average, " ) 
		  .append( "er.eid,er.erothereid,r.rname,eqs.eqsid " ) 
		  .append( "from t_employee_result_detail erd " ) 
		  .append( "INNER JOIN t_employee_result er on er.erid=erd.erid " ) 
		  .append( "INNER JOIN t_employee_question_standard eqs on eqs.eqsid=erd.eqsid " ) 
		  .append( "INNER JOIN t_employee_question_basic eqb on eqb.eqbid=eqs.eqbid " ) 
		  .append( "INNER JOIN t_employee_role erl on erl.eid = er.erothereid " ) 
		  .append( "INNER JOIN t_role r on r.rid = erl.rid " ) 
		  .append( "where er.eid="+ eid + " and er.sid=" + sid) 
		  .append( " GROUP BY eqs.eqsid,dtype,r.rname " ) 
		  .append( ") a GROUP BY eqsid " );
		
		List<EmployeeResult> edRtList = EmployeeResult.dao.find(sb.toString());
		setAttr("size", edRtList.size());
        setAttr("edRtList", edRtList);
        render("edResult.jsp");
	}*/
	
	//部门经理测评结果
	public void getEdResult(){
		int eid = getParaToInt("eid");
		int sid = getParaToInt("sid");
		StringBuffer sb = new StringBuffer();
		sb.append( "SELECT * from t_ed_collection where sid ="+sid) 
		  .append( " and eid=" + eid )
		  .append(" order by eqbbasic");
		
		List<EdCollection> edRtList = EdCollection.dao.find(sb.toString());
		
		setAttr("size", edRtList.size());
        setAttr("edRtList", edRtList);
        List<TotalScale> tsList = TotalScale.dao.find("select * from t_total_scale where tstype like '%部门经理测评%'");
        String tsname = null;
        long tsscale = 0;
        for(TotalScale ts : tsList){
        	tsname = ts.getStr("tsname");
        	tsscale = ts.getLong("tsscale");
        	if(tsname.contains("自评")){
        		setAttr("mydTsscale", tsscale);
        	}else if(tsname.contains("上级")){
        		setAttr("updTsscale", tsscale);
        	}else if(tsname.contains("其他部门")){
        		setAttr("otherdTsscale", tsscale);
        	}else if(tsname.contains("下属")){
        		setAttr("departdTsscale", tsscale);
        	}
        }
        render("edResult.jsp");
	}
	
	
	public void exportEDResult(){
		int sid = getParaToInt("sid");
		int epType = getParaToInt("epType",0);
		StringBuffer sb = new StringBuffer();
		Statistic sc = Statistic.dao.findById(sid);
		String title = sc.getStr("sname")+"部门经理测评结果";
		String[] rowName = null;//表头
		List<Object[]>  dataList = new ArrayList<Object[]>();
		List<Object> tmpStrList = null;
		List<TotalScale> tsList = TotalScale.dao.find("select * from t_total_scale where tstype like '%部门经理测评%'");
        String tsname = null;
        long tsscale = 0;
        long selfpTsscale = 0;
        long uppTsscale = 0;
        long otherpTsscale = 0;
        long departpTsscale = 0;
        for(TotalScale ts : tsList){
        	tsname = ts.getStr("tsname").trim();
        	tsscale = ts.getLong("tsscale");
        	if(tsname.contains("自评")){
        		selfpTsscale =  tsscale; 
        	}else if(tsname.contains("上级")){
        		uppTsscale =  tsscale; 
        	}else if(tsname.contains("其他部门同事")){
        		otherpTsscale =  tsscale; 
        	}else if(tsname.contains("下属")){
        		departpTsscale =  tsscale; 
        	}
        }
		if(epType==1){
			dataList.clear();
			sb.append("SELECT d.dname,e.zname,  ")
			.append("ROUND(sum(edc.eqsscale*edc.myd/100),4) self,  ")
			.append("ROUND(sum(edc.eqsscale*edc.upd/100),4) up, ")
			.append("ROUND(sum(edc.eqsscale*edc.otherd/100),4) other, ")
			.append("ROUND(sum(edc.eqsscale*edc.departd/100),4) depart ")
			.append("from t_ed_collection edc  ")
			.append("INNER JOIN t_employee e on e.eid=edc.eid ")
			.append("INNER JOIN t_department d on e.did = d.did ")
			.append("WHERE edc.sid= "+sid +" ")
			.append("GROUP BY edc.eid order by d.dname");
			List<EdCollection> edcList = EdCollection.dao.find(sb.toString());
			rowName =new String[]{"序号","部门","姓名","自评","上级","其他部门同事","下属","总分"};//表头
			
			for(EdCollection edc : edcList){
				tmpStrList = new ArrayList<Object>();
				tmpStrList.add(edc.getStr("dname"));
				tmpStrList.add(edc.getStr("zname"));
				tmpStrList.add(edc.getDouble("self"));
				tmpStrList.add(edc.getDouble("up"));
				tmpStrList.add(edc.getDouble("other"));
				tmpStrList.add(edc.getDouble("depart"));
				tmpStrList.add(edc.getDouble("self")*selfpTsscale/100.000
						+ edc.getDouble("up")*uppTsscale/100.000
						+ edc.getDouble("other")*otherpTsscale/100.000
						+ edc.getDouble("depart")*departpTsscale/100.000
						);
				
				dataList.add(tmpStrList.toArray());
			}
		}else{
			int eid = getParaToInt("eid",0);
			dataList.clear();
			sb.append("SELECT d.dname,e.zname,edc.* from t_ed_collection edc ")
			  .append("INNER JOIN t_employee e on e.eid=edc.eid ")
			  .append("INNER JOIN t_department d on e.did = d.did ")
			  .append("where edc.sid="+sid+" ");
			if(eid!=0){
				sb.append(" and edc.eid="+eid+" ");
			}
			  sb.append(" ORDER BY d.dname,e.zname ");
			List<EdCollection> edcList = EdCollection.dao.find(sb.toString());
			rowName =new String[]{"序号","部门","姓名","题目","权重(%)","自评","上级","其他部门同事","下属"};//表头
			float totalmy = 0.0f;
			float totalup = 0.0f;
			float totalother = 0.0f;
			float totaldepart = 0.0f;
			for(EdCollection edc : edcList){
				tmpStrList = new ArrayList<Object>();
				tmpStrList.add(edc.getStr("dname"));
				tmpStrList.add(edc.getStr("zname"));
				tmpStrList.add(edc.getStr("eqsstandard"));
				tmpStrList.add(edc.getLong("eqsscale")+"%");
				tmpStrList.add(edc.getFloat("myd"));
				tmpStrList.add(edc.getFloat("upd"));
				tmpStrList.add(edc.getFloat("otherd"));
				tmpStrList.add(edc.getFloat("departd"));
				totalmy += edc.getFloat("myd")*edc.getLong("eqsscale");
				totalup += edc.getFloat("upd")*edc.getLong("eqsscale");
				totalother += edc.getFloat("otherd")*edc.getLong("eqsscale");
				totaldepart += edc.getFloat("departd")*edc.getLong("eqsscale");
				dataList.add(tmpStrList.toArray());
			}
			if(eid!=0&&edcList.size()>0){
				tmpStrList = new ArrayList<Object>();
				tmpStrList.add("总计（按权重）");
				tmpStrList.add((totalmy*selfpTsscale+totalup*uppTsscale+totalother*otherpTsscale+totaldepart*departpTsscale)/10000.000);
				tmpStrList.add(" ");
				tmpStrList.add(" ");
				tmpStrList.add(totalmy/100.00);
				tmpStrList.add(totalup/100.00);
				tmpStrList.add(totalother/100.00);
				tmpStrList.add(totaldepart/100.00);
				dataList.add(tmpStrList.toArray());
			}
		}
		
		HSSFUtil execl = new HSSFUtil(title, rowName, dataList, getRequest());
		File file = null;
		try {
			String fileName = execl.export();
			file = new File(fileName);
		
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(file!=null){
				renderFile(file);
				return;
			}
		}
		renderNull();
	}
	
	public void exportEEResult(){
		int sid = getParaToInt("sid");
		int epType = getParaToInt("epType",0);
		StringBuffer sb = new StringBuffer();
		Statistic sc = Statistic.dao.findById(sid);
		String title = sc.getStr("sname")+"普通员工测评结果";
		String[] rowName = null;//表头
		List<Object[]>  dataList = new ArrayList<Object[]>();
		List<Object> tmpStrList = null;
		List<TotalScale> tsList = TotalScale.dao.find("select * from t_total_scale where tstype like '%普通员工测评%'");
		String tsname = null;
		long tsscale = 0;
		long selfpTsscale = 0;
		long uppTsscale = 0;
		long otherpTsscale = 0;
		long departpTsscale = 0;
		for(TotalScale ts : tsList){
			tsname = ts.getStr("tsname").trim();
			tsscale = ts.getLong("tsscale");
			if(tsname.contains("自评")){
				selfpTsscale =  tsscale; 
			}else if(tsname.contains("上级")){
				uppTsscale =  tsscale; 
			}else if(tsname.contains("其他部门同事")){
				otherpTsscale =  tsscale; 
			}else if(tsname.contains("部门同事")){
				departpTsscale =  tsscale; 
			}
		}
		if(epType==1){
			dataList.clear();
			sb.append("SELECT d.dname,e.zname,  ")
			.append("ROUND(sum(eec.eqsscale*eec.mye/100),4) self,  ")
			.append("ROUND(sum(eec.eqsscale*eec.upe/100),4) up, ")
			.append("ROUND(sum(eec.eqsscale*eec.othere/100),4) other, ")
			.append("ROUND(sum(eec.eqsscale*eec.departe/100),4) depart ")
			.append("from t_ee_collection eec  ")
			.append("INNER JOIN t_employee e on e.eid=eec.eid ")
			.append("INNER JOIN t_department d on e.did = d.did ")
			.append("WHERE eec.sid= "+sid +" ")
			.append("GROUP BY eec.eid order by d.dname");
			List<EeCollection> eecList = EeCollection.dao.find(sb.toString());
			rowName =new String[]{"序号","部门","姓名","自评","上级","其他部门同事","部门同事","总分"};//表头
			for(EeCollection eec : eecList){
				tmpStrList = new ArrayList<Object>();
				tmpStrList.add(eec.getStr("dname"));
				tmpStrList.add(eec.getStr("zname"));
				tmpStrList.add(eec.getDouble("self"));
				tmpStrList.add(eec.getDouble("up"));
				tmpStrList.add(eec.getDouble("other"));
				tmpStrList.add(eec.getDouble("depart"));
				tmpStrList.add(eec.getDouble("self")*selfpTsscale/100.000
						+ eec.getDouble("up")*uppTsscale/100.000
						+ eec.getDouble("other")*otherpTsscale/100.000
						+ eec.getDouble("depart")*departpTsscale/100.000
						);
				
				dataList.add(tmpStrList.toArray());
			}
		}else{
			int eid = getParaToInt("eid",0);
			dataList.clear();
			sb.append("SELECT d.dname,e.zname,eec.* from t_ee_collection eec ")
			.append("INNER JOIN t_employee e on e.eid=eec.eid ")
			.append("INNER JOIN t_department d on e.did = d.did ")
			.append("where eec.sid="+sid+" ");
			if(eid!=0){
				sb.append(" and eec.eid="+eid+" ");
			}
			sb.append(" ORDER BY d.dname,e.zname ");
			List<EeCollection> eecList = EeCollection.dao.find(sb.toString());
			rowName =new String[]{"序号","部门","姓名","题目","权重(%)","自评","上级","其他部门同事","部门同事"};//表头
			float totalmy = 0.0f;
			float totalup = 0.0f;
			float totalother = 0.0f;
			float totaldepart = 0.0f;
			for(EeCollection eec : eecList){
				tmpStrList = new ArrayList<Object>();
				tmpStrList.add(eec.getStr("dname"));
				tmpStrList.add(eec.getStr("zname"));
				tmpStrList.add(eec.getStr("eqsstandard"));
				tmpStrList.add(eec.getLong("eqsscale")+"%");
				tmpStrList.add(eec.getFloat("mye"));
				tmpStrList.add(eec.getFloat("upe"));
				tmpStrList.add(eec.getFloat("othere"));
				tmpStrList.add(eec.getFloat("departe"));
				totalmy += eec.getFloat("mye")*eec.getLong("eqsscale");
				totalup += eec.getFloat("upe")*eec.getLong("eqsscale");
				totalother += eec.getFloat("othere")*eec.getLong("eqsscale");
				totaldepart += eec.getFloat("departe")*eec.getLong("eqsscale");
				dataList.add(tmpStrList.toArray());
			}
			if(eid!=0&&eecList.size()>0){
				tmpStrList = new ArrayList<Object>();
				tmpStrList.add("总计（按权重）");
				tmpStrList.add((totalmy*selfpTsscale+totalup*uppTsscale+totalother*otherpTsscale+totaldepart*departpTsscale)/10000.000);
				tmpStrList.add(" ");
				tmpStrList.add(" ");
				tmpStrList.add(totalmy/100.00);
				tmpStrList.add(totalup/100.00);
				tmpStrList.add(totalother/100.00);
				tmpStrList.add(totaldepart/100.00);
				dataList.add(tmpStrList.toArray());
			}
		}
		
		HSSFUtil execl = new HSSFUtil(title, rowName, dataList, getRequest());
		File file = null;
		try {
			String fileName = execl.export();
			file = new File(fileName);
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			if(file!=null){
				renderFile(file);
				return;
			}
		}
		renderNull();
	}
}
