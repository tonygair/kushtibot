with Ada.Characters.Latin_1;
with Strings_Edit.Float_Edit;
--with Text_IO; use Text_IO;
with Ada.Exceptions;
with Gnoga;
package body App_Common_Functions_Pkg is

   Convert_Error : exception;

   package Float_Edit is new Strings_Edit.Float_Edit(Float);

   function Character_To_Number
     (The_Char : in Character) return integer is
      Return_Value : Integer := 0;
   begin
      if Character'pos(The_Char) in  48..57 then
         Return_Value := Character'pos(The_Char)  - 48;
      else
         raise Convert_Error;
      end if;
      return Return_Value;
exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));


   end Character_To_Number;


   function Convert_Text_To_Integer (The_Text : in String)
                                     return Integer is
      Place : Integer := 0;
      Return_Value : Integer :=0;
   begin
       for Count in reverse The_Text'first..The_Text'last loop

         if The_Text(Count) = ' ' then
            exit;
         end if;

         Return_Value := Return_Value +
           (Character_To_Number(The_Text(Count)) *(10**Place));
         Place := Place + 1;
      end loop;
      return Return_Value;
      exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));


   end Convert_Text_To_Integer;


   function Temp_Xten_Image (Temp : in Temp_Xten_Type) return string is

      Degree_Character : Character := Ada.Characters.Latin_1.Degree_Sign;
      First_Modulo : constant Integer := Integer(Temp) mod 10;
      Second_Modulo : constant Integer := (Integer(Temp) - First_Modulo) mod 100;
      Third_Modulo : constant Integer := integer(Temp) - (Second_Modulo + First_Modulo);

      First_String : constant String := First_Modulo'img;
      Second_String : constant String := Second_Modulo'img;
      Third_String : constant String := Third_Modulo'img;
      First_Character : string := First_String(2..2);
      Second_Character : string := Second_String(2..2);
      Third_Character : string := Third_String(2..2);

   begin
      if Temp > 99 or Temp < -99 then
      return Third_Character & Second_Character& '.' & First_Character &
        'C';
      else
         return Second_Character & '.' & First_Character & 'C';
      end if;
exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Temp_Xten_Image;

   --notsure this is needed as we will always refer to the data stored

   --function Temp_Xten_Numeric ( The_Text : in string) return Temp_Xten_Type;

   function Strip_First_Space (The_String : String) return String is

   begin
      if The_String'length > 1  then
        if The_String(1) =' ' then
         return The_String(2..The_String'length);
      else
         return The_String;
         end if;
      else
         return The_String;
      end if;
exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Strip_First_Space;

   function String_To_Xten(The_String : in String ) return Temp_Xten_Type is
      Return_Value : Temp_Xten_Type;
      Temp_Value : Float;
   begin
      Temp_Value := Float_Edit.Value(Source => The_String) ;
      Gnoga.log("******&&&& set point " & integer(Temp_Value)'img);
      Return_Value := Temp_Xten_Type(Temp_Value * 10.0);
      return Return_Value;
     exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end String_To_Xten;

   -- this function checks for nullness and that the first space is not a blank
   function Check_String_Input (The_String : in String) return boolean is
      Return_Value : boolean := true;
      --String_Length : Natural := The_String
      subtype Acceptable_Range is  character range '0'..'z';
   begin
      if The_String'length > 0 and The_String'length < 51 then
         if The_String(The_String'first) = ' ' or
           The_String(The_String'last) = ' ' then
            Return_Value := false;
         elsif The_String'length > 2 then

         for count in 1..(The_String'last -1) loop
            --check for double spaces cos thats bbbbaaaaddd
            if The_String(count..count+1) = "  " then
               Gnoga.log("Double space detected in " & The_String);
               Return_Value := false;
             exit;
           end if;
         end loop;
         end if;
      else
         Return_Value := false;
      end if;
      return Return_Value;
   end Check_String_Input;

   function Overlay_String_Value (The_String : in String) return String is
      Return_String : String (1..50) := (others => ' ');
      String_Length : Natural := The_String'length;
   begin
      if String_Length > 0 then
         If String_Length < 51 then
            Return_String (1..String_Length) := The_String(1..String_Length);
         else
            Return_String := The_String(1..50);
         end if;
      end if;
      return Return_String;
   end Overlay_String_Value;

function To_String (Location_Id : in Location_Id_Type;
                       The_String : in Unbounded_String) return String is
   begin
      return To_String(The_String);
   end To_String;


   end App_Common_Functions_Pkg;
