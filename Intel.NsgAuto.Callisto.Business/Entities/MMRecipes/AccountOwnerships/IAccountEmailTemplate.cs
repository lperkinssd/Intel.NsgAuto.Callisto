using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes.AccountOwnerships
{
    interface IAccountEmailTemplate
    {
         string BodyXsl { get;set;}
        string BodyXml { get; set; }
        bool Send(string to, string Subject, string BodyXsl, string Body, string BodyXml, string From, params string[] parameters);
        bool Send(IEnumerable<string> to, string Subject, string BodyXsl, string Body, string BodyXml, string From, params string[] parameters);
    }
}
