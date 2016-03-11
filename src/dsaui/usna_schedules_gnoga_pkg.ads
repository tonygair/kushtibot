
with Gnoga.Gui.Base;
with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;


package Usna_Schedules_Gnoga_Pkg is

   procedure On_Schedule_Name_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class);

   procedure On_Modify_Schedule_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class);

   procedure On_New_Schedule_Button_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class);

   procedure Build_Schedule_View
     (App : in out App_Access);

   procedure Update_Schedule_View
     (App : in out App_Access);

end Usna_Schedules_Gnoga_Pkg;
