with Dsa_Usna_Server;
with Gnoga;
with Ada;
with Ada.Exceptions;
package body Print_Records_Pkg is

   function Print_Rir  (Rir : in Room_Information_Record) return String is

   begin
      Return Dsa_Usna_Server.Get_Description(Rir.Location) & " : " & Rir.Room_Name & " :  Set Point - "
        & Rir.Set_Point'img & " : Actual - " & Rir.Actual'img ;
       exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         return "";

   end Print_Rir;



   function Print_Rir_For_Button (Rir : in Room_Information_Record) return String is

   begin
      return Rir.Room_Name & " :  Set - "
        & Rir.Set_point'img & " : Is- " & Rir.Actual'img ;
    exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         return "";

end Print_Rir_For_Button;

   end Print_Records_Pkg;
