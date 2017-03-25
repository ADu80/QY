USE [QPPlatformManagerDB]
GO

TRUNCATE TABLE [dbo].[AgentSpreaderOptions]
TRUNCATE TABLE [dbo].[SystemLog]
TRUNCATE TABLE [dbo].[SystemSecurity]

TRUNCATE TABLE [dbo].[Base_Module]
INSERT [dbo].[Base_Module] ([ModuleID], [ParentID], [Title], [Link], [OrderNo], [Nullity], [IsMenu], [Description], [ManagerPopedom], [Img]) 
VALUES (1, 0, N'��Ϸ�û�', N'', 0, 0, 1, N'', 0, N'user.svg')
, (2, 0, N'��ֵϵͳ', N'', 5, 0, 1, N'', 0, N'money.svg')
, (3, 0, N'ϵͳά��', N'', 10, 0, 1, N'', 0, N'settings.svg')
, (4, 0, N'��վϵͳ', N'', 15, 0, 1, N'', 0, N'www.svg')
, (5, 0, N'��̨ϵͳ', N'', 20, 0, 1, N'', 0, N'manager.svg')
, (6, 0, N'������־', N'', 25, 0, 1, N'', 0, N'log.svg')
, (7, 0, N'�ܴ�', N'', 30, 0, 1, N'', 0, NULL)
, (8, 0, N'��Ϸ����', N'', 0, 0, 1, N'', 0, NULL)
, (100, 1, N'�û�����', N'Module/AccountManager/AccountsList.aspx', 0, 0, 1, N'', 0, NULL)
, (101, 1, N'��ҹ���', N'Module/AccountManager/AccountsGoldList.aspx', 5, 0, 1, N'', 0, NULL)
, (102, 1, N'���ֹ���', N'Module/AccountManager/AccountsScoreList.aspx', 10, 0, 1, N'', 0, NULL)
, (103, 1, N'���м�¼', N'Module/AccountManager/AccountsInsureList.aspx', 20, 0, 1, N'', 0, NULL)
, (104, 1, N'�����û���', N'Module/AccountManager/ConfineContentList.aspx', 25, 0, 1, N'', 0, NULL)
, (105, 1, N'����IP��ַ', N'Module/AccountManager/ConfineAddressList.aspx', 35, 0, 1, N'', 0, NULL)
, (106, 1, N'���ƻ�����', N'Module/AccountManager/ConfineMachineList.aspx', 40, 0, 1, N'', 0, NULL)
, (107, 1, N'�����˹���', N'Module/AccountManager/AndroidList.aspx', 40, 0, 1, N'', 0, NULL)
, (108, 1, N'��������', N'Module/AccountManager/AccountsConvertPresentList.aspx', 15, 0, 1, N'', 0, NULL)
, (110, 1, N'���ƹ���', N'Module/AccountManager/RecordConvertMedalList.aspx', 16, 0, 1, N'', 0, NULL)
, (200, 2, N'ʵ������', N'Module/FilledManager/LivcardBuildStreamList.aspx', 0, 0, 1, N'', 0, NULL)
, (202, 2, N'��������', N'Module/FilledManager/OnLineOrderList.aspx', 10, 0, 1, N'', 0, NULL)
, (203, 2, N'��ֵ��¼', N'Module/FilledManager/ShareInfoList.aspx', 8, 0, 1, N'', 0, NULL)
, (205, 2, N'��Ǯ����', N'Module/FilledManager/OrderKQList.aspx', 25, 0, 1, N'', 0, NULL)
, (206, 2, N'�ױ�����', N'Module/FilledManager/OrderYPList.aspx', 30, 0, 1, N'', 0, NULL)
, (208, 2, N'��Ѷ��¼', N'Module/FilledManager/OrderVBList.aspx', 31, 0, 1, N'', 0, NULL)
, (300, 3, N'��������', N'Module/AppManager/DataBaseInfoList.aspx', 0, 0, 1, N'', 0, NULL)
, (301, 3, N'��Ϸ����', N'Module/AppManager/GameGameItemList.aspx', 5, 0, 1, N'', 0, NULL)
, (302, 3, N'�������', N'Module/AppManager/GameRoomInfoList.aspx', 10, 0, 1, N'', 0, NULL)
, (303, 3, N'ϵͳ��Ϣ', N'Module/AppManager/SystemMessageList.aspx', 20, 0, 1, N'', 0, NULL)
, (304, 3, N'ϵͳ����', N'Module/AppManager/SystemSet.aspx', 20, 0, 1, N'', 0, NULL)
, (305, 3, N'���߹���', N'Module/AppManager/GamePropertyManager.aspx', 35, 0, 1, N'', 0, NULL)
, (307, 3, N'����ͳ��', N'Module/AppManager/StatOnline.aspx', 45, 0, 1, N'', 0, NULL)
, (308, 3, N'�ݵ�����', N'Module/AppManager/GlobalPlayPresentList.aspx', 25, 0, 1, N'', 0, NULL)
, (309, 3, N'�ƹ����', N'Module/AppManager/SpreadSet.aspx', 30, 0, 1, N'', 0, NULL)
, (310, 3, N'�ʼ�����', N'Module/AppManager/SendEmailsList.aspx', 0, 0, 1, N'', 0, NULL)
, (311, 3, N'��Ϸ����', N'Module/AppManager/GameRankSet.aspx', 0, 0, 1, N'', 0, NULL)
, (400, 4, N'���Ź���', N'Module/WebManager/NewsList.aspx', 0, 0, 1, N'', 0, NULL)
, (402, 4, N'����ҳ��', N'Module/WebManager/NoticeList.aspx', 30, 0, 1, N'', 0, NULL)
, (404, 4, N'�������', N'Module/WebManager/RulesList.aspx', 5, 0, 1, N'', 0, NULL)
, (405, 4, N'�������', N'Module/WebManager/IssueList.aspx', 10, 0, 1, N'', 0, NULL)
, (406, 4, N'��������', N'Module/WebManager/MatchList.aspx', 15, 0, 1, N'', 0, NULL)
, (407, 4, N'��������', N'Module/WebManager/FeedbackList.aspx', 20, 0, 1, N'', 0, NULL)
, (500, 5, N'����Ա����', N'Module/BackManager/BaseRoleList.aspx', 0, 0, 1, N'', 0, NULL)
, (501, 5, N'ϵͳ����', N'Module/BackManager/SystemSet.aspx', 10, 0, 1, N'', 0, NULL)
, (502, 5, N'ϵͳͳ��', N'Module/BackManager/SystemStat.aspx', 20, 0, 1, N'', 0, NULL)
, (600, 6, N'��ȫ��־', N'Module/OperationLog/SystemSecurityList.aspx', 20, 0, 1, N'', 0, NULL)
, (700, 7, N'�������', N'Module/AgentManager/AgentPoundage.aspx', 0, 0, 1, N'', 0, NULL)
, (801, 8, N'�ټ���', N'Module/GameManager/GameSet_BJL.aspx', 0, 0, 1, N'', 0, NULL)

