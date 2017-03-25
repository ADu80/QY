// JavaScript Document
$(document).ready(function(e) {
	$('#form1').submit(function(e){		
	    dd.Post('/News/AddFeedbackadvise', $(e.target).serialize(),
			function (data) {
			    var msg = data.message;
			    if (msg == "保存成功") {
			        alert('提交成功！！');
			    }
			},
			function (err) {
			    alert('请求失败！');
			}
		);
	})
});

