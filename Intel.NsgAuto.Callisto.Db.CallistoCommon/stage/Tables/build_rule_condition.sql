CREATE TABLE [stage].[build_rule_condition] (
    [build_rule_condition_id] INT           IDENTITY (1, 1) NOT NULL,
    [column_name]             VARCHAR (25)  NOT NULL,
    [column_operator]         VARCHAR (20)  NULL,
    [operator]                VARCHAR (20)  NULL,
    [column_value]            VARCHAR (500) NOT NULL,
    [build_rule_id]           INT           NOT NULL,
    [created_by]              VARCHAR (20)  NULL,
    [created_date]            DATETIME      NULL,
    [lastmodified_by]         VARCHAR (20)  NULL,
    [lastmodified_date]       DATETIME      NULL,
    PRIMARY KEY CLUSTERED ([build_rule_condition_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_build_rule_condition_build_rule_id]
    ON [stage].[build_rule_condition]([build_rule_id] ASC);