GO

TRUNCATE TABLE [dbo].[Base_ModulePermission]
INSERT [dbo].[Base_ModulePermission] ([ModuleID], [PermissionTitle], [PermissionValue], [Nullity], [StateFlag], [ParentID]) 
VALUES (100, N'�鿴', 1, 0, 0, 1)
, (100, N'���', 2, 0, 0, 1)
, (100, N'�༭', 4, 0, 0, 1)
, (100, N'���ͻ�Ա', 16, 0, 0, 1)
, (100, N'���ͽ��', 32, 0, 0, 1)
, (100, N'���ͷ���', 40, 0, 0, 1)
, (100, N'���;���', 64, 0, 0, 1)
, (100, N'���ͻ���', 128, 0, 0, 1)
, (100, N'��������', 256, 0, 0, 1)
, (100, N'�������', 512, 0, 0, 1)
, (100, N'��������', 1024, 0, 0, 1)
, (100, N'��/���ʺ�', 8192, 0, 0, 1)
, (100, N'����/ȡ��������', 16384, 0, 0, 1)
, (101, N'�鿴', 1, 0, 0, 1)
, (102, N'�鿴', 1, 0, 0, 1)
, (103, N'�鿴', 1, 0, 0, 1)
, (104, N'�鿴', 1, 0, 0, 1)
, (104, N'���', 2, 0, 0, 1)
, (104, N'�༭', 4, 0, 0, 1)
, (104, N'ɾ��', 8, 0, 0, 1)
, (105, N'�鿴', 1, 0, 0, 1)
, (105, N'���', 2, 0, 0, 1)
, (105, N'�༭', 4, 0, 0, 1)
, (105, N'ɾ��', 8, 0, 0, 1)
, (106, N'�鿴', 1, 0, 0, 1)
, (106, N'���', 2, 0, 0, 1)
, (106, N'�༭', 4, 0, 0, 1)
, (106, N'ɾ��', 8, 0, 0, 1)
, (107, N'�鿴', 1, 0, 0, 1)
, (107, N'���', 2, 0, 0, 1)
, (107, N'�༭', 4, 0, 0, 1)
, (107, N'ɾ��', 8, 0, 0, 1)
, (108, N'�鿴', 1, 0, 0, 1)
, (109, N'�鿴', 1, 0, 0, 1)
, (109, N'��������', 8, 0, 0, 1)
, (200, N'�鿴', 1, 0, 0, 2)
, (200, N'���', 2, 0, 0, 2)
, (200, N'�༭', 4, 0, 0, 2)
, (200, N'����ʵ��', 2048, 0, 0, 2)
, (200, N'����ʵ��', 4096, 0, 0, 2)
, (202, N'�鿴', 1, 0, 0, 2)
, (202, N'ɾ��', 8, 0, 0, 2)
, (203, N'�鿴', 1, 0, 0, 2)
, (205, N'�鿴', 1, 0, 0, 2)
, (205, N'ɾ��', 8, 0, 0, 2)
, (206, N'�鿴', 1, 0, 0, 2)
, (206, N'ɾ��', 8, 0, 0, 2)
, (208, N'�鿴', 1, 0, 0, 2)
, (300, N'�鿴', 1, 0, 0, 3)
, (300, N'���', 2, 0, 0, 3)
, (300, N'�༭', 4, 0, 0, 3)
, (300, N'ɾ��', 8, 0, 0, 3)
, (301, N'�鿴', 1, 0, 0, 3)
, (301, N'���', 2, 0, 0, 3)
, (301, N'�༭', 4, 0, 0, 3)
, (301, N'ɾ��', 8, 0, 0, 3)
, (302, N'�鿴', 1, 0, 0, 3)
, (302, N'���', 2, 0, 0, 3)
, (302, N'�༭', 4, 0, 0, 3)
, (302, N'ɾ��', 8, 0, 0, 3)
, (304, N'�鿴', 1, 0, 0, 3)
, (304, N'�༭', 4, 0, 0, 3)
, (305, N'�鿴', 1, 0, 0, 3)
, (305, N'�༭', 4, 0, 0, 3)
, (305, N'ɾ��', 8, 0, 0, 3)
, (306, N'�鿴', 1, 0, 0, 3)
, (307, N'�鿴', 1, 0, 0, 3)
, (308, N'�鿴', 1, 0, 0, 3)
, (308, N'���', 2, 0, 0, 3)
, (308, N'�༭', 4, 0, 0, 3)
, (308, N'ɾ��', 8, 0, 0, 3)
, (309, N'�鿴', 1, 0, 0, 3)
, (309, N'�༭', 4, 0, 0, 3)
, (400, N'�鿴', 1, 0, 0, 4)
, (400, N'���', 2, 0, 0, 4)
, (400, N'�༭', 4, 0, 0, 4)
, (400, N'ɾ��', 8, 0, 0, 4)
, (402, N'�鿴', 1, 0, 0, 4)
, (402, N'���', 2, 0, 0, 4)
, (402, N'�༭', 4, 0, 0, 4)
, (402, N'ɾ��', 8, 0, 0, 4)
, (404, N'�鿴', 1, 0, 0, 4)
, (404, N'���', 2, 0, 0, 4)
, (404, N'�༭', 4, 0, 0, 4)
, (404, N'ɾ��', 8, 0, 0, 4)
, (405, N'�鿴', 1, 0, 0, 4)
, (405, N'���', 2, 0, 0, 4)
, (405, N'�༭', 4, 0, 0, 4)
, (405, N'ɾ��', 8, 0, 0, 4)
, (406, N'�鿴', 1, 0, 0, 4)
, (406, N'���', 2, 0, 0, 4)
, (406, N'�༭', 4, 0, 0, 4)
, (406, N'ɾ��', 8, 0, 0, 4)
, (407, N'�鿴', 1, 0, 0, 4)
, (407, N'�༭', 4, 0, 0, 4)
, (407, N'ɾ��', 8, 0, 0, 4)
, (500, N'�鿴', 1, 0, 0, 5)
, (500, N'���', 2, 0, 0, 5)
, (500, N'�༭', 4, 0, 0, 5)
, (500, N'ɾ��', 8, 0, 0, 5)
, (501, N'�鿴', 1, 0, 0, 5)
, (501, N'�༭', 4, 0, 0, 5)
, (502, N'�鿴', 1, 0, 0, 5)
, (600, N'�鿴', 1, 0, 0, 6)
, (700, N'�鿴', 1, 0, 0, 7)
, (800, N'�鿴', 1, 0, 0, 7)

