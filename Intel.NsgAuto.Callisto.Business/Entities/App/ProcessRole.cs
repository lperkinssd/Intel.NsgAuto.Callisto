namespace Intel.NsgAuto.Callisto.Business.Entities.App
{
    public class ProcessRole : IProcessRole
    {
        /// <summary>
        /// Gets\Sets the processes
        /// </summary>
        public Process Process { get; set; }
        /// <summary>
        /// Gets\Sets the role names for the process to have PSS
        /// </summary>
        public string RoleName { get; set; }
    }
}