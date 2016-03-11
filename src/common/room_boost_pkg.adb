with Ada.Calendar; use Ada.Calendar;
with Gnoga;
with Message_Server_Types_Pkg; use Message_Server_Types_Pkg;
package body Room_Boost_Pkg is

   type Boost_Type is new integer range  -2..2;


   type Room_Boost_Array_Type is array(Location_Id_Type, Room_Id_Type) of
     Boost_Type;

   type Location_Boost_Duration_Array_Type is array ( Location_Id_Type) of
     Duration;

   type Location_Boost_Temp_Array_Type is array ( Location_Id_Type) of
        Temp_Xten_Type;

   type Location_Time_Array_Type is array (Location_Id_Type) of Ada.Calendar.Time;



   protected  Boost_Settings is

         procedure Set_Time_Period
           ( Location_Id : Location_Id_Type;
             Value : in Duration);

         function Get_Time_Period
           (Location_Id : Location_Id_Type)
            return Duration;

      procedure Set_Boost_Amount
        (Location_Id : in Location_Id_Type;
         Amount : in Temp_Xten_Type);

      function Get_Boost_Amount
        (Location_Id : in Location_Id_Type)
        return Temp_Xten_Type;

      procedure Apply_Boost
        (Location_Id : in Location_Id_Type;
         Room_Id : in Room_Id_Type;
         Boost_Level : in Boost_Type);


      function Current_Boost
        (Location_Id : in Location_Id_Type;
         Room_Id: in Room_Id_Type) return Boost_Type;

      function Get_Wanted_Increase
         (Location_Id : in Location_Id_Type;
         Room_Id: in Room_Id_Type) return Temp_Xten_Type;

   private

      Location_Room_Array : Room_Boost_Array_Type := (others => (others => 0));
      Duration_Periods : Location_Boost_Duration_Array_Type := (others => 7200.0);
      Boost_Amounts : Location_Boost_Temp_Array_Type := (others => 20);
   end Boost_Settings;

   --Type Location_Boost_Array is array (Location_Id_Type) of Boost_Settings_Type;





   -- this is the usual method of access;






   Boost_Active ,
   End_Boost_Request : P_LR_Boolean_Array_Type;




   Task Type Timer_Task_Type is
      entry Start_The_Task
        ( Entry_Location_Id : in Location_Id_Type;
          Entry_Room_Id : in Room_Id_Type;
          Entry_Direction : in Direction_Type);


   end Timer_Task_Type;


   Task body Timer_Task_Type is separate;

   type Timer_Task_Access is access Timer_Task_Type;



 protected body Boost_Settings is

        procedure Set_Time_Period
           ( Location_Id : Location_Id_Type;
             Value : in Duration) is

      begin
         Duration_Periods(Location_Id) := Value;
         end Set_Time_Period;

         function Get_Time_Period
           (Location_Id : Location_Id_Type)
            return Duration is
      begin
         return Duration_Periods(Location_Id);
      end Get_Time_Period;

     procedure Set_Boost_Amount
        (Location_Id : in Location_Id_Type;
         Amount : in Temp_Xten_Type) is
      begin
         Boost_Amounts(Location_Id) := Amount;
      end Set_Boost_Amount;

      function Get_Boost_Amount
        (Location_Id : in Location_Id_Type)
         return Temp_Xten_Type is
      begin
         return Boost_Amounts(Location_Id);
         end Get_Boost_Amount;

      procedure Apply_Boost
        (Location_Id : in Location_Id_Type;
         Room_Id : in Room_Id_Type;
         Boost_Level : in Boost_Type) is

      begin
         Location_Room_Array (Location_Id, Room_Id) := Boost_Level;
      end Apply_Boost;



      function Current_Boost
        (Location_Id : in Location_Id_Type;
         Room_Id: in Room_Id_Type) return Boost_Type is
      begin
         return Location_Room_Array(Location_Id,Room_Id);
      end Current_Boost;

      function Get_Wanted_Increase
        (Location_Id : in Location_Id_Type;
         Room_Id: in Room_Id_Type) return Temp_Xten_Type is

         The_Boost : Boost_Type := Current_Boost
           (Location_Id => Location_Id,
            Room_Id => Room_Id);

         Amount : Temp_Xten_Type := Get_Boost_Amount
           (Location_Id => Location_Id);
      begin
         return (Temp_Xten_Type (The_Boost) *Amount);
      end Get_Wanted_Increase;




   end Boost_Settings;


