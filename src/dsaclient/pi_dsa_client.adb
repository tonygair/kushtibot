
with Identity_Types_Pkg; use Identity_Types_Pkg;
with Gnat.Sockets;

with GNAT.Sockets.Server;          use GNAT.Sockets.Server;
with GNAT.Sockets.Server.Handles;  use GNAT.Sockets.Server.Handles;
with Pi_Cube_Client_Pkg;
with GNAT.Sockets.Connection_State_Machine.
  ELV_MAX_Cube_Client.Stream_IO;
with GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;

with Pi_Specific_Data_Pkg; use Pi_Specific_Data_Pkg;
with Ada;
with Ada.Exceptions;

with Dsa_Usna_Server;
with Gnoga;
procedure Pi_Dsa_Client is

   Timeout_Delay : Duration := 5.0;

    use GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;
      Cubes : Cube_Descriptor_Array := Discover;
   Number_Of_Cubes : Natural := Cubes'length;
   Location_Id : Location_Id_Type;
   Cube_Serial_Number : Serial_Type;
   Cube_Address : Gnat.Sockets.Inet_Addr_Type;
   Pi_Access : Pi_Cube_Client_Pkg.Pi_Access_Type;

begin
  -- Gnoga.log("starting Pi App");
   -- Find the cube
   if Number_Of_Cubes = 1 then
      Cube_Serial_Number := Serial_Type(Cubes(1).Serial_No);
      Cube_Address := Cubes(1).Address;
--        Gnoga.log("Cube " & string (Cube_Serial_Number) &
--                    " found at address " & Gnat.Sockets.image(Cube_Address));
      -- first register with the server!

      delay 0.5;
      -- wait for DSA Server database to Finish
 Location_Id := Dsa_Usna_Server.Register
           (Serial_Number =>  Cube_Serial_Number);
         Pi_Data.Set_Location_Id(Location_Id);


   Pi_Access := new Pi_Cube_Client_Pkg.Pi_Comms_Thread;
   Pi_Access.Start_Thread
     (Location_Id => Location_Id,
      Cube => GNAT.Sockets.Image (Cubes (Cubes'First).Address));


      -- loop over the rooms
      --for count in 1..Get_Number_Of_Rooms
      else
        Gnoga.log( "EXCEPTION" & Number_Of_Cubes'img & "Detected - cannot start");

   end if;

  Gnoga.log( "STATUS" & " Ending PI APP");
    exception
         when E : others => Gnoga.log( "EXCEPTION" & Ada.Exceptions.Exception_Information (E));

end Pi_Dsa_Client;
