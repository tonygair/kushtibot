
with Identity_Types_Pkg; use Identity_Types_Pkg;
with Gnoga.Gui.Element.Common;
--with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;

Package UI_Related_Access_Types_Pkg  is


type RIR_Access is Access Room_Information_Record;

 type String_Access_Type is Access String;

  type Room_Array_Type is  array (Room_ID_Type range <>) of RIR_Access;

 type Room_Array_Access is access Room_Array_Type;

  type Day_Schedule_Access is access Day_Schedule_Type;

    type Week_Schedule_Type is array (Weekday_Type) of Day_Schedule_Access;

 type Room_Button_Array_Type is Array(Room_Id_Type range <>) of
     Gnoga.Gui.Element.Common.Button_Type;

   type Room_Button_Array_Access is access Room_Button_Array_Type;

type Location_Array_String_Type is array(Location_Id_Type) of String_Access_Type;

end UI_Related_Access_Types_Pkg;
