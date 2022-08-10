using Intel.NsgAuto.Callisto.Business.Core;
using Intel.NsgAuto.Callisto.Business.Entities.App;
using Intel.NsgAuto.Callisto.Business.Services;
using Intel.NsgAuto.Shared.DirectoryServices;
using Intel.NsgAuto.Shared.Extensions;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Hosting;

namespace Intel.NsgAuto.Web.Mvc.Core
{
    public static class Functions
    {
        /// <summary>
        /// Gets only the idsid of the current logged in user with out the domain part
        /// </summary>
        /// <returns></returns>
        public static string GetLoggedInUserId()
        {
            string host = HttpContext.Current.Request.Url.Host;
            string userId = (host.IsNeitherNullNorEmpty() && host.Equals("localhost")) ?
                System.Security.Principal.WindowsIdentity.GetCurrent().Name :
                Intel.NsgAuto.Shared.Functions.GetCurrentUserIdSid(HttpContext.Current);
            if (userId.Contains("\\"))
            {
                userId = userId.Split("\\".ToCharArray())[1];
            }
            return userId;
        }
        /// <summary>
        /// Gets the idsid of the current logged in user from the session
        /// </summary>
        /// <returns></returns>
        public static string GetCurrentUserIdSid()
        {
            string userIdSid = String.Empty;
            User currentUser = GetCurrentUser();
            if (currentUser.IsNotNull())
            {
                userIdSid = currentUser.Attributes.Idsid;
            }
            return userIdSid;
        }

        public static bool IsOptaneUser()
        {
           // string Role = String.Empty;
            User currentUser = GetCurrentUser();
            AdministrationService adminService = new AdministrationService();
            string host = HttpContext.Current.Request.Url.Host;
            string userId = (host.IsNeitherNullNorEmpty() && host.Equals("localhost")) ?
                System.Security.Principal.WindowsIdentity.GetCurrent().Name :
                // else from http context and AD
                Intel.NsgAuto.Shared.Functions.GetCurrentUserIdSid(HttpContext.Current);

            if (userId.IsNullOrEmpty())
            {
                // throw error
                throw new UnauthorizedAccessException("User information is not available.");
            }
            else
            {
                User user = new User();
                if (userId.Contains("\\"))
                {
                    userId = userId.Split("\\".ToCharArray())[1];
                }
                string preferredRole = adminService.GetPreferredRole(userId);
                if (preferredRole.Contains("Callisto_Optane_User"))
                    return true;
                else 
                    return false;
            }
                
        }
        /// <summary>
        /// Gets the name of the current logged in user
        /// </summary>
        /// <returns></returns>
        public static string GetCurrentUserName()
        {
            string userName = String.Empty;
            User currentUser = GetCurrentUser();
            if (currentUser.IsNotNull())
            {
                //userName = currentUser.Attributes.Name;
            }
            return userName;
        }
        public static string GetCurrentUserEmail()
        {
            string email = String.Empty;
            User currentUser = GetCurrentUser();
            if (currentUser.IsNotNull())
            {
                email = currentUser.Attributes.Email;
            }
            return email;
        }
        /// <summary>
        /// Gets the current logged in user information from the sesssion
        /// </summary>
        /// <returns></returns>
        public static User GetCurrentUser()
        {
            // Get the user from the session
            User user = (User)System.Web.HttpContext.Current.Session[Constants.KEY_SESSION_USER];
            // if user is null, then try again
            if (user.IsNull())
            {
                // try to initilize again
                InitializeSession();
                user = (User)System.Web.HttpContext.Current.Session[Constants.KEY_SESSION_USER];
                // if user is still not available, throw error
                if (user.IsNull() && user.Attributes.IsNull())
                {
                    throw new UnauthorizedAccessException("User information is not available.");
                }
            }
            return user;
        }
        /// <summary>
        /// Performs the application initialization functions
        /// </summary>
        public static void InitializeApplication()
        {

        }
        /// <summary>
        /// Performs the session initialization functions
        /// </summary>
        public static void InitializeSession()
        {
            // Get the user details            
            // if debugging from localhost
            string host = HttpContext.Current.Request.Url.Host;
            string userId = (host.IsNeitherNullNorEmpty() && host.Equals("localhost")) ?
                System.Security.Principal.WindowsIdentity.GetCurrent().Name :
                // else from http context and AD
                Intel.NsgAuto.Shared.Functions.GetCurrentUserIdSid(HttpContext.Current);

            if (userId.IsNullOrEmpty())
            {
                // throw error
                throw new UnauthorizedAccessException("User information is not available.");
            }
            else
            {
                User user = new User();
                if (userId.Contains("\\"))
                {
                    userId = userId.Split("\\".ToCharArray())[1];
                }
                //user.Attributes = new EmployeeDataProvider().GetUser(userId);
                // Get the application roles from web configuration
                string csvAppRoles = ConfigurationManager.AppSettings[Constants.CONFIG_KEY_ROLES].ToStringSafely();
                if (csvAppRoles.IsNullOrEmpty())
                {
                    new ConfigurationErrorsException("Application roles have not been configured. Define app setting in configuration as comma separated strings.");
                }
                //List<string> directoryRoles = user.Attributes.Roles;
                List<string> appRoles = csvAppRoles.Split(",".ToCharArray()).ToList<string>();
                List<string> userAppRoles = new List<string>();
                // Find out user roles in AD
                //foreach (string appRole in appRoles)
                //{
                //    if (directoryRoles.Contains(appRole))
                //    {
                //        userAppRoles.Add(appRole);
                //    }
                //}

                //SetInitPreferredRole(userId, directoryRoles);

                // Check if user has access to the application.
                // user should have any of the configured roles in AD
                //if (userAppRoles.Count == 0)
                //{
                //    //throw new UnauthorizedAccessException("You are unauthorized use this system. Request access before proceeding.");
                //    throw new HttpException((int)HttpStatusCode.Forbidden, "You are unauthorized use this system. Request access before proceeding.");
                //}
                // Replace the user roles in the user object with user-application roles
                //user.Attributes.Roles = userAppRoles;

                // Get the PSS roles from web configuration
                string csvProcessRoles = ConfigurationManager.AppSettings[Constants.CONFIG_KEY_PROCESSROLES].ToStringSafely();
                if (csvAppRoles.IsNullOrEmpty())
                {
                    new ConfigurationErrorsException("Product security roles have not been configured. Define app setting in configuration as comma separated strings.");
                }
                List<string> appProcessRoles = csvProcessRoles.Split(",".ToCharArray()).ToList<string>();
                List<string> userProcessRoles = new List<string>();
                user.ProcessRoles = new ProcessRoles();
                // Find out user roles in AD
                //foreach (string pssRole in appProcessRoles)
                //{
                //    if (directoryRoles.Contains(pssRole))
                //    {
                //        user.ProcessRoles.Add(new ProcessRole()
                //        {
                //            RoleName = pssRole
                //        });
                //    }
                //}

                // Send to database and merge-sync roles & throw the user instane into session
                System.Web.HttpContext.Current.Session[Constants.KEY_SESSION_USER] = new FrameworkService().InitializeSession(HttpContext.Current.Session.SessionID, user);
            }
        }

