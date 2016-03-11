
with Ada.Unchecked_Deallocation;
with Identity_Types_Pkg;
with UI_Related_Access_Types_Pkg;
package Deallocate_And_Access_Types_Pkg is




   --     procedure Deallocate_Device is new Ada.Unchecked_Deallocation
   --       (Object => Device_Parameters,
   --        Name => Device_Parameter_Access);

   procedure Deallocate_RIR_Access is new Ada.Unchecked_Deallocation
     (Object => Identity_Types_Pkg.Room_Information_Record,
      Name => UI_Related_Access_Types_Pkg.RIR_Access);

   procedure Deallocate_Room_Buttons_Access is new Ada.Unchecked_Deallocation
     (Object => UI_Related_Access_Types_Pkg.Room_Button_Array_Type,
      Name => UI_Related_Access_Types_Pkg.Room_Button_Array_Access);




   procedure Deallocate_String is new Ada.Unchecked_Deallocation
     (Object => String,
      Name => UI_Related_Access_Types_Pkg.String_Access_Type);

   procedure Deallocate_Room_Array_Access is new Ada.Unchecked_Deallocation
     (Object => UI_Related_Access_Types_Pkg.Room_Array_Type,
      Name => UI_Related_Access_Types_Pkg.Room_Array_Access);


   procedure Deallocate_Day_Schedule_Access is new Ada.Unchecked_Deallocation
     (Object => Identity_Types_Pkg.Day_Schedule_Type,
      Name => UI_Related_Access_Types_Pkg.Day_Schedule_Access);

end Deallocate_And_Access_Types_Pkg;
