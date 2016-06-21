

package Ui_Text_Pkg is

   pragma pure;

   -- Admin Screen
   Admin_Screen_Text : constant string := " Please choose an address to modify the heating schedule at. "
     & " Please be aware that once you press the address button you will be adjusting the heating " &
   " someones home" ;


   Legal_Warning_Text : constant string :=
     "You are currently at the heart of the control system of Warm and Smart, a progressive social " &
     " enterprise based in the UK. Ask yourself - are you authorised to be here? This could be a serious criminal act" &
     " but also have serious repercussions for vulnerable folk who do not deserve any malice, " &
     " if you are here accidentally, please email tony.gair@warmandsmart.com and let him know what happened" ;



   -- Room Screen

   Room_Instruction_Text : constant string :=
     " Press a room button to adjust the schedule " ;


end Ui_Text_Pkg;
