// JavaScript Document
var Problemapp = angular.module("commonproblem", []);
Problemapp.controller("commonProblemBox",function($scope,$http){	
	$http.jsonp("http://117.78.46.33:8057/api/News/GameIssueInfoList?jsonpcb=JSON_CALLBACK")
	.success(function(data){	
		$scope.problemlist=data.message;	
	})
	.error(function(err){	
		alert("失败")
	})
})
