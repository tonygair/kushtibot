

with Gnoga.Application.Multi_Connect;
with Gnoga.Gui.Window;
with Gnoga.Gui.View;
with Gnoga.Gui.Element.Common;
with Gnoga.Gui.Element; use Gnoga.Gui.Element;
with Gnoga.Gui.Base;
with Gnoga.Gui.Navigator;
with Gnoga.Gui.Element.List;
with Gnoga.Types;
with Device_Type_Pkg; use Device_Type_Pkg;
with Ada.Strings.Unbounded;
with App_Common_Functions_Pkg; use App_Common_Functions_Pkg;
with Schedule_Types_Pkg; use Schedule_Types_Pkg;
with Gnoga.Gui.Element.Form.Fieldset;
with Gnoga.Gui.Element.List;
with Date_Functions_Pkg;
with App_View_List_Support_Pkg;
with Ada.Exceptions; use Ada.Exceptions;
-- for this
with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;
with Schedules_Rooms_Devices_Indexes_Pkg;
use Schedules_Rooms_Devices_Indexes_Pkg;
with Room_Types_Pkg; use Room_Types_Pkg;
with Identity_Types_Pkg; use Identity_Types_Pkg;
with Schedule_Information_Pkg; use Schedule_Information_Pkg;
with Gnoga.Gui.Window;
with Stringify_Types_Pkg;
--with Abbreviated_Types_Pkg; use Abbreviated_Types_Pkg;
with Schedules_Rooms_Devices_Indexes_Pkg;
with Room_Boost_Pkg;
package body Usna_Status_View_Gnoga_Pkg is


   use Gnoga.Gui;

   package SRN renames Schedules_Rooms_Devices_Indexes_Pkg;




   procedure Populate_Room_Select is new App_View_List_Support_Pkg.Generic_Populate_Select
     (T_Type           => Room_Record,
      Index_Type       => Room_Id_Type,
      T_Array_Type     => SRN.Room_Array_Type,
      Stringify_T_Type => Stringify_Types_Pkg.Stringify_Room_Status);


   procedure On_Room_Select_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App             : App_Access := App_Access(Object.Connection_Data);


      Change_In_Display_Info: Boolean;
      Room_Id : Room_Id_Type;
      Room_List : Room_Array_Type := SRN.Get_All_Rooms
        (Location_Id => App.Location.Location_Id);

      Need_Thermostat_Attaching_Message : String := "No Thermostat(s) in Room";
      Need_Sensor_Attaching_Message : String := "No Temperature Sensors in Room";


   begin
      Change_In_Display_Info :=
        not (App.Status_Record.Current_Room_Index =
               App.Status_Record.Room_Status_Select.Selected_Index);
      App.Status_Record.Current_Room_Index :=
        App.Status_Record.Room_Status_Select.Selected_Index;
      if  App.Status_Record.Room_Status_Select.Selected_Index < 1 or
        App.Status_Record.Room_Status_Select.Selected_Index > integer(Room_Id_Type'last)
      then
         App.Status_Record.Up_Boost_Button.HIdden(Value => True);
         App.Status_Record.Down_Boost_Button.HIdden(Value => True);
         App.Status_Record.Boost_Status.HIdden(Value => True);
      else
        App.Status_Record.Up_Boost_Button.HIdden(Value => False);
         App.Status_Record.Down_Boost_Button.HIdden(Value => False);
         App.Status_Record.Boost_Status.HIdden(Value => False);

       end if;
      if Change_In_Display_Info then
         Room_Id := Room_Id_Type
           (App.Status_Record.Room_Status_Select.Selected_Index);

         Gnoga.Log("Change needed in display information for " & Room_Id'img);
         declare
            Device_List : Device_List_Type :=
              Get_Device_List(Location_Id => App.Location.Location_Id,
                              Room_Id => Room_Id);
            Thermostat_Number : Natural :=
              Number_Of_Thermostats(Location_Id => App.Location.Location_Id,
                                    Room_Id => Room_Id);
            Sensor_Number: Natural :=
              Number_Of_Sensors(Location_Id => App.Location.Location_Id,
                                Room_Id => Room_Id);

            The_Room : Room_Record := Get_Room
              (Location_Id => App.Location.Location_Id,
               Room_Id     => Room_Id);


         begin

            App.Status_Record.Boost_Status.Text
              (Value =>  Room_Boost_Pkg.Get_Boost_Screen_Status
                 (Location_Id => App.Location.Location_Id,
                  Room_Id     => Room_Id));


            App.Status_Record.Room_Label.Text
              (Value => The_Room.Room_Name(1..The_Room.Room_Name_Length));

            if The_Room.Schedule_Id = 0 then
               App.Status_Record.Schedule_Label.Text
                 (Value => "No Schedule is Attached to this Room ");
            else
               App.Status_Record.Schedule_Label.Text
                 (Value => "Schedule is : " & Schedule_Id_To_Name
                    (Location_Id => App.Location.Location_Id,
                     Schedule_Id => The_Room.Schedule_Id));
            end if;

            App.Status_Record.Number_Of_Thermostats.
              Text( Thermostat_Number'img & " thermostat(s) are in use in this room ");
            App.Status_Record.Number_Of_Sensors.
              Text(Sensor_Number'img & " temperature sensor(s) are in use in this room ");
            if Sensor_Number = 0 then

               App.Status_Record.Actual_Temperature_Label.Text
                 (Need_Sensor_Attaching_Message);
            elsif Sensor_Number = 1 then
               App.Status_Record.Actual_Temperature_Label.
                 Text("Actual Temperature : " &
                        Stringify_Types_Pkg.Room_Temperature_String
                        (Location_Id => App.Location.Location_Id,
                         Room_Id => Room_Id));
            else
               App.Status_Record.Actual_Temperature_Label.
                 Text("Average Temperature : " &
                        Stringify_Types_Pkg.Room_Temperature_String
                        (Location_Id => App.Location.Location_Id,
                         Room_Id => Room_Id));

            end if;
            if Thermostat_Number = 0 then
               App.Status_Record.Setpoint_Temperature_Label.Text
                 (Need_Thermostat_Attaching_Message);
            elsif Thermostat_Number = 1 then
               App.Status_Record.Setpoint_Temperature_Label.Text
                 (" Setpoint Temperature : " &
                    Stringify_Types_Pkg.Room_Setpoint_String
                    (Location_Id => App.Location.Location_Id,
                     Room_Id => Room_Id));
            else
               App.Status_Record.Setpoint_Temperature_Label.
                 Text(" Average Setpoint Temperature : " &
                        Stringify_Types_Pkg.Room_Setpoint_String
                        (Location_Id => App.Location.Location_Id,
                         Room_Id => Room_Id));
            end if;

         end;

      end if;

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Room_Select_Click;

    procedure On_Up_Boost_Button_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App             : App_Access := App_Access(Object.Connection_Data);

      Room_Id : Room_Id_Type;
      Success : boolean;
      Theres_A_Change : boolean := false;
   begin
      -- disable both boost buttons
      App.Status_Record.Up_Boost_Button.Disabled(Value => true);
      App.Status_Record.Down_Boost_Button.Disabled(Value => true);

      if  App.Status_Record.Room_Status_Select.Selected_Index < 1 or
        App.Status_Record.Room_Status_Select.Selected_Index > integer(Room_Id_Type'last) then null;
      else
         Room_Id := Room_Id_Type (App.Status_Record.Room_Status_Select.Selected_Index ) ;
         Gnoga.log(" Room with ID " & Room_Id'img & " up boost button " );
         Room_Boost_Pkg.Apply_Boost
           (Location_Id => App.Location.Location_Id,
            Room_Id     => Room_Id,
            Direction   => Room_Boost_Pkg.Warmer,
            Success     => Success) ;



      end if;


      delay 0.5;

       Gnoga.log("1- Boost at " & Room_Boost_Pkg.Get_Boost_Screen_Status
                (Location_Id => App.Location.Location_Id,
                 Room_Id     => Room_Id));

      App.Status_Record.Up_Boost_Button.Disabled(Value => false);
      App.Status_Record.Down_Boost_Button.Disabled(Value => false);

      App.Status_Record.Boost_Status.Text
        (Value =>  Room_Boost_Pkg.Get_Boost_Screen_Status
           (Location_Id => App.Location.Location_Id,
            Room_Id     => Room_Id));
       Gnoga.log("1- Boost at " & Room_Boost_Pkg.Get_Boost_Screen_Status
                (Location_Id => App.Location.Location_Id,
                 Room_Id     => Room_Id));


   end On_Up_Boost_Button_Click;

       procedure On_Down_Boost_Button_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App             : App_Access := App_Access(Object.Connection_Data);

      Room_Id : Room_Id_Type;
      Success : boolean;
   begin
 App.Status_Record.Up_Boost_Button.Disabled(Value => true);
      App.Status_Record.Down_Boost_Button.Disabled(Value => true);

      if  App.Status_Record.Room_Status_Select.Selected_Index < 1 or
        App.Status_Record.Room_Status_Select.Selected_Index > integer(Room_Id_Type'last) then null;
      else
         Room_Id := Room_Id_Type (App.Status_Record.Room_Status_Select.Selected_Index ) ;
        Gnoga.log(" Room with ID " & Room_Id'img & " down boost button " );
          Room_Boost_Pkg.Apply_Boost
           (Location_Id => App.Location.Location_Id,
            Room_Id     => Room_Id,
            Direction   => Room_Boost_Pkg.Colder,
            Success     => Success) ;





      end if;

      delay 0.5;
       App.Status_Record.Up_Boost_Button.Disabled(Value => false);
         App.Status_Record.Down_Boost_Button.Disabled(Value => false);

      Gnoga.log("1- Boost at " & Room_Boost_Pkg.Get_Boost_Screen_Status
                (Location_Id => App.Location.Location_Id,
                 Room_Id     => Room_Id));
      App.Status_Record.Boost_Status.Text
           (Value =>  Room_Boost_Pkg.Get_Boost_Screen_Status
              (Location_Id => App.Location.Location_Id,
               Room_Id     => Room_Id));
      Gnoga.log("2- Boost at " & Room_Boost_Pkg.Get_Boost_Screen_Status
                (Location_Id => App.Location.Location_Id,
               Room_Id     => Room_Id));

   end On_Down_Boost_Button_Click;


   procedure Build_Status_View
     (App : in out App_Access) is

      Image_Holder  : Gnoga.Gui.Element.Common.DIV_Type;
      The_Image  : Gnoga.Gui.Element.Common.IMG_Type;
      --Matched_Image : Gnoga.Gui.Element.Common.IMG_Type;

   begin

      Image_Holder.Create(Parent => App.Form_Array(Status_View));

      Image_Holder.Place_After(App.Nav_Array(Status_View));

      The_Image.Create(Image_Holder,
                       "img/status.jpg");



      -- title Widget
      App.Status_Record.Title_Label.Create
        (Parent => App.Form_Array(Status_View),
         Content => "<H1>Room Status View<H1>");

      App.Status_Record.Title_Label.Place_After
        (App.Nav_Array(Status_View));




      App.Status_Record.Control_Fset.Create
        (Parent => App.Form_Array(Status_View));

      App.Status_Record.Control_Fset.Put_Legend
              (Value => "Room Details" );

      App.Status_Record.Room_Status_Select.Create
        (Form=>App.Form_Array(Status_View),
         Multiple_Select => false,
         Visible_Lines => 8);

      Gnoga.log("Pre select");
      declare
         Rooms_List : SRN.Room_Array_Type :=
           SRN.Get_All_Rooms(Location_Id => App.Location.Location_Id);
      begin
         Populate_Room_Select
           (Location_Id => App.Location.Location_Id,
            The_Select => App.Status_Record.Room_Status_Select,
            T_Array =>Rooms_List);

      end;
      Gnoga.log("Post select");

       App.Status_Record.Room_Label.Create
        (Parent  =>App.Status_Record.Control_Fset ,
         Content => "");

      App.Status_Record.Control_Fset.New_Line;


      App.Status_Record.Actual_Temperature_Label.Create
        (Parent  =>App.Status_Record.Control_Fset ,
         Content => "");

      --App.Status_Record.Actual_Temperature_Label.Place_Inside_Top_Of
      --  (Target => App.Status_Record.Control_Fset);

      App.Status_Record.Control_Fset.New_Line;


      App.Status_Record.Setpoint_Temperature_Label.Create
        (Parent  =>App.Status_Record.Control_Fset,
         Content => "");

      -- App.Status_Record.Setpoint_Temperature_Label.Place_After
      ---  (Target => App.Status_Record.Actual_Temperature_Label);

      App.Status_Record.Control_Fset.New_Line;







      --  App.Status_Record.Room_Label.Place_After
      --   (Target => App.Status_Record.Setpoint_Temperature_Label);

      App.Status_Record.Schedule_Label.Create
        (Parent  => App.Status_Record.Control_Fset , --App.Form_Array(Status_View) ,
         Content => "");

      --App.Status_Record.Schedule_Label.Place_After
      -- (Target =>App.Status_Record.Room_Label);

      App.Status_Record.Control_Fset.New_Line;


      App.Status_Record.Number_Of_Thermostats.Create
        (Parent  => App.Status_Record.Control_Fset ,
         Content => "");

      -- App.Status_Record.Number_Of_Thermostats.Place_Inside_Top_Of
      --  (Target => App.Status_Record.Schedule_Label);

      App.Status_Record.Control_Fset.New_Line;

      App.Status_Record.Number_Of_Sensors.Create
        (Parent  => App.Status_Record.Control_Fset ,
         Content => "");

      -- App.Status_Record.Number_Of_Sensors.Place_After
      --   (Target => App.Status_Record.Number_Of_Thermostats);

 App.Status_Record.Control_Fset.New_Line;


      App.Status_Record.Boost_Status.Create
        (Parent => App.Status_Record.Control_Fset,
         Content => "" );

       App.Status_Record.Control_Fset.New_Line;

      App.Status_Record.Up_Boost_Button.Create
        (Parent  => App.Status_Record.Control_Fset,
         Content => " Make Warmer ");

       App.Status_Record.Down_Boost_Button.Create
        (Parent => App.Status_Record.Control_Fset,
         Content => " Make Colder ");

      declare
         --for the button colours
         -- color_type is 0..255

         Red_Colour : Gnoga.Types.RGBA_Type := (Red => 125, Green => 50, Blue => 0, Alpha => 0.5);

         Blue_Colour : Gnoga.Types.RGBA_Type := (Red => 0, Green => 0, Blue => 250, Alpha => 0.3);

      begin

        -- App.Status_Record.Up_Boost_Button.Font(Style => "Heading");
          App.Status_Record.Up_Boost_Button.Background_Color
        (RGBA => Red_Colour);

          App.Status_Record.Down_Boost_Button.Background_Color
        (RGBA =>  Blue_Colour);

         App.Status_Record.Up_Boost_Button.HIdden(Value => True);
         App.Status_Record.Down_Boost_Button.HIdden(Value => True);
         App.Status_Record.Boost_Status.HIdden(Value => True);

      end;

     -- wire up the select event

      App.Status_Record.Room_Status_Select.On_Click_Handler
        (On_Room_Select_Click'Unrestricted_Access);

      -- wire up the up and down boost buttons

      App.Status_Record.Up_Boost_Button.On_Click_Handler
        (On_Up_Boost_Button_Click'Unrestricted_Access);

      App.Status_Record.Down_Boost_Button.On_Click_Handler
        (On_Down_Boost_Button_Click'Unrestricted_Access);


   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));


   end Build_Status_View;

   procedure Update_Status_View
     (App : in out App_Access) is

      Rooms_List : SRN.Room_Array_Type :=
        SRN.Get_All_Rooms(Location_Id => App.Location.Location_Id);

   begin
      Populate_Room_Select
        (Location_Id => App.Location.Location_Id,
         The_Select => App.Status_Record.Room_Status_Select,
         T_Array =>Rooms_List);

   end Update_Status_View;

end Usna_Status_View_Gnoga_Pkg;
