package com.tao.www.controller;

import java.util.List;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.Employee;
import com.tao.www.model.Grade;
import com.tao.www.model.SatisfyQuestion;
import com.tao.www.model.SatisfyResult;
import com.tao.www.model.Statistic;

public class SatisfyQuestionController extends Controller {

	public void index(){
		this.render("satisfyQuestion.jsp");
	}
	
	public void satisfyList(){
		Statistic sc = (Statistic)getSessionAttr("sc");
		if(sc!=null){
			setAttr("sname", sc.getStr("sname"));
		}else{
			setAttr("sname", "测评未开启");
		}
		this.render("satisfyList.jsp");
	}
	
	public void satisfyTest(){
		//找到所有的测评问题
		List<SatisfyQuestion> satisfyQuestionList = SatisfyQuestion.dao.find("select * from  t_satisfy_question where sqisactive=1 order by sqid asc ");
		List<Grade> gradeList = Grade.dao.find("select * from  t_grade order by gnum asc");
		setAttr("gradeList", gradeList);
		setAttr("satisfyQuestionList", satisfyQuestionList);
		setAttr("size", satisfyQuestionList.size());
		this.render("satisfyTest.jsp");
	}
	
	public void getStatisfyList(){
		StringBuffer sb = new StringBuffer();
		Statistic sc = getSessionAttr("sc");
		Employee ee = getSessionAttr("ee");
		if(sc!=null&&ee!=null){
			//区查询当前用户是否已经测评
			SatisfyResult satisfyResult = SatisfyResult.dao.findFirst("select * from t_satisfy_result where eid="+ee.getLong("eid")
					+" and sid="+sc.getLong("sid"));
			Float srtotal = 0.0F;
			int srissubmit = 0; 
			long srid = 0L;
			if(satisfyResult!=null){
				srtotal =satisfyResult.getFloat("srtotal");
				srissubmit =satisfyResult.getInt("srissubmit");
				srid = satisfyResult.getLong("srid");
			}
			sb.append("{\"total\":"+1)
			  .append(",\"rows\":")
			  .append("[{")
			  .append("\"id\":"+1)
			  .append(",\"name\":\"长春担保公司满意度测评\"")
			  .append(",\"srtotal\":"+srtotal)
			  .append(",\"srissubmit\":"+srissubmit)
			  .append(",\"srid\":"+srid)
			  .append("}]")
			  .append("}");
			this.renderJson(sb.toString());
		}else{
			sb.append("{\"total\":\""+0+"\"").append(",\"rows\":"+"[]"+"}");
			this.renderJson(sb.toString());
		}
	}
	
	//@Before(LoginValidator. class) //数据校验拦截器
	public void getSatisfyQuestionList(){
		String search = getPara("search");
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from t_satisfy_question";
		}else{
			sqlExpectSelect = "from t_satisfy_question where sqname like '%"+search+"%'";
		}
		System.out.println("sqlExpectSelect:"+sqlExpectSelect);
		//分页查
		Page<SatisfyQuestion> satisfyQuestionPage = SatisfyQuestion.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"select *",
				sqlExpectSelect);
		int total = satisfyQuestionPage.getTotalRow();
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(satisfyQuestionPage.getList())+"}");
		this.renderJson(sb.toString());
		
	}
	
	
	public void addSatisfyQuestion(){
		SatisfyQuestion satisfyQuestion = getModel(SatisfyQuestion.class);
		satisfyQuestion.save();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void editSatisfyQuestion(){
		SatisfyQuestion satisfyQuestion = getModel(SatisfyQuestion.class);
		satisfyQuestion.update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void updateSatisfyQuestion(){
		int sqid = getParaToInt("sqid");
		int sqisactive = getParaToInt("sqisactive");
		//修改当前状态,停用时将问题及其对应选项分值置0
		/*if(sqisactive==0){
			SatisfyQuestion.dao.findById(sqid)
			.set("sqisactive", sqisactive)
			.set("sqweight", 0)
			.update();
			Db.update("update t_satisfy_option set soweight=0 where sqid="+sqid);
		}else{*/
			SatisfyQuestion.dao.findById(sqid).set("sqisactive", sqisactive).update();
		//}
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void removeSatisfyQuestion(){
		int sqid = getParaToInt("sqid");
		SatisfyQuestion.dao.deleteById(sqid);
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchRemoveSatisfyQuestion(){
		String[] sqidStrArr = getPara("sqids").split(",");
		for(String sqid : sqidStrArr){
			SatisfyQuestion.dao.deleteById(sqid);
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
}
