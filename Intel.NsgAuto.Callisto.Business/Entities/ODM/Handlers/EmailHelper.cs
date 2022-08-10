using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
using System.Threading.Tasks;
using Intel.NsgAuto.Shared.Mail;
using Intel.NsgAuto.Shared.Extensions;
using Intel.NsgAuto.Callisto.Business.Core;

namespace Intel.NsgAuto.Callisto.Business.Entities.ODM.Handlers
{
    internal static class EmailHelper
    {
        private const string CONST_CRYPTO_KEY = "";
        private const string CONST_MAIL_USER = "username here ";
        private const string CONST_ENCRYPTED_PWD = "encrypted pw here";
        private const string EMAIL_DATA = @"<?xml-stylesheet type='text/xsl' href='ProductLabelActionTemplate.xsl'?>
        <ROOT>
          <MAIL>
            <RECIPIENT>{0}</RECIPIENT>
            <HEADING>Callisto System</HEADING>
            <MESSAGE>
            <![CDATA[                
                <p>You are receiving this email notification because you are an assigned recipient for information from intel callisto system.</p>
                <p>Non qualified media list are in file: <b><i>{1}</i></b>
                   Exceptions with in non qualified media list are in file : <b><i>{2}</i></b></p>                
            ]]>
          </MESSAGE>
          </MAIL>
        </ROOT>";

        private const string EMAIL_TEMPLATE = @"<?xml version='1.0'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>
  <xsl:output method='html'/>
  <xsl:template match='/'>
    <html>
      <head>
        <meta http-equiv='Content-Type' content='text/html; charset=utf-8'/>
        <meta name='viewport' content='width=device-width'/>
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
          .nsgacontent{font-size:14px;color:#555;padding:5px;}
          .nsgatable{border: 1px solid #CBD9E6;font-size:14px;color:#555555;border-collapse:collapse;}
          .intelmessage{color: #FFFFFF;font-size: 24px;font-weight: bold;line-height: 24px;padding-top:10px;margin-top:6px;}
          .nsgaheading{color: #555555;font-size: 24px;font-weight: bold;line-height: 24px;padding-top:10px;margin-top:6px;}
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
          .actionrequired {color:red;}
        </style>
      </head>
      <body>
        <table style='width:720px' class='nsgatable'>
          <tr>
            <td>
              <table style='width:100%;background-color: #0071c5;' bgcolor='background-color: #0071c5;'>
                <tr style='background-color: #0071c5;height:65px;padding:4px;'>
                  <td style='text-align:left;background-color: #0071c5 !important;'></td>
                  <td style='text-align:right;background-color: #0071c5;'>
                    <a style='padding:2px;margin:4px;' class='intelmessage' href='http://www.domain.com/' target='_blank' title='Click to visit the intel web site'>A Message From Intel</a>
                  </td>
                </tr>
              </table>
              <table>
                <tr>
                  <td class='nsgacontent'>
                    <div><br/>
                      <p><span class='nsgaheading'><xsl:value-of select='/ROOT/MAIL/HEADING/text()'/></span></p>
                      <p>Hello <xsl:value-of  disable-output-escaping='yes' select='/ROOT/MAIL/RECIPIENT/text()'/></p>
                      <xsl:value-of  disable-output-escaping='yes' select='/ROOT/MAIL/MESSAGE/text()'/>
                      <p><span><b>Thank you</b><br/><b>intel</b></span></p><br/>
                      <p style='text-align:justify'><b>Technical support:</b><br/>                       
                        <span>
                          Please do not reply to this email message as this email address is used for outbound messages only.
                        </span>
                      </p>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td style='text-align:center;'>
                    <p style='margin-top:8px;'><span class='bold'> Confidential</span><br/><span class='foottext'>© 2020 company name here. All rights reserved.</span><br/><span class='foottext'><a class='nsgalink' href='http://www.domain.com/content/www/us/en/legal/trademarks.html'>*Legal Information</a> | <a class='nsgalink' href='http://www.domain.com/content/www/us/en/privacy/intel-online-privacy-notice-summary.html'>Privacy Policy</a></span><br/><span class='foottext'>*Other names and brands may be claimed as the property of others.</span><br/><span class='foottext'>**Intel is not responsible for content of sites outside our intranet</span><br/></p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>";

        public static bool Send(List<FileInfo> attachments, string recipients, string process = "", string odmName = "")
        {
            bool result;
            try
            {
                SmtpClient smtpClient = new SmtpClient(Settings.SmtpServer);
                
                using (MailMessage mailMessage = new MailMessage())
                {
                    mailMessage.IsBodyHtml = true;
                    mailMessage.SubjectEncoding = Encoding.UTF8;
                    foreach (FileInfo fileInfo in attachments)
                    {
                        mailMessage.Attachments.Add(new Attachment(fileInfo.FullName.ToStringSafely(), MediaTypeNames.Application.Octet)
                        {
                            NameEncoding = Encoding.UTF8
                        }
                        );
                    }
                    // Create the Email body
                    ITemplate template = new Template();
                    template.TemplateText = EMAIL_TEMPLATE;
                    Transformer transformer = new Transformer();
                    string emailData = String.Format(EMAIL_DATA, "!", attachments[0].Name, attachments[1].Name);
                    mailMessage.Body = transformer.Transform(template.TemplateText, emailData);
                    mailMessage.Subject = string.Format(Settings.ODMMailSubject.ToStringSafely(), process, odmName, Settings.EnvironmentName.ToStringSafely());
                    //mailMessage.To.Add(Settings.ODMEmailList.ToStringSafely());
                    mailMessage.To.Add(recipients);
                    mailMessage.From = new MailAddress(Settings.SystemEmailAddress.ToStringSafely());
                    // Hard coding for the quick reponse to IT change from SMTP to SMTPAUTH
                    smtpClient.Host = Settings.SmtpServer.ToStringSafely(); //"smtpauth.domain.com";
                    smtpClient.Port = Settings.SmtpServerPort.ToIntegerSafely(); //smtpClient.Port = 587;
                    smtpClient.EnableSsl = true;
                    smtpClient.Credentials = new System.Net.NetworkCredential(CONST_MAIL_USER, CONST_ENCRYPTED_PWD.Decrypt(CONST_CRYPTO_KEY));
                    smtpClient.Send(mailMessage);
                }
                result = true;
            }
            catch (Exception)
            {
                result = false;
            }
            return result;
        }
    }
}
