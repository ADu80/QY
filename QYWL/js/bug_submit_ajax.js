// JavaScript Document
$(document).ready(function (e) {
    $('#bugForm').submit(function (e) {
        dd.Post('/News/AddFeedback', $(e.target).serialize(),
			function (data) {
			    if (data.status) {
			        alert('提交成功！！');
			    }
			},
			function (err) {
			    alert('请求失败：' + err)
			}
		);
    });
});
