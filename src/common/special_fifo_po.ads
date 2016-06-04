

with Fifo;
generic
   type Element_Type (<>) is private;
   type Element_Discriminator_Type is private;
  with function Check_Discriminator ( Element : in Element_Type) return Element_Discriminator_Type ;
package Special_Fifo_Po is

      Package Element_Fifo is new Fifo(Element_Type => Element_Type);


   protected type  The_PO is

      procedure Push (Element : in Element_Type) ;

      function Peek_At_Discriminator return Element_Discriminator_Type;

      procedure Pop  (Element_Discriminator : in Element_Discriminator_Type ;
                      Element : out Element_Type;
                      Success : out boolean);

       function Is_Empty  return Boolean;


   private
      The_List : Element_Fifo.Fifo_Type;
      View_In_Progress : boolean := false;
   end The_PO;



end Special_Fifo_Po;
