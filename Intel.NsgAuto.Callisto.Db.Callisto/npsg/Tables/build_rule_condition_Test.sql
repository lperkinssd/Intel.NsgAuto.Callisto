CREATE TABLE [npsg].[build_rule_condition_Test] (
    [build_rule_condition_id] INT           IDENTITY (1, 1) NOT NULL,
    [column_name]             VARCHAR (100) NULL,
    [column_operator]         VARCHAR (100) NULL,
    [operator]                VARCHAR (100) NULL,
    [column_value]            VARCHAR (100) NULL,
    [build_rule_id]           VARCHAR (100) NULL,
    [created_by]              VARCHAR (100) NULL,
    [created_date]            VARCHAR (100) NULL,
    [lastmodified_by]         VARCHAR (100) NULL,
    [lastmodified_date]       DATETIME      NULL
);



