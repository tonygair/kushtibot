separate(Room_Boost_Pkg)

Task body Timer_Task_Type is
   Location_Id : Location_Id_Type;
   Room_Id : Room_Id_Type;
   Finish_Time : Ada.Calendar.Time;
   Direction : Direction_Type;
   Current_Boost : Boost_Type;
begin
   Gnoga.log("Start Timer Task");
   accept Start_The_Task
     ( Entry_Location_Id : in Location_Id_Type;
       Entry_Room_Id : in Room_Id_Type;
       Entry_Direction : in Direction_Type) do


      Location_Id :=  Entry_Location_Id;
      Room_Id := Entry_Room_Id;
      Finish_Time := Ada.Calendar.Clock +
        Boost_Settings.Get_Time_Period(Location_Id => Location_Id);
      Direction := Entry_Direction;

   end Start_The_Task;

   Current_Boost := Boost_Settings.Current_Boost
     (Location_Id => Location_Id,
      Room_Id     => Room_Id);

   case Direction is
      when Warmer =>
         Current_Boost := Current_Boost + 1;
      when Colder =>
         Current_Boost := Current_Boost - 1;
   end case;

   Boost_Settings.Apply_Boost
     (Location_Id => Location_Id,
      Room_Id     => Room_Id,
      Boost_Level => Current_Boost);
   Gnoga.log("New boost is " & Boost_Settings.Current_Boost
             (Location_Id => Location_Id,
              Room_Id     => Room_Id)'img);
   Boost_Active.Set_Value (Location_Id, Room_Id, true);
   loop
      If End_Boost_Request.Get_Value (Location_Id, Room_Id) then
         exit;
      elsif Clock > Finish_Time then
         case Direction is
         when Warmer =>
            Current_Boost := Current_Boost  - 1;
         when Colder =>
            Current_Boost := Current_Boost + 1;
         end case;

         Boost_Settings.Apply_Boost(Location_Id => Location_Id,
                                    Room_Id     => Room_Id,
                                    Boost_Level => Current_Boost);
         exit;
      else
         delay 5.0;
      end if;
   end loop;

   Boost_Active.Set_Value (Location_Id, Room_Id, false);

   Gnoga.log("End Timer Task ");
end Timer_Task_Type;
