package com.tao.www.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Model;

public class Employee extends Model<Employee> {

	private static final long serialVersionUID = 1L;
	
	public static final Employee dao = new Employee();
	
	public void setDepartment(){
		super.put("departemnt", Department.dao.findById(get("did")));
	}
	
	public Department getDepartment(){
		return super.get("departemnt");
	}
	
	public void setRoleList(){
		super.put("roleList",Role.dao.find("SELECT r.rid,r.name,r.rtype"));
	}
	
	public List<Role> getRoleList(){
		return super.get("roleList");
	}
}
