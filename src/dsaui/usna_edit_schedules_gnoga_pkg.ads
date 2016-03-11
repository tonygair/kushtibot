with Gnoga.Gui.Base;

with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;
package Usna_Edit_Schedules_Gnoga_Pkg is

   procedure Update_Temperature_And_Mode_Information (Object : in out Gnoga.Gui.Base.Base_Type'Class) ;


  procedure Minus_A_Degree_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class) ;

   procedure Add_A_Degree_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class) ;

  procedure Mode_Change_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class);

   procedure Select_Command_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class);

   procedure Build_Edit_Schedule_View
     (App  : in out App_Access);

 procedure Update_Edit_Schedule_View
     (App  : in out App_Access);

end Usna_Edit_Schedules_Gnoga_Pkg;
