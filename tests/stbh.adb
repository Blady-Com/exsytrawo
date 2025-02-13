with GNAT.Exception_Traces;
with Excep_Sym_Trace_Workaround;
procedure STBH is
   procedure P1 is
   begin
      raise Constraint_Error;
   exception
      when others =>
         null;
   end P1;
   procedure P2 is
   begin
      P1;
      raise Storage_Error;
   end P2;
begin
   GNAT.Exception_Traces.Trace_On (GNAT.Exception_Traces.Every_Raise);
   GNAT.Exception_Traces.Set_Trace_Decorator
     (Excep_Sym_Trace_Workaround.Symbolic_Traceback'Access);
   P2;
end STBH;
