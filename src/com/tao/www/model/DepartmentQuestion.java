package com.tao.www.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Model;

public class DepartmentQuestion extends Model<DepartmentQuestion> {

	private static final long serialVersionUID = 1L;
	
	public static final DepartmentQuestion dao = new DepartmentQuestion();
	
	public void setDepartmentOptionList(List<DepartmentOption> departmentOptionList){
		super.put("departmentOptionList",departmentOptionList);
	}
	public List<DepartmentOption> getDepartmentOptionList(){
		return super.get("departmentOptionList");
	}
}
