
/**
 * JSON无限折叠菜单
 * @constructor {AccordionMenu}
 * @param {options} 对象
 * @date 2013-12-13
 * @author tugenhua
 * @email 879083421@qq.com
 */

 function AccordionMenu(options) {
	this.config = {
		containerCls        : '.sidebar-collapse',                // 外层容器
		menuArrs            :  '',                         //  JSON传进来的数据
		type                :  'click',                    // 默认为click 也可以mouseover
		renderCallBack      :  null,                       // 渲染html结构后回调
		clickItemCallBack   : null                         // 每点击某一项时候回调
	};
	this.cache = {
		
	};
	this.init(options);
 }

 
 AccordionMenu.prototype = {

	constructor: AccordionMenu,

	init: function(options){
		this.config = $.extend(this.config,options || {});
		var self = this,
			_config = self.config,
			_cache = self.cache;
		
		// 渲染html结构
		$(_config.containerCls).each(function(index,item){
			
			self._renderHTML(item);

			// 处理点击事件
			self._bindEnv(item);
		});
	},
	_renderHTML: function(container){
		var self = this,
			_config = self.config,
			_cache = self.cache;
		var ulhtml = $('<ul class="nav" id="side-menu">'
						+'</ul>');
		$(_config.menuArrs).each(function(index,item){
			var lihtml = $('<li><a href="#"> <i class="glyphicon glyphicon-cog"></i><span class="nav-label">'+item.name+'</span><span class="fa arrow"></span></a></li>');

			if(item.submenu && item.submenu.length > 0) {
				self._createSubMenu(item.submenu,lihtml);
			}
			$(ulhtml).append(lihtml);
		});
		$(container).append(ulhtml);
		
		_config.renderCallBack && $.isFunction(_config.renderCallBack) && _config.renderCallBack();
		
		// 处理层级缩进
		self._levelIndent(ulhtml);
	},
	/**
	 * 创建子菜单
	 * @param {array} 子菜单
	 * @param {lihtml} li项
	 */
	_createSubMenu: function(submenu,lihtml){
		var self = this,
			_config = self.config,
			_cache = self.cache;
		//<ul class="nav nav-second-level collapse in" aria-expanded="true">
		var subUl = $('<ul class="nav nav-second-level collapse in" aria-expanded="true"></ul>'),
			callee = arguments.callee,
			subLi;
		
		$(submenu).each(function(index,item){
			var url = item.url || 'javascript:void(0)';

			subLi = $('<li><a class="J_menuItem" href="'+url+'">'+item.name+'</a></li>');
			if(item.submenu && item.submenu.length > 0) {

				$(subLi).children('a').append('<span class="fa arrow"></span>');
                callee(item.submenu, subLi);
			}
			$(subUl).append(subLi);
		});
		$(lihtml).append(subUl);
	},
	/**
	 * 处理层级缩进
	 */
	_levelIndent: function(ulList){
		var self = this,
			_config = self.config,
			_cache = self.cache,
			callee = arguments.callee;
	   
		var initTextIndent = 2,
			lev = 1,
			$oUl = $(ulList);
		
		while($oUl.find('ul').length > 0){
			initTextIndent = parseInt(initTextIndent,10) + 2 + 'px'; 
			$oUl.children().children('ul').addClass('lev-' + lev)
						.children('li').css('text-indent', initTextIndent);
			$oUl = $oUl.children().children('ul');
			lev++;
		}
		$(ulList).find('ul').hide();
	},
	/**
	 * 绑定事件
	 */
	_bindEnv: function(container) {
		var self = this,
			_config = self.config;

		$('h2,a',container).unbind(_config.type);
		$('h2,a',container).bind(_config.type,function(e){
			if($(this).siblings('ul').length > 0) {
				$(this).siblings('ul').slideToggle('normal').end();
				//$(this).siblings('ul').slideToggle('normal').end().children('img').toggleClass('unfold');
			}
			$(this).parent('li').siblings().find('ul').hide().end();
			//$(this).parent('li').siblings().find('ul').hide().end().find('img.unfold').removeClass('unfold');
			_config.clickItemCallBack && $.isFunction(_config.clickItemCallBack) && _config.clickItemCallBack($(this));

		});
	}
 };
