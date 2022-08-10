CREATE TYPE [npsg].[IPrfRecords] AS TABLE (
    [Odm_Desc]        VARCHAR (255) NULL,
    [SSD_Family_Name] VARCHAR (255) NULL,
    [MM_Number]       VARCHAR (50)  NULL,
    [Product_Code]    VARCHAR (50)  NULL,
    [SSD_Name]        VARCHAR (MAX) NULL,
    [CreateDate]      DATETIME      NULL);

