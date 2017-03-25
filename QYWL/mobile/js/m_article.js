// JavaScript Document
var querystringObj = getQueryString();
var id = querystringObj['id'];//NewsID
var app = angular.module("Article",[])
app.controller("ArticleDetails",function($scope,$http){	
	$http.jsonp("http://117.78.46.33:8057/api/News/NewDetailList?jsonpcb=JSON_CALLBACK")
	.success(function(data){
		for(i=0;i<data.message.length;i++){
			var newsid=data.message[i].NewsID;	
			if(id == newsid){	
				$scope.ArticleInfos=data.message[i];
			}
		}
	})
})
