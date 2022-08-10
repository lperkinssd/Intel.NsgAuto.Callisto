using Intel.NsgAuto.Callisto.Business.DataContexts;
using Intel.NsgAuto.Callisto.Business.Entities;

namespace Intel.NsgAuto.Callisto.Business.Services
{
    public class TasksService
    {
        public void Abort(long id)
        {
            new TasksDataContext().Abort(id);
        }

        public Task CreateByName(string taskTypeName)
        {
            return new TasksDataContext().CreateByName(taskTypeName);
        }

        public void CreateMessage(long id, string type, string text)
        {
            new TasksDataContext().CreateMessage(id, type, text);
        }

        public void End(long id)
        {
            new TasksDataContext().End(id);
        }

        public Task Get(string userId, long id)
        {
            return new TasksDataContext().Get(userId, id);
        }

        public Tasks GetAllOpen(string userId)
        {
            return new TasksDataContext().GetAllOpen(userId);
        }

        public Tasks GetAllRecent(string userId, int days)
        {
            return new TasksDataContext().GetAllRecent(userId, days);
        }

        public TaskMessages GetMessages(string userId, long taskId)
        {
            return new TasksDataContext().GetMessages(userId, taskId);
        }

        public Task Resolve(string userId, long id, string resolvedBy)
        {
            return new TasksDataContext().Resolve(userId, id, resolvedBy);
        }

        public Task ResolveAllAborted(string userId, long taskId, string resolvedBy)
        {
            return new TasksDataContext().ResolveAllAborted(userId, taskId, resolvedBy);
        }

        public void UpdateProgress(long id, int progressPercent, string progressText = null)
        {
            new TasksDataContext().UpdateProgress(id, progressPercent, progressText);
        }

        public Task Unresolve(string userId, long id)
        {
            return new TasksDataContext().Unresolve(userId, id);
        }
    }
}
