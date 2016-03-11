with Ada.Unchecked_Deallocation;
with Gnoga;
with Ada.Exceptions;
package body Pi_Specific_Data_Pkg is


--     procedure Deallocate_Device is new Ada.Unchecked_Deallocation
--       (Object => Device_Parameters,
--        Name => Device_Parameter_Access);

   procedure Deallocate_RIR is new Ada.Unchecked_Deallocation
     (Object => Room_Information_Record,
      Name => RIR_Access);

   procedure Deallocate_RIR_Array is new Ada.Unchecked_Deallocation
     (Object => Room_Array_Type,
      Name => Room_Array_Access);

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
         Deallocate_RBA(RBA);
          exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

      end Reset;


      function Location_id return Location_Id_Type is
      begin
         return My_Location_Id;
          exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
            return 0;

      end Location_Id;


      procedure Set_Location_Id ( Location : in Location_Id_Type) is
      begin
         My_Location_Id := Location;
      end Set_Location_Id;

      procedure Set_Number_Rooms (Room_Size : in Natural) is
      begin
         if Room_Array = null and RBA = null then
            Room_Array := new Room_Array_Type(0..Room_Id(Room_Size));
            RBA := new Room_Boolean_Array_Type
              (0..Room_ID(Room_Size));
            RBA.all := (others => false);

         end if;
          exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

         end Set_Number_Rooms;


      procedure Process_Data
        (Room : in Room_Id;
         Roomname : in string;
         Data : in Device_Data) is
      begin
         if Room_Array.all(Room) = null then
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
               Room_Array.all(Room) := new Room_Information_Record'(RIR);
            end;
         end if;

         Room_Array.all(Room).Error_In_Room := Data.Error or Room_Array.all(Room).Error_In_Room;
         Room_Array.all(Room).Link_Error := Data.Link_Error or Room_Array.all(Room).Link_Error;
         --Room_Array.all(Room).Battery_Low := Data.Battery_Low ;

         case Data.Kind_Of is
            when  Radiator_Thermostat | Radiator_Thermostat_Plus =>

               Room_Array.all(Room).Set_Point :=
                 C_Centigrade(Data.Set_Temperature);
            when Wall_Thermostat =>
               Room_Array.all(Room).Actual :=
                 C_Centigrade(Data.Temperature);


            when others =>
               null;
         end case;


         RBA.all(Room) := true;
          exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

      end Process_Data;


      function Room_Data_Ready (Room: in Room_Id)
      return boolean is
      begin
         if RBA = null or Room_Array = null then
            return false;
         else
            return RBA.all(Room);
         end if;
          exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
            return false;

      end Room_Data_Ready;




      function Get_Room_Information
        (Room : in Room_ID) return Room_Information_Record is

      begin
         if Room_Array.all( Room) = null then
            return Blank_RIR;
         else

         declare
             Return_Value : Room_Information_Record :=
              Room_Array.all( Room).all;
            begin
            return Return_Value;
            end;
         end if;

       exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
           return Blank_RIR;
      end Get_Room_Information;



   --private
   --  My_Location_Id : Location_Id_Type;
--      Room_Array : Rir_Access_Type := null;
--        RBA : RBA_Access := null;
   end Pi_Data;


end Pi_Specific_Data_Pkg;
