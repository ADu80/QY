USE QPPlatformDB
GO

IF NOT EXISTS(SELECT * FROM dbo.SysObjects WHERE OBJECT_ID('InviteCode')=id AND xtype='U')
BEGIN
	CREATE TABLE [dbo].[InviteCode](
		[CodeID] [nvarchar](10) NOT NULL,
		[IsLiang] [bit] NOT NULL CONSTRAINT [DF_InviteCodeCfg_Agent_IsLiang]  DEFAULT ((0)),
		[IsUse] [bit] NOT NULL CONSTRAINT [DF_InviteCodeCfg_Agent_IsUse]  DEFAULT ((0)),
		[LastTime] [datetime] NULL CONSTRAINT [DF_InviteCodeCfg_Agent_LastTime]  DEFAULT (getdate())
	) ON [PRIMARY]
END
GO

