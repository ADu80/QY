// JavaScript Document
var querystringObj = getQueryString();
var id = querystringObj['id'];//NewsID
var app = angular.module("problemdetails",[])
app.controller("problemdetailsBox",function($scope,$http){	
	$http.jsonp("http://117.78.46.33:8057/api/News/GameIssueInfoList?jsonpcb=JSON_CALLBACK")
	.success(function(data){
		for(i=0;i<data.message.length;i++){
			var Issueid=data.message[i].IssueID;	
			if(id == Issueid){	
				$scope.problemInfos=data.message[i];
			}
		}
	})
})
