
with Identity_Types_Pkg; use Identity_Types_Pkg;
Package Label_Function_Pkg is


   function Make_Room_Label (Room : in Room_Id_Type) return String;

   function Get_Room_Id_From_Label (Label : in string) return Room_Id_Type;

   function Make_Location_Label (Location : in Location_Id_Type) return String;

   function Get_Location_Id_From_Label (Label : in string) return Location_Id_Type;

end Label_Function_Pkg;
