package com.tao.www.plugin;

import java.util.List;

import com.tao.www.model.DepartmentCollection;

public class Dr {
	
	private String dname;
	private List<DepartmentCollection>  dcList ;
	public String getDname() {
		return dname;
	}
	public void setDname(String dname) {
		this.dname = dname;
	}
	public List<DepartmentCollection> getDcList() {
		return dcList;
	}
	public void setDcList(List<DepartmentCollection> dcList) {
		this.dcList = dcList;
	}
	public Dr(String dname, List<DepartmentCollection> dcList) {
		super();
		this.dname = dname;
		this.dcList = dcList;
	}

	public Dr(){
		
	}
	
}
