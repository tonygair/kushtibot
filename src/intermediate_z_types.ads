with Interfaces;
--with  Fifo_Po;
package Intermediate_Z_Types is
 type Node_ID         is mod 2 ** 8;
      type Parameter_Index is mod 2 ** 8;
      type Parameter_Value is new Interfaces.Integer_32;


    type Z_Command_Record is record
      Node       :  Node_ID;
      Index      :  Parameter_Index;
      Value      :  Parameter_Value;
      Num_Bytes  :  Natural := 2;
    end Record;




end Intermediate_Z_Types;
