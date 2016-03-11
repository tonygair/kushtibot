with Identity_Types_Pkg; use Identity_Types_Pkg;

with Dsa_Usna_Server; use Dsa_Usna_Server;

with Ada.Strings.Unbounded;
package body Load_Test_Data is


   package Su renames Ada.Strings.Unbounded;
   type Roomname_Array_Type is array (Room_Id_Type range <>) of Su.Unbounded_String;

   Roomname_Array : Roomname_Array_Type (1..6) :=
     (1=> Su.To_Unbounded_String("Hall"),
      2 => Su.To_Unbounded_String("Kitchen"),
      3 => Su.To_Unbounded_String("Lounge"),
      4=> Su.To_Unbounded_String ("Front Bedroom"),
          5=> Su.To_Unbounded_String("Back Bedroom"),
      6=> Su.To_Unbounded_String("Bathroom"));





   procedure Rooms_Create_And_Load_Test_Data is

   begin
      Dsa_Usna_Server.Set_number_Of_Rooms(Location => 1,
                                           Rooms =>6);
      for count in Roomname_Array'first..Roomname_Array'last loop

         declare
            RIR : Room_Information_Record :=
              (Roomname_Length => Su.To_String(Roomname_Array(count))'length,
               Location =>  1,
               Room => count,
               Set_Point => 22.0,
               Actual => 18.0,
               Error_In_Room => false,
               Link_Error => false,
               Battery_Low => false,
               Room_Name =>Su.To_String(Roomname_Array(count)));
         begin
            Dsa_Usna_Server.Submit_Room_data(Room_Data => RIR);
         end;
      end loop;

   end Rooms_Create_And_Load_Test_Data;

   procedure Load_Rooms_Data is
   begin
      Rooms_Create_And_Load_Test_Data;
   end Load_Rooms_Data;


   procedure Load_User_Data is
   begin
      null;
      end Load_User_Data;

end Load_Test_Data;
