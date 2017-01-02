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
import com.tao.www.model.Department;
import com.tao.www.model.DepartmentCollection;
import com.tao.www.model.DepartmentResult;
import com.tao.www.model.DepartmentResultDetail;
import com.tao.www.model.Employee;
import com.tao.www.model.Progress;
import com.tao.www.model.Statistic;
import com.tao.www.model.TotalScale;
import com.tao.www.plugin.HSSFUtil;

public class DepartmentResultController extends Controller {
	
	public void addDepartmentResult(){
		Integer[] dqids = this.getParaValuesToInt("dqids");//这是所有问题的id
		Integer[] dqscales = this.getParaValuesToInt("dqscales");//这是所有问题的比重
		int did = getParaToInt("did"); //当前被测评的部门
		int dtid = getParaToInt("dtid"); //当前被测评的部门的类型
		int drdweight = 0; //得分
		int doid = 0; //选项id
		long drid = 0; //满意度结果主键
		
		Integer[] drdweights = new Integer[dqids.length];
		int allZero = 0;//得分为零的所有比例之和
		int allZeroCount = 0; //得分为零的个数
		for(int i=0;i<dqids.length;i++){
			drdweights[i] = getParaToInt("drdweight"+dqids[i]);//获取到对应的得分
			if(drdweights[i]==0){
				allZero += dqscales[i]; //加入到为零的总计中
				dqscales[i] = 0; //然后将当前比例置0
				allZeroCount++;
			}
		}
		int remaind = dqscales.length - allZeroCount; //剩余不为零的比例个数
		float fenshu = ((float)allZero)/remaind;
		Float[] dqscalesFloat = new Float[dqscales.length];
		for(int j=0;j<dqscales.length;j++){
			if(dqscales[j]!=0){
				dqscalesFloat[j] = dqscales[j] +fenshu; //均摊为零的比例
			}else{
				dqscalesFloat[j] = 0f;
			}
		}
		//先插入到满意度结果表 
		Statistic sc = getSessionAttr("sc");
		Employee ee = getSessionAttr("ee");
		DepartmentResult dr = null;
		if(sc!=null&&ee!=null){
			DepartmentResult oldDr = DepartmentResult.dao.findFirst("select * from t_department_result where "
					+ "eid="+ee.getLong("eid")+" and sid="+sc.getLong("sid")+" and did="+did);
			if(oldDr==null){
				//如果是第一次测评
				 dr = new DepartmentResult()
					.set("sid",sc.getLong("sid"))
					.set("eid", ee.getLong("eid"))
					.set("did", did)
					.set("dtid", dtid)
					.set("drftime", new Date());
				dr.save();
				drid = dr.getLong("drid");
				//更新进度表
				long sid = sc.getLong("sid");
				long eid = ee.getLong("eid");
				//先去查看进度表里面有没有数据
				Progress ps = Progress.dao.findFirst("select * from t_progress where sid="+sid
						+" and eid="+eid);
				if(ps!=null){
					ps.set("dpnum", ps.getLong("dpnum")+1).update();//实际测评部门数加1
				}
			}else{
				//如果是重新测评的话,需要将结果详细表数据删除
				Db.update("delete from t_department_result_detail where drid ="+oldDr.getLong("drid"));
				drid = oldDr.getLong("drid");
			}
			float total = 0;
			for(int i=0;i<dqids.length;i++){
				drdweight = drdweights[i];
				doid = getParaToInt("do"+dqids[i]);
				total+= drdweight*dqscalesFloat[i]/100.0f;
				DepartmentResultDetail drd = new DepartmentResultDetail()
						.set("drid",drid)
						.set("dqid", dqids[i])
						.set("doid",doid)
						.set("drdscale", dqscalesFloat[i])
						.set("drdweight", drdweight);
				drd.save();
			}
			//最后再更新结果表里的总分数据
			DecimalFormat df = new DecimalFormat("######0.00");   
			if(oldDr==null){
				dr.set("drtotal", df.format(total)).update();
			}else{
				oldDr.set("drtotal", df.format(total)).update();
			}
			
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	//部门测评结果列表
	public void getDList(){
		Employee ee = getSessionAttr("ee");
		String rName = getSessionAttr("rName");//角色名称
		
		String search = getPara("search")==null?"":getPara("search");
		String sqlExpectSelect = null;
		StringBuffer sb = new StringBuffer();
		
		if(ee!=null&&rName!=null){
			if(rName.contains("系统管理员")||rName.contains("董事长")
					||(rName.contains("总经理")&&!rName.contains("直属副总经理"))){
				//总经理,系统管理员,董事长能看所有的部门
				sqlExpectSelect = "from t_department d inner join t_department_type dt ON d.dtid = dt.dtid "
						+ "where d.dname like '%"+search+"%'"+" and d.dname not like '%高%管%'";
			}else{
				if(rName.equals("直属副总经理")){//只能查看自己管理的部门
					sqlExpectSelect = "from t_employee_department ed "
							+ "inner join t_department d on ed.did=d.did "
							+ "inner join t_department_type dt ON d.dtid = dt.dtid "
							+ "where ed.eid= "+ee.getLong("eid")
							+ " and d.dname like '%"+search+"%'";
				}else if(rName.equals("部门经理")||rName.equals("部门副经理")){//只能查看本部门
					sqlExpectSelect = "from t_department d "
							+ "inner join t_department_type dt ON d.dtid = dt.dtid "
							+ "where d.dname like '%"+search+"%' "
							+ " and d.did=" + ee.getLong("did");
				}else if(rName.contains("直属副总经理")&&(rName.contains("部门经理")||rName.contains("部门副经理"))){
					sqlExpectSelect = "from (select d.did,d.dname,dt.dtname from t_employee_department ed "
							+ "inner join t_department d on ed.did=d.did "
							+ "inner join t_department_type dt ON d.dtid = dt.dtid "
							+ "where ed.eid= "+ee.getLong("eid")
							+ " and d.dname like '%"+search+"%'"
							+ " union "
							+ "select d.did,d.dname,dt.dtname from t_department d "
							+ "inner join t_department_type dt ON d.dtid = dt.dtid "
							+ "where d.dname like '%"+search+"%' "
							+ " and d.did=" + ee.getLong("did")
							+ ") aa";
				}
			}
		
			System.out.println("select * " + sqlExpectSelect);
			Page<Department> departmentPage = Department.dao.paginate(
					getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
					getParaToInt("limit", 50),
					"select *",
					sqlExpectSelect);
			int total = departmentPage.getTotalRow();
			sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(departmentPage.getList())+"}");
			this.renderJson(sb.toString());
		}else{
			sb.append("{\"total\":\""+0+"\"").append(",\"rows\":"+"[]"+"}");
			this.renderJson(sb.toString());
		}
		
	}
	
	/*//部门测评结果
	public void getDResult(){
		int did = getParaToInt("did");
		int sid = getParaToInt("sid");
		StringBuffer sb = new StringBuffer();
		sb.append( "SELECT " ) 
		.append( "dqbasic,dqscale, " ) 	
		.append( "SUM(IF(ptype='自评',average,0)) AS selfp, " ) 	
		.append( "SUM(IF(ptype='高管',average,0)) AS upp,  " ) 	
		.append( "SUM(IF(ptype='其他部门',average,0)) AS otherp " ) 	
		.append( "FROM( " ) 	
		.append( "SELECT dq.dqbasic, " )
		.append( "CONCAT(dq.dqscale,'%') dqscale, " )
		.append( "getptype(dr.eid,dr.did) ptype, " )
		.append( "round(avg(drd.drdweight*dq.dqscale/100),2) average, " ) 
		.append( "dr.eid " ) 
		.append( "from t_department_result_detail drd " ) 
		.append( "INNER JOIN t_department_result dr on dr.drid=drd.drid " ) 
		.append( "INNER JOIN t_department_question dq on dq.dqid=drd.dqid " ) 
		.append( "where dr.did="+ did + " and dr.sid=" + sid ) 
		.append( " GROUP BY dq.dqid,ptype " ) 
		.append( ") a GROUP BY dqscale" );
		
		List<DepartmentResult> dRtList = DepartmentResult.dao.find(sb.toString());
		
		setAttr("size", dRtList.size());
		setAttr("dRtList", dRtList);
		
		render("dResult.jsp");
		
	}*/
	//部门测评结果
	public void getDResult(){
		int did = getParaToInt("did");
		int sid = getParaToInt("sid");
		StringBuffer sb = new StringBuffer();
		sb.append( "SELECT * from t_department_collection where sid ="+sid) 
		  .append( " and did=" + did ); 
		List<DepartmentCollection> dRtList = DepartmentCollection.dao.find(sb.toString());
		setAttr("size", dRtList.size());
        setAttr("dRtList", dRtList);
        List<TotalScale> tsList = TotalScale.dao.find("select * from t_total_scale where tstype like '%部门测评%'");
        String tsname = null;
        long tsscale = 0;
        for(TotalScale ts : tsList){
        	tsname = ts.getStr("tsname");
        	tsscale = ts.getLong("tsscale");
        	if(tsname.contains("自评")){
        		setAttr("selfpTsscale", tsscale);
        	}else if(tsname.contains("高管")){
        		setAttr("uppTsscale", tsscale);
        	}else if(tsname.contains("其他部门")){
        		setAttr("otherpTsscale", tsscale);
        	}
        }
        render("dResult.jsp");
	}
	
	public void exportDResult(){
		int sid = getParaToInt("sid");
		int epType = getParaToInt("epType",0);
		StringBuffer sb = new StringBuffer();
		Statistic sc = Statistic.dao.findById(sid);
		String title = sc.getStr("sname")+"部门测评结果";
		String[] rowName = null;//表头
		List<Object[]>  dataList = new ArrayList<Object[]>();
		List<Object> tmpStrList = null;
		List<TotalScale> tsList = TotalScale.dao.find("select * from t_total_scale where tstype like '%部门测评%'");
        String tsname = null;
        long tsscale = 0;
        long selfpTsscale = 0;
        long uppTsscale = 0;
        long otherpTsscale = 0;
        for(TotalScale ts : tsList){
        	tsname = ts.getStr("tsname");
        	tsscale = ts.getLong("tsscale");
        	if(tsname.contains("自评")){
        		selfpTsscale =  tsscale; 
        	}else if(tsname.contains("高管")){
        		uppTsscale =  tsscale; 
        	}else if(tsname.contains("其他部门")){
        		otherpTsscale =  tsscale; 
        	}
        }
		if(epType==1){
			dataList.clear();
			sb.append("SELECT d.dname name,round(sum(dc.dqscale*dc.selfp/100),4) self,  ")
			.append("round(sum(dc.dqscale*dc.upp/100),4) up,  ")
			.append("round(sum(dc.dqscale*dc.otherp/100),4) other ")
			.append("from t_department_collection dc INNER JOIN t_department d on d.did=dc.did ")
			.append("where dc.sid= "+sid +" ")
			.append(" GROUP BY dc.did ");
			List<DepartmentCollection> dcList = DepartmentCollection.dao.find(sb.toString());
			rowName =new String[]{"序号","部门","自评","高管","其他部门","总分"};//表头
			for(DepartmentCollection dc : dcList){
				tmpStrList = new ArrayList<Object>();
				tmpStrList.add(dc.getStr("name"));
				tmpStrList.add(dc.getDouble("self"));
				tmpStrList.add(dc.getDouble("up"));
				tmpStrList.add(dc.getDouble("other"));
				tmpStrList.add(dc.getDouble("self")*selfpTsscale/100.000
						+ dc.getDouble("up")*uppTsscale/100.000
						+ dc.getDouble("other")*otherpTsscale/100.000);
				
				dataList.add(tmpStrList.toArray());
			}
		}else{
			int did = getParaToInt("did",0);
			dataList.clear();
			sb.append("SELECT d.dname,dc.* from t_department_collection dc ")
			  .append("INNER JOIN t_department d on dc.did = d.did ")
			  .append("where dc.sid="+sid+" ");
			if(did!=0){
				sb.append(" and d.did="+did+" ");
			}
			sb.append("ORDER BY dname ");
			List<DepartmentCollection> dcList = DepartmentCollection.dao.find(sb.toString());
			rowName =new String[]{"序号","部门","题目","权重(%)","自评","高管","其他部门"};//表头
			float totalself = 0.0f;
			float totalup = 0.0f;
			float totalother = 0.0f;
			for(DepartmentCollection dc : dcList){
				tmpStrList = new ArrayList<Object>();
				tmpStrList.add(dc.getStr("dname"));
				tmpStrList.add(dc.getStr("dqbasic"));
				tmpStrList.add(dc.getLong("dqscale")+"%");
				tmpStrList.add(dc.getFloat("selfp"));
				tmpStrList.add(dc.getFloat("upp"));
				tmpStrList.add(dc.getFloat("otherp"));
				totalself += dc.getFloat("selfp")*dc.getLong("dqscale");
				totalup += dc.getFloat("upp")*dc.getLong("dqscale");
				totalother += dc.getFloat("otherp")*dc.getLong("dqscale");
				dataList.add(tmpStrList.toArray());
			}
			if(did!=0&&dcList.size()>0){
				tmpStrList = new ArrayList<Object>();
				tmpStrList.add("总计（按权重）");
				tmpStrList.add((totalself*selfpTsscale+totalup*uppTsscale+totalother*otherpTsscale)/10000.000);
				tmpStrList.add(" ");
				tmpStrList.add(totalself/100.00);
				tmpStrList.add(totalup/100.00);
				tmpStrList.add(totalother/100.00);
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
	
	/*public void exportDResult(){
		
		int sid = getParaToInt("sid");
		System.out.println(sid);
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT dc.*,d.dname from t_department_collection dc ")
		  .append("inner join t_department d on dc.did=d.did  where dc.sid ="+sid);
		List<DepartmentCollection> dRtList = DepartmentCollection.dao.find(sb.toString());
		Map<String,List<DepartmentCollection>> mapList = new LinkedHashMap<String, List<DepartmentCollection>>();
		String dname = null;
		List<DepartmentCollection> tmpList = null;
		for(DepartmentCollection dc :dRtList){
			dname = dc.getStr("dname");
			if(mapList.containsKey(dname)){
				tmpList = mapList.get(dname);
			}else{
				tmpList = new ArrayList<DepartmentCollection>();
			}
			tmpList.add(dc);
			mapList.put(dname, tmpList);
		}
		List<Dr> out = new ArrayList<Dr>();
		Dr dr = null;
		for(Map.Entry<String, List<DepartmentCollection>> en : mapList.entrySet()){
			dr = new Dr(en.getKey(),en.getValue());
			out.add(dr);
			
		}
        Map<String,Object> beans = new HashMap<String, Object>();
        beans.put("out", out);//详细数据
        
          List<TotalScale> tsList = TotalScale.dao.find("select * from t_total_scale where tstype like '%部门测评%'");
        String tsname = null;
        long tsscale = 0;
        for(TotalScale ts : tsList){
        	tsname = ts.getStr("tsname");
        	tsscale = ts.getLong("tsscale");
        	if(tsname.contains("自评")){
        		 beans.put("selfpTsscale", tsscale); 
        	}else if(tsname.contains("高管")){
        		 beans.put("uppTsscale", tsscale);
        	}else if(tsname.contains("其他部门")){
        		 beans.put("otherpTsscale", tsscale);
        	}
        }
        @SuppressWarnings("deprecation")
		String templateFileName =  this.getRequest().getRealPath("")+File.separator+"excel/dr.xls";
        String filename = "details.xls";
        render(JxlsRender.me(templateFileName).filename(filename).beans(beans));
        
	}*/
	
	public void submitDepartmentResult(){
		int drid = getParaToInt("drid");
		DepartmentResult.dao.findById(drid).set("drissubmit", 1).update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchSubmitDepartmentResult(){
		String[] dridStrArr = getPara("drids").split(",");
		for(String drid : dridStrArr){
			DepartmentResult.dao.findById(drid).set("drissubmit", 1).update();
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
}
