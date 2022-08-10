namespace Intel.NsgAuto.Callisto.Business.Entities.App
{
    public interface IProcessRole
    {
        /// <summary>
        /// Gets\Sets the processes
        /// </summary>
        Process Process { get; set; }
        /// <summary>
        /// Gets\Sets the role names
        /// </summary>
        string RoleName { get; set; }
    }
}