GO

TRUNCATE TABLE [dbo].[SystemLogOperation]
INSERT [dbo].[SystemLogOperation] ( [Code], [Operation]) 
VALUES (N'AddAgent', N'��������')
,(N'EditAgent', N'�޸Ĵ���')
,(N'AddGamer', N'�������')
,(N'AddAdmin', N'��������Ա�˺�')
,(N'EditAdmin', N'�޸Ĺ���Ա�˺�')
,(N'DeleteAdmin', N'ɾ������Ա�˺�')
,(N'ChangeAdminRole', N'���Ĺ���Ա��ɫ')
,(N'ChangeAdminPassword', N'���ù���Ա����')
,(N'NullityAdmin', N'�������Ա�˺�')
,( N'NoNullityAdmin', N'�ⶳ����Ա�˺�')
,( N'AddRole', N'������ɫ')
,( N'EditRole', N'�޸Ľ�ɫ')
,( N'DeleteRole', N'ɾ����ɫ')
,( N'Logout', N'�˳�')
,( N'Login', N'��¼')
,( N'SpreadOption', N'����������')
,( N'EditSensitiveWord', N'�༭���д�')

GO

TRUNCATE TABLE Base_AgentGrades
INSERT Base_AgentGrades(GradeDes,AgentLevel,Created,Modified)
VALUES('ƽ̨',0,GETDATE(),GETDATE()),
('����1',1,GETDATE(),GETDATE()),
('����2',1,GETDATE(),GETDATE()),
('����3',1,GETDATE(),GETDATE()),
('����4',1,GETDATE(),GETDATE()),
('����5',1,GETDATE(),GETDATE()),
('����1',2,GETDATE(),GETDATE()),
('����2',2,GETDATE(),GETDATE()),
('����3',2,GETDATE(),GETDATE()),
('����4',2,GETDATE(),GETDATE()),
('����5',2,GETDATE(),GETDATE())

GO

TRUNCATE TABLE [dbo].Base_Roles
INSERT INTO dbo.Base_Roles([RoleName],[Description],[AgentLevel],[Operator],[Created],[Modified])
VALUES('��������Ա','ϵͳ����',0,NULL,GETDATE(),GETDATE()),
('����','����',1,'admin',GETDATE(),GETDATE()),
('����','����',2,'admin',GETDATE(),GETDATE())

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








