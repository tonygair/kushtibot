with Identity_Types_Pkg; use Identity_Types_Pkg;
with Booking_Types_Pkg; use Booking_Types_Pkg;


package Booking_Record_Pkg is



     Blank_Booking_Record : constant Booking_Record :=
     (The_Location => 0,
      Room_Id => 0,
      The_Time => 0,
      Booking_Length => 0.0,
      Booking_Text => (others => 'X'));


   Blank_Booking_Array : constant Booking_Record_Array (1..0) :=
     (others => Blank_Booking_Record);


   procedure Add_Booking_Record (The_Record : in Booking_Record);

   procedure Delete_Booking_Record (The_Record : in Booking_Record);

   function Fetch_Valid_Bookings
     (Location : in Identity_Types_Pkg.Location_Id_Type)  return Booking_Record_Array;

   function Fetch_Rooms_Bookings
     (Location : in Identity_Types_Pkg.Location_Id_Type;
      Room_Id : in Identity_Types_Pkg.Room_Id_Type) return Booking_Record_Array;

   function Room_Bookable
     (Location : in Location_Id_Type;
      Room_Id : in Room_Id_Type) return boolean;

   procedure Set_Bookable
      (Location : in Location_Id_Type;
       Room_Id : in Room_Id_Type;
      Bookable : in Boolean) ;

   procedure Purge_Past_Bookings;







end Booking_Record_Pkg;
