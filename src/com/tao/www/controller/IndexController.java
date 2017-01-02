/**
 * 
 */
package com.tao.www.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.jfinal.aop.Clear;
import com.jfinal.core.Controller;
import com.jfinal.kit.PropKit;
import com.jfinal.plugin.activerecord.Db;
import com.tao.www.interceptor.LoginInterceptor;
import com.tao.www.model.Authority;
import com.tao.www.model.Department;
import com.tao.www.model.Employee;
import com.tao.www.model.Now;
import com.tao.www.model.Progress;
import com.tao.www.model.Role;
import com.tao.www.model.Statistic;

public class IndexController extends Controller {

	//@Before(Tx. class) //添加声明式事务
	@Clear(LoginInterceptor.class)
	//@Before(NoUrlPara.class)
	public void index() {
		//查询全部
		//List<DepartmentType> departmentTypeList = DepartmentType.dao.find("select * from t_department_type");
		//setAttr("departmentTypeList", departmentTypeList);
		//通过id查询
		//DepartmentType departmentType= DepartmentType.dao.findById(1);
		//setAttr("departmentType", departmentType);
		//分页查
		//Page<DepartmentType> departmentTypePage = DepartmentType.dao.paginate(getParaToInt(0, 1), 1);
		//setAttr("departmentTypePage", departmentTypePage);
		//添加
		//new DepartmentType().set("name","贡献型部门").set("describe", "贡献型部门描述").save();
		//删除
		//DepartmentType.dao.deleteById(4);
		//更新
		//DepartmentType.dao.findById(4).set("name", "贡献型部门").update();
		//获取字段
		//DepartmentType departmentType = DepartmentType.dao.findByIdLoadColumns(4,"dtid,name,describe");
		//String name = departmentType.getStr("name");
		//Long describe = departmentType.getLong("dtid");
		//关联关系获取
		//DepartmentType departmentType = DepartmentType.dao.findById(1);
		//List<Department> departmentList= departmentType.getDepartmentList();
		//Department department= departmentType.getDepartmentList().get(0);
		//department.setDepartmentType();
		//System.out.println(department.getDepartmentType());
		//setAttr("department", department);
		//System.out.println("部门名称:"+departmentList.get(0).getStr("name"));
		//System.out.println("部门类型名称:"+departmentList.get(0).getDepartmentType().getStr("name"));
		this.render("login.jsp");
	}
	@Clear(LoginInterceptor.class)
	public void login(){
		this.render("login.jsp");
	}
	
