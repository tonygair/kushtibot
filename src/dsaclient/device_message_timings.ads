
-- this package is to make sure that devices have sent their information
-- if there has been no message from this device in a certain time period then devices are asked
with Ada.Calendar; use Ada.Calendar;

package Device_Message_Timings is


   Device_Max_Id : Positive := 60;


   type Device_Timings_Type is array (1..Device_Max_Id) of Time;

    type Device_Boolean is array (1..Device_Max_Id) of Boolean;


   protected Last_Device_Update is

      procedure Register_An_Update ( Device_Number : in Positive);

      procedure Set_Update_Time (How_Long : in Duration);

      function Ripe_For_Update (Device_Number : in positive) return boolean;

   private
      Max_Device_Id : Positive := 1;
      How_Long_Delay : Duration := 120.0;
      Timings : Device_Timings_Type;
      Ever_Read : Device_Boolean := (others => false);
   end Last_Device_Update;


   end Device_Message_Timings;
