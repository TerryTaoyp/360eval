package com.tao.www.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.tao.www.model.SatisfyResult;
import com.tao.www.model.Statistic;
import com.tao.www.plugin.HSSFUtil;

public class ResultTypeController extends Controller {
	public void resultSelByType(){
		//where sisactive=0
		List<Statistic> statisticList= Statistic.dao.find("select sid,sname from t_statistic");
		setAttr("statisticList", statisticList);
		Map<Integer,String> typeMap= new LinkedHashMap<Integer,String>();
		String rName = getSessionAttr("rName");
		if(rName.contains("系统管理员")||rName.contains("董事长")||rName.contains("总经理")&&!rName.contains("直属副总经理")){
			typeMap.put(1, "满意度测评");//董事长,总经理,系统管理员能看满意度
			typeMap.put(2, "部门测评");
			typeMap.put(3, "部门经理测评");
		}else if(rName.contains("直属副总经理")||rName.contains("部门经理")||rName.contains("部门副经理")){
			typeMap.put(2, "部门测评");
			typeMap.put(3, "部门经理测评");
		}
		typeMap.put(4, "普通员工测评");
		setAttr("typeMap", typeMap);
		render("resultType.jsp");
	}
	
	public void getResultSelByType(){
		int sid = getParaToInt("sid"); //测评计划id
		int rtype = getParaToInt("rtype"); //测评类型 1满意度 2部门 3部门经理 4普通员工
		setAttr("sid", sid);//把测评计划id 传递过去
		if(rtype==4){
			render("eeList.jsp");//普通员工测评
		}else if(rtype==3){
			render("edList.jsp");//部门经理测评
		}else if(rtype==2){
			render("dList.jsp");//部门测评
		}else if(rtype==1){
			//开放题结果
			StringBuffer sb1 = new StringBuffer();
			sb1.append("SELECT sq.sqname,srd.srdname FROM ")
			  .append("t_satisfy_result_detail srd ")
			  .append("INNER JOIN t_satisfy_result sr on sr.srid = srd.srid ")
			  .append("INNER JOIN t_satisfy_question sq on srd.sqid=sq.sqid ")
			  .append("WHERE srd.sqtype=1 and sr.sid="+sid);
			List<SatisfyResult> srOpenList = SatisfyResult.dao.find(sb1.toString());//开放题结果集
			Map<String,ArrayList<String>> srOpenMap = new LinkedHashMap<String, ArrayList<String>>(); //开放题结果解析
			ArrayList<String> tmpList = null;
			String sqname= null;
			for(SatisfyResult sr :srOpenList){
				sqname = sr.getStr("sqname");
				if(srOpenMap.containsKey(sqname)){
					tmpList = srOpenMap.get(sqname);
				}else{
					tmpList = new ArrayList<String>();
				}
				tmpList.add(sr.getStr("srdname"));
				srOpenMap.put(sqname, tmpList);
			}
			setAttr("openSize", srOpenMap.size());
			setAttr("srOpenMap", srOpenMap);//开放题结果
			
			
			//全部封闭题
			StringBuffer sb2 = new StringBuffer();
			sb2.append("SELECT sq.sqname sqname,'公司整体' dname, ")
			   .append("round(avg(srd.srdweight),2) average, ")
			   .append("round(VAR_POP(srd.srdweight),2) variance ")
			   .append("from t_satisfy_result_detail srd  ")
			   .append("INNER JOIN t_satisfy_result sr on srd.srid=sr.srid ")
			   .append("INNER JOIN t_satisfy_question sq on srd.sqid=sq.sqid ")
			   .append("WHERE srd.sqtype=0 and sr.sid="+ sid +" ")
			   .append("GROUP BY sq.sqid ")
			   .append("UNION ")
			   .append("SELECT sq.sqname sqname,d.dname dname, ")
			   .append("round(avg(srd.srdweight),2) average, ")
			   .append("round(VAR_POP(srd.srdweight),2) variance ")
			   .append("from t_satisfy_result_detail srd  ")
			   .append("INNER JOIN t_satisfy_result sr on srd.srid=sr.srid ")
			   .append("INNER JOIN t_satisfy_question sq on srd.sqid=sq.sqid ")
			   .append("INNER JOIN t_department d on d.did=sr.did ")
			   .append("WHERE srd.sqtype=0 and sr.sid=" + sid+" ")
			   .append("GROUP BY sq.sqid,sr.did ");
			   List<SatisfyResult>  srCloseList = SatisfyResult.dao.find(sb2.toString()); //各部门封闭题结果集
			   Map<String,ArrayList<String>> srCloseMap = new LinkedHashMap<String, ArrayList<String>>();//封闭题结果解析
			   Map<String,String> srCloseDp = new LinkedHashMap<String, String>();//表头
			   tmpList = null;
			   sqname = null;
			   String dname = null;
			   for(SatisfyResult sr :srCloseList){
				   sqname = sr.getStr("sqname");//满意度问题
				   dname = sr.getStr("dname");//部门名称
					if(srCloseMap.containsKey(sqname)){
						tmpList = srCloseMap.get(sqname);
					}else{
						tmpList = new ArrayList<String>();
					}
					srCloseDp.put(dname,dname);//这里是将各部门名称加入到表头项里面,利用map的自动去重功能
					tmpList.add(sr.get("average")+"");//将均值加入到列表里
					tmpList.add(sr.get("variance")+"");//将方差加入到列表里
					srCloseMap.put(sqname, tmpList);
			   }
			   setAttr("dpSize", srCloseDp.size());
			   setAttr("srCloseDp", srCloseDp);
			   setAttr("closeSize", srCloseMap.size());
			   setAttr("srCloseMap", srCloseMap);//封闭题部门结果
			   
			render("sResult.jsp");//满意度测评
		}else{
			resultSelByType(); //再返回到选择页面
		}
	}

