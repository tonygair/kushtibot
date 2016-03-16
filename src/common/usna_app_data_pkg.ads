with Gnoga.Types;
with Gnoga.Gui.Window;
with Gnoga.Gui.View;
with Gnoga.Gui.Element.Common;
with Gnoga.Gui.Element;
with Gnoga.Gui.Element.Form;
with Gnoga.Gui.Element.Form.Fieldset;
with Gnoga.Gui.Plugin.jQuery;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Room_Types_Pkg;
with Identity_Types_Pkg; use Identity_Types_Pkg;
with UI_Related_Access_Types_Pkg; use UI_Related_Access_Types_Pkg;
with Deallocate_And_Access_Types_Pkg; use Deallocate_And_Access_Types_Pkg;
package Usna_App_Data_Pkg is

   use Gnoga;
   use Gnoga.Types;
   use Gnoga.Gui;
   use Gnoga.Gui.Element;
   use Gnoga.Gui.Element.Form;

   type View_Select_Type is
     (Login_View,
      Admin_View,
      Rooms_View,
      Room_Edit_View--,
      --Edit_Room_View,
      --Holiday_View
     );





   type View_Initial_Array is array (View_Select_Type) of boolean;

   type View_Array_Type is Array ( View_Select_Type) of aliased View.View_Type;


   type Common_Button_Array is Array (View_Select_Type,View_Select_Type) of Common.Button_Type;

   type Location_Button_Array is array(Location_Id_Type) of Common.Button_Type;

   type Ub2_String_Array is Array
     (View_Select_Type  range Admin_View..Rooms_View)
     of Unbounded_String;

   type Ub_String_Array is Array
     (View_Select_Type  range Admin_View..Rooms_View)
     of Ub2_String_Array;
   Common_Button_Names : constant Ub_String_Array :=
     ( Others =>
         (  To_Unbounded_String("Admin View "),
            To_Unbounded_String("Rooms View ")--,
           -- To_Unbounded_String("Edit Room")--,
           -- To_Unbounded_String("Edit Holidays")
           )
      );

   type Form_Array_Type is array(View_Select_Type)
     of Form.Form_Type;

   type View_Nav_Array is array(View_Select_Type) of Form.Fieldset.Fieldset_Type;


   type Login_Window_Data_Record is record

      Title_Label : Common.Span_Type;
      Password_Label : Common.Span_Type;
      Email_Label : Common.Span_Type;
      The_Email : Email_Type;
      The_Password : Password_Type;
      Login_Button : Common.Button_Type;
      Error_Tag : Common.Span_Type;

   end record;



   type Location_Boolean_Array_Type is array(Location_Id_Type) of boolean;

   type Admin_Window_Data_Record is record

      Location_Array : Location_Array_String_Type;
      Buttons : Location_Button_Array;
      Button_Creation : Location_Boolean_Array_Type := (others => false);
      Max_Location_Id : Location_Id_Type;
      Title_Label : Common.Span_Type;

      --Device_Input : Form.Text_Type;


   end record;

   type Rooms_Window_Data_Record is record

      Title_Label : Common.Span_Type;
      Back_Button : Common.Button_Type;
      Room_Buttons: Room_Button_Array_Access;
      Max_Room_Id, Current_Room_Id : Room_Id_Type;




   end record;

   type Day_Schedule_Buttons_Array_Type is array(Hour_Day_Schedule_Type) of
     Gnoga.Gui.Element.Common.Button_Type;

   type Week_Schedule_Buttons_Array_Type is array (Weekday_Type)
     of Day_Schedule_Buttons_Array_Type;

   type Weekly_Tags_Array_Type is array(Weekday_Type) of Form.Fieldset.Fieldset_Type;



   type Week_Button_Set_Type is array (Weekday_Type) of  Gnoga.Gui.Element.Common.Button_Type;


   type Edit_Rooms_Window_Data_Record is Record

      Title_Label : Common.Span_Type;
      Back_Button : Common.Button_Type;


      This_Room : Room_Id_Type;
      Room_Data : RIR_Access;

      -- for mode and temperature setting
      Mode_Fset : Form.Fieldset.Fieldset_Type;
      Temp_Reading         : Common.Span_Type;

      Plus_Button,
      Minus_Button : Common.Button_Type;
      Mode_Button  : Common.Button_Type;
      Temp_Meter   : Common.Meter_Type;

      -- for Schedule Setting
      Current_Mode : Energy_Mode_Type := Economy_Mode;

      Mode_Temperatures : Mode_Temperature_Type :=
        (Economy_Mode => 15.0,
         Comfort_Mode => 21.0);

       -- Fsets for form
      Schedule_Button_Fset : Form.Fieldset.Fieldset_Type;

      Week_Day_Sets :  Weekly_Tags_Array_Type;
      The_Week : Week_Schedule_Type := (others => null) ;
      The_Weeks_Buttons : Week_Schedule_Buttons_Array_Type;
      The_Week_Reset_Buttons : Week_Button_Set_Type;
      The_Week_Transmit_Buttons : Week_Button_Set_Type;

   end Record;




  type Edit_Room_Record is Record

      Title_Label : Common.Span_Type;
      Back_Button : Common.Button_Type;


      Temp_Reading         : Common.Span_Type;

      Plus_Button,
      Minus_Button : Common.Button_Type;
      Mode_Button  : Common.Button_Type;
      Temp_Meter   : Common.Meter_Type;

      Command_Fset          : Form.Fieldset.Fieldset_Type;
      Overall_Schedule_Fset : Form.Fieldset.Fieldset_Type;
      Command_Delete_Button : Common.Button_Type;
      Command_Add_Button    : Common.Button_Type;

      Command_Select             : Form.Selection_Type;
      --Command_Details_Label      : Common.Span_Type;
      Command_Popup              : Gnoga.Gui.Window.Window_Type;

      -- mod the command buttons
      Command_Select_Fset : Form.Fieldset.Fieldset_Type;
      Command_Mode_Button : Common.Button_Type;
      Hour_Button         : Common.Button_Type;
      Minute_Button       : Common.Button_Type;
      Day_Button          : Common.Button_Type;
      Am_Pm_Button        : Common.Button_Type;

     Right_Click_Active : boolean := false;
   end Record;



