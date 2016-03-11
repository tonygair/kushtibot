with Identity_Types_Pkg; use Identity_Types_Pkg;

package Alarm is

   pragma Pure;
   type Terminal_Type is abstract tagged limited private;



   -- the following procedures warn the terminals that data has changed
   -- and only use meta data to tell us this.
   -- terminals will then go and get the data to update on which client it is.


--     procedure Device_Update
--       (Terminal : access Terminal_Type;
--        Location_Id : Location_Id_Type;
--        Device_Address : in Rf_Address) is abstract;


   procedure Temperature_Update
     (Terminal : access Terminal_Type;
      TC : in TC_Change_Record) is abstract;

   procedure User_Update
     (Terminal : access Terminal_Type;
      User : in string) is abstract;

private
   type Terminal_Type is abstract tagged limited null record;


end Alarm;
