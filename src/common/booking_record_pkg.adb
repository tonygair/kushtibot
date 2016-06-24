

with Tables;
package body Booking_Record_Pkg is

   type Booking_Table_Pkg is new Tables(Tag => Booking_Record);

   function Booking_Hash (The_Record : in Booking_Record) return string;

   protected type Booking_Po is

      function Get_All_Bookings return Booking_Record_Array;

      function Get_Room_Bookings (Room_Id : in Room_Id_Type) return Booking_Record_Array;

      function Get_Room_Bookings_By_Day (Room_Id : in Room_Id_Type;

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



