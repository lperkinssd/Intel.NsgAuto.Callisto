using System;

namespace Intel.NsgAuto.Callisto.Business.Entities.Speed
{
    public class SpeedAccessToken : ISpeedAccessToken
    {
        public int Id { get; set; }
        public string AccessToken { get; set; }
        public string TokenType { get; set; }
        public DateTime ExpiresOn { get; set; }
        public string CreatedBy { get; set; }
        public DateTime CreatedOn { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime UpdatedOn { get; set; }
    }
}
