with Identity_Types_Pkg;
with User_Password_Check_Pkg;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Location_Types is

 type Location_Record is record
      Location_Id : Identity_Types_Pkg.Location_Id_Type;
      Description : Unbounded_String := User_Password_Check_Pkg.Blank_Ustring;
      Serial_No : Unbounded_String := User_Password_Check_Pkg.Blank_Ustring;
      Bookable : boolean := false;
   end record;

end Location_Types;
