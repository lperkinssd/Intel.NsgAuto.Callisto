using Intel.NsgAuto.Callisto.Business.Entities;
using Intel.NsgAuto.Callisto.Business.Services;
using System;

namespace Intel.NsgAuto.Callisto.Business.Applications
{
    public abstract class TaskApplication
    {
        private const string MESSAGE_TYPE_ABORT = "Abort";
        private const string MESSAGE_TYPE_ERROR = "Error";
        private const string MESSAGE_TYPE_INFORMATION = "Information";
        private const string MESSAGE_TYPE_WARNING = "Warning";

        private Task task;
        private readonly TasksService service;

        public string By { get; private set; }

        public string TaskTypeName { get; }

        public IReadOnlyTask Task
        { 
            get
            {
                return task;
            }
        }

        public TaskApplication(string taskTypeName)
        {
            TaskTypeName = taskTypeName;
            service = new TasksService();
        }

        protected abstract void Content();

        public void Start()
        {
            var aborted = false;
            try
            {
                InitializeTask();
                Content();
            }
            catch (Exception exception)
            {
                aborted = true;
                if (task != null)
                {
                    Abort(exception.ToString());
                }
            }
            if (!aborted)
            {
                if (task != null)
                {
                    End();
                }
            }
        }

        private void InitializeTask()
        {
            task = service.CreateByName(TaskTypeName);
            if (task == null) throw new Exception(string.Format("Task could not be created for task type = {0}", TaskTypeName));
            By = string.Format("TASK_{0}", task.Id);
        }

        private void End()
        {
            service.End(task.Id);
        }

        protected void Abort(string message = null)
        {
            service.Abort(task.Id);
            if (!string.IsNullOrEmpty(message))
            {
                try
                {
                    CreateAbortMessage(message);
                }
                catch { }
            }
        }

        protected void CreateMessage(string type, string text)
        {
            service.CreateMessage(task.Id, type, text);
        }

        protected void CreateAbortMessage(string text)
        {
            CreateMessage(MESSAGE_TYPE_ABORT, text);
        }

        protected void CreateErrorMessage(string text)
        {
            CreateMessage(MESSAGE_TYPE_ERROR, text);
        }

        protected void CreateInformationalMessage(string text)
        {
            CreateMessage(MESSAGE_TYPE_INFORMATION, text);
        }

        protected void CreateWarningMessage(string text)
        {
            CreateMessage(MESSAGE_TYPE_WARNING, text);
        }

        protected void UpdateProgress(int progressPercent, string progressText = null)
        {
            service.UpdateProgress(task.Id, progressPercent, progressText);
        }
    }
}
