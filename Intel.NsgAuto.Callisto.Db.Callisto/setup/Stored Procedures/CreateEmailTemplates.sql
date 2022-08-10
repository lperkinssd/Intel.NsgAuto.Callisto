CREATE PROCEDURE [setup].[CreateEmailTemplates]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count INT = 0;
	DECLARE @Message VARCHAR(MAX);
	DECLARE @TableName VARCHAR(100) = '[ref].[EmailTemplates]';
	BEGIN
		TRUNCATE TABLE [ref].[EmailTemplates];
		SET @Message = @TableName + ' table truncated';
		PRINT @Message;

		SET IDENTITY_INSERT [ref].[EmailTemplates] ON;

		INSERT [ref].[EmailTemplates] ([Id], [Name], [Subject], [IsHtml], [Body], [BodyXslId], [BodyXml]) VALUES (1, N'ReviewSubmit', N'[Submitted] {4}: {5}', 1, NULL, 1, N'<ROOT>
					<MAIL>
						<IMGAUTOBLOCKS>
							<![CDATA[
								<img src="{0}/Images/autoblocks.png" alt="" border="0" />
							]]>
						</IMGAUTOBLOCKS>
						<IMGINTEL>
							<![CDATA[
								<img src="{0}/Images/logo.png" alt="" border="0" />
							]]>
						</IMGINTEL>
						<MESSAGE>
							<![CDATA[
								<p>Hello!</p>
								<p>You are receiving this email because you have submitted the following {4} for review in Callisto.</p>
								<p>{5}</p>
								<p>The review process is at: <b><i>{2}</i></b></p>
								<p>Click <a class="nsgalink" href="{1}">here</a> to open the request. Alternatively, you may copy and paste the web address {1} in the browser address bar.</p>
							]]>
						</MESSAGE>
					</MAIL>
				</ROOT>')

INSERT [ref].[EmailTemplates] ([Id], [Name], [Subject], [IsHtml], [Body], [BodyXslId], [BodyXml]) VALUES (2, N'ReviewAction', N'[Action Required] Review {4}: {5} ({2})', 1, NULL, 1, N'<ROOT>
					<MAIL>
						<IMGAUTOBLOCKS>
							<![CDATA[
								<img src="{0}/Images/autoblocks.png" alt="" border="0" />
							]]>
						</IMGAUTOBLOCKS>
						<IMGINTEL>
							<![CDATA[
								<img src="{0}/Images/logo.png" alt="" border="0" />
							]]>
						</IMGINTEL>
						<MESSAGE>
							<![CDATA[
								<p>Hello!</p>
								<p><b><span style="color: red;">Action Required!</span></b>&nbsp&nbspYour review input is requested</p>
								<p>You are receiving this email notification because you are an assigned reviewer for the following {4} in Callisto.</p>
								<p>{5}</p>
								<p>The review process is at: <b><i>{2}</i></b></p>
								<p>Click <a class="nsgalink" href="{1}">here</a> to open the request. Alternatively, you may copy and paste the web address {1} in the browser address bar.</p>
							]]>
						</MESSAGE>
					</MAIL>
				</ROOT>')

INSERT [ref].[EmailTemplates] ([Id], [Name], [Subject], [IsHtml], [Body], [BodyXslId], [BodyXml]) VALUES (3, N'ReviewApprove', N'[Approved] {4}: {5} ({2})', 1, NULL, 1, N'<ROOT>
					<MAIL>
						<IMGAUTOBLOCKS>
							<![CDATA[
								<img src="{0}/Images/autoblocks.png" alt="" border="0" />
							]]>
						</IMGAUTOBLOCKS>
						<IMGINTEL>
							<![CDATA[
								<img src="{0}/Images/logo.png" alt="" border="0" />
							]]>
						</IMGINTEL>
						<MESSAGE>
							<![CDATA[
								<p>Hello!</p>
								<p>You are receiving this email notification because the following {4} has been approved in Callisto.</p>
								<p>{5}</p>
								<p>It was approved at review process: <b><i>{2}</i></b></p>
								<p>Click <a class="nsgalink" href="{1}">here</a> to open the request. Alternatively, you may copy and paste the web address {1} in the browser address bar.</p>
							]]>
						</MESSAGE>
					</MAIL>
				</ROOT>')

INSERT [ref].[EmailTemplates] ([Id], [Name], [Subject], [IsHtml], [Body], [BodyXslId], [BodyXml]) VALUES (4, N'ReviewCancel', N'[Canceled] {4}: {5}', 1, NULL, 1, N'<ROOT>
					<MAIL>
						<IMGAUTOBLOCKS>
							<![CDATA[
								<img src="{0}/Images/autoblocks.png" alt="" border="0" />
							]]>
						</IMGAUTOBLOCKS>
						<IMGINTEL>
							<![CDATA[
								<img src="{0}/Images/logo.png" alt="" border="0" />
							]]>
						</IMGINTEL>
						<MESSAGE>
							<![CDATA[
								<p>Hello!</p>
								<p>You are receiving this email notification as you have canceled the following {4} in Callisto.</p>
								<p>{5}</p>
								<p>Click <a class="nsgalink" href="{1}">here</a> to open the request. Alternatively, you may copy and paste the web address {1} in the browser address bar.</p>
							]]>
						</MESSAGE>
					</MAIL>
				</ROOT>')

INSERT [ref].[EmailTemplates] ([Id], [Name], [Subject], [IsHtml], [Body], [BodyXslId], [BodyXml]) VALUES (5, N'ReviewPORGenerated', N'[POR Generated] {4}: {5}', 1, NULL, 1, N'<ROOT>
					<MAIL>
						<IMGAUTOBLOCKS>
							<![CDATA[
								<img src="{0}/Images/autoblocks.png" alt="" border="0" />
							]]>
						</IMGAUTOBLOCKS>
						<IMGINTEL>
							<![CDATA[
								<img src="{0}/Images/logo.png" alt="" border="0" />
							]]>
						</IMGINTEL>
						<MESSAGE>
							<![CDATA[
								<p>Hello!</p>
								<p>You are receiving this email notification as a POR has been generated for your {4} in Callisto.</p>
								<p>{5}</p>
								<p>The review process is at: <b><i>{2}</i></b></p>
								<p>Click <a class="nsgalink" href="{1}">here</a> to open the request. Alternatively, you may copy and paste the web address {1} in the browser address bar.</p>
							]]>
						</MESSAGE>
					</MAIL>
				</ROOT>')

INSERT [ref].[EmailTemplates] ([Id], [Name], [Subject], [IsHtml], [Body], [BodyXslId], [BodyXml]) VALUES (6, N'ReviewReject', N'[Rejected] {4}: {5} ({2})', 1, NULL, 1, N'<ROOT>
					<MAIL>
						<IMGAUTOBLOCKS>
							<![CDATA[
								<img src="{0}/Images/autoblocks.png" alt="" border="0" />
							]]>
						</IMGAUTOBLOCKS>
						<IMGINTEL>
							<![CDATA[
								<img src="{0}/Images/logo.png" alt="" border="0" />
							]]>
						</IMGINTEL>
						<MESSAGE>
							<![CDATA[
								<p>Hello!</p>
								<p>You are receiving this email notification because the following {4} has been rejected in Callisto.</p>
								<p>{5}</p>
								<p>It was rejected at review process: <b><i>{2}</i></b></p>
								<p><b><span style="color: red;">Action Required!</span></b> {3}: As the submitter for this {4} you should review the rejection comment and submit a new one for review with any necessary updates.</p>
								<p>Click <a class="nsgalink" href="{1}">here</a> to open the request in Callisto. Alternatively, you may copy and paste the web address {1} in the browser address bar.</p>
							]]>
						</MESSAGE>
					</MAIL>
				</ROOT>')

INSERT [ref].[EmailTemplates] ([Id], [Name], [Subject], [IsHtml], [Body], [BodyXslId], [BodyXml]) VALUES (7, N'ReviewRejectReviewer', N'[Rejected] {4}: {5}', 1, NULL, 1, N'<ROOT>
					<MAIL>
						<IMGAUTOBLOCKS>
							<![CDATA[
								<img src="{0}/Images/autoblocks.png" alt="" border="0" />
							]]>
						</IMGAUTOBLOCKS>
						<IMGINTEL>
							<![CDATA[
								<img src="{0}/Images/logo.png" alt="" border="0" />
							]]>
						</IMGINTEL>
						<MESSAGE>
							<![CDATA[
								<p>Hello!</p>
								<p>You are receiving this email notification because you are an assigned reviewer on this {4} in Callisto. The version has been rejected. If a new version is submitted for review you will be notified.</p>
								<p>{5}</p>
								<p>Click <a class="nsgalink" href="{1}">here</a> to open the version in Callisto. Alternatively, you may copy and paste the web address {1} in the browser address bar.</p>
							]]>
						</MESSAGE>
					</MAIL>
				</ROOT>')

INSERT [ref].[EmailTemplates] ([Id], [Name], [Subject], [IsHtml], [Body], [BodyXslId], [BodyXml]) VALUES (8, N'ReviewComplete', N'[Active] {4}: {5}', 1, NULL, 1, N'<ROOT>
					<MAIL>
						<IMGAUTOBLOCKS>
							<![CDATA[
								<img src="{0}/Images/autoblocks.png" alt="" border="0" />
							]]>
						</IMGAUTOBLOCKS>
						<IMGINTEL>
							<![CDATA[
								<img src="{0}/Images/logo.png" alt="" border="0" />
							]]>
						</IMGINTEL>
						<MESSAGE>
							<![CDATA[
								<p>Hello!</p>
								<p>You are receiving this email notification as the review process has completed successfully for the following {4} in Callisto and it is now active.</p>
								<p>{5}</p>
								<p>Click <a class="nsgalink" href="{1}">here</a> to open the request. Alternatively, you may copy and paste the web address {1} in the browser address bar.</p>
							]]>
						</MESSAGE>
					</MAIL>
				</ROOT>')

INSERT [ref].[EmailTemplates] ([Id], [Name], [Subject], [IsHtml], [Body], [BodyXslId], [BodyXml]) VALUES (9, N'ProductOwnershipChange', N'Product Ownership Change Notification', 1, NULL, 2, N'<ROOT><MAIL><IMGAUTOBLOCKS><![CDATA[<img src="{0}/Images/autoblocks.png" alt="" border="0" />]]></IMGAUTOBLOCKS><IMGINTEL><![CDATA[<img src="{0}/Images/logo.png" alt="" border="0" />]]></IMGINTEL><MESSAGE><![CDATA[<p> You are receiving this notification since the product ownership information was changed. Please view the details <a href=''{4}''>here</a> </p><p><b>Product (s)</b> :  <br>{1}</p><p><b>Role</b>:<br> {2}  <br><br>Change initiated by: {3}</p> ]]></MESSAGE></MAIL></ROOT>')
INSERT [ref].[EmailTemplates] ([Id], [Name], [Subject], [IsHtml], [Body], [BodyXslId], [BodyXml]) VALUES (10, N'AccountOwnershipChange', N'Account Ownership Change Notification', 1, NULL, 2, N'<ROOT><MAIL><IMGAUTOBLOCKS><![CDATA[<img src="{0}/Images/autoblocks.png" alt="" border="0" />]]></IMGAUTOBLOCKS><IMGINTEL><![CDATA[<img src="{0}/Images/logo.png" alt="" border="0" />]]></IMGINTEL><MESSAGE><![CDATA[<p> You are receiving this notification since the account ownership information was changed. Please view the details <a href=''{4}''>here</a> </p><p><b>Product (s)</b> :  <br>{1}</p><p><b>Role</b>:<br> {2}  <br><br>Change initiated by: {3}</p> ]]></MESSAGE></MAIL></ROOT>')
		SET IDENTITY_INSERT [ref].[EmailTemplates] OFF;
	END
	SELECT @Count = COUNT(*) FROM [ref].[EmailTemplates] WITH (NOLOCK);
	SET @Message = @TableName + ' records created: ' + CAST(@Count AS VARCHAR(20));
	PRINT @Message;
END
