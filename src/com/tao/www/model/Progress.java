package com.tao.www.model;

import com.jfinal.plugin.activerecord.Model;

public class Progress extends Model<Progress> {

	private static final long serialVersionUID = 1L;
	
	// 方便于访问数据库，不是必须
	public static final Progress dao = new Progress();
}
