package com.tao.www.model;


import com.jfinal.plugin.activerecord.Model;

public class Role extends Model<Role> {

	private static final long serialVersionUID = 1L;
	
	public static final Role dao = new Role();
	
	/*public void setEmployeeList(){
		super.put("employeeList",DepartmentType.dao.findById(get("dtid")));
	}
	
	public List<Employee> getEmployeeList(){
		return super.get("employeeList");
	}
	
	public void setAuthorityList(){
		super.put("authorityList",DepartmentType.dao.findById(get("dtid")));
	}
	
	public List<Authority> getAuthorityList(){
		return super.get("authorityList");
	}*/
}
