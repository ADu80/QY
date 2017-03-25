// JavaScript Document
$(function(){	
	$('.icon_pic .icon-list').click(function(e) {
		var show=$('.navigation').css("display");
		if(show == "none"){	
			$('.navigation').stop().slideDown();
		}else{	
			$('.navigation').stop().slideUp();
		}
    });
	;(function(){	
		$('.PayStyle span').click(function(){	
			$(this).addClass('current').siblings().removeClass('current')
		})
	})();
})
