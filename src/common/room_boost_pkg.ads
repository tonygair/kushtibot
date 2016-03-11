with Identity_Types_Pkg; use Identity_Types_Pkg;
with User_And_Location_Types_Pkg; use User_And_Location_Types_Pkg;
with Device_Type_Pkg; use Device_Type_Pkg;
package Room_Boost_Pkg is

   Maximum_Boost_Duration : Duration := 14400.1;  -- max duration of four hours

   Minimum_Boost_Duration : Duration := 1199.0; -- just below 20 minnutes



   type Direction_Type is (Warmer, Colder);


   -- future improvements will include some sort of timer which will act and send a message
   -- a certain amount of inactivity from the UI (to avoid lots of messages being sent!

   procedure Apply_Boost
     ( Location_Id : in Location_Id_Type;
       Room_Id : in Room_Id_Type;
       Direction : in Direction_Type;
       Success : out boolean);



   function Get_Current_Temperature_Boost

     (Location_Id : in Location_Id_Type;
      Room_Id : in Room_Id_Type ) return Temp_Xten_Type;

   function Get_Boost_Screen_Status
     (Location_Id : in Location_Id_Type;
      Room_Id : in Room_Id_Type ) return string;

 --- these two setting of temp and time do not work on retrospective timers already set
   procedure Set_Boost_Amount
     ( Location_Id : in Location_Id_Type;
       Amount : in Temp_Xten_Type ;
       Success : out boolean);


   procedure Set_Boost_Time
     (Location_Id : in Location_Id_Type;
      Boost_Time : in Duration;
      Success : out boolean);


end Room_Boost_Pkg;
