CREATE TABLE [qan].[build_rule_Test] (
    [build_rule_id]        INT           IDENTITY (1, 1) NOT NULL,
    [design_id]            VARCHAR (100) NULL,
    [fabrication_facility] VARCHAR (100) NULL,
    [test_flow]            VARCHAR (100) NULL,
    [prb_conv_id]          VARCHAR (100) NULL,
    [created_by]           VARCHAR (100) NULL,
    [created_date]         DATETIME      NULL,
    [lastmodified_by]      VARCHAR (100) NULL,
    [lastmodified_date]    DATETIME      NULL,
    CONSTRAINT [PK_build_rule_Test] PRIMARY KEY CLUSTERED ([build_rule_id] ASC)
);







