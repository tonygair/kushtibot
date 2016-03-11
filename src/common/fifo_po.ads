with Fifo;
generic
   type Element_Type (<>) is private;
package Fifo_Po is

      Package Element_Fifo is new Fifo(Element_Type => Element_Type);


   protected type The_PO is

      procedure Push ( Item : in Element_Type) ;

       procedure Pop (Item : out Element_Type) ;

       function Is_Empty  return Boolean;


   private
      The_List : Element_Fifo.Fifo_Type;
   end The_PO;


end Fifo_Po;
