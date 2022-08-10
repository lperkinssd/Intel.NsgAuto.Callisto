using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class EmailTemplatesService
    {
        public EmailTemplate Get(string templateName)
        {
            return new EmailTemplatesDataContext().Get(templateName);
        }

        public void Send(string templateName, string to, params string[] parameters)
        {
            EmailTemplate template = Get(templateName);
            EmailTemplateSender sender = new EmailTemplateSender(template);
            sender.Send(to, parameters);
        }
    }
}
