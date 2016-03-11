--with Device_Type_Pkg; use Device_Type_Pkg;
with Ada.Calendar;
--with User_And_Location_Types_Pkg; use User_And_Location_Types_Pkg;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Identity_Types_Pkg; use Identity_Types_Pkg;

package App_Common_Functions_Pkg is

   function Convert_Text_To_Integer (The_Text : in String)
return integer;

   function Temp_Xten_Image (Temp : in Temp_Xten_Type) return string;

   --function Temp_Xten_Numeric ( The_Text : in string) return Temp_Xten_Type;

   function Strip_First_Space (The_String : String) return String;

  function String_To_Xten(The_String : in String ) return Temp_Xten_Type;


   function Check_String_Input(The_String : in String) return boolean;

   function Overlay_String_Value (The_String : in String) return String;

  function To_String (Location_Id : in Location_Id_Type;
                      The_String : in Unbounded_String)
   return String;

end App_Common_Functions_Pkg;
