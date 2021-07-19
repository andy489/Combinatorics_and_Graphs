 Program Kings1;

 Type
   vododel = 0..4;
   vododel_array = array[1..4] of vododel;

 function check(const r,c: vododel_array): boolean;
 var i,j: 1..3;
 begin
   check := false;
   for i := 1 to 3 do
   for j := 1 to 3 do begin
     if  ((j-r[i]) * (j-r[i+1]) < 0)
     and ((i-c[j]) * (i-c[j+1]) < 0)
     and ((r[i+1]-r[i]) * (c[j+1]-c[j]) > 0)
     then Exit
   end;
   check := true
 end;

 Procedure PrintConfig(const r,c: vododel_array);
 Var i: 1..4;
 Begin
   for i := 1 to 4 do write(r[i]);
   for i := 1 to 4 do write(c[i]);
   writeln
 End;

 VAR  r, c: vododel_array;
      cnt: longint;

 BEGIN
   writeln;
   writeln;
   cnt := 0;
   for r[1] := 0 to 4 do
   for r[2] := 0 to 4 do
   for r[3] := 0 to 4 do
   for r[4] := 0 to 4 do
   for c[1] := 0 to 4 do
   for c[2] := 0 to 4 do
   for c[3] := 0 to 4 do
   for c[4] := 0 to 4 do
     if Check(r,c) then begin
       PrintConfig(r,c);
       inc(cnt)
     end;
   writeln;
   writeln;
   writeln('Count = ', cnt);
   writeln
 END.