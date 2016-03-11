with Open_Zwave; use Open_Zwave;
with Intermediate_Z_Types;
with Open_Zwave_Helper_Functions_Pkg; use Open_Zwave_Helper_Functions_Pkg;
package Z_Comms_Task_Pkg is



   function Z_Task_Running return boolean;

   procedure Z_Start_The_Task (The_Interface : in string;
                               Success : out boolean) ;

   procedure Set_Debug ( Debug : in boolean);

   procedure Set_Polling_Time_Between_Polls ( Time_Period : in Duration);

   procedure Set_Parameter
     (  Command : in Intermediate_Z_Types.Z_Command_Record);

generic
      with Procedure Action_On_Node_Value (Node_Number : Value_U8);
   procedure Action_On_Node_List(Nodes : in Value_U8_Array_Type);



   package ZManager is new Open_Zwave.Manager
     (Context_Data                 => Dummy_Type,
      Process_Notification         =>  Process_Z_Notification_Into_Data,
      Initial_Configuration_Path   =>"/home/tony/zwavetry",
      Initial_User_Path            =>"",
      Initial_Command_Line_Options => "" );
   use ZManager;

end  Z_Comms_Task_Pkg;
