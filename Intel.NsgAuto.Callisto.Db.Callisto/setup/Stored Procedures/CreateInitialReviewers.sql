
-- =================================================================================
-- Author       : bricschx
-- Create date  : 2020-12-02 09:24:50.547
-- Description  : Creates the initial reviewers
-- Example      : EXEC [setup].[CreateInitialReviewers] 'system';
--                SELECT * FROM [qan].[Reviewers];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateInitialReviewers]
(
	  @By VARCHAR(25) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	----DECLARE @Count INT = 0;
	----DECLARE @Ids TABLE ([Id] INT NOT NULL);
	----DECLARE @Message VARCHAR(MAX);
	----DECLARE @TableName VARCHAR(100) = '[qan].[Reviewers]';
	----IF (@By IS NULL) SET @By = [qan].[CreatedBySystem]();

	----MERGE [qan].[Reviewers] AS M
	----USING
	----(VALUES
	----	  ('Jake Douglas', 'jakemurx', '10995566', 'jakex.murphy.douglas@domain.com')
	----	, ('Fuhan Tian', 'ftianx', '12034907', 'fuhanx.tian@domain.com')
	----	, ('Jose Kurian', 'jkurian', '11330800', 'jose.kurian@domain.com')
	----	, ('Sudeep N Mohile', 'snmohile', '10648077', 'sudeep.n.mohile@domain.com')
	----	, ('Dennis Doherty', 'dodohert', '10700489', 'dennis.o.doherty@domain.com')
	----	, ('Ryan Gregory', 'ryangreg', '11794503', 'ryan.gregory@domain.com')
	----	, ('Maridol Guillen', 'mariagui', '11754399', 'maridol.guillen@domain.com')
	----	, ('Leslie Xu', 'llxu', '10582333', 'leslie.l.xu@domain.com')
	----	, ('Nazih Khoury', 'nkkhoury', '10676044', 'nazih.k.khoury@domain.com')
	----	, ('Lydia Dennis', 'ldennis', '11366161', 'lydia.dennis@domain.com')
	----	, ('Arash Eftekhari', 'arasheft', '11940247', 'arash.eftekhari@domain.com')
	----	, ('Pooja Tiwari', 'poojatiw', '11966265', 'pooja.tiwari@domain.com')
	----	, ('Richard Cote', 'coter', '11820761', 'richard1.cote@domain.com')
	----	, ('Kevin Liou', 'kkliou', '11299727', 'kevin.k.liou@domain.com')
	----	, ('Kok Teo', 'kokhinte', '11871382', 'kok.hin.teo@domain.com')
	----	, ('Jerry Wang', 'yunpengw', '11449302', 'jerry.m.wang@domain.com')
	----	, ('Joseph Baker', 'josephba', '11836479', 'joseph.baker@domain.com')
	----	, ('Ramakrishna Gopal', 'ramanat2', '11843845', 'ramakrishna.ramanathan.gopal@domain.com')
	----	, ('John Ahmu', 'jahmu', '11804465', 'john.ahmu@domain.com')
	----	, ('Trent Clinton', 'tdclinto', '10637855', 'trent.d.clinton@domain.com')
	----	, ('Andrew Whippie', 'andrewdw', '10655953', 'andrew.d.whipple@domain.com')
	----	, ('Brian Romo', 'bcromo', '10644431', 'brian.c.romo@domain.com')
	----	, ('Gerrit Lensink', 'gerritle', '11831009', 'gerrit.lensink@domain.com')
	----	, ('Gustavo Leiton', 'gaguilar', '10670978', 'gustavo.aguilar.leiton@domain.com')
	----	, ('Katherine Reyes', 'reyeska', '11814118', 'katherine.reyes@domain.com')
	----	, ('Adithya Shankar ', 'adithyas', '11759602', 'adithya.shankar@domain.com')
	----	, ('Linda Cheng', 'chengl1', '12058276', 'linda.cheng@domain.com')
	----	, ('SL Chiu', 'slchiu', '11749650', 'sl.chiu@domain.com')
		
	----) AS N ([Name], [Idsid], [Wwid], [Email])
	----ON (M.[Idsid] = N.[Idsid])
	----WHEN NOT MATCHED THEN INSERT ([Name], [Idsid], [Wwid], [Email], [CreatedBy], [UpdatedBy]) VALUES (N.[Name], N.[Idsid], N.[Wwid], N.[Email], @By, @By)
	----OUTPUT inserted.[Id] INTO @Ids;

	----SELECT @Count = COUNT(*) FROM @Ids;
	----SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	----PRINT @Message;

	    TRUNCATE TABLE [qan].[Reviewers];
		PRINT 'Table removed successfully';

		-- Insert fresh new standard data
		SET IDENTITY_INSERT [qan].[Reviewers] ON 
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (1, N'Jake Douglas', N'jakemurx', N'10995566', N'jakex.murphy.douglas@domain.com', 0, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (2, N'Bric Schultz', N'bricschx', N'11975655', N'bricx.schultz@domain.com', 0, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (3, N'Jose Kurian', N'jkurian', N'11330800', N'jose.kurian@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (4, N'Sudeep N Mohile', N'snmohile', N'10648077', N'sudeep.n.mohile@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (5, N'Dennis Doherty', N'dodohert', N'10700489', N'dennis.o.doherty@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (6, N'Ryan Gregory', N'ryangreg', N'11794503', N'ryan.gregory@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (7, N'Maridol Guillen', N'mariagui', N'11754399', N'maridol.guillen@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (8, N'Juanita Sze', N'jsze', N'10709020', N'juanita.sze@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (9, N'Nazih Khoury', N'nkkhoury', N'10676044', N'nazih.k.khoury@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (10, N'Lydia Dennis', N'ldennis', N'11366161', N'lydia.dennis@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (11, N'Arash Eftekhari', N'arasheft', N'11940247', N'arash.eftekhari@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (12, N'Pooja Tiwari', N'poojatiw', N'11966265', N'pooja.tiwari@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (13, N'Richard Cote', N'coter', N'11820761', N'richard1.cote@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (14, N'Kevin Liou', N'kkliou', N'11299727', N'kevin.k.liou@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (15, N'Kok Teo', N'kokhinte', N'11871382', N'kok.hin.teo@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (16, N'Jerry Wang', N'yunpengw', N'11449302', N'jerry.m.wang@domain.com', 0, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (17, N'Joseph Baker', N'josephba', N'11836479', N'joseph.baker@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (18, N'Ramakrishna Gopal', N'ramanat2', N'11843845', N'ramakrishna.ramanathan.gopal@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (19, N'John Ahmu', N'jahmu', N'11804465', N'john.ahmu@domain.com', 0, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (20, N'Trent Clinton', N'tdclinto', N'10637855', N'trent.d.clinton@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (21, N'Andrew Whippie', N'andrewdw', N'10655953', N'andrew.d.whipple@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (22, N'Brian Romo', N'bcromo', N'10644431', N'brian.c.romo@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (23, N'Gerrit Lensink', N'gerritle', N'11831009', N'gerrit.lensink@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (24, N'Gustavo Leiton', N'gaguilar', N'10670978', N'gustavo.aguilar.leiton@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (25, N'Katherine Reyes', N'reyeska', N'11814118', N'katherine.reyes@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (26, N'SL Chiu', N'slchiu', N'11749650', N'sl.chiu@domain.com', 1, N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2), N'sys_nsgqana', CAST(N'2021-03-12T23:08:25.3966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (27, N'Adithya Shankar ', N'adithyas', N'11759602', N'adithya.shankar@domain.com', 1, N'system', CAST(N'2021-10-14T21:09:48.2800000' AS DateTime2), N'system', CAST(N'2021-10-14T21:09:48.2800000' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (28, N'Linda Cheng', N'chengl1', N'12058276', N'linda.cheng@domain.com', 1, N'system', CAST(N'2021-10-14T21:09:48.2800000' AS DateTime2), N'system', CAST(N'2021-10-14T21:09:48.2800000' AS DateTime2))
		

		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (29, N'Tian, FuhanX', N'ftianx', N'12034907', N'fuhanx.tian@domain.com', 1, N'system', CAST(N'2021-10-20 18:09:09.7966667' AS DateTime2), N'system', CAST(N'2021-10-20 18:09:09.7966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (30, N'Anand Ayyasamy', N'aayyasax', N'12059796', N'anandx.ayyasamy@domain.com', 1, N'system', CAST(N'2021-10-20 18:09:09.7966667' AS DateTime2), N'system', CAST(N'2021-10-20 18:09:09.7966667' AS DateTime2))
		INSERT [qan].[Reviewers] ([Id], [Name], [Idsid], [Wwid], [Email], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (31, N'Sureshkumar Jayapal', N'jayapa1x', N'12060315', N'sureshkumarx.jayapal@domain.com', 1, N'system', CAST(N'2021-10-20 18:09:09.7966667' AS DateTime2), N'system', CAST(N'2021-10-20 18:09:09.7966667' AS DateTime2))

		
		-- Add more reviewers here by adding more insert statements
		SET IDENTITY_INSERT [qan].[Reviewers] OFF
		-- Add new reference items here

		PRINT 'Records created successfully'

END
