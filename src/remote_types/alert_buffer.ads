with Location_Fifo_Po;
with Fifo_Po;
with Identity_Types_Pkg; use Identity_Types_Pkg;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Alert_Buffer is

--     package Device_Fifo is new Location_Fifo_Po
--       (Element_Type => Rf_Address);

   Package TC_Fifo is new Location_Fifo_Po
     (Element_Type => TC_Change_Record);

   Package User_Fifo is new Fifo_Po
     (Element_Type => Unbounded_String);


  -- Device_Buffer : Device_Fifo.The_Po;

   TC_Buffer : TC_Fifo.The_Po;

   User_Buffer : User_Fifo.The_Po;


end Alert_Buffer;
