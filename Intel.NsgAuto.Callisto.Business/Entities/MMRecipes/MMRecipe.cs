using Intel.NsgAuto.Callisto.Business.Entities.ProductLabels;
using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes
{
    public class MMRecipe : IMMRecipe
    {
        public long Id { get; set; }
        public int Version { get; set; }
        public bool IsPOR { get; set; }
        public bool IsActive { get; set; }
        public Status Status { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }

        // Product Details
        public string PCode { get; set; }
        public string ProductName { get; set; }
        public ProductFamily ProductFamily { get; set; }
        public int? MOQ { get; set; }
        public string ProductionProductCode { get; set; }
        public string SCode { get; set; }
        public FormFactor FormFactor { get; set; }
        public Customer Customer { get; set; }
        public DateTime? PRQDate { get; set; }
        public CustomerQualStatus CustomerQualStatus { get; set; }
        public string SCodeProductCode { get; set; }
        public string ModelString { get; set; }
        public PLCStage PLCStage { get; set; }

        public MMRecipeNandMediaItems NandMediaItems { get; set; }
        public MMRecipeAssociatedItems OtherAssociatedItems { get; set; }

        public ProductLabel ProductLabel { get; set; }

        /*
        // Testing Component
        public string TTVersion { get; set; }
        public string FWVersion { get; set; }
        public string SCodeTestingSA { get; set; }
        public string EFAIToolVersion { get; set; }
        public string BaseBoardBootLoader { get; set; }
        public string MICVersion { get; set; }
        public string PCodeTestingSA { get; set; }

        // BOM Components
        public string MemoryBoardBootLoader { get; set; }
        public string BaseBoardPIC { get; set; }
        public string BaseBoardEEPROM { get; set; }
        public string MemoryBoardASICRev { get; set; }
        public string BaseBoardPCB { get; set; }
        public string BaseBoardASICRev { get; set; }
        public string MemoryBoardPCB { get; set; }
        */
    }
}
