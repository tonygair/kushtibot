with Alarm; use Alarm;
with Alert_Buffer; use Alert_Buffer;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
package body Message is

   -- need to define two locationfifo po types

--     procedure Device_Update
--       (Terminal : access Alarm_Terminal;
--        Location_Id : in Location_Id_Type;
--        Device_Address : in Rf_Address) is
--
--     begin
--        Device_Buffer.Push(Item     => Device_Address,
--                           Location => Location_Id);
--     end Device_Update;

   procedure Temperature_Update
     (Terminal : access Alarm_Terminal;
     TC : in TC_Change_Record)  is
   begin
      TC_Buffer.Push
        (Item     => TC,
         Location => TC.Location);
   end Temperature_Update;

   procedure User_Update
     (Terminal : access Alarm_Terminal;
      User : in String) is

   begin
      User_Buffer.Push(Item => To_Unbounded_String(User));
   end User_Update;







end Message;
