package body  Bookings_Gnoga_Pkg is

   procedure Build_Bookings_View
     (App : in out App_Access) is

   begin
      if not App.Bookings_Record.Title_Label.Valid then
         App.Bookings_Record.Title_Label.Create
           (Parent  => App.Form_Array(Bookings_View),
            Content => "<H1> Under Construction <H1>");
      end if;

   end Build_Bookings_View;


   procedure Update_Bookings_View
     (App : in out App_Access) is
   begin
      Build_Bookings_View(App => App);

   end Update_Bookings_View;




end Bookings_Gnoga_Pkg;
