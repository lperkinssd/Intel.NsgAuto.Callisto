using Intel.NsgAuto.Shared.Extensions;
using System.IO;

namespace Intel.NsgAuto.Callisto.Business.Core
{
    public class Functions
    {
        /// <summary>
        /// Gets file extension from the file name passed in without the period (.)
        /// file name can be in the format of filename.txt or somefile.xlsx etc...
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static string GetFileExtension(string fileName)
        {
            string extension = string.Empty;
            if (fileName.IsNeitherNullNorEmpty())
            {
                extension = Path.GetExtension(fileName).Substring(1);
            }
            return extension;
        }
    }
}
