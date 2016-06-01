
package body Location_Types is

   function Convert_Location_Array ( The_Array : in Access_Array_Type) return Integer is
      Return_Value : Integer := 0;
   begin

      for count  in Location_Id_Type'first + 1.. Location_Id_Type'last  loop
         if The_Array(count) = full then
            Return_Value := Return_Value + 2**(integer (count-1));
         end if;

      end loop;
      return Return_Value;

   end Convert_Location_Array;



   function Convert_Location_Value ( The_Value : in Integer ) return Access_Array_Type is
   Return_Value : Access_Array_Type := (others => none);
   Compare_Value : integer ;
   D_Value : integer := The_Value;
begin
   for count in reverse (Location_Id_Type'first+1)..Location_Id_Type'last loop
      Compare_Value := 2**(integer (count-1));
      if Compare_Value > D_Value then
         null;
      else
         D_Value := D_Value - Compare_Value;
         Return_Value(count) := full;
      end if;
      if The_Value = 0 then
         exit;
      end if;
   end loop;
   return Return_Value;
end Convert_Location_Value;

end Location_Types;
