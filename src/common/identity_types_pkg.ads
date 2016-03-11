package Identity_Types_Pkg is


   pragma pure;

   type Device_Index_Type is new Integer range 0..255;


   -- Idx type is for communications with the domoticz controller
   -- to control the Zwave


   type Idx_Id_Type is new Integer range 0..1024;

   type Schedule_Id_Type is new integer range 0..20;

   type Room_Id_Type is new Integer range 0..50;

   subtype Location_Id_Type is Natural range 0..1000;

   type Serial_Type is new string(1..10);

   Blank_Serial : constant Serial_Type := (others => 'X');

   Good_Password_No_Serial : constant Serial_Type := (others => 'Z');
   Bad_Password_Serial : constant Serial_Type := (others =>'Y');

   type C_Centigrade is delta 0.1 digits 4 range -4.0..135.0;
   subtype C_Set_Centigrade is C_Centigrade range 0.0..63.5;
   type User_Transfer_Record (User_Length, Password_Length : Natural)
   is record
      User : string ( 1..User_length);
      Password : string ( 1..Password_Length);
      Is_Admin : boolean;
      Serial_Number : Serial_Type;
   end record;

   Blank_UTR : constant User_Transfer_Record :=
     (User_Length => 0,
      Password_Length => 0,
      User => (others => 'X'),
      Password => (others => 'X'),
      Is_Admin => false,
      Serial_Number => (others => 'X'));



   type Room_Information_Record (Roomname_Length : natural)
   is
      Record
         Location : Identity_Types_Pkg.Location_Id_Type;
         Room : Room_Id_Type;
         Set_Point : C_Centigrade;
         Actual : C_Centigrade;
         Error_In_Room : Boolean;
         Link_Error : Boolean;
         Battery_Low : Boolean;
         Room_Name :String (1..Roomname_Length);
      end Record;

   Blank_Room_Name : constant string := "Blank ROOM Record";

   Blank_RIR : constant Room_Information_Record :=
     (Roomname_Length => Blank_Room_Name'length,
      Location =>  0,
      Room => 0,
      Set_Point => 18.0,
      Actual => 18.0,
      Error_In_Room => false,
      Link_Error => false,
      Battery_Low => false,
      Room_Name => Blank_Room_Name);

   --type Rir_Array_Type is array (Room_Id_Type range <>)
   --  of Room_Information_Record;

   type Energy_Mode_Type is (Economy_Mode, Comfort_Mode);

   type Mode_Temperature_Type is array(Energy_Mode_Type) of C_Set_Centigrade;

   Blank_Mode_Temperature : constant Mode_Temperature_Type := (others => 15.0);

   subtype Hour_Day_Schedule_Type is natural range 0..23;

   subtype Points_In_Day_Type is natural range 0..13;


   type Day_Schedule_Type is array(Points_In_Day_Type range <> ) of Hour_Day_Schedule_Type;

  Blank_Day_Schedule : constant Day_Schedule_Type(1..0) := (others=> (0));



--     type Complete_Day_Schedule_Type (Command_Size : Points_In_Day_Type) is record
--        Temperatures : Mode_Temperature_Type :=
--          (Economy_Mode => 18.0,
--           Comfort_Mode => 22.0);
--        Schedule : Day_Schedule_Type(1..Command_Size);
--     end record;

   type Weekday_Type is (Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday);




   type TC_Change_Type is (RIR_Update,  Schedule_Update);

   type TC_Change_Record is record
      Location : Location_Id_Type;
      Room : Room_Id_Type;
      Day : Weekday_Type;
      TC_Change : TC_Change_Type;

   end record;




end Identity_Types_Pkg;
