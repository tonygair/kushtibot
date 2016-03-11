with Gnoga.Gui.Element.Form;
with Ada.Strings.Unbounded;
--with User_And_Location_Types_Pkg; use User_And_Location_Types_Pkg;
with Identity_Types_Pkg; use Identity_Types_Pkg;

package App_View_List_Support_Pkg is

use Gnoga.Gui.Element;

   package Su renames Ada.Strings.Unbounded;

   type UString_List_Type is array(positive range <>) of Su.Unbounded_String;


   -- produces a gnoga list from an unbounded string array


   Procedure Clear_Select
     (The_Select : in out Gnoga.Gui.Element.Form.Selection_Type);

   procedure Populate_Select
     (The_Select : in out Gnoga.Gui.Element.Form.Selection_Type;
      String_List : in UString_List_Type);




   generic
      type T_Type is limited private;
     type Index_Type is new natural;

      type T_Array_Type is array(Index_Type range <>) of T_Type;
      with function Stringify_T_Type (Location_Id : in Location_Id_Type;
                                      T : in T_Type ) return string;
   procedure Generic_Populate_Select
     (The_Select : in out Gnoga.Gui.Element.Form.Selection_Type;
      T_Array    : in T_Array_Type;
     Location_Id : in Location_Id_Type);









end App_View_List_Support_Pkg;
