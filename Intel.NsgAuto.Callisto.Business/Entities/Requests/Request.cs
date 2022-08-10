using System;
using Intel.NsgAuto.Shared.DirectoryServices;

namespace Intel.NsgAuto.Callisto.Business.Entities.Requests
{
    public class Request : IRequest
	{
        public int Id { get; set; }
        public ItemType ItemType { get; set; }
        public RequestRequestor RequestedBy { get; set; }
        public IdAndName Status { get; set; }
        public Reviews Reviews { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string CreatedOnStr { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
        public string UpdatedOnStr { get; set; }

        public void initialize()
        {
            Id = 0;
            ItemType = new ItemType() { Id = 0, TypeName = string.Empty, ItemTypeDisplay = string.Empty, IsActive = true };
            RequestedBy = new RequestRequestor() { Requestor = new Employee() };
            Status = new IdAndName(){ Id = 0, Name = string.Empty };
            CreatedBy = string.Empty;
            UpdatedBy = string.Empty;
        }
	}
}
