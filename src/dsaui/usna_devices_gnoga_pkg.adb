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
package Body Usna_Devices_Gnoga_Pkg is

use Gnoga.Gui;



   package Su renames Ada.Strings.Unbounded;

   use Su;
   package SRN renames Schedules_Rooms_Devices_Indexes_Pkg;






  procedure Populate_Room_Select is new App_View_List_Support_Pkg.Generic_Populate_Select
     (T_Type           => Room_Record,
      Index_Type       => Room_Id_Type,
      T_Array_Type     => SRN.Room_Array_Type,
      Stringify_T_Type => Stringify_Types_Pkg.Stringify_Room);

   procedure Populate_Device_Select is new App_View_List_Support_Pkg.Generic_Populate_Select
     (T_Type           => Device_Index_Type,
      Index_Type       => natural ,
      T_Array_Type     => SRN.Device_List_Type,
      Stringify_T_Type => Stringify_Types_Pkg.Stringify_Device_Id);


   procedure On_Modify_Room_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'class) is
     App : App_Access := App_Access(Object.Connection_Data);

   begin
      App.Device_Record.Control_Fset.Hidden(Value => True);
      App.Device_Record.Update_Fset.Hidden(Value => false);
      App.Device_Record.Update_Button.Hidden(Value => true);
      App.Device_Record.Button_Fset.Hidden(Value => true);
       exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Modify_Room_Click;

   procedure On_Device_Select_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'class) is
      App : App_Access := App_Access(Object.Connection_Data);
      Device : Device_Details_Type;
      Room : Room_Record;
   begin
      App.Device_Record.Button_Fset.Hidden(Value => false);
     -- App.Device_Record.Modify_Button.Visible(Value => false);


      App.Device_Record.Current_Device_Id :=
        Get_Device_Id
          (Location_Id => App.Location_Id,
           Device_Name => App.Device_Record.Device_Select.Text
             ( App.Device_Record.Device_Select.Selected_Index));
      Device :=  Get_Device
        (Location_Id => App.Location_Id,
           Device_id => App.Device_Record.Current_Device_Id);
      Gnoga.log( Device.Name(1..Device.Name_Length) & " Chosen");
      if Device.Room_Id /= 0 then
         App.Device_Record.Current_Room_Id := Device.Room_Id;
         App.Device_Record.Room_Select.Selected(Index => Natural(Device.Room_Id),
                                           Value => true);
         Room := Get_Room
           (Location_Id => App.Location_Id,
           Room_Id => Device.Room_Id);
         App.Device_Record.Room_Label.Text
           (Value =>  Device.Name(1..Device.Name_Length) & " attached to " &
              Room.Room_Name(1..Room.Room_Name_Length));
      else
         App.Device_Record.Room_Label.Text
           (Value =>  Device.Name(1..Device.Name_Length) & " not attached ");
      end if;

 exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Device_Select_Click;

   procedure On_Room_Select_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'class) is
      App : App_Access := App_Access(Object.Connection_Data);

   begin
      App.Device_Record.Current_Room_Id := Get_Room_Id
        (Location_Id => App.Location_Id,
           Room_Name => App.Device_Record.Room_Select.Text
                (Index => App.Device_Record.Room_Select.Selected_Index));
      Gnoga.Log (App.Device_Record.Current_Room_Id'img & " selected ");
      App.Device_Record.Update_Button.Hidden(Value => false);
 exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Room_Select_Click;



     procedure On_Cancel_Button_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'class) is
      App : App_Access := App_Access(Object.Connection_Data);





   begin

      Gnoga.Log("index selected " & App.Device_Record.Room_Select.Selected_Index'img);
      if App.Device_Record.Room_Select.Selected_Index /= 0 then
         App.Device_Record.Room_Select.Selected
           (Index => App.Device_Record.Room_Select.Selected_Index,
                                        Value => False);
      end if;

      if App.Device_Record.Device_Select.Selected_Index /=0 then
         App.Device_Record.Device_Select.Selected
           (Index => App.Device_Record.Device_Select.Selected_Index,
            Value => False);
      end if;



       App.Device_Record.Control_Fset.Hidden(Value => false);
      App.Device_Record.Update_Fset.Hidden(Value => true);
     -- App.Device_Record.Update_Button.Hidden(Value => true);
      App.Device_Record.Button_Fset.Hidden(Value => true);
       exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

      end On_Cancel_Button_Click;


   procedure On_Update_Device_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'class) is
      App : App_Access := App_Access(Object.Connection_Data);
      --The_Device : Device_Details_Type :=
        --Get_Device(Device_id => App.Device_Record.Current_Device_Id);
      Success : boolean := false;
   begin
      Gnoga.log(" Moving Device " & App.Device_Record.Current_Device_Id'img
                  & " to room " & App.Device_Record.Current_Room_Id'img);
      Change_Room_To_Device
        (Location_Id => App.Location_Id,
           Device_Id => App.Device_Record.Current_Device_Id,
                             Room_Id   => App.Device_Record.Current_Room_Id,
         Success   => Success);


      Gnoga.Log("Change success ? : " & Success'img);
      On_Cancel_Button_Click (Object => Object);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Update_Device_Click;




   procedure Build_Device_View
  (App : in out App_Access) is
       Image_Holder  : Gnoga.Gui.Element.Common.DIV_Type;
      The_Image  : Gnoga.Gui.Element.Common.IMG_Type;
      --Matched_Image : Gnoga.Gui.Element.Common.IMG_Type;

      begin

      Image_Holder.Create(Parent => App.Form_Array(Device_View));

      Image_Holder.Place_After(App.Nav_Array(Device_View));

      The_Image.Create(Image_Holder,
                       "img/device.jpg");


      Gnoga.Log ("Starting Devices screen");

  -- App.View_Array(Device_View).Put_Line("<H1>Device Location - Pick a  Room<H1>");





      -- Widgets create


        App.Device_Record.Control_Fset.Create
        (Parent => App.Form_Array(Device_View));

      App.Device_Record.Button_Fset.Create
        (Parent => App.Form_Array(Device_View));

      App.Device_Record.Update_Fset.Create
        (Parent => App.Form_Array(Device_View));

    App.Device_Record.Title_Label.Create
        (Parent => App.Form_Array(Device_View),
         Content => "<H1>Device Location - Pick a  Room<H1>" );

      App.Device_Record.Modify_Button.Create
        (Parent => App.Form_Array(Device_View),
         Content => " Change Location of Device ");

      App.Device_Record.Cancel_Button.Create
        (Parent => App.Form_Array(Device_View),
         Content => " Cancel Change ");

      App.Device_Record.Update_Button.Create
        (Parent => App.Form_Array(Device_View),
         Content => " Update Change ");


      App.Device_Record.Room_Select.Create
        (Form => App.Form_Array(Device_View),
         Multiple_Select => false,
         Visible_Lines => 6);


      App.Device_Record.Device_Select.Create
        (Form => App.Form_Array(Device_View),
         Multiple_Select => false,
        Visible_Lines => 6);

      App.Device_Record.Room_Label.Create
        (Parent => App.Form_Array(Device_View),
         Content => "Which Room is Attached ? " );


          -- Placement of Widgets


      App.Device_Record.Modify_Button.Place_Inside_Top_Of
        (App.Device_Record.Button_Fset);

      App.Device_Record.Device_Select.Place_Inside_Top_Of
        (App.Device_Record.Control_Fset);

      App.Device_Record.Title_Label.Place_Inside_Top_Of
        (App.Device_Record.Control_Fset);

     -- App.Device_Record.Room_Label.Place_Inside_Bottom_Of
      --(App.Device_Record.Control_Fset);


       -- update Fset contains Room Name Input Schedule_select, update_botton
       -- and cancel button


       App.Device_Record.Room_Select.Place_Inside_Top_Of
         (App.Device_Record.Update_Fset);


       App.Device_Record.Update_Fset.New_Line;


       App.Device_Record.Cancel_Button.Place_Inside_Bottom_Of
         (App.Device_Record.Update_Fset);

       App.Device_Record.Update_Button.Place_Inside_Bottom_Of
         (App.Device_Record.Update_Fset);

      -- populate the Devices and Rooms!

      declare

         Devices_List : SRN.Device_List_Type :=
           SRN.Get_Device_List(Location_Id => App.Location_Id);


         Rooms_List : SRN.Room_Array_Type :=
           SRN.Get_All_Rooms(Location_Id => App.Location_Id);

      begin
         Populate_Device_Select(Location_Id => App.Location_Id,
                                The_Select => App.Device_Record.Device_Select,
                              T_Array => Devices_List);
         Populate_Room_Select(Location_Id => App.Location_Id,
                              The_Select =>  App.Device_Record.Room_Select,
                              T_Array => Rooms_List);

      end;

      -- items to hide
      App.Device_Record.Update_Fset.Hidden(Value => True);
      App.Device_Record.Button_Fset.Hidden(Value => True);
      -- handler attachment

      App.Device_Record.Modify_Button.On_Click_Handler
        (On_Modify_Room_Click'Unrestricted_Access);

      App.Device_Record.Device_Select.On_Click_Handler
        (On_Device_Select_Click'Unrestricted_Access);

      App.Device_Record.Room_Select.On_Click_Handler
        (On_Room_Select_Click'Unrestricted_Access);

      App.Device_Record.Update_Button.On_Click_Handler
        (On_Update_Device_Click'Unrestricted_Access);

      App.Device_Record.Cancel_Button.On_Click_Handler
        (On_Cancel_Button_Click'Unrestricted_Access);


 exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Build_Device_View;

procedure Update_Device_View
     (App : in out App_Access) is

      Devices_List : SRN.Device_List_Type :=
        SRN.Get_Device_List(Location_Id => App.Location_Id);

      Rooms_List : SRN.Room_Array_Type :=
        SRN.Get_All_Rooms(Location_Id => App.Location_Id);

      begin
      Populate_Device_Select(Location_Id => App.Location_Id,
                             The_Select => App.Device_Record.Device_Select,
                              T_Array => Devices_List);
         Populate_Room_Select(Location_Id => App.Location_Id,
                             The_Select => App.Device_Record.Room_Select,
                              T_Array => Rooms_List);
 exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Update_Device_View;




   end Usna_Devices_Gnoga_Pkg;
