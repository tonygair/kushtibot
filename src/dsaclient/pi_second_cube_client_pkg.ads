with Identity_Types_Pkg; use Identity_Types_Pkg;
package Pi_Second_Cube_Client_Pkg is



   Task type Pi_Comms_Thread is
      entry  Start_Thread(Location_Id : in Location_Id_Type;
                          Cube : in String) ;
   end Pi_Comms_Thread;

   type Pi_Access_Type is access Pi_Comms_Thread;

end Pi_Second_Cube_Client_Pkg;
