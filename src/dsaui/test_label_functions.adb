with Label_Function_Pkg; use Label_Function_Pkg;
with Identity_Types_Pkg; use Identity_Types_Pkg;
with gnoga;
procedure Test_Label_Functions is

begin
for count in Room_Id_Type'first..Room_Id_Type'last loop

Gnoga.log(Get_Room_Id_From_Label(Make_Room_Label(count))'img);
end loop;

   for count in Location_Id_Type'first..Location_Id_Type'last loop

Gnoga.log(Get_Location_Id_From_Label(Make_Location_Label(count))'img);
end loop;


end Test_Label_Functions;
