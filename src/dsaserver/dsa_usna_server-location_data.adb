separate(Dsa_Usna_Server)
protected body Location_Data is



   procedure  Register (Serial_Number: in Serial_Type;
                        Location_Id : out Location_Id_Type) is

      Place_Found : boolean := false;

   begin

      for count in Location_Id_Type'first + 1..Location_Id_Type'last loop
         if not Occupancy (Location_Id) then
            Location_Id := count;
            Occupancy (Location_Id) := true;
            Place_Found := true;
            if count > Max_Location then
               Max_Location := count;
            end if;

            exit;
         end if;
      end loop;

      if not Place_Found then
         Gnoga.Log("HAve over run location id's no more to be had " );
         raise Constraint_Error;

      end if;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));

   end Register;


   procedure Change_Description
     (Location_Id : in Location_Id_Type;
      Description : in string) is
      Archive : boolean := false;

   begin
      if Descriptions(Location_Id) = null then
         Archive := true;
      else
         if Descriptions(Location_Id).all /= Description then
            Archive:= true;
            Gnoga.Log(" Changing Description of location id " & Location_Id'img &
                        " from " & Descriptions(Location_Id).all & " to "
                      &  Description);
            Deallocate_String(Descriptions(Location_Id));
         end if;
      end if;
      if Archive then
         Descriptions(Location_Id) := new String'(Description);
         -- also archive to the database
      end if;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));

   end Change_Description;

   procedure Set_Occupancy ( Location_Id : in Location_Id_Type ;
                             State : in boolean) is
   begin
      Occupancy(Location_Id) := State;
      if State = true and then
        Location_Id > Max_Location then
               Max_Location := Location_Id;
      end if;


   end Set_Occupancy;

   function Location_Occupied (Location_Id : in Location_Id_Type)
                               return boolean is
   begin
      return Occupancy(Location_Id);
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
      return True;
   end Location_Occupied;
   function Get_Max_Location return Location_Id_Type is

   begin
      return Max_Location;
      exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
      return 0;
      end Get_Max_Location;



   function Get_Description (Location_Id : in Location_Id_Type)
                              return String is
   begin
      if Descriptions(Location_Id) = null then
         return "No Description input yet";
      else
         return Descriptions(Location_Id).all;
      end if;
   exception
      when E : others => Gnoga.Log (Ada.Exceptions.Exception_Information (E));
return "";
   end Get_Description;



   --        private
   --
   --           Occupancy : Location_Boolean_Array_Type := (others => false);
   --           Descriptions : Description_Array_Type := (others => null);
   --           Highest_Location_Id_Used : Location_Id_Type := 0;
   --





end Location_Data;
