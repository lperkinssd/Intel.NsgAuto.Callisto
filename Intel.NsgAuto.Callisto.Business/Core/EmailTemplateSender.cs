using Intel.NsgAuto.Callisto.Business.Core.Extensions;
using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Shared.Mail;
using System.Collections.Generic;
using System.Linq;

namespace Intel.NsgAuto.Callisto.Business.Core
{
    public class EmailTemplateSender
    {
        public EmailTemplateSender(IReadOnlyEmailTemplate template)
        {
            Template = template;
            From = Settings.SystemEmailAddress;
            Cc = new List<string>();
            Bcc = new List<string>();
        }

        // read only; set in constructor
        public IReadOnlyEmailTemplate Template { get; }

        // these can be customized for individual sends
        public string From { get; set; }

        public List<string> Bcc { get; private set; }

        public List<string> Cc { get; private set; }


        public bool Send(string to, params string[] parameters)
        {
            return Send(to.Yield(), parameters);
        }

        public bool Send(IEnumerable<string> to, params string[] parameters)
        {
            string subject = string.Format(Template.Subject, parameters);
            subject = subject.Replace("<br>", "");
            string body;
            if (!string.IsNullOrEmpty(Template.BodyXsl))
            {
                string bodyXml = string.Format(Template.BodyXml, parameters);
                body = new Transformer().Transform(Template.BodyXsl, bodyXml);
            }
            else
            {
                body = string.Format(Template.Body, parameters);
            }
            MailBuilder mailBuilder = new MailBuilder(From, to.ToArray()).Subject(subject).Body(body);
            if (Cc.Count > 0) mailBuilder.Cc(Cc.ToArray());
            if (Bcc.Count > 0) mailBuilder.Bcc(Bcc.ToArray());
            return mailBuilder.Send();
        }
    }
}
