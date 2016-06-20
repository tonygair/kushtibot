
with Identity_Types_Pkg;
with Gnat.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;
package Schedule_Conversion_Pkg is

package Gse renames  GNAT.Sockets.Connection_State_Machine.ELV_MAX_Cube_Client;

   package It renames Identity_Types_Pkg;


   function Web_Day_To_Pi_Day ( The_Day : in It.Weekday_Type)
                               return Gse.Week_Day;


   function Web_To_Pi_Schedule
     (Temperatures : in It.Mode_Temperature_Type;
            Schedule : in It.Day_Schedule_Type)
     return Gse.Day_Schedule;


end Schedule_Conversion_Pkg;
