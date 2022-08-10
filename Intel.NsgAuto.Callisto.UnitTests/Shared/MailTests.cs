using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Intel.NsgAuto.Shared.Mail;

namespace Intel.NsgAuto.Callisto.UnitTests.Shared
{
    [TestClass]
    public class MailTests
    {
        public const string EMAIL_DATA = @"<ROOT>
                                              <MAIL>
                                                <RECIPIENT>Jose Kurian</RECIPIENT>
                                                <SERVICE>Shared Components</SERVICE>
                                                <HEADING>Email From Mail Component</HEADING>
                                                <MESSAGE><![CDATA[
                                                  <p>You are receiving this email notification as you have
                                                  submitted a request to unit test the mail component. Glad that this component works as expected.</p>
                                                  <p> </p>
                                                ]]></MESSAGE>
                                              </MAIL>
                                            </ROOT>";

        public const string EMAIL_TEMPLATE = @"<?xml version='1.0'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
  <xsl:output method='html'/>
  <xsl:template match='/'>
    <html>
      <head>
        <meta name='viewport' content='width=device-width' />
        <style type='text/css'>
          body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td,a,select{font-family:Verdana,Tahoma,helvetica,sans-serif;}
          *{outline:none;}
          html{color:#555555;background:#FFFFFF;height:100%;outline:none;font-family:Verdana,Tahoma,helvetica,sans-serif;}
          body,div,dl,dt,dd,ul,ol,li,h1,h2,h3,h4,h5,h6,pre,code,form,fieldset,legend,input,textarea,p,blockquote,th,td{padding:0;margin:0;}
          td{padding:0;margin:0;}
          table{border-collapse:collapse;border-spacing:0;}
          fieldset,img{border:0;}
          address,caption,cite,code,dfn,em,strong,th,var{font-style:normal;font-weight:normal;}
          li{list-style:none;}
          caption,th{text-align:left;}
          h1,h2,h3,h4,h5,h6{font-size:100%;font-weight:normal;}
          q:before,q:after{content:'';}
          abbr,acronym{border:0;font-variant:normal;}
          sup{vertical-align:text-top;}
          sub{vertical-align:text-bottom;}
          input,textarea,select{font-size:inherit;font-weight:inherit;}
          legend{color:#555;}
          body{background:#ffffff;height:100%;outline:none;}
          p{color:#666;font-size:12px!important;}
          a{text-decoration:none;color:#0071c5;outline:none;}
          a:hover{text-decoration: none;color: #00aeef !important;outline:none;}
          .bold{font-weight: bold;}
          .nsgacontent{font-size:14x;color:#555;padding:5px;}
          .nsgatable{border: 1px solid #CBD9E6;font-size:14x;color:#555555;border-collapse:collapse;}
          .nsgaheading{color: #555555;font-size: 24px;font-weight: bold;line-height: 24px;padding-top:10px;margin-top:10px;}
          .nsgacolumnrow{border-radius: 0 0 0 0;height: 32px;padding-bottom: 0;padding-top: 0;background-color: #D4E7F5;background-image: none;text-decoration: none;text-overflow: ellipsis;font-weight: normal;overflow: hidden;white-space: nowrap;border: 1px solid #CBD9E6;}
          .nsgacolumn{font-weight:normal;border: 1px solid #CBD9E6;padding:5px;text-align:left;}
          .nsgarow{background-color:#fff;}
          .nsgacell{border: 1px solid #CBD9E6;padding:5px;}
          .nsgaaltrow{background-color: #F3F3F3;}
          .nsgalink {text-decoration:none;color:#0071c5;outline:none;}
          .nsgalink :hover{text-decoration: none;color: #00aeef;outline:none;}
          .nsgalink :visited{text-decoration:none;color:#0071c5;outline:none;}
          .foottext{color: #555555;font-size: 12px;text-align: center;}
          .blueline {border-top: 1px solid #CBD9E6;width: 100%;}
        </style>
      </head>
      <body>
        <table style='width:720px' class='nsgatable'>
          <tr>
            <td>
              <!-- Header { -->
              <table style='width:100%;background-color: #0071c5;' bgcolor='background-color: #0071c5;'>
                <tr style='background-color: #0071c5;height:65px;padding:4px;'>
                  <td  style='text-align:left;background-color: #0071c5 !important;'>
                    <a style='padding:2px;margin:4px;' href='link here' target='_blank' title='Click to visit the intel web site'>
                      <img src='link here' alt='visit intel web site' border='0' />
                    </a>
                  </td>
                  <td  style='text-align:left;background-color: #0071c5;'>
                    <!--<span class='nsgaheading' style='color:#ffffff;'>
                      <a href='link here' title='Click here to access the online services'>
                        <img src='link here' alt='' border='0' />
                      </a>
                    </span>-->
                  </td>
                  <td  style='text-align:right;background-color: #0071c5;'>
                    <a id='lnkIfsLogo' href='link here' title='Click here to access the home page'>
                      <img src='link here' alt='' border='0' />
                    </a>
                  </td>
                  <td style='text-align:right;background-color: #0071c5;'>
                    <!--<img src='link here' alt='' border='0' />-->
                  </td>
                </tr>
              </table>
              <!--  } Header -->
              <table>
                <tr>
                  <td class='nsgacontent'>
                    <div><br/>
                      <span class='nsgaheading'>
                        <xsl:value-of select='/ROOT/MAIL/HEADING/text()'/>                        
                      </span>
                      <span class='nsgacontent'>                      
                      <p style='text-align:justify'>
                        Hello <xsl:value-of  disable-output-escaping='yes' select='/ROOT/MAIL/RECIPIENT/text()'/>
                        <br/><xsl:value-of  disable-output-escaping='yes' select='/ROOT/MAIL/MESSAGE/text()'/></p>
                      </span> 
                      <p>
                        <span>                        
                          <b>Thank you</b>
                        </span>
                      </p>                    
                      <p style='text-align:justify'>
                        <b>Technical support:</b>
                        <br/>
                        <span>
                          For assistance, submit a ticket using the Issue Management System available at online services portal.</span><br/>
                          <span>
                            Please do not reply to this email message as this email address is used for outbound messages only.
                          </span>
                      </p>                      
                    </div>
                  </td>
                </tr>
                <tr><td style='text-align:center;'>
                      <p style='margin-top:8px;'>
                        <span class='bold'>Intel Confidential</span><br/>
                        <span  class='foottext'>© 2018 company name here. All rights reserved.</span><br/>
                        <span  class='foottext'><a class='nsgalink' href='link here'>*Legal Information</a> | <a class='nsgalink' href='link here'>Privacy Policy</a></span><br/>
                        <span class='foottext'>*Other names and brands may be claimed as the property of others.</span><br/>
                        <span class='foottext'>**Intel is not responsible for content of sites outside our intranet</span><br/>
                      </p>
                </td></tr>
              </table>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>";

        // Test the ability to transform xml data to html
        [TestMethod]
        public void MailTests_VerifyTransform_Test1()
        {
            ITemplate template = new Template();
            template.TemplateText = EMAIL_TEMPLATE;
            Transformer transformer = new Transformer();
            string body = transformer.Transform(template.TemplateText, EMAIL_DATA);
            Assert.IsFalse(String.IsNullOrEmpty(body), "Failed to transform!");
        }

        // Test the ability to transform xml data to html and send email
        [TestMethod]
        public void MailTests_VerifyTransformAndSend_Test1()
        {
            ITemplate template = new Template();
            template.TemplateText = EMAIL_TEMPLATE;
            Transformer transformer = new Transformer();
            string body = transformer.Transform(template.TemplateText, EMAIL_DATA);
            bool status = new MailBuilder("jose.kurian@domain.com", "jose.kurian@domain.com")
                .UsingTemplateText(template.TemplateText)
                .UsingSmtpServer("ch-out.domain.com")
                .Subject("Test Mail")
                .Body(body)
                .Send();
            Assert.IsTrue(status, "Failed to send email!");
        }

        // Test the ability to transform xml data to html and send email
        [TestMethod]
        public void MailTests_VerifyTransformAndSendWithCc_Test1()
        {
            ITemplate template = new Template();
            template.TemplateText = EMAIL_TEMPLATE;
            Transformer transformer = new Transformer();
            string body = transformer.Transform(template.TemplateText, EMAIL_DATA);
            var status = new MailBuilder("jose.kurian@domain.com", new string[] { "jose.kurian@domain.com", "jose.kurian@domain.com" })
                .UsingTemplateText(template.TemplateText)
                .UsingSmtpServer("smtp.domain.com")
                .Subject("Test Mail from Unit Test. Ignore this mail, please.")
                .Body(body)
                .Cc(new string[] { "jose.kurian@domain.com", "jose.kurian@domain.com", "jose.kurian@domain.com" })
                .ReplyTo("jose.kurian@domain.com")
                .Send();
            Assert.IsTrue(status, "Failed to send email!");
        }

        [TestMethod]
        public void MailTests_ActionTemplate()
        {
            // This requires Templates\Emails\Body.xsl and Templates\Emails\SubmitTemplate.xml to have their
            // Properties / Copy to Output Directory set to Copy always

            string templateName = "ReviewAction.xml";
            string templatePath = @"Templates\Emails\{0}";
            string templateFile = string.Format(templatePath, templateName);
            string templateData = System.IO.File.ReadAllText(templateFile);
            string baseURL = "website link here";
            string detailsView = "MMRecipe/Details/";
            string id = "1";
            string detailsURL = string.Format("{0}{1}{2}", baseURL, detailsView, id);
            string stageName = "Stage 1";
            string reviewerFirstName = "Jake";
            string reviewItem = "MM Recipe version";

            string filledinTemplateData = string.Format(templateData, baseURL, detailsURL, stageName, reviewerFirstName, reviewItem);

            ITemplate template = new Template();
            template.TemplateText = System.IO.File.ReadAllText(@"Templates\Emails\MOAutomation.xsl");
            Transformer transformer = new Transformer();

            string fromEmail = "jakex.murphy.douglas@domain.com"; // this could be a system email account
            string toEmail = "jakex.murphy.douglas@domain.com"; // this could be an array of emails e.g. new string[] { "jose.kurian@domain.com", "jose.kurian@domain.com" })
            string smtpServer = "smtp.domain.com";
            string reviewSubject = "MM Recipe";
            string emailSubject = "[Action Required] Review {0}"; // this comes from the EmailTemplates[Subject] db table
            string subjectLine = string.Format(emailSubject, reviewSubject);

            string body = transformer.Transform(template.TemplateText, filledinTemplateData);

            //Change email address to come from web.config 
            bool status = new MailBuilder(fromEmail, toEmail)
                .UsingTemplateText(template.TemplateText)
                .UsingSmtpServer(smtpServer)
                .Subject(subjectLine)
                .Body(body)
                .Send();
        }

        [TestMethod]
        public void MailTests_ApproveTemplate()
        {
            // This requires Templates\Emails\MOAutomation.xsl and Templates\Emails\SubmitTemplate.xml to have their
            // Properties / Copy to Output Directory set to Copy always

            string templateName = "ReviewApprove.xml";
            string templatePath = @"Templates\Emails\{0}";
            string templateFile = string.Format(templatePath, templateName);
            string templateData = System.IO.File.ReadAllText(templateFile);
            string baseURL = "link here";
            string detailsView = "MMRecipe/Details/";
            string id = "1";
            string detailsURL = string.Format("{0}{1}{2}", baseURL, detailsView, id);
            string stageName = "Stage 1";
            string reviewerFirstName = "Jake";
            string reviewItem = "MM Recipe version";

            string filledinTemplateData = string.Format(templateData, baseURL, detailsURL, stageName, reviewerFirstName, reviewItem);

            ITemplate template = new Template();
            template.TemplateText = System.IO.File.ReadAllText(@"Templates\Emails\MOAutomation.xsl");
            Transformer transformer = new Transformer();

            string fromEmail = "jakex.murphy.douglas@domain.com"; // this could be a system email account
            string toEmail = "jakex.murphy.douglas@domain.com"; // this could be an array of emails e.g. new string[] { "jose.kurian@domain.com", "jose.kurian@domain.com" })
            string smtpServer = "smtp.domain.com";
            string reviewSubject = "MM Recipe";
            string emailSubject = "Review {0} Approved"; // this comes from the EmailTemplates[Subject] db table
            string subjectLine = string.Format(emailSubject, reviewSubject);

            string body = transformer.Transform(template.TemplateText, filledinTemplateData);

            //Change email address to come from web.config 
            bool status = new MailBuilder(fromEmail, toEmail)
                .UsingTemplateText(template.TemplateText)
                .UsingSmtpServer(smtpServer)
                .Subject(subjectLine)
                .Body(body)
                .Send();
        }

        [TestMethod]
        public void MailTests_CancelTemplate()
        {
            // This requires Templates\Emails\MOAutomation.xsl and Templates\Emails\SubmitTemplate.xml to have their
            // Properties / Copy to Output Directory set to Copy always

            string templateName = "ReviewCancel.xml";
            string templatePath = @"Templates\Emails\{0}";
            string templateFile = string.Format(templatePath, templateName);
            string templateData = System.IO.File.ReadAllText(templateFile);
            string baseURL = "https://callistodev.domain.com/";
            string detailsView = "MMRecipe/Details/";
            string id = "1";
            string detailsURL = string.Format("{0}{1}{2}", baseURL, detailsView, id);
            string stageName = "Stage 1";
            string reviewerFirstName = "Jake";
            string reviewItem = "MM Recipe version";

            string filledinTemplateData = string.Format(templateData, baseURL, detailsURL, stageName, reviewerFirstName, reviewItem);

            ITemplate template = new Template();
            template.TemplateText = System.IO.File.ReadAllText(@"Templates\Emails\MOAutomation.xsl");
            Transformer transformer = new Transformer();

            string fromEmail = "jakex.murphy.douglas@domain.com"; // this could be a system email account
            string toEmail = "jakex.murphy.douglas@domain.com"; // this could be an array of emails e.g. new string[] { "jose.kurian@domain.com", "jose.kurian@domain.com" }) 
            string smtpServer = "smtp.domain.com";
            string reviewSubject = "MM Recipe";
            string emailSubject = "Review {0} Cancelled"; // this comes from the EmailTemplates[Subject] db table
            string subjectLine = string.Format(emailSubject, reviewSubject);

            string body = transformer.Transform(template.TemplateText, filledinTemplateData);

            //Change email address to come from web.config 
            bool status = new MailBuilder(fromEmail, toEmail)
                .UsingTemplateText(template.TemplateText)
                .UsingSmtpServer(smtpServer)
                .Subject(subjectLine)
                .Body(body)
                .Send();
        }

        [TestMethod]
        public void MailTests_PORGeneratedTemplate()
        {
            // This requires Templates\Emails\MOAutomation.xsl and Templates\Emails\SubmitTemplate.xml to have their
            // Properties / Copy to Output Directory set to Copy always

            string templateName = "ReviewPORGenerated.xml";
            string templatePath = @"Templates\Emails\{0}";
            string templateFile = string.Format(templatePath, templateName);
            string templateData = System.IO.File.ReadAllText(templateFile);
            string baseURL = "https://callistodev.domain.com/";
            string detailsView = "MMRecipe/Details/";
            string id = "1";
            string detailsURL = string.Format("{0}{1}{2}", baseURL, detailsView, id);
            string stageName = "Stage 1";
            string reviewerFirstName = "Jake";
            string reviewItem = "MM Recipe version";

            string filledinTemplateData = string.Format(templateData, baseURL, detailsURL, stageName, reviewerFirstName, reviewItem);

            ITemplate template = new Template();
            template.TemplateText = System.IO.File.ReadAllText(@"Templates\Emails\MOAutomation.xsl");
            Transformer transformer = new Transformer();

            string fromEmail = "jakex.murphy.douglas@domain.com"; // this could be a system email account
            string toEmail = "jakex.murphy.douglas@domain.com"; // this could be an array of emails e.g. new string[] { "jose.kurian@domain.com", "jose.kurian@domain.com" })
            string smtpServer = "smtp.domain.com";
            string reviewSubject = "MM Recipe";
            string emailSubject = "Review {0} POR Generated"; // this comes from the EmailTemplates[Subject] db table
            string subjectLine = string.Format(emailSubject, reviewSubject);

            string body = transformer.Transform(template.TemplateText, filledinTemplateData);

            //Change email address to come from web.config 
            bool status = new MailBuilder(fromEmail, toEmail)
                .UsingTemplateText(template.TemplateText)
                .UsingSmtpServer(smtpServer)
                .Subject(subjectLine)
                .Body(body)
                .Send();
        }

        [TestMethod]
        public void MailTests_RejectReviewerTemplate()
        {
            // This requires Templates\Emails\MOAutomation.xsl and Templates\Emails\SubmitTemplate.xml to have their
            // Properties / Copy to Output Directory set to Copy always 

            string templateName = "ReviewRejectReviewer.xml";
            string templatePath = @"Templates\Emails\{0}";
            string templateFile = string.Format(templatePath, templateName);
            string templateData = System.IO.File.ReadAllText(templateFile);
            string baseURL = "https://callistodev.domain.com/";
            string detailsView = "MMRecipe/Details/";
            string id = "1";
            string detailsURL = string.Format("{0}{1}{2}", baseURL, detailsView, id);
            string stageName = "Stage 1";
            string reviewerFirstName = "Jake";
            string reviewItem = "MM Recipe version";

            string filledinTemplateData = string.Format(templateData, baseURL, detailsURL, stageName, reviewerFirstName, reviewItem);

            ITemplate template = new Template();
            template.TemplateText = System.IO.File.ReadAllText(@"Templates\Emails\MOAutomation.xsl");
            Transformer transformer = new Transformer();

            string fromEmail = "jakex.murphy.douglas@domain.com"; // this could be a system email account
            string toEmail = "jakex.murphy.douglas@domain.com"; // this could be an array of emails e.g. new string[] { "jose.kurian@domain.com", "jose.kurian@domain.com" }) 
            string smtpServer = "smtp.domain.com";
            string reviewSubject = "MM Recipe";
            string emailSubject = "Review {0} Rejected";
            string subjectLine = string.Format(emailSubject, reviewSubject);

            string body = transformer.Transform(template.TemplateText, filledinTemplateData);

            //Change email address to come from web.config 
            bool status = new MailBuilder(fromEmail, toEmail)
                .UsingTemplateText(template.TemplateText)
                .UsingSmtpServer(smtpServer)
                .Subject(subjectLine)
                .Body(body)
                .Send();
        }

        [TestMethod]
        public void MailTests_RejectTemplate()
        {
            // This requires Templates\Emails\MOAutomation.xsl and Templates\Emails\SubmitTemplate.xml to have their
            // Properties / Copy to Output Directory set to Copy always

            string templateName = "ReviewReject.xml";
            string templatePath = @"Templates\Emails\{0}";
            string templateFile = string.Format(templatePath, templateName);
            string templateData = System.IO.File.ReadAllText(templateFile);
            string baseURL = "https://callistodev.domain.com/";
            string detailsView = "MMRecipe/Details/";
            string id = "1";
            string detailsURL = string.Format("{0}{1}{2}", baseURL, detailsView, id);
            string stageName = "Stage 1";
            string reviewerFirstName = "Jake";
            string reviewItem = "MM Recipe version";

            string filledinTemplateData = string.Format(templateData, baseURL, detailsURL, stageName, reviewerFirstName, reviewItem);

            ITemplate template = new Template();
            template.TemplateText = System.IO.File.ReadAllText(@"Templates\Emails\MOAutomation.xsl");
            Transformer transformer = new Transformer();

            string fromEmail = "jakex.murphy.douglas@domain.com"; // this could be a system email account
            string toEmail = "jakex.murphy.douglas@domain.com"; // this could be an array of emails e.g. new string[] { "jose.kurian@domain.com", "jose.kurian@domain.com" }) 
            string smtpServer = "smtp.domain.com";
            string reviewSubject = "MM Recipe";
            string emailSubject = "Review {0} Rejected";
            string subjectLine = string.Format(emailSubject, reviewSubject);

            string body = transformer.Transform(template.TemplateText, filledinTemplateData);

            //Change email address to come from web.config 
            bool status = new MailBuilder(fromEmail, toEmail)
                .UsingTemplateText(template.TemplateText)
                .UsingSmtpServer(smtpServer)
                .Subject(subjectLine)
                .Body(body)
                .Send();
        }

        [TestMethod]
        public void MailTests_SubmitTemplate()
        {
            // This requires Templates\Emails\MOAutomation.xsl and Templates\Emails\SubmitTemplate.xml to have their
            // Properties / Copy to Output Directory set to Copy always

            string templateName = "ReviewSubmit.xml";
            string templatePath = @"Templates\Emails\{0}";
            string templateFile = string.Format(templatePath, templateName);
            string templateData = System.IO.File.ReadAllText(templateFile);
            string baseURL = "https://callistodev.domain.com/";
            string detailsView = "MMRecipe/Details/";
            string id = "1";
            string detailsURL = string.Format("{0}{1}{2}", baseURL, detailsView, id);
            string stageName = "Stage 1";
            string submitterFirstName = "Jake";
            string reviewItem = "MM Recipe version";

            string filledinTemplateData = string.Format(templateData, baseURL, detailsURL, stageName, submitterFirstName, reviewItem);

            ITemplate template = new Template();
            template.TemplateText = System.IO.File.ReadAllText(@"Templates\Emails\MOAutomation.xsl");
            Transformer transformer = new Transformer();

            string fromEmail = "jakex.murphy.douglas@domain.com"; // this could be a system email account
            string toEmail = "jakex.murphy.douglas@domain.com"; // this could be an array of emails e.g. new string[] { "jose.kurian@domain.com", "jose.kurian@domain.com" })
            string smtpServer = "smtp.domain.com";
            string reviewSubject = "MM Recipe";
            string emailSubject = "Review {0} Submitted"; // this comes from the EmailTemplates[Subject] db table
            string subjectLine = string.Format(emailSubject, reviewSubject);

            string body = transformer.Transform(template.TemplateText, filledinTemplateData);

            //Change email address to come from web.config 
            bool status = new MailBuilder(fromEmail, toEmail)
                .UsingTemplateText(template.TemplateText)
                .UsingSmtpServer(smtpServer)
                .Subject(subjectLine)
                .Body(body)
                .Send();
        }

    }
}
