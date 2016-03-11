
--with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;

with Gnoga.Gui.Base;
with Usna_App_Data_Pkg;
package Usna_Rooms_Gnoga_Pkg is

   procedure Build_Rooms_View
     (App : in out Usna_App_Data_Pkg.App_Access);

 procedure Update_Rooms_View
     (App : in out Usna_App_Data_Pkg.App_Access);


end Usna_Rooms_Gnoga_Pkg;
