with Dsa_Usna_Server;
with Gnoga;
with Gnoga.Gui;
with Label_Function_Pkg;
with View_Change_Pkg;
with Gnoga.Gui.Base;
with Ada.Exceptions;
with Label_Function_Pkg;
with Ui_Text_Pkg;
package body Usna_Admin_Gnoga_Pkg is


--     function Stringify_Admin_Button_Id
--       (Location_Id : in Location_Id_Type) return string is
--     begin
--        return  Location_Id'img &" Location_Button_Id" ;
--     exception
--        when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
--
--     end Stringify_Admin_Button_Id;

   procedure Go_To_Rooms_View
     (Object : in out Gnoga.Gui.Base.Base_Type'Class) is

      The_Id : constant string := Object.Id;
      Location_Id : Location_Id_Type :=
        Label_Function_Pkg.Get_Location_Id_From_Label(The_Id);
      App : App_Access := App_Access (Object.Connection_Data);

   begin

      App.Location_id := Location_Id;
      App.Requested_View_Selected:= Rooms_View;
      View_Change_Pkg.New_Content_View(App => App);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Go_To_Rooms_View;






   procedure Build_Admin_View
     (App : in out App_Access) is



   begin

      App.Admin_Record.Title_Label.Create
        (Parent => App.Form_Array(Admin_View),
         Content => Ui_Text_Pkg.Admin_Screen_Text);

      App.Form_Array(Admin_View).New_Line;



      for Count in 1..Dsa_Usna_server.Get_Max_Location loop


         if Dsa_Usna_Server.Occupied_Location(Count) then
            if App.Admin_Record.Button_Creation(Count) then
               App.Admin_Record.Buttons(Count).Text
                 (Value => Dsa_Usna_Server.Get_Description
                    (Location => Count));

            else

               App.Admin_Record.Buttons(Count).Create
                 (Parent  => App.Form_Array(Admin_View),
                  Content => Dsa_Usna_Server.Get_Description
                    (Location => Count),
                  ID      => Label_Function_Pkg.Make_Location_Label(Count));
               App.Admin_Record.Buttons(Count).
                 On_Click_Handler(Handler => Go_To_Rooms_View'Unrestricted_Access);



               App.Admin_Record.Button_Creation(Count) := true;

            end if;
            App.Form_Array(Admin_View).New_Line;

         end if;

      end loop;
      App.View_Array(Admin_View).New_Line;
      App.View_Array(Admin_View).New_Line;

      if not App.Admin_Record.Legal_Warning_Label.Valid then
          App.Admin_Record.Legal_Warning_Label.Create
        (Parent => App.Form_Array(Admin_View),
         Content => Ui_Text_Pkg.Legal_Warning_Text);
      end if;


   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));


   end Build_Admin_View;




   procedure Update_Admin_View
     (App : in out App_Access) is
      Max_Location : Location_Id_Type := Dsa_Usna_server.Get_Max_Location;
   begin

      Gnoga.log("Max_Locations " & Max_Location'Img);
      for Count in 1..Max_Location loop


         if Dsa_Usna_Server.Occupied_Location(Count) then
            if App.Admin_Record.Button_Creation(Count) then
               App.Admin_Record.Buttons(Count).Text
                 (Value => Dsa_Usna_Server.Get_Description
                    (Location => Count));

            else

               App.Admin_Record.Buttons(Count).Create
                 (Parent  => App.Form_Array(Admin_View),
                  Content => Dsa_Usna_Server.Get_Description
                    (Location => Count),
                  ID      => Label_Function_Pkg.Make_Location_Label(Count));
               App.Admin_Record.Buttons(Count).
                 On_Click_Handler(Handler => Go_To_Rooms_View'Unrestricted_Access);

               App.Admin_Record.Button_Creation(Count) := true;

            end if;
         end if;

      end loop;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Update_Admin_View;



end Usna_Admin_Gnoga_Pkg;
