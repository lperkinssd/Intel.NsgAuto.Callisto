
-- =================================================================================
-- Author       : bricschx
-- Create date  : 2021-01-07 16:18:22.073
-- Description  : Creates the email template body style sheet records
-- Example      : EXEC [setup].[CreateEmailTemplateBodyXsls];
--                SELECT * FROM [ref].[EmailTemplateBodyXsls];
--Update Date   : 2021-11-30 16:48:00.078
--Description   : Added the new Insert Script at the end 
-- =================================================================================
CREATE PROCEDURE [setup].[CreateEmailTemplateBodyXsls]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[EmailTemplateBodyXsls]';
	BEGIN
		TRUNCATE TABLE [ref].[EmailTemplateBodyXsls];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[EmailTemplateBodyXsls] ON;

		INSERT [ref].[EmailTemplateBodyXsls] ([Id], [Name], [Value]) VALUES (1, N'MOAutomation', N'<?xml version="1.0"?>
				<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
					<xsl:output method="html"/>
					<xsl:template match="/">
						<html>
							<head>
								<meta name="viewport" content="width=device-width" />
								<style type="text/css">
									body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td,a,select{font-family:Verdana,Tahoma,helvetica,sans-serif;}
									*{outline:none;}
									html{color:#555555;background:#FFFFFF;height:100%;outline:none;font-family:Verdana,Tahoma,helvetica,sans-serif;}
									body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td{padding:0;margin:0;}
									td{padding:0;margin:0;}
									table{border-collapse:collapse;border-spacing:0;}
									body{background:#ffffff;height:100%;outline:none;}
									p{color:#666;font-size:12px!important;}
									a{text-decoration:none;color:#0071c5;outline:none;}
									a:hover{text-decoration: none;color: #00aeef !important;outline:none;}
									.applogo {margin-left:10px; margin-bottom: 10px; color: #f5f5f5; font-size: 26px; font-weight: bold; line-height: 40px; height: 40px; display: block;}
									.autologo {margin-top: 50px; margin-left:0px; color: #2cd0fd; font-size: 16px; font-weight: bold; line-height: 40px; height: 40px; display: block; font-family:"Intel Clear" }
									.classification{margin-left: 15px;margin-right: 4px;font-size: 11px;font-style: italic;color: #f5f5f5;}
									.foottext{color: #555555;font-size: 12px;text-align: center;}
									.nsgacontent{font-size:14x;color:#555;padding:15px;}
									.nsgatable{border: 1px solid #CBD9E6;font-size:14x;color:#555555;}
									.nsgaheading{color: #555555;font-size: 24px;font-weight: bold;line-height: 24px;padding-top:10px;margin-top:10px;}
									.nsgalink {text-decoration:none;color:#0071c5;outline:none;}
									.nsgalink :hover{text-decoration: none;color: #00aeef;outline:none;}
									.nsgalink :visited{text-decoration:none;color:#0071c5;outline:none;}
									.poweredby {margin-top: 50px;margin-left:2px; color: #2cd0fd;font-size: 11px; font-weight: normal; line-height: 40px; height: 40px; display: block; font-style:italic; font-family:"Intel Clear"}
									.intelconfidential{text-align:center; padding-bottom:15px;}
								</style>
							</head>
							<body>
								<table style="width:720px" class="nsgatable">
									<tr>
										<td>
											<!-- Header { -->
											<table style="width:100%;background-color: #0071c5;" bgcolor="background-color: #0071c5;">
												<tr style="background-color: #0071c5;height:65px;padding:4px;">
													<td style="text-align:center; width:200px;">
														<xsl:value-of disable-output-escaping="yes" select="/ROOT/MAIL/IMGINTEL/text()"/>
													</td>
													<td style="text-align:center; width:160px;">
														<span class="applogo">Callisto</span><br/>
														<span class="classification">Intel Confidential</span>
													</td>
													<td style="text-align:left; width:70px;line-height:50px;">
														<span class="poweredby">Powered by :</span>
													</td>
													<td style="text-align:left; width:35px">
														<xsl:value-of disable-output-escaping="yes" select="/ROOT/MAIL/IMGAUTOBLOCKS/text()"/>
													</td>
													<td style="line-height:50px;">
														<span class="autologo">M&amp;O Automation</span>
													</td>
												</tr>
											</table>
											<!--  } Header -->
											<table>
												<tr>
													<td class="nsgacontent">
														<div>
															<xsl:value-of disable-output-escaping="yes" select="/ROOT/MAIL/MESSAGE/text()"/>
															<p>
																<b>Thank you</b><br/>
																<b>Callisto</b>
															</p>
															<p>
																For assistance, please contact: <a href="mailto:callisto_support@domain.com">callisto_support@domain.com</a>
															</p>
															<p>Please do not reply to this email message as this email address is used for outbound messages only.</p>
														</div>
													</td>
												</tr>
												<tr>
													<td class="intelconfidential">
														<p style="margin-top:8px;">
															<span><b>Intel Confidential</b></span>
															<br/>
															<span  class="foottext">© 2020 All rights reserved.</span>
															<br/>
															<span  class="foottext">
																<a class="nsgalink" href="http://www.domain.com/content/www/us/en/legal/trademarks.html">*Legal Information</a> | <a class="nsgalink" href="http://www.domain.com/content/www/us/en/privacy/intel-online-privacy-notice-summary.html">Privacy Policy</a>
															</span>
															<br/>
															<span class="foottext">*Other names and brands may be claimed as the property of others.</span>
															<br/>
															<span class="foottext">**Intel is not responsible for content of sites outside our intranet</span>
															<br/>
														</p>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</body>
						</html>
					</xsl:template>
				</xsl:stylesheet>')

INSERT [ref].[EmailTemplateBodyXsls] ([Id], [Name], [Value]) VALUES (2, N'OwnershipChange', N'<?xml version="1.0"?>
				<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
					<xsl:output method="html"/>
					<xsl:template match="/">
						<html>
							<head>
								<meta name="viewport" content="width=device-width" />
								<style type="text/css">
									body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td,a,select{font-family:Verdana,Tahoma,helvetica,sans-serif;}
									*{outline:none;}
									html{color:#555555;background:#FFFFFF;height:100%;outline:none;font-family:Verdana,Tahoma,helvetica,sans-serif;}
									body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td{padding:0;margin:0;}
									td{padding:0;margin:0;}
									table{border-collapse:collapse;border-spacing:0;}
									body{background:#ffffff;height:100%;outline:none;}
									p{color:#666;font-size:12px!important;}
									a{text-decoration:none;color:#0071c5;outline:none;}
									a:hover{text-decoration: none;color: #00aeef !important;outline:none;}
									.applogo {margin-left:10px; margin-bottom: 10px; color: #f5f5f5; font-size: 26px; font-weight: bold; line-height: 40px; height: 40px; display: block;}
									.autologo {margin-top: 50px; margin-left:0px; color: #2cd0fd; font-size: 16px; font-weight: bold; line-height: 40px; height: 40px; display: block; font-family:"Intel Clear" }
									.classification{margin-left: 15px;margin-right: 4px;font-size: 11px;font-style: italic;color: #f5f5f5;}
									.foottext{color: #555555;font-size: 12px;text-align: center;}
									.nsgacontent{font-size:14x;color:#555;padding:15px;}
									.nsgatable{border: 1px solid #CBD9E6;font-size:14x;color:#555555;}
									.nsgaheading{color: #555555;font-size: 24px;font-weight: bold;line-height: 24px;padding-top:10px;margin-top:10px;}
									.nsgalink {text-decoration:none;color:#0071c5;outline:none;}
									.nsgalink :hover{text-decoration: none;color: #00aeef;outline:none;}
									.nsgalink :visited{text-decoration:none;color:#0071c5;outline:none;}
									.poweredby {margin-top: 50px;margin-left:2px; color: #2cd0fd;font-size: 11px; font-weight: normal; line-height: 40px; height: 40px; display: block; font-style:italic; font-family:"Intel Clear"}
									.intelconfidential{text-align:center; padding-bottom:15px;}
								</style>
							</head>
							<body>
								<table style="width:720px" class="nsgatable">
									<tr>
										<td>
											<!-- Header { -->
											<table style="width:100%;background-color: #0071c5;" bgcolor="background-color: #0071c5;">
												<tr style="background-color: #0071c5;height:65px;padding:4px;">
													<td style="text-align:center; width:200px;">
														<xsl:value-of disable-output-escaping="yes" select="/ROOT/MAIL/IMGINTEL/text()"/>
													</td>
													<td style="text-align:center; width:160px;">
														<span class="applogo">Callisto</span><br/>
														<span class="classification">Intel Confidential</span>
													</td>
													<td style="text-align:left; width:70px;line-height:50px;">
														<span class="poweredby">Powered by :</span>
													</td>
													<td style="text-align:left; width:35px">
														<xsl:value-of disable-output-escaping="yes" select="/ROOT/MAIL/IMGAUTOBLOCKS/text()"/>
													</td>
													<td style="line-height:50px;">
														<span class="autologo">MS&amp;O Automation</span>
													</td>
												</tr>
											</table>
											<!--  } Header -->
											<table>
												<tr>
													<td class="nsgacontent">
														<div>
															<xsl:value-of disable-output-escaping="yes" select="/ROOT/MAIL/MESSAGE/text()"/>

  											
											<p>
																<b>Thank you</b><br/>
																<b>Callisto</b>
															</p>
														</div>
													</td>
												</tr>
												<tr>
													<td class="intelconfidential">
														<p style="margin-top:8px;">
															<span><b>Intel Confidential</b></span>
															<br/>
															<span  class="foottext">© 2020 company name here All rights reserved.</span>
															<br/>
															<span  class="foottext">
																<a class="nsgalink" href="http://www.domain.com/content/www/us/en/legal/trademarks.html">*Legal Information</a> | <a class="nsgalink" href="http://www.domain.com/content/www/us/en/privacy/intel-online-privacy-notice-summary.html">Privacy Policy</a>
															</span>
															<br/>
															<span class="foottext">*Other names and brands may be claimed as the property of others.</span>
															<br/>
															<span class="foottext">**Intel is not responsible for content of sites outside our intranet</span>
															<br/>
														</p>
													</td>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</body>
						</html>
					</xsl:template>
				</xsl:stylesheet>')
		SET IDENTITY_INSERT [ref].[EmailTemplateBodyXsls] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[EmailTemplateBodyXsls] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
