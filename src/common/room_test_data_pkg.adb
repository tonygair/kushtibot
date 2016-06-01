with Identity_Types_Pkg; use Identity_Types_Pkg;
with Dsa_Usna_Server;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Gnoga;
package body  Room_Test_Data_Pkg is

 procedure Create_And_Save_Random_Room_Data
     (Location : in Location_Id_Type;
      Room_Name : in string;
      Room_Id : Room_Id_Type) ;



   procedure Load_Room_Test_Data is


      Room_Names : Array(Room_Id_Type range 1..10) of Unbounded_String :=
        (To_Unbounded_String("Hall"),
         To_Unbounded_String("Lounge"),
         To_Unbounded_String("Kitchen"),
         To_Unbounded_String("Bathroom"),
         To_Unbounded_String("Toilet"),
         To_Unbounded_String("Master Bedroom"),
         To_Unbounded_String("Second Bedroom"),
         To_Unbounded_String("Study"),
         To_Unbounded_String("Third Bedroom"),
         To_Unbounded_String("Front Room"));

      Location_Start : Location_Id_Type := 1;
      Location_End : Location_Id_Type := 3;
      Room_Start : Room_Id_Type := Room_Names'first;
      Room_End : Room_Id_Type := Room_Names'last;

   begin
      For Location_Count in Location_Start..Location_End loop
         Dsa_Usna_Server.Set_number_Of_Rooms
           (Location => Location_Count,
            Rooms    => Room_Id_Type(Room_Names'length));
         For Room_Id_Count in  Room_Start..Room_End loop

            Create_And_Save_Random_Room_Data
              (Location  => Location_Count,
               Room_Name => Location_Count'img & To_String(Room_Names(Room_Id_Count)),
               Room_Id   => Room_Id_Count);

         end loop;
         Gnoga.log("There are " & Dsa_Usna_Server.Get_Number_Of_Rooms
                   (Location => Location_Count)'img & "rooms !");
      end loop;


   end Load_Room_Test_Data;


   procedure Create_And_Save_Random_Room_Data
     (Location : in Location_Id_Type;
      Room_Name : in string;
     Room_Id : Room_Id_Type)  is

      Room_Number  : Room_Id_Type := 1;


   begin
      if Room_Name'length > 0 then
         Gnoga.log("Submitting room " & Room_Name & " Id is " & Room_Id'img);
         declare
          Submitted_Record : Room_Information_Record :=
              (Roomname_Length => Room_Name'length,
               Location => Location,
               Room => Room_Id,
               Set_Point => 16.1,
               Actual => 19.3,
               Link_Error => False,
               Error_In_Room => false,
               Battery_Low => false,
               Room_Name => Room_Name(Room_Name'first..Room_Name'last));

         begin
            Dsa_Usna_Server.Submit_Room_data
              (Room_Data => Submitted_Record);
            --gnoga.log("Success : " & Room_Name);
         end;
      end if;


   end Create_And_Save_Random_Room_Data;





end Room_Test_Data_Pkg;
