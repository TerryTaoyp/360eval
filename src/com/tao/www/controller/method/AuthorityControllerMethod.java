package com.tao.www.controller.method;

import java.util.ArrayList;
import java.util.List;

import com.jfinal.core.Controller;
import com.jfinal.kit.JsonKit;
import com.jfinal.plugin.activerecord.Page;
import com.tao.www.controller.sql.AuthorityControllerSql;
import com.tao.www.model.Authority;
import com.tao.www.model.RoleToAuthority;

public class AuthorityControllerMethod extends Controller{
	AuthorityControllerSql authorityControllerSql;

	
	public List<Authority> tinit(){
		List<Authority> authorityList = Authority.dao.find(authorityControllerSql.authorityListSql);
		return authorityList;
	}
	/**
	 * 初始化页面，获取所有的Authority所对应的方法
	 */
	public StringBuffer tgetAuthorityList(){
		String search = getPara("search");
		String sqlExpectSelect = null;
		if(search==null||"".equals(search)){
			sqlExpectSelect = authorityControllerSql.sqlExpectSelect1;
		}else{
			sqlExpectSelect = authorityControllerSql.sqlExpectSelect2;
		}
		//分页查
		Page<Authority> authorityPage = Authority.dao.paginate(
				getParaToInt("offset", 0)/getParaToInt("limit", 50)+1, 
				getParaToInt("limit", 50),
				authorityControllerSql.authorityPageSql,
				sqlExpectSelect);
		int total = authorityPage.getTotalRow();
		StringBuffer sb = new StringBuffer();
		sb.append("{\"total\":"+total).append(",\"rows\":"+JsonKit.toJson(authorityPage.getList())+"}");
		return sb;
	}
	
	public void taddAuthority(){
		Authority authority = getModel(Authority.class);
		authority.save();
	}
	
	public void tupdateAuthority(){
		Authority authority = getModel(Authority.class);
		System.out.println(authority);
		authority.update();
	}
	
	public void tremoveAuthority(){
		int aid = getParaToInt("aid");
		Authority.dao.deleteById(aid);
	}
	
	public void tbatchRemoveAuthority(){
		String[] aidStrArr = getPara("aids").split(",");
		for(String aid : aidStrArr){
			Authority.dao.deleteById(aid);
		}
	}
	
		//根据角色获取权限树
		public List<Authority> getTree2(List<Authority> al){
			List<Authority> nodeList = new ArrayList<Authority>();
	        for (Authority a : al) {
	            boolean mark = false;
	            for (Authority b : al) {
	                if (a.getLong("pid") == b.getLong("id")) {
	                    mark = true;
	                    if (b.get("submenu") == null) {
	                        b.put("submenu",new ArrayList<Authority>());
	                    }
	                    //得到这个数据
	                    @SuppressWarnings("unchecked")
						ArrayList<Authority> submenu =  (ArrayList<Authority>)b.get("submenu");
	                    if(!submenu.contains(a)){
	                    	submenu.add(a);
	                    }
	                    break;
	                }
	            }
	            if (!mark) {
	                nodeList.add(a);
	            }
	        }
	        return nodeList;
		}
		
		public StringBuffer getAuthorityTree(){
			int rid = getParaToInt("rid")==null?0:getParaToInt("rid");
			List<Authority> authorityList = Authority.dao.find(authorityControllerSql.authorityListSql1);
			StringBuffer sb = new StringBuffer();
			sb.append("[ ");
			sb.append("{ \"id\":\"0\", \"pId\":\"-1\", \"name\":\"所有权限\", \"iconOpen\":\"/360eval/css/zTreeStyle/img/diy/1_open.png\", \"iconClose\":\"/360eval/css/zTreeStyle/img/diy/1_close.png\", \"open\":\"true\"},");
			int index = 0;
			//if(authorityList.size()>0){
			//	sb.append(",");
			//}
			RoleToAuthority rtr = null;
			for(Authority a :authorityList){
				sb.append("{");
				sb.append("\"id\":\""+a.getLong("aid")+"\"");
				sb.append(",\"pId\":\""+a.getLong("aparent")+"\"");
				sb.append(",\"name\":\""+a.getStr("aname")+"\"");
				rtr = RoleToAuthority.dao.findById(rid,a.getLong("aid"));
				if(rtr!=null){//如果当前人员有分配角色则加载选中
					sb.append(",\"checked\":\"true\"");
				}
				sb.append("}");
				if(index<authorityList.size()-1){
					sb.append(",");
				}
				index++;
			}
			sb.append("]");
			return sb;
		}
}
