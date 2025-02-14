with System.Address_Image;
with Ada.Command_Line;
with Ada.Text_IO;
with Ada.Strings.Unbounded;
with GNAT.OS_Lib;
with Ada.Strings.Unbounded.Text_IO;

package body Excep_Sym_Trace_Workaround is

   function Exception_Information_Workaround
     (Address_List : Ada.Strings.Unbounded.Unbounded_String) return String
   is
      use type Ada.Strings.Unbounded.Unbounded_String;
      use type GNAT.OS_Lib.Argument_List;

      File     : Ada.Text_IO.File_Type;
      Exe      : constant String := Ada.Command_Line.Command_Name;
      Filename : constant String := Exe & "-exception.txt";
      Text     : Ada.Strings.Unbounded.Unbounded_String;
      Result   : Integer;
      Ok       : Boolean;
      Ind      : Natural;

      Args : GNAT.OS_Lib.Argument_List_Access :=
        GNAT.OS_Lib.Argument_String_To_List
          ("-o " & Ada.Command_Line.Command_Name & " -arch x86_64 " &
           Ada.Strings.Unbounded.To_String (Address_List));
   begin
      if GNAT.OS_Lib.Is_Executable_File (Exe) then
         Ada.Text_IO.Create (File, Ada.Text_IO.In_File, Filename);
         GNAT.OS_Lib.Spawn ("/usr/bin/atos", Args.all, Filename, Ok, Result);
         GNAT.OS_Lib.Free (Args);
         if Result = 0 then
            Ada.Text_IO.Reset (File);
            while not Ada.Text_IO.End_Of_File (File) loop
               Ada.Strings.Unbounded.Append
                 (Text,
                  Ada.Strings.Unbounded.Text_IO.Get_Line (File) & ASCII.LF);
            end loop;
            Ada.Text_IO.Close (File);
            Ind := Ada.Strings.Unbounded.Index (Text, "main");
            if Ind = 0 then
               Ada.Strings.Unbounded.Append
                 (Text,
                  "Location not found (possible missing of linker switch -Wl,-no_pie).");
            else
               if Ada.Strings.Unbounded.Index (Text, "+", Ind) > 0 then
                  Ada.Strings.Unbounded.Append
                    (Text,
                     "Source code line not found (possible missing of compiler switch -g).");
               end if;
            end if;
            return Ada.Strings.Unbounded.To_String (Text);
         else
            return Ada.Strings.Unbounded.To_String (Address_List);
         end if;
      else
         return
           "Executable '" & Exe &
           "' not found, probably called from JAVA context.";
      end if;
   end Exception_Information_Workaround;

   function Symbolic_Traceback
     (Traceback : Ada.Exceptions.Traceback.Tracebacks_Array) return String
   is
      Address_List : Ada.Strings.Unbounded.Unbounded_String;
   begin
      if Traceback'Length /= 0 then
         for Ind in Traceback'Range loop
            Ada.Strings.Unbounded.Append
              (Address_List, " 0x" & System.Address_Image (Traceback (Ind)));
         end loop;
         return Exception_Information_Workaround (Address_List);
      else
         return
           "No traceback (possible missing of binder switch -E to store tracebacks in exception occurrences).";
      end if;
   end Symbolic_Traceback;

   function Symbolic_Traceback
     (E : Ada.Exceptions.Exception_Occurrence) return String
   is
   begin
      return Symbolic_Traceback (Ada.Exceptions.Traceback.Tracebacks (E));
   end Symbolic_Traceback;

end Excep_Sym_Trace_Workaround;
