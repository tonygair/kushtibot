--with Open_Zwave; use Open_Zwave;
--with Open_Zwave_Helper_Functions_Pkg; use Open_Zwave_Helper_Functions_Pkg;
with Z_Comms_Task_Pkg;
with Ada.Exceptions;
with Ada.Unchecked_Conversion;
with Interfaces;
with Gnoga;
with Ada.Calendar; use Ada.Calendar;
procedure Kushtibot_Main is

   Startup_Success : boolean := false;


begin

   Z_Comms_Task_Pkg.Z_Start_The_Task
     (The_Interface => "/dev/ttyUSB0",
      Success       => Startup_Success );



end Kushtibot_Main;
