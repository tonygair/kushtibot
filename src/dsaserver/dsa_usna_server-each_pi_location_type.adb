separate (Dsa_Usna_Server)
protected body Each_Pi_Location_Type is



   function Get_Location_Id return Location_Id_Type is
   begin
      return My_Location;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
      return 0;
   end Get_Location_Id;


   function Get_Serial_No return Serial_Type is
   begin
      return My_Cube_Serial;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
         return Blank_serial;

   end Get_Serial_No;



   procedure Initialise_Location
     (Serial_Number : in Serial_Type;
      Location_Id : in Location_Id_Type) is
   begin
      My_Cube_Serial := Serial_Number;
      My_Location := Location_Id;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));

   end Initialise_Location;




   procedure Submit_Room_data
     (Room_Data : in Room_Information_Record;
      New_Room : out Boolean)  is

   begin
      Gnoga.log("Room data has arrived for location  " & Room_Data.Location'img &
                  " room name is "  & Room_Data.Room_Name);
      New_Room := false;
      if Room_Array(Room_Data.Room) = null then
         New_Room := true;

      else
         if Room_Array (Room_Data.Room).Room_Name /= Room_Data.Room_Name then
            Gnoga.Log("Room name is changing " & My_Location'img & " changing from " &
                        Room_Array(Room_Data.Room).Room_Name & " To " & Room_Data.Room_Name);
         end if;

         Deallocate_RIR_Access(Room_Array(Room_Data.Room));
         New_Room := false;


      end if;
      -- archive

      Room_Array(Room_Data.Room) := new Room_Information_Record'(Room_Data);
      -- and update the database when ready
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));

   end Submit_Room_data;

   function Get_Room_Data (Room : in Room_Id_Type) return Room_Information_Record is
   begin
      if Room_Array(Room) = null then
         return Blank_RIR;
      else
         return Room_Array(Room).all;
      end if;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
         return Blank_RIR;

   end Get_Room_Data;



   function Get_Number_Of_Rooms return Room_Id_Type is
      begin
      return Number_Of_Rooms;

   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
         return 0;


   end Get_Number_Of_Rooms;

    procedure Set_Number_Of_Rooms
     (Rooms : Room_Id_Type) is
   begin
      Number_Of_Rooms := Rooms;
      if Room_Array /= null then
         Deallocate_Room_Array_Access(Room_Array);

         --Deallocate
      end if;

      Room_Array := new Room_Array_Type(1..Rooms);
   end Set_Number_Of_Rooms;



   procedure Modify_Day_Schedule
     (Room_Number : in Room_Id_Type;
      --The_Week : in Which_Week_Type;
      The_Day : in Weekday_Type;
      Schedule : in Day_Schedule_Type;
      Success : out boolean) is
      Archive : boolean := false;
   begin
      Success := false;
      if Weekly_Schedule(Room_Number)(The_Day) = null then
        Archive := true;
         --we cannot modify a single day from a non existant week

      else

            Archive := true;
            Success := true;
            Deallocate_Day_Schedule_Access( Weekly_Schedule(Room_Number)(The_Day));

      end if;
       Weekly_Schedule(Room_Number)(The_Day) :=
           new Day_Schedule_Type'(Schedule);
      if Archive then

         -- and archive!
         null; -- at moment
      end if;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));

   end Modify_Day_Schedule;

  procedure Modify_Room_Mode_Temperatures
        (Room_Number : in Room_ID_Type;
         The_Day : in Weekday_Type;
         Mode_Temperatures : in Mode_Temperature_Type) is
   begin
      Room_Mode_Temperatures (Room_Number):= Mode_Temperatures;
    exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
   end Modify_Room_Mode_Temperatures;


   Function Get_Room_Mode_Temperatures
     (Room_Number : in Room_Id_Type;
      The_Day : in Weekday_Type)
         return Mode_Temperature_Type is
   begin
      return Room_Mode_Temperatures(Room_Number);
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
         return Blank_Mode_Temperature;
   end Get_Room_Mode_Temperatures;



   function Fetch_Updated_Day_Schedule
     (Room_Number : in Room_Id_Type;
      --The_Week : in Which_Week_Type;
      The_Day : in Weekday_Type) return Day_Schedule_Type is
   begin
      if Weekly_Schedule(Room_Number) (The_Day)= null then
         raise Program_Error;
      else
         return Weekly_Schedule(Room_Number)(The_Day).all;
      end if;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
return Blank_Day_Schedule;
   end Fetch_Updated_Day_Schedule;

   procedure Deregister_Pi_Terminal  is
   begin
      if Pi_terminal /= null then
         Pi_Terminal := null;
      end if;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));

   end Deregister_Pi_terminal;


   procedure Register_Pi_Terminal
     (Terminal : Terminal_Access) is
      Incoming_Terminal_Null : boolean := (Terminal = null) ;
        Existing_Terminal_Null : boolean :=  (Pi_Terminal = null);
   begin
      Gnoga.log( "Registration from location id " & My_Location'img &
                   "Serial " & string(My_Cube_Serial) &
                   "incoming terminal null ? " &  Incoming_Terminal_Null'img  &
                "existing terminal null? " & Existing_Terminal_Null'img);
      if Pi_terminal = null then
         Pi_Terminal := Terminal;

      end if;

   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));

   end Register_Pi_terminal;

   function Get_Pi_Terminal return Terminal_Access is
   begin
      return Pi_Terminal;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
      return Null;
   end Get_Pi_Terminal;


   procedure Deregister_Ui_Terminal  is
   begin
      if Ui_terminal /= null then
         Ui_Terminal := null;
      end if;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));

   end Deregister_Ui_terminal;

   procedure Register_Ui_Terminal
     (Terminal : Terminal_Access) is
   begin
      if Ui_Terminal = null then
         Ui_Terminal := Terminal;
      end if;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));

   end Register_Ui_Terminal;


   function Get_Ui_Terminal return Terminal_Access is
   begin
      return Ui_Terminal;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
return Null;
   end Get_Ui_Terminal;


   procedure Push (Item : in TC_Change_Record) is
   begin
      Waiting_Command_Fifo.Push (List =>  Fifo_Q ,
                                 Item => Item);
      exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
   end Push;


   procedure Pop (Item : out TC_Change_Record) is
   begin
      Waiting_Command_Fifo.Pop (List =>  Fifo_Q ,
                                Item => Item);
      exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));

   end Pop;

   function Is_Empty return boolean is
   begin
      return Waiting_Command_Fifo.Is_Empty(List => FIfo_Q);
      exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
         return false;

   end Is_Empty;


   --     private
   --        My_Cube_Serial : Serial_Type := (others => ' ');
   --        My_Location : Location_Id_Type := 0;
   --        Device_Table : Device_Table_Pkg.Table;
   --          Room_Name_Array : Room_Name_Array_Type;
  --  Fifo : Waiting_Command_Fifo.Fifo_Type;
end Each_Pi_Location_Type;
