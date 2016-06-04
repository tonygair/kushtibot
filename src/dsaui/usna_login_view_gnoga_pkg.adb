--with User_Password_Check_Pkg; use User_Password_Check_Pkg;
--with App_Common_Functions_Pkg; use App_Common_Functions_Pkg;
--with User_And_Location_Types_Pkg; use User_And_Location_Types_Pkg;
--with User_Location_Pkg; use User_Location_Pkg;
--with Stringify_Types_Pkg; use Stringify_Types_Pkg;
with Ada;
with Ada.Exceptions;
with View_Change_Pkg;
with Gnoga.Gui.Element;
with Gnoga.Gui.Element.Common;
with Gnoga.Gui.Element.Common;
with Identity_Types_Pkg; use Identity_Types_Pkg;
with Dsa_Usna_Server;
package body Usna_Login_View_Gnoga_Pkg is

   procedure On_Login_Button_Click
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      App    : App_Access :=  App_Access(Object.Connection_Data);
      Email_String : constant string
        := App.Login_Record.The_Email.Value;
      Password_String : constant string
        := App.Login_Record.The_Password.Value;
      --Email_And_Password_Valid : boolean := false;


      Serial_No : Serial_Type := Dsa_Usna_Server.Check_User_Password
        (User=> Email_String,
         Password => Password_String);
      Admin : boolean := Dsa_Usna_Server.Is_User_An_Admin(Email_String);

   begin
      Gnoga.log(" Serial Number : " & string(Serial_No) &
                  " Email " & Email_String & " Password " & Password_String);

      Gnoga.log(" Is an Admin ? " & Admin'img);
      App.Admin := Admin;
      If Serial_No = Bad_Password_Serial  then
         App.Form_Array(Login_View).Put_Line("<H1> Bad Password <H1>");
         Gnoga.log("Bad Password ");
      elsif Serial_No = Good_Password_No_Serial and not Admin then
         App.Form_Array(Login_View).Put_Line("<H1> Good Password No Serial <H1>");

         Gnoga.log("Good Password : No serial assigned ");
      else

         if not App.Admin then
            Gnoga.log(" Not an Admin, but the user has a good password and has registered a serial number ");

            App.Location_id := Dsa_Usna_Server.Check_Serial (Serial_Number => Serial_No);

            Gnoga.log("Serial_Number " & string(Serial_No) &
                        "Location id" & App.Location_id'img);
            App.Location_Change := true;

            App.Requested_View_Selected := Rooms_View;
            View_Change_Pkg.New_Content_View(App);
         else
            Gnoga.log("User is an admin");

            App.Requested_View_Selected := Admin_View;
            View_Change_Pkg.New_Content_View(App);
         end if;
      end if;

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));


   end On_Login_Button_Click;



   procedure Update_Login_View (App : in out App_Access) is

   begin
      Gnoga.Log("Update  Login View Triggered ");

      null;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Update_Login_View;

   procedure Build_Login_View (App : in out App_Access) is

      Image_Holder  : Gnoga.Gui.Element.Common.DIV_Type;
      The_Image  : Gnoga.Gui.Element.Common.IMG_Type;
      --Matched_Image : Gnoga.Gui.Element.Common.IMG_Type;

   begin

      Image_Holder.Create(Parent => App.View_Array(Login_View));
      Gnoga.Log("Build Login View Triggered ");

      Image_Holder.Place_Before(App.Form_Array(Login_View));

      The_Image.Create(Image_Holder,
                       "img/wslogo.png");


      App.Login_Record.Title_Label.Create
        (Parent => App.Form_Array(Login_View),
         Content => "<H1> Welcome to Warm and Smart CIC <H1>");



      App.Login_Record.Email_Label.Create
        (Parent => App.Form_Array(Login_View),
         Content => "User : ");

      App.Login_Record.Email_Label.Place_After
        (Target => App.Login_Record.Title_Label);

      App.Login_Record.The_Email.Create
        (Form => App.Form_Array(Login_View));

      --App.Login_Record.The_Email.Place_After
      --  (App.Login_Record.Email_Label);
      -- App.Form_Array(Login_View).New_Line;

      App.Login_Record.Password_Label.Create
        (Parent => App.Form_Array(Login_View),
         Content => "Password : ");


      App.Login_Record.The_Password.Create
        (Form => App.Form_Array(Login_View));

      App.Form_Array(Login_View).New_Line;

      App.Login_Record.Login_Button.Create
        (Parent => App.Form_Array(Login_View),
         Content => "Log Me In");


      App.Login_Record.Login_Button.On_Click_Handler
        (On_Login_Button_Click'Unrestricted_Access);
      Gnoga.Log("END Build Login View  ");
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Build_Login_View;



end Usna_Login_View_Gnoga_Pkg;
