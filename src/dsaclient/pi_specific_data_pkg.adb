with Ada.Unchecked_Deallocation;
--with Gnoga;
with Ada.Exceptions;
--with Dsa_Usna_Server;
with Gnoga;
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




      procedure Process_Data
        (Room : in Room_Id;
         Roomname : in string;
         Data : in Device_Data) is
      begin

         if Room_Array(Room) = null then
            declare
               RIR : Room_Information_Record :=
                 (Roomname_Length => Roomname'length,
                  Location =>  1,
                  Room => Room_Id_Type(Room),
                  Set_Point => 18.0,
                  Actual => 18.0,
                  Error_In_Room => false,
                  Link_Error => false,
                  Battery_Low => false,
                  Room_Name => Roomname);

            begin

               Room_Array(Room) := new Room_Information_Record'(RIR);
            exception
               when E : others =>Gnoga.Log( "EXCEPTION" & Ada.Exceptions.Exception_Information (E));

            end;
         end if;

         Room_Array(Room).Error_In_Room := Data.Error or Room_Array(Room).Error_In_Room;
         Room_Array(Room).Link_Error := Data.Link_Error or Room_Array(Room).Link_Error;
         --Room_Array.all(Room).Battery_Low := Data.Battery_Low ;

         case Data.Kind_Of is
            when  Radiator_Thermostat | Radiator_Thermostat_Plus =>

               Room_Array(Room).Set_Point :=
                 C_Centigrade(Data.Set_Temperature);
            when Wall_Thermostat =>
               Room_Array(Room).Actual :=
                 C_Centigrade(Data.Temperature);


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
         Device_Count : in natural;
         Ready : out boolean) is
         Return_Value : Boolean;
      begin
         Gnoga.log(" Room id : " & Room'img & " Device_Count " & Device_Count'img
                   & " RBA(Room) " & RBA(Room)'img
                   & " Messages Per Room " & Messages_Per_Room(Room)'img);
         if not RBA(Room) or Device_Count = 0 or Room = 0 then
            Return_Value := false;
         elsif Messages_Per_Room(Room) = 0 then
            Return_Value := false;
         elsif RBA(Room) and Messages_Per_Room (Room) > 0 then
            Messages_Per_Room (Room) := 0;
            Return_Value := true;
         end if;
         Ready := Return_Value;

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
