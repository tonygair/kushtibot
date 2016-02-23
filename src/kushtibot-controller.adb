with Gnoga.Gui.Base;

with kushtibot.View;

package body kushtibot.Controller is

   procedure On_Click (Object : in out Gnoga.Gui.Base.Base_Type'Class);
   
   procedure On_Click (Object : in out Gnoga.Gui.Base.Base_Type'Class) is
      View : kushtibot.View.Default_View_Access := 
               kushtibot.View.Default_View_Access (Object.Parent);
   begin
      View.Label_Text.Put_Line ("Click");
   end On_Click;
   
   procedure Default
     (Main_Window : in out Gnoga.Gui.Window.Window_Type'Class;
      Connection  : access
        Gnoga.Application.Multi_Connect.Connection_Holder_Type)
   is
      View : kushtibot.View.Default_View_Access :=
               new kushtibot.View.Default_View_Type;
   begin
      View.Dynamic;
      View.Create (Main_Window);
      View.Click_Button.On_Click_Handler (On_Click'Access);
   end Default;

begin
   Gnoga.Application.Multi_Connect.On_Connect_Handler
     (Default'Access, "default");   
end kushtibot.Controller;
