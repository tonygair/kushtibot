with Gnoga;
with Ada.Exceptions;
package body Device_Message_Timings is




   protected body  Last_Device_Update is

      procedure Register_An_Update ( Device_Number : in Positive) is

      begin
         if Device_Number > Max_Device_Id then
            Max_Device_Id := Device_Number;
         end if;
         if Device_Number > 0 and Device_Number <= Device_Max_Id then
            Timings(Device_Number) := Ada.Calendar.Clock;
            Ever_Read (Device_Number) := true;
         else

         Gnoga.log("Device_Message_Timings-Strange Device Number " & Device_Number'img);
         end if;
                    exception
               when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

      end Register_An_Update;


      procedure Set_Update_Time (How_Long : in Duration) is


      begin
         Gnoga.log("Message Device Timings - Updated Delay from " & How_Long_Delay'img
                    & " to :- " & How_Long'img);
         How_Long_Delay := How_Long;
                    exception
               when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

      end Set_Update_Time;


      function Ripe_For_Update (Device_Number : in positive) return boolean is
         Return_Value : boolean := false;
      begin
         if Ever_Read (Device_Number) then
            if Last_Device_Update.Timings(Device_Number) + How_Long_Delay < Clock then
             Return_Value := true;
            end if;
         else
            Return_Value := true;
         end if;
         return Return_Value;
                    exception
               when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));
            return false;

      end Ripe_For_Update;


--     private
--        Max_Device_Id : Positive := 0;
--        How_Long_Delay : Duration := 120.0;
--        Timings : Device_Timings_Type;
--        Ever_Read : Device_Boolean := (others => false);
   end Last_Device_Update;


   end Device_Message_Timings;
