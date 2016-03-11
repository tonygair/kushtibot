Package body Label_Function_Pkg is

   Room_Prefix : constant string := "room_label";

   Location_Prefix : constant string := "Location_label";

   function Make_Room_Label (Room : in Room_Id_Type) return String is
   begin
      return Room'img & Room_Prefix;
   end Make_Room_Label;



   function Get_Room_Id_From_Label (Label : in string) return Room_Id_Type is
      Length_To_Take : constant Natural := Label'length - Room_Prefix'length;
   begin
      return Room_Id_Type'value(Label
                                (Label'first..(Label'first +Length_To_Take -1)));

   end Get_Room_Id_From_Label;



   function Make_Location_Label (Location : in Location_Id_Type) return String is
   begin
      return Location'img & Location_Prefix;
   end Make_Location_Label;



   function Get_Location_Id_From_Label (Label : in string) return Location_Id_Type is
      Length_To_Take : constant Natural := Label'length - Location_Prefix'length;
   begin
      return Location_Id_Type'value(Label
                                (Label'first..(Label'first +Length_To_Take -1)));

   end Get_Location_Id_From_Label;


   end Label_Function_Pkg;
