package com.tao.www.model;


import com.jfinal.plugin.activerecord.Model;

public class SatisfyQuestion extends Model<SatisfyQuestion> {

	private static final long serialVersionUID = 1L;
	
	public static final SatisfyQuestion dao = new SatisfyQuestion();
	
	/*public void setSatisfyOptionList(List<SatisfyOption> soList){
		super.put("satisfyOptionList",soList);
	}
	public List<SatisfyOption> getSatisfyOptionList(){
		return super.get("satisfyOptionList");
	}*/
}
