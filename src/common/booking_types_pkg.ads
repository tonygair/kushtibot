with Identity_Types_Pkg;

package Booking_Types_Pkg is

pragma pure;


  type Booking_Record is record
      The_Location : Identity_Types_Pkg.Location_Id_Type;
      Room_Id : Identity_Types_Pkg.Room_Id_Type;
      The_Time : Long_Integer;
      Booking_Length : Duration;
      Booking_Text : String (1..50);
   end record;


   subtype Max_Bookings_Type is Natural range 0..1000;


    type Booking_Record_Array is array (Max_Bookings_Type range <>)
     of Booking_Record;

end Booking_Types_Pkg;
