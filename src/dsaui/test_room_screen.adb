
-- Gnoga packages
with Gnoga;
with Gnoga.Application.Multi_Connect;

-- USNA screens


--with View_Change_Pkg;
with Ada.Exceptions;

--with User_Password_Check_Pkg;
--with Dsa_Usna_Server;
with Edit_Room_Details_Gnoga_Pkg;
with Gnoga.Gui;
with Gnoga.Gui.Window;
with Usna_App_Data_Pkg; use Usna_App_Data_Pkg;

with Load_Test_Data;
with Dsa_Usna_Server;
with Usna_Rooms_Gnoga_Pkg;
with Terminal;
with Identity_Types_Pkg; use Identity_Types_Pkg;
procedure Test_Room_Screen is
  procedure On_Connect_App
     (Main_Window : in out Gnoga.Gui.Window.Window_Type'Class;
      Connection  : access Gnoga.Application.Multi_Connect.Connection_Holder_Type) is

   App :  App_Access := new Usna_App_Data_Pkg.App_Data;
   Location : Location_Id_Type;
   begin
      Location := Dsa_Usna_Server.Register(Serial_Number => "A12e122FFF");
      Dsa_Usna_Server.Register_Pi(Terminal => Terminal.My_Terminal'access ,
                                  Location => 1);
      App.Location_id := 1;
      Dsa_Usna_Server.Deregister_Archiver;

      Load_Test_Data.Load_Rooms_Data;
      Main_Window.Connection_Data(App);
      App.Main_Window := Main_Window'Unchecked_Access;
     App.View_Array(Room_Edit_View).Create(Parent => Main_Window);
      App.View_Array(Rooms_View).Create(Parent => Main_Window);
       App.Form_Array(Rooms_View).Create(Parent => App.View_Array(Rooms_View));
      App.Form_Array(Room_Edit_View).Create(Parent => App.View_Array(Room_Edit_View));
      Edit_Room_Details_Gnoga_Pkg.Build_Edit_Schedule_View(App => App);
      Usna_Rooms_Gnoga_Pkg.Build_Rooms_View(App=>App);
   end On_Connect_App;

begin


   Gnoga.Log("Start of web server");
   Gnoga.Application.Title(Name => "Testing Room Screen ");
   Gnoga.Application.HTML_On_Close
     ("<b>Your Test Connection to Warm and Smart is terminated</b>");

   Gnoga.Application.Multi_Connect.Initialize(Port => 8100);
   Gnoga.Log("Multi connect initialised ");

   Gnoga.Application.Multi_Connect.On_Connect_Handler
     (Event=> On_Connect_App'Unrestricted_Access,
      Path => "default");
   Gnoga.Log("default started");


   Gnoga.Application.Multi_Connect.Message_Loop;

exception
   when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));


end Test_Room_Screen;
