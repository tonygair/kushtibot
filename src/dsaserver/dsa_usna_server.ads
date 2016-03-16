with Alarm; Use Alarm;
with Identity_Types_Pkg; use Identity_Types_Pkg;
package Dsa_Usna_Server is

   pragma Remote_Call_Interface;

    type Terminal_Access is access all Terminal_Type'Class;

   procedure Register_Pi
     (Terminal : in Terminal_Access;
      Location : in Location_Id_Type);

   procedure Deregister_Pi
     (Location : in Location_Id_Type);
   
   procedure Register_Ui
     (Terminal : in Terminal_Access;
      Location : in Location_Id_Type);

      procedure Deregister_Ui
     (Location : in Location_Id_Type);

   procedure Register_Archiver
     (Terminal : in Terminal_Access);
   
   procedure Deregister_Archiver;
   
     
   

    procedure Set_Database_To_Ready;
   
   function Is_Database_Ready return boolean;
   
   
  
--     type Terminal_Access is access all Terminal_Type'Class;
--     
--     type Terminal_Version_Type is (Archiver_Terminal, Web_Terminal, Pi_Terminal);
--     
--     procedure Register_Terminal 
--       (Terminal_Version : in Terminal_Version_Type;
--        Actual_Terminal : in Terminal_Access;
--        Serial_Number : in Serial_Type);
--     
   --- data base data reconstruction 
    procedure Load_Location_Data_From_Database
     (Description : in string;
      Location_Id : in Location_Id_Type;
      Serial_Number : in Serial_Type);
   
   function Get_Description 
     (Location : in Location_Id_Type)
      return string;
   
   function Occupied_Location
     (Location : in Location_Id_Type)
     return boolean;
   
   procedure Pi_Command_Insert
     (Item : in TC_Change_Record);
   
   procedure Pi_Command_Get
     (Location : Location_Id_Type;
      Item : out TC_Change_Record);
   
   function Is_Empty 
     (Location : Location_Id_Type) return boolean;
   
   
   -- end of database reconstruction
   -- Users
   
     function IsIn (User : in string ) return boolean;

      function Check_User_Password
        (User , Password : in string)
         return Serial_Type;

      procedure User_Admin_Setting
        (User : in string;
         Admin : in boolean);

      function Is_User_An_Admin
        (User : in  String) return boolean;

      procedure Add_User
        (User , Password : in string;
         Serial_Number : in Serial_Type := Blank_Serial;
         Is_Admin : in boolean;
         Success : out boolean);

   function Fetch_User 
     (User : in string) return User_Transfer_Record;

   -- used to add or remove access dependent on
   -- User_Access_Type
      procedure Change_Serial_Attached_To_User
        (User : in string;
         Serial_Number : in Serial_Type;
         Success : out boolean);

   
   function Register 
     (Serial_Number : in Serial_Type) return Location_Id_Type;

   function Check_Serial 
     (Serial_Number : in Serial_Type) return Location_Id_Type;
   
   function Get_Cube_Serial
     (Location_Id : in Location_Id_Type) return Serial_Type;
   
   procedure Send_Debug_Message
     ( Location : in Location_Id_Type;
      Debug_Message : in string);
   
     procedure Get_Next_Debug_Message 
           (Location : out Location_Id_Type;
            Debug_Message : out string) ;
   
   function Messages_Waiting return boolean;
   
   
--     function Get_Modified_Device 
--       (Serial_Number : in Serial_Type;
--        Location_Id : in Location_Id_Type
--   	  ) return Device_Parameters;
--    
--     procedure Store_Device_Parameters 
--       (Location : in Location_Id_Type;
--        Static_Device_Info : in Device_Parameters) ;
--     
   
   Procedure Submit_Room_data
     (Room_Data : in Room_Information_Record);
                                          
   function Get_Room_Data 
     (Location : in Location_Id_Type;
      Room : in Room_Id_Type ) return Room_Information_Record;                      
     
   function Get_Number_Of_Rooms (Location : in Location_Id_Type) return Room_Id_Type;
   
   procedure Set_number_Of_Rooms (Location : in Location_Id_Type;
                                  Rooms : in Room_Id_Type);
 procedure Modify_Day_Schedule
           (Location : in Location_Id_Type;
            Room_Number : in Room_Id_Type;
            The_Day : in Weekday_Type;
            Schedule : in Day_Schedule_Type;
            Success : out boolean);
   
         function Fetch_Updated_Day_Schedule
           (Location : in Location_Id_Type;
            Room_Number : in Room_ID_Type;
            -- The_Week : in Which_Week_Type;
            The_Day : in Weekday_Type) return Day_Schedule_Type ;
   
         procedure Modify_Room_Mode_Temperatures
           (Location : in Location_Id_Type;
            Room_Number : in Room_ID_Type;
            The_Day : in Weekday_Type;
            Mode_Temperatures : in Mode_Temperature_Type);



         Function Get_Room_Mode_Temperatures
           (Location : in Location_Id_Type;
            Room_Number : in Room_Id_Type;
            The_Day : in Weekday_Type)
            return Mode_Temperature_Type;
   

function Get_Max_Location return Location_Id_Type;

end  Dsa_Usna_Server;
