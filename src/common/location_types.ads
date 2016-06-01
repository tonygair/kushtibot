with Identity_Types_Pkg; use Identity_Types_Pkg;
with User_Password_Check_Pkg;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Location_Types is

 type Location_Record is record
      Location_Id : Identity_Types_Pkg.Location_Id_Type;
      Description : Unbounded_String := User_Password_Check_Pkg.Blank_Ustring;
      Serial_No : Unbounded_String := User_Password_Check_Pkg.Blank_Ustring;
      Bookable : boolean := false;
   end record;

   type Location_Array_Type is array (Natural range <>) of
     Location_Record;

   type Location_List_Type is array(Natural range <>) of Unbounded_String;

   type User_Access_Type is (Full,  None);

   --type Access_Ok_Array is array (Location_Id_Type) of boolean;


   type Access_Array_Type is array
     (Location_Id_Type
      range Location_Id_Type'first + 1.. Location_Id_Type'last)
     of User_Access_Type;

   Blank_Access_Array : Access_Array_Type := (others=> None);



   type Location_Conversion_Array_Type is array (Location_Id_Type) of boolean;

   function Convert_Location_Array ( The_Array : in Access_Array_Type) return Integer;

   function Convert_Location_Value ( The_Value : in Integer ) return Access_Array_Type;


end Location_Types;
