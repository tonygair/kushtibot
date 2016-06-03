package body Special_Fifo_Po is



   protected body The_PO is

      procedure Push (Element : in Element_Type)  is
      begin
         Element_Fifo.Push
           (List => The_List,
            Item => Element);
      end Push;

      function Peek_At_Discriminator return Element_Discriminator_Type is
         Element : Element_Type := Element_Fifo.Peek( List => The_List);
      begin
         return Check_Discriminator(Element) ;
      end Peek_At_Discriminator;




      procedure Pop  (Element_Discriminator : in Element_Discriminator_Type ;
                      Element : out Element_Type;
                      Success : out boolean) is
      begin
         if Element_Discriminator = Peek_At_Discriminator then
            Success := true;
            Element_Fifo.Pop
              (List => The_List,
               Item => Element);
         end if;

      end Pop;


      function Is_Empty  return Boolean is
      begin
         return          Element_Fifo.Is_Empty(List => The_List);
      end Is_Empty;


      -- private
      --    The_List : Element_Fifo.Fifo_Type;
   end The_PO;


end Special_Fifo_Po;
