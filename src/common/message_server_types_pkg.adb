
package body Message_Server_Types_Pkg is

   protected body P_LR_Boolean_Array_Type  is

      procedure Set_Value (Location_Id : in Location_Id_Type;
                           Room_Id : in Room_Id_Type;
                           Value : in Boolean) is
      begin
         Location_Value(Location_Id,Room_Id) := Value;
      end Set_Value;


      function Get_Value (Location_Id : in Location_Id_Type;
                          Room_Id : in Room_Id_Type) return boolean is
      begin
         return Location_Value(Location_Id,Room_Id);
      end Get_Value;

   end P_LR_Boolean_Array_Type;

     protected body P_S_Boolean_Array_Type  is

      procedure Set_Value (Location_Id : in Location_Id_Type;
                           Schedule_Id : in Schedule_Id_Type;
                           Value : in Boolean) is
      begin
         Location_Value(Location_Id,Schedule_Id) := Value;
      end Set_Value;


      function Get_Value (Location_Id : in Location_Id_Type;
                          Schedule_Id : in Schedule_Id_Type) return boolean is
      begin
         return Location_Value(Location_Id,Schedule_Id);
      end Get_Value;

   end P_S_Boolean_Array_Type;


end Message_Server_Types_Pkg;
