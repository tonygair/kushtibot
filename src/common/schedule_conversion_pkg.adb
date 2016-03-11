with Gnoga;
with Ada;
with Ada.Exceptions;
with Ada.Calendar; use Ada.Calendar;


package body Schedule_Conversion_Pkg is


   use It;
   use Gse;


    function Web_Day_To_Pi_Day ( The_Day : in It.Weekday_Type)
                                return Gse.Week_Day is

      Return_Value : Gse.Week_Day;
   begin
      case The_Day is
         when It.Monday =>
            Return_Value := Gse.Mo;
         when It.Tuesday =>
            Return_Value := Gse.Tu;
         when It.Wednesday =>
            Return_Value := Gse.We;
         When It.Thursday =>
            Return_Value := Gse.Th;
         When It.Friday =>
            Return_Value := Gse.Fr;
         When It.Saturday =>
            Return_Value := Gse.Sa;
         When It.Sunday =>
            Return_Value := Gse.Su;
      end case;
      Return Return_Value;
        exception
         when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
     return Gse.Mo;
   end Web_Day_To_Pi_Day;



      function Switch_Type ( Mode : in It.Energy_Mode_Type) return It.Energy_Mode_Type is
         Return_Value : It.Energy_Mode_Type;
      begin
           if Mode = It.Comfort_Mode then
            Return_Value := It.Economy_Mode;
         else
            Return_Value := It.Comfort_Mode;
         end if;
         return Return_Value;
      end Switch_Type;

   function Web_To_Pi_Schedule
           (Temperatures : in It.Mode_Temperature_Type;
            Schedule : in It.Day_Schedule_Type)
            return Gse.Day_Schedule is
      Loop_Points : Gse.Point_Count:= Gse.Point_Count(Schedule'Length)  ;

      Type_Of_Point : It.Energy_Mode_Type := Comfort_Mode;
         Return_Value : Gse.Day_Schedule (Loop_Points + 1);
         Index : Gse.Point_Count := 1;
      Blank_Return_Value : Gse.Day_Schedule(1) :=(1,(others =>  (0.0,0.0)));

   begin
         if Schedule(Schedule'first) > Hour_Day_Schedule_Type'first then
            Return_Value.Points (Index) :=
              (Last => (Day_Duration(Schedule(Schedule'first)) * 3600.0 -1.0),
               Point => Centigrade(Temperatures(It.Economy_Mode)));
            Index := Index + 1;

         end if;
         if Loop_Points > 1 then
            for count in 2..Loop_Points loop
               Return_Value.Points (Index) :=
              (Last => (Day_Duration(Schedule(count)) * 3600.0 -1.0),
               Point => Centigrade(Temperatures(Type_Of_Point)));
               Type_Of_Point := Switch_Type(Mode => Type_Of_Point);
               Index := Index + 1;
            end loop;
         end if;

         if Schedule(Schedule'last) < Hour_Day_Schedule_Type'last then
            Return_Value.Points (Index) :=
              (Last => Day_Duration'last,
               Point => Centigrade(Temperatures(It.Economy_Mode)));
         end if;
      if Index = Loop_Points + 1 then
         return Return_Value;
      else

         declare
            Adjusted_Return_Value : Gse.Day_Schedule(Index);
         begin
            Adjusted_Return_Value.Points := Return_Value.Points(1..Index);
            return Adjusted_Return_Value;
         end;
      end if;
   exception
      when E : others => Gnoga.log (Ada.Exceptions.Exception_Information (E));
         return Blank_Return_Value;
   end Web_To_Pi_Schedule;




end Schedule_Conversion_Pkg;
