with Ada.Text_IO; use Ada.Text_IO;
--  with GNAT.Traceback.Symbolic; use GNAT.Traceback.Symbolic;
with Excep_Sym_Trace_Workaround; use Excep_Sym_Trace_Workaround;
procedure STBGA is
   procedure P1 is
   begin
      raise Constraint_Error;
   end P1;
   procedure P2 is
   begin
      P1;
   end P2;
begin
   P2;
exception
   when E : others =>
      Put_Line ("----------------------------");
      Put_Line (Symbolic_Traceback (E));
      Put_Line ("----------------------------");
end STBGA;
