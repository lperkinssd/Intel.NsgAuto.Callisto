using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.MMRecipes
{
    public interface IMMRecipe
    {
        long Id { get; set; }
        int Version { get; set; }
        bool IsActive { get; set; }
        Status Status { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        // Product Details
        string PCode { get; set; }
        string ProductName { get; set; }
        ProductFamily ProductFamily { get; set; }
        int? MOQ { get; set; }
        string ProductionProductCode { get; set; }
        string SCode { get; set; }
        FormFactor FormFactor { get; set; }
        Customer Customer { get; set; }
        DateTime? PRQDate { get; set; }
        CustomerQualStatus CustomerQualStatus { get; set; }
        string SCodeProductCode { get; set; }
        string ModelString { get; set; }
        PLCStage PLCStage { get; set; }

        /*
        // NAND/Media Details
        string NANDMediaIPN { get; set; }
        string ProductGrade { get; set; }
        string ProbeRevision { get; set; }
        string DesignStepping { get; set; }
        string MPPR { get; set; }
        string CellRevision { get; set; }

        // Product Label List
        string PBANumber { get; set; }
        string AANumber { get; set; }
        string SANumber { get; set; }
        string TANumber { get; set; }
        string Opal { get; set; }
        string ProgramName { get; set; }
        string CustomerSpecificStrings { get; set; }
        string KCCIdNumber { get; set; }
        string DensityCapacity { get; set; }
        string VoltageCurrent { get; set; }
        string UPC { get; set; }
        string CanadianString { get; set; }
        string PPProductIdentifier { get; set; }
        string InterfaceSpeed { get; set; }

        // Testing Component
        string TTVersion { get; set; }
        string FWVersion { get; set; }
        string SCodeTestingSA { get; set; }
        string EFAIToolVersion { get; set; }
        string BaseBoardBootLoader { get; set; }
        string MICVersion { get; set; }
        string PCodeTestingSA { get; set; }

        // BOM Components
        string MemoryBoardBootLoader { get; set; }
        string BaseBoardPIC { get; set; }
        string BaseBoardEEPROM { get; set; }
        string MemoryBoardASICRev { get; set; }
        string BaseBoardPCB { get; set; }
        string BaseBoardASICRev { get; set; }
        string MemoryBoardPCB { get; set; }
        */
    }
}
