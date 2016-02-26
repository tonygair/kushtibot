with Open_Zwave; use Open_Zwave;
with Intermediate_Z_Types;
package Z_Comms_Task_Pkg is



   function Z_Task_Running return boolean;

   procedure Z_Start_The_Task (The_Interface : in string;
                               Success : out boolean) ;

   procedure Set_Debug ( Debug : in boolean);

   procedure Set_Polling_Time_Between_Polls ( Time_Period : in Duration);

   procedure Set_Parameter
     (  Command : in Intermediate_Z_Types.Z_Command_Record);



end  Z_Comms_Task_Pkg;
