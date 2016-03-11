

package body OZW_Binding_Pkg is

type Manager_Object is access all Integer;

function Create return Manager_Object;
      pragma Import (C, Create, "_ZN9OpenZWave7Manager6CreateEv");

 function GetSendQueueCount (this : Manager_Object; u_homeId : Defs_h.uint32) return Defs_h.int32;
      pragma Import (C, GetSendQueueCount, "_ZN9OpenZWave7Manager17GetSendQueueCountEj");


procedure WriteConfig (this : access Manager'Class; u_homeId : Defs_h.uint32);  -- Manager.h:194
      pragma Import (C, WriteConfig, "_ZN9OpenZWave7Manager11WriteConfigEj");




    function AddDriver
        (this : access Manager'Class;
         u_controllerPath : access string;
         u_interface : access Driver_h.ControllerInterface) return Extensions.bool;  -- Manager.h:227
      pragma Import (CPP, AddDriver, "_ZN9OpenZWave7Manager9AddDriverERKSsRKNS_6Driver19ControllerInterfaceE");



end OZW_Binding_Pkg;
