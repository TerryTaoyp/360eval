/**
 * 
 */
package com.tao.www.config;

import com.jfinal.config.Constants;
import com.jfinal.config.Handlers;
import com.jfinal.config.Interceptors;
import com.jfinal.config.JFinalConfig;
import com.jfinal.config.Plugins;
import com.jfinal.config.Routes;
import com.jfinal.core.JFinal;
import com.jfinal.ext.handler.ContextPathHandler;
import com.jfinal.kit.PropKit;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.jfinal.plugin.c3p0.C3p0Plugin;
import com.jfinal.render.ViewType;
import com.tao.www.config.config._MappingKit;
import com.tao.www.controller.AuthorityController;
import com.tao.www.controller.DepartmentController;
import com.tao.www.controller.DepartmentQuestionController;
import com.tao.www.controller.DepartmentResultController;
import com.tao.www.controller.DepartmentTypeController;
import com.tao.www.controller.DepmDistributeController;
import com.tao.www.controller.EmployeeController;
import com.tao.www.controller.EmployeeOptionController;
import com.tao.www.controller.EmployeeQuestionBasicController;
import com.tao.www.controller.EmployeeQuestionStandardController;
import com.tao.www.controller.EmployeeResultController;
import com.tao.www.controller.EvalDistributeController;
import com.tao.www.controller.GradeController;
import com.tao.www.controller.IndexController;
import com.tao.www.controller.ProgressController;
import com.tao.www.controller.ResultTypeController;
import com.tao.www.controller.RoleController;
import com.tao.www.controller.DepartmentOptionController;
import com.tao.www.controller.SatisfyQuestionController;
import com.tao.www.controller.SatisfyResultController;
import com.tao.www.controller.StatisticController;
import com.tao.www.controller.TotalScaleController;
import com.tao.www.interceptor.LoginInterceptor;
/**  
 * AppConfig配置文件
 * @Author: tao
 * @Date: 2015年11月25日
 * @Version:V1.0
 */
public class AppConfig extends JFinalConfig {
	/**
	 * 配置常量
	 * @Discription:扩展说明
	 * @Author: tao
	 * @Date: 2015年11月25日
	 * @see com.jfinal.config.JFinalConfig#configConstant(com.jfinal.config.Constants)
	 */
	@Override
	public void configConstant(Constants me) {
		//加载系统属性配置文件 随后可用getProperty(...)获取值
		loadPropertyFile("system_config_info.txt");
		//设置开发模式
		me.setDevMode(getPropertyToBoolean("devMode", false));
		//设置编码方式
		me.setEncoding("utf-8");
		//设置视图类型为Jsp，否则默认为FreeMarker
		me.setViewType(ViewType.JSP);
		//设置404和500错误页面 相对于项目webRoot根目录路径
		me.setError404View("/login.jsp");
		me.setError500View("/login.jsp");
	}

	/**
	 * 配置路由
	 * @Discription:扩展说明
	 * @Author: tao
	 * @Date: 2015年11月25日
	 * @see com.jfinal.config.JFinalConfig#configRoute(com.jfinal.config.Routes)
	 */
	@Override
	public void configRoute(Routes me) {
		//第三个参数为该Controller的视图存放路径
		me.add("/", IndexController.class,"/");
		me.add("system/department", DepartmentController.class,"/system");
		me.add("system/depmDistribute", DepmDistributeController.class,"/system");
		me.add("system/departmentType", DepartmentTypeController.class,"/system");
		me.add("system/employee", EmployeeController.class,"/system");
		me.add("system/authority", AuthorityController.class,"/system");
		me.add("system/role", RoleController.class,"/system");
		
		me.add("eval/statistic", StatisticController.class,"/eval");
		me.add("eval/grade", GradeController.class,"/eval");
		me.add("eval/totalScale", TotalScaleController.class,"/eval");
		me.add("eval/progress", ProgressController.class,"/eval");
		me.add("eval/satisfyQuestion", SatisfyQuestionController.class,"/eval");
		me.add("eval/departmentQuestion", DepartmentQuestionController.class,"/eval");
		me.add("eval/departmentOption", DepartmentOptionController.class,"/eval");
		me.add("eval/employeeQuestionBasic", EmployeeQuestionBasicController.class,"/eval");
		me.add("eval/employeeQuestionStandard", EmployeeQuestionStandardController.class,"/eval");
		me.add("eval/employeeOption", EmployeeOptionController.class,"/eval");
		me.add("eval/evalDistribute", EvalDistributeController.class,"/eval");
		
		me.add("result/resultType", ResultTypeController.class,"/result");
		me.add("result/satisfyResult", SatisfyResultController.class,"/result");
		me.add("result/departmentResult", DepartmentResultController.class,"/result");
		me.add("result/employeeResult", EmployeeResultController.class,"/result");
	}

	/**
	 * 配置插件
	 * @Discription:扩展说明
	 * @Author: tao
	 * @Date: 2015年11月25日
	 * @see com.jfinal.config.JFinalConfig#configPlugin(com.jfinal.config.Plugins)
	 */
	public static C3p0Plugin createC3p0Plugin() {
		return new C3p0Plugin(PropKit.get("jdbcUrl"), PropKit.get("user"), PropKit.get("password").trim());
	}
	@Override
	public void configPlugin(Plugins me) {
		//配置Mysql支持
		//配置c3p0数据库连接池插件
		C3p0Plugin cp = new C3p0Plugin(getProperty("jdbcUrl"), getProperty("user"), getProperty("password"));
		me.add(cp);
		//配置ActiveRecord插件
		ActiveRecordPlugin arp = new ActiveRecordPlugin(cp);
		//arp.setShowSql(true);
		//事务级别
		arp.setTransactionLevel(4);
		me.add(arp);
		// 所有配置在 MappingKit 中搞定
		_MappingKit.mapping(arp);
	}

	/**
	 * 配置全局拦截器
	 * @Discription:扩展说明
	 * @Author: tao
	 * @Date: 2015年11月25日
	 * @see com.jfinal.config.JFinalConfig#configInterceptor(com.jfinal.config.Interceptors)
	 */
	@Override
	public void configInterceptor(Interceptors me) {
		//全局异常处理
		//me.add(new ExceptionInterceptor());
		//登录拦截
		me.add(new LoginInterceptor());
	}

	/**
	 * 配置处理器
	 * @Discription:扩展说明
	 * @Author: tao
	 * @Date: 2015年11月25日
	 * @see com.jfinal.config.JFinalConfig#configHandler(com.jfinal.config.Handlers)
	 */
	@Override
	public void configHandler(Handlers me) {
		//处理后缀
		//me.add(new PostfixSkipHandler());
		me.add(new ContextPathHandler("basePath"));
	}
	
	/**
	 * 建议使用 JFinal 手册推荐的方式启动项目
	 * 运行此 main 方法可以启动项目，此main方法可以放置在任意的Class类定义中，不一定要放于此
	 */
	public static void main(String[] args) {
		JFinal.start("WebRoot", 8081, "/", 5);
	}

}
