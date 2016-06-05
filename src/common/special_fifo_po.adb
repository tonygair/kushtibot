with Gnoga;
with Ada;
with Ada.Exceptions;
with Ada.Exceptions;
package body Special_Fifo_Po is



   protected body The_PO is

      procedure Push (Element : in Element_Type)  is
      begin
         Element_Fifo.Push
           (List => The_List,
            Item => Element);
         Message_Number := Message_Number + 1;
      exception
         when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

      end Push;

      function Peek_At_Discriminator return Element_Discriminator_Type is
         Element : Element_Type := Element_Fifo.Peek( List => The_List);
      begin
         return Check_Discriminator(Element) ;
      exception
         when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));
         raise Program_Error;
      end Peek_At_Discriminator;




      procedure Pop  (Element_Discriminator : in Element_Discriminator_Type ;
                      Element : out Element_Type;
                      Success : out boolean) is
      begin
         if Element_Discriminator = Peek_At_Discriminator then

            Element_Fifo.Pop
              (List => The_List,
               Item => Element);
            Success := true;
            Message_Number := Message_Number - 1;
         else
            Success := false;
         end if;
      exception
         when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

      end Pop;


      function Is_Empty  return Boolean is
      begin
         return          Element_Fifo.Is_Empty(List => The_List);
      end Is_Empty;

      function Messages_Waiting return Natural is
      begin
         return Message_Number;
      exception
         when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));
            return 0;

      end Messages_Waiting;


      -- private
      --    The_List : Element_Fifo.Fifo_Type;
   end The_PO;


end Special_Fifo_Po;
