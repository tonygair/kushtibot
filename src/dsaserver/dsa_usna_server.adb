with Tables;
--with Gnoga;
with Ada.Unchecked_Deallocation;
with User_Password_Check_Pkg; use User_Password_Check_Pkg;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Exceptions;
with Gnoga;
with Usna_App_Data_Pkg;  use Usna_App_Data_Pkg;
with Deallocate_And_Access_Types_Pkg; use Deallocate_And_Access_Types_Pkg;
with UI_Related_Access_Types_Pkg; use UI_Related_Access_Types_Pkg;
--remote type
with Alarm;
with Fifo;
with Location_Fifo_Po;
package body Dsa_Usna_Server is




   Blank_Day_Schedule : Day_Schedule_Type(1..0) := (others => 1);

   -- type Device_Parameter_Access is access Device_Parameters;




   --     package Device_Table_Pkg is new Tables(Tag => Device_Parameter_Access);


   package Room_Table_Pkg is new Tables (Tag => Room_Id_Type);






   type Room_Schedule_Array_Type is array(Room_Id_Type) of Week_Schedule_Type;

   type Room_Mode_Temperatures_Array_Type is array(Room_Id_Type) of Mode_Temperature_Type;

   type Location_Boolean_Array_type is array (Location_Id_Type) of boolean;


   protected Database_Ok is

      procedure Set_To_Loaded;

      function Is_It_Ready return boolean;

      procedure Register_Archive_Terminal
        (Terminal : Terminal_Access);

      function Get_Archive_Terminal return Terminal_Access;

      procedure Deregister_Archiver;
   private
      Archive_Terminal : Terminal_Access;

      Database_Loaded : boolean := false;
   end Database_OK;

   protected body Database_Ok is
      procedure Set_To_Loaded is
      begin
         Database_Loaded := true;
      exception

         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
      end Set_To_Loaded;


      function Is_It_Ready return boolean is
      begin
         return Database_Loaded;
      exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
            return false;
      end Is_It_Ready;

      procedure Register_Archive_Terminal
        (Terminal : Terminal_Access) is
      begin
         Archive_Terminal := Terminal;
      exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
      end Register_Archive_Terminal;


      function Get_Archive_Terminal return Terminal_Access is
      begin
         return Archive_Terminal;
      exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
            return null;
      end Get_Archive_Terminal;

      procedure Deregister_Archiver is
      begin
         Archive_Terminal := null;
      exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
      end Deregister_Archiver;

   end Database_Ok;

   procedure Set_Database_To_Ready is
   begin
      Database_Ok.Set_To_Loaded;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
   end Set_Database_To_Ready;


   function Is_Database_Ready return boolean is
   begin
      return Database_Ok.Is_It_Ready;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         return false;
   end Is_Database_Ready;




   Package Waiting_Command_Fifo is new Fifo(Element_Type => TC_Change_Record);

   protected type Each_Pi_Location_Type is


      function Get_Location_Id return Location_Id_Type;

      function Get_Serial_No return Serial_Type;

      procedure Initialise_Location
        (Serial_Number : in Serial_Type;
         Location_Id : in Location_Id_Type);

      --        function Get_Modified_Device
      --          (Serial_Number : in Serial_Type ) return Device_Parameters;

      --        procedure Store_Device_Parameters
      --          (Static_Device_Info : in Device_Parameters) ;


      Procedure Submit_Room_Data
        (Room_Data : in Room_Information_Record;
         New_Room : out boolean);

      function Get_Room_Data
        (Room : in Room_Id_Type ) return Room_Information_Record;


      function Get_Number_Of_Rooms return Room_Id_Type;

      procedure Set_Number_Of_Rooms
        (Rooms : Room_Id_Type);




      procedure Modify_Day_Schedule
        (Room_Number : in Room_Id_Type;
         --The_Week : in Which_Week_Type;
         The_Day : in Weekday_Type;
         Schedule : in Day_Schedule_Type;
         Success : out boolean);


      function Fetch_Updated_Day_Schedule
        (Room_Number : in Room_ID_Type;
         --The_Week : in Which_Week_Type;
         The_Day : in Weekday_Type) return Day_Schedule_Type;


      procedure Modify_Room_Mode_Temperatures
        (Room_Number : in Room_ID_Type;
         The_Day : in Weekday_Type;
         Mode_Temperatures : in Mode_Temperature_Type);

      Function Get_Room_Mode_Temperatures
        (Room_Number : in Room_Id_Type;
         The_Day : in Weekday_Type)
         return Mode_Temperature_Type;


      procedure Deregister_Pi_Terminal;


      procedure Register_Pi_Terminal
        (Terminal : Terminal_Access);

      function Get_Pi_Terminal return Terminal_Access;

      procedure Deregister_Ui_Terminal;


      procedure Register_Ui_Terminal
        (Terminal : Terminal_Access);

      function Get_Ui_Terminal return Terminal_Access;

      -- fifo functions

      procedure Push (Item : in TC_Change_Record);

      procedure Pop (Item : out TC_Change_Record);

      function Is_Empty return boolean;
      --  Fifo : Waiting_Command_Fifo.Fifo_Type;
   private
      My_Cube_Serial : Serial_Type := (others => ' ');
      My_Location : Location_Id_Type := 0;
      --Device_Table : Device_Table_Pkg.Table;
      Room_Array : Room_Array_Access;
      Number_Of_Rooms : Room_Id_Type;
      Room_Mode_Temperatures : Room_Mode_Temperatures_Array_Type;
      Weekly_Schedule : Room_Schedule_Array_Type ;
      Ui_Terminal,
      Pi_Terminal : Terminal_Access := null;
      Fifo_Q : Waiting_Command_Fifo.Fifo_Type;
   end Each_Pi_Location_Type;

   protected body Each_Pi_Location_Type is separate;

      type Pi_Access_Type is access Each_Pi_Location_Type;


      package Location_Serial_Pkg is new Tables(Location_Id_Type);

      type Location_To_Pi_Array_Type is array (Location_Id_Type) of Pi_Access_Type;


      --- Main storage of information for each location is here!
      Location_To_Pi : Location_To_Pi_Array_Type := (others => null);

      type Description_Array_Type is array(Location_Id_Type) of String_Access_Type;
      --********************************************************

        procedure Pi_Command_Insert
        (Item : in TC_Change_Record) is
      begin
         if Location_To_Pi(Item.Location) /= null then
            Location_To_Pi(Item.Location).Push(Item=>Item);
         end if;
      end Pi_Command_Insert;


   procedure Pi_Command_Get
        (Location : in Location_Id_Type;
         Item : out TC_Change_Record) is

      begin

           if Location_To_Pi(Location) /= null then
            Location_To_Pi(Location).Pop(Item=>Item);
         end if;
      end Pi_Command_Get;


   function Is_Empty
        (Location : Location_Id_Type) return boolean is

         Return_Value : boolean := false;
      begin
         if Location_To_Pi(Location) /= null then
            return Location_To_Pi(Location).Is_Empty;
         end if;
         return Return_Value;
      end Is_Empty;







      protected Location_Data is

         procedure  Register
           (Serial_Number: in Serial_Type;
            Location_Id : out Location_Id_Type);

         procedure Change_Description
           (Location_Id : in Location_Id_Type;
            Description : in string);

         function Get_Description
           (Location_Id : in Location_Id_Type)
            return String;

         procedure Set_Occupancy
           ( Location_Id : in Location_Id_Type ;
             State : in boolean) ;

         function Location_Occupied
           (Location_Id : Location_Id_Type)
            return boolean;

         function Get_Max_Location return Location_Id_Type;

      private
         Max_Location : Location_Id_Type := 0;
         Occupancy : Location_Boolean_Array_Type := (others => false);
         Descriptions : Description_Array_Type := (others => null);

      end Location_Data;


      --******************************************************************
      protected body Location_Data is separate;


         protected Location_Table_PO is
            function Find_Location_Id ( Serial_Number : in Serial_Type) return Location_Id_Type;

            procedure Store_Location (Serial_Number : in Serial_Type ;
                                      Location_Id : in Location_Id_Type);
         private
            Location_Table : Location_Serial_Pkg.Table;

         end Location_Table_PO;

         protected body Location_Table_PO is
            function Find_Location_Id (Serial_Number : in Serial_Type) return Location_Id_Type is
               Return_Value : Location_Id_Type;
               Place : Natural := Location_Table.Locate(Name => String(Serial_Number));
            begin
               if Place = 0 then
                  Return_Value := 0;
               else
                  Return_Value := Location_Table.GetTag(Offset => Place);
               end if;

               return Return_Value;
            exception
               when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
                  return 0;
            end Find_Location_Id;

            procedure Store_Location (Serial_Number : in Serial_Type ;
                                      Location_Id : in Location_Id_Type) is
               Place : Natural := Location_Table.Locate(Name => String(Serial_Number));
            begin
               if Place > 0 then
                  Gnoga.log ("Corrupt data found ");
               else
                  Location_Table.Add(Name => String(Serial_Number),
                                     Data => Location_Id);
               end if;
            exception
               when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
            end Store_Location;


         end Location_Table_PO;


         -- terminal registration

         procedure Register_Pi
           (Terminal : in Terminal_Access;
            Location : in Location_Id_Type) is
         begin
            Gnoga.log ("Pi registering location and terminal " & Location'img);
            Location_To_Pi(Location).
              Register_Pi_Terminal(Terminal);
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         end Register_Pi;


         procedure Deregister_Pi
           (Location : in Location_Id_Type) is
         begin
            Location_To_Pi(Location).
              Deregister_Pi_Terminal;
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         end Deregister_Pi;


         procedure Register_Ui
           (Terminal : in Terminal_Access;
            Location : in Location_Id_Type) is
         begin
            Location_To_Pi(Location).
              Register_Ui_Terminal(Terminal);
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         end Register_Ui;


         procedure Deregister_Ui
           (Location : in Location_Id_Type) is
         begin

            Location_To_Pi(Location).
              Deregister_Ui_Terminal;
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         end Deregister_Ui;

         procedure Register_Archiver
           (Terminal : in Terminal_Access) is
         begin
            Database_Ok.Register_Archive_Terminal
              (Terminal =>  Terminal);
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         end Register_Archiver;


         procedure Deregister_Archiver is
         begin
            Database_Ok.Deregister_Archiver;
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         end Deregister_Archiver;




         -- database stuff

         procedure Load_Location_Data_From_Database
           (Description : in string;
            Location_Id : in Location_Id_Type;
            Serial_Number : in Serial_Type) is

         begin
            Location_Table_PO.Store_Location
              (Serial_Number => Serial_Number,
               Location_Id   => Location_Id);
            Location_To_Pi (Location_Id) := new Each_Pi_Location_Type;
            Location_To_Pi(Location_Id).Initialise_Location
              (Serial_Number => Serial_Number,
               Location_Id => Location_Id);
            Location_Data.Change_Description
              (Location_Id => Location_Id,
               Description => Description);
            Location_Data.Set_Occupancy
              (Location_Id => Location_Id,
               State => true);
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         end Load_Location_Data_From_Database;










         -- end of database stuff



         procedure Send_Debug
           ( Location : in Location_Id_Type;
             Debug : in string) is
         begin
            null;
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         end Send_Debug;



         function IsIn (User : in string ) return boolean is

         begin
            return User_Check_Object.
              IsIn(User => User);
         end IsIn;

         function Check_User_Password
           (User , Password : in string)
            return Serial_Type is
         begin
            return User_Check_Object.Check_User_Password
              (User     => User,
               Password => Password);
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
               return Blank_Serial;
         end Check_User_Password;

         procedure User_Admin_Setting
           (User : in string;
            Admin : in boolean) is
         begin
            User_Check_Object.User_Admin_Setting
              (User  => User,
               Admin => Admin);
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         end User_Admin_Setting;


         function Is_User_An_Admin
           (User : in  String) return boolean is
         begin
            return User_Check_Object.Is_User_An_Admin
              (User => User);
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
               return false;
         end Is_User_An_Admin;


         procedure Add_User
           (User , Password : in string;
            Serial_Number : in Serial_Type := Blank_Serial;
            Is_Admin : in boolean;
            Success : out boolean) is
         begin
            User_Check_Object.Add_User
              (User          => User,
               Password      => Password,
               Serial_Number => Serial_Number,
               Is_Admin => Is_Admin,
               Success       => Success);
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         end Add_User;

         function Fetch_User
           (User : in string) return User_Transfer_Record is
            Is_Admin : boolean;
            Success : boolean;
            User_Info : User_Password_Check_Pkg.User_Record;
         begin
            User_Check_Object.Fetch_User
              (User     => User,
               info     => User_Info,
               Is_Admin => Is_Admin,
               success  => Success);
            declare
               New_User: constant string := To_String(User_Info.User);
               Password: constant string := To_String(User_Info.Password);
            begin

               If Success then
                  return  (User_Length => New_User'length,
                           Password_Length => Password'length,
                           User => New_User,
                           Password => Password,
                           Is_Admin => Is_Admin,
                           Serial_Number => User_Info.Serial_Number);
               else
                  raise Program_Error;
               end if;
            end;
         exception

            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
               return Blank_UTR;
         end Fetch_User;








         -- used to add or remove access dependent on
         -- User_Access_Type
         procedure Change_Serial_Attached_To_User
           (User : in string;
            Serial_Number : in Serial_Type;
            Success : out boolean) is
         begin
            User_Check_Object.Change_Serial_Attached_To_User
              (User          => User,
               Serial_Number => Serial_Number,
               Success       => Success);
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         end Change_Serial_Attached_To_User;



         function Check_Serial (Serial_Number : in Serial_Type) return Location_Id_Type is

         begin
            return Location_Table_PO.Find_Location_Id(Serial_Number);
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
               return 0;
         end Check_Serial;

         function Get_Cube_Serial
           (Location_Id : in Location_Id_Type) return Serial_Type is


         begin
            if Location_To_Pi(Location_Id) /= null then
               return Location_To_Pi(Location_Id).all.Get_Serial_No;
            else
               raise Program_Error;
            end if;
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
               return Blank_Serial;
         end Get_Cube_Serial;



         function Register (Serial_Number : in Serial_Type) return Location_Id_Type is
            Return_Value : Location_ID_Type := Location_Table_PO.
              Find_Location_Id(Serial_Number => Serial_Number);


            New_Object : boolean := false;
         begin
            Gnoga.log("Serial_Number " & String(Serial_Number));
            if Return_Value >  0 then
               Gnoga.log("pre existing Location is at " & Return_Value'img);
            else


               Location_Data.Register
                 (Serial_Number=>  Serial_Number,
                  Location_ID => Return_Value);
               Gnoga.log (" Registered  " & string(Serial_Number) & " at "
                          & Return_Value'img);

               Location_To_Pi (Return_Value) := new Each_Pi_Location_Type;
               Location_To_Pi(Return_Value).Initialise_Location
                 (Serial_Number => Serial_Number,
                  Location_Id => Return_Value);

               Gnoga.log("New location created at " & Return_Value'img);
               Location_Table_PO.Store_Location(Serial_Number => Serial_Number,
                                                Location_Id   => Return_Value);
               -- archive in database


            end if;

            return Return_Value;
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
               return 0;

         end Register;






         Procedure Submit_Room_data
           (Room_Data : in Room_Information_Record) is

            New_Room : boolean;

         begin
            if Location_To_Pi(Room_Data.Location) = null then
               null;
            else

               Location_To_Pi(Room_Data.location).Submit_Room_Data
                 (Room_Data, New_Room);
               if New_Room then
                  Gnoga.log("New_Room_Created called " & Room_Data.Room_Name
                            & " at " & Room_data.Room'img);
               else
                  Gnoga.log("Room already there : " & Room_Data.Room_Name);
               end if;
               declare
                  Archive_Terminal : Terminal_Access := Database_Ok.Get_Archive_Terminal;
               begin

                  if Archive_Terminal /= null then
                     Alarm.Temperature_Update
                       (Terminal => Archive_Terminal,
                        TC       => (Location => Room_Data.Location,
                                     Room => Room_Data.Room,
                                     Day => Sunday, -- day not used here
                                     TC_Change => RIR_Update));
                  end if;
               end;

            end if;
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         end Submit_Room_Data;


         function Get_Room_Data
           (Location : in Location_Id_Type;
            Room : in Room_Id_Type ) return Room_Information_Record is

         begin
            if Location_To_Pi(Location) = null
            then return Blank_RIR;
            else

               return  Location_To_Pi(Location).Get_Room_Data(Room);
            end if;

         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
               return Blank_RIR;

         end Get_Room_Data;

         function Get_Number_Of_Rooms (Location : in Location_Id_Type) return Room_Id_Type is
         begin
            Gnoga.log("Get_Number_Of_Rooms.Location " & Location'img );
            return Location_To_Pi(Location).Get_Number_Of_Rooms;
         exception
            when E : others => Gnoga.log ("Location "& Location'img
                                          & Ada.Exceptions.Exception_Information (E));
               return 0;

         end Get_Number_Of_Rooms;

         procedure Set_number_Of_Rooms (Location : in Location_Id_Type;
                                        Rooms : in Room_Id_Type) is
         begin
            Gnoga.log("set number of rooms Location_Id" & Location'img & " rooms " & Rooms'img);
            Location_To_Pi(Location).Set_Number_Of_Rooms(Rooms);
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         end Set_Number_Of_Rooms;


         procedure Modify_Day_Schedule
           (Location : in Location_Id_Type;
            Room_Number : in Room_Id_Type;
            The_Day : in Weekday_Type;
            Schedule : in Day_Schedule_Type;
            Success : out boolean) is
         begin
            If Location_To_Pi(Location) = null then
               Success := false;
               raise Program_Error;

            else
               Location_To_Pi(Location).Modify_Day_Schedule
                 (Room_Number => Room_Number,
                  The_Day => The_Day,
                  Schedule => Schedule,
                  Success => Success);
               declare
                  Pi_Terminal : Terminal_Access := Location_To_Pi(Location).Get_Pi_terminal;
               begin
                  if Pi_Terminal /= null then
                     -- send an update to the pi so that it knows to fetch an update
                     -- sending update
                     Gnoga.log(" Sending update to Pi " & Location'img);
--                       Alarm.Temperature_Update
--                         (Terminal => Pi_Terminal,
--                          TC       => (Location => Location,
--                                       Room => Room_Number,
--                                       Day => The_Day,
--                                       TC_Change => Schedule_Update));

                  else
                     Gnoga.log(" Pi " & Location'img & " did not get an update ");

                  end if;
                  Dsa_Usna_Server.Pi_Command_Insert
                       (Item =>
                          (Location => Location,
                           Room => Room_Number,
                           Day => The_Day,
                           TC_Change => Schedule_Update));
               end;

            end if;
            -- send to the archive as well
            declare
               Archive_Terminal : Terminal_Access := Database_Ok.Get_Archive_terminal;
            begin
               if Archive_Terminal /= null then
                  -- send an update to the pi so that it knows to fetch an update
                  Alarm.Temperature_Update
                    (Terminal => Archive_Terminal,
                     TC       => (Location => Location,
                                  Room => Room_Number,
                                  Day => The_Day,
                                  TC_Change => Schedule_Update));
               end if;
            end;

         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

         end Modify_Day_Schedule;

         function Fetch_Updated_Day_Schedule
           (Location : in Location_Id_Type;
            Room_Number : in Room_ID_Type;
            -- The_Week : in Which_Week_Type;
            The_Day : in Weekday_Type) return Day_Schedule_Type is

         begin
            if Location_To_Pi(Location) =null then
               raise Program_Error;
            else

               return Location_To_Pi(Location).Fetch_Updated_Day_Schedule
                 (Room_Number => Room_Number,
                  The_Day => The_Day);
            end if;
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
               return Blank_Day_Schedule;
         end Fetch_Updated_Day_Schedule;

         procedure Modify_Room_Mode_Temperatures
           (Location : in Location_Id_Type;
            Room_Number : in Room_ID_Type;
            The_Day : in Weekday_Type;
            Mode_Temperatures : in Mode_Temperature_Type) is

         begin
            if Location_To_Pi(Location) =null then
               raise Program_Error;
            else
               Location_To_Pi(Location).Modify_Room_Mode_Temperatures
                 (Room_Number => Room_Number,
                  The_Day=> The_Day,
                  Mode_Temperatures => Mode_Temperatures);
            end if;
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

         end Modify_Room_Mode_Temperatures;



         Function Get_Room_Mode_Temperatures
           (Location : in Location_Id_Type;
            Room_Number : in Room_Id_Type;
            The_Day : in Weekday_Type)
            return Mode_Temperature_Type is
         begin
            if Location_To_Pi(Location) =null then
               raise Program_Error;
            else
               return Location_To_Pi(Location).Get_Room_Mode_Temperatures
                 (Room_Number => Room_Number,
                  The_Day => The_Day);
            end if;

         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
               return Blank_Mode_Temperature;
         end Get_Room_Mode_Temperatures;


         --           procedure Deliver_Data
         --             (Location : in Location_Id_Type;
         --              Device_Info : Device_Data) is
         --           begin
         --              null;
         --           exception
         --              when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         --           end Deliver_Data;

         function Get_Description
           (Location : in Location_Id_Type)
            return string is

         begin
            return  Location_Data.Get_Description(Location);

         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
               return "";
         end Get_Description;


         function Occupied_Location
           (Location : in Location_Id_Type)
            return boolean is
         begin
            return Location_Data.Location_Occupied(Location_Id => Location);
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
               return true;
         end Occupied_Location;

         function Get_Max_Location return Location_Id_Type is
         begin
            return Location_Data.Get_Max_Location;
         exception
            when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
               return 0;
         end Get_Max_Location;

         package Debug_By_Location_Pkg is new Location_Fifo_Po(Element_Type => String);

         Debug_Po : Debug_By_Location_Pkg.The_Po;

         procedure Send_Debug_Message
           (Location : in Location_Id_Type;
                     Debug_Message : in string) is
         begin
            Debug_Po.Push(Location => Location,
                          Item => Debug_Message);
         end Send_Debug_Message;

         procedure Get_Next_Debug_Message
           (Location : out Location_Id_Type;
            Debug_Message : out string) is
         begin
            Debug_Po.Pop
              (Location => Location,
               Item => Debug_Message);
         end Get_Next_Debug_Message;

         function Messages_Waiting return boolean is
         begin
            return not Debug_Po.Is_Empty;
         end Messages_Waiting;


      end  Dsa_Usna_Server;
