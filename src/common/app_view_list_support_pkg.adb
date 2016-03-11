
with Gnoga.Gui.Element.Form;
--with Gnoga;
package body App_View_List_Support_Pkg is


   -- produces a gnoga list from an unbounded string array


   Procedure Clear_Select
     (The_Select : in out Gnoga.Gui.Element.Form.Selection_Type) is
   begin
      for Count in 1..The_Select.Length loop
         The_Select.Remove_Option(Index => 1);
      end loop;
   end Clear_Select;


   procedure Populate_Select
     (The_Select : in out Gnoga.Gui.Element.Form.Selection_Type;
      String_List : in UString_List_Type) is
   begin
      for Count in 1..String_List'length loop
         The_Select.Add_Option
           (Value    => Count'img,
                               Text     => Su.To_String(String_List(Count)),
                               Index    => Count,
                               Selected => false,
                               Disabled => false);
      end loop;
   end Populate_Select;



   procedure Generic_Populate_Select
     (The_Select : in out Gnoga.Gui.Element.Form.Selection_Type;
      T_Array    : in T_Array_Type;
     Location_Id  : in Location_Id_Type) is

   begin

      for Count in 1..Index_Type(T_Array'length) loop
         Gnoga.log("Value " & Count'img);
         The_Select.Add_Option
           (Value    => Count'img,
            Text     => Stringify_T_Type (Location_Id,
              T_Array(Count)),
            Index    => natural(Count),
            Selected => false,
            Disabled => false);
      end loop;
      -- remove any left over that were present in the last select
      -- if it were smaller


      if The_Select.Length > T_Array'length then
         declare
            Start_Of_Rest : Natural := T_Array'length + 1;
         begin

            for count in T_Array'length + 1 .. The_Select.Length loop
               The_Select.Remove_Option (Start_Of_Rest);
            end loop;
         end;
      end if;

   end Generic_Populate_Select;








end App_View_List_Support_Pkg;
