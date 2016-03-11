

with ODBC.API;  use ODBC.API;
--with Modified_Elv_Types; use Modified_Elv_Types;
--with Device_Type_Pkg; use Device_Type_Pkg;
--with User_And_Location_Types_Pkg; use User_And_Location_Types_Pkg;
with Identity_Types_Pkg; use Identity_Types_Pkg;
with User_Password_Check_Pkg;

package Archiver_Pkg is



   task type Archiver_Task_Type is
      entry Start_Archiving;
      entry End_The_Task;
   end Archiver_Task_Type;

   type Archiver_Task_Type_Access is access Archiver_Task_Type;

--     type Device_Is_Archived_Array is Array (Location_Id_Type, Device_Index_Type)
--       of boolean;
--
--     type Device_Unique_Ref_Array is Array (Location_Id_Type, Device_Index_Type)
--       of Integer;


--     procedure Deposit_Device_Details
--       (Location : in Location_Id_Type;
--        Device_Info : in Device_Parameters);

--     procedure Deposit_Room_Data
--       ( Location : in Location_Id_Type;
--        Data : in Room_Information_Record);
--
--     procedure Deposit_User_Data (User : in User_Password_Check_Pkg.User_Record);








end Archiver_Pkg;
