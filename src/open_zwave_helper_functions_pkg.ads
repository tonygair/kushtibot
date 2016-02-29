
with Open_Zwave; use Open_Zwave;
with Fifo;
with Ada.Unchecked_Deallocation;

with Ada.Calendar;
--with Gnat.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;
with Tables;
with Ada.Strings.Unbounded;
with Interfaces;
package Open_Zwave_Helper_Functions_Pkg is

   package SU renames Ada.Strings.Unbounded;
  -- package EC renames Gnat.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;

   type Battery_Level_Type is new integer range 1..100;

   type Message_Type is (Battery_Life, Temperature_Report, Wake_Up_Interval, Reported_Ratio);

   type Interval_Type is new integer range 1..610000;


   type Command_Class_Description_Type is array(Open_Zwave.Value_U8) of
     SU.Unbounded_String;




      procedure Process_Notification_Data (Notification : in Notification_Info);


   package Queue_Pkg is new Fifo(Element_Type => Notification_Info);

   protected Notification_Queue_PO is

      procedure Add_Item ( Value : in Notification_Info);

      function Empty return boolean;

      function The_Size return Natural;

      procedure Read_Item (Value : out Notification_Info);




   private
      Queue_Size : natural := 0;
      Queue : Queue_Pkg.Fifo_Type;


   end Notification_Queue_PO;





   -- command classes


   protected Home_Id_P is
      procedure Set_Home_Id ( Home_Id : in Controller_ID);
      function Read_Home_Id return Controller_ID;
      function Home_Id_Set return boolean;

   private
      Home_Id_Is_Set : boolean := false;

      The_Home_Id : Controller_ID;
   end Home_Id_P;


   Type Z_Store_Type is record
      Occurred_At : Ada.Calendar.Time;
      The_Value_Id : Value_Id;
   end record;

   Blank_Adatime : constant Ada.Calendar.Time :=
     Ada.calendar.Time_Of
     (Year => 1969,
      Month => 12,
      Day => 14);


   Blank_Z_Store : constant Z_Store_Type :=
     (Occurred_At => Blank_Adatime,
      The_Value_ID =>
        (Type_ID => Invalid,
         Index => 0,
         Command_Class_ID =>  0,
         Genre => Invalid,
         Node => 0,
         Command_Class_Index => 0,
         Home_Id => 0
        ) );

   type Class_List_Array_Type is array (positive range <>) of Open_Zwave.Value_U8;

   Blank_Class_List : constant Class_List_Array_Type(1..0) := (others => 0);



   type Z_Store_Array_Type is array (positive range <>) of Z_Store_Type;

   Blank_Z_Store_Array : constant Z_Store_Array_Type (1..0) := (others => Blank_Z_Store);


    package Command_Class_Table is new Tables(Tag => Z_Store_Type);


   protected type Command_Class_Values_Type is
      function Node_Initialised return boolean;
      procedure Initialise_Node ( Node_Value : Value_U8);
      function Get_Node_ID return Value_U8;
      procedure Add_Class_Value ( Class_Value : in Z_Store_Type);
      function Get_Class_Value (Class : in Value_U8) return Z_Store_Type;
      function Get_List_Class return Class_List_Array_Type;
      function Get_List_Class_Values return Z_Store_Array_Type;
   private
      Initialised : boolean := false;
      This_Node_Id : Value_U8;
      List_Table : Command_Class_Table.Table;
   end Command_Class_Values_Type;

   type Z_Network_Values_Type is array (Open_Zwave.Value_U8) of Command_Class_Values_Type;


   This_Network : Z_Network_Values_Type;


   package Node_Table_Pkg is new Tables(Tag => Value_U8);

   type Value_U8_Array_Type is Array(Natural range <>) of Value_U8;

   Blank_Value_U8_Array : Value_U8_Array_Type(1..0) := (others => 0);


   protected The_Nodes is
      procedure Submit_Node (Node_Value : in Value_U8);
      function Get_Active_Node_List return Value_U8_Array_Type;
      function Number_Nodes return Natural;
   private
      Node_Table : Node_Table_Pkg.Table;
   end The_Nodes;

    type Dummy_Type is new integer;


   procedure Process_Z_Notification_Into_Data (Chunk : in Open_Zwave.Notification_Info;
                        Context      : in out Dummy_Type);

end Open_Zwave_Helper_Functions_Pkg;
