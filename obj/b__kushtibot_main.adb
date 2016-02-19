pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__kushtibot_main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__kushtibot_main.adb");
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E101 : Short_Integer; pragma Import (Ada, E101, "system__os_lib_E");
   E013 : Short_Integer; pragma Import (Ada, E013, "system__soft_links_E");
   E215 : Short_Integer; pragma Import (Ada, E215, "system__fat_llf_E");
   E023 : Short_Integer; pragma Import (Ada, E023, "system__exception_table_E");
   E088 : Short_Integer; pragma Import (Ada, E088, "ada__io_exceptions_E");
   E139 : Short_Integer; pragma Import (Ada, E139, "ada__strings_E");
   E143 : Short_Integer; pragma Import (Ada, E143, "ada__strings__maps_E");
   E151 : Short_Integer; pragma Import (Ada, E151, "ada__strings__utf_encoding_E");
   E053 : Short_Integer; pragma Import (Ada, E053, "ada__tags_E");
   E087 : Short_Integer; pragma Import (Ada, E087, "ada__streams_E");
   E045 : Short_Integer; pragma Import (Ada, E045, "interfaces__c_E");
   E171 : Short_Integer; pragma Import (Ada, E171, "interfaces__c__strings_E");
   E025 : Short_Integer; pragma Import (Ada, E025, "system__exceptions_E");
   E097 : Short_Integer; pragma Import (Ada, E097, "system__finalization_root_E");
   E095 : Short_Integer; pragma Import (Ada, E095, "ada__finalization_E");
   E114 : Short_Integer; pragma Import (Ada, E114, "system__storage_pools_E");
   E106 : Short_Integer; pragma Import (Ada, E106, "system__finalization_masters_E");
   E120 : Short_Integer; pragma Import (Ada, E120, "system__storage_pools__subpools_E");
   E196 : Short_Integer; pragma Import (Ada, E196, "system__task_info_E");
   E006 : Short_Integer; pragma Import (Ada, E006, "ada__calendar_E");
   E049 : Short_Integer; pragma Import (Ada, E049, "ada__calendar__delays_E");
   E070 : Short_Integer; pragma Import (Ada, E070, "ada__calendar__time_zones_E");
   E116 : Short_Integer; pragma Import (Ada, E116, "system__pool_global_E");
   E104 : Short_Integer; pragma Import (Ada, E104, "system__file_control_block_E");
   E093 : Short_Integer; pragma Import (Ada, E093, "system__file_io_E");
   E017 : Short_Integer; pragma Import (Ada, E017, "system__secondary_stack_E");
   E159 : Short_Integer; pragma Import (Ada, E159, "ada__strings__unbounded_E");
   E085 : Short_Integer; pragma Import (Ada, E085, "ada__text_io_E");
   E177 : Short_Integer; pragma Import (Ada, E177, "system__tasking__protected_objects_E");
   E210 : Short_Integer; pragma Import (Ada, E210, "fifo_E");
   E066 : Short_Integer; pragma Import (Ada, E066, "gnoga_E");
   E169 : Short_Integer; pragma Import (Ada, E169, "open_zwave_E");
   E212 : Short_Integer; pragma Import (Ada, E212, "tables_E");
   E173 : Short_Integer; pragma Import (Ada, E173, "open_zwave_helper_functions_pkg_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E173 := E173 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "open_zwave_helper_functions_pkg__finalize_spec");
      begin
         F1;
      end;
      E085 := E085 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "ada__text_io__finalize_spec");
      begin
         F2;
      end;
      E159 := E159 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "ada__strings__unbounded__finalize_spec");
      begin
         F3;
      end;
      E106 := E106 - 1;
      E120 := E120 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "system__file_io__finalize_body");
      begin
         E093 := E093 - 1;
         F4;
      end;
      declare
         procedure F5;
         pragma Import (Ada, F5, "system__file_control_block__finalize_spec");
      begin
         E104 := E104 - 1;
         F5;
      end;
      E116 := E116 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "system__pool_global__finalize_spec");
      begin
         F6;
      end;
      declare
         procedure F7;
         pragma Import (Ada, F7, "system__storage_pools__subpools__finalize_spec");
      begin
         F7;
      end;
      declare
         procedure F8;
         pragma Import (Ada, F8, "system__finalization_masters__finalize_spec");
      begin
         F8;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");
   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");

      procedure Install_Handler;
      pragma Import (C, Install_Handler, "__gnat_install_handler");

      Handler_Installed : Integer;
      pragma Import (C, Handler_Installed, "__gnat_handler_installed");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      if Handler_Installed = 0 then
         Install_Handler;
      end if;

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Fat_Llf'Elab_Spec;
      E215 := E215 + 1;
      System.Exception_Table'Elab_Body;
      E023 := E023 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E088 := E088 + 1;
      Ada.Strings'Elab_Spec;
      E139 := E139 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Utf_Encoding'Elab_Spec;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E087 := E087 + 1;
      Interfaces.C'Elab_Spec;
      Interfaces.C.Strings'Elab_Spec;
      System.Exceptions'Elab_Spec;
      E025 := E025 + 1;
      System.Finalization_Root'Elab_Spec;
      E097 := E097 + 1;
      Ada.Finalization'Elab_Spec;
      E095 := E095 + 1;
      System.Storage_Pools'Elab_Spec;
      E114 := E114 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Storage_Pools.Subpools'Elab_Spec;
      System.Task_Info'Elab_Spec;
      E196 := E196 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E006 := E006 + 1;
      Ada.Calendar.Delays'Elab_Body;
      E049 := E049 + 1;
      Ada.Calendar.Time_Zones'Elab_Spec;
      E070 := E070 + 1;
      System.Pool_Global'Elab_Spec;
      E116 := E116 + 1;
      System.File_Control_Block'Elab_Spec;
      E104 := E104 + 1;
      System.File_Io'Elab_Body;
      E093 := E093 + 1;
      E120 := E120 + 1;
      System.Finalization_Masters'Elab_Body;
      E106 := E106 + 1;
      E171 := E171 + 1;
      E045 := E045 + 1;
      Ada.Tags'Elab_Body;
      E053 := E053 + 1;
      E151 := E151 + 1;
      E143 := E143 + 1;
      System.Soft_Links'Elab_Body;
      E013 := E013 + 1;
      System.Os_Lib'Elab_Body;
      E101 := E101 + 1;
      System.Secondary_Stack'Elab_Body;
      E017 := E017 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E159 := E159 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E085 := E085 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E177 := E177 + 1;
      E210 := E210 + 1;
      E066 := E066 + 1;
      E169 := E169 + 1;
      E212 := E212 + 1;
      Open_Zwave_Helper_Functions_Pkg'Elab_Spec;
      Open_Zwave_Helper_Functions_Pkg'Elab_Body;
      E173 := E173 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_kushtibot_main");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /home/tony/opensource/kushtibot/obj/fifo.o
   --   /home/tony/opensource/gnoga/deps/simple_components/tables.o
   --   /home/tony/opensource/kushtibot/obj/open_zwave_helper_functions_pkg.o
   --   /home/tony/opensource/kushtibot/obj/kushtibot_main.o
   --   -L/home/tony/opensource/kushtibot/obj/
   --   -L/home/tony/opensource/kushtibot/obj/
   --   -L/home/tony/opensource/gnoga/lib/
   --   -L/home/tony/opensource/gnoga/
   --   -L/home/tony/opensource/gnoga/deps/simple_components/
   --   -L/home/tony/opensource/gnoga/deps/simple_components/xpm/
   --   -L/home/tony/opensource/ada_open_zwave/lib/
   --   -L/home/tony/opensource/ada_open_zwave/openzwave-1.4.1/
   --   -L/home/tony/ada/gnat/lib/gcc/x86_64-pc-linux-gnu/4.7.4/adalib/
   --   -static
   --   -lgnarl
   --   -lgnat
   --   -lpthread
--  END Object file/option list   

end ada_main;
