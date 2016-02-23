with Ada.Exceptions;

with Gnoga.Application.Multi_Connect;

with kushtibot.Controller;

with Z_Comms_Task_Pkg;

procedure kushtibot.Main is
begin
    Z_Comms_Task_Pkg.Z_Start_The_Task
     (The_Interface => "/dev/ttyUSB0",
      Success       => Startup_Success );

   Gnoga.Application.Title ("kushtibot");
   Gnoga.Application.HTML_On_Close
     ("<b>Connection to Application has been terminated</b>");
   
   Gnoga.Application.Multi_Connect.Initialize;
   
   Gnoga.Application.Multi_Connect.Message_Loop;
exception
   when E : others =>
      Gnoga.Log (Ada.Exceptions.Exception_Name (E) & " - " &
                   Ada.Exceptions.Exception_Message (E));
end kushtibot.Main;
