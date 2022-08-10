﻿



-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-03-02 16:38:31.110
-- Description  : Creates the initial osats
-- Example      : EXEC [setup].[CreateInitialOsats] 'bricschx';
--                SELECT * FROM [qan].[Osats];
-- =================================================================================
CREATE PROCEDURE [setup].[CreateProductContacts]
(
	  @By VARCHAR(25) = 'SYSTEM'
)
AS
BEGIN
	    TRUNCATE TABLE [qan].[ProductContacts];
		SET IDENTITY_INSERT [qan].[ProductContacts] ON
		PRINT 'Table removed successfully';
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (234, N'Cannon, Jamie', N'11820126', N'jamiecan', N'jamie.cannon@domain.com', N'jamie.cannon@solidigmtechnology.com', 1, N'SYSTEM', CAST(N'2021-12-21T23:17:44.7433333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:17:44.7433333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (235, N'Doherty, Dennis O', N'10700489', N'dodohert', N'Dennis.O.Doherty@domain.com', N'Dennis.Doherty@solidigmtechnology.com', 1, N'SYSTEM', CAST(N'2021-12-21T23:17:44.7433333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:17:44.7433333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (236, N'Jamieson, Mark', N'10548116', N'mjamies', N'mark.jamieson@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:17:44.7433333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:17:44.7433333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (237, N'Khoury, Nazih K', N'10676044', N'nkkhoury', N'nazih.k.khoury@domain.com', N'nazih.khoury@solidigmtechnology.com', 1, N'SYSTEM', CAST(N'2021-12-21T23:17:44.7433333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:17:44.7433333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (238, N'Reed, Michael A', N'10071120', N'mareed', N'michael.a.reed@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:17:44.7433333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:17:44.7433333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (239, N'Zhang, Lance', N'10501528', N'zhangli1', N'lance.zhang@domain.com', N'lance.zhang@solidigmtechnology.com', 1, N'SYSTEM', CAST(N'2021-12-21T23:17:44.7433333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:17:44.7433333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (240, N'Tang, Gernia I', N'10623082', N'gitang', N'gernia.i.tang@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:20:48.1033333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:20:48.1033333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (241, N'Yin, Neo', N'11903811', N'neoyin', N'neo.yin@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:20:48.1033333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:20:48.1033333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (242, N'Chen, Jane', N'12001831', N'janechen', N'jane.chen@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:22:58.5733333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:22:58.5733333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (243, N'Cuendet, John S', N'10058660', N'jscuende', N'john.s.cuendet@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:22:58.5733333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:22:58.5733333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (244, N'Ushakov, Valery', N'11853187', N'vushakov', N'valery.ushakov@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:22:58.5733333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:22:58.5733333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (245, N'Truong, Tramy', N'11959581', N'tramytru', N'tramy.truong@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:28:21.1866667' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:28:21.1866667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (246, N'Muchhal, Ratnesh', N'10720154', N'rmuchhal', N'ratnesh.muchhal@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:30:18.6566667' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:30:18.6566667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (247, N'Hudson, John Paul', N'10061816', N'jhudson', N'john.paul.hudson@domain.com', N'john.paul.hudson@solidigmtechnology.com', 1, N'SYSTEM', CAST(N'2021-12-21T23:32:03.2500000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:32:03.2500000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (248, N'Jacobosky, Brian', N'10075349', N'bljacobo', N'brian.jacobosky@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:32:03.2500000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:32:03.2500000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (249, N'Noah, Mohannad', N'10049666', N'mnoah', N'mohannad.noah@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:32:03.2500000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:32:03.2500000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (250, N'Rahman, Tahmid U', N'10663522', N'turahman', N'tahmid.u.rahman@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:33:03.6100000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:33:03.6100000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (251, N'Sun, Yuyang', N'11526989', N'yuyangsu', N'yuyang.sun@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:34:07.3766667' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:34:07.3766667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (252, N'Motomori, Koji', N'10577594', N'kmotomor', N'koji.motomori@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:35:58.3000000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:35:58.3000000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (253, N'Sane, Monika S', N'10533986', N'mssane', N'monika.s.sane@domain.com', N'monika.s.sane@solidigmtechnology.com', 1, N'SYSTEM', CAST(N'2021-12-21T23:35:58.3000000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:35:58.3000000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (254, N'Zimmerman, Aaron K', N'10693766', N'aaronkzi', N'aaron.k.zimmerman@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:38:07.7533333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:38:07.7533333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (255, N'Nguyen, Jason', N'11941882', N'jasonngu', N'jason.nguyen@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-21T23:41:39.9433333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-21T23:41:39.9433333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (256, N'Foster, Charles Br', N'10706107', N'cbfoste1', N'charles.br.foster@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T00:05:57.2100000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T00:05:57.2100000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (257, N'Wei, Frank', N'10708671', N'zwei1', N'frank.wei@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T00:05:57.2100000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T00:05:57.2100000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (258, N'Cain, Barrett D', N'10069534', N'bdcain', N'barrett.d.cain@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T00:20:53.5300000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T00:20:53.5300000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (259, N'Bollapragada, Balaram', N'10077948', N'bpbollap', N'balaram.bollapragada@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T00:32:32.9600000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T00:32:32.9600000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (260, N'Kang, Hai Feng', N'11412673', N'haifengk', N'hai.feng.kang@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T00:40:11.7300000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T00:40:11.7300000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (261, N'Tuhy, David', N'10597450', N'dtuhy', N'david.tuhy@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T00:40:11.7300000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T00:40:11.7300000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (262, N'Dennis, Lydia', N'11366161', N'ldennis', N'lydia.dennis@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T02:32:46.7100000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T02:32:46.7100000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (263, N'Hong, Henry', N'10500009', N'hyhong', N'henry.hong@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T02:32:46.7100000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T02:32:46.7100000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (264, N'Zhu, Qian', N'11270894', N'qzhu8', N'qian.zhu@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T02:32:46.7100000' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T02:32:46.7100000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (265, N'Che Neba, Messac', N'12004900', N'mcheneba', N'messac.che.neba@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T02:41:15.6533333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T02:41:15.6533333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (266, N'Heiner, Kellen B', N'11413260', N'kbheiner', N'kellen.b.heiner@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T02:41:15.6533333' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T02:41:15.6533333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (267, N'Khanal, Pradeep', N'11271695', N'pkhanal', N'pradeep.khanal@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T02:42:07.7166667' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T02:42:07.7166667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (268, N'Benoist, Jon', N'12016494', N'jonbenoi', N'jon.benoist@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T02:43:45.5166667' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T02:43:45.5166667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (269, N'Tang, Arvin', N'10715038', N'tanghua', N'arvin.tang@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T02:46:39.1566667' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T02:46:39.1566667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (270, N'Liang, Mark', N'10687200', N'hliang2', N'mark.liang@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T02:47:31.2366667' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T02:47:31.2366667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (271, N'Grabski, Don', N'11893301', N'dgrabski', N'don.grabski@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T02:51:43.8166667' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T02:51:43.8166667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (272, N'Stryker, Ace', N'11626885', N'tstryker', N'ace.stryker@domain.com', NULL, 1, N'SYSTEM', CAST(N'2021-12-22T02:51:43.8166667' AS DateTime2), N'SYSTEM', CAST(N'2021-12-22T02:51:43.8166667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (273, N'Jayapal, SureshkumarX', N'12060315', N'jayapa1x', N'sureshkumarx.jayapal@domain.com', NULL, 1, N'jayapa1x', CAST(N'2021-12-31T17:01:25.4866667' AS DateTime2), N'jayapa1x', CAST(N'2021-12-31T17:01:25.4866667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (274, N'Kurian, Jose', N'11330800', N'jkurian', N'jose.kurian@domain.com', NULL, 1, N'jayapa1x', CAST(N'2021-12-31T17:01:25.4866667' AS DateTime2), N'jayapa1x', CAST(N'2021-12-31T17:01:25.4866667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (275, N'Assadian, Elsa', N'11572134', N'eassadia', N'elsa.assadian@domain.com', N'michael.j.reed@domain.com ', 1, N'rosalvox', CAST(N'2022-02-02T18:10:00.6333333' AS DateTime2), N'rosalvox', CAST(N'2022-02-02T18:10:00.6333333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (276, N'Taylor, Angela K', N'11567592', N'angelata', N'angela.k.taylor@domain.com', N'taylor.angela@solidigmtechnology.com', 1, N'rosalvox', CAST(N'2022-02-02T18:20:38.9733333' AS DateTime2), N'rosalvox', CAST(N'2022-02-02T18:20:38.9733333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (277, N'Bhat, Kiran U', N'10691011', N'kubhat', N'kiran.u.bhat@domain.com', N'bhat.kiran@solidigmtechnology.com', 1, N'rosalvox', CAST(N'2022-02-02T18:26:17.4400000' AS DateTime2), N'rosalvox', CAST(N'2022-02-02T18:26:17.4400000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (278, N'Ugokwe, Uche', N'11785755', N'uugokwe', N'uche.ugokwe@domain.com', N'uche.ugokwe@solidigmtechnology.com', 1, N'rosalvox', CAST(N'2022-02-02T18:57:47.4600000' AS DateTime2), N'rosalvox', CAST(N'2022-02-02T18:57:47.4600000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (279, N'Nakano, Aya', N'11898188', N'ayanakan', N'aya.nakano@domain.com', N'aya.nakano@solidigmtechnology.com', 1, N'rosalvox', CAST(N'2022-02-02T19:22:27.6600000' AS DateTime2), N'rosalvox', CAST(N'2022-02-02T19:22:27.6600000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (280, N'Worley Jr, Dennis', N'11938231', N'dworleyj', N'dennis.worley.jr@domain.com', N'dennis.worley.jr@solidigmtechnology.com', 1, N'rosalvox', CAST(N'2022-02-02T21:23:00.7766667' AS DateTime2), N'rosalvox', CAST(N'2022-02-02T21:23:00.7766667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (281, N'Reed, Michael J', N'10056149', N'mjreed', N'michael.j.reed@domain.com', N'michael.j.reed@domain.com', 1, N'rosalvox', CAST(N'2022-02-02T22:12:50.4866667' AS DateTime2), N'rosalvox', CAST(N'2022-02-02T22:12:50.4866667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (282, N'Wang, Fiona Y', N'11304113', N'ywan149', N'fiona.y.wang@domain.com', N'fiona.y.wang@domain.com', 1, N'rosalvox', CAST(N'2022-02-02T23:48:05.9733333' AS DateTime2), N'rosalvox', CAST(N'2022-02-02T23:48:05.9733333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (283, N'Sze, Juanita', N'10709020', N'jsze', N'juanita.sze@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-19T00:40:57.5466667' AS DateTime2), N'llxu', CAST(N'2022-02-19T00:40:57.5466667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (284, N'Diaz, Jesus A', N'10641625', N'jadiaz', N'jesus.a.diaz@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-24T17:27:16.1666667' AS DateTime2), N'llxu', CAST(N'2022-02-24T17:27:16.1666667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (285, N'Juanita Sze', N'10709020', N'jsze', N'juanita.sze@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-24T17:27:16.1666667' AS DateTime2), N'llxu', CAST(N'2022-02-24T17:27:16.1666667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (286, N'Jimenez, Gilbert', N'10656715', N'gjimenez', N'gilbert.jimenez@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-24T17:28:15.2300000' AS DateTime2), N'llxu', CAST(N'2022-02-24T17:28:15.2300000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (287, N'Gish, Steven M', N'10055846', N'smgish', N'steven.m.gish@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-24T17:29:04.5500000' AS DateTime2), N'llxu', CAST(N'2022-02-24T17:29:04.5500000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (288, N'Reynolds, Michael J', N'10066989', N'mjreynol', N'michael.j.reynolds@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-24T17:31:36.0033333' AS DateTime2), N'llxu', CAST(N'2022-02-24T17:31:36.0033333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (289, N'Wu, Ren', N'10650506', N'wuren', N'ren.wu@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-24T21:44:34.0666667' AS DateTime2), N'llxu', CAST(N'2022-02-24T21:44:34.0666667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (290, N'Kulkarni, Raghu', N'11925826', N'raghukul', N'raghu.kulkarni@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-24T21:48:42.0466667' AS DateTime2), N'llxu', CAST(N'2022-02-24T21:48:42.0466667' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (291, N'Kuskie, Tyler', N'11473334', N'tkuskie', N'tyler.kuskie@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-24T21:50:34.9933333' AS DateTime2), N'llxu', CAST(N'2022-02-24T21:50:34.9933333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (292, N'Aziz, Ans', N'11346931', N'ansaziz', N'ans.aziz@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-24T21:51:33.6300000' AS DateTime2), N'llxu', CAST(N'2022-02-24T21:51:33.6300000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (293, N'LoConti, Craig L', N'10639882', N'cllocont', N'craig.l.loconti@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-24T21:53:19.5200000' AS DateTime2), N'llxu', CAST(N'2022-02-24T21:53:19.5200000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (294, N'Gubezskis, Tal', N'10666242', N'gtal', N'tal.gubezskis@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-24T22:35:49.4500000' AS DateTime2), N'llxu', CAST(N'2022-02-24T22:35:49.4500000' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (295, N'Lamm, Mayuli', N'10687903', N'mlamm', N'mayuli.lamm@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-24T22:36:44.6833333' AS DateTime2), N'llxu', CAST(N'2022-02-24T22:36:44.6833333' AS DateTime2))
		INSERT [qan].[ProductContacts] ([Id], [Name], [WWID], [idSid], [Email], [AlternateEmail], [IsActive], [CreatedBy], [CreatedOn], [UpdatedBy], [UpdatedOn]) VALUES (296, N'Mallela, Ram', N'10072933', N'rmallela', N'ram.mallela@domain.com', NULL, 1, N'llxu', CAST(N'2022-02-24T22:37:33.3166667' AS DateTime2), N'llxu', CAST(N'2022-02-24T22:37:33.3166667' AS DateTime2))
		SET IDENTITY_INSERT [qan].[ProductContacts] OFF
		PRINT 'Table removed successfully';
END