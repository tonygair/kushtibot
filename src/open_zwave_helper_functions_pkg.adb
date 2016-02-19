with Gnoga;
with Interfaces;
with Ada.Exceptions;
package body Open_Zwave_Helper_Functions_Pkg is




   procedure Process_Notification_Data (Notification : in Notification_Info) is

   begin
      Gnoga.log("Process Notification Data MTYPE is " & Notification.M_Type'img);
      case Notification.M_Type is

         when Value_Added =>
            null;
         when        Value_Removed =>
            null;
        when    Value_Changed =>
            null;
         when Value_Refreshed =>
            null;
         when Group =>
            null;
         when Node_New =>
            null;
         when Node_Added =>
            null;
         when Node_Removed =>
            null;
         when Node_Protocol_Info =>
            null;
         when Node_Naming =>
            null;
         when Node_Event =>
            null;
         when Polling_Disabled =>
            null;
         when Polling_Enabled =>
            null;
         when Scene_Event =>
            null;
         when Create_Button =>
            null;
          when Delete_Button =>
            null;
          when Button_On =>
            null;
          when Button_Off =>
            null;
         when Driver_Ready =>
            null;
         when Driver_Failed =>
            null;
         when Driver_Reset =>
            null;
         when Essential_Node_Queries_Complete =>
            null;
         when Node_Queries_Complete =>
            null;
         when Awake_Nodes_Queried =>
            null;
         when All_Nodes_Queried_Some_Dead =>
            null;
         when All_Nodes_Queried|
                                 Notification_Type|
                                 Driver_Removed|
              Invalid =>
            null;

      end case;

   end Process_Notification_Data;

   protected body Notification_Queue_PO is

      procedure Add_Item ( Value : in Notification_Info) is

      begin
         Gnoga.log(Value.M_Type'Img & " added to queue ");
         Queue_Pkg.Push(List => Queue,
                        Item => Value);
         Queue_Size := Queue_Size + 1;
         --Gnoga.log(" Pushed Value ");
         --Output_Value (Value);
      exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

      end Add_Item;

      function Empty return boolean is
      begin
         return Queue_Pkg.Is_Empty(Queue);
      exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
            return true;
      end Empty;

      function The_Size return Natural is
      begin
         return Queue_Size;
      end The_Size;


      procedure Read_Item (Value : out Notification_Info) is
      begin
         Queue_Pkg.Pop(List => Queue,
                       Item => Value);
         Queue_Size := Queue_Size - 1;

         --Gnoga.log("Popped Value ");
         --  Output_Value (Value);
      exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

      end Read_Item;


   end Notification_Queue_PO;


    protected body Home_Id_P is
      procedure Set_Home_Id ( Home_Id : in Controller_ID) is
      begin
         Home_Id_Is_Set := true;
         The_Home_Id := Home_Id;
      end Set_Home_Id;

      function Read_Home_Id return Controller_ID is
      begin
         return The_Home_Id;
      end Read_Home_Id;

      function Home_Id_Set return boolean is
      begin
         return Home_Id_Is_Set;
      end Home_Id_Set;

--   private
--      The_Home_Id : Controller_ID;
   end Home_Id_P;



   Node_Not_Initialised : exception;

   Node_Already_Initialised : exception;


   protected body  Command_Class_Values_Type is


      function Class_Location(Node : in Value_U8) return Natural is
      begin
         return List_Table.Locate(Name => Node'img);
      end Class_Location;

      procedure Initialise_Node(Node_Value : in Value_U8) is

      begin
         if not Initialised then
            This_Node_Id := Node_Value;
            Initialised := true;
         else
            raise Node_Already_Initialised;
         end if;
      end Initialise_Node;

      function Get_Node_ID return Value_U8 is
      begin
         if Initialised then
            return This_Node_Id;
         else
            raise Node_Not_Initialised;
         end if;
      end Get_Node_Id;



      procedure Add_Class_Value ( Class_Value : in Z_Store_Type) is
         Class_Place : Natural :=Class_Location(Class_Value.Class);
      begin
         if not Initialised then
            raise Node_Not_Initialised;
         end if;

         if Class_Place = 0 then
            List_Table.Add(Name => Class_Value.Class'img,
                           Data => Class_Value);
         else
            List_Table.Replace(Offset => Class_Place,
                               Data   => Class_Value);
         end if;
      end Add_Class_Value;

      function Get_Class_Value (Class : in Value_U8)  return Z_Store_Type is
         Class_Place : Natural := Class_Location(Class);
         Return_Value : Z_Store_Type;
      begin
         if not Initialised then
            raise Node_Not_Initialised;
         end if;
         if Class_Place=0 then
            Return_Value := Blank_Z_Store;
         else
            Return_Value := List_Table.GetTag(Offset => Class_Place);
         end if;
         return Return_Value;
      end Get_Class_Value;

      function Get_List_Class return Class_List_Array_Type is
         Array_Size : Natural := List_Table.GetSize;
               Class_List : Class_List_Array_Type(1..Array_Size);

      begin
         if Array_Size = 0 then
            return Blank_Class_List;
         else

               for count in 1..Array_Size loop
                  Class_List(count) := List_Table.GetTag(count).Class;
               end loop;
               return Class_List;

         end if;
      end Get_List_Class;


      function Get_List_Class_Values return Z_Store_Array_Type is
               Array_Size : Natural := List_Table.GetSize;
               Class_List : Z_Store_Array_Type(1..Array_Size);

      begin
         if Array_Size = 0 then
            return Blank_Z_Store_Array;
         else

               for count in 1..Array_Size loop
                  Class_List(count) := List_Table.GetTag(count);
               end loop;
               return Class_List;

         end if;

      end Get_List_Class_Values;


   end Command_Class_Values_Type;







end  Open_Zwave_Helper_Functions_Pkg;
