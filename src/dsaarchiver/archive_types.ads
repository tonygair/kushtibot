

--NOTUSED
with Schedule_Types_Pkg; use Schedule_Types_Pkg;

package Archive_Types is

type  Schedule_Archive_Record is record
     Schedule_id : Schedule_Id_Type;
      Location_Id :  Location_Id_Type;
      Name : Unbounded_String;
   end record;


   type Command_Archive_Record is record
      Db_Command_Id : integer;
      Command_Id : Schedule_Command_Type;
      Location : Location_Id_Type;
      Schedule_Id : Schedule_Id_Type;
      Time_Of_Week : Weekly_Time_Type;
      Mode : TRV_Mode_Type;
   end record;


end package archive_Types;
