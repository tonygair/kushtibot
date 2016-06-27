

with Tables;
with Ada.Calendar; use Ada.Calendar;
with Ada.Calendar.Conversions; use Ada.Calendar.Conversions;
with Interfaces.C; use Interfaces.C;
package body Booking_Record_Pkg is



   package Booking_Table_Pkg is new Tables(Tag => Booking_Record);


   function Booking_Hash (The_Record : in Booking_Record) return string is

   function Bookings_Clash (Left, Right : in Booking_Record) return boolean is
      Left_Start   : Ada.Calendar.Time :=
        To_Ada_Time(Unix_Time =>Long( Left.The_Time));
      Left_End : Ada.Calendar.Time := Left_Start + Left.Booking_Length;

      Right_Start   : Ada.Calendar.Time :=
        To_Ada_Time(Unix_Time =>Long( Right.The_Time));
      Right_End : Ada.Calendar.Time := Right_Start + Right.Booking_Length;

      Return_Result : Boolean := false;

   begin
      if (Left_Start >= Right_Start and Left_End <= Right_End) or
        (Right_Start >= Left_Start and Right_Start <= Left_End) or
        (Right_End >= Left_Start and Right_End <= Left_End) then
         Return_Result := true;
      end if;
      return Return_Result;
   end Bookings_Clash;


   protected type Booking_Po is

      function Get_All_Bookings return Booking_Record_Array;

      function Get_Room_Bookings (Room_Id : in Room_Id_Type) return Booking_Record_Array;

      function Get_Room_Bookings_By_Day
                               (Room_Id : in Room_Id_Type;
                                Time : in Ada.Calendar.TIme) return Booking_Record_Array;


      procedure Purge_Past_Bookings;

      procedure Add_Booking_Record (The_Record : in Booking_Record);

      procedure Delete_Booking_Record ( The_Record : in Booking_Record);


   private
           Booking_Table : Booking_Table_Pkg.Table;

   end Booking_Po;





   type Booking_Po_Access is access Booking_Po;

   type Booking_Po_Access_Array is array ( Location_Id_Type) of Booking_Po_Access;


   type Location_Room_Bookable_Array is array (Location_Id_Type) of boolean;


end Booking_Record_Pkg;



