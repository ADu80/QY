// JavaScript Document
$(function(){	
	;(function(){
			
		//ios下载&android下载
		$('.banner li.iosshow').click(function(e) {
            $('.banner .showpic').css({'background':'url(../images/ios.jpg)','display':'block','background-size':'contain'});
        });
		$('.banner li.iosshow').mouseleave(function(e) {
            $('.banner .showpic').css({'display':'none'});
        });
		$('.banner li.Adroidshow').click(function(){	
			$('.banner .showpic').css({'background':'url(../images/android.jpg)','display':'block','background-size':'contain'});
		});
		$('.banner li.Adroidshow').mouseleave(function(e) {
            $('.banner .showpic').css({'display':'none'});
        });
		
		//活动公告
		$('.News p span').hover(function(){	
			$(this).addClass('current').siblings().removeClass('current');
			$('.News .NewsContent ul').eq($(this).index()).addClass('showNews').siblings().removeClass('showNews');
		})
		
		//兑换奖品——无缝焦点图
		var timer=null;
		var num=0;
		var lenght=$('.AwardContent .AwardBox').width();
		function autoplay(){
			clearInterval(timer);	
			timer=setInterval(function(){	
				num+=2;
				if(num>lenght){	
					num=0;
				}
				$('.AwardContent ul').css({left:-num+"px"});
			},50)
		}
		autoplay();
		$('.AwardBox').hover(function(e){	
			clearInterval(timer)
		},function(){	
			clearInterval(timer);
			autoplay();
		})
		
		//新闻公告tab栏切换
		$('.NewsSidebar li').click(function(e) {
            $(this).addClass('current').siblings().removeClass('current');
			$('.NewsArticleName ul').eq($(this).index()).addClass('current').siblings().removeClass('current');
        });
		
		
		//下载专区的二维码切换
		$('.AboutAdroid .DownloadGameContent dl:lt(7)').hover(function(e) {
        	$(this).addClass('current').siblings().removeClass('current');
			$(this).children('dt').children('img').eq(0).css({display:"none"})
			$(this).children('dt').children('img').eq(1).css({display:"block"})
			$(this).children("dd").children("p").css({"background-position":"0 -390px"})
        },function(){
			$(this).children('dt').children('img').eq(1).css({display:"none"})
			$(this).children('dt').children('img').eq(0).css({display:"block"})
			$(this).children("dd").children("p").css({"background-position":"0 -419px"})
		});
		$('.AboutIOS .DownloadGameContent dl:lt(7)').hover(function(e) {
        	$(this).addClass('current').siblings().removeClass('current');
			$(this).children('dt').children('img').eq(0).css({display:"none"})
			$(this).children('dt').children('img').eq(1).css({display:"block"})
			$(this).children("dd").children("p").css({"background-position":"0 -390px"})
        },function(){
			$(this).children('dt').children('img').eq(1).css({display:"none"})
			$(this).children('dt').children('img').eq(0).css({display:"block"})
			$(this).children("dd").children("p").css({"background-position":"0 -419px"})
		});
		
		
		
		//点击下载弹出下载框
		$('.myGame .myGameContent p').click(function(e) {
            $('.GameDetails_Wrapper').css({display:'block'})
        });
		$('.GameDetails .GameDetailsTop span').click(function(e) {
            $('.GameDetails_Wrapper').css({display:'none'})
        });
	})();
	
//积分商城之侧导航栏	
/*	;(function(){
		var winH=$(window).height();
		var conT=$('.MallContent_in').height()+50;
		var second=$('.Mallsecond').offset();
		if(!second)
		return;
		var secondTop=second.top;
		var sum=0;
		$(window).scroll(function(e) {
			var winT=$(window).scrollTop();
			var dbp=secondTop-winH;
			if(winT>dbp){	
				$('.MallContent .Malllistleader').css({display:'block'})
			}else{	
				$('.MallContent .Malllistleader').css({display:'none'})
			}
		});
		//单击事件
		$('.MallContent .Malllistleader li').click(function(e) {
			sum=secondTop+conT*$(this).index();
			$(this).addClass('color').siblings().removeClass('color');
			$('html,body').animate({scrollTop:sum})
		});
	})();
*/	
//支付中心
	;(function(){
		var wechatpay;
		$('.PayLeft div').click(function(e) {
            $(this).addClass('Paycurrent').siblings().removeClass('Paycurrent');
        });
		$('.PayRight .PayBox').click(function(e) {
            $(this).addClass('current').siblings().removeClass('current')
        });
		$('.PayRight .Paysub').click(function(e) {
            if($('.Apay_pay.Paycurrent').is('.Apay_pay.Paycurrent')){	
				$('.Apay_Wrap').addClass('current');
			}else(	
				$('.WeChat_Wrap').addClass('current')
			)
        });
		$('.error').click(function(){	
			$(this).parent().parent().removeClass('current');
		})
	})();
})
$(function(){	
	$('.nav_list').click(function(){	
		$('.nav').toggleClass('nav_show');
		var winT=window.scrollTop;
		if(winT>0){	
			$('.nav').removeClass('nav_show');	
		}
	})
	
	$('.parents').click(function(e) {
        $('.login_wrap').addClass('current')
    });
})

$(function(){	
	$('.HelpCenterLeft .CommonProblems').click(function(){	
		$('.CommonProblems_article').addClass('current').siblings().removeClass('current');
	})
	$('.HelpCenterLeft .GameFeedback ').click(function(){	
		$('.GameFeedback_article').addClass('current').siblings().removeClass('current');
	})
	
	$('.HelpCenterBox .GameFeedback li').click(function(){	
		$(this).addClass('color').siblings().removeClass('color');
		$('.HelpCenterRight .GameFeedback_article div ').eq($(this).index()).addClass('current').siblings().removeClass('current')
	})
})










