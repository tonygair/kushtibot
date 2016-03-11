with Gnoga.Gui.Base;
with Gnoga.Gui.Window;
with Gnoga.Application.Multi_Connect;
with Usna_App_Data_Pkg;
Package   View_Change_Pkg is







 procedure New_Content_View
     (App : in out Usna_App_Data_Pkg.App_Access);


procedure On_Connect_App
     (Main_Window : in out Gnoga.Gui.Window.Window_Type'Class;
      Connection  : access Gnoga.Application.Multi_Connect.Connection_Holder_Type) ;



end View_Change_Pkg;
