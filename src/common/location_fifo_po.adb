with Gnoga;
package body Location_Fifo_Po is



   protected body The_PO is

      procedure Push ( Item : in Element_Type;
                      Location : in Location_Id_Type)  is
      begin
         Element_Fifo.Push
           (List => The_List,
            Item => Item);
         Location_Fifo.Push (List => Location_List,
                             Item => Location);
         Gnoga.log("Remote Message has arrived for Location " & Location'img);

      end Push;


      procedure Pop ( Item : out Element_Type;
                      Location : out Location_Id_Type)  is
      begin
         Element_Fifo.Pop
           (List => The_List,
            Item => Item);
         Location_Fifo.Pop(List => Location_List,
                           Item => Location);

      end Pop;


      function Is_Empty  return Boolean is
      begin
         return          Element_Fifo.Is_Empty(List => The_List);
      end Is_Empty;



  -- private
  --    The_List : Element_Fifo.Fifo_Type;
   end The_PO;


end Location_Fifo_Po;
