USE [QPPlatformManagerDB]
GO

TRUNCATE TABLE [dbo].[AgentSpreaderOptions]
TRUNCATE TABLE [dbo].[SystemLog]
TRUNCATE TABLE [dbo].[SystemSecurity]

TRUNCATE TABLE [dbo].[Base_Module]
INSERT [dbo].[Base_Module] ([ModuleID], [ParentID], [Title], [Link], [OrderNo], [Nullity], [IsMenu], [Description], [ManagerPopedom], [Img]) 
VALUES (1, 0, N'游戏用户', N'', 0, 0, 1, N'', 0, N'user.svg')
, (2, 0, N'冲值系统', N'', 5, 0, 1, N'', 0, N'money.svg')
, (3, 0, N'系统维护', N'', 10, 0, 1, N'', 0, N'settings.svg')
, (4, 0, N'网站系统', N'', 15, 0, 1, N'', 0, N'www.svg')
, (5, 0, N'后台系统', N'', 20, 0, 1, N'', 0, N'manager.svg')
, (6, 0, N'操作日志', N'', 25, 0, 1, N'', 0, N'log.svg')
, (7, 0, N'总代', N'', 30, 0, 1, N'', 0, NULL)
, (8, 0, N'游戏设置', N'', 0, 0, 1, N'', 0, NULL)
, (100, 1, N'用户管理', N'Module/AccountManager/AccountsList.aspx', 0, 0, 1, N'', 0, NULL)
, (101, 1, N'金币管理', N'Module/AccountManager/AccountsGoldList.aspx', 5, 0, 1, N'', 0, NULL)
, (102, 1, N'积分管理', N'Module/AccountManager/AccountsScoreList.aspx', 10, 0, 1, N'', 0, NULL)
, (103, 1, N'银行记录', N'Module/AccountManager/AccountsInsureList.aspx', 20, 0, 1, N'', 0, NULL)
, (104, 1, N'限制用户名', N'Module/AccountManager/ConfineContentList.aspx', 25, 0, 1, N'', 0, NULL)
, (105, 1, N'限制IP地址', N'Module/AccountManager/ConfineAddressList.aspx', 35, 0, 1, N'', 0, NULL)
, (106, 1, N'限制机器码', N'Module/AccountManager/ConfineMachineList.aspx', 40, 0, 1, N'', 0, NULL)
, (107, 1, N'机器人管理', N'Module/AccountManager/AndroidList.aspx', 40, 0, 1, N'', 0, NULL)
, (108, 1, N'魅力管理', N'Module/AccountManager/AccountsConvertPresentList.aspx', 15, 0, 1, N'', 0, NULL)
, (110, 1, N'奖牌管理', N'Module/AccountManager/RecordConvertMedalList.aspx', 16, 0, 1, N'', 0, NULL)
, (200, 2, N'实卡管理', N'Module/FilledManager/LivcardBuildStreamList.aspx', 0, 0, 1, N'', 0, NULL)
, (202, 2, N'订单管理', N'Module/FilledManager/OnLineOrderList.aspx', 10, 0, 1, N'', 0, NULL)
, (203, 2, N'充值记录', N'Module/FilledManager/ShareInfoList.aspx', 8, 0, 1, N'', 0, NULL)
, (205, 2, N'快钱管理', N'Module/FilledManager/OrderKQList.aspx', 25, 0, 1, N'', 0, NULL)
, (206, 2, N'易宝管理', N'Module/FilledManager/OrderYPList.aspx', 30, 0, 1, N'', 0, NULL)
, (208, 2, N'声讯记录', N'Module/FilledManager/OrderVBList.aspx', 31, 0, 1, N'', 0, NULL)
, (300, 3, N'机器管理', N'Module/AppManager/DataBaseInfoList.aspx', 0, 0, 1, N'', 0, NULL)
, (301, 3, N'游戏管理', N'Module/AppManager/GameGameItemList.aspx', 5, 0, 1, N'', 0, NULL)
, (302, 3, N'房间管理', N'Module/AppManager/GameRoomInfoList.aspx', 10, 0, 1, N'', 0, NULL)
, (303, 3, N'系统消息', N'Module/AppManager/SystemMessageList.aspx', 20, 0, 1, N'', 0, NULL)
, (304, 3, N'系统设置', N'Module/AppManager/SystemSet.aspx', 20, 0, 1, N'', 0, NULL)
, (305, 3, N'道具管理', N'Module/AppManager/GamePropertyManager.aspx', 35, 0, 1, N'', 0, NULL)
, (307, 3, N'在线统计', N'Module/AppManager/StatOnline.aspx', 45, 0, 1, N'', 0, NULL)
, (308, 3, N'泡点设置', N'Module/AppManager/GlobalPlayPresentList.aspx', 25, 0, 1, N'', 0, NULL)
, (309, 3, N'推广管理', N'Module/AppManager/SpreadSet.aspx', 30, 0, 1, N'', 0, NULL)
, (310, 3, N'邮件管理', N'Module/AppManager/SendEmailsList.aspx', 0, 0, 1, N'', 0, NULL)
, (311, 3, N'游戏排行', N'Module/AppManager/GameRankSet.aspx', 0, 0, 1, N'', 0, NULL)
, (400, 4, N'新闻管理', N'Module/WebManager/NewsList.aspx', 0, 0, 1, N'', 0, NULL)
, (402, 4, N'弹出页面', N'Module/WebManager/NoticeList.aspx', 30, 0, 1, N'', 0, NULL)
, (404, 4, N'规则管理', N'Module/WebManager/RulesList.aspx', 5, 0, 1, N'', 0, NULL)
, (405, 4, N'问题管理', N'Module/WebManager/IssueList.aspx', 10, 0, 1, N'', 0, NULL)
, (406, 4, N'比赛管理', N'Module/WebManager/MatchList.aspx', 15, 0, 1, N'', 0, NULL)
, (407, 4, N'回馈管理', N'Module/WebManager/FeedbackList.aspx', 20, 0, 1, N'', 0, NULL)
, (500, 5, N'管理员管理', N'Module/BackManager/BaseRoleList.aspx', 0, 0, 1, N'', 0, NULL)
, (501, 5, N'系统设置', N'Module/BackManager/SystemSet.aspx', 10, 0, 1, N'', 0, NULL)
, (502, 5, N'系统统计', N'Module/BackManager/SystemStat.aspx', 20, 0, 1, N'', 0, NULL)
, (600, 6, N'安全日志', N'Module/OperationLog/SystemSecurityList.aspx', 20, 0, 1, N'', 0, NULL)
, (700, 7, N'代理管理', N'Module/AgentManager/AgentPoundage.aspx', 0, 0, 1, N'', 0, NULL)
, (801, 8, N'百家乐', N'Module/GameManager/GameSet_BJL.aspx', 0, 0, 1, N'', 0, NULL)

