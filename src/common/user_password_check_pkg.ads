
with Tables;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
--with User_And_Location_Types_Pkg; use User_And_Location_Types_Pkg;
with Identity_Types_Pkg; use Identity_Types_Pkg;

package User_Password_Check_Pkg is

  Blank_Ustring : Unbounded_String := To_Unbounded_String("");


  type User_Record is record
      User : Unbounded_String := Blank_Ustring;
      Password : Unbounded_String := Blank_Ustring;
      --Location_Id : Location_Id_Type := 0;
      Serial_Number : Serial_Type:= Good_Password_No_Serial;

   end record;




   package User_Password_Table is new Tables(Tag => User_Record);


   protected User_Check_Object is
      function IsIn (User : in string ) return boolean;

      function Check_User_Password
        (User , Password : in string)
         return Serial_Type;

      function Get_Serial_From_User (User : in String)
                                     return Serial_Type;

      procedure User_Admin_Setting
        (User : in string;
         Admin : in boolean);

      function Is_User_An_Admin
        (User : in  String) return boolean;

      procedure Add_User
        (User , Password : in string;
         Serial_Number : in Serial_Type := Blank_Serial;
         Is_Admin : in boolean;
         Success : out boolean);

   procedure Fetch_User (User : in String;
                            info : out User_Record;
                            Is_Admin : out boolean;
                           success : out boolean) ;

      -- used to add or remove access dependent on
      -- User_Access_Type
      procedure Change_Serial_Attached_To_User
        (User : in string;
         Serial_Number : in Serial_Type;
         Success : out boolean);



   private
      Users, User_Admin : User_Password_Table.Table;

   end User_Check_Object;


   procedure Initialise;





end User_Password_Check_Pkg;
