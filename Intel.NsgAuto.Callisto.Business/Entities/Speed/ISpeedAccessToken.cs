using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Speed
{
    public interface ISpeedAccessToken
    {
        int Id { get; set; }
        string AccessToken { get; set; }
        string TokenType { get; set; }
        DateTime ExpiresOn { get; set; }
        string CreatedBy { get; set; }
        DateTime CreatedOn { get; set; }
        string UpdatedBy { get; set; }
        DateTime UpdatedOn { get; set; }
    }
}
