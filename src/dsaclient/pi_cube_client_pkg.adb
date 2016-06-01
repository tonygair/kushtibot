with GNAT.Sockets;
with GNAT.Sockets.Server; use GNAT.Sockets.Server;
with GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;
use GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;
with GNAT.Sockets.Server.Handles;  use GNAT.Sockets.Server.Handles;

with Pi_Specific_Data_Pkg; use Pi_Specific_Data_Pkg;
with Ada;
with Ada.Exceptions;
with Fifo_Po;
with Schedule_Conversion_Pkg;
with Gnoga;
-- dsa specific packages
with Terminal; use Terminal;
with Dsa_Usna_Server;
--with Alert_Buffer; use Alert_Buffer; -- remote messages coming in from server
package body  Pi_Cube_Client_Pkg is

   Timeout_Delay : Duration := 5.0;
   package Device_Data_Fifo_Po is new Fifo_Po
     (Element_Type => Device_Data);

   Data_Po : Device_Data_Fifo_Po.The_PO;
   type Adjusted_Cube_Client is new GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client.ELV_MAX_Cube_Client
    with null record;

   overriding

   procedure Data_Received (Client : in out Adjusted_Cube_Client ;
                                   Data   :  Device_Data) is
   begin
      GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client.Data_Received
        (Client => GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client.ELV_MAX_Cube_Client(Client),
         Data   => Data);
      Data_Po.Push(Item => Data);

      Gnoga.log(Data.Kind_Of'img & "push onto PO ");
   exception
      when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

   end Data_Received;


   Task body Pi_Comms_Thread  is
      Factory   : aliased Connections_Factory;
      Server    : aliased Connections_Server (Factory'Access, 0);
      Reference : Handle;
      Location : Location_Id_Type;
      Loop_Number : integer := 1; -- this is for doing one loop of sending every 20 checks of the buffers
      Delay_Count : Natural := 0;

   begin
      Trace_On
        (  Factory  => Factory,
           Received => GNAT.Sockets.Server.Trace_Decoded,
           Sent     => GNAT.Sockets.Server.Trace_Decoded
          );
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
            --Rir_Array : Rir_Array_Type(1..Room_Id(Number_Of_Rooms));
         begin
            Gnoga.log( "Number of Rooms " & Number_Of_Rooms'img);
             Gnoga.log( "Number_Of_Devices" & Number_Of_Devices'img);
            Pi_Data.Set_Number_Rooms(Number_Of_Rooms);




            delay Timeout_Delay;

            loop
               if Loop_Number > 10 then
                  Loop_Number := 1;

               end if;
               if Loop_Number = 1 then
                  for count in 1..Number_Of_Rooms loop
                     declare
                        Room : Room_ID := Get_Room_Id(Client => Client,
                                                      Index => count);
                        Room_Name : string := Get_Room_Name
                          (Client => Client,
                           ID => Room);
                        Number_Of_Devices : Natural := Get_Number_Of_Devices
                          (Client => Client,
                           ID     => Room);

                     begin
                        Pi_Data.Set_Number_Rooms(Room_Size => Number_Of_Rooms);
                       Gnoga.log(" Device Number in Room " & Number_Of_Devices'img);
                        Dsa_Usna_Server.Set_number_Of_Rooms
                          (Location => Location,
                           Rooms    => Room_Id_Type(Number_Of_Rooms));
                         Gnoga.log("Room name is " & Room_Name);
                        for Second_Count in 1..Number_Of_Devices loop
                           declare
                              Device : positive := Get_Device(Client => Client,
                                                              ID     => Room,
                                                              Device => Second_Count);
                              Device_Name : constant string := Get_Device_Name
                                (Client => Client,
                                 Index => Device);
                              Data : constant Device_Data := Get_Device_Data
                                (Client => Client,
                                 Index  => Device);
                              Parameters : constant Device_Parameters :=
                                Get_Device_Parameters (Client => Client,
                                                       Index  => Device);


                           begin

                              Gnoga.log(Device_Name & " in " & Room_Name);
                               Gnoga.log(Image(Data));
                              -- Put the Data in a RIR format ready for transmission

                              Pi_Data.Process_Data(Room => Room,
                                                   Roomname=> Room_Name,
                                                   Data => Data);

                           end;
                        end loop;
                     exception
                        when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

                     end;
                  end loop;
                  for count in 1..Number_Of_Rooms loop
                     declare

                        Room : Room_Id := Get_Room_ID (Client => Client,
                                                       Index => count);
                        Room_Data : Room_Information_Record := Pi_Data.Get_Room_Information
                          (Room => Room);
                     begin
                         Gnoga.log( "Sending data  for room :" & Room_Data.Room_Name & " room id " &
                                    Room'img);
                        Room_Data.Location := Location;
                        If Get_Number_Of_Devices(Client => Client,
                                                 ID     => Room) > 0 then
                           Dsa_Usna_Server.Submit_Room_data(Room_Data => Room_Data );
                        end if;
                     exception
                        when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

                     end;
                  end loop;
               end if;
               -- until the DSA messages is implemented
               -- we will check the server to see if there are messages waiting to be serviced.

               -- check for messages coming in from server using alert buffer and process these
                Gnoga.log("Checking TC Buffer from server , instead of local");
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
               delay 120.0; -- ten minute delay -- we need something a little more sophisticated here
               Loop_Number := Loop_Number + 1;
            end loop;

         exception
            when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

         end;
      exception
         when E : others => Gnoga.log( "EXCEPTION" & Ada.Exceptions.Exception_Information (E));
      end;

   end Pi_Comms_Thread;


end Pi_Cube_Client_Pkg;
