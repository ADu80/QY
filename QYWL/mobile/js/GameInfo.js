// JavaScript Document
var star='<span class="iconfont icon-star"></span>';
var pointer=0;
var app = angular.module("WebSite", []);
app.controller("HotGame", function($scope,$http) {
	$http.jsonp('http://117.78.46.33:8057/api/GameGameItem/GetDownload?jsonpcb=JSON_CALLBACK')
	.success(function(data){
		$scope.names=data.message;
		$scope.GameInfos=data.message;
		$scope.parseInt = parseInt;
		console.log(data.message);
		var rankID = new Array();
		for(var i=0 ; i < data.message.length ; i++){	
			$scope.GameInfos[i].RankID=parseInt(data.message[i].RankID);
		}
	})
	.error(function(err){
		console.log(err)
	})
});

app.controller("news",function($scope,$http,$location){	
	$http.jsonp('http://117.78.46.33:8057/api/News/HotNewList?jsonpcb=JSON_CALLBACK')
	.success(function(data){	
	    $scope.NewsInfo = data.message;
	})	
	.error(function(err){	
		alert('请求失败！')
	});
})
