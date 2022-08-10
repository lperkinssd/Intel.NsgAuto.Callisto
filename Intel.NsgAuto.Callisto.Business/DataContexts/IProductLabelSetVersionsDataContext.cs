using Intel.NsgAuto.Callisto.Business.Entities.ProductLabels;

namespace Intel.NsgAuto.Callisto.Business.DataContexts
{
    public interface IProductLabelSetVersionsDataContext
    {
        ProductLabelSetVersionImportResult Import(string userId, ProductLabelsImport entities);
    }
}
