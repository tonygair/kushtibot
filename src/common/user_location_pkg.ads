
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Tables;
with Identity_Types_Pkg; use Identity_Types_Pkg;

with User_And_Location_Types_Pkg; use User_And_Location_Types_Pkg;
package User_Location_Pkg is



   package Location_By_Id_Table is new tables(Tag=> Location_Record);

   package Location_By_Name_Table is new tables (Tag => Location_Id_Type);

   package Location_By_Serial_Table is new tables (Tag => Location_Id_Type);

   procedure Initialise;

   type Location_Occupied_Array_Type is Array(Location_Id_Type)
     of boolean;



   protected Location_Object is

      function IsIn
        (Location_Id : in Location_Id_Type)
         return boolean;

      Function Get_Location_Record
        (Location_Id : in Location_Id_Type)
         return Location_Record;

      function Get_Location_Id_From_Name
        (Name : string)
         return Location_Id_Type;

      function Get_Location_Id_From_Serial
        (Serial : string)
        return Location_Id_Type;

      procedure Add_Location
        ( Location : in Location_Record);

      procedure Add_Connected_Location
        (Serial_Number : in Unbounded_String);

      function Get_Occupied_Locations
        return Location_Occupied_Array_Type;

      function Get_Authorised_Locations
        (Users_Access : in Access_Array_Type)
        return Location_Array_Type;


   private
      Id_Table : Location_By_Id_Table.Table;
         Name_Table : Location_By_Name_Table.Table;
         Serial_Table : Location_By_Serial_Table.Table;
      Location_Occupied : Location_Occupied_Array_Type
        := (others => false);


   end Location_Object;



   end User_Location_Pkg;
