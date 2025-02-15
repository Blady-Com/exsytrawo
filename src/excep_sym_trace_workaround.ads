-------------------------------------------------------------------------------
-- NAME (spec)                  : excep_sym_trace_workaround.ads
-- AUTHOR                       : Pascal Pignard
-- ROLE                         : Exception Symbolic Traceback Workaround for macOS.
-- NOTES                        : Ada 2022
--
-- COPYRIGHT                    : (c) Pascal Pignard 2025
-- LICENCE                      : CeCILL-C (https://cecill.info)
-- CONTACT                      : http://blady.chez.com
-------------------------------------------------------------------------------

with Ada.Exceptions.Traceback;

package Excep_Sym_Trace_Workaround is

   function Symbolic_Traceback
     (Traceback : Ada.Exceptions.Traceback.Tracebacks_Array) return String;

   function Symbolic_Traceback
     (E : Ada.Exceptions.Exception_Occurrence) return String;

end Excep_Sym_Trace_Workaround;
