package com.tao.www.model;

import java.util.List;

import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;

public class DepartmentType extends Model<DepartmentType> {

		private static final long serialVersionUID = 1L;
		// 方便于访问数据库，不是必须
		public static final DepartmentType dao = new DepartmentType();
		
		//一对多关联
		public  List<Department> getDepartmentList(){
			return Department.dao.find("select * from t_department where dtid=?",get("dtid"));
		}
		
		/**
		 * 所有 sql 与业务逻辑写在 Model 或 Service 中 方法说明
		 * 
		 * @Discription:扩展说明
		 * @param pageNumber
		 * @param pageSize
		 * @Author: zhanggy
		 * @Date: 2015年11月25日
		 * @return Page<DepartmentType>
		 */
		public Page<DepartmentType> paginate(int pageNumber, int pageSize) {
			//这里体会到了jfinal的强大之处，mysql和oracle的分页都只需下面这一句就可以了。。
			return paginate(pageNumber, pageSize, "select * ","from t_department_type order by dtid asc");
		}
}
