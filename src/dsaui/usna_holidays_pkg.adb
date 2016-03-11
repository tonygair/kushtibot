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
with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;
with Holiday_Types; use Holiday_Types;

with Holiday_Manager_Pkg; use Holiday_Manager_Pkg;
with Ada.Calendar; use Ada.Calendar;
--with User_And_Location_Types_Pkg; use User_And_Location_Types_Pkg;
with Identity_Types_Pkg; use Identity_Types_Pkg;

--with Abbreviated_Types_Pkg; use Abbreviated_Types_Pkg;
package body Usna_Holidays_Pkg is


   use Gnoga.Gui;


   Holiday_Selection_Error : Exception;

   Holiday_Active_String : constant String := "Holiday ACTIVE";
   Holiday_Inactive_String : constant string := "Holiday INACTIVE";




   function Stringify_Holiday (Location_Id : in Location_Id_Type;
                               Holiday : in Holiday_Record) return string is
      Active_String   : constant String := " * ACTIVE *";
      Inactive_String : constant String := "-inactive-";
   begin
      if Holiday.Active then
         return Holiday.Holiday_Name(1..Holiday.Name_Length) &
           "  " & Active_String;
      else
         return Holiday.Holiday_Name(1..Holiday.Name_Length)&
           " " & Inactive_String;
      end if;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
      return "";
   end Stringify_Holiday;


   procedure Populate_Select is new App_View_List_Support_Pkg.Generic_Populate_Select
     (T_Type           => Holiday_Record,
      Index_Type       => natural,
      T_Array_Type     => Holiday_Array_Type,
      Stringify_T_Type => Stringify_Holiday);

   procedure Reset_Holiday_Screen
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App              : App_Access := App_Access(Object.Connection_Data);

   begin
      App.Holiday_Record.Old_Holiday_Name := Blank_Name;
      App.Holiday_Record.Old_Holiday_Name_Length := 0;
      if App.Holiday_Record.Holiday_Select.Selected_Index > 0 then
      App.Holiday_Record.Holiday_Select.Selected
        (Index => App.Holiday_Record.Holiday_Select.Selected_Index,
         Value => false);
      end if;

      App.Holiday_Record.Current_Holiday_Active := False;
      App.Holiday_Record.From_Dp.Value
        (Date_Functions_Pkg.Date_To_String(Holiday_Types.Blank_Ada_Time));
      App.Holiday_Record.To_Dp.Value
        (Date_Functions_Pkg.Date_To_String(Holiday_Types.Blank_Ada_Time));
      App.Holiday_Record.Holiday_Input.Value
        ("");
      App.Holiday_Record.Delete_Button.Visible(false);
      App.Holiday_Record.Modify_Button.Visible(false);
      App.Holiday_Record.Activate_Button.Text(Value=> Holiday_Inactive_String);
      App.Holiday_Record.Holiday_Replace := false;

       exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Reset_Holiday_Screen;

   procedure On_Update_Holiday_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App              : App_Access := App_Access(Object.Connection_Data);
      Active_Change_Success,
      Data_Delete_Success,
      Data_Add_Success : boolean := false;

      Holiday_Name     : constant string := App.Holiday_Record.Holiday_Input.Value;
      The_Index        : Natural ;
      Soh_Text : constant string :=  App.Holiday_Record.From_Dp.Value;
      Start_Of_Holiday : Time := Date_Functions_Pkg.
        String_To_Date (The_Time => Soh_Text);
      Eoh_Text : constant string := App.Holiday_Record.To_Dp.Value;
      End_Of_Holiday   : Time := Date_Functions_Pkg.String_To_Date
        (The_Time => Eoh_Text);

      New_Holiday_Record : Holiday_Record := Blank_Holiday_Record;
   begin
      App.Holiday_Record.Control_Fset.Visible(false);

      Gnoga.log("Holiday Name * " & Holiday_Name& "*");
      if App.Holiday_Record.Holiday_Replace then
         The_Index := Holiday_Manager(App.Location_Id).Holiday_Index
           (Description => App.Holiday_Record.Old_Holiday_Name
           (1..App.Holiday_Record.Old_Holiday_Name_Length));
         -- delete the old holiday
         Holiday_Manager(App.Location_Id).Delete_Holiday
           (Description => App.Holiday_Record.Old_Holiday_Name
           (1..App.Holiday_Record.Old_Holiday_Name_Length),
            Success     => Data_Delete_Success);
         -- delete the entry in holiday_select

         App.Holiday_Record.Holiday_Select.Remove_Option
           (Index => The_Index);
      end if;
      Gnoga.log(" Start of_Holiday " & Soh_Text);
      Gnoga.log(" End of Holiday " & Eoh_Text);
      Holiday_Manager_Pkg.Holiday_Manager(App.Location_Id).Add_Holiday
        (Description => Holiday_Name,
         Start       => Start_Of_Holiday,
         Finish      => End_Of_Holiday,
         Active => App.Holiday_Record.Current_Holiday_Active,
         Success     => Data_Add_Success);
      Gnoga.log ("Data_Add_Success " & Data_Add_Success'img);
      if Data_Add_Success then


         The_Index := Holiday_Manager(App.Location_Id).Holiday_Index (Holiday_Name);
         New_Holiday_Record :=Holiday_Manager(App.Location_Id).Get_Holiday
           (The_Index => The_Index);
         App.Holiday_Record.Holiday_Select.Add_Option
           (Value    =>  Holiday_Name,
            Text     => Stringify_Holiday(App.Location_Id,
              Holiday => New_Holiday_Record),
            Index    => The_Index,
            Selected => false,
            Disabled => false);

      end if;
      App.Holiday_Record.Button_Fset.Visible(False);
      App.Holiday_Record.Add_Button.Visible(true);
      App.Holiday_Record.Delete_Button.Visible (False);
      App.Holiday_Record.Holiday_Select.Visible (True);
      Reset_Holiday_Screen(Object => Object);
      Gnoga.log("Got to end of Update Holiday_Click");

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Update_Holiday_Click;

   procedure On_Add_Holiday_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App             : App_Access := App_Access(Object.Connection_Data);

   begin
      App.Holiday_Record.Current_Holiday_Active := false;
      App.Holiday_Record.Control_Fset.Visible(true);
      App.Holiday_Record.Button_Fset.Visible(false);
      App.Holiday_Record.Holiday_Replace := false;
      App.Holiday_Record.Button_Fset.Visible(false);
      App.Holiday_Record.Modify_Button. Visible(False);
      App.Holiday_Record.Delete_Button. Visible(False);
      App.Holiday_Record.Add_Button.Visible(False);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Add_Holiday_Click;

   procedure On_Modify_Holiday_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App             : App_Access := App_Access(Object.Connection_Data);

   begin
      App.Holiday_Record.Control_Fset.Visible(true);
      App.Holiday_Record.Button_Fset.Visible(false);
      App.Holiday_Record.Holiday_Replace := true;
      App.Holiday_Record.Modify_Button. Visible(False);

      App.Holiday_Record.Delete_Button. Visible(False);
      App.Holiday_Record.Add_Button.Visible(False);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Modify_Holiday_Click;

   Procedure On_Cancel_Holiday_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App             : App_Access := App_Access(Object.Connection_Data);
   begin
      Reset_Holiday_Screen(Object => Object);

      --App.Holiday_Record.Holiday_Select.Selected_Index ( 0);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Cancel_Holiday_Click;



   procedure On_Select_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App             : App_Access := App_Access(Object.Connection_Data);
      Holiday         : Holiday_Record;
      The_Index : Natural := App.Holiday_Record.Holiday_Select.Selected_Index;
      Reset_Holiday : boolean := false;
   begin
      if (The_Index > 0) and ( not  (Holiday_Manager(App.Location_Id)
                                     .Number_Of_Holidays  < The_Index)) then

         Holiday  := Holiday_Manager(App.Location_Id)
           .Get_Holiday (The_Index => The_Index );


         Gnoga.log(Message => Holiday.Holiday_Name(1..Holiday.Name_Length) & " selected");

         if App.Holiday_Record.Old_Holiday_Name = Holiday.Holiday_Name then
            Reset_Holiday := true;

         else

            App.Holiday_Record.Old_Holiday_Name := Holiday.Holiday_Name;
            App.Holiday_Record.Old_Holiday_Name_Length := Holiday.Name_Length;
         App.Holiday_Record.Holiday_Input.Value
           (Holiday.Holiday_Name(1..Holiday.Name_Length));
         App.Holiday_Record.From_Dp.Value
           (Date_Functions_Pkg.Date_To_String(Holiday.Start_Holiday));
         App.Holiday_Record.To_Dp.Value
           (Date_Functions_Pkg.Date_To_String(Holiday.End_Holiday));
         App.Holiday_Record.Delete_Button.Visible(true);
         App.Holiday_Record.Modify_Button.Visible(true);

         If Holiday.Active then
            App.Holiday_Record.Activate_Button.Text(Value =>Holiday_Active_String );
         else
            App.Holiday_Record.Activate_Button.Text(Value=> Holiday_Inactive_String);
         end if;
            App.Holiday_Record.Current_Holiday_Active := Holiday.Active;
         end if;
   else
      Reset_Holiday := true;

   end if;
   if Reset_Holiday then
         -- deselect everything so that user can add a holiday if necessary
         Reset_Holiday_Screen(Object => Object);

   end if;

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Select_Click;

   procedure On_Activate_Holiday_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App             : App_Access := App_Access(Object.Connection_Data);
   begin
      App.Holiday_Record.Current_Holiday_Active :=
        not App.Holiday_Record.Current_Holiday_Active;

      If App.Holiday_Record.Current_Holiday_Active then
         App.Holiday_Record.Activate_Button.Text(Value =>Holiday_Active_String );
      else
         App.Holiday_Record.Activate_Button.Text(Value=> Holiday_Inactive_String);
      end if;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Activate_Holiday_Click;

   procedure On_Delete_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App             : App_Access := App_Access(Object.Connection_Data);

      The_Index : Natural := App.Holiday_Record.Holiday_Select.Selected_Index;

      Holiday   : Holiday_Record;
      Holiday_Name : constant String := Holiday.Holiday_Name(1..Holiday.Name_Length);
      Data_Delete_Success : Boolean;
   begin
      if (The_Index > 0) or
        (The_Index > Holiday_Manager(App.Location_Id).Number_Of_Holidays) then
         Holiday := Holiday_Manager(App.Location_Id)
           .Get_Holiday(The_Index => The_Index);
         Gnoga.log("deleting holiday " & Holiday_Name & " at position " & The_Index'img);
         -- delete the old holiday
         Holiday_Manager(App.Location_Id).Delete_Holiday
           (Description => Holiday.Holiday_Name(1..Holiday.Name_Length) ,
            Success     => Data_Delete_Success);
         -- delete the entry in holiday_select
         if Data_Delete_Success then
            App.Holiday_Record.Holiday_Select.Remove_Option
              (Index => The_Index);
         end if;
      else

         Gnoga.log(" Woah...bad delete index for the holiday....mmmaaaannnn");
      end if;
     Reset_Holiday_Screen (Object => Object);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));


   end On_Delete_Click;


   procedure Build_Holiday_View
     (App : in out App_Access) is



      Image_Holder  : Gnoga.Gui.Element.Common.DIV_Type;
      The_Image  : Gnoga.Gui.Element.Common.IMG_Type;
      --Matched_Image : Gnoga.Gui.Element.Common.IMG_Type;

      begin

      Image_Holder.Create(Parent => App.Form_Array(Holiday_View));

      Image_Holder.Place_After(App.Nav_Array(Holiday_View));

      The_Image.Create(Image_Holder,
                       "img/holiday.jpg");

      Gnoga.Log ("Starting Holidays screen");

      App.Holiday_Record.Title_Label.Create
        (Parent => App.Form_Array(Holiday_View),
         Content => "<H1>Holidays - Addition, modification and deletion<H1>");

      App.Holiday_Record.Title_Label.Place_After
        (App.Nav_Array(Holiday_View));


      App.Holiday_Record.Control_Fset.Create
        (Parent => App.Form_Array(Holiday_View));

      App.Holiday_Record.Control_Fset.Put_Legend
        (Value => "Please Insert Information");

      app.Holiday_Record.From_Dp.Create
        (Form  => App.Form_Array(Holiday_View),
         ID => "adfdp");

      App.Holiday_Record.To_Dp.Create
        (Form => App.Form_Array(Holiday_View),
         ID => "adtdp");


      App.Holiday_Record.From_Dp.Place_Inside_Top_Of
        (App.Holiday_Record.Control_Fset);

      App.Holiday_Record.To_Dp.Place_Inside_Bottom_Of
        (App.Holiday_Record.Control_Fset);


      App.Holiday_Record.Holiday_Input.Create
        (Form  => App.Form_Array(Holiday_View),
         Size  => 15);

      App.Holiday_Record.Holiday_Input.Place_Inside_Bottom_Of
        (App.Holiday_Record.Control_Fset);


      App.Holiday_Record.Holiday_Select.Create
        (Form            => App.Form_Array(Holiday_View),
         Multiple_Select => false,
         Visible_Lines   => 8);

      App.Holiday_Record.Holiday_Select.Place_Inside_Top_Of
        (App.Holiday_Record.Control_Fset);

      App.Holiday_Record.Activate_Button.Create
        (Parent  => App.Form_Array(Holiday_View),
         Content => "Activate");

      App.Holiday_Record.Activate_Button.Place_Inside_Bottom_Of
        (App.Holiday_Record.Control_Fset);


      App.Holiday_Record.Cancel_Button.Create
        (Parent  =>App.Form_Array(Holiday_View) ,
         Content => "Cancel");

      App.Holiday_Record.Cancel_Button.Place_Inside_Bottom_Of
        (App.Holiday_Record.Control_Fset);

      App.Holiday_Record.Update_Button.Create
        (Parent =>App.Form_Array(Holiday_View),
         Content => "Update");

      App.Holiday_Record.Update_Button.Place_Inside_Bottom_Of
        (App.Holiday_Record.Control_Fset);


      Gnoga.log ("Placemark pre load select reached ");


      Update_Holiday_View(App => App);


      App.Holiday_Record.Button_Fset.Create
        (Parent => App.Form_Array(Holiday_View));


      App.Holiday_Record.Button_Fset.Put_Legend
        (Value => "Change Holidays");

      App.Holiday_Record.Holiday_Select.Place_Inside_Top_Of
        (App.Holiday_Record.Button_Fset);

      App.Holiday_Record.Add_Button.Create
        (Parent => App.Form_Array(Holiday_View),
         Content => "Add Holiday");

      App.Holiday_Record.Add_Button.Place_Inside_Bottom_Of
        (App.Holiday_Record.Button_Fset);


      App.Holiday_Record.Delete_Button.Create
        (Parent => App.Form_Array(Holiday_View),
         Content => "Delete Holiday");

      App.Holiday_Record.Delete_Button.Place_Inside_Bottom_Of
        (App.Holiday_Record.Button_Fset);

      -- ** modify
      App.Holiday_Record.Modify_Button.Create
        (Parent => App.Form_Array(Holiday_View),
         Content => "Modify Holiday");

      App.Holiday_Record.Modify_Button.Place_Inside_Bottom_Of
        (App.Holiday_Record.Button_Fset);

      --update

      Gnoga.log(" Post modify create");

      -- click handlers

      App.Holiday_Record.Holiday_Select.On_Click_Handler
        (On_Select_Click'Unrestricted_Access);


      App.Holiday_Record.Delete_Button.On_Click_Handler
        (On_Delete_Click'Unrestricted_Access);

      App.Holiday_Record.Add_Button.On_Click_Handler
        (On_Add_Holiday_Click'Unrestricted_Access);

      App.Holiday_Record.Modify_Button.On_Click_Handler
        (On_Modify_Holiday_Click'Unrestricted_Access);

      App.Holiday_Record.Update_Button.On_Click_Handler
        (On_Update_Holiday_Click'Unrestricted_Access);

      App.Holiday_Record.Cancel_Button.On_Click_Handler
        (On_Cancel_Holiday_Click'Unrestricted_Access);


      App.Holiday_Record.Activate_Button.On_Click_Handler
        (On_Activate_Holiday_Click'Unrestricted_Access);

      -- set visibility
      App.Holiday_Record.Control_Fset.Visible(false);

      App.Holiday_Record.Modify_Button. Visible(False);

      App.Holiday_Record.Delete_Button. Visible(False);


      --App.Holiday_Record.To_Dp.On_Change_Handler
      -- (On_Date_Change'Unrestricted_Access);

      --         App.Holiday_Record.From_Dp.On_Change_Handler
      --         (On_Date_Change'Unrestricted_Access);

--      Gnoga.log(      app.Holiday_Record.From_Dp.Text);

      Gnoga.log(" ***** Got to the end of Build Holiday VIEW ****");
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Build_Holiday_View;

   procedure Update_Holiday_View
     (App : in out App_Access) is
      Holidays_Booked : Holiday_Array_Type :=
        Holiday_Manager(App.Location_Id).Holidays_Booked;
   begin
      Gnoga.log("Number of Holidays " & Holidays_Booked'length'img);
      If Holiday_Manager(App.Location_Id).
        Number_Of_Holidays > 0 then
      Populate_Select
        (Location_Id => App.Location_Id,
         The_Select => App.Holiday_Record.Holiday_Select,
         T_Array => Holidays_Booked);
      end if;

       exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Update_Holiday_View;

end Usna_Holidays_Pkg;
