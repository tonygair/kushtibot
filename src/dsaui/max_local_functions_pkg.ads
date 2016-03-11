with GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;
use GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;

package Max_Local_Functions_Pkg is




-- need to override this
-- incoming from box

 procedure Data_Received
             (  Client : in out ELV_MAX_Cube_Client;
                Data   : Device_Data
             );



protected type Cube_Parameters is




end Max_Local_Functions_Pkg;
