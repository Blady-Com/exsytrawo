# Exception Symbolic Traceback Workaround for macOS

[![Alire](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/exsytrawo.json)](https://alire.ada.dev/crates/exsytrawo.html)

GNAT symbolic traceback of Ada exceptions is not working on macOS
because macOS doesn't support ***addr2line***.
Hopefully, Xcode brings a similar tool: ***atos***.
This library calls ***atos*** with exception information and returns
the symbolic traceback.

## Usage

In your own [Alire](https://alire.ada.dev) project, add ***exsytrawo*** dependency:

`% alr with exsytrawo`

Then you can import the Ada ***exsytrawo*** package in your programs.

Your program must compile with ***-g*** switch, bind with ***-E*** switch
and link with ***-Wl,-no_pie*** switch.

You can use it like that:

```ada
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
```

or:

```ada
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
```

## Limitation

The library is configured only for ***x86_64*** architecture.

## Licence

All files are provided under terms of the [CeCILL-C](https://cecill.info) licence.

Pascal Pignard, February 2025.
