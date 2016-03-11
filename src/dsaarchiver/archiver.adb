with Archiver_Pkg;
with Gnoga;
procedure Archiver is

   Archive_Task : Archiver_Pkg.Archiver_Task_Type;
begin
   Gnoga.log("Starting");
   Archive_Task.Start_Archiving;
   Gnoga.log("Post archiver task start");

end Archiver;

