-- =============================================================
-- Author       : bricschx
-- Create date  : 2020-09-09 10:07:39.533
-- Description  : Gets the email templates
-- Example      : EXEC [ref].[GetEmailTemplates] 1;
-- =============================================================
CREATE PROCEDURE [ref].[GetEmailTemplates]
(
	  @Id           INT         = NULL
	, @Name         VARCHAR(50) = NULL
	, @IsHtml       BIT         = NULL
	, @BodyXslId    INT         = NULL
	, @BodyXslName  VARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM [ref].[FEmailTemplates](@Id, @Name, @IsHtml, @BodyXslId, @BodyXslName) ORDER BY [Id] DESC;

END