	@Clear(LoginInterceptor.class)
	public void check(){
		Employee em = getModel(Employee.class);
		if(em!=null&&em.getStr("ename")!=null&&em.getStr("ename")!=null){
			Employee employee = Employee.dao.findFirst("select * from t_employee where ename='"+em.getStr("ename")+"' and pwd='"+em.getStr("pwd")+"'");
			if(employee!=null){
				if(employee.getInt("isactive")==0){
					setAttr("error", "你的信息正在审核中,请耐心等待!");
					this.render("login.jsp");
				}else{
					Statistic sc = Statistic.dao.findFirst("select * from t_statistic where sisactive=1");
					if(sc==null){
						sc =  Statistic.dao.findFirst("select * from t_statistic where "
								+ "sid=(select sid from t_now where id=1)");
					}
					setSessionAttr("sc", sc);//将当前开启的测评保存到session
					setSessionAttr("ee", employee);//将这个人的信息保存到session
					List<Role> roleList = Role.dao.find("select r.rname,r.rid from t_role r inner join"
							+ " t_employee_role er on r.rid = er.rid where er.eid="+employee.getLong("eid"));
					setSessionAttr("roleList", roleList);//角色列表
					
					StringBuffer sb = new StringBuffer();
					String rName = "";
					String tn = null;
					for(Role r: roleList){
						sb.append(r.getLong("rid")+",");
						tn = r.getStr("rname").trim();
						rName += tn+"|";
					}
					String rids = sb.toString().substring(0,sb.toString().length()-1);//角色rids
					if(rName.contains("|")){
						rName = rName.substring(0,rName.length()-1);
					}
					setSessionAttr("rName", rName);
					List<Authority> auList = new ArrayList<Authority>();
					if(sb.length()>0){
						//select aname name,apath url,aid id,aparent pid
						 auList = Authority.dao.find("select distinct a.aid id,a.aname "
									+ "name,a.apath url,a.aparent pid from t_authority a "
									+ "inner join t_role_authority ra on a.aid=ra.aid where ra.rid in ("
									+rids+") order by a.aparent asc,a.aid asc");//and ra.aid>0
					}
					setSessionAttr("auList", auList);//权限列表
					//设置session过期时间单位秒
					getSession().setMaxInactiveInterval(60*60*8);
					//这里再将这个人当前测评应该参与的各项测评的数据放入进度表
					if(sc!=null){
						long sid = sc.getLong("sid");
						long eid = employee.getLong("eid");
						//先去查看进度表里面有没有数据
						Progress ps = Progress.dao.findFirst("select * from t_progress where sid="+sid
								+" and eid="+eid);
						//没有数据说明第一次登录,这里就去根据其角色查询出他对应的各种应测评的数量,然后save
						if(ps==null){
							String str2 = "直属副总经理";
							System.out.println(rName);
							//先过滤掉系统管理员和董事长,这两个角色可以正常登录但不参与测评,所以不插入到测评进度表中
							if(!(rName.contains("董事长")||rName.contains("系统管理员"))){
								ps = new Progress();
								ps.set("sid", sid);
								ps.set("eid", eid);
								/*
								 * 1.满意度测评,直接设置为未测评
								 */
								//满意度未测评
								ps.set("siseval", 0);
								/*
								 * 2.部门测评,根据角色去确定
								 */
								String sqlExpectSelect1 = null;
								//当前登录人只有一个直属副总经理角色,就从对应配置表里取他能测评的部门
								if(str2.indexOf(rName.trim())>-1){
									sqlExpectSelect1 = "select count(ed.did) from t_employee_department ed "
											+ "inner join t_department d on ed.did=d.did where ed.eid= "+eid;
								}else{
									sqlExpectSelect1 = "select count(did) from t_department d where 1=1 ";
								}
								//应测评部门数,实际测评数
								ps.set("dtnum", Db.queryLong(sqlExpectSelect1));
								ps.set("dpnum", 0);
								
								/**
								 * 3.部门经理评价,也根据角色去确定
								 */
								String sqlExpectSelect2 = null;
								if(str2.indexOf(rName.trim())>-1){
									StringBuffer ed = new StringBuffer();
									ed.append("select count(eid) from ( select e.*,dt.dtid,r.rid,d.dname  FROM t_employee_employee ee ")
									   .append("INNER JOIN t_employee e on ee.eeid=e.eid ")
									   .append("INNER JOIN t_department d on e.did=d.did ")
									   .append("inner join t_department_type dt on dt.dtid=d.dtid  ")
									   .append("INNER JOIN t_employee_role er on ee.eeid=er.eid ")
									   .append("INNER JOIN t_role r on r.rid=er.rid ")
									   .append("where r.rname like '%部%门%经%理%' and e.isactive=1 and ee.eid="+eid)
									   .append(" UNION ")
									   .append("select e.*,dt.dtid,r.rid,d.dname from t_employee_department ed ")
									   .append("INNER JOIN t_employee e on ed.did=e.did ")
									   .append("inner join t_department d on e.did=d.did ")
									   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
									   .append("INNER JOIN t_employee_role er on e.eid=er.eid ")
									   .append("INNER JOIN t_role r on r.rid=er.rid ")
									   .append("where r.rname like '%部%门%经%理%' and e.isactive=1 and ed.eid="+eid+" ) aa");
									sqlExpectSelect2 = ed.toString();
								}else{
									//其他角色可以测评所有部门经理
									sqlExpectSelect2 = "select count(eid) from (select e.*,dt.dtid,r.rid,d.dname from t_employee e "
											+ "inner join t_employee_role er on e.eid=er.eid "
											+ "inner join t_department d on d.did=e.did "
											+ "inner join t_department_type dt on dt.dtid=d.dtid "
											+ "inner join t_role r on er.rid=r.rid where r.rname like '%部%门%经%理%' "
											+ "and e.isactive=1) aa";
								}
								//应测评部门经理数,实际测评数
								ps.set("edtnum", Db.queryLong(sqlExpectSelect2));
								ps.set("edpnum", 0);
								
								/**
								 * 4.普通员工评价,也根据角色去确定
								 */
								//先去查询额外配置表
								StringBuffer ee = new StringBuffer();
								ee.append("select count(eid) from ( select e.*,dt.dtid,r.rid,d.dname  FROM t_employee_employee ee ")
								   .append("INNER JOIN t_employee e on ee.eeid=e.eid ")
								   .append("INNER JOIN t_department d on e.did=d.did ")
								   .append("inner join t_department_type dt on dt.dtid=d.dtid  ")
								   .append("INNER JOIN t_employee_role er on ee.eeid=er.eid ")
								   .append("INNER JOIN t_role r on r.rid=er.rid ")
								   .append("where r.rname like '%普%通%员%工%' and e.isactive=1 and ee.eid="+eid);
								//如果角色里面还有部门经理或者普通员工角色,则加入该角色对应部门的员工列表
								if(rName.contains("部门经理")||rName.contains("普通员工")){
									ee.append(" UNION ")
									   .append("select e.*,dt.dtid,r.rid,d.dname from t_employee e ")
									   .append("inner join t_employee_role er on e.eid=er.eid  ")
									   .append("inner join t_department d on d.did=e.did ")
									   .append("inner join t_department_type dt on dt.dtid=d.dtid ")
									   .append("inner join t_role r on er.rid=r.rid where r.rname like '%员%工%' ")
									   .append("and e.isactive=1 and d.did="+employee.getLong("did"));
								}
							    ee.append(" ) aa");
							    //应测评普通员工数,实际测评数
								ps.set("eetnum", Db.queryLong(ee.toString()));
								ps.set("eepnum", 0);
								ps.save();
							}
							
						}
					}
					Statistic st = Statistic.dao.findFirst("select * from t_statistic where sisactive=1");
					if(st!=null){
						Date etime = st.getDate("etime");
						if(etime.compareTo(new Date())<=0){
							st.set("sisactive", 0).update();
							Now.dao.findById(1)
								   .set("sid", st.getLong("sid"))
								   .update();
						}
					}
					
					this.redirect("/main");//重定向,解决表单重复提交问题,将main.jsp隐藏为main,增强安全性
					//this.render("main.jsp");
				}
				
			}else{
				setAttr("error", "用户名或密码错误!");
				this.render("login.jsp");
			}
		}else{
			setAttr("error", "请输入用户名和密码!");
			this.render("login.jsp");
		}
	}
	public void main(){
		this.render("main.jsp");
	}
	@Clear(LoginInterceptor.class)
	public void register(){
		List<Department> departmentList = Department.dao.find("select * from t_department");
		setAttr("departmentList", departmentList);
		this.render("register.jsp");
	}
	
	public void out(){
		getSession().invalidate();
		this.render("login.jsp");
	}
}
