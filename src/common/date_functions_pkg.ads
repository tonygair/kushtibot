with Ada.Calendar; use Ada.Calendar;
package Date_Functions_Pkg is

   function String_To_Date (The_Time : in String) return Time;


   function Date_To_String  (The_Time : in Time) return String;



end Date_Functions_Pkg;
