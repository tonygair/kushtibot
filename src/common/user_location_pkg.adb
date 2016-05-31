with Gnoga;


package body User_Location_Pkg is


   procedure Initialise is
      SIBC : Location_Record :=
        (Location_Id => 1,
         Description => To_Unbounded_String("S I B C"),
         Serial_No => To_Unbounded_String(""),
         Bookable => false,
         Port => 2221);
      Bobs_House : Location_Record :=
        (Location_Id => 2,
         Description => To_Unbounded_String("Bobs House"),
         Serial_No => To_Unbounded_String(""),
         Bookable => false,
          Port => 2222);


     Here : boolean;

   begin
      Location_Object.Add_Location(SIBC);
      Location_Object.Add_Location(Bobs_House);
      Here := Location_Object.IsIn(SIBC.Location_Id);
      Gnoga.log(To_String(SIBC.Description) & " Added ok ? " & Here'img);
      Here := Location_Object.IsIn(Bobs_House.Location_Id);
      Gnoga.log(To_String(Bobs_House.Description) & " Added ok ? " &Here'img);
   end Initialise;


      -- add the test locations
      -- this will come from a file in the future;


   protected body Location_Object is

      function IsIn
        (Location_Id : in Location_Id_Type)
         return boolean is

      begin
         return Location_Occupied(Location_Id);
      end IsIn;


      Function Get_Location_Record
        (Location_Id : in Location_Id_Type)
         return Location_Record is


         Offset : Natural := Id_Table.Locate(Location_Id'img);

      begin
         if Offset > 0 then
            return Id_Table.GetTag(Offset);
         else
            raise Program_Error;
         end if;
      end Get_Location_Record;

      function Get_Location_Id_From_Name
        (Name : string)
         return Location_Id_Type is

         Offset : Natural := Name_Table.Locate(Name);

      begin
         if Offset >0 then
            return Name_Table.GetTag(Offset);
         else
            raise Program_Error;
         end if;
      end Get_Location_Id_From_Name;


      function Get_Location_Id_From_Serial
        (Serial : string)
        return Location_Id_Type is

         Offset : Natural := Serial_Table.Locate(Serial);

      begin
         if Offset >0 then
            return Name_Table.GetTag(Offset);
         else
            raise Program_Error;
         end if;
end Get_Location_Id_From_Serial;

      procedure Add_Location
        ( Location : in Location_Record) is

      begin
         if Location.Location_Id > 0 and
           Location.Description /= To_Unbounded_String("") and
           Location.Port > 0 then
            if (not Id_Table.IsIn(Location.Location_Id'img)) and
              (not Name_Table.Isin(To_String(Location.Description))) then

               Name_Table.Add(Name => To_String(Location.Description),
                              Data => Location.Location_Id);
               Id_Table.Add(Name => Location.Location_Id'img,
                            Data => Location);
               Location_Occupied (Location.Location_Id) := true;
            else
               Gnoga.log("Location already stored ");

            end if;
         else
            Gnoga.log("Crap Location_Record - yawn");

         end if;
      end Add_Location;


 procedure Add_Connected_Location
        (Serial_Number : in Unbounded_String) is
         Place_In : Location_Id_Type := 0;
      begin
         if not Serial_Table.IsIn(To_String(Serial_Number)) then
            -- search for an unoccupied location
            for count in Location_Occupied'first .. Location_Occupied'last loop
               if not Location_Occupied(count) then
                  Place_In := count;
                  exit;
               end if;
            end loop;
            if Place_In = 0 then
               Gnoga.log("We've run out of location_Id_Type");

               raise Program_Error;
            else

               declare
                  Location_Data : Location_Record :=
                    (Location_Id => Place_In,
                     Description => To_Unbounded_String("Describe the Location"),
                     Serial_No => Serial_Number,
                     Port => 0);
               begin
                  Id_Table.Add(Name => Place_In'img,
                               Data => Location_Data);
                  Serial_Table.Add(Name => To_String(Serial_Number),
                                   Data => Place_In );





               end;

            end if;
         else
            Gnoga.log ("Serial Number already used! WTF  ");
         end if;

      end Add_Connected_Location;



      procedure Modify_Location_Name
        ( Location_Name : in Unbounded_String := Blank_Ustring;
          Cube_Serial_Number : in Unbounded_String := Blank_Ustring;
         Success : out Boolean) is

         Serial_Table_Place : Natural := Serial_Table.Locate(Name => To_String(Cube_Serial_Number));
         Location_Id_Place : Natural := 0;
         Location_Data : Location_Record;
      begin
         if Serial_Table_Place > 0 then
            Location_Id_Place := Id_Table.Locate(Location_Id_Place'img);
         else
            Gnoga.log("Serial number not found");
            Success := false;
            if Location_Id_Place > 0 then
               Location_Data := Id_Table.GetTag(Offset => Location_Id_Place);
               Location_Data.Description := Location_Name;
               Id_Table.Replace(Offset => Location_Id_Place,
                                Data   => Location_Data);
               Success := true;
            else
               Gnoga.log("Location Id produced by serial number did not produce");
               Success := false;
            end if;
         end if;
      end Modify_Location_Name;




      function Get_Occupied_Locations
        return Location_Occupied_Array_Type is
      begin
         return Location_Occupied;
      end Get_Occupied_Locations;

     function Get_Authorised_Locations
        (Users_Access : in Access_Array_Type)
         return Location_Array_Type is
         Location_Array : Location_Array_Type
           (1..Users_Access'last);
         Location_Count : Natural := 0;
      begin
         -- first count the number of locations for the user
         for count in Users_Access'first..Users_Access'last loop
            if Users_Access(count) = None then
               null;
            else
               Location_Count := Location_Count + 1;
               Location_Array(Location_Count) :=
                 Get_Location_Record(Location_Id => Count);
               Gnoga.log(Count'img &
                           To_String(Location_Array(Location_Count).Description));
            end if;
         end loop;
         return Location_Array(1..Location_Count);

      end Get_Authorised_Locations;

       function Get_Location_Bookable
        (Location : in Location_Id_Type)
         return boolean;


   end Location_Object;


end User_Location_Pkg;
