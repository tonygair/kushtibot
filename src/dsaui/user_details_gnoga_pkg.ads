with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;
with Identity_Types_Pkg;
use Identity_Types_Pkg;

package User_Details_Gnoga_Pkg is

procedure Build_User_Details_View
	(App : in out App_Access);

procedure Update_User_Details_View
	(App : in out App_Access);

end User_Details_Gnoga_Pkg;
