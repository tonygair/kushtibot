-- Gnoga packages
with Gnoga;
with Gnoga.Application.Multi_Connect;

-- USNA screens


with View_Change_Pkg;
with Ada.Exceptions;

with User_Password_Check_Pkg;
with Dsa_Usna_Server;
procedure Usna_Main is


begin



   --User_Password_Check_Pkg.Initialise; -- adds stuff for initialise passwords

   delay 0.5;
   if not Dsa_Usna_Server.Is_Database_Ready then
      -- run test data loading
      null;
   end if;




   Gnoga.Log("Start of web server");
   Gnoga.Application.Title(Name => "Warm and Smart ");
   Gnoga.Application.HTML_On_Close
     ("<b>Your Connection to Warm and Smart is terminated</b>");

   Gnoga.Application.Multi_Connect.Initialize(Port => 8010);
   Gnoga.Log("Multi connect initialised ");

   Gnoga.Application.Multi_Connect.On_Connect_Handler
     (Event=> View_Change_Pkg.On_Connect_App'Unrestricted_Access,
      Path => "default");
Gnoga.Log("default started");


   Gnoga.Application.Multi_Connect.Message_Loop;

exception
   when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));




end Usna_Main;
