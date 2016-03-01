--with Open_Zwave; use Open_Zwave;
with Open_Zwave_Helper_Functions_Pkg; use Open_Zwave_Helper_Functions_Pkg;
with Ada.Exceptions;
with Ada.Unchecked_Conversion;
with Interfaces;
with Gnoga;
with Ada.Calendar; use Ada.Calendar;
with Ada.Calendar.Formatting;
with Intermediate_Z_Types;
with Fifo_Po;
with Ada.Calendar.Formatting;
package body Z_Comms_Task_Pkg is

   Package Z_Command_Fifo_Pkg is new
     Fifo_Po(Element_Type => Intermediate_Z_Types.Z_Command_Record);

   Z_Command_Fifo : Z_Command_Fifo_Pkg.The_PO;

   procedure Set_Parameter
     (  Command : in Intermediate_Z_Types.Z_Command_Record) is
   begin
      Z_Command_Fifo.Push(Item => Command);
   end Set_Parameter;



   type Node_Boolean_Array_Type is array (Open_Zwave.Value_U8) of boolean;



   Node_Occupied, Node_Asked : Node_Boolean_Array_Type := (others => false);


   procedure Print_Z_Notification (Notification : in Open_Zwave.Notification_Info) is





      procedure Print_Valid_Record ( VR : in Open_Zwave.Value_ID) is

      begin
         Gnoga.log("In detail --->");
         Gnoga.log ("VR - Type_ID : " & VR.Type_Id'img);
         Gnoga.log ("VR-Index(U8) : " & VR.Index'img);
         Gnoga.log ("VR-Command_Class_ID(U8) : " & VR.Command_Class_ID'img);
         Gnoga.log("VR-Genre :" & VR.Genre'img);
         Gnoga.log ("VR-Node(U8) : " & VR.Node'img);
         Gnoga.log ("VR-Command_Class_Index(U8) : " & VR.Command_Class_Index'img);
         Gnoga.log ("VR-Home_ID (longword) " & Notification.M_Value_ID.Home_ID'img);

         if not Node_Occupied(VR.Node) then
            Node_Occupied(VR.Node) := true;
         end if;



      end Print_Valid_Record;

   begin
      Gnoga.log("M_Type : " & Notification.M_Type'img);
      Print_Valid_Record(Notification.M_Value_ID);
      Gnoga.Log("M_Byte :" & Notification.M_Byte'img);

   end Print_Z_Notification;


   procedure Notify_Me (Notification : in     Open_Zwave.Notification_Info;
                        Context      : in out Dummy_Type)
   is

      type Notification_Type_Rep is mod 2 ** Open_Zwave.Notification_Type_ID'Size;

      function To_Rep is new Ada.Unchecked_Conversion
        (Source => Open_Zwave.Notification_Type_ID,
         Target => Notification_Type_Rep);

      Rep : Notification_Type_Rep;
   begin -- Notify_Me
      Gnoga.log (Notification.M_Type'img);
      Rep := To_Rep (Notification.M_Type);

      if Rep in Open_Zwave.Notification_Type_ID'Pos (Open_Zwave.Notification_Type_ID'First) ..
        Open_Zwave.Notification_Type_ID'Pos (Open_Zwave.Notification_Type_ID'Last) then

         -- filtering out zero command classes and
         if Notification.M_Value_ID.Command_Class_ID > 0  then

            Notification_Queue_PO.Add_Item(Value => Notification);
         end if;
      else

         Gnoga.log ("*****Notification received with invalid type******" &
                      Rep'Img);
      end if;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Notify_Me;


   procedure Check_Notification
     (Notification : in     Open_Zwave.Notification_Info;
      Context      : in out Dummy_Type) is

      type Notification_Type_Rep is mod 2 ** Open_Zwave.Notification_Type_ID'Size;

      function To_Rep is new Ada.Unchecked_Conversion
        (Source => Open_Zwave.Notification_Type_ID,
         Target => Notification_Type_Rep);

      Rep : Notification_Type_Rep;
   begin -- Notify_Me
      Gnoga.log (Notification.M_Type'img);
      Rep := To_Rep (Notification.M_Type);

      if Rep in Open_Zwave.Notification_Type_ID'Pos (Open_Zwave.Notification_Type_ID'First) ..
        Open_Zwave.Notification_Type_ID'Pos (Open_Zwave.Notification_Type_ID'Last) then

         -- filtering out zero command classes and
         if Notification.M_Value_ID.Command_Class_ID > 0  then

            Notification_Queue_PO.Add_Item(Value => Notification);
         end if;
      else

         Gnoga.log ("*****Notification received with invalid type******" &
                      Rep'Img);
      end if;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Check_Notification;



   procedure Check_Incoming_Z_Messages
     ( Home_Id : in Controller_ID ) is
      Command :  Intermediate_Z_Types.Z_Command_Record;

   begin
      while  not Z_Command_Fifo.Is_Empty  loop

         Z_Command_Fifo.Pop (Command);
         declare
            Node :ZManager.Node_ID := ZManager.Node_ID(Command.Node);
            Index :ZManager.Parameter_Index :=ZManager.Parameter_Index(Command.Index);
            Value : ZManager.Parameter_Value := ZManager.Parameter_Value(Command.Value);

         begin
            ZManager.Set_Parameter
              (Controller => Home_Id,
               Node => Node,
               Index => Index,
               Value => Value,
               Num_Bytes => Command.Num_Bytes);

         end;

      end loop;

   end Check_Incoming_Z_Messages;




   procedure Print_Value_Id (The_Value_Id : in Value_Id ) is

      Boolean_Value_Id : Boolean;
      Unsigned_Value_Id : Interfaces.Unsigned_8;
      Float_Value_Id : Float;
      Integer_32_Value_Id : Interfaces.Integer_32;
      Integer_16_Value_Id : Interfaces.Integer_16;
      -- string is encapsulated
   begin
      Gnoga.log("**%%");
      Gnoga.log ("VR - Type_ID : " & The_Value_Id.Type_Id'img);

      Gnoga.log ("VR-Index(U8) : " & The_Value_Id.Index'img);
      Gnoga.log ("VR-Command_Class_ID(U8) : " & The_Value_Id.Command_Class_ID'img);
      Gnoga.log("VR-Genre :" & The_Value_Id.Genre'img);
      Gnoga.log ("VR-Node(U8) : " & The_Value_Id.Node'img);
      Gnoga.log ("VR-Command_Class_Index(U8) : " & The_Value_Id.Command_Class_Index'img);
      Gnoga.log(Manufacturer_Name(Controller => The_Value_ID.Home_ID,
                                  Node       => Node_ID(The_Value_Id.Node)));
      Gnoga.log(Product_Name(Controller => The_Value_ID.Home_ID,
                             Node       => Node_ID(The_Value_Id.Node)));


      case The_Value_Id.Type_ID is
         when Bool =>
            Boolean_Value_Id := ZManager.Value(The_Value_Id);

            Gnoga.log("Boolean Value Id : " & Boolean_Value_Id'img);



         when Byte =>
            Unsigned_Value_Id := ZManager.Value(The_Value_Id);
            Gnoga.log ("Unsigned Value Id : " & Unsigned_Value_Id'img);

         when Decimal =>
            Float_Value_Id := ZManager.Value(The_Value_Id);
            Gnoga.log("Float Value Id : " &  Float_Value_Id'img);


         when Int =>
            Integer_32_Value_Id := ZManager.Value(The_Value_Id);
            Gnoga.log("Integer 32 Value_Id : " & Integer_32_Value_Id'img);

         when List =>
            Gnoga.log("list not implemented ");


         when Schedule =>
            Gnoga.log("Schedule not implemented ");

         when  Short =>
            Integer_16_Value_Id := ZManager.Value(The_Value_Id);
            Gnoga.log(" Integer 16 Value Id : " & Integer_16_Value_Id 'img);


         when String_Type =>
            declare
               String_Value_Id :constant string :=ZManager.Value(The_Value_Id) ;

            begin

               Gnoga.log(" String Value ID : " & String_Value_Id);
            exception
               when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

            end;

         when Button =>
            Gnoga.log("Button not implemented ");


         when Raw =>
            Gnoga.log("RAW not implemented ");

         when Invalid =>
            Gnoga.log("Invalid Type ");

         when others =>
            Gnoga.log("Theres a new type and no one told me! ");



      end case;
      Gnoga.log("%%**");
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Print_Value_Id;

   task type Z_Comms_Task_Type is

      entry Start ( The_Interface : in string);

      entry End_The_Task ;

      entry Set_Debug ( Debug : in boolean);

      entry Set_Time_Between_Polls ( Time_Period : in Duration);


   end Z_Comms_Task_Type;

   Procedure Print_Node_List (Nodes : in Value_U8_Array_Type) is
      Start_List : Natural := Nodes'first;
      End_List : Natural := Nodes'last;
   begin
      Gnoga.log("Node List " );
      for count in Start_List..End_List loop
         gnoga.log(Nodes(count)'img);
      end loop;
   end Print_Node_List;


   procedure Action_On_Node_List(Nodes : in Value_U8_Array_Type)    is
      Start_List : Natural := Nodes'first;
      End_List : Natural := Nodes'last;
   begin
      for count in Start_List..End_List loop
         Action_On_Node_Value(Nodes(count));
      end loop;
   end Action_On_Node_List;

   procedure Print_Node_Details ( Node : Value_U8) is
      Classes : Z_Store_Array_Type := This_Network(Node).Get_List_Class_Values;
      Start_List : Natural := Classes'first;
      End_List : Natural := Classes'last;
      The_Value_ID : Value_ID;

      Boolean_Value_Id : Boolean;
      Unsigned_Value_Id : Interfaces.Unsigned_8;
      Float_Value_Id : Float;
      Integer_32_Value_Id : Interfaces.Integer_32;
      Integer_16_Value_Id : Interfaces.Integer_16;
   begin
      Gnoga.log (" Node : " & Node'img);
      for count in Start_List..End_List loop
         Gnoga.log("Last Class Update for class : " & Ada.Calendar.Formatting.Image
                   (Date                  => Classes(count).Occurred_At));
         The_Value_ID := Classes(count).The_Value_Id;
         case The_Value_Id.Type_ID is
            when Bool =>
               Boolean_Value_Id := ZManager.Value(The_Value_Id);

               Gnoga.log("Boolean Value Id : " & Boolean_Value_Id'img);



            when Byte =>
               Unsigned_Value_Id := ZManager.Value(The_Value_Id);
               Gnoga.log ("Unsigned Value Id : " & Unsigned_Value_Id'img);

            when Decimal =>
               Float_Value_Id := ZManager.Value(The_Value_Id);
               Gnoga.log("Float Value Id : " &  Float_Value_Id'img);


            when Int =>
               Integer_32_Value_Id := ZManager.Value(The_Value_Id);
               Gnoga.log("Integer 32 Value_Id : " & Integer_32_Value_Id'img);

            when List =>
               Gnoga.log("list not implemented ");


            when Schedule =>
               Gnoga.log("Schedule not implemented ");

            when  Short =>
               Integer_16_Value_Id := ZManager.Value(The_Value_Id);
               Gnoga.log(" Integer 16 Value Id : " & Integer_16_Value_Id 'img);


            when String_Type =>
               declare
                  String_Value_Id :constant string :=ZManager.Value(The_Value_Id) ;

               begin

                  Gnoga.log(" String Value ID : " & String_Value_Id);
               exception
                  when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

               end;

            when Button =>
               Gnoga.log("Button not implemented ");


            when Raw =>
               Gnoga.log("RAW not implemented ");

            when Invalid =>
               Gnoga.log("Invalid Type ");

            when others =>
               Gnoga.log("Theres a new type and no one told me! ");



         end case;

      end loop;

   end Print_Node_Details;

   procedure Print_Node_List_Details is new Action_On_Node_List
     (Action_On_Node_Value => Print_Node_Details);

   procedure Get_All_Parameters_For_Node (The_Node : in Value_U8) is

   begin
      ZManager.Get_All_Parameters(Controller => Home_Id_P.Read_Home_Id ,
                                  Node       => ZManager.Node_Id(The_Node));
   end Get_All_Parameters_For_Node;

   procedure Get_All_Parameters_For_Node_List is new Action_On_Node_List
     (Action_On_Node_Value => Get_All_Parameters_For_Node);

   task body Z_Comms_Task_Type is


      Adhoc_Notification : Notification_Info;
      Last_Temperature_Request : Ada.Calendar.Time := Ada.Calendar.Clock;
      Time_Between_Requests : Ada.Calendar.Day_Duration := 720.0;

      Print_Debug : boolean := true;
      Terminate_Task : boolean := false;


   begin

      accept Start (The_Interface : in string ) do

         --ZManager.Add_Driver(Controller_Path => "/dev/ttyUSB0");
         ZManager.Add_Driver(Controller_Path => The_Interface);



      end;

      loop
         Gnoga.log(" Size of Queue " & Notification_Queue_PO.The_Size'img & " items ");

         While not Notification_Queue_PO.Empty  loop
            Gnoga.log(" Size of Queue " & Notification_Queue_PO.The_Size'img & " items ");
            Notification_Queue_PO.Read_Item(Value => Adhoc_Notification);
            Print_Value_Id(The_Value_Id => Adhoc_Notification.M_Value_ID);

         end loop;





         select

            accept End_The_Task do
               Terminate_Task := true;
            end;

         or

            accept Set_Debug (Debug : boolean ) do

               Print_Debug := Debug;

            end;

         or
            delay 10.0;

         or accept Set_Time_Between_Polls (Time_Period : in Duration) do
               Time_Between_Requests := Time_Period;

            end Set_Time_Between_Polls;

         end Select;

         if Terminate_Task then
            Exit;
         end if;



         -- check to see if enough time has past so we can do another request for notifications etc!
         Gnoga.log("Last Req :" & Ada.Calendar.Formatting.Image(Last_Temperature_Request) & " TBR " &
                        Time_Between_Requests'img & " Now is " &
                        Ada.Calendar.Formatting.Image(Ada.Calendar.Clock));
         if (Last_Temperature_Request + Time_Between_Requests) < Ada.Calendar.Clock then
            --examine the nodes
            Gnoga.Log("Time to send out messages for updates " );

            Last_Temperature_Request := Ada.Calendar.Clock;

            declare
               Node_List : Open_Zwave_Helper_Functions_Pkg.Value_U8_Array_Type :=
                 Open_Zwave_Helper_Functions_Pkg.The_Nodes.Get_Active_Node_List;
            begin
               --   Print_Node_List(Nodes => Node_List);
               Print_Node_List_Details(Node_List);
               Get_All_Parameters_For_Node_List(Node_List);

            end;

         end if;

      end loop;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));


   end Z_Comms_Task_Type;

   type Z_Comms_Access is access Z_Comms_Task_Type;

   Z_Task : Z_Comms_Access;



   function Z_Task_Running return boolean is
   begin
      if Z_Task = null then
         return false;
      else
         return true;
      end if;
   end Z_Task_Running;


   procedure Z_Start_The_Task (The_Interface : in string;
                               Success : out boolean) is

   begin
      if Z_Task_Running then
         Gnoga.log("Task Already Running ");
      else

         Z_Task := new Z_Comms_Task_Type;
      end if;
      delay 5.0;
      Z_Task.Start(The_Interface);
      Success := Z_Task_Running;

   end Z_Start_The_Task;



   procedure Set_Debug ( Debug : in boolean) is
   begin
      if Z_Task_Running then
         Z_Task.Set_Debug(Debug => Debug);
      else
         Gnoga.log("Z_TASK not running");
      end if;

   end Set_Debug;

   procedure Set_Polling_Time_Between_Polls ( Time_Period : in Duration) is

   begin
      if Z_Task_Running then
         Z_Task.Set_Time_Between_Polls(Time_Period => Time_Period);
      else
         Gnoga.log("Z_TASK not running");
      end if;

   end Set_Polling_Time_Between_Polls;


end Z_Comms_Task_Pkg;
