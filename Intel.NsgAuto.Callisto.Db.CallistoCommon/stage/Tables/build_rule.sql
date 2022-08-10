CREATE TABLE [stage].[build_rule] (
    [build_rule_id]        INT          IDENTITY (1, 1) NOT NULL,
    [design_id]            VARCHAR (15) NOT NULL,
    [fabrication_facility] VARCHAR (15) NOT NULL,
    [test_flow]            VARCHAR (20) NULL,
    [prb_conv_id]          VARCHAR (20) NULL,
    [created_by]           VARCHAR (20) NULL,
    [created_date]         DATETIME     NULL,
    [lastmodified_by]      VARCHAR (20) NULL,
    [lastmodified_date]    DATETIME     NULL,
    PRIMARY KEY CLUSTERED ([build_rule_id] ASC)
);

