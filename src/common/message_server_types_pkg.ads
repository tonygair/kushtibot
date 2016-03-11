with User_And_Location_Types_Pkg; use User_And_Location_Types_Pkg;
with Identity_Types_Pkg; use Identity_Types_Pkg;


package Message_Server_Types_Pkg is





   type Location_Room_Boolean_Array_Type is array
     (Location_Id_Type, Room_Id_Type ) of boolean;


    type Location_Schedule_Boolean_Array_Type is array
     (Location_Id_Type, Schedule_Id_Type ) of boolean;




protected type P_LR_Boolean_Array_Type  is

      procedure Set_Value (Location_Id : in Location_Id_Type;
                           Room_Id : in Room_Id_Type;
                          Value : in Boolean);

      function Get_Value (Location_Id : in Location_Id_Type;
                        Room_Id : in Room_Id_Type) return boolean;


      private
      Location_Value : Location_Room_Boolean_Array_Type
        := (others=> (others => false));
   end P_LR_Boolean_Array_Type;


   protected type P_S_Boolean_Array_Type  is

      procedure Set_Value (Location_Id : in Location_Id_Type;
                           Schedule_Id : in Schedule_Id_Type;
                          Value : in Boolean);

      function Get_Value (Location_Id : in Location_Id_Type;
                        Schedule_Id : in Schedule_Id_Type) return boolean;


      private
      Location_Value : Location_Schedule_Boolean_Array_Type
        := (others=> (others => false));
   end P_S_Boolean_Array_Type;


end Message_Server_Types_Pkg;
