with Gnoga.Application.Multi_Connect;
with Gnoga.Gui.Window;
with Gnoga.Gui.View;
with Gnoga.Gui.Element.Common;
with Gnoga.Gui.Element; use Gnoga.Gui.Element;
with Gnoga.Gui.Base;
with Gnoga.Gui.Element.List;
with Gnoga.Types;
with Device_Type_Pkg; use Device_Type_Pkg;
--with Nodes_Rooms_Lists_Defs_Pkg; use Nodes_Rooms_Lists_Defs_Pkg;
with Ada.Strings.Unbounded;
with App_Common_Functions_Pkg; use App_Common_Functions_Pkg;
with Schedule_Types_Pkg; use Schedule_Types_Pkg;
with Gnoga.Gui.Element.Form.Fieldset;
with Gnoga.Gui.Element.List;

with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;
with Schedule_Information_Pkg; use Schedule_Information_Pkg;
with Schedule_Functions_Pkg; use Schedule_Functions_Pkg;
--with Test_Schedule_Data_Pkg;
with App_View_List_Support_Pkg;
--with Selection_Information_Pkg; use Selection_Information_Pkg;
with Ada.Exceptions; use Ada.Exceptions;
with Stringify_Types_Pkg;
with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
--with Abbreviated_Types_Pkg; use Abbreviated_Types_Pkg;
package body Usna_Edit_Schedules_Gnoga_Pkg is


   use Gnoga;
   use Gnoga.Types;
   use Gnoga.Gui;
   use Gnoga.Gui.Element;




   procedure Populate_Command_Select  is new App_View_List_Support_Pkg.Generic_Populate_Select
     (T_Type           => Schedule_Command_Record,
      Index_Type => Command_Id_Type,
      T_Array_Type     => Schedule_Command_Array,
      Stringify_T_Type => Stringify_Types_Pkg.Stringify_Command);



   procedure Delete_Command (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
       App                  : App_Access := App_Access(Object.Connection_Data);

      Delete_Success : Boolean;
       The_Id : Command_Id_Type := App.Current_Command_Id;
   begin
      Gnoga.log("Deleting " & The_Id'img);
      Schedule_Information_Pkg.Remove_Command_From_Schedule
        (Location_Id => App.Location_Id,
         Command_Id    => The_Id,
         Schedule_Name => To_String(App.Current_Schedule),
         Success       => Delete_Success);
      if Delete_Success then
         App.Edit_Schedule_Record.Command_Select.Remove_Option
           (Index => Positive(The_Id));
         App.Edit_Schedule_Record.Command_Delete_Button.Visible(False);

      end if;
   end Delete_Command;


   procedure Add_Command (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
       App                  : App_Access := App_Access(Object.Connection_Data);
      Add_Success : Boolean;
      The_Id : Command_Id_Type := App.Current_Command_Id;
     Time_Split_Record    : Decomposed_Time_Record;
       Am_Or_Pm_String      : Unbounded_String;
   begin
      Schedule_Information_Pkg.Add_Command_To_Schedule
        (Location_Id    => App.Location_Id,
         Command        => New_Schedule_Command_Record,
         Schedule_Name  => To_String(App.Current_Schedule),
         Success        => Add_Success,
         New_Command_Id => App.Current_Command_Id );
      if Add_Success then
         Gnoga.log("Adding a command" & App.Current_Command_Id'img);
         Time_Split_Record := Split_Time(The_Time => New_Schedule_Command_Record.Its_At);
         App.Edit_Schedule_Record.Command_Select.Add_Option
           (Index => Natural(App.Current_Command_Id),
            Value => App.Current_Command_Id'img,
            Text => Stringify_Types_Pkg.Stringify_Command
              (Location_Id => App.Location_Id,
               Command => New_Schedule_Command_Record));

         App.Edit_Schedule_Record.Command_Mode_Button.Text(Value => New_Schedule_Command_Record.Mode_Change'img);
         if Time_Split_Record.Pm then
            Am_Or_Pm_String := To_Unbounded_String("P.M.");
         else
            Am_Or_Pm_String:= To_Unbounded_String("A.M.");
         end if;
         App.Edit_Schedule_Record.Am_Pm_Button.Text(Value => To_String(Am_Or_Pm_String));
         App.Edit_Schedule_Record.Day_Button.Text(Value => Time_Split_Record.The_Day'img);
         App.Edit_Schedule_Record.Hour_Button.Text(Value => Time_Split_Record.The_Hour'img);
         App.Edit_Schedule_Record.Minute_Button.Text(Value => Time_Split_Record.The_Minute'img);
         App.Edit_Schedule_Record.Command_Select.
           Selected(Index => natural (App.Current_Command_Id));
      end if;

   end Add_Command;




   -- an optimisation can be made here. The commands time is split twice, once by stringify and
   -- once by split time
   procedure Update_Command_And_List (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App                  : App_Access := App_Access(Object.Connection_Data);
      Update_Index         : Natural;
      New_Update_Index : Natural;
      Update_Command_Index : Command_Id_Type;
      New_Command          : Schedule_Command_Record;
      The_Change           : Command_Change_Type;
      Time_Split_Record    : Decomposed_Time_Record;
      Am_Or_Pm_String      : Unbounded_String;
   begin

      Update_Command_Index := App.Current_Command_Id;
      Update_Index := Natural(Update_Command_Index);
      Gnoga.Log("update index " & Update_Index'img );

      -- depending on ID we do a change then update stuff
      if Object.ID="AESCMD" then
         if App.Edit_Schedule_Record.Right_Click_Active then
            The_Change := Mode_Change_Reverse;
            else
         The_Change := Mode_Change;
         end if;

      elsif Object.ID="AESDB" then
         if App.Edit_Schedule_Record.Right_Click_Active then
            The_Change := Minus_A_Day;
         else
            The_Change:= Plus_A_Day;
         end if;

      elsif Object.ID="AESHB" then
         if App.Edit_Schedule_Record.Right_Click_Active then
            The_Change := Minus_An_Hour;
         else
            The_Change:= Plus_An_Hour;
         end if;

      elsif Object.ID="AESMB" then
         if App.Edit_Schedule_Record.Right_Click_Active then
            The_Change := Minus_A_Minute;
         else
            The_Change:=Plus_A_Minute;
         end if;

      elsif Object.ID="AESAPB" then
         The_Change:=Am_Pm_Change;
      end if;

      -- this may change the command id
      Schedule_Information_Pkg.Modify_Command
        (Location_Id => App.Location_Id,
         Schedule    => To_String(App.Current_Schedule),
         Command_Id  => Update_Command_Index,
         The_Change => The_Change,
         New_Command => New_Command);
      -- can be optimised later

      App.Current_Command_Id := Update_Command_Index;
      New_Update_Index := Natural (Update_Command_Index);
      Time_Split_Record := Split_Time(The_Time => New_Command.Its_At);
      App.Edit_Schedule_Record.Command_Select.Remove_Option(Index => Update_Index);
      App.Edit_Schedule_Record.Command_Select.Add_Option
        (Index => New_Update_Index,
         Value => New_Update_index'img,
         Text => Stringify_Types_Pkg.Stringify_Command
           (Location_Id => App.Location_Id,
         Command => New_Command));
      App.Edit_Schedule_Record.Command_Select.Selected
        (Index => natural(App.Current_Command_Id));
      App.Edit_Schedule_Record.Command_Mode_Button.Text(Value => New_Command.Mode_Change'img);
      if Time_Split_Record.Pm then
         Am_Or_Pm_String := To_Unbounded_String("P.M.");
      else
         Am_Or_Pm_String:= To_Unbounded_String("A.M.");
      end if;
      App.Edit_Schedule_Record.Am_Pm_Button.Text(Value => To_String(Am_Or_Pm_String));
      App.Edit_Schedule_Record.Day_Button.Text(Value => Time_Split_Record.The_Day'img);
      App.Edit_Schedule_Record.Hour_Button.Text(Value => Time_Split_Record.The_Hour'img);
      App.Edit_Schedule_Record.Minute_Button.Text(Value => Time_Split_Record.The_Minute'img);
      App.Edit_Schedule_Record.Command_Select.
        Selected(Index => natural (App.Current_Command_Id));
     App.Edit_Schedule_Record.Right_Click_Active := false;
   end Update_Command_And_List;

   procedure Update_Command_And_List_Right (Object : in out Gnoga.Gui.Base.Base_Type'Class;
                                            Mouse_Event : in     Gnoga.Gui.Base.Mouse_Event_Record) is

      App                  : App_Access := App_Access(Object.Connection_Data);

   begin
      if Mouse_Event.Right_Button = true then
         App.Edit_Schedule_Record.Right_Click_Active := true;
         Update_Command_And_List(Object => Object);
      end if;

   end Update_Command_And_List_Right;


   procedure Update_Temperature_And_Mode_Information
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App             : App_Access := App_Access(Object.Connection_Data);
      Current_Request : TRV_Request_Record;
   begin
      Current_Request  := Read_Request_Details
        (Location_Id => App.Location_Id,
        Schedule_Name => To_String(App.Current_Schedule));
      App.Edit_Schedule_Record.Temp_Reading.Text
        (Value => Temp_Xten_Image
           (Current_Request.Requested_Setpoints(Current_Request.Requested_Mode)));
      App.Edit_Schedule_Record.Temp_Meter.Value
        (Value => Integer
           (Current_Request.Requested_Setpoints(Current_Request.Requested_Mode)));
      App.Edit_Schedule_Record.Mode_Button.Text(Value => Current_Request.Requested_Mode'img);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end;

   procedure Minus_A_Degree_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App : App_Access := App_Access(Object.Connection_Data);

   begin
      Lower_Schedule_Temperature
        (Location_Id   => App.Location_Id,
         Schedule_Name => To_String(App.Current_Schedule));
      Update_Temperature_And_Mode_Information(Object => Object);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Minus_A_Degree_Click;



   procedure Add_A_Degree_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App : App_Access := App_Access(Object.Connection_Data);

   begin
      Raise_Schedule_Temperature(Location_Id   => App.Location_Id,
         Schedule_Name => To_String(App.Current_Schedule));
      Update_Temperature_And_Mode_Information(Object => Object);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Add_A_Degree_Click;

   procedure Mode_Change_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App : App_Access := App_Access(Object.Connection_Data);

   begin
      Change_Mode(Location_Id   => App.Location_Id,
         Schedule_Name => To_String(App.Current_Schedule));
      Update_Temperature_And_Mode_Information(Object => Object);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Mode_Change_Click;

   procedure Select_Command_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App : App_Access := App_Access(Object.Connection_Data);

      Command           : Schedule_Command_Record;
      Time_Split_Record : Decomposed_Time_Record;
      Am_Or_Pm_String   : Unbounded_String;
   begin
      App.Current_Command_Id :=
        Command_Id_Type(App.Edit_Schedule_Record.Command_Select.Selected_Index);
      gnoga.log(" command id selected " & App.Current_Command_Id'img);
      Command   := Get_Command_Record
        (Location_Id => App.Location_Id,
         Schedule_Id => Schedule_Id
           (Location_Id   => App.Location_Id,
            Schedule_Name => To_String(App.Current_Schedule)),
         Command_Id  => App.Current_Command_Id);
      --  App.Edit_Schedule_Record.Command_Details_Label.Text
      --    (Value => Printable_Weekly_Date(The_Time => Command.Its_At));
      App.Edit_Schedule_Record.Command_Mode_Button.Text
        (Value => Command.Mode_Change'img);
      Time_Split_Record := Split_Time(The_Time => Command.Its_At);
      if Time_Split_Record.Pm then
         Am_Or_Pm_String := To_Unbounded_String("P.M.");
      else
         Am_Or_Pm_String:= To_Unbounded_String("A.M.");
      end if;
      App.Edit_Schedule_Record.Am_Pm_Button.Text(Value => To_String(Am_Or_Pm_String));
      App.Edit_Schedule_Record.Day_Button.Text(Value => Time_Split_Record.The_Day'img);
      App.Edit_Schedule_Record.Hour_Button.Text(Value => Time_Split_Record.The_Hour'img);
      App.Edit_Schedule_Record.Minute_Button.Text(Value => Time_Split_Record.The_Minute'img);

      App.Edit_Schedule_Record.Command_Select_Fset.Visible(true);
      App.Edit_Schedule_Record.Command_Delete_Button.Visible(True);

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Select_Command_Click;


   procedure Build_Edit_Schedule_View
     (App : in out App_Access) is

      Stored_Commands : Schedule_Command_Array :=
        Show_The_Schedule(Location_Id   => App.Location_Id,
                          Schedule_Name => To_String(App.Current_Schedule));
   begin


      --App.View_Array(Edit_Schedule_View).Put_Line("<H1>Modify Schedule <H1>");

      Gnoga.Log("OCES Number of Commands " & Stored_Commands'length'img);



      App.Edit_Schedule_Record.Overall_Schedule_Fset.Create
        (App.Form_Array(Edit_Schedule_View));

      App.Edit_Schedule_Record.Overall_Schedule_Fset.Put_Legend
        (" Overall Schedule Control ");


      App.Edit_Schedule_Record.Command_Fset.
        Create(Parent => App.Form_Array(Edit_Schedule_View));

      App.Edit_Schedule_Record.Command_Fset.
        Put_Legend(" Commands  ");


      App.Edit_Schedule_Record.Command_Select_Fset.Create
        (App.Form_Array(Edit_Schedule_View));

      App.Edit_Schedule_Record.Title_Label.Create
        (Parent => App.Form_Array(Edit_Schedule_View),
         Content => "<H1>Modify Schedule <H1>" );


      App.Edit_Schedule_Record.Command_Select_Fset.Put_Legend
        ("Modify Command Selected");

      App.Edit_Schedule_Record.Command_Add_Button.Create
        (Parent  => App.Form_Array(Edit_Schedule_View),
         Content => "Add a Command");

      App.Edit_Schedule_Record.Command_Add_Button.Place_Inside_Top_Of
        (Target => App.Edit_Schedule_Record.Command_Fset);

       App.Edit_Schedule_Record.Command_Add_Button.
        On_Click_Handler(Add_Command'Unrestricted_Access);

      App.Edit_Schedule_Record.Command_Delete_Button.Create
        (Parent  => App.Form_Array(Edit_Schedule_View),
         Content => " Delete The Command");

      App.Edit_Schedule_Record.Command_Delete_Button.Place_Inside_Top_Of
        (Target => App.Edit_Schedule_Record.Command_Fset);

      App.Edit_Schedule_Record.Command_Delete_Button.
        On_Click_Handler(Delete_Command'Unrestricted_Access);



      App.Edit_Schedule_Record.Command_Delete_Button.Visible(False);

      App.Edit_Schedule_Record.Command_Select.Create
        (Form => App.Form_Array(Edit_Schedule_View),
         Multiple_Select => false,
         Visible_Lines => 10);

      Populate_Command_Select
        (Location_Id => App.Location_Id,
         The_Select => App.Edit_Schedule_Record.Command_Select,
         T_Array => Stored_Commands);

      App.Edit_Schedule_Record.Command_Select.On_Click_Handler
        (Select_Command_Click'Unrestricted_Access);

      App.Edit_Schedule_Record.Command_Select.Place_Inside_Bottom_Of
        (App.Edit_Schedule_Record.Command_Fset);
      App.Edit_Schedule_Record.Title_Label.Place_Inside_Top_Of
                                            (App.Edit_Schedule_Record.Command_Fset);

      --set up command mode button
      App.Edit_Schedule_Record.Command_Mode_Button.Create
        (Parent => App.Form_Array(Edit_Schedule_View),
         Content => " Choose a Command to adjust",
         ID=>"AESCMD");
      App.Edit_Schedule_Record.Command_Mode_Button.On_Click_Handler
        (Handler => Update_Command_And_List'Unrestricted_Access);

      App.Edit_Schedule_Record.Command_Mode_Button.On_Mouse_Right_Click_Handler
        (Handler => Update_Command_And_List_Right'Unrestricted_Access);


      App.Edit_Schedule_Record.Command_Mode_Button.Place_Inside_Bottom_Of
        (App.Edit_Schedule_Record.Command_Select_Fset);

      -- day button setup
      App.Edit_Schedule_Record.Day_Button.Create
        (Parent => App.Form_Array(Edit_Schedule_View),
         Content => "Non Day",
         ID => "AESDB");

      App.Edit_Schedule_Record.Day_Button.On_Click_Handler
        (Handler => Update_Command_And_List'Unrestricted_Access);

      App.Edit_Schedule_Record.Day_Button.On_Mouse_Right_Click_Handler
        (Handler => Update_Command_And_List_Right'Unrestricted_Access);


      App.Edit_Schedule_Record.Day_Button.Place_Inside_Bottom_Of
        (App.Edit_Schedule_Record.Command_Select_Fset);

      -- hour button setup
      App.Edit_Schedule_Record.Hour_Button.Create
        (Parent => App.Form_Array(Edit_Schedule_View),
         Content => "Non Day",
         ID => "AESHB");

      App.Edit_Schedule_Record.Hour_Button.On_Click_Handler
        (Handler => Update_Command_And_List'Unrestricted_Access);

      App.Edit_Schedule_Record.Hour_Button.On_Mouse_Right_Click_Handler
        (Handler => Update_Command_And_List_Right'Unrestricted_Access);

      App.Edit_Schedule_Record.Hour_Button.Place_Inside_Bottom_Of
        (App.Edit_Schedule_Record.Command_Select_Fset);

      -- minute button setup
      App.Edit_Schedule_Record.Minute_Button.Create
        (Parent => App.Form_Array(Edit_Schedule_View),
         Content => "Non Day",
         ID => "AESMB");

      App.Edit_Schedule_Record.Minute_Button.On_Click_Handler
        (Handler => Update_Command_And_List'Unrestricted_Access);

      App.Edit_Schedule_Record.Minute_Button.On_Mouse_Right_Click_Handler
        (Handler => Update_Command_And_List_Right'Unrestricted_Access);


      App.Edit_Schedule_Record.Minute_Button.Place_Inside_Bottom_Of
        (App.Edit_Schedule_Record.Command_Select_Fset);

      -- am_pm button setup
      App.Edit_Schedule_Record.Am_Pm_Button.Create
        (Parent => App.Form_Array(Edit_Schedule_View),
         Content => "Non Day",
         ID => "AESAPB");

      App.Edit_Schedule_Record.Am_Pm_Button.On_Click_Handler
        (Handler => Update_Command_And_List'Unrestricted_Access);

      App.Edit_Schedule_Record.Am_Pm_Button.Place_Inside_Bottom_Of
        (App.Edit_Schedule_Record.Command_Select_Fset);


      App.Edit_Schedule_Record.Temp_Reading.Create
        (Parent  => App.Form_Array(Edit_Schedule_View),
         Content => "25",
         ID      => "Room_Temp");

      App.Edit_Schedule_Record.Temp_Reading.Place_Inside_Bottom_Of
        (App.Edit_Schedule_Record.Overall_Schedule_Fset);

      App.Edit_Schedule_Record.Minus_Button.Create
        (Parent  => App.Form_Array(Edit_Schedule_View),
         Content => " - ");
      App.Edit_Schedule_Record.Minus_Button.Place_Inside_Bottom_Of
        (App.Edit_Schedule_Record.Overall_Schedule_Fset);

      App.Edit_Schedule_Record.Plus_Button.Create
        (Parent => App.Form_Array(Edit_Schedule_View),
         Content => " + ");
      App.Edit_Schedule_Record.Plus_Button.Place_Inside_Bottom_Of
        (App.Edit_Schedule_Record.Overall_Schedule_Fset);

      App.Edit_Schedule_Record.Mode_Button.Create
        (Parent => App.Form_Array(Edit_Schedule_View),
         Content => " Mode ");
      App.Edit_Schedule_Record.Mode_Button.Place_Inside_Bottom_Of
        (App.Edit_Schedule_Record.Overall_Schedule_Fset);

      App.Edit_Schedule_Record.Minus_Button.On_Click_Handler
        (Minus_A_Degree_Click'Unrestricted_Access);
      App.Edit_Schedule_Record.Plus_Button.On_Click_Handler
        (Add_A_Degree_Click'Unrestricted_Access);

      App.Edit_Schedule_Record.Mode_Button.On_Click_Handler
        (Mode_Change_Click'Unrestricted_Access);

      Gnoga.Log("OCES Pre Meter Create ");

      App.Edit_Schedule_Record.Temp_Meter.Create
        (Parent  => App.Form_Array(Edit_Schedule_View),
         Value   => 200,
         High    => integer(Upper_Temp_Limit),
         Low     => integer(Lower_Temp_Limit),
         Maximum => integer(Temp_Xten_Type'last),
         Minimum => integer(Temp_Xten_Type'first),
         Optimum => 250,
         ID      => "Temp_Meter");
      Gnoga.log("OCES hereee.....");
      App.Edit_Schedule_Record.Temp_Meter.Place_Inside_Bottom_Of
        (App.Edit_Schedule_Record.Overall_Schedule_Fset);




      App.Edit_Schedule_Record.Command_Select_Fset.Visible(false);

      App.Edit_Schedule_Record.Mode_Button.Click;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Build_Edit_Schedule_View;

procedure Update_Edit_Schedule_View
     (App  : in out App_Access) is

         Stored_Commands : Schedule_Command_Array :=
        Show_The_Schedule(Location_Id => App.Location_Id,
                          Schedule_Name => To_String(App.Current_Schedule));

   begin
      Populate_Command_Select
        (Location_Id => App.Location_Id,
         The_Select => App.Edit_Schedule_Record.Command_Select,
         T_Array => Stored_Commands);
   end Update_Edit_Schedule_View;


end Usna_Edit_Schedules_Gnoga_Pkg;
