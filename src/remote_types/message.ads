with Alarm; use Alarm;
--with Types; use Types;
with Identity_Types_Pkg; use Identity_Types_Pkg;

package Message is

   pragma Remote_Types;

   type Alarm_Terminal is new Terminal_Type with null record;


--      procedure Device_Update
--       (Terminal : access Alarm_Terminal;
--        Location_Id : in Location_Id_Type;
--        Device_Address : in Rf_Address);


   procedure Temperature_Update
     (Terminal : access Alarm_Terminal;
      TC : in TC_Change_Record) ;

   procedure User_Update
     (Terminal : access Alarm_Terminal;
      User : in String);

end Message;
