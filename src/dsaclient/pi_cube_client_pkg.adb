with GNAT.Sockets;
with GNAT.Sockets.Server; use GNAT.Sockets.Server;
with GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;
use GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;
with GNAT.Sockets.Server.Handles;  use GNAT.Sockets.Server.Handles;

with Pi_Specific_Data_Pkg; use Pi_Specific_Data_Pkg;
with Ada;
with Ada.Exceptions;
with Special_Fifo_Po;
with Schedule_Conversion_Pkg;
with Gnoga;
-- dsa specific packages
with Terminal; use Terminal;
with Dsa_Usna_Server;
with Ada.Calendar; use Ada.Calendar;
--with Alert_Buffer; use Alert_Buffer; -- remote messages coming in from server
package body  Pi_Cube_Client_Pkg is

   Timeout_Delay : Duration := 5.0;

   Time_Between_Querys : Duration := 1200.0;

   Terminate_The_Task : boolean := false;

   function Check_Device_Data_Discriminant ( Element : in Device_Data) return Device_Type is
   begin
      return Element.Kind_Of;
   end Check_Device_Data_Discriminant;


   package Device_Data_Fifo_Po is new Special_Fifo_Po
     (Element_Type => Device_Data,
      Element_Discriminator_Type => Device_Type,
      Check_Discriminator =>  Check_Device_Data_Discriminant);

   Data_Po : Device_Data_Fifo_Po.The_PO;

   type Adjusted_Cube_Client is new GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client.ELV_MAX_Cube_Client
   with null record;

   overriding
   procedure Data_Received (Client : in out Adjusted_Cube_Client ;
                            Data   :  Device_Data);
   Overriding
   procedure Disconnected (Client : in out Adjusted_Cube_Client);


   procedure Data_Received (Client : in out Adjusted_Cube_Client ;
                            Data   :  Device_Data) is


      -- Device : Positive := Get_Device (Client => Client,
      --                                  Address => Data.Address);


   begin
      GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client.Data_Received
        (Client => GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client.ELV_MAX_Cube_Client(Client),
         Data   => Data);
      Data_Po.Push(Element => Data);



      Gnoga.log(Data.Kind_Of'img & " Added data to internal Data_Po");
   exception
      when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

   end Data_Received;

   type Dd_Access is access Device_Data;

   procedure Process_Waiting_Local_Messages_From_Cube
     (Client : in out Adjusted_Cube_Client) is



   begin
      while not Data_Po.Is_Empty loop

         declare
            The_Data : Device_Data (Kind_Of => Data_Po.Peek_At_Discriminator) ;
            Successful_Pop : boolean;
         begin

            Data_Po.Pop
              (Element_Discriminator => The_Data.Kind_Of,
               Element => The_Data,
               Success => Successful_Pop);
            if Successful_Pop then
               declare

                  -- Device : Positive := Get_Device (Client => Client,
                  --                                  Address => Data.Address);
                  Room : Room_ID := Get_Device_Room
                    (Client => Client,
                     Address => The_Data.Address);

                  Room_Name : string := Get_Room_Name
                    (Client => Client,
                     ID     => Room);

               begin

                  if Room_Name'length > 0 and  Room > 0 then
                     Pi_Data.Process_Data
                       (Room     => Room,
                        Roomname => Room_Name,
                        Data     => The_Data);
                  else
                     Gnoga.log("Invalid Message sent for Room Name : "& Room_Name & " with ID :" & Room'img);
                  end if;
               exception
                  when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

               end;
            else
               delay 0.2;

            end if;
         exception
            when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

         end;

      end loop;
   exception
      when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

   end Process_Waiting_Local_Messages_From_Cube;

   procedure Disconnected (Client : in out Adjusted_Cube_Client) is
   begin

      GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client.Disconnected
        (Client => GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client.ELV_MAX_Cube_Client(Client));
      Pi_Data.Reset;
      Terminate_The_Task := True;
      Gnoga.log(" 3QMAX Cube disconnected - ending the task");

   exception
      when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

   end Disconnected;



   Task body Pi_Comms_Thread  is
      Factory   : aliased Connections_Factory;
      Server    : aliased Connections_Server (Factory'Access, 0);
      Reference : Handle;
      Location : Location_Id_Type;
      Loop_Number : integer := 1; -- this is for doing one loop of sending every 20 checks of the buffers
      Delay_Count : Natural := 0;

   begin
      --        Trace_On
      --          (  Factory  => Factory,
      --             Received => GNAT.Sockets.Server.Trace_Decoded,
      --             Sent     => GNAT.Sockets.Server.Trace_Decoded
      --            );
      Set
        (  Reference,
           new Adjusted_Cube_Client
             (  Listener    => Server'Unchecked_Access,
                Line_Length => 4096,
                Input_Size  => 80,
                Output_Size => 200
               )      );
      declare
         Client : Adjusted_Cube_Client renames
           Adjusted_Cube_Client (Ptr (Reference).all);
      begin
         Gnoga.log("Start of task - before rendezvous");
         accept  Start_Thread(Location_Id : in Location_Id_Type;
                              Cube : in String)  do

            Location := Location_Id;
            Connect
              (  Server,
                 Client'Unchecked_Access,
                 Cube,
                 ELV_MAX_Cube_Port
                );
            Gnoga.log("Post rendezvous");
         end Start_Thread;

         while not Is_Connected (Client) loop -- Busy waiting
            delay Timeout_Delay;
         end loop;
         while not Dsa_Usna_Server.Is_Database_Ready loop
            Delay_Count := Delay_Count + 1;
            if Delay_Count=10 then
               Delay_Count:= 0;
               Gnoga.log( " Archiver not started ");
            else
               Gnoga.log("Archiver OK - starting main task");
            end if;

            delay 1.0;
         end loop;

         Dsa_Usna_Server.Register_Pi
           (Terminal => Terminal.My_Terminal'access,
            Location => Location );
         Gnoga.log("We have location 1" );

         declare
            --Room_Register_Success  : boolean;
            Number_Of_Rooms : Natural := Get_Number_Of_Rooms (Client);
            Number_Of_Devices : Natural := Get_Number_Of_Devices(Client);
            Message_Ready_For_Room : boolean := false;
            Last_Query_Done : Ada.Calendar.time := Ada.Calendar.Clock;
            --Rir_Array : Rir_Array_Type(1..Room_Id(Number_Of_Rooms));
         begin
            Gnoga.log( "Number of Rooms " & Number_Of_Rooms'img & "in location " );
            Gnoga.log( "Number_Of_Devices" & Number_Of_Devices'img);
            Dsa_Usna_Server.Set_number_Of_Rooms
              (Location => Location,
               Rooms    => Room_Id_Type(Number_Of_Rooms));



            delay Timeout_Delay;

            loop
               if Terminate_The_Task then
                  exit;
               elsif  (Last_Query_Done +  Time_Between_Querys) < Ada.Calendar.Clock then
                  Last_Query_Done := Ada.Calendar.Clock;
                  Query_Devices(Client => Client);
                  delay 50.0;
                  gnoga.log("Querying Devices Request Made ");


               else
                  Process_Waiting_Local_Messages_From_Cube(Client => Client);
                  -- first check outgoing data to decide if theres any to send
                  For room_count in Room_ID(1) .. Room_Id(Number_Of_Rooms) loop
                     Number_Of_Devices := Get_Number_Of_Devices
                       (Client => Client,
                        ID     => room_count);
                     -- check to see if room data is ready
                     -- we send a message if all devices have received
                     Pi_Data.Room_Data_Ready(Room         => room_count,
                                             Device_Count => Number_Of_Devices,
                                             Ready        => Message_Ready_For_Room);
                     if Message_Ready_For_Room then
                        Dsa_Usna_Server.Submit_Room_Data
                          (Room_Data => Pi_Data.Get_Room_Information(room_count) );
                        Gnoga.log("Data sent to server for room id " & room_count'img);

                     end if;



                  end loop;

                  -- until the DSA messages is implemented
                  -- we will check the server to see if there are messages waiting to be serviced.

                  -- check for messages coming in from server using alert buffer and process these
                  while not Dsa_Usna_Server.Is_Empty(Location) loop
                     declare
                        TC : TC_Change_Record;

                     begin

                        Dsa_Usna_Server.Pi_Command_Get
                          (Location => Location,
                           Item => TC);
                        Gnoga.log("DSA Buffer has received a record, Location : " & TC.Location'img
                                  & " Room id " & TC.Room'img &  " Day " & TC.Day'img
                                  & " TC_CHange " & TC.TC_Change'img );
                        delay 5.0;-- give the server time for the temperatures to up as well

                        declare
                           Web_Pi_Schedule : Identity_Types_Pkg.Day_Schedule_Type :=
                             Dsa_Usna_Server.Fetch_Updated_Day_Schedule
                               (Location    => TC.Location,
                                Room_Number => TC.Room,
                                The_Day     => TC.Day);
                           Temperatures : Identity_Types_Pkg.Mode_Temperature_Type :=
                             Dsa_Usna_Server.Get_Room_Mode_Temperatures
                               (Location    => TC.Location,
                                Room_Number => TC.Room,
                                The_Day     => TC.Day);

                           New_Schedule : Day_Schedule := Schedule_Conversion_Pkg.
                             Web_To_Pi_Schedule(Temperatures => Temperatures,
                                                Schedule     => Web_Pi_Schedule);

                           Room : Room_Id := Room_Id (TC.Room);
                           Number_Of_Devices : Natural := Get_Number_Of_Devices
                             (Client => Client);
                        begin
                           for count in 1..Number_Of_Devices loop
                              if  Is_In (  Client => Client,
                                           ID     => Room,
                                           Device => count
                                          )  and then Get_Device_Type(Client => Client,
                                                                      Index  => count)
                              in Radiator_Thermostat..Wall_Thermostat then
                                 Set_Thermostat_Schedule (Client   => Client ,
                                                          Index    => count ,
                                                          Day      => Schedule_Conversion_Pkg.Web_Day_To_Pi_Day( TC.Day),
                                                          Schedule => New_Schedule.Points);
                              end if;


                           end loop;
                        exception
                           when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

                        end ;
                     exception
                        when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

                     end ;


                  end loop; -- end of buffer empty
                  delay 10.0; -- ten second delay -- we need something a little more sophisticated here
               end if;

            end loop;


         exception
            when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

         end;
      exception
         when E : others => Gnoga.log( "EXCEPTION" & Ada.Exceptions.Exception_Information (E));
      end;

   end Pi_Comms_Thread;


end Pi_Cube_Client_Pkg;