GO

TRUNCATE TABLE [dbo].[Base_ModulePermission]
INSERT [dbo].[Base_ModulePermission] ([ModuleID], [PermissionTitle], [PermissionValue], [Nullity], [StateFlag], [ParentID]) 
VALUES (100, N'查看', 1, 0, 0, 1)
, (100, N'添加', 2, 0, 0, 1)
, (100, N'编辑', 4, 0, 0, 1)
, (100, N'赠送会员', 16, 0, 0, 1)
, (100, N'赠送金币', 32, 0, 0, 1)
, (100, N'赠送房卡', 40, 0, 0, 1)
, (100, N'赠送经验', 64, 0, 0, 1)
, (100, N'赠送积分', 128, 0, 0, 1)
, (100, N'赠送靓号', 256, 0, 0, 1)
, (100, N'清零积分', 512, 0, 0, 1)
, (100, N'清零逃率', 1024, 0, 0, 1)
, (100, N'冻/解帐号', 8192, 0, 0, 1)
, (100, N'设置/取消机器人', 16384, 0, 0, 1)
, (101, N'查看', 1, 0, 0, 1)
, (102, N'查看', 1, 0, 0, 1)
, (103, N'查看', 1, 0, 0, 1)
, (104, N'查看', 1, 0, 0, 1)
, (104, N'添加', 2, 0, 0, 1)
, (104, N'编辑', 4, 0, 0, 1)
, (104, N'删除', 8, 0, 0, 1)
, (105, N'查看', 1, 0, 0, 1)
, (105, N'添加', 2, 0, 0, 1)
, (105, N'编辑', 4, 0, 0, 1)
, (105, N'删除', 8, 0, 0, 1)
, (106, N'查看', 1, 0, 0, 1)
, (106, N'添加', 2, 0, 0, 1)
, (106, N'编辑', 4, 0, 0, 1)
, (106, N'删除', 8, 0, 0, 1)
, (107, N'查看', 1, 0, 0, 1)
, (107, N'添加', 2, 0, 0, 1)
, (107, N'编辑', 4, 0, 0, 1)
, (107, N'删除', 8, 0, 0, 1)
, (108, N'查看', 1, 0, 0, 1)
, (109, N'查看', 1, 0, 0, 1)
, (109, N'卡线清理', 8, 0, 0, 1)
, (200, N'查看', 1, 0, 0, 2)
, (200, N'添加', 2, 0, 0, 2)
, (200, N'编辑', 4, 0, 0, 2)
, (200, N'生成实卡', 2048, 0, 0, 2)
, (200, N'导出实卡', 4096, 0, 0, 2)
, (202, N'查看', 1, 0, 0, 2)
, (202, N'删除', 8, 0, 0, 2)
, (203, N'查看', 1, 0, 0, 2)
, (205, N'查看', 1, 0, 0, 2)
, (205, N'删除', 8, 0, 0, 2)
, (206, N'查看', 1, 0, 0, 2)
, (206, N'删除', 8, 0, 0, 2)
, (208, N'查看', 1, 0, 0, 2)
, (300, N'查看', 1, 0, 0, 3)
, (300, N'添加', 2, 0, 0, 3)
, (300, N'编辑', 4, 0, 0, 3)
, (300, N'删除', 8, 0, 0, 3)
, (301, N'查看', 1, 0, 0, 3)
, (301, N'添加', 2, 0, 0, 3)
, (301, N'编辑', 4, 0, 0, 3)
, (301, N'删除', 8, 0, 0, 3)
, (302, N'查看', 1, 0, 0, 3)
, (302, N'添加', 2, 0, 0, 3)
, (302, N'编辑', 4, 0, 0, 3)
, (302, N'删除', 8, 0, 0, 3)
, (304, N'查看', 1, 0, 0, 3)
, (304, N'编辑', 4, 0, 0, 3)
, (305, N'查看', 1, 0, 0, 3)
, (305, N'编辑', 4, 0, 0, 3)
, (305, N'删除', 8, 0, 0, 3)
, (306, N'查看', 1, 0, 0, 3)
, (307, N'查看', 1, 0, 0, 3)
, (308, N'查看', 1, 0, 0, 3)
, (308, N'添加', 2, 0, 0, 3)
, (308, N'编辑', 4, 0, 0, 3)
, (308, N'删除', 8, 0, 0, 3)
, (309, N'查看', 1, 0, 0, 3)
, (309, N'编辑', 4, 0, 0, 3)
, (400, N'查看', 1, 0, 0, 4)
, (400, N'添加', 2, 0, 0, 4)
, (400, N'编辑', 4, 0, 0, 4)
, (400, N'删除', 8, 0, 0, 4)
, (402, N'查看', 1, 0, 0, 4)
, (402, N'添加', 2, 0, 0, 4)
, (402, N'编辑', 4, 0, 0, 4)
, (402, N'删除', 8, 0, 0, 4)
, (404, N'查看', 1, 0, 0, 4)
, (404, N'添加', 2, 0, 0, 4)
, (404, N'编辑', 4, 0, 0, 4)
, (404, N'删除', 8, 0, 0, 4)
, (405, N'查看', 1, 0, 0, 4)
, (405, N'添加', 2, 0, 0, 4)
, (405, N'编辑', 4, 0, 0, 4)
, (405, N'删除', 8, 0, 0, 4)
, (406, N'查看', 1, 0, 0, 4)
, (406, N'添加', 2, 0, 0, 4)
, (406, N'编辑', 4, 0, 0, 4)
, (406, N'删除', 8, 0, 0, 4)
, (407, N'查看', 1, 0, 0, 4)
, (407, N'编辑', 4, 0, 0, 4)
, (407, N'删除', 8, 0, 0, 4)
, (500, N'查看', 1, 0, 0, 5)
, (500, N'添加', 2, 0, 0, 5)
, (500, N'编辑', 4, 0, 0, 5)
, (500, N'删除', 8, 0, 0, 5)
, (501, N'查看', 1, 0, 0, 5)
, (501, N'编辑', 4, 0, 0, 5)
, (502, N'查看', 1, 0, 0, 5)
, (600, N'查看', 1, 0, 0, 6)
, (700, N'查看', 1, 0, 0, 7)
, (800, N'查看', 1, 0, 0, 7)