	//封闭题结果
	public void exportSCResult(){
		int sid = getParaToInt("sid",0);
		List<Object[]>  dataList = new ArrayList<Object[]>();
		List<Object> tmpStrList = null;
		//全部封闭题
		StringBuffer sb2 = new StringBuffer();
		sb2.append("SELECT sq.sqname sqname,'公司整体' dname, ")
		   .append("round(avg(srd.srdweight),2) average, ")
		   .append("round(VAR_POP(srd.srdweight),2) variance ")
		   .append("from t_satisfy_result_detail srd  ")
		   .append("INNER JOIN t_satisfy_result sr on srd.srid=sr.srid ")
		   .append("INNER JOIN t_satisfy_question sq on srd.sqid=sq.sqid ")
		   .append("WHERE srd.sqtype=0 and sr.sid="+ sid +" ")
		   .append("GROUP BY sq.sqid ")
		   .append("UNION ")
		   .append("SELECT sq.sqname sqname,d.dname dname, ")
		   .append("round(avg(srd.srdweight),2) average, ")
		   .append("round(VAR_POP(srd.srdweight),2) variance ")
		   .append("from t_satisfy_result_detail srd  ")
		   .append("INNER JOIN t_satisfy_result sr on srd.srid=sr.srid ")
		   .append("INNER JOIN t_satisfy_question sq on srd.sqid=sq.sqid ")
		   .append("INNER JOIN t_department d on d.did=sr.did ")
		   .append("WHERE srd.sqtype=0 and sr.sid=" + sid+" ")
		   .append("GROUP BY sq.sqid,sr.did ");
		   List<SatisfyResult>  srCloseList = SatisfyResult.dao.find(sb2.toString()); //各部门封闭题结果集
		   Map<String,ArrayList<String>> srCloseMap = new LinkedHashMap<String, ArrayList<String>>();//封闭题结果解析
		   Map<String,String> srCloseDp = new LinkedHashMap<String, String>();//表头
		   ArrayList<String> tmpList = null;
		   String sqname= null;
		   String dname = null;
		   int biaotoulen = 0;
		   for(SatisfyResult sr :srCloseList){
			   sqname = sr.getStr("sqname");//满意度问题
			   dname = sr.getStr("dname");//部门名称
				if(srCloseMap.containsKey(sqname)){
					tmpList = srCloseMap.get(sqname);
				}else{
					tmpList = new ArrayList<String>();
				}
				srCloseDp.put(dname,dname);//这里是将各部门名称加入到表头项里面,利用map的自动去重功能
				tmpList.add(sr.get("average")+"");//将均值加入到列表里
				tmpList.add(sr.get("variance")+"");//将方差加入到列表里
				srCloseMap.put(sqname, tmpList);
				biaotoulen = tmpList.size();
		   }
			for(Map.Entry<String,ArrayList<String>> cq : srCloseMap.entrySet()){
				tmpStrList = new ArrayList<Object>();
				tmpStrList.add(cq.getKey());
				for(String s : cq.getValue()){
					tmpStrList.add(s);
				}
				dataList.add(tmpStrList.toArray());
			}
			List<String > second = new ArrayList<String>();
			Statistic sc = Statistic.dao.findById(sid);
			String title = sc.getStr("sname")+"满意度测评测评结果";
			String[] rowName = new String[biaotoulen+2];//表头
			rowName[0] = "序号";
			rowName[1] = "问题";
			for(int i =2;i<rowName.length;i++){
				if(i%2==0){
					rowName[i]="均值";
				}else{
					rowName[i]="方差";
				}
			}
			List<String> title2 = new ArrayList<String>();
			title2.add("内容");
			Iterator<String> itor = srCloseDp.keySet().iterator();
			while (itor.hasNext()) {
				title2.add(itor.next());
				
			}
			HSSFUtil execl = new HSSFUtil(title, rowName, dataList, getRequest());
			File file = null;
			try {
				String fileName = execl.export(title2);
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
	
	//开放题结果
	public void exportSOResult(){
		int sid = getParaToInt("sid",0);
		List<Object[]>  dataList = new ArrayList<Object[]>();
		List<Object> tmpStrList = null;
		StringBuffer sb1 = new StringBuffer();
		sb1.append("SELECT sq.sqname,srd.srdname FROM ")
		  .append("t_satisfy_result_detail srd ")
		  .append("INNER JOIN t_satisfy_result sr on sr.srid = srd.srid ")
		  .append("INNER JOIN t_satisfy_question sq on srd.sqid=sq.sqid ")
		  .append("WHERE srd.sqtype=1 and sr.sid="+sid +" order by sq.sqname");
		List<SatisfyResult> srOpenList = SatisfyResult.dao.find(sb1.toString());//开放题结果集
		for(SatisfyResult so : srOpenList){
			tmpStrList = new ArrayList<Object>();
			tmpStrList.add(so.getStr("sqname"));
			tmpStrList.add(so.getStr("srdname"));
			dataList.add(tmpStrList.toArray());
		}
		
		Statistic sc = Statistic.dao.findById(sid);
		String title = sc.getStr("sname")+"满意度测评测评结果";
		String[] rowName = new String[]{"序号","问题","答案"};//表头
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
	
	public void resultProduct(){
		
		this.render("resultProduct.jsp");
	}
	
	public void getProductList(){
		
		StringBuffer sb = new StringBuffer();
		Statistic sc = getSessionAttr("sc");
		if(sc!=null){
			String sname = sc.getStr("sname");
			long sid = sc.getLong("sid");
			long count1 = Db.queryLong("select count(did) from t_department_collection where sid="+sid);//部门测评
			long count2 = Db.queryLong("select count(eid) from t_ed_collection where sid="+sid);//经理测评
			long count3 = Db.queryLong("select count(eid) from t_ee_collection where sid="+sid);//员工测评
			sb.append("{\"total\":"+3)
			  .append(",\"rows\":")
			  .append("[{")
			  .append("\"id\":"+1)
			  .append(",\"tname\":\"部门测评\"")
			  .append(",\"sname\":\""+sname+"\"");
			if(count1>0){
				sb.append(",\"isProducted\":\"1\"");	
			}else{
				sb.append(",\"isProducted\":\"0\"");	
			}
			sb.append("},{")
			  .append("\"id\":"+2)
			  .append(",\"tname\":\"部门经理测评\"")
			  .append(",\"sname\":\""+sname+"\"");
			if(count2>0){
				sb.append(",\"isProducted\":\"1\"");	
			}else{
				sb.append(",\"isProducted\":\"0\"");	
			}
			sb.append("},{")
			  .append("\"id\":"+3)
			  .append(",\"tname\":\"普通员工测评\"")
			  .append(",\"sname\":\""+sname+"\"");
			if(count3>0){
				sb.append(",\"isProducted\":\"1\"");	
			}else{
				sb.append(",\"isProducted\":\"0\"");	
			}
			sb.append("}]")
			  .append("}");
			this.renderJson(sb.toString());
		}else{
			sb.append("{\"total\":\""+0+"\"").append(",\"rows\":"+"[]"+"}");
			this.renderJson(sb.toString());
		}
		
	}
	
	public void product(){
		int id = getParaToInt("id");
		int isProducted = getParaToInt("isProducted");
		Statistic sc = getSessionAttr("sc");
		
		if(sc!=null){
			long sid = sc.getLong("sid");
			if(id==1){//部门测评汇总
				if(isProducted==1){
					Db.update("delete from t_department_collection where sid ="+sid);
				}
				StringBuffer dc = new StringBuffer();
				dc.append("insert INTO t_department_collection (sid,did,dqbasic,dqscale,selfp,upp,otherp) ")
				  .append("SELECT sid,did,dqbasic,dqscale, ")
				  .append("SUM(IF(ptype='自评',average,0)) AS selfp, ")
				  .append("SUM(IF(ptype='高管',average,0)) AS upp, ")
				  .append("SUM(IF(ptype='其他部门',average,0)) AS otherp ")
				  .append("FROM( SELECT dq.dqbasic, ")
				  .append("dq.dqscale, ")
				  .append("getptype(dr.eid,dr.did) ptype, ")
				  .append("round(avg(drd.drdweight),2) average, ")
				  .append("dr.eid,dr.did,dr.sid ")
				  .append("from t_department_result_detail drd ")
				  .append("INNER JOIN t_department_result dr on dr.drid=drd.drid ")
				  .append("INNER JOIN t_department_question dq on dq.dqid=drd.dqid ")
				  .append("WHERE dr.sid =" + sid + " ")
				  .append("GROUP BY dr.did,dq.dqid,ptype ")
				  .append(") a GROUP BY did,dqbasic");
				Db.update(dc.toString());//将所有的结果插入
			}else if(id==2){//经理测评汇总
				if(isProducted==1){
					Db.update("delete from t_ed_collection where sid ="+sid);
				}
				StringBuffer ee = new StringBuffer();
				ee.append("insert INTO t_ed_collection (sid,eid,eqbbasic,eqsstandard,eqsscale,myd,upd,otherd,departd) ")
				  .append("SELECT sid,eid,eqbbasic,eqsstandard,eqsscale, ")
				  .append("SUM(IF(dtype='自评',average,0)) AS myd, ")
				  .append("SUM(IF(dtype='上级',average,0)) AS upd, ")
				  .append("SUM(IF(dtype='其他部门同事',average,0)) AS otherd, ")
				  .append("SUM(IF(dtype='下属',average,0)) AS departd ")
				  .append("FROM( SELECT eqb.eqbbasic,eqs.eqsscale,eqs.eqsstandard,er.sid, ")
				  .append("getdtype(er.eid,er.erothereid) dtype, ")
				  .append("round(avg(erd.erdweight),2) average, ")
				  .append("er.eid,er.erothereid,r.rname ")
				  .append("from t_employee_result_detail erd ")
				  .append("INNER JOIN t_employee_result er on er.erid=erd.erid ")
				  .append("INNER JOIN t_employee_question_standard eqs on eqs.eqsid=erd.eqsid ")
				  .append("INNER JOIN t_employee_question_basic eqb on eqb.eqbid=eqs.eqbid ")
				  .append("INNER JOIN t_employee_role erl on erl.eid = er.eid ")
				  .append("INNER JOIN t_role r on r.rid = erl.rid ")
				  .append("where r.rname like '%部%门%经%理%' and er.sid=" + sid + " ")
				  .append("GROUP BY er.eid,eqs.eqsid,dtype ")
				  .append(") a GROUP BY eid,eqsstandard");
				Db.update(ee.toString());//将所有的结果插入
			}else if(id==3){//员工测评汇总
				if(isProducted==1){
					Db.update("delete from t_ee_collection where sid ="+sid);
				}
				StringBuffer ee = new StringBuffer();
				ee.append("insert INTO t_ee_collection (sid,eid,eqbbasic,eqsstandard,eqsscale,mye,upe,othere,departe) ")
				  .append("SELECT sid,eid,eqbbasic,eqsstandard,eqsscale, ")
				  .append("SUM(IF(etype='自评',average,0)) AS mye, ")
				  .append("SUM(IF(etype='上级',average,0)) AS upe, ")
				  .append("SUM(IF(etype='其他部门同事',average,0)) AS othere, ")
				  .append("SUM(IF(etype='部门同事',average,0)) AS departe ")
				  .append("FROM( SELECT eqb.eqbbasic,eqs.eqsscale, ")
				  .append("eqs.eqsstandard,er.sid, ")
				  .append("getetype(er.eid,er.erothereid) etype, ")
				  .append("round(avg(erd.erdweight),2) average, ")
				  .append("er.eid,er.erothereid,r.rname ")
				  .append("from t_employee_result_detail erd ")
				  .append("INNER JOIN t_employee_result er on er.erid=erd.erid ")
				  .append("INNER JOIN t_employee_question_standard eqs on eqs.eqsid=erd.eqsid ")
				  .append("INNER JOIN t_employee_question_basic eqb on eqb.eqbid=eqs.eqbid ")
				  .append("INNER JOIN t_employee_role erl on erl.eid = er.eid ")
				  .append("INNER JOIN t_role r on r.rid = erl.rid ")
				  .append("where r.rname like '%普%通%员%工%' and er.sid=" + sid + " ")
				  .append("GROUP BY er.eid,eqs.eqsid,etype ")
				  .append(") a GROUP BY eid,eqsstandard");
				Db.update(ee.toString());//将所有的结果插入
			}
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
}
