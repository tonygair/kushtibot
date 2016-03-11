with App_Common_Functions_Pkg;
with Gnoga;
package body Date_Functions_Pkg is

   function String_To_Date (The_Time : in String) return Time is
         Day : Day_Number;
   Month : Month_Number;
   Year : Year_Number;
   Return_Value : Time;
begin
   if The_Time'length=10 then
      Year := App_Common_Functions_Pkg.Convert_Text_To_Integer(The_Time(1..4));
      Month:= App_Common_Functions_Pkg.Convert_Text_To_Integer(The_Time(6..7));
      Day := App_Common_Functions_Pkg.Convert_Text_To_Integer(The_Time(9..10));
      Return_Value := Time_Of(Year    => Year,
                                 Month   => Month,
                                 Day     => Day);
      return Return_Value;
   else raise Time_Error;

   end if;
end String_To_Date;


   function Date_To_String  (The_Time : in Time) return String is

      Day : Day_Number;
      Month : Month_Number;
      Year : Year_Number;
      Seconds : Day_Duration;
      Day_String : String(1..2);
      Month_String : String(1..2);
      Year_String : String(1..4);

      -- represented YYYY-MM-DD
      Return_Value : string (1..10) := (others => '-');
   begin
      Split(Date    => The_Time,
               Year    => Year,
               Month   => Month,
               Day     => Day,
              Seconds => Seconds);
      declare
         Day_Image : constant string := Day'img;
         Month_Image : constant string := Month'img;
         Year_Image  : constant string := Year'img;

      begin
         Gnoga.log("*" & Year_Image & "*");
         if Day < 10 then
            Day_String :=Day_Image(1..2);
            Day_String (1..1) := "0";
         elsif Day < 32 then
            Day_String(1..2) := Day_image(2..3);
         else
            raise Time_Error;
          end if;

          if Month < 10 then
            Month_String :=Month_Image(1..2);
            Month_String (1..1) := "0";
         else
            Month_String(1..2) := Month_image(2..3);

          end if;
          Year_String := Year_Image(2..5);
         Return_Value(1..4) := Year_String;
         Return_Value(6..7) := Month_String;
         Return_Value(9..10) :=Day_String;
      end;

      return Return_Value;
   end Date_To_String;


end Date_Functions_Pkg;
