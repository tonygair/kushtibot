with Ada.Unchecked_Deallocation;
with Gnoga;
with Ada.Exceptions;


package body Fifo is

   ----------
   -- Push --
   ----------

   procedure Push (List : in out Fifo_Type; Item : in Element_Type) is
      Temp_EP : Element_Ptr := new Element_Type'(Item);
      Temp : Fifo_Ptr := new Fifo_Element'(Temp_EP, null);
   begin
      if List.Tail = null then
         List.Tail := Temp;
      end if;
      if List.Head /= null then
         List.Head.Next := Temp;
      end if;
      List.Head := Temp;
   exception
      when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

   end Push;

   --------
   -- peek --
   ------------
   function Peek (List : in Fifo_Type) return Element_Type is
   begin
      if List.Head = null or List.Tail.Value = null then
         raise Empty_Error;
      end if;
      Return List.Tail.Value.all;
   exception
      when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

   end Peek;

   ---------
   -- Pop --
   ---------

   procedure Pop (List : in out Fifo_Type; Item : out Element_Type) is
      Procedure Free_EP is new Ada.Unchecked_Deallocation(Element_Type, Element_Ptr);
      procedure Free_FP is new Ada.Unchecked_Deallocation(Fifo_Element, Fifo_Ptr);
      Temp : Fifo_Ptr := List.Tail;
   begin
      if List.Head = null or List.Tail.Value = null then
         raise Empty_Error;
      end if;
      Item := List.Tail.Value.all;
      List.Tail := List.Tail.Next;
      if List.Tail = null then
         List.Head := null;
      end if;
      Free_EP (Temp.Value);
      Free_FP (Temp);
   exception
      when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

   end Pop;

   --------------
   -- Is_Empty --
   --------------

   function Is_Empty (List : Fifo_Type) return Boolean is
   begin
      return List.Head = null;
   exception
      when E : others =>  Gnoga.log("EXCEPTION" & Ada.Exceptions.Exception_Information (E));

   end Is_Empty;

end Fifo;
