package com.tao.www.controller;

import java.util.Date;

import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.tao.www.model.Employee;
import com.tao.www.model.Progress;
import com.tao.www.model.SatisfyResult;
import com.tao.www.model.SatisfyResultDetail;
import com.tao.www.model.Statistic;

public class SatisfyResultController extends Controller {

	public void addSatisfyResult(){
		Integer[] sqids = this.getParaValuesToInt("sqids");//这是所有问题的id
		Integer[] sqtypes = this.getParaValuesToInt("sqtypes");//这是所有问题的类型
		String srdname = null;
		int srdweight = 0;
		long srid = 0; //满意度结果主键
		//先插入到满意度结果表
		Statistic sc = getSessionAttr("sc");
		Employee ee = getSessionAttr("ee");
		SatisfyResult sr = null;
		if(sc!=null&&ee!=null){
			SatisfyResult oldSr = SatisfyResult.dao.findFirst("select * from t_satisfy_result where "
					+ "eid="+ee.getLong("eid")+" and sid="+sc.getLong("sid"));
			if(oldSr==null){
				//如果是第一次测评
				 sr = new SatisfyResult()
					.set("sid",sc.getLong("sid"))
					.set("eid", ee.getLong("eid"))
					.set("did", ee.getLong("did"))
					.set("srftime", new Date());
				sr.save();
				srid = sr.getLong("srid");
				//更新进度表
				long sid = sc.getLong("sid");
				long eid = ee.getLong("eid");
				//先去查看进度表里面有没有数据
				Progress ps = Progress.dao.findFirst("select * from t_progress where sid="+sid
						+" and eid="+eid);
				if(ps!=null){
					ps.set("siseval", 1).update();//已经测评
				}
			}else{
				//如果是重新测评的话,需要将结果详细表数据删除
				Db.update("delete from t_satisfy_result_detail where srid ="+oldSr.getLong("srid"));
				srid = oldSr.getLong("srid");
			}
			int index = 0;
			float total = 0;
			for(int sqid : sqids){
				if(getPara("srdname"+sqid)!=null&&getPara("srdname"+sqid).length()>0){
					srdname = getPara("srdname"+sqid);
					SatisfyResultDetail srd = new SatisfyResultDetail()
							.set("srid",srid)
							.set("sqid", sqid)
							.set("sqtype", sqtypes[index])
							.set("srdname", srdname);
					srd.save();
				}else{
					srdweight = getParaToInt("srdweight"+sqid);
					total+= srdweight;
					SatisfyResultDetail srd = new SatisfyResultDetail()
							.set("srid",srid)
							.set("sqid", sqid)
							.set("sqtype", sqtypes[index])
							.set("srdweight", srdweight);
					srd.save();
				}
				index++;
			}
			//最后再更新结果表里的总分数据
			if(oldSr==null){
				sr.set("srtotal", total).update();
			}else{
				oldSr.set("srtotal", total).update();
			}
		}
		
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void submitSatisfyResult(){
		int srid = getParaToInt("srid");
		SatisfyResult.dao.findById(srid).set("srissubmit", 1).update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchSubmitSatisfyResult(){
		String[] sridStrArr = getPara("srids").split(",");
		for(String srid : sridStrArr){
			SatisfyResult.dao.findById(srid).set("srissubmit", 1).update();
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
}
