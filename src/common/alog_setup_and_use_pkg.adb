package body Alog_Setup_And_Use_Pkg is


--     Zwave_Log_Name : constant string := "Task_Zwave_Log";
--
--     Max_Log_Name : constant string := "Task_Max_Log";

   -- Gui_Log_Name : constant string := "Gui_Log";

   procedure Log_Zwave (Text_To_Be_Logged : in string) is

   begin
      Gnoga.Log_To_File(Zwave_Log_Name);
      Gnoga.log(Text_To_Be_Logged);
   end Log_Zwave;


   procedure Log_Max (Text_To_Be_Logged : in string) is
   begin

     Gnoga.Log_To_File(Max_Log_Name);
      Gnoga.log(Text_To_Be_Logged);
   end Log_Max;

   procedure Log_Gui (Text_To_Be_Logged : in string) is
   begin
      Gnoga.Log_To_File(Gui_Log_Name);
      Gnoga.log(Text_To_Be_Logged);

   end Log_Gui;




end Alog_Setup_And_Use_Pkg;
