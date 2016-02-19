pragma Ada_95;
with System;
package ada_main is
   pragma Warnings (Off);

   gnat_argc : Integer;
   gnat_argv : System.Address;
   gnat_envp : System.Address;

   pragma Import (C, gnat_argc);
   pragma Import (C, gnat_argv);
   pragma Import (C, gnat_envp);

   gnat_exit_status : Integer;
   pragma Import (C, gnat_exit_status);

   GNAT_Version : constant String :=
                    "GNAT Version: GPL 2014 (20140331)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_kushtibot_main" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure adafinal;
   pragma Export (C, adafinal, "adafinal");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#f05c9b3a#;
   pragma Export (C, u00001, "kushtibot_mainB");
   u00002 : constant Version_32 := 16#fbff4c67#;
   pragma Export (C, u00002, "system__standard_libraryB");
   u00003 : constant Version_32 := 16#93c52800#;
   pragma Export (C, u00003, "system__standard_libraryS");
   u00004 : constant Version_32 := 16#3ffc8e18#;
   pragma Export (C, u00004, "adaS");
   u00005 : constant Version_32 := 16#65712768#;
   pragma Export (C, u00005, "ada__calendarB");
   u00006 : constant Version_32 := 16#e791e294#;
   pragma Export (C, u00006, "ada__calendarS");
   u00007 : constant Version_32 := 16#56fc860c#;
   pragma Export (C, u00007, "ada__exceptionsB");
   u00008 : constant Version_32 := 16#a5ccaeb2#;
   pragma Export (C, u00008, "ada__exceptionsS");
   u00009 : constant Version_32 := 16#032105bb#;
   pragma Export (C, u00009, "ada__exceptions__last_chance_handlerB");
   u00010 : constant Version_32 := 16#2b293877#;
   pragma Export (C, u00010, "ada__exceptions__last_chance_handlerS");
   u00011 : constant Version_32 := 16#90249111#;
   pragma Export (C, u00011, "systemS");
   u00012 : constant Version_32 := 16#daf76b33#;
   pragma Export (C, u00012, "system__soft_linksB");
   u00013 : constant Version_32 := 16#dafbf423#;
   pragma Export (C, u00013, "system__soft_linksS");
   u00014 : constant Version_32 := 16#c8ed38da#;
   pragma Export (C, u00014, "system__parametersB");
   u00015 : constant Version_32 := 16#96fe09a3#;
   pragma Export (C, u00015, "system__parametersS");
   u00016 : constant Version_32 := 16#c96bf39e#;
   pragma Export (C, u00016, "system__secondary_stackB");
   u00017 : constant Version_32 := 16#3b455e78#;
   pragma Export (C, u00017, "system__secondary_stackS");
   u00018 : constant Version_32 := 16#39a03df9#;
   pragma Export (C, u00018, "system__storage_elementsB");
   u00019 : constant Version_32 := 16#bde7db15#;
   pragma Export (C, u00019, "system__storage_elementsS");
   u00020 : constant Version_32 := 16#41837d1e#;
   pragma Export (C, u00020, "system__stack_checkingB");
   u00021 : constant Version_32 := 16#1e9bfaf9#;
   pragma Export (C, u00021, "system__stack_checkingS");
   u00022 : constant Version_32 := 16#393398c1#;
   pragma Export (C, u00022, "system__exception_tableB");
   u00023 : constant Version_32 := 16#3e3df704#;
   pragma Export (C, u00023, "system__exception_tableS");
   u00024 : constant Version_32 := 16#ce4af020#;
   pragma Export (C, u00024, "system__exceptionsB");
   u00025 : constant Version_32 := 16#f847fce7#;
   pragma Export (C, u00025, "system__exceptionsS");
   u00026 : constant Version_32 := 16#2652ec14#;
   pragma Export (C, u00026, "system__exceptions__machineS");
   u00027 : constant Version_32 := 16#b895431d#;
   pragma Export (C, u00027, "system__exceptions_debugB");
   u00028 : constant Version_32 := 16#23c688af#;
   pragma Export (C, u00028, "system__exceptions_debugS");
   u00029 : constant Version_32 := 16#570325c8#;
   pragma Export (C, u00029, "system__img_intB");
   u00030 : constant Version_32 := 16#92ff71d3#;
   pragma Export (C, u00030, "system__img_intS");
   u00031 : constant Version_32 := 16#ff5c7695#;
   pragma Export (C, u00031, "system__tracebackB");
   u00032 : constant Version_32 := 16#b8200e4c#;
   pragma Export (C, u00032, "system__tracebackS");
   u00033 : constant Version_32 := 16#8c33a517#;
   pragma Export (C, u00033, "system__wch_conB");
   u00034 : constant Version_32 := 16#8b59b3c3#;
   pragma Export (C, u00034, "system__wch_conS");
   u00035 : constant Version_32 := 16#9721e840#;
   pragma Export (C, u00035, "system__wch_stwB");
   u00036 : constant Version_32 := 16#a6489fc2#;
   pragma Export (C, u00036, "system__wch_stwS");
   u00037 : constant Version_32 := 16#9b29844d#;
   pragma Export (C, u00037, "system__wch_cnvB");
   u00038 : constant Version_32 := 16#84ee0930#;
   pragma Export (C, u00038, "system__wch_cnvS");
   u00039 : constant Version_32 := 16#69adb1b9#;
   pragma Export (C, u00039, "interfacesS");
   u00040 : constant Version_32 := 16#ece6fdb6#;
   pragma Export (C, u00040, "system__wch_jisB");
   u00041 : constant Version_32 := 16#049e1011#;
   pragma Export (C, u00041, "system__wch_jisS");
   u00042 : constant Version_32 := 16#8cb17bcd#;
   pragma Export (C, u00042, "system__traceback_entriesB");
   u00043 : constant Version_32 := 16#2535f183#;
   pragma Export (C, u00043, "system__traceback_entriesS");
   u00044 : constant Version_32 := 16#769e25e6#;
   pragma Export (C, u00044, "interfaces__cB");
   u00045 : constant Version_32 := 16#3b563890#;
   pragma Export (C, u00045, "interfaces__cS");
   u00046 : constant Version_32 := 16#22d03640#;
   pragma Export (C, u00046, "system__os_primitivesB");
   u00047 : constant Version_32 := 16#20f51d38#;
   pragma Export (C, u00047, "system__os_primitivesS");
   u00048 : constant Version_32 := 16#7bf4f215#;
   pragma Export (C, u00048, "ada__calendar__delaysB");
   u00049 : constant Version_32 := 16#474dd4b1#;
   pragma Export (C, u00049, "ada__calendar__delaysS");
   u00050 : constant Version_32 := 16#ee80728a#;
   pragma Export (C, u00050, "system__tracesB");
   u00051 : constant Version_32 := 16#6239f9bb#;
   pragma Export (C, u00051, "system__tracesS");
   u00052 : constant Version_32 := 16#034d7998#;
   pragma Export (C, u00052, "ada__tagsB");
   u00053 : constant Version_32 := 16#ce72c228#;
   pragma Export (C, u00053, "ada__tagsS");
   u00054 : constant Version_32 := 16#c3335bfd#;
   pragma Export (C, u00054, "system__htableB");
   u00055 : constant Version_32 := 16#14e622fb#;
   pragma Export (C, u00055, "system__htableS");
   u00056 : constant Version_32 := 16#089f5cd0#;
   pragma Export (C, u00056, "system__string_hashB");
   u00057 : constant Version_32 := 16#b6b84985#;
   pragma Export (C, u00057, "system__string_hashS");
   u00058 : constant Version_32 := 16#c12203be#;
   pragma Export (C, u00058, "system__unsigned_typesS");
   u00059 : constant Version_32 := 16#1e25d3f1#;
   pragma Export (C, u00059, "system__val_lluB");
   u00060 : constant Version_32 := 16#bbd054cc#;
   pragma Export (C, u00060, "system__val_lluS");
   u00061 : constant Version_32 := 16#27b600b2#;
   pragma Export (C, u00061, "system__val_utilB");
   u00062 : constant Version_32 := 16#3c8427ef#;
   pragma Export (C, u00062, "system__val_utilS");
   u00063 : constant Version_32 := 16#d1060688#;
   pragma Export (C, u00063, "system__case_utilB");
   u00064 : constant Version_32 := 16#b42df8c6#;
   pragma Export (C, u00064, "system__case_utilS");
   u00065 : constant Version_32 := 16#8db3bee1#;
   pragma Export (C, u00065, "gnogaB");
   u00066 : constant Version_32 := 16#1a9037e1#;
   pragma Export (C, u00066, "gnogaS");
   u00067 : constant Version_32 := 16#7a13e6d7#;
   pragma Export (C, u00067, "ada__calendar__formattingB");
   u00068 : constant Version_32 := 16#929f882b#;
   pragma Export (C, u00068, "ada__calendar__formattingS");
   u00069 : constant Version_32 := 16#e3cca715#;
   pragma Export (C, u00069, "ada__calendar__time_zonesB");
   u00070 : constant Version_32 := 16#98f012d7#;
   pragma Export (C, u00070, "ada__calendar__time_zonesS");
   u00071 : constant Version_32 := 16#f8f38c17#;
   pragma Export (C, u00071, "system__val_intB");
   u00072 : constant Version_32 := 16#d881bb2e#;
   pragma Export (C, u00072, "system__val_intS");
   u00073 : constant Version_32 := 16#4266b2a8#;
   pragma Export (C, u00073, "system__val_unsB");
   u00074 : constant Version_32 := 16#d18aee85#;
   pragma Export (C, u00074, "system__val_unsS");
   u00075 : constant Version_32 := 16#8ff77155#;
   pragma Export (C, u00075, "system__val_realB");
   u00076 : constant Version_32 := 16#6e0de600#;
   pragma Export (C, u00076, "system__val_realS");
   u00077 : constant Version_32 := 16#0be1b996#;
   pragma Export (C, u00077, "system__exn_llfB");
   u00078 : constant Version_32 := 16#11a08ffe#;
   pragma Export (C, u00078, "system__exn_llfS");
   u00079 : constant Version_32 := 16#1b28662b#;
   pragma Export (C, u00079, "system__float_controlB");
   u00080 : constant Version_32 := 16#70d8d22d#;
   pragma Export (C, u00080, "system__float_controlS");
   u00081 : constant Version_32 := 16#c054f766#;
   pragma Export (C, u00081, "system__powten_tableS");
   u00082 : constant Version_32 := 16#f64b89a4#;
   pragma Export (C, u00082, "ada__integer_text_ioB");
   u00083 : constant Version_32 := 16#f1daf268#;
   pragma Export (C, u00083, "ada__integer_text_ioS");
   u00084 : constant Version_32 := 16#1ac8b3b4#;
   pragma Export (C, u00084, "ada__text_ioB");
   u00085 : constant Version_32 := 16#7572d5cf#;
   pragma Export (C, u00085, "ada__text_ioS");
   u00086 : constant Version_32 := 16#1b5643e2#;
   pragma Export (C, u00086, "ada__streamsB");
   u00087 : constant Version_32 := 16#2564c958#;
   pragma Export (C, u00087, "ada__streamsS");
   u00088 : constant Version_32 := 16#db5c917c#;
   pragma Export (C, u00088, "ada__io_exceptionsS");
   u00089 : constant Version_32 := 16#9f23726e#;
   pragma Export (C, u00089, "interfaces__c_streamsB");
   u00090 : constant Version_32 := 16#bb1012c3#;
   pragma Export (C, u00090, "interfaces__c_streamsS");
   u00091 : constant Version_32 := 16#baff2c34#;
   pragma Export (C, u00091, "system__crtlS");
   u00092 : constant Version_32 := 16#967994fc#;
   pragma Export (C, u00092, "system__file_ioB");
   u00093 : constant Version_32 := 16#2cd47d17#;
   pragma Export (C, u00093, "system__file_ioS");
   u00094 : constant Version_32 := 16#b7ab275c#;
   pragma Export (C, u00094, "ada__finalizationB");
   u00095 : constant Version_32 := 16#19f764ca#;
   pragma Export (C, u00095, "ada__finalizationS");
   u00096 : constant Version_32 := 16#95817ed8#;
   pragma Export (C, u00096, "system__finalization_rootB");
   u00097 : constant Version_32 := 16#dfd6e281#;
   pragma Export (C, u00097, "system__finalization_rootS");
   u00098 : constant Version_32 := 16#d0432c8d#;
   pragma Export (C, u00098, "system__img_enum_newB");
   u00099 : constant Version_32 := 16#f16897d1#;
   pragma Export (C, u00099, "system__img_enum_newS");
   u00100 : constant Version_32 := 16#6db7d87c#;
   pragma Export (C, u00100, "system__os_libB");
   u00101 : constant Version_32 := 16#94c13856#;
   pragma Export (C, u00101, "system__os_libS");
   u00102 : constant Version_32 := 16#1a817b8e#;
   pragma Export (C, u00102, "system__stringsB");
   u00103 : constant Version_32 := 16#ee9b8077#;
   pragma Export (C, u00103, "system__stringsS");
   u00104 : constant Version_32 := 16#5f8330cf#;
   pragma Export (C, u00104, "system__file_control_blockS");
   u00105 : constant Version_32 := 16#a4371844#;
   pragma Export (C, u00105, "system__finalization_mastersB");
   u00106 : constant Version_32 := 16#e432b851#;
   pragma Export (C, u00106, "system__finalization_mastersS");
   u00107 : constant Version_32 := 16#57a37a42#;
   pragma Export (C, u00107, "system__address_imageB");
   u00108 : constant Version_32 := 16#31c80c2b#;
   pragma Export (C, u00108, "system__address_imageS");
   u00109 : constant Version_32 := 16#7268f812#;
   pragma Export (C, u00109, "system__img_boolB");
   u00110 : constant Version_32 := 16#65fde0fa#;
   pragma Export (C, u00110, "system__img_boolS");
   u00111 : constant Version_32 := 16#d7aac20c#;
   pragma Export (C, u00111, "system__ioB");
   u00112 : constant Version_32 := 16#0e66665e#;
   pragma Export (C, u00112, "system__ioS");
   u00113 : constant Version_32 := 16#6d4d969a#;
   pragma Export (C, u00113, "system__storage_poolsB");
   u00114 : constant Version_32 := 16#657f1695#;
   pragma Export (C, u00114, "system__storage_poolsS");
   u00115 : constant Version_32 := 16#e34550ca#;
   pragma Export (C, u00115, "system__pool_globalB");
   u00116 : constant Version_32 := 16#c88d2d16#;
   pragma Export (C, u00116, "system__pool_globalS");
   u00117 : constant Version_32 := 16#d6f619bb#;
   pragma Export (C, u00117, "system__memoryB");
   u00118 : constant Version_32 := 16#c959f725#;
   pragma Export (C, u00118, "system__memoryS");
   u00119 : constant Version_32 := 16#7b002481#;
   pragma Export (C, u00119, "system__storage_pools__subpoolsB");
   u00120 : constant Version_32 := 16#e3b008dc#;
   pragma Export (C, u00120, "system__storage_pools__subpoolsS");
   u00121 : constant Version_32 := 16#63f11652#;
   pragma Export (C, u00121, "system__storage_pools__subpools__finalizationB");
   u00122 : constant Version_32 := 16#fe2f4b3a#;
   pragma Export (C, u00122, "system__storage_pools__subpools__finalizationS");
   u00123 : constant Version_32 := 16#f6fdca1c#;
   pragma Export (C, u00123, "ada__text_io__integer_auxB");
   u00124 : constant Version_32 := 16#b9793d30#;
   pragma Export (C, u00124, "ada__text_io__integer_auxS");
   u00125 : constant Version_32 := 16#e0da2b08#;
   pragma Export (C, u00125, "ada__text_io__generic_auxB");
   u00126 : constant Version_32 := 16#a6c327d3#;
   pragma Export (C, u00126, "ada__text_io__generic_auxS");
   u00127 : constant Version_32 := 16#d48b4eeb#;
   pragma Export (C, u00127, "system__img_biuB");
   u00128 : constant Version_32 := 16#07008bf3#;
   pragma Export (C, u00128, "system__img_biuS");
   u00129 : constant Version_32 := 16#2b864520#;
   pragma Export (C, u00129, "system__img_llbB");
   u00130 : constant Version_32 := 16#46c79b0d#;
   pragma Export (C, u00130, "system__img_llbS");
   u00131 : constant Version_32 := 16#9777733a#;
   pragma Export (C, u00131, "system__img_lliB");
   u00132 : constant Version_32 := 16#816bc4c0#;
   pragma Export (C, u00132, "system__img_lliS");
   u00133 : constant Version_32 := 16#c2d63ebb#;
   pragma Export (C, u00133, "system__img_llwB");
   u00134 : constant Version_32 := 16#efabb89b#;
   pragma Export (C, u00134, "system__img_llwS");
   u00135 : constant Version_32 := 16#8ed53197#;
   pragma Export (C, u00135, "system__img_wiuB");
   u00136 : constant Version_32 := 16#69410c61#;
   pragma Export (C, u00136, "system__img_wiuS");
   u00137 : constant Version_32 := 16#e892b88e#;
   pragma Export (C, u00137, "system__val_lliB");
   u00138 : constant Version_32 := 16#0a0077b1#;
   pragma Export (C, u00138, "system__val_lliS");
   u00139 : constant Version_32 := 16#af50e98f#;
   pragma Export (C, u00139, "ada__stringsS");
   u00140 : constant Version_32 := 16#e5480ede#;
   pragma Export (C, u00140, "ada__strings__fixedB");
   u00141 : constant Version_32 := 16#a86b22b3#;
   pragma Export (C, u00141, "ada__strings__fixedS");
   u00142 : constant Version_32 := 16#e2ea8656#;
   pragma Export (C, u00142, "ada__strings__mapsB");
   u00143 : constant Version_32 := 16#1e526bec#;
   pragma Export (C, u00143, "ada__strings__mapsS");
   u00144 : constant Version_32 := 16#f8a2eef8#;
   pragma Export (C, u00144, "system__bit_opsB");
   u00145 : constant Version_32 := 16#0765e3a3#;
   pragma Export (C, u00145, "system__bit_opsS");
   u00146 : constant Version_32 := 16#12c24a43#;
   pragma Export (C, u00146, "ada__charactersS");
   u00147 : constant Version_32 := 16#4b7bb96a#;
   pragma Export (C, u00147, "ada__characters__latin_1S");
   u00148 : constant Version_32 := 16#0f7faa1b#;
   pragma Export (C, u00148, "ada__strings__searchB");
   u00149 : constant Version_32 := 16#c1ab8667#;
   pragma Export (C, u00149, "ada__strings__searchS");
   u00150 : constant Version_32 := 16#cd3494c7#;
   pragma Export (C, u00150, "ada__strings__utf_encodingB");
   u00151 : constant Version_32 := 16#b3a2089b#;
   pragma Export (C, u00151, "ada__strings__utf_encodingS");
   u00152 : constant Version_32 := 16#bb780f45#;
   pragma Export (C, u00152, "ada__strings__utf_encoding__stringsB");
   u00153 : constant Version_32 := 16#fe1d64b5#;
   pragma Export (C, u00153, "ada__strings__utf_encoding__stringsS");
   u00154 : constant Version_32 := 16#fd83e873#;
   pragma Export (C, u00154, "system__concat_2B");
   u00155 : constant Version_32 := 16#928446c1#;
   pragma Export (C, u00155, "system__concat_2S");
   u00156 : constant Version_32 := 16#2b70b149#;
   pragma Export (C, u00156, "system__concat_3B");
   u00157 : constant Version_32 := 16#9b54cdb4#;
   pragma Export (C, u00157, "system__concat_3S");
   u00158 : constant Version_32 := 16#261c554b#;
   pragma Export (C, u00158, "ada__strings__unboundedB");
   u00159 : constant Version_32 := 16#e303cf90#;
   pragma Export (C, u00159, "ada__strings__unboundedS");
   u00160 : constant Version_32 := 16#5b9edcc4#;
   pragma Export (C, u00160, "system__compare_array_unsigned_8B");
   u00161 : constant Version_32 := 16#3927e09c#;
   pragma Export (C, u00161, "system__compare_array_unsigned_8S");
   u00162 : constant Version_32 := 16#5f72f755#;
   pragma Export (C, u00162, "system__address_operationsB");
   u00163 : constant Version_32 := 16#83282f22#;
   pragma Export (C, u00163, "system__address_operationsS");
   u00164 : constant Version_32 := 16#afc64758#;
   pragma Export (C, u00164, "system__atomic_countersB");
   u00165 : constant Version_32 := 16#5d5805db#;
   pragma Export (C, u00165, "system__atomic_countersS");
   u00166 : constant Version_32 := 16#ffe20862#;
   pragma Export (C, u00166, "system__stream_attributesB");
   u00167 : constant Version_32 := 16#e5402c91#;
   pragma Export (C, u00167, "system__stream_attributesS");
   u00168 : constant Version_32 := 16#6736fd1c#;
   pragma Export (C, u00168, "open_zwaveB");
   u00169 : constant Version_32 := 16#bba884db#;
   pragma Export (C, u00169, "open_zwaveS");
   u00170 : constant Version_32 := 16#48973b17#;
   pragma Export (C, u00170, "interfaces__c__stringsB");
   u00171 : constant Version_32 := 16#603c1c44#;
   pragma Export (C, u00171, "interfaces__c__stringsS");
   u00172 : constant Version_32 := 16#d9bcd2ce#;
   pragma Export (C, u00172, "open_zwave_helper_functions_pkgB");
   u00173 : constant Version_32 := 16#992f41c3#;
   pragma Export (C, u00173, "open_zwave_helper_functions_pkgS");
   u00174 : constant Version_32 := 16#22ab03a2#;
   pragma Export (C, u00174, "system__img_unsB");
   u00175 : constant Version_32 := 16#5ed63f49#;
   pragma Export (C, u00175, "system__img_unsS");
   u00176 : constant Version_32 := 16#62148cec#;
   pragma Export (C, u00176, "system__tasking__protected_objectsB");
   u00177 : constant Version_32 := 16#6fa056d1#;
   pragma Export (C, u00177, "system__tasking__protected_objectsS");
   u00178 : constant Version_32 := 16#5e588602#;
   pragma Export (C, u00178, "system__soft_links__taskingB");
   u00179 : constant Version_32 := 16#e47ef8be#;
   pragma Export (C, u00179, "system__soft_links__taskingS");
   u00180 : constant Version_32 := 16#17d21067#;
   pragma Export (C, u00180, "ada__exceptions__is_null_occurrenceB");
   u00181 : constant Version_32 := 16#8b1b3b36#;
   pragma Export (C, u00181, "ada__exceptions__is_null_occurrenceS");
   u00182 : constant Version_32 := 16#78c10968#;
   pragma Export (C, u00182, "system__task_primitivesS");
   u00183 : constant Version_32 := 16#2c3ab68e#;
   pragma Export (C, u00183, "system__os_interfaceB");
   u00184 : constant Version_32 := 16#c4caea1f#;
   pragma Export (C, u00184, "system__os_interfaceS");
   u00185 : constant Version_32 := 16#2eda4e44#;
   pragma Export (C, u00185, "system__linuxS");
   u00186 : constant Version_32 := 16#7ecc359d#;
   pragma Export (C, u00186, "system__os_constantsS");
   u00187 : constant Version_32 := 16#f907f9ae#;
   pragma Export (C, u00187, "system__task_primitives__operationsB");
   u00188 : constant Version_32 := 16#cc6ffe4f#;
   pragma Export (C, u00188, "system__task_primitives__operationsS");
   u00189 : constant Version_32 := 16#903909a4#;
   pragma Export (C, u00189, "system__interrupt_managementB");
   u00190 : constant Version_32 := 16#7eac115d#;
   pragma Export (C, u00190, "system__interrupt_managementS");
   u00191 : constant Version_32 := 16#f65595cf#;
   pragma Export (C, u00191, "system__multiprocessorsB");
   u00192 : constant Version_32 := 16#a8880e62#;
   pragma Export (C, u00192, "system__multiprocessorsS");
   u00193 : constant Version_32 := 16#3c04b2bf#;
   pragma Export (C, u00193, "system__stack_checking__operationsB");
   u00194 : constant Version_32 := 16#64c2cb2b#;
   pragma Export (C, u00194, "system__stack_checking__operationsS");
   u00195 : constant Version_32 := 16#375a3ef7#;
   pragma Export (C, u00195, "system__task_infoB");
   u00196 : constant Version_32 := 16#46089c92#;
   pragma Export (C, u00196, "system__task_infoS");
   u00197 : constant Version_32 := 16#636d49d6#;
   pragma Export (C, u00197, "system__taskingB");
   u00198 : constant Version_32 := 16#be2bddc5#;
   pragma Export (C, u00198, "system__taskingS");
   u00199 : constant Version_32 := 16#4bc4ed76#;
   pragma Export (C, u00199, "system__stack_usageB");
   u00200 : constant Version_32 := 16#09222097#;
   pragma Export (C, u00200, "system__stack_usageS");
   u00201 : constant Version_32 := 16#5cf44d0b#;
   pragma Export (C, u00201, "system__tasking__debugB");
   u00202 : constant Version_32 := 16#e2cec1ea#;
   pragma Export (C, u00202, "system__tasking__debugS");
   u00203 : constant Version_32 := 16#a83b7c85#;
   pragma Export (C, u00203, "system__concat_6B");
   u00204 : constant Version_32 := 16#42e3bca3#;
   pragma Export (C, u00204, "system__concat_6S");
   u00205 : constant Version_32 := 16#608e2cd1#;
   pragma Export (C, u00205, "system__concat_5B");
   u00206 : constant Version_32 := 16#177ad23f#;
   pragma Export (C, u00206, "system__concat_5S");
   u00207 : constant Version_32 := 16#932a4690#;
   pragma Export (C, u00207, "system__concat_4B");
   u00208 : constant Version_32 := 16#ee40ba31#;
   pragma Export (C, u00208, "system__concat_4S");
   u00209 : constant Version_32 := 16#c2b9fd7a#;
   pragma Export (C, u00209, "fifoB");
   u00210 : constant Version_32 := 16#e0f5dc01#;
   pragma Export (C, u00210, "fifoS");
   u00211 : constant Version_32 := 16#5dbee6d7#;
   pragma Export (C, u00211, "tablesB");
   u00212 : constant Version_32 := 16#d2d5d447#;
   pragma Export (C, u00212, "tablesS");
   u00213 : constant Version_32 := 16#56e74f1a#;
   pragma Export (C, u00213, "system__img_realB");
   u00214 : constant Version_32 := 16#578cc0f3#;
   pragma Export (C, u00214, "system__img_realS");
   u00215 : constant Version_32 := 16#4f1f4f21#;
   pragma Export (C, u00215, "system__fat_llfS");
   u00216 : constant Version_32 := 16#3da6be5a#;
   pragma Export (C, u00216, "system__img_lluB");
   u00217 : constant Version_32 := 16#88eb037d#;
   pragma Export (C, u00217, "system__img_lluS");
   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  ada.characters%s
   --  ada.characters.latin_1%s
   --  interfaces%s
   --  system%s
   --  system.address_operations%s
   --  system.address_operations%b
   --  system.atomic_counters%s
   --  system.atomic_counters%b
   --  system.case_util%s
   --  system.case_util%b
   --  system.exn_llf%s
   --  system.exn_llf%b
   --  system.float_control%s
   --  system.float_control%b
   --  system.htable%s
   --  system.img_bool%s
   --  system.img_bool%b
   --  system.img_enum_new%s
   --  system.img_enum_new%b
   --  system.img_int%s
   --  system.img_int%b
   --  system.img_lli%s
   --  system.img_lli%b
   --  system.img_real%s
   --  system.io%s
   --  system.io%b
   --  system.linux%s
   --  system.multiprocessors%s
   --  system.os_primitives%s
   --  system.os_primitives%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  interfaces.c_streams%s
   --  interfaces.c_streams%b
   --  system.powten_table%s
   --  system.standard_library%s
   --  system.exceptions_debug%s
   --  system.exceptions_debug%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.stack_checking.operations%s
   --  system.stack_usage%s
   --  system.stack_usage%b
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%b
   --  system.strings%s
   --  system.strings%b
   --  system.os_lib%s
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  ada.exceptions%s
   --  ada.exceptions.is_null_occurrence%s
   --  ada.exceptions.is_null_occurrence%b
   --  system.soft_links%s
   --  system.stack_checking.operations%b
   --  system.traces%s
   --  system.traces%b
   --  system.unsigned_types%s
   --  system.fat_llf%s
   --  system.img_biu%s
   --  system.img_biu%b
   --  system.img_llb%s
   --  system.img_llb%b
   --  system.img_llu%s
   --  system.img_llu%b
   --  system.img_llw%s
   --  system.img_llw%b
   --  system.img_uns%s
   --  system.img_uns%b
   --  system.img_real%b
   --  system.img_wiu%s
   --  system.img_wiu%b
   --  system.val_int%s
   --  system.val_lli%s
   --  system.val_llu%s
   --  system.val_real%s
   --  system.val_uns%s
   --  system.val_util%s
   --  system.val_util%b
   --  system.val_uns%b
   --  system.val_real%b
   --  system.val_llu%b
   --  system.val_lli%b
   --  system.val_int%b
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_cnv%s
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%b
   --  system.wch_stw%s
   --  system.wch_stw%b
   --  ada.exceptions.last_chance_handler%s
   --  ada.exceptions.last_chance_handler%b
   --  system.address_image%s
   --  system.bit_ops%s
   --  system.bit_ops%b
   --  system.compare_array_unsigned_8%s
   --  system.compare_array_unsigned_8%b
   --  system.concat_2%s
   --  system.concat_2%b
   --  system.concat_3%s
   --  system.concat_3%b
   --  system.concat_4%s
   --  system.concat_4%b
   --  system.concat_5%s
   --  system.concat_5%b
   --  system.concat_6%s
   --  system.concat_6%b
   --  system.exception_table%s
   --  system.exception_table%b
   --  ada.io_exceptions%s
   --  ada.strings%s
   --  ada.strings.maps%s
   --  ada.strings.fixed%s
   --  ada.strings.search%s
   --  ada.strings.search%b
   --  ada.strings.utf_encoding%s
   --  ada.strings.utf_encoding.strings%s
   --  ada.tags%s
   --  ada.streams%s
   --  ada.streams%b
   --  interfaces.c%s
   --  system.multiprocessors%b
   --  interfaces.c.strings%s
   --  system.exceptions%s
   --  system.exceptions%b
   --  system.exceptions.machine%s
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  ada.finalization%s
   --  ada.finalization%b
   --  system.os_constants%s
   --  system.os_interface%s
   --  system.os_interface%b
   --  system.interrupt_management%s
   --  system.storage_pools%s
   --  system.storage_pools%b
   --  system.finalization_masters%s
   --  system.storage_pools.subpools%s
   --  system.storage_pools.subpools.finalization%s
   --  system.storage_pools.subpools.finalization%b
   --  system.stream_attributes%s
   --  system.stream_attributes%b
   --  system.task_info%s
   --  system.task_info%b
   --  system.task_primitives%s
   --  system.interrupt_management%b
   --  system.tasking%s
   --  system.task_primitives.operations%s
   --  system.tasking%b
   --  system.tasking.debug%s
   --  system.task_primitives.operations%b
   --  ada.calendar%s
   --  ada.calendar%b
   --  ada.calendar.delays%s
   --  ada.calendar.delays%b
   --  ada.calendar.time_zones%s
   --  ada.calendar.time_zones%b
   --  ada.calendar.formatting%s
   --  system.memory%s
   --  system.memory%b
   --  system.standard_library%b
   --  system.pool_global%s
   --  system.pool_global%b
   --  system.file_control_block%s
   --  system.file_io%s
   --  system.secondary_stack%s
   --  system.file_io%b
   --  system.tasking.debug%b
   --  system.storage_pools.subpools%b
   --  system.finalization_masters%b
   --  interfaces.c.strings%b
   --  interfaces.c%b
   --  ada.tags%b
   --  ada.strings.utf_encoding.strings%b
   --  ada.strings.utf_encoding%b
   --  ada.strings.fixed%b
   --  ada.strings.maps%b
   --  system.soft_links%b
   --  system.os_lib%b
   --  system.secondary_stack%b
   --  ada.calendar.formatting%b
   --  system.address_image%b
   --  ada.strings.unbounded%s
   --  ada.strings.unbounded%b
   --  system.soft_links.tasking%s
   --  system.soft_links.tasking%b
   --  system.traceback%s
   --  ada.exceptions%b
   --  system.traceback%b
   --  ada.text_io%s
   --  ada.text_io%b
   --  ada.text_io.generic_aux%s
   --  ada.text_io.generic_aux%b
   --  ada.text_io.integer_aux%s
   --  ada.text_io.integer_aux%b
   --  ada.integer_text_io%s
   --  ada.integer_text_io%b
   --  system.tasking.protected_objects%s
   --  system.tasking.protected_objects%b
   --  fifo%s
   --  fifo%b
   --  gnoga%s
   --  gnoga%b
   --  open_zwave%s
   --  open_zwave%b
   --  tables%s
   --  tables%b
   --  open_zwave_helper_functions_pkg%s
   --  open_zwave_helper_functions_pkg%b
   --  kushtibot_main%b
   --  END ELABORATION ORDER


end ada_main;
