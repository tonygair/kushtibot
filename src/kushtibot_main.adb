with Open_Zwave; use Open_Zwave;
with Open_Zwave_Helper_Functions_Pkg; use Open_Zwave_Helper_Functions_Pkg;
with Ada.Exceptions;
with Ada.Unchecked_Conversion;
with Interfaces;
with Gnoga;
with Ada.Calendar; use Ada.Calendar;
procedure Kushtibot_Main is



   type Dummy_Type is new integer;

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

         Gnoga.log ("Notification received with invalid type" &
                      Rep'Img);
      end if;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Notify_Me;


    package ZManager is new Open_Zwave.Manager
     (Context_Data                 => Dummy_Type,
      Process_Notification         => Notify_Me,
      Initial_Configuration_Path   =>"/home/tony/zwavetry",
      Initial_User_Path            =>"",
      Initial_Command_Line_Options => "" );
   use ZManager;

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

   Adhoc_Notification : Notification_Info;
   Last_Temperature_Request : Ada.Calendar.Time := Ada.Calendar.Clock;
   Time_Between_Requests : Ada.Calendar.Day_Duration := 720.0;
begin
   ZManager.Add_Driver(Controller_Path => "/dev/ttyUSB0");
   loop
      --delay 200.0;
      --for count in Node_Boolean_Array_Type'first..Node_Boolean_Array_Type'last loop
      --   if Node_Occupied(count) then
      --      if not Node_Asked(count) then
      --         Gnoga.log("&&Getting all parameters for node :" & count'img & "&&");
      --         ZManager.Get_All_Parameters
      --           (Controller => Home_ID,
      --            Node       => ZManager.Node_ID(count));
      --         Node_Asked(count) := true;
      --      end if;
      --   end if;

      --end loop;
      While not Notification_Queue_PO.Empty  loop
         Gnoga.log(" Size of Queue " & Notification_Queue_PO.The_Size'img & " items ");
         Notification_Queue_PO.Read_Item(Value => Adhoc_Notification);
         Print_Value_Id(The_Value_Id => Adhoc_Notification.M_Value_ID);

      end loop;
      delay 10.0;
      if Last_Temperature_Request + Time_Between_Requests < Ada.Calendar.Clock then
         Last_Temperature_Request := Ada.Calendar.Clock;
         ZManager.Get_All_Parameters(Controller => Adhoc_Notification.M_Value_ID.Home_ID ,
                                     Node       => Node_ID(Adhoc_Notification.M_Value_ID.Node));
--                                       ZManager.Node_ID(count));
         Node_Asked(Adhoc_Notification.M_Value_ID.Node) := true;
      end if;
   end loop;
   exception
       when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));


end Kushtibot_Main;
