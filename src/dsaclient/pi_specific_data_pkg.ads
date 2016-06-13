with Identity_Types_Pkg; use Identity_Types_Pkg;
with Gnat.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;
 use Gnat.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;

package Pi_Specific_Data_Pkg is


   Whole_House_Description : constant String := "Whole House";

   type RIR_Access is access Room_Information_Record;


 type Room_Array_Type is  array (Room_ID ) of RIR_Access;


   type Room_Boolean_Array_Type is array (Room_Id )
     of boolean;

   type RBA_Access is access Room_Boolean_Array_Type;

   type Messages_Per_Room_Array_Type is array (Room_ID ) of Natural;


   protected Pi_Data is


      procedure Reset;

      function Location_id return Location_Id_Type;

      procedure Set_Location_Id ( Location : in Location_Id_Type);

      procedure Set_Room_Name (Room : in Room_Id;
                               Roomname : String);

      procedure Process_Parameters
        (Device_P : in Device_Parameters);

      procedure Process_Data
        (Room : in Room_Id;
         Roomname : in string;
         Data : in Device_Data);

       procedure Room_Data_Ready
        (Room: in Room_Id;
         Ready : out boolean);

      function Get_Room_Information
        (Room : in Room_ID) return Room_Information_Record;

   private
      My_Location_Id : Location_Id_Type;
      Room_Array : Room_Array_Type  :=  (others => null);
      RBA : Room_Boolean_Array_Type := (others => false);
      Messages_Per_Room : Messages_Per_Room_Array_Type := (others => 0);
   end Pi_Data;



end Pi_Specific_Data_Pkg;
