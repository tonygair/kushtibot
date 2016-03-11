
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

with Schedule_Information_Pkg; use Schedule_Information_Pkg;
with Schedule_Functions_Pkg; use Schedule_Functions_Pkg;
--with Test_Schedule_Data_Pkg;
with App_View_List_Support_Pkg;
--with Selection_Information_Pkg; use Selection_Information_Pkg;
with Ada.Exceptions; use Ada.Exceptions;
with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;
with Identity_Types_Pkg; use Identity_Types_Pkg;
--with Abbreviated_Types_Pkg; use Abbreviated_Types_Pkg;
with View_Change_Pkg;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
package body Usna_Schedules_Gnoga_Pkg is

   use Gnoga;
   use Gnoga.Types;
   use Gnoga.Gui;
   use Gnoga.Gui.Element;




   procedure Populate_Schedule_Select is new
     App_View_List_Support_Pkg.Generic_Populate_Select
       (T_Type           => Unbounded_String,
        Index_Type => Natural,
        T_Array_Type     => Schedule_List_Type ,
        Stringify_T_Type => To_String);


   procedure On_Schedule_Name_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App             : App_Access :=  App_Access(Object.Connection_Data);
      Schedule_Array  : Schedule_List_Type :=
        Schedule_Information_Pkg.List_The_Schedules(Location_Id => App.Location.Location_Id);
      Schedule_Name : constant string := App.Schedule_Record.Schedule_Select.Text
        (App.Schedule_Record.Schedule_Select.Selected_Index);
      Schedule_Id : Schedule_Id_Type := Schedule_Information_Pkg.Schedule_Id
        (Location_Id   => App.Location.Location_Id,
         Schedule_Name => Schedule_Name);

   begin
      Gnoga.log("Name : " & Schedule_Name & " Schedule Id : " & Schedule_Id'img );
      --App.Schedule_Record.New_Schedule_Button.Hidden(Value=>true);
      --App.Schedule_Record.New_Schedule_Button.Visible(Value=>false);
      App.Schedule_Record.Modify_Existing_Schedule_Button.Hidden(Value=> false);
      App.Schedule_Record.Modify_Existing_Schedule_Button.Visible(Value => true);
      App.Schedule_Record.Remove_Schedule_Button.Hidden(Value=> false);
      App.Schedule_Record.Remove_Schedule_Button.Visible(Value=> true);
      App.Current_Schedule := Schedule_Array
        (App.Schedule_Record.Schedule_Select.Selected_Index);
      Gnoga.log(To_String(App.Current_Schedule));
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Schedule_Name_Click;

   procedure On_Modify_Schedule_Click(Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App             : App_Access := App_Access(Object.Connection_Data);

   begin
      -- redirect to the /editschedule
      -- how do we do that ?
      --find out
      -- we form a new selection of commands based on which schedule
      App.Schedule_Record.Modify_Existing_Schedule_Button.Visible(false);
      App.Schedule_Record.Modify_Existing_Schedule_Button.Hidden(true);

      App.Requested_View_Selected:= Edit_Schedule_View;
      View_Change_Pkg.New_Content_View(App);

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Modify_Schedule_Click;

   procedure On_New_Schedule_Button_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App : App_Access := App_Access(Object.Connection_Data);

      New_Schedule_Name           : constant String :=
        App.Schedule_Record.Schedule_Input.Value;
      Invalid_Schedule, Added_Ok  : boolean := false;
      New_Schedule_Index          : Schedule_Id_Type ;
   begin

      Gnoga.log("New schedule clicked" & New_Schedule_Name);
      if New_Schedule_Name = "" then
         Invalid_Schedule := true;
      else
         Schedule_Information_Pkg.Add_Weekly_Schedule
           (Location_Id => App.Location.Location_Id,
            Schedule_Name => New_Schedule_Name, Success       => Added_Ok);
         If Added_Ok then --add to the onscreen list
            New_Schedule_Index := Schedule_Id
              (Location_Id => App.Location.Location_Id,
               Schedule_Name => New_Schedule_Name);
            App.Schedule_Record.Schedule_Select.Add_Option
              (Value    => New_Schedule_Index'img,
               Text     => New_Schedule_Name,
               Index    => integer(New_Schedule_Index),
               Selected => false,
               Disabled => false);
            App.Schedule_Record.Schedule_Input.Value (Value => "");
         end if;
      end if;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_New_Schedule_Button_Click;


   procedure Build_Schedule_View
     (App: in out App_Access) is
      Stored_Schedules : Schedule_List_Type :=
        Schedule_Information_Pkg.List_The_Schedules
      (Location_Id => App.Location.Location_Id);


        Image_Holder  : Gnoga.Gui.Element.Common.DIV_Type;
      The_Image  : Gnoga.Gui.Element.Common.IMG_Type;
      --Matched_Image : Gnoga.Gui.Element.Common.IMG_Type;

      begin

      Image_Holder.Create(Parent => App.Form_Array(Schedule_View));

      Image_Holder.Place_After(App.Nav_Array(Schedule_View));

      The_Image.Create(Image_Holder,
                       "img/schedule.jpg");


      -- title Widget
      App.Schedule_Record.Title_Label.Create
        (Parent => App.Form_Array(Schedule_View),
         Content => "<H1>Schedule Adjustment <H1>");

      App.Schedule_Record.Title_Label.Place_After
        (App.Nav_Array(Schedule_View));


      --create the Schedule list from storage

      Gnoga.Log( "Number of schedules :- " & Stored_Schedules'length'img);

      App.Schedule_Record.New_Schedule_Button.Create
        (Parent  => App.Form_Array(Schedule_View),
         Content => "New Schedule",
         ID      => "New_Schedule_Id" );

      App.Schedule_Record.Modify_Existing_Schedule_Button.Create
        (Parent  => App.Form_Array(Schedule_View),
         Content => "Modify Schedule",
         ID      => "Modify_Schedule_Id");

      App.Schedule_Record.Modify_Existing_Schedule_Button.On_Click_Handler
        (On_Modify_Schedule_Click'Unrestricted_Access);

      App.Schedule_Record.Remove_Schedule_Button.Create
        (Parent  => App.Form_Array(Schedule_View),
         Content => "Delete Schedule",
         ID      => "Delete_Schedule_Id");




      -- for form
      Gnoga.Log("Got to here ");
      App.Schedule_Record.Schedule_FSet.Create(App.Form_Array(Schedule_View));

      App.Schedule_Record.Schedule_FSet.Put_Legend(" Schedules ");

      App.Schedule_Record.Schedule_Input.Create
        (Form =>App.Form_Array(Schedule_View),
         Size=> 20,
         Id =>"Scid");

      App.Schedule_Record.Schedule_Input.Place_Inside_Bottom_Of
        (App.Schedule_Record.Schedule_FSet);

      App.Schedule_Record.Schedule_Select.Create
        (Form            => App.Form_Array(Schedule_View),
         Multiple_Select => false,
         Visible_Lines   => 5);

      App.Schedule_Record.Schedule_Select.Place_Inside_Bottom_Of
        (App.Schedule_Record.Schedule_FSet);

      App.Schedule_Record.New_Schedule_Button.On_Click_Handler
        (On_New_Schedule_Button_Click'Unrestricted_Access);

      App.Schedule_Record.New_Schedule_Button.Place_Inside_Bottom_Of
        (App.Schedule_Record.Schedule_FSet);

      Populate_Schedule_Select
        (Location_Id => App.Location.Location_Id,
         The_Select => App.Schedule_Record.Schedule_Select,
         T_Array => Stored_Schedules);



      App.Schedule_Record.Schedule_Select.On_Click_Handler
        (On_Schedule_Name_Click'Unrestricted_Access);

      -- create the Command page but not the select, thats going to be dynamic

      App.Schedule_Record.Modify_Existing_Schedule_Button.Hidden(Value=> true);

      App.Schedule_Record.Modify_Existing_Schedule_Button.Visible(Value => false);

      App.Schedule_Record.Remove_Schedule_Button.Hidden(Value=> true);
      App.Schedule_Record.Remove_Schedule_Button.Visible(Value=> false);
      Gnoga.Log("Got to the end of Build Schedule View");

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Build_Schedule_View;

   procedure Update_Schedule_View
     (App : in out App_Access) is
      Stored_Schedules : Schedule_List_Type :=
        Schedule_Information_Pkg.List_The_Schedules
      (Location_Id => App.Location.Location_Id);

   begin
      Populate_Schedule_Select
        (Location_Id => App.Location.Location_Id,
         The_Select => App.Schedule_Record.Schedule_Select,
         T_Array => Stored_Schedules);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Update_Schedule_View;






end Usna_Schedules_Gnoga_Pkg;
