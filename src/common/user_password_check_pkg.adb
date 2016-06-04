with Tables;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Gnoga;
with Dsa_Usna_Server;
with Ada.Exceptions;
package body User_Password_Check_Pkg is


   protected body User_Check_Object is

      function IsIn (User : in String) return boolean is

      begin
         return Users.IsIn(Name => User);
      exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
      return false;
      end IsIn;



      -- returns the port number for a user if the password is correct
      function Check_User_Password (User , Password : in string)
                                    return Serial_Type is

         Offset : Natural := Users.Locate(Name => User);
         Return_Value : Serial_Type;
         User_Data : User_Record;
      begin
         Gnoga.log("**"&User&"**");
         If Offset > 0 then
            -- the user was found -- hooray!
            User_Data := Users.GetTag(Offset);
            if Password = To_String(User_Data.Password) then
               Return_Value := User_Data.Serial_Number;
               gnoga.log("password ok, serial is " & string(User_Data.Serial_Number));
            else
               Return_Value := Bad_Password_Serial;
               gnoga.log("bad password");

            end if;
         else
            Return_Value := Bad_Password_Serial;
         end if;
         return Return_Value;
      exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
            return Blank_Serial;

      end Check_User_Password;

      function Get_Serial_From_User (User : in String)
                                     return Serial_Type is

         Offset : Natural := Users.Locate(Name => User);
         Return_Value : Serial_Type;
         User_Data : User_Record;
      begin
         If Offset > 0 then
            -- the user was found -- hooray!
            User_Data := Users.GetTag(Offset);

            Return_Value := User_Data.Serial_Number;
         else

            Return_Value := Bad_Password_Serial;
         end if;
         return Return_Value;

      end Get_Serial_From_User;



      procedure User_Admin_Setting
        (User : in string;
         Admin : in boolean) is
         Store_Record : User_Record:= (User => To_Unbounded_String(User),
                                       Password => To_Unbounded_String(""),
                                       Serial_Number => Blank_Serial);
      begin
         if Admin and not User_Admin.IsIn(User) then
            User_Admin.Add(Name => User,
                           Data => Store_Record);
         elsif not Admin and User_Admin.IsIn(User) then
            User_Admin.Delete(Name => User);
         end if;
      exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

      end User_Admin_Setting;


      function Is_User_An_Admin
        (User : in  String) return boolean is
      begin
         return User_Admin.IsIn(Name => User);
      end Is_User_An_Admin;



      procedure Add_User (User , Password : in string;
                          Serial_Number : in Serial_Type := Blank_Serial;
                          Is_Admin : in boolean;
                          Success : out boolean) is
         Offset : Natural := Users.Locate(Name => User);
         Admin_Store_Record : User_Record:= (User => To_Unbounded_String(User),
                                             Password => To_Unbounded_String(""),
                                             Serial_Number => Blank_Serial);
         Store_Record : User_Record :=
           (User => To_Unbounded_String(User),
            Password => To_Unbounded_String(Password),
            Serial_Number => Serial_Number);
      begin
         if Offset > 0 then
            Success := false;
         else
            Users.Add(Name => User,
                      Data => Store_Record);
            Success := true;
            if Is_Admin then
               User_Admin.Add(Name => User,
                              Data => Admin_Store_Record);
            end if;

         end if;
      exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

      end Add_User;

      procedure Fetch_User (User : in String;
                            info : out User_Record;
                            Is_Admin : out boolean;
                            success : out boolean) is
         Offset : Natural := Users.Locate(Name => User);

      begin
         Is_Admin  := User_Admin.IsIn(Name => User);
         if offset > 0 then
            Success := true;
            Info := Users.GetTag(Offset => Offset);
         else
            Success := false;
         end if;
      exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

      end Fetch_User;


      procedure Change_Serial_Attached_To_User
        (User : in string;
         Serial_Number : in Serial_Type;
         Success : out boolean) is

         Offset : Natural := Users.locate(Name => User);
         Record_To_Be_Meddled : User_Record;
      begin
         if Offset  > 0 then
            Record_To_Be_Meddled := Users.GetTag (Offset);
            Record_To_Be_Meddled.Serial_Number := Serial_Number;
            Users.Replace(Offset => Offset,
                          Data   => Record_To_Be_Meddled);
            Success := true;
         else
            Success := false;
         end if;


      exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

      end Change_Serial_Attached_To_User;

   end User_Check_Object;

   procedure Add_Hardwired_Users is

      Bob_Add,
      Bob_Rights,
      Gair_Add,
      Abu_Rights,
      Non_Existant : boolean := false;

   begin
      User_Check_Object.Add_User(User     => "BobH",
                                 Password => "Triffid",
                                 Is_Admin => false,
                                 Success  => Bob_Add);
      User_Check_Object.Add_User(User => "Tony",
                                 Password => "Gair",
                                 Is_Admin => true,
                                 Success => Gair_Add);

      --    User_Check_Object.Add_User(User => "SyedaK",
      --                                   Password => "Mahian",
      --                                   Success => Abu_Add);
      --
      --        User_Check_Object.Add_User(User => "MartinB",
      --                                   Password => "Bicycle",
      --                                   Success => Abu_Add);

      User_Check_Object.Change_Serial_Attached_To_User
        (User        => "BobH",
         Serial_Number => "LEQ1324749",
         Success     => Bob_Rights);



      Gnoga.Log(" Bob user added " & Bob_Add'img &
                  User_Check_Object.Isin(User => "BobH")'img);
      Gnoga.log (" Community user added " & Gair_Add'img
                 & User_Check_Object.IsIn(User => "Tony")'img);

      -- check for non existant user
      Gnoga.Log ("Non Existant user added " & Non_Existant'img
                 & User_Check_Object.IsIn(User=> "Non_Existant")'img);
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Add_Hardwired_Users;


   -- normally initialise would use a file or database to
   -- load up values. At the moment we just load up some
   -- hardwired values ! Ha




   procedure Initialise is
   begin
      Add_Hardwired_Users;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));

   end Initialise;


end User_Password_Check_Pkg;