GO

TRUNCATE TABLE [dbo].[SystemLogOperation]
INSERT [dbo].[SystemLogOperation] ( [Code], [Operation]) 
VALUES (N'AddAgent', N'新增代理')
,(N'EditAgent', N'修改代理')
,(N'AddGamer', N'新增玩家')
,(N'AddAdmin', N'新增管理员账号')
,(N'EditAdmin', N'修改管理员账号')
,(N'DeleteAdmin', N'删除管理员账号')
,(N'ChangeAdminRole', N'更改管理员角色')
,(N'ChangeAdminPassword', N'重置管理员密码')
,(N'NullityAdmin', N'冻结管理员账号')
,( N'NoNullityAdmin', N'解冻管理员账号')
,( N'AddRole', N'新增角色')
,( N'EditRole', N'修改角色')
,( N'DeleteRole', N'删除角色')
,( N'Logout', N'退出')
,( N'Login', N'登录')
,( N'SpreadOption', N'分享返利设置')
,( N'EditSensitiveWord', N'编辑敏感词')

GO

TRUNCATE TABLE Base_AgentGrades
INSERT Base_AgentGrades(GradeDes,AgentLevel,Created,Modified)
VALUES('平台',0,GETDATE(),GETDATE()),
('金牌1',1,GETDATE(),GETDATE()),
('金牌2',1,GETDATE(),GETDATE()),
('金牌3',1,GETDATE(),GETDATE()),
('金牌4',1,GETDATE(),GETDATE()),
('金牌5',1,GETDATE(),GETDATE()),
('银牌1',2,GETDATE(),GETDATE()),
('银牌2',2,GETDATE(),GETDATE()),
('银牌3',2,GETDATE(),GETDATE()),
('银牌4',2,GETDATE(),GETDATE()),
('银牌5',2,GETDATE(),GETDATE())

