package com.tao.www.model;


import com.jfinal.plugin.activerecord.Model;

public class Department extends Model<Department> {

	private static final long serialVersionUID = 1L;
	
	// 方便于访问数据库，不是必须
	public static final Department dao = new Department();
	//多对一关联
	/*public DepartmentType getDepartmentType() {
		return DepartmentType.dao.findById(get("dtid"));
	}*/
	
	//部门
	public void setDepartmentType(){
		super.put("departmentType",DepartmentType.dao.findById(get("dtid")));
	}

	public DepartmentType getDepartmentType(){
		return super.get("departmentType");
	}
	
}
