with Identity_Types_Pkg; use Identity_Types_Pkg;

package Print_Records_Pkg is

   function Print_Rir  (Rir : in Room_Information_Record) return String;


   function Print_Rir_For_Button (Rir : in Room_Information_Record) return String;


   end Print_Records_Pkg;
