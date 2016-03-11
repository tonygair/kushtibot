
with Gnoga.Application.Multi_Connect;
with Gnoga.Gui.Window;
with Gnoga.Gui.View;
with Gnoga.Gui.Element.Common;
with Gnoga.Gui.Element; use Gnoga.Gui.Element;
with Gnoga.Gui.Base;
with Gnoga.Gui.Navigator;
with Gnoga.Gui.Element.List;
with Gnoga.Types;
with Ada.Strings.Unbounded;
with Gnoga.Gui.Element.Form.Fieldset;
with Gnoga.Gui.Element.List;
with App_View_List_Support_Pkg;
with Ada.Exceptions; use Ada.Exceptions;

with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;
with Identity_Types_Pkg; use Identity_Types_Pkg;
with Label_Function_Pkg; use Label_Function_Pkg;
with Gnoga.Gui.Window;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Dsa_Usna_Server;
with View_Change_Pkg;
with Deallocate_And_Access_Types_Pkg;
with UI_Related_Access_Types_Pkg; use UI_Related_Access_Types_Pkg;
package Body Usna_Rooms_Gnoga_Pkg is

   --- this package will be used to create a gnoga interface to create rooms, and attach nodes
   -- and schedules to them so that this can reflect the user interface.

   use Gnoga.Gui;



   function Stringify_Rir ( Rir : in Room_Information_Record)
                           return String is
   begin
      return "<H1>" & Rir.Room_Name & ": Sp-" &Rir.Set_Point'img & " Act-"
        & Rir.Actual'img & "<H1>";
   end Stringify_Rir;

   procedure Go_to_Edit_Room  (Object : in out Gnoga.Gui.Base.Base_Type'Class) is

        The_Id : constant string := Object.Id;
      Room_Id : Room_Id_Type :=
        Label_Function_Pkg.Get_Room_Id_From_Label(The_Id);
       App : App_Access := App_Access (Object.Connection_Data);

   begin
      Gnoga.log("Go to room calledd for room id " & Room_Id'img);

      App.Edit_Record.This_Room:= Room_Id;
      App.Requested_View_Selected:= Room_Edit_View;
   View_Change_Pkg.New_Content_View(App => App);

     end Go_to_Edit_Room;
   -- end event click procedures

   procedure Display_Portfolio (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
       App : App_Access := App_Access (Object.Connection_Data);

   begin
      App.Location_id := 0;
      App.Requested_View_Selected:= Admin_View;
      View_Change_Pkg.New_Content_View(App => App);

   end Display_Portfolio;

      procedure Build_Rooms_View
        (App : in out App_Access) is
         --App : App_Access := App_Access(Object.Connection_Data);

         Total_Rooms : Room_Id_Type :=
           Dsa_Usna_Server.Get_Number_Of_Rooms(App.Location_id);
         New_Room_Button_Array : Room_Button_Array_Type
           (1..Total_Rooms);
   begin

      if App.Rooms_Record.Back_Button.ID = "Room Back Button" or App.Admin then
         null;
      else
         App.Rooms_Record.Title_Label.Create
        (Parent  => App.Form_Array(Rooms_View),
         Content => "<H1> Editing " &  App.Edit_Record.Room_Data.Room_Name & "'s schedule <H1>");
         App.Rooms_Record.Back_Button.Create(Parent  => App.Form_Array(Rooms_View) ,
                                             Content => "Back to  Portfolio",
                                             ID      => "Room Back Button" );
         App.Rooms_Record.Back_Button.On_Click_Handler(Handler => Display_Portfolio'Unrestricted_Access);
      end if;

         App.Rooms_Record.Max_Room_Id := Total_Rooms;
         for count in 1..Total_Rooms loop
            declare
               Rir : Room_Information_Record := Dsa_Usna_Server.Get_Room_Data
                 (Location => App.Location_id,
                  Room     => count);
         begin
            App.Rooms_Record.Room_Buttons := new Room_Button_Array_Type(1..Total_Rooms);
            Gnoga.log( "Total Rooms" & Total_Rooms'img);

            if Rir.Roomname_Length > 0 then
               App.Rooms_Record.Room_Buttons.all(count).Create(Parent  => App.Form_Array(Rooms_View),
                                                   Content => Stringify_Rir(Rir => Rir),
                                                   ID      => Make_Room_Label(Room => Count));


               App.Rooms_Record.Room_Buttons.all(count).On_Click_Handler
                 (Handler =>   Go_to_Edit_Room'Unrestricted_Access);
             --New_Room_Button_Array(count).

               App.Form_Array(Rooms_View).New_Line;
            end if;

            end;

         end loop;
      App.Room_Change := false;

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));


   end Build_Rooms_View;

   procedure Update_Rooms_View
     (App : in out App_Access) is



   begin
      Gnoga.log("Update_Rooms_View called ");
      if App.Room_Change then
         Deallocate_And_Access_Types_Pkg.Deallocate_Room_Buttons_Access(App.Rooms_Record.Room_Buttons);
         Build_Rooms_View(App=>App);
         App.Room_Change := false;
      end if;

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Update_Rooms_View;


end Usna_Rooms_Gnoga_Pkg;
