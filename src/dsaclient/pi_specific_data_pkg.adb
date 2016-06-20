with Ada.Unchecked_Deallocation;
--with Gnoga;
with Ada.Exceptions;
--with Dsa_Usna_Server;
with Gnoga;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;
package body Pi_Specific_Data_Pkg is


   --     procedure Deallocate_Device is new Ada.Unchecked_Deallocation
   --       (Object => Device_Parameters,
   --        Name => Device_Parameter_Access);

   procedure Deallocate_RIR is new Ada.Unchecked_Deallocation
     (Object => Room_Information_Record,
      Name => RIR_Access);

   --     procedure Deallocate_RIR_Array is new Ada.Unchecked_Deallocation
   --       (Object => Room_Array_Type,
   --        Name => Room_Array_Access);

   procedure Deallocate_RBA is new Ada.Unchecked_Deallocation
     (Object => Room_Boolean_Array_Type,
      Name   => RBA_Access);



   protected body  Pi_Data is

      procedure Reset is
      begin
         for count in Room_Array'first..Room_Array'last loop
            if Room_Array(Count) /= null then
               Deallocate_RIR (Room_Array(count));
            end if;
         end loop;
         RBA := (others => false);
         Messages_Per_Room := (others => 0);

      exception
         when E : others => Gnoga.Log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

      end Reset;


      function Location_id return Location_Id_Type is
      begin
         return My_Location_Id;
      exception
         when E : others => Gnoga.Log( "EXCEPTION" & Ada.Exceptions.Exception_Information (E));
            return 0;

      end Location_Id;


      procedure Set_Location_Id ( Location : in Location_Id_Type) is
      begin
         My_Location_Id := Location;
           exception
         when E : others =>Gnoga.Log( "EXCEPTION" & Ada.Exceptions.Exception_Information (E));

      end Set_Location_Id;

      procedure Set_Room_Name (Room : in Room_Id;
                                Roomname : String) is
          House_RIR : Room_Information_Record :=
           (Roomname_Length => Whole_House_Description'length,
            Location => My_Location_id,
            Room => 0,
            Set_Point => 0.0,
            Actual => 0.0,
            Error_In_Room => false,
            Link_Error => false,
            Battery_Low => false,
            Room_Name =>Whole_House_Description);

         Other_RIR :Room_Information_Record :=
              (Roomname_Length => Roomname'length,
               Location =>  My_Location_Id,
               Room => Room_Id_Type(Room),
               Set_Point => 0.0,
               Actual => 0.0,
               Error_In_Room => false,
               Link_Error => false,
               Battery_Low => false,
               Room_Name => Roomname);

      begin
         if Room_Array (Room) = null then
            if Room = 0 then
               Room_Array(0) := new Room_Information_Record'(House_RIR);
            else
               Room_Array(Room) := new Room_Information_Record'(Other_RIR);
            end if;
         else
            Gnoga.log (" Room pointer should be null ");
            raise Program_Error;
         end if;
           exception
               when E : others =>Gnoga.Log( "EXCEPTION" & Ada.Exceptions.Exception_Information (E));
      end Set_Room_Name;




      procedure Process_Parameters
        (Device_P : in Device_Parameters) is
         Room : Room_ID := Device_P.Room;

      begin
        if Room_Array(Room) = null then
            raise Program_Error;
         end if;
         if Device_P.Room > 0 then
            case Device_P.Kind_Of is
               when Radiator_Thermostat..Wall_Thermostat =>
                  Room_Array(Room).Set_Point := C_Centigrade(Device_P.Comfort);
               when others =>
                  null;
            end case;
         end if;


      exception
         when E : others =>Gnoga.Log( "EXCEPTION" & Ada.Exceptions.Exception_Information (E));
      end Process_Parameters;

      procedure Process_Data
        (Room : in Room_Id;
         Roomname : in string;
         Data : in Device_Data) is
      begin


         Room_Array(Room).Battery_Low := Data.Battery_Low or Room_Array(Room).Battery_Low;
         Room_Array(Room).Error_In_Room := Data.Error or Room_Array(Room).Error_In_Room;
         Room_Array(Room).Link_Error := Data.Link_Error or Room_Array(Room).Link_Error;
         --Room_Array.all(Room).Battery_Low := Data.Battery_Low ;
         Gnoga.log(Data.Kind_Of'img & " in room " & Roomname );
         case Data.Kind_Of is
            when  Radiator_Thermostat .. Radiator_Thermostat_Plus =>
               Room_Array(Room).Actual :=
                 C_Centigrade(Data.Latest_Temperature);
               Gnoga.log(Data.Kind_Of'img &  " has temp " & Data.Latest_Temperature'img & " delivered at "&
                          Ada.Calendar.Formatting.Image(Data.Received_At));

            when Wall_Thermostat =>
               Room_Array(Room).Actual :=
                 C_Centigrade(Data.Temperature);
               Gnoga.log(Data.Kind_Of'img &  " has temp " & Data.Temperature'img );

            when others =>
               null;
         end case;
         RBA(Room) := true;
         Messages_Per_Room(Room) := Messages_Per_Room(Room) + 1;

      exception
         when E : others =>Gnoga.Log( "EXCEPTION" & Ada.Exceptions.Exception_Information (E));

      end Process_Data;


      procedure Room_Data_Ready
        (Room: in Room_Id;
         Ready : out boolean) is

      begin
         Gnoga.log(" Room id : " & Room'img & " RBA(Room) " & RBA(Room)'img
                   & " Messages Per Room " & Messages_Per_Room(Room)'img);
         if RBA(Room) then
            Ready := true;
            RBA(Room) := false;
         else
            Ready := false;
         end if;

      exception
         when E : others => Gnoga.Log( "EXCEPTION" & Ada.Exceptions.Exception_Information (E));
            Ready := false;

      end Room_Data_Ready;




      function Get_Room_Information
        (Room : in Room_ID) return Room_Information_Record is

      begin
         if Room_Array( Room) = null then
            return Blank_RIR;
         else

            declare
               Return_Value : Room_Information_Record :=
                 Room_Array( Room).all;
            begin
               return Return_Value;
            exception
               when E : others =>Gnoga.Log( "EXCEPTION" & Ada.Exceptions.Exception_Information (E));
               return Blank_RIR;
            end;
         end if;

      exception
         when E : others =>Gnoga.Log( "EXCEPTION" & Ada.Exceptions.Exception_Information (E));
            return Blank_RIR;
      end Get_Room_Information;



      --private
      --  My_Location_Id : Location_Id_Type;
      --      Room_Array : Rir_Access_Type := null;
      --        RBA : RBA_Access := null;
   end Pi_Data;


end Pi_Specific_Data_Pkg;
