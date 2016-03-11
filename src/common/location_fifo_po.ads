with Fifo;
with Identity_Types_Pkg; use Identity_Types_Pkg;
generic
   type Element_Type (<>) is private;
package Location_Fifo_Po is


   Package Element_Fifo is new Fifo(Element_Type => Element_Type);

   package Location_Fifo is new Fifo(Element_Type => Location_Id_Type);

   protected type The_PO is

      procedure Push ( Item : in Element_Type;
                       Location : in Location_Id_Type) ;

      procedure Pop (Item : out Element_Type;
                     Location : out Location_Id_Type) ;

      function Is_Empty  return Boolean;

   private
      Location_List : Location_Fifo.Fifo_Type;

      The_List : Element_Fifo.Fifo_Type;
   end The_PO;

end Location_Fifo_Po;
