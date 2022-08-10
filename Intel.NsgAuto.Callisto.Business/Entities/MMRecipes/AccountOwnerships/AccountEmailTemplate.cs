using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Shared.Mail;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships
{
    public class AccountEmailTemplate : IAccountEmailTemplate
    {
        public string BodyXsl { get; set; }
        public string BodyXml { get; set; }

        public bool Send(string to, string Subject, string BodyXsl, string Body, string BodyXml, string From, params string[] parameters)
        {
            return Send(to.Yield(),  Subject,  BodyXsl,  Body,  BodyXml,  From ,parameters);
        }

        public bool Send(IEnumerable<string> to, string Subject, string BodyXsl, string Body,string BodyXml,  string From,  params string[] parameters)
        {
            string subject = string.Format(Subject, parameters);
            string body;
            if (!string.IsNullOrEmpty(BodyXsl))
            {
                string bodyXml = string.Format(BodyXml, parameters);
                body = new Transformer().Transform(BodyXsl, bodyXml);
            }
            else
            {
                body = string.Format(Body, parameters);
            }
            MailBuilder mailBuilder = new MailBuilder(From, to.ToArray()).Subject(subject).Body(body);
            //if (Cc.Count > 0) mailBuilder.Cc(Cc.ToArray());
            //if (Bcc.Count > 0) mailBuilder.Bcc(Bcc.ToArray());
            return mailBuilder.Send();
        }
    }
}