        public static void SetInitPreferredRole(string userId, List<string> directoryRoles)
        {
            AdministrationService adminService = new AdministrationService();

            if (directoryRoles.Contains(Settings.SuperUserRole))
            {
                string preferredRole = adminService.GetPreferredRole(userId);
                if (String.IsNullOrEmpty(preferredRole))
                {
                    adminService.SavePreferredRole(userId, Settings.CallistoNandUserRole);
                }
            }
            else if (directoryRoles.Contains(Settings.CallistoNandUserRole))
            {
                adminService.SavePreferredRole(userId, Settings.CallistoNandUserRole);                
            }
            else if (directoryRoles.Contains(Settings.CallistoOptaneUserRole))
            {
                adminService.SavePreferredRole(userId, Settings.CallistoOptaneUserRole);
            }
            else
            {
                throw new HttpException((int)HttpStatusCode.Forbidden, "You are unauthorized to use this system. Request access before proceeding.");
            }
        }

        /// <summary>
        /// Returns true if the current user if a super user, if not false.
        /// </summary>
        /// <returns></returns>
        public static bool IsAutoCheckerCriteriaAuthor()
        {
            bool result = false;
            User currentUser = GetCurrentUser();
            if (currentUser.IsNotNull())
            {
                if (isSpecifiedUser(currentUser, Settings.CallistoOptaneUserRole))
                {
                    result = currentUser.Attributes.Roles.Contains(Settings.AutoCheckerCriteriaAuthorUserRole);
                }
                else if (isSpecifiedUser(currentUser, Settings.CallistoNandUserRole))
                {
                    result = currentUser.Attributes.Roles.Contains(Settings.AutoCheckerCriteriaAuthorNpsgUserRole);
                }
            }
            return result;
        }

