
with Identity_Types_Pkg; use Identity_Types_Pkg;
--with User_And_Location_Types_Pkg; use User_And_Location_Types_Pkg;

package Room_Types_Pkg is


   Blank_Room_Name : String (1..50) := (others => ' ' );

   Type Room_Record is record
      Location_Id : Location_Id_Type;
      Room_Id : Room_Id_Type;
      Room_Name : String (1..50);
      Room_Name_Length : Natural;
      Schedule_Id : Schedule_Id_Type;
   end record;

   Blank_Room : constant Room_Record :=
     (Location_Id => 0,
      Room_Id => 0,
      Room_Name => Blank_Room_Name,
      Room_Name_Length => 0,
      Schedule_Id => 0);


   end Room_Types_Pkg;
