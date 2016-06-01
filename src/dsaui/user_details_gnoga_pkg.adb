with User_Password_Check_Pkg;
package body  User_Details_Gnoga_Pkg is

   procedure Build_User_Details_View
     (App : in out App_Access) is

   begin
      App.User_Record.Title_Label.Create
        (Parent => App.Form_Array(User_Details_View),
         Content => "<H1> User Details Change Screen <H1>");

      App.User_Record.Email_Label.Create
        (Parent => App.Form_Array(User_Details_View),
         Content => "Email to change " );

      App.User_Record.Email_First.Create
        (Form => App.Form_Array(User_Details_View),
         Value => App.Login_Record.The_Email.Value);

      App.User_Record.Email_First.Visible(Value => False);

      App.Form_Array(User_Details_View).New_Line;

      App.User_Record.Email_Compare_Label.Create
        (Parent => App.Form_Array(User_Details_View),
         Content => "Type Email Again ");

      App.User_Record.Email_Second.Create
        (Form => App.Form_Array(User_Details_View),
         Value => App.Login_Record.The_Email.Value);

      App.User_Record.Email_Second.Visible(Value => False);

       App.Form_Array(User_Details_View).New_Line;

      App.User_Record.Modify_Email_Button.Create
        (Parent  => App.Form_Array(User_Details_View),
         Content => " Modify Email ");


      App.User_Record.Commit_Change_Email_Button.Create
        (Parent => App.Form_Array(User_Details_View),
         Content => "Commit Email Change");

      App.User_Record.Commit_Change_Email_Button.Visible(Value => false);

        App.Form_Array(User_Details_View).New_Line;


      App.User_Record.Email_Error_Tag.Create
        (Parent  => App.Form_Array(User_Details_View),
         Content => "Email Problem ");

      App.Form_Array(User_Details_View).New_Line;

       App.User_Record.Box_Id.Create
        (Parent  => App.Form_Array(User_Details_View),
         Content => "Box Serial Number ");

      App.User_Record.Box_Id_Input.Create
        (Form => App.Form_Array(User_Details_View),
         Value => String(User_Password_Check_Pkg.User_Check_Object.
              Get_Serial_From_User(User => App.Login_Record.The_Email.Value)));

      App.User_Record.Box_Id_Input.Visible(Value =>  false);

      App.User_Record.Box_Id_Input_Compare.Create
        (Form => App.Form_Array(User_Details_View),
         Value => String(User_Password_Check_Pkg.User_Check_Object.
               Get_Serial_From_User(User => App.Login_Record.The_Email.Value)));

      App.User_Record.Box_Id_Input_Compare.Visible(Value =>  false);

      App.User_Record.Modify_Box_Id_Button.Create
        (Parent  => App.Form_Array(User_Details_View),
         Content => "Modify Serial Number" );

        App.User_Record.Commit_Change_Box_Id_Button.Create
        (Parent  => App.Form_Array(User_Details_View),
         Content => "Commit Change to Serial" );

      App.User_Record.Commit_Change_Box_Id_Button.Visible
        (Value => False);




   end Build_User_Details_View;


   procedure Update_User_Details_View
     (App : in out App_Access) is
   begin
      null;
   end Update_User_Details_View;


end User_Details_Gnoga_Pkg;