--     type Holiday_Window_Data_Record is record
--
--        Title_Label : Common.Span_Type;
--
--        Button_Fset,
--        Control_Fset    : Form.Fieldset.Fieldset_Type;
--        Add_Button,
--        Delete_Button,
--        Modify_Button   : Common.Button_Type;
--
--        Activate_Button,
--        Cancel_Button,
--        Update_Button : Common.Button_Type;
--        Holiday_Input  : Form.Text_Type;
--        Holiday_Select : Form.Selection_Type;
--        From_Dp, To_Dp : Form.Date_Type;
--        Holiday_Replace : Boolean := true;
--        Old_Holiday_Name : Holiday_Name_Type;
--        Old_Holiday_Name_Length : Natural := 0;
--        Current_Holiday_Active : Boolean;
--     end record;







   Type App_Data is new Gnoga.Types.Connection_Data_Type with
      record
         Main_Window : aliased Window.Pointer_To_Window_Class;
         -- views
         Room_Change  : Boolean := true;
         Location_Change :Boolean := true;
         Email_And_Password_Valid : Boolean := false;
         Admin : boolean := false;
--           Current_Schedule : Unbounded_String := To_Unbounded_String("");
--           Current_Command_Id : Command_Id_Type := 0;
         Location_id : Location_Id_Type;

         View_Initial : View_Initial_Array := ( others => true);

         Current_View_Selected,
         Requested_View_Selected : View_Select_Type:= Login_View;

         View_Array : View_Array_Type;

         Form_Array : Form_Array_Type;

         Common_Buttons : Common_Button_Array;

         Nav_Array : View_Nav_Array;
         -- data records for each view

         Login_Record : Login_Window_Data_Record;

         Admin_Record : Admin_Window_Data_Record;

         Rooms_Record : Rooms_Window_Data_Record;

            Edit_Record : Edit_Rooms_Window_Data_Record;


         --Holiday_Record : Holiday_Window_Data_Record;

      end Record;

   type App_Access is access all App_Data;





end Usna_App_Data_Pkg;