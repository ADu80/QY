USE QPRecordDB
GO

IF NOT EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('RecordGrantRCard') AND [type]='U')
	CREATE TABLE [RecordGrantRCard](
		[RecordID] [int] IDENTITY(1,1) NOT NULL,
		[MasterID] [int] NOT NULL,
		[ClientIP] [varchar](15) NOT NULL DEFAULT (N'000.000.000.000'),
		[CollectDate] [datetime] NOT NULL DEFAULT (getdate()),
		[UserID] [int] NOT NULL,
		[RCard] [bigint] NOT NULL DEFAULT ((0)),
		[Reason] [nvarchar](32) NOT NULL DEFAULT (N''),
	 CONSTRAINT [PK_RecordGrantRCard] PRIMARY KEY CLUSTERED 
	(
		[RecordID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

GO

IF NOT EXISTS(SELECT 1 FROM dbo.SysObjects WHERE id=OBJECT_ID('RecordRichChange') AND [type]='U')
	CREATE TABLE [dbo].[RecordRichChange](
		[ID] [bigint] IDENTITY(1,1) NOT NULL,
		[UserID] [int] NULL,
		[KindID] [int] NULL,
		[ServerID] [int] NULL,
		[BeforeScore] [bigint] NULL,
		[ChangeScore] [bigint] NULL,
		[AfterScore] [bigint] NULL,
		[BeforeDiamond] [bigint] NULL,
		[ChangeDiamond] [bigint] NULL,
		[AfterDiamond] [bigint] NULL,
		[BeforeRCard] [bigint] NULL,
		[ChangeRCard] [bigint] NULL,
		[AfterRCard] [bigint] NULL,
		[Revenue] [bigint] NULL CONSTRAINT [DF_RecordRichChange_Revenue]  DEFAULT ((0)),
		[Reason] [int] NULL,
		[LastTime] [datetime] NULL CONSTRAINT [DF_RecordRichChange_LastTime]  DEFAULT (getdate())
	) ON [PRIMARY]

GO


IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('RecordGrantTreasure')=id AND name ='SendUserID')
	ALTER TABLE RecordGrantTreasure
	ADD SendUserID INT
GO


IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('RecordGrantRCard')=id AND name ='SendUserID')
	ALTER TABLE RecordGrantRCard
	ADD SendUserID INT
GO

IF NOT EXISTS(SELECT 1 FROM dbo.SYSCOLUMNS WHERE OBJECT_ID('RecordGrantRCard')=id AND name ='CurRCard')
	ALTER TABLE RecordGrantRCard
	ADD CurRCard BIGINT
GO


