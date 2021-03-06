with Gnoga.Application.Multi_Connect;
with Gnoga.Types;
with Gnoga.Gui.Window;
with Gnoga.Gui.View;
with Gnoga.Gui.Element.Common;
with Gnoga.Gui.Element;
with Gnoga.Gui.Element.Form;
with Gnoga.Gui.Element.Form.Fieldset;
with Gnoga.Gui.Plugin.jQueryUI;
with Ada.Strings.Unbounded;
with Room_Types_Pkg;
with Identity_Types_Pkg; use Identity_Types_Pkg;
with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;
with Usna_Rooms_Gnoga_Pkg;
with Usna_Login_View_Gnoga_Pkg;
with Ada.Exceptions;
with Usna_Admin_Gnoga_Pkg;
with Edit_Room_Details_Gnoga_Pkg;
with Label_Function_Pkg;
with User_Details_Gnoga_Pkg;
with Bookings_Gnoga_Pkg;
Package body  View_Change_Pkg is
   use Gnoga;
   use Gnoga.Types;
   use Gnoga.Gui;
   use Gnoga.Gui.Element;
   use Gnoga.Gui.Element.Form;
   use Gnoga.Gui.View;


   procedure Update_View
     (App : in out App_Access)
   is
      --App : App_Access := App_Access (Object.Connection_Data);
   begin
      Gnoga.log(" Update View " & App.Current_View_Selected'img );
      case App.Current_View_Selected is
         when Login_View =>
            Usna_Login_View_Gnoga_Pkg.Update_Login_View(App);

         when Admin_View =>
            Usna_Admin_Gnoga_Pkg.Update_Admin_View(App);

         when Rooms_View =>
            Usna_Rooms_Gnoga_Pkg.Update_Rooms_View(App);

         when Room_Edit_View =>
            Edit_Room_Details_Gnoga_Pkg.Update_Edit_Schedule_View(App);

         when User_Details_View =>
            User_Details_Gnoga_Pkg.Update_User_Details_View(App);

         when Bookings_View =>
            Bookings_Gnoga_Pkg.Update_Bookings_View(App);

      end case;
      Gnoga.Log(App.Current_View_Selected'img & "updated ");
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Update_View;



   procedure Build_View
     (App : in out App_Access)
   is
      --App : App_Access := App_Access (Object.Connection_Data);
   begin
      Gnoga.log(" Build View " & App.Current_View_Selected'img );

      case App.Current_View_Selected is
         when Login_View =>
            Usna_Login_View_Gnoga_Pkg.Build_Login_View(App);

         when Admin_View =>
            Usna_Admin_Gnoga_Pkg.Build_Admin_View(App);

         when Rooms_View =>
            Usna_Rooms_Gnoga_Pkg.Build_Rooms_View (App);

         when Room_Edit_View =>
            Edit_Room_Details_Gnoga_Pkg.Build_Edit_Schedule_View(App);

         when User_Details_View =>
            User_Details_Gnoga_Pkg.Build_User_Details_View(App);

         when Bookings_View =>
            Bookings_Gnoga_Pkg.Build_Bookings_View(App);


      end case;
      Gnoga.Log(App.Current_View_Selected'img & "created ");
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Build_View;


   procedure Show_View
     (App : in out App_Access)
   is
      --App : App_Access := App_Access (Object.Connection_Data);
   begin


      if App.View_Initial (App.Current_View_Selected) then

         App.View_Initial (App.Current_View_Selected) := false;
         Gnoga.log("building view");
         Build_View (App);
         App.View_Initial (App.Current_View_Selected) := false;

      else
         Update_View(App);
      end if;
      gnoga.log("End of Show View ");
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Show_View;

   procedure New_Content_View
     (App : in out App_Access)
   is
      -- App : App_Access := App_Access (Object.Connection_Data);
   begin
      if App.Current_View_Selected /= App.Requested_View_Selected then
         Gnoga.Gui.Plugin.jQueryUI.Hide_With_Effect
           (Element            => App.View_Array(App.Current_View_Selected),
            Effect_Name        => "slide");

      end if;

      App.Current_View_Selected := App.Requested_View_Selected;
      if App.View_Initial(App.Current_View_Selected ) then
         Build_View(App => App);
         App.View_Initial(App.Current_View_Selected ) := false;
      end if;

      App.View_Array(App.Current_View_Selected).Visible(true);
      Show_View(App);


      Gnoga.Gui.Plugin.jQueryUI.Show_With_Effect
        (Element            => App.View_Array(App.Current_View_Selected),
         Effect_Name        => "slide");

      Gnoga.log("Slide triggered to " & App.Requested_View_Selected'img);


   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end New_Content_View;

   procedure Go_To_Edit_Room_View
     (Object : in out Gnoga.Gui.Base.Base_Type'Class)
   is
      App : App_Access := App_Access (Object.Connection_Data);

   begin
      App.Requested_View_Selected := Rooms_View;
      New_Content_View (App);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Go_To_Edit_Room_View;


   -- there has to be a better way to do this
   procedure Go_To_User_Details_View
     (Object : in out Gnoga.Gui.Base.Base_Type'Class)
   is
      App : App_Access := App_Access (Object.Connection_Data);

   begin
      App.Requested_View_Selected := User_Details_View;
      New_Content_View (App);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Go_To_User_Details_View;

   procedure Go_To_Bookings_View
     (Object : in out Gnoga.Gui.Base.Base_Type'Class)
   is
      App : App_Access := App_Access (Object.Connection_Data);

   begin
      App.Requested_View_Selected := Bookings_View;
      New_Content_View (App);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Go_To_Bookings_View;

   procedure Go_To_Rooms_View
     (Object : in out Gnoga.Gui.Base.Base_Type'Class)
   is
      App : App_Access := App_Access (Object.Connection_Data);

   begin
      App.Requested_View_Selected := Rooms_View;
      New_Content_View (App);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Go_To_Rooms_View;

   procedure Go_To_Admin_View
     (Object : in out Gnoga.Gui.Base.Base_Type'Class)
   is
      App : App_Access := App_Access (Object.Connection_Data);
   begin
      App.Requested_View_Selected := Admin_View;
      New_Content_View (App);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Go_To_Admin_View;



   procedure Build_And_Connect_Common_Buttons (App : in out App_Access) is

      View : View_Select_Type := App.Current_View_Selected;
      Am_I_An_Admin : boolean := App.Admin;
      type Function_Access is access procedure  (Object : in out Gnoga.Gui.Base.Base_Type'Class);
      Function_Array : array(View_Select_Type) of Function_Access :=
        (Login_View => null,
         Admin_View => Go_To_Admin_View'Access,
         Rooms_View => Go_To_Rooms_View'Access,
         Room_Edit_View => Go_To_Edit_Room_View'access,
         User_Details_View => Go_To_User_Details_View'access,
         Bookings_View => Go_To_Bookings_View'access);

   begin
     Gnoga.log("build connect buttons called ");
      -- Make The Fieldset to contain the navigation buttons
      -- may be this will work
      if Am_I_An_Admin then
         App.Nav_Array_Start := Admin_View;
      else
         App.Nav_Array_Start := Rooms_View;
      end if;

      Gnoga.log("Last View is " & View_Nav_Array_Type'last'img);


      for view_count in  App.Nav_Array_Start.. View_Nav_Array_Type'last loop
           App.Nav_Array(view_count).Create
              (Parent => App.Form_Array(view_count));
            App.Nav_Array(view_count).Place_Inside_Top_Of
              (Target => App.Form_Array(view_count));
            Gnoga.log( view_count'img & "placed " );
         for count in App.Nav_Array_Start.. View_Nav_Array_Type'last loop




            declare
               Button_Content : constant string :=
                 Ada.Strings.Unbounded.To_String(Usna_App_Data_Pkg.Common_Button_Names(count));
            begin
               if view_count /= count then
                  App.Common_Buttons(count,view_count).Create
                    (Parent  => App.View_Array(view_count),
                     Content => Button_Content);

                  App.Common_Buttons(count,view_count).On_Click_handler
                    (Handler => Function_Array(count).all'unrestricted_access);

                  App.Common_Buttons(count,view_count).Place_Inside_Top_Of
                    (Target => App.Nav_Array(view_count));

               end if;
            exception
               when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

            end;

         end loop;

      end loop;








   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Build_And_Connect_Common_Buttons;


   procedure On_Connect_App
     (Main_Window : in out Gnoga.Gui.Window.Window_Type'Class;
      Connection  : access Gnoga.Application.Multi_Connect.Connection_Holder_Type) is

      App :  App_Access := new App_Data;

   begin
      -- for testing until password api is fitted
      --App.Admin := true;
      -- App.Location_id := 1;
      -----****

      if App.Admin then
         Gnoga.log("Starting Admin Screen");

      else
         Gnoga.log("Starting Rooms View ");
      end if;

      -- create the window, view and widgets
      Main_Window.Connection_Data(App);
      App.Main_Window := Main_Window'Unchecked_Access;
      Gnoga.Gui.Plugin.jQueryUI.Load_jQueryUI(Window => Main_Window);

      Main_Window.Document.Body_Element.Font
        (Family  => "Verdana, Arial",
         Height  => "20px");

      for count in View_Select_Type loop
         Gnoga.log("View Create being called for  " & count'img);
        App.View_Array(count).Create(Parent => Main_Window);

         Gnoga.log("View Created " & count'img);

         App.Form_Array(count).Create
           (Parent => App.View_Array(count));
         App.View_Array(count).Visible(false);
         Gnoga.log("Form Created" & count'img);
      end loop;


      App.Requested_View_Selected := Login_View;
      New_Content_View(App);

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end On_Connect_App;


end View_Change_Pkg;