GO

TRUNCATE TABLE [dbo].Base_Roles
INSERT INTO dbo.Base_Roles([RoleName],[Description],[AgentLevel],[Operator],[Created],[Modified])
VALUES('超级管理员','系统管理',0,NULL,GETDATE(),GETDATE()),
('金牌','代理',1,'admin',GETDATE(),GETDATE()),
('银牌','代理',2,'admin',GETDATE(),GETDATE())

GO

TRUNCATE TABLE [dbo].Base_Users
INSERT INTO dbo.Base_Users(UserName,[Password],RoleID,Nullity,PreLogintime,PreLoginIP,LastLogintime,LastLoginIP,LoginTimes,IsBand,BandIP,AgentID,VipID,Percentage,canHasSubAgent,AgentLevelLimit)
VALUES('admin','E10ADC3949BA59ABBE56E057F20F883E',1,0,'1970-01-01','0.0.0.0','1970-01-01','0.0.0.0',0,1,'0.0.0.0',NULL,NULL,NULL,NULL,NULL)

go


--IF NOT EXISTS(SELECT 1 FROM dbo.Base_Users)
--	TRUNCATE TABLE [dbo].Base_Users
--GO
--IF NOT EXISTS(SELECT 1 FROM dbo.Base_Users WHERE UserName='admin')
--BEGIN
--	INSERT INTO dbo.Base_Users(UserName,[Password],RoleID,Nullity,PreLogintime,PreLoginIP,LastLogintime,LastLoginIP,LoginTimes,IsBand,BandIP,AgentID,VipID,Percentage,canHasSubAgent,AgentLevelLimit)
--	VALUES('admin','E10ADC3949BA59ABBE56E057F20F883E',1,0,'1970-01-01','0.0.0.0','1970-01-01','0.0.0.0',0,1,'0.0.0.0',NULL,NULL,NULL,NULL,NULL)
--END

--GO








