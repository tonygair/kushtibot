with Identity_Types_Pkg; use Identity_Types_Pkg;
with Gnat.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;
 use Gnat.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;

package Pi_Specific_Data_Pkg is

   type RIR_Access is access Room_Information_Record;


 type Room_Array_Type is  array (Room_ID range <>) of RIR_Access;

   type Room_Array_Access is access Room_Array_Type;

   type Room_Boolean_Array_Type is array (Room_Id range <>)
     of boolean;

   type RBA_Access is access Room_Boolean_Array_Type;

   protected Pi_Data is


      procedure Reset;

      function Location_id return Location_Id_Type;

      procedure Set_Location_Id ( Location : in Location_Id_Type);

      procedure Set_Number_Rooms (Room_Size : in Natural);

      procedure Process_Data
        (Room : in Room_Id;
         Roomname : in string;
         Data : in Device_Data);

      function Room_Data_Ready (Room: Room_Id)
         return boolean ;

      function Get_Room_Information
        (Room : in Room_ID) return Room_Information_Record;

   private
      My_Location_Id : Location_Id_Type;
      Room_Array : Room_Array_Access  := null;
      RBA : RBA_Access := null;
   end Pi_Data;



end Pi_Specific_Data_Pkg;
