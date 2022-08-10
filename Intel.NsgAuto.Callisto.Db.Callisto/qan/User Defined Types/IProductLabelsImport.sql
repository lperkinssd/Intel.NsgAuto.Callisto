﻿CREATE TYPE [qan].[IProductLabelsImport] AS TABLE
(
    [RecordNumber]                    INT           NOT NULL,
    [ProductFamily]                   VARCHAR (500) NULL,
    [Customer]                        VARCHAR (500) NULL,
    [ProductionProductCode]           VARCHAR (500) NULL,
    [ProductFamilyNameSeries]         VARCHAR (500) NULL,
    [Capacity]                        VARCHAR (500) NULL,
    [ModelString]                     VARCHAR (500) NULL,
    [VoltageCurrent]                  VARCHAR (500) NULL,
    [InterfaceSpeed]                  VARCHAR (500) NULL,
    [OpalType]                        VARCHAR (500) NULL,
    [KCCId]                           VARCHAR (500) NULL,
    [CanadianStringClass]             VARCHAR (500) NULL,
    [DellPN]                          VARCHAR (500) NULL,
    [DellPPIDRev]                     VARCHAR (500) NULL,
    [DellEMCPN]                       VARCHAR (500) NULL,
    [DellEMCPNRev]                    VARCHAR (500) NULL,
    [HpePN]                           VARCHAR (500) NULL,
    [HpeModelString]                  VARCHAR (500) NULL,
    [HpeGPN]                          VARCHAR (500) NULL,
    [HpeCTAssemblyCode]               VARCHAR (500) NULL,
    [HpeCTRev]                        VARCHAR (500) NULL,
    [HpPN]                            VARCHAR (500) NULL,
    [HpCTAssemblyCode]                VARCHAR (500) NULL,
    [HpCTRev]                         VARCHAR (500) NULL,
    [LenovoFRU]                       VARCHAR (500) NULL,
    [Lenovo8ScodePN]                  VARCHAR (500) NULL,
    [Lenovo8ScodeBCH]                 VARCHAR (500) NULL,
    [Lenovo11ScodePN]                 VARCHAR (500) NULL,
    [Lenovo11ScodeRev]                VARCHAR (500) NULL,
    [Lenovo11ScodePN10]               VARCHAR (500) NULL,
    [OracleProductIdentifer]          VARCHAR (500) NULL,
    [OraclePN]                        VARCHAR (500) NULL,
    [OraclePNRev]                     VARCHAR (500) NULL,
    [OracleModel]                     VARCHAR (500) NULL,
    [OraclePkgPN]                     VARCHAR (500) NULL,
    [OracleMarketingPN]               VARCHAR (500) NULL,
    [CiscoPN]                         VARCHAR (500) NULL,
    [FujistuCSL]                      VARCHAR (500) NULL,
    [Fujitsu106PN]                    VARCHAR (500) NULL,
    [HitachiModelName]                VARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([RecordNumber] ASC)
);
