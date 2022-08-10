using Intel.NsgAuto.Web.Mvc.Core;
using System.Web.Http.ExceptionHandling;

namespace Intel.NsgAuto.Callisto.UI.Core
{
    public class GlobalExceptionHandler : ExceptionHandler
    {
        public override void Handle(ExceptionHandlerContext context)
        {
            Functions.LogException(context.Exception);
        }
    }
}