--******************* Spec functions / procedures

      procedure Apply_Boost
     ( Location_Id : in Location_Id_Type;
       Room_Id : in Room_Id_Type;
       Direction : in Direction_Type;
       Success : out boolean) is
      Current_Boost : Boost_Type:= Boost_Settings.Current_Boost
        (Location_Id => Location_Id,
         Room_Id     => Room_Id);

   begin

      Gnoga.log("The Current Boost is " & Current_Boost'img &
                  " at location " & Location_Id'img &
                  " and room " & Room_Id'img);
      If (Current_Boost = Boost_Type'last and Direction = Warmer)
        or (Current_Boost = Boost_Type'first and Direction = Colder) then
         Success := false;
      else

         if  Boost_Active.Get_Value(Location_Id, Room_Id) then
            Gnoga.log("Boost already active ");
            End_Boost_Request.Set_Value
              (Location_Id => Location_Id,
               Room_Id     => Room_Id ,
               Value       => true);

            while Boost_Active.Get_Value(Location_Id, Room_Id) loop
               gnoga.log(" Room " & Room_Id'img & " delaying until timer task finishes early ");
               delay 1.5;

            end loop;
            Gnoga.log("Already active Boost Ended");
         end if;


         Gnoga.log ("Now Starting timer " & Current_Boost'img & " to room id " & Room_Id'img &
                      " at location id " & Location_Id'img);
         declare
            New_Timer_Task : Timer_Task_Access;
         begin
            New_Timer_Task := new Timer_Task_Type;
            New_Timer_Task.Start_The_Task
              (Entry_Location_Id => Location_Id,
               Entry_Room_Id => Room_Id,
               Entry_Direction => Direction);
             Gnoga.log ("Started timer " & Current_Boost'img & " to room id " & Room_Id'img &
                      " at location id " & Location_Id'img);
         end;
         Success := true;
      end if;


   end Apply_Boost;



   function Get_Current_Boost (Location_Id : Location_Id_Type;
                               Room_Id : Room_Id_Type ) return Boost_Type is
   begin
      return Boost_Settings.Current_Boost(Location_Id => Location_Id,
                                          Room_Id     => Room_Id);
   end Get_Current_Boost;

    procedure Set_Boost_Amount
     ( Location_Id : in Location_Id_Type;
       Amount : in Temp_Xten_Type ;
       Success : out boolean) is

   begin
      if Amount < 51 and Amount >  4 then
         Boost_Settings.Set_Boost_Amount
           (Location_Id => Location_Id,
            Amount      => Amount);
         Success := true;
      else
         Success := false;
      end if;
   end Set_Boost_Amount;

   function Get_Current_Temperature_Boost

     (Location_Id : in Location_Id_Type;
      Room_Id : in Room_Id_Type ) return Temp_Xten_Type is

   begin

      return Boost_Settings.Get_Wanted_Increase
        (Location_Id => Location_Id,
         Room_Id     => Room_Id);
   end Get_Current_Temperature_Boost;

 procedure Set_Boost_Time
     (Location_Id : in Location_Id_Type;
      Boost_Time : in Duration;
      Success : out boolean) is
   begin
      if Boost_Time > Maximum_Boost_Duration or
        Boost_Time < Minimum_Boost_Duration then
         Success := false;
      else
         Boost_Settings.Set_Time_Period
           (Location_Id => Location_Id,
            Value       => Boost_Time);
      end if;
   end Set_Boost_Time;

  function Get_Boost_Screen_Status (Location_Id : in Location_Id_Type;
                                     Room_Id  : in Room_Id_Type  ) return string is
      Current_Boost : Boost_Type := Boost_Settings.Current_Boost
        (Location_Id => Location_Id,
         Room_Id     => Room_Id);
   begin
      case Current_Boost is
         when -2 =>
            return "Minus 4 degrees ";
         when -1 =>
            return "Minus 2 degrees ";
         when 0 =>
            return "No temporary boost is currently applied";
         when 1 =>
            return "Plus 2 degrees ";
         when 2 =>
            return "Plus 4 degrees";
      end case;
   end Get_Boost_Screen_Status;



   ---************end *****************************************

end Room_Boost_Pkg;
