with Ada.Exceptions.Traceback;

package Excep_Sym_Trace_Workaround is
   function Symbolic_Traceback
     (Traceback : Ada.Exceptions.Traceback.Tracebacks_Array)
      return      String;
   function Symbolic_Traceback
     (E    : Ada.Exceptions.Exception_Occurrence)
      return String;
end Excep_Sym_Trace_Workaround;
