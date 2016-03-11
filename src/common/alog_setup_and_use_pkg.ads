with Alog;
package Alog_Setup_And_Use_Pkg is


   Zwave_Log_Name : constant string := "Task_Zwave_Log";

   Max_Log_Name : constant string := "Task_Max_Log";

   Gui_Log_Name : constant string := "Gui_Log";


   procedure Log_Zwave (Text_To_Be_Logged : in string);

   procedure Log_Max (Text_To_Be_Logged : in string);

    procedure Log_Gui (Text_To_Be_Logged : in string);




end Alog_Setup_And_Use_Pkg;
