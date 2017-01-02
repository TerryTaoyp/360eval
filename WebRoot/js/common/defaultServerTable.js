//服务端分页默认表格参数
$.extend($.fn.bootstrapTable.defaults, {
	method: "post", //请求提交方式
    pagination: true, //分页
    search: true, //搜索
    showRefresh: true, //刷新
    showToggle: true, //切换显示
    showColumns: true, //列显示选择
    iconSize: 'outline', //图标样式
    icons: { //图标
          refresh: 'glyphicon-repeat',
          toggle: 'glyphicon-list-alt',
          columns: 'glyphicon-list'
       },
    //detailView: true,
    striped: true, //行变色
    pageList: [50,100],//每页大小
    toolbar: tableToolbar,
    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
    paginationFirstText: "首页",
    paginationPreText: "上一页",
    paginationNextText: "下一页",
    paginationLastText: "尾页",
    sidePagination:'server',//设置为服务器端分页
    clickToSelect: false,
    smartDisplay: true,
    //height: 500, //高度
    //showExport: true, //导出
	//queryParams: queryParams,//提交到后台额外参数
	//queryParams: queryParams,//提交到后台额外参数
    //searchText : "当前页搜索",
    pageSize: 50	//初始化显示多少条
    //pageNumber: 1, //初始化显示第几页
    //ajaxOptions :{"ni":"你大爷"}, //额外参数,不懂
    //queryParamsType : "limit", 不懂
    //searchTimeOut : 500, 搜索时间限制
    //showFooter :true, //显示表页脚
    //showPaginationSwitch :true,隐藏显示分页,需要配合图标
    //url: "${basePath}/hello",//数据路径 返回结果类似{"total":10,"rows":[{"id":1,"name":"n1"},{"id":2,"name":"n2"}]}
});
//列对齐方式参数
$.extend($.fn.bootstrapTable.columnDefaults, {align: 'center',valign: 'middle'});
//随机颜色
function rowStyle(row, index) {
	  var classes = ['active', 'success', 'info', 'warning', 'danger'];
	  if (index % 2 === 0 && index / 2 < classes.length) {
	    return {classes: classes[index / 2]};
	  }
	  return {};
}