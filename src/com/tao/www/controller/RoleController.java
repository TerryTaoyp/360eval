package com.tao.www.controller;

import java.util.List;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.model.EmployeeToRole;
import com.tao.www.model.Role;
import com.tao.www.model.RoleToAuthority;

public class RoleController extends Controller {

	public void index(){
		this.render("role.jsp");
	}
	
	//@Before(LoginValidator. class) //数据校验拦截器
	public void getRoleList(){
		/*String userName = this.getPara("userName");
		String sayHello = "Hello " + userName + ", welcome to JFinal world.";
		this.setAttr("sayHello", sayHello);
		this.render("/hello.jsp");*/
		//System.out.println(getPara("ni"));
		String search = getPara("search");
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = "from t_role";
		}else{
			sqlExpectSelect = "from t_role where rname like '%"+search+"%'";
		}
		System.out.println("sqlExpectSelect:"+sqlExpectSelect);
		//分页查
		Page<Role> rolePage = Role.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				"select *",
				sqlExpectSelect);
		//System.out.println("第几页:"+(getParaToInt("offset", 0)/getParaToInt("limit", 10)+1)+"===每页条数:"+getParaToInt("limit", 10));
		int total = rolePage.getTotalRow();
		//DepartmentType.dao.paginate(page, 15, "select *", "from item where" + sqlCondition + " order by id desc"))
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(rolePage.getList())+"}");
		this.renderJson(sb.toString());
	}
	
	public void addRole(){
		Role role = getModel(Role.class);
		//System.out.println(departmentType.getStr("name"));
		role.save();
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void updateRole(){
		Role role = getModel(Role.class);
		//System.out.println(departmentType.getStr("name"));
		role.update();
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void removeRole(){
		int rid = getParaToInt("rid");
		//System.out.println(departmentType.getStr("name"));
		Role.dao.deleteById(rid);
		this.renderJson("{\"message\":\"success!\"}");
	}
	public void batchRemoveRole(){
		String[] ridStrArr = getPara("rids").split(",");
		for(String rid : ridStrArr){
			Role.dao.deleteById(rid);
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void distriAuthority(){
		String aidStr = getPara("aids");
		String[] aidStrArr = new String[0];;
		if(aidStr!=null&&!"".equals(aidStr)){
			aidStrArr = getPara("aids").split(",");
		}
		//System.out.println("aids:"+getPara("aids"));
		int rid = getParaToInt("rid")==null?0:getParaToInt("rid");
		//根据rid查询之前存在的权限并删除
		List<RoleToAuthority> roleToAuthList = RoleToAuthority.dao.find("select rid,aid from t_role_authority where rid="+rid);
		if(roleToAuthList!=null){
			for(RoleToAuthority rta :roleToAuthList){
				RoleToAuthority.dao.deleteById(rta.getLong("rid"),rta.getLong("aid"));
			}
		}
		//更新rid权限
		RoleToAuthority roleToAuthority = new RoleToAuthority();
		for(String aid : aidStrArr){
			roleToAuthority.set("aid", Integer.valueOf(aid));
			roleToAuthority.set("rid", rid);
			roleToAuthority.save();
			//System.out.println("aid:"+aid+"<====>"+"rid:"+rid);
		}
		this.renderJson("{\"message\":\"success!\"}");
	}
	
	public void getAllRoleList(){
		List<Role> roleList = Role.dao.find("select rid,rname from t_role");
		this.renderJson(roleList);
	}
	public void getRoleTree(){
		int eid = getParaToInt("eid")==null?0:getParaToInt("eid");
		List<Role> roleList = Role.dao.find("select rid,rname from t_role order by rid asc");
		System.out.println("roleList:"+roleList.size());
		StringBuffer sb = new StringBuffer();
		sb.append("[ ");
		sb.append("{ \"id\":\"0\", \"pId\":\"-1\", \"name\":\"所有角色\", \"iconOpen\":\"/360eval/css/zTreeStyle/img/diy/1_open.png\", \"iconClose\":\"/360eval/css/zTreeStyle/img/diy/1_close.png\", \"open\":\"false\"},");
		int index = 0;
		EmployeeToRole etr = null;
		for(Role r :roleList){
			sb.append("{");
			sb.append("\"id\":\""+r.getLong("rid")+"\"");
			sb.append(",\"pId\":\"0\"");
			sb.append(",\"name\":\""+r.getStr("rname")+"\"");
			etr = EmployeeToRole.dao.findById(eid,r.getLong("rid"));
			if(etr!=null){//如果当前人员有分配角色则加载选中
				sb.append(",\"checked\":\"true\"");
			}
			sb.append("}");
			if(index<roleList.size()-1){
				sb.append(",");
			}
			index++;
			
		}
		sb.append("]");
		this.renderJson(sb.toString());
	}
}
