with Gnoga.Application.Multi_Connect;
with Gnoga.Gui.Window;
with Gnoga.Gui.View;
with Gnoga.Gui.Element.Common;
with Gnoga.Gui.Element; use Gnoga.Gui.Element;
with Gnoga.Gui.Base;
with Gnoga.Gui.Element.List;
with Gnoga.Types;
with Ada.Strings.Unbounded;
--with App_Common_Functions_Pkg; use App_Common_Functions_Pkg;
--with Schedule_Types_Pkg; use Schedule_Types_Pkg;
with Gnoga.Gui.Element.Form;
with Gnoga.Gui.Element.Form.Fieldset;
with Gnoga.Gui.Element.List;

with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;
with App_View_List_Support_Pkg;
--with Selection_Information_Pkg; use Selection_Information_Pkg;
with Ada.Exceptions; use Ada.Exceptions;
--with Stringify_Types_Pkg;
with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Identity_Types_Pkg; use Identity_Types_Pkg;
with Gnoga.Types;  use Gnoga.Types;
with Deallocate_And_Access_Types_Pkg; use Deallocate_And_Access_Types_Pkg;
with UI_Related_Access_Types_Pkg; use UI_Related_Access_Types_Pkg;
with Dsa_Usna_Server;
package body Edit_Room_Details_Gnoga_Pkg is


   Upper_Temp_Limit : constant  integer := 350;
   Lower_Temp_Limit : Constant integer := 60;

   use Gnoga;
   use Gnoga.Types;
   use Gnoga.Gui;
   use Gnoga.Gui.Element;

   B_Comfort_Colour : Gnoga.Types.RGBA_Type :=
     ( Red   => 200,
       Green => 0,
       Blue  => 0,
       Alpha => 1.0);

   B_Economy_Colour : Gnoga.Types.RGBA_Type :=
     ( Red   => 0,
       Green => 80,
       Blue  => 200,
       Alpha => 1.0);

   B_Blank_Colour : Gnoga.Types.RGBA_Type :=
     (Red => 0,
      Green => 0,
      Blue => 0,
      Alpha => 1.0);

   White_Writing : Gnoga.Types.RGBA_Type :=
     (Red => 0,
      Green => 0,
      Blue => 0,
      Alpha => 1.0);

   Black_Writing : Gnoga.Types.RGBA_Type :=
     (Red => 200,
      Green => 200,
      Blue => 200,
      Alpha => 1.0);






   function Schedule_Button_Label(The_Day : in Weekday_Type;
                                  The_Bit : in Hour_Day_Schedule_Type)
                                  return string is
   begin
      return  The_Day'img(1..2) & The_Bit'img  & "SB" ;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         return "";

   end Schedule_Button_Label;

   Function Cancel_Button_Label (The_Day : in Weekday_Type) return String is
   begin
      return  The_Day'img(1..2) & "CANCEL" ;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         return "";
   end Cancel_Button_Label;


   Function Transmit_Button_Label (The_Day : in Weekday_Type) return String is
   begin
      return  The_Day'img(1..2) & "TRANSMIT" ;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         return "";
   end Transmit_Button_Label;


   function Day_From_Id ( The_Id : String) return Weekday_Type is
      Return_Value : Weekday_Type;
      Day : constant string := The_Id(The_Id'first..The_Id'first + 1);
   begin

      if Day ="MO"  then
         Return_Value := Monday;
      elsif Day = "TU" then
         Return_Value := Tuesday;
      elsif Day =  "WE" then
         Return_Value := Wednesday;
      elsif Day = "TH"  then
         Return_Value := Thursday;
      elsif Day = "FR" then
         Return_Value := Friday;
      elsif Day = "SA" then
         Return_Value := Saturday;
      elsif Day =  "SU"  then
         Return_Value := Sunday;
      else
         raise Program_Error;
      end if;

      return Return_Value;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         return Saturday;


   end Day_From_Id;

   Hour_Display_String : Constant string := "--1am----------5am--------8am----------11am--------2pm-------4pm---------7pm--------9pm-------";

   function Is_Number_Odd  (Number : in Points_In_Day_Type) return boolean is
      Return_Value : Boolean := false;
   begin
      case Number is
         when 1|3|5|7|9|11|13 =>
            Return_Value := true;
         when 2|4|6|8|10|12 =>
            Return_Value := false;
         when others =>
            raise Program_Error;

      end case;
      return Return_Value;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         return false;
   end Is_Number_Odd;


   function What_Colour (Step : in Points_In_Day_Type) return Gnoga.Types.RGBA_Type is
      Return_Value : Gnoga.Types.RGBA_Type;
   begin
      if Is_Number_Odd(Step) then
         Return_Value :=  B_Comfort_Colour;
      else
         Return_Value := B_Economy_Colour;
      end if;
      return Return_Value;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         return Black_Writing;

   end What_Colour;

   function What_Colour_For_Tail (Step : in Points_In_Day_Type) return Gnoga.Types.RGBA_Type is
      Return_Value : Gnoga.Types.RGBA_Type;
   begin
      if not Is_Number_Odd(Step) then
         Return_Value :=  B_Comfort_Colour;
      else
         Return_Value := B_Economy_Colour;
      end if;
      return Return_Value;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         return Black_Writing;

   end What_Colour_For_Tail;


   procedure Log_Day_Schedule (Item : in Day_Schedule_Type) is
   begin

      Gnoga.log(" Size of Schedule : " & Item'length'img);
      gnoga.log("***");
      for count in Item'first..Item'last loop
         Gnoga.log("Item " & count'img & "Array item"  &Item(count)'img);
      end loop;
      gnoga.log("***");
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Log_Day_Schedule;

   procedure Display_Day_Schedule
     (The_Day : in Weekday_Type;
      App : in out App_Access
     )  is


   begin

      if App.Edit_Record.The_Week(The_Day) = null then
         for count in Hour_Day_Schedule_Type'first ..Hour_Day_Schedule_Type'last loop
            App.Edit_Record.The_Weeks_Buttons(The_Day)(count).
              Background_Color(RGBA => B_Blank_Colour);
            App.Edit_Record.The_Weeks_Buttons(The_Day)(count).
              Color(RGBA => Black_Writing);
         end loop;
      else
         --Log_Day_Schedule(App.Edit_Record.The_Week(The_Day).all);
         declare
            The_First : Points_In_Day_Type := App.Edit_Record.The_Week(The_Day).all'first;
            The_Last : Points_In_Day_Type := App.Edit_Record.The_Week(The_Day).all'last;
            Theres_A_Tail, Theres_A_Head : boolean ;
            Number_Of_Steps : Points_In_Day_Type;
            Tail_Is_Red : boolean := Is_Number_Odd(App.Edit_Record.The_Week(The_Day).all'last);

         begin
            Theres_A_Head := App.Edit_Record.The_Week(The_Day).all(The_First) /=
              Hour_Day_Schedule_Type'first;
            Theres_A_Tail := App.Edit_Record.The_Week(The_Day).all(The_Last) /=
              Hour_Day_Schedule_Type'last;

            if App.Edit_Record.The_Week(The_Day).all'length > 1 then
               Number_Of_Steps := App.Edit_Record.The_Week(The_Day).all'length -1;
               for count in 1..Number_Of_Steps loop
                  declare
                     Start_Of_Step : Hour_Day_Schedule_Type:= App.Edit_Record.The_Week(The_Day)(count);
                     End_Of_Step : Hour_Day_Schedule_Type := App.Edit_Record.The_Week(The_Day)(count+ 1) -1;
                  begin
                     for Button_Count in Start_Of_Step..End_Of_Step loop
                        App.Edit_Record.The_Weeks_Buttons(The_Day)(Button_count).
                          Background_Color(RGBA => What_Colour(count));
                        App.Edit_Record.The_Weeks_Buttons(The_Day)(Button_count).
                          Color(RGBA => White_Writing);
                     end loop;
                  exception
                     when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

                  end;
               end loop;
            else
               Number_Of_Steps :=2;
               App.Edit_Record.The_Weeks_Buttons(The_Day)
                 (App.Edit_Record.The_Week(The_Day).all'first).
                   Background_Color(RGBA => B_Comfort_Colour);
               App.Edit_Record.The_Weeks_Buttons(The_Day)
                 (App.Edit_Record.The_Week(The_Day).all'first).
                   Color(RGBA => White_Writing);
            end if;
            if Theres_A_Head then
               declare
                  Start_Of_Step : Hour_Day_Schedule_Type:= Hour_Day_Schedule_Type'first;
                  End_Of_Step : Hour_Day_Schedule_Type := App.Edit_Record.The_Week(The_Day)(The_First) -1;
               begin
                  for Button_Count in Start_Of_Step..End_Of_Step loop
                     App.Edit_Record.The_Weeks_Buttons(The_Day)(Button_count).
                       Background_Color(RGBA => B_Economy_Colour);
                     App.Edit_Record.The_Weeks_Buttons(The_Day)(Button_count).
                       Color(RGBA => White_Writing);
                  end loop;
               exception
                  when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

               end;
            end if;
            if Theres_A_Tail then
               declare
                  Start_Of_Step : Hour_Day_Schedule_Type:= App.Edit_Record.The_Week(The_Day)(The_Last) ;
                  End_Of_Step : Hour_Day_Schedule_Type := Hour_Day_Schedule_Type'last;
               begin
                  for Button_Count in Start_Of_Step..End_Of_Step loop
                     App.Edit_Record.The_Weeks_Buttons(The_Day)(Button_count).
                       Background_Color(RGBA => What_Colour_For_Tail(Number_Of_Steps));
                     App.Edit_Record.The_Weeks_Buttons(The_Day)(Button_count).
                       Color(RGBA => White_Writing);
                  end loop;
               exception
                  when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

               end;
            end if;
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

         end;
      end if;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Display_Day_Schedule;

   procedure Schedule_Button_Click (Object : in out Gnoga.Gui.Base.Base_Type'Class)  is
      App                  : App_Access := App_Access(Object.Connection_Data);
      The_Id : constant string := Object.Id;
      The_Day : constant Weekday_Type:= Day_From_Id(The_Id);
      Button_Number : constant Hour_Day_Schedule_Type :=
        Hour_Day_Schedule_Type'value(The_Id(3..The_Id'length - 2));
      -- VISIBLE procedures to other packages

   begin


      if App.Edit_Record.The_Week(The_Day) = null then
         declare
            New_Schedule : Day_Schedule_Type (1..1) := (others => Button_Number);
         begin
            App.Edit_Record.The_Week(The_Day) := new Day_Schedule_Type'(New_Schedule);
         end;
      elsif  App.Edit_Record.The_Week(The_Day).all'last  = 13 then
         Deallocate_Day_Schedule_Access (App.Edit_Record.The_Week(The_Day));
      else
         declare
            Start_Array : Points_In_Day_Type := App.Edit_Record.The_Week(The_Day).all'first;
            End_Array : Points_In_Day_Type := App.Edit_Record.The_Week(The_Day).all'last;
            New_Position : Points_In_Day_Type;
         begin
            if Button_Number > App.Edit_Record.The_Week(The_Day).all(End_Array) then
               New_Position := End_Array + 1;
            else
               -- find it !
               for count in Start_Array..End_Array loop
                  if App.Edit_Record.The_Week(The_Day).all(count) >= Button_Number then
                     New_Position := count;
                     exit;
                  end if;
               end loop;
            end if;
            declare
               New_Schedule : Day_Schedule_Type(1..New_Position);
            begin
               if New_Position > 1 then
                  New_Schedule (1..New_Position-1) :=
                    App.Edit_Record.The_Week(The_Day).all(1..New_Position-1);
               end if;
               New_Schedule(New_Position) := Button_Number;
               Deallocate_Day_Schedule_Access(App.Edit_Record.The_Week(The_Day));
               App.Edit_Record.The_Week(The_Day) := new Day_Schedule_Type'(New_Schedule);
            exception
               when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

            end;
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

         end;
      end if;

      -- Log_Day_Schedule(App.Edit_Record.The_Week(The_Day).all);
      Display_Day_Schedule(The_Day => The_Day,
                           App     => App);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Schedule_Button_Click;

   procedure Cancel_Button_Click (Object : in out Gnoga.Gui.Base.Base_Type'Class)  is
      App                  : App_Access := App_Access(Object.Connection_Data);
      The_Id : constant string := Object.Id;
      The_Day : constant Weekday_Type:= Day_From_Id(The_Id);

   begin

      Deallocate_Day_Schedule_Access(App.Edit_Record.The_Week(The_Day));
      Display_Day_Schedule(The_Day => The_Day,
                           App     => App);
   end Cancel_Button_Click;

   procedure Transmit_Button_Click (Object : in out Gnoga.Gui.Base.Base_Type'Class)  is
      App                  : App_Access := App_Access(Object.Connection_Data);
      The_Id : constant string := Object.Id;
      The_Day : constant Weekday_Type:= Day_From_Id(The_Id);
      Transmit : boolean := false;
      Schedule : Day_Schedule_Access := App.Edit_Record.The_Week(The_Day);
      Success : boolean;
   begin
      if not (Schedule = null) and then
        (Schedule.all'length > 1) then
         Dsa_Usna_Server.Modify_Room_Mode_Temperatures
           (Location => App.Location_id,
            Room_Number => App.Edit_Record.This_Room,
            The_Day => The_Day,
            Mode_Temperatures => App.Edit_Record.Mode_Temperatures);
         Dsa_Usna_Server.Modify_Day_Schedule
           (Location => App.Location_id,
            Room_Number => App.Edit_Record.This_Room,
            The_Day => The_Day,
            Schedule => Schedule.all,
            Success => Success);
         -- we also need to transmit the schedule change to the database and the pi
      end if;

   end Transmit_Button_Click;

   procedure Redisplay_Mode_Values (App : in out App_Access) is

   begin
      App.Edit_Record.Temp_Meter.Value(integer(App.Edit_Record.Mode_Temperatures
                                       (App.Edit_Record.Current_Mode)*10));
      App.Edit_Record.Mode_Button.Text(App.Edit_Record.Current_Mode'img);
      App.Edit_Record.Temp_Reading.Text(App.Edit_Record.Mode_Temperatures
                                        (App.Edit_Record.Current_Mode)'img);
   end Redisplay_Mode_Values;


   procedure Minus_A_Degree_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App : App_Access := App_Access(Object.Connection_Data);

   begin
      App.Edit_Record.Mode_Temperatures(App.Edit_Record.Current_Mode) :=
        App.Edit_Record.Mode_Temperatures(App.Edit_Record.Current_Mode) - 0.5;
      Redisplay_Mode_Values(App => App);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Minus_A_Degree_Click;



   procedure Add_A_Degree_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App : App_Access := App_Access(Object.Connection_Data);

   begin
      App.Edit_Record.Mode_Temperatures(App.Edit_Record.Current_Mode) :=
        App.Edit_Record.Mode_Temperatures(App.Edit_Record.Current_Mode) + 0.5;
      --Gnoga.log("Mode is " & App.Edit_Record.Current_Mode'img
      --          & " Mode Temp is " & App.Edit_Record.Mode_Temperatures(App.Edit_Record.Current_Mode)'img);

      Redisplay_Mode_Values(App => App);


   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Add_A_Degree_Click;

   procedure Mode_Change_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App : App_Access := App_Access(Object.Connection_Data);

   begin
      if  App.Edit_Record.Current_Mode = Economy_Mode then
         App.Edit_Record.Current_Mode := Comfort_Mode;
      else
         App.Edit_Record.Current_Mode := Economy_Mode;
      end if;
      App.Edit_Record.Mode_Button.Text(Value => App.Edit_Record.Current_Mode'img);
      Redisplay_Mode_Values(App=>App);

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Mode_Change_Click;

   procedure Build_Edit_Schedule_View
     (App : in out App_Access)  is

   begin
      -- update room information
      -- depends on This_Room being set by the ROOMS_VIEW
      if App.Edit_Record.This_Room /= 0 then
         App.Edit_Record.Room_Data := new Room_Information_Record
           '(Dsa_Usna_Server.Get_Room_Data(Location => App.Location_id,
                                           Room     => App.Edit_Record.This_Room));
         if not App.Edit_Record.Title_Label.Valid then
         App.Edit_Record.Title_Label.Create
           (Parent  => App.Form_Array(Room_Edit_View),
            Content => "<H1> Editing " &  App.Edit_Record.Room_Data.Room_Name & "'s schedule <H1>");
            App.Edit_Record.Title_Label.Place_After(App.Nav_Array(Room_Edit_View));
         else
            App.Edit_Record.Title_Label.Text
              (Value =>  "<H1> Editing " &  App.Edit_Record.Room_Data.Room_Name & "'s schedule <H1>");
         end if;

         -- create the Fset and buttons for the temperature / Mode controls
         App.Edit_Record.Mode_Fset.Create
           (parent => App.Form_Array(Room_Edit_View));
         App.Edit_Record.Mode_Fset.Put_Legend   (" Temperature Mode Controls ");

         App.Edit_Record.Mode_Fset.Place_After(App.Edit_Record.Title_Label);

         App.Edit_Record.Temp_Reading.Create
           (Parent  => App.Form_Array(Room_Edit_View),
            Content => "25",
            ID      => "Room_Temp");

         App.Edit_Record.Temp_Reading.Place_Inside_Bottom_Of
           (App.Edit_Record.Mode_Fset);
         App.Edit_Record.Mode_Fset.Put("  ");
         App.Edit_Record.Minus_Button.Create
           (Parent  => App.Form_Array(Room_Edit_View),
            Content => " - ");
         App.Edit_Record.Minus_Button.Place_Inside_Bottom_Of
           (App.Edit_Record.Mode_Fset);
         App.Edit_Record.Mode_Fset.Put("  ");

         App.Edit_Record.Plus_Button.Create
           (Parent => App.Form_Array(Room_Edit_View),
            Content => " + ");
         App.Edit_Record.Plus_Button.Place_Inside_Bottom_Of
           (App.Edit_Record.Mode_Fset);

         App.Edit_Record.Mode_Button.Create
           (Parent => App.Form_Array(Room_Edit_View),
            Content => " Mode ");
         App.Edit_Record.Mode_Button.Place_Inside_Bottom_Of
           (App.Edit_Record.Mode_Fset);
         App.Edit_Record.Mode_Fset.Put("  ");

         App.Edit_Record.Minus_Button.On_Click_Handler
           (Minus_A_Degree_Click'Unrestricted_Access);
         App.Edit_Record.Plus_Button.On_Click_Handler
           (Add_A_Degree_Click'Unrestricted_Access);

         App.Edit_Record.Mode_Button.On_Click_Handler
           (Mode_Change_Click'Unrestricted_Access);

         Gnoga.Log("OCES Pre Meter Create ");

         App.Edit_Record.Temp_Meter.Create
           (Parent  => App.Form_Array(Room_Edit_View),
            Value   => 200,
            High    => integer(Upper_Temp_Limit),
            Low     => integer(Lower_Temp_Limit),
            Maximum => Upper_Temp_Limit+50,
            Minimum => Lower_Temp_Limit- 50,
            Optimum => 250,
            ID      => "Temp_Meter");
         Gnoga.log("OCES hereee.....");
         App.Edit_Record.Temp_Meter.Place_Inside_Bottom_Of
           (App.Edit_Record.Mode_Fset);






         -- create the schedule buttons

         App.Edit_Record.Schedule_Button_Fset.Create
           (parent => App.Form_Array(Room_Edit_View));

         App.Edit_Record.Schedule_Button_Fset.Put_Legend   ("Weekly Schedule ");

         for Day_Count in Weekday_Type'first..Weekday_Type'last loop
            App.Edit_Record.Week_Day_Sets(Day_Count).Create
              (Parent => App.Form_Array(Room_Edit_View));
            App.Edit_Record.Week_Day_Sets(Day_Count).Put_Legend
              (Day_Count'img);
            App.Edit_Record.Week_Day_Sets(Day_Count).Place_Inside_Bottom_Of
              (App.Edit_Record.Schedule_Button_Fset);
            App.Edit_Record.Week_Day_Sets(Day_Count).Put_Line
              (Message => Hour_Display_String);

            for Bit_Count in Hour_Day_Schedule_Type loop
               App.Edit_Record.The_Weeks_Buttons(Day_Count)(Bit_Count).
                 Create(Parent  => App.Form_Array(Room_Edit_View),
                        Content => Bit_Count'img,
                        ID      => Schedule_Button_Label(The_Day => Day_Count,
                                                         The_Bit => Bit_Count) );
               -- put in side Fset
               App.Edit_Record.The_Weeks_Buttons(Day_Count)(Bit_Count).
                 Place_Inside_Bottom_Of(App.Edit_Record.Week_Day_Sets(Day_Count));
               App.Edit_Record.The_Weeks_Buttons(Day_Count)(Bit_Count).On_Click_Handler
                 (Handler => Schedule_Button_Click'Unrestricted_Access);
            end loop;
            -- set up cancel button
            App.Edit_Record.The_Week_Reset_Buttons(Day_Count).Create
              (Parent  => App.Form_Array(Room_Edit_View),
               Content => " Cancel " ,
               ID      => Cancel_Button_Label(The_Day => Day_Count));
            App.Edit_Record.The_Week_Reset_Buttons(Day_Count).
              Place_Inside_Bottom_Of(App.Edit_Record.Week_Day_Sets(Day_Count));
            App.Edit_Record.The_Week_Reset_Buttons(Day_Count).
              On_Click_Handler(handler => Cancel_Button_Click'Unrestricted_Access);

            -- set up transmit Button
            App.Edit_Record.The_Week_Transmit_Buttons(Day_Count).Create
              (Parent  => App.Form_Array(Room_Edit_View),
               Content => " Send " ,
               ID      => Transmit_Button_Label(The_Day => Day_Count));
            App.Edit_Record.The_Week_Transmit_Buttons(Day_Count).
              Place_Inside_Bottom_Of(App.Edit_Record.Week_Day_Sets(Day_Count));
            App.Edit_Record.The_Week_Transmit_Buttons(Day_Count).
              On_Click_Handler(Handler => Transmit_Button_Click'Unrestricted_Access);




            -- new line inside Fset
            App.Edit_Record.Schedule_Button_Fset.New_Line;
            App.Edit_Record.Mode_Button.click;
         end loop;
      else
         App.Edit_Record.Title_Label.Create
           (Parent  => App.Form_Array(Room_Edit_View),
            Content => "<H1> No Room selected , go back to rooms view <H1>");
         App.View_Initial(Room_Edit_View ) := true;
      end if;

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));


   end Build_Edit_Schedule_View;



   procedure Update_Edit_Schedule_View
     (App  : in out App_Access) is

   begin
      null;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Update_Edit_Schedule_View;


end Edit_Room_Details_Gnoga_Pkg;



