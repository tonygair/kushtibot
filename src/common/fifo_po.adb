package body Fifo_Po is



   protected body The_PO is

      procedure Push ( Item : in Element_Type)  is
      begin
         Element_Fifo.Push
           (List => The_List,
            Item => Item);
      end Push;


      procedure Pop ( Item : out Element_Type)  is
      begin
         Element_Fifo.Pop
           (List => The_List,
            Item => Item);
      end Pop;


      function Is_Empty  return Boolean is
      begin
         return          Element_Fifo.Is_Empty(List => The_List);
      end Is_Empty;


  -- private
  --    The_List : Element_Fifo.Fifo_Type;
   end The_PO;


end Fifo_Po;