        /// <summary>
        /// Returns true if the current user if an odm mat author, false otherwise.
        /// </summary>
        public static bool IsOdmMatAuthor()
        {
            bool result = false;
            User currentUser = GetCurrentUser();
            if (currentUser.IsNotNull())
            {
                if (isSpecifiedUser(currentUser, Settings.CallistoOptaneUserRole))
                {
                    result = currentUser.Attributes.Roles.Contains(Settings.OdmMatAuthorUserRole);
                }
                else if (isSpecifiedUser(currentUser, Settings.CallistoNandUserRole))
                {
                    result = currentUser.Attributes.Roles.Contains(Settings.OdmMatAuthorNpsgUserRole);
                }
            }
            return result;
        }

        /// <summary>
        /// Returns true if the current user if an odm prf author, false otherwise.
        /// </summary>
        public static bool IsOdmPrfAuthor()
        {
            bool result = false;
            User currentUser = GetCurrentUser();
            if (currentUser.IsNotNull())
            {
                if (isSpecifiedUser(currentUser, Settings.CallistoOptaneUserRole))
                {
                    result = currentUser.Attributes.Roles.Contains(Settings.OdmPrfAuthorUserRole);
                }
                else if (isSpecifiedUser(currentUser, Settings.CallistoNandUserRole))
                {
                    result = currentUser.Attributes.Roles.Contains(Settings.OdmPrfAuthorNpsgUserRole);
                }
            }
            return result;
        }

        /// <summary>
        /// Returns true if the current user if an odm mat author, false otherwise.
        /// </summary>
        public static bool IsOdmQualFilterAuthor()
        {
            bool result = false;
            User currentUser = GetCurrentUser();
            if (currentUser.IsNotNull())
            {
                if (isSpecifiedUser(currentUser, Settings.CallistoOptaneUserRole))
                {
                    result = currentUser.Attributes.Roles.Contains(Settings.OdmQualFilterAuthorUserRole);
                }
                else if (isSpecifiedUser(currentUser, Settings.CallistoNandUserRole))
                {
                    result = currentUser.Attributes.Roles.Contains(Settings.OdmQualFilterAuthorNpsgUserRole);
                }
            }
            return result;
        }

        /// <summary>
        /// Returns true if the current user if an osat criteria author, false otherwise.
        /// </summary>
        public static bool IsOsatCriteriaAuthor()
        {
            bool result = false;
            User currentUser = GetCurrentUser();
            if (currentUser.IsNotNull())
            {
                if (isSpecifiedUser(currentUser, Settings.CallistoOptaneUserRole))
                {
                    result = currentUser.Attributes.Roles.Contains(Settings.OsatCriteriaAuthorUserRole);
                }
                else if (isSpecifiedUser(currentUser, Settings.CallistoNandUserRole))
                {
                    result = currentUser.Attributes.Roles.Contains(Settings.OsatCriteriaAuthorNpsgUserRole);
                }
            }
            return result;
        }

        /// <summary>
        /// Returns true if the current user if an osat pas author, false otherwise.
        /// </summary>
        public static bool IsOsatPasAuthor()
        {
            bool result = false;
            User currentUser = GetCurrentUser();
            if (currentUser.IsNotNull())
            {
                if (isSpecifiedUser(currentUser, Settings.CallistoOptaneUserRole))
                {
                    result = currentUser.Attributes.Roles.Contains(Settings.OsatPasAuthorUserRole);
                }
                else if (isSpecifiedUser(currentUser, Settings.CallistoNandUserRole))
                {
                    result = currentUser.Attributes.Roles.Contains(Settings.OsatPasAuthorNpsgUserRole);
                }                
            }
            return result;
        }

        /// <summary>
        /// Returns true if the current environment is production, false otherwise.
        /// </summary>
        public static bool IsProduction()
        {
            return Settings.EnvironmentName?.ToLowerInvariant() == "production";
        }

        /// <summary>
        /// Returns true if the current user if a super user, if not false.
        /// </summary>
        /// <returns></returns>
        public static bool IsSuperUser()
        {
            bool result = false;
            User currentUser = GetCurrentUser();
            if (currentUser.IsNotNull())
            {
                result = true; //currentUser.Attributes.Roles.Contains(Settings.SuperUserRole);
            }
            return result;
        }

        /// <summary>
        /// Centralized code to log exceptions
        /// </summary>
        /// <param name="exception">The exception that occurred.</param>
        public static void LogException(Exception exception)
        {
            try
            {
                var filepath = Settings.PathErrors;
                var directory = Path.GetDirectoryName(filepath);
                if (!string.IsNullOrEmpty(directory) && !Directory.Exists(directory)) Directory.CreateDirectory(directory);
                File.AppendAllLines(filepath, new string[] { exception.ToString() });
            }
            catch { }
        }

        private static bool isSpecifiedUser(User user, string roleName)
        {
            return user.ProcessRoles.Exists(r => r.RoleName == roleName);
        }
    }
}