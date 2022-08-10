using System;
using Intel.NsgAuto.Callisto.Business.Entities.MATs;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public interface IMATVersionsDataContext
    {
        MATVersionImportResponse Import(string userId, MATsImport entities);
    }
}
