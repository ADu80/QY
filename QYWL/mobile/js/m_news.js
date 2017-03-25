// JavaScript Document
var Newsapp = angular.module("NewsTitle", []);
Newsapp.controller("NewsBox",function($scope,$http){	
	$http.jsonp("http://117.78.46.33:8057/api/News/HotNewList?jsonpcb=JSON_CALLBACK")
	.success(function(data){
		var Newscount=new Array();
		var Noticescount=new Array();
		for(var i=0; i<data.message.length;i++){	
			var classid = data.message[i].ClassID;
			if(classid==1){	
				//$scope.News=data.message[i];
				Newscount.push(data.message[i]); 
			}
			if(classid==2){	
				Noticescount.push(data.message[i]);
			}
		}
		$scope.News = Newscount;
		$scope.Notices = Noticescount;
	})
})
