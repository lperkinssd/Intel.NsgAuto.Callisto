namespace Intel.NsgAuto.Callisto.Business.Entities
{
    public class EntitySingleMessageResult<T> : SingleMessageResult
    {
        public T Entity { get; set; }
    }
}
