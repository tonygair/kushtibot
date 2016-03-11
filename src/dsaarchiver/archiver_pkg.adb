with Ada.Calendar;                use Ada.Calendar;
with Ada.Exceptions;              use Ada.Exceptions;
with Ada.Strings.Unbounded;       use Ada.Strings.Unbounded;
with Ada.Text_IO;                 use Ada.Text_IO;
with ODBC.Bound_Parameters;       use ODBC.Bound_Parameters;
with ODBC.SQLTypes;               use ODBC.SQLTypes;
with  Strings_Edit.Streams;       use  Strings_Edit.Streams;
with Strings_Edit.UTF8.Handling;  use Strings_Edit.UTF8.Handling;
with Room_Types_Pkg; use Room_Types_Pkg;
with Gnoga;
with Ada.Calendar.Conversions;
with Identity_Types_Pkg; use Identity_Types_Pkg;
with Dsa_Usna_Server;
with User_Password_Check_Pkg;
with Ada.Calendar;
with Message; use Message;
with Terminal; use Terminal;
with Alert_Buffer; use Alert_Buffer;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;


package body Archiver_Pkg is


   procedure Load_User_Data (Connection : in out ODBC_Connection) is
      Command : aliased ODBC_Command (Connection'access);
      Exit_The_Loop : boolean := false;
   begin
      Execute (Command, String'("SELECT * FROM wsversion1.usertable "));
      while not Exit_The_Loop loop

      Fetch (Command);
          declare
            User_Name : constant String := Get_Data(Command'access, 1, On_No_Result);
            Password : constant String := Get_Data(Command'access,2, On_No_Result);
            Serial_String : constant string :=Get_Data(Command'access,3,On_No_Result);
            Serial_Number : Serial_Type :=  Serial_Type(Serial_String);
            Is_Admin_String : constant string :=
              Get_Data(Command'access,4,On_No_Result);
            -- 4 is going to be the view access figure to give people view access to other peoples systems.

            Success : boolean;
            Is_Admin : boolean;

         begin
            if Is_Admin_String = "false" then
               Is_Admin := false;
            else
               Is_Admin := true;
            end if;

            Dsa_Usna_Server.
              Add_User(User     => User_Name,
                       Password => Password,
                       Is_Admin => Is_Admin,
                       Success  => Success);
            if not Success then
               Gnoga.log(" User not added successfully " & User_Name);
               Exit_The_Loop := true;
            else
               Gnoga.log(" Added User " & User_Name);
            end if;


         exception
            when End_Error =>
               Exit_The_Loop := true;

         end;
      end loop;

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Load_User_Data;

   procedure Load_Device_Details (Connection : in out ODBC_Connection) is


   begin
      null;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Load_Device_Details;

   procedure Load_Location_Information ( Connection : in out ODBC_Connection) is
      Command : aliased ODBC_Command (Connection'access);
      -- locationid is column 1
      -- locationname is column 2
      -- cube serial is column 3
      Location_Id : aliased SQLINTEGER;
      Exit_The_Loop : boolean := false;
   begin
      Execute (Command, String'("SELECT * FROM wsversion1.locationtable "));
      Bind_Result (Command , 2 , Location_Id'Access);

      While not Exit_The_Loop loop
          Fetch(Command);

         declare
            Location_Name : constant string:= Get_Data(Command'access, 3, On_No_Result);
            Midway_String : constant String := Get_Data(Command'access, 4, On_No_Result);
            Cube_Serial : Serial_Type := Serial_Type (Midway_String(1..10));

         begin


            Gnoga.log ("length " & Midway_String'length'img & "*"&Midway_String&"*");
            Dsa_Usna_Server.Load_Location_Data_From_Database
              (Description   => Location_Name,
               Location_Id   => Location_Id_Type (Location_Id),
               Serial_Number => Cube_Serial);
         exception
                   when End_Error =>
               Exit_The_Loop := true;
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

         end;
      end loop;
   exception
             when End_Error =>
               Exit_The_Loop := true;
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Load_Location_Information;





   -- procedure responsible for loading data from the database and placing in the system
   procedure Initialise (Connection : in out ODBC_Connection) is
   begin
      Load_Location_Information (Connection => Connection);
      Gnoga.log("Post location load");
      Load_Device_Details(Connection => Connection);
      Gnoga.log("Post device load");
      Load_User_Data(Connection => Connection);
      Gnoga.log("Post User");
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Initialise;


   Procedure Archive_User_Details
     (Connection : in out ODBC_Connection;
      User_Data : in User_Transfer_Record) is

      Command  : aliased ODBC_Command (Connection'Access);


      User_P : aliased String_Parameter := Create (To_String(User_Data.User));
      Password_P : aliased String_Parameter := Create (To_String(User_Data.Password));
      Conv_String : constant string := string(User_Data.Serial_Number);
      Serial_P : aliased String_Parameter := Create (Conv_String);
      Email_P : aliased String_Parameter := Create ("Dealwithlater");
      Phone_P : aliased String_Parameter := Create ("Dealwithevenlater");
      Admin : aliased String_Parameter := (Create(User_Data.Is_Admin'img));
   begin

      prepare (Command,
               String' ("Insert into wsversion1.usertable VALUES (?,?,?,?,?,?);"));
      Bind_Parameter (Command, 1, User_P'Access);
      Bind_Parameter (Command, 2, Password_P'Access);
      Bind_Parameter (Command, 3, Serial_P'Access);
      Bind_Parameter (Command, 4, Admin'Access);
      Bind_Parameter (Command, 5, Email_P'access);
      Bind_Parameter (Command, 6, Phone_P'access);
      Execute(Command);

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
   end Archive_User_Details;


   -- archives operational data for device such as temperature / battery etc
   procedure Archive_Room_Data
     (Connection : in out ODBC_Connection;
      Location : in Location_Id_Type;
      Room : in Room_Information_Record) is


      Command  : aliased ODBC_Command (Connection'Access);

      -- Id : constant integer ;
      --  this is a reference to refer to the device table
      Location_Id : aliased SQLINTEGER_Parameter := Create (sqlinteger(Location));
      Room_Number : aliased SQLINTEGER_Parameter := Create(sqlinteger(Room.Room));
      Setpoint : aliased SQLINTEGER_Parameter := Create(sqlinteger(Room.Set_Point));
      Temperature : aliased SQLINTEGER_Parameter :=Create(sqlinteger(Room.Actual ));
      Room_Name : aliased String_Parameter := Create (Room.Room_Name);
      Unix_Time : aliased SQLINTEGER_Parameter :=  Create(sqlinteger
                                                          (Ada.Calendar.Conversions.To_Unix_Time
                                                             (Ada.Calendar.Clock)));







   begin
      Prepare
        (  Command,
           String'("INSERT INTO wsversion1.DEVICEONEDATAARCHIVE VALUES (?,?,?,?,?,?)")
          );
      Bind_Parameter (Command, 1, Location_Id'Access);
      Bind_Parameter (Command, 2, Room_Number'Access);
      Bind_Parameter (Command, 3, Setpoint'Access);
      Bind_Parameter (Command, 4, Temperature'Access);
      Bind_Parameter (Command, 5, Room_Name'Access);
      Bind_Parameter (Command, 6, Unix_Time'access);

      Execute(Command);

   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Archive_Room_Data;






   task body Archiver_Task_Type is


      End_Task_Nicely : boolean := false;

      Database_Environment : aliased ODBC_Environment;

      Database_Connection : ODBC_Connection (Database_Environment'Access);

      Server_Name : constant string := "Localhost";

   begin
      Gnoga.log ("Pre connect");
      Connect
        (Connection  => Database_Connection,
         Server_Name => Server_Name,
         User_Name   => "root",
         Password    => "wombatsrus",
         Auto_Commit => true);
      -- Connect to AND load up data from database which is necessary
      -- i.e. user / password data
      Gnoga.log("Pre Initiaiise ");

      Initialise (Connection => Database_Connection);
      Gnoga.log("We should be connected ");
      accept Start_Archiving; --nicely  holds the main application until database is loaded

      Dsa_Usna_Server.Set_Database_To_Ready;
      Dsa_Usna_Server.Register_Archiver(Terminal => Terminal.My_Terminal'access);
      loop
         select
            accept End_The_Task  do
               End_Task_Nicely := true;
            end End_The_Task;

         or

            delay 5.0;

         end select;

         while not User_Buffer.Is_Empty loop
            declare
               The_User : Unbounded_String;
            begin
               User_Buffer.Pop(Item => The_User);
               -- now go get the updated value from the passive partition
               declare
                  New_User_Details : User_Transfer_Record :=
                    Dsa_Usna_Server.Fetch_User (To_String(The_User));
               begin


                  Archive_User_Details
                    (Connection => Database_Connection,
                     User_Data =>  New_User_Details);
               exception
                  when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

               end;
            end;

         end loop;

         -- check for messages to archive
         while not TC_Buffer.Is_Empty loop
            declare
               TC : TC_Change_Record;
               Location : Location_Id_Type;
            begin
               TC_Buffer.Pop(Location => Location,
                             Item => TC);
               Gnoga.Log("DSA Buffer has received a record, Location : " & TC.Location'img
                         & " Room id " & TC.Room'img &  " Day " & TC.Day'img
                         & " TC_CHange " & TC.TC_Change'img );
               declare
                  Room_Info: Room_Information_Record :=
                    Dsa_Usna_Server.Get_Room_Data
                      (Location => TC.Location,
                       Room     => TC.Room);
               begin

                  Archive_Room_Data
                    (Connection => Database_Connection,
                     Room     => Room_Info,
                     Location => TC.Location);
               exception
                  when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

               end;
            exception
               when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

            end;
         end loop;

         -- end the task if necessary
         if End_Task_Nicely then
            Gnoga.log("Archive Task is Terminating ");
            exit;
         end if;


      end loop;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Archiver_Task_Type;


end Archiver_Pkg;
