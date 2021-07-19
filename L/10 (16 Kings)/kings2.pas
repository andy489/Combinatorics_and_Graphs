 Program Kings2;

 Const
   PossibleColumns: array[1..8, 1..55] of Byte = (
     (0,1,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0),
     (0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1),
     (0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1,1,0,0),
     (0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,1,0,0,0,1,1,1,0,0,0,0,0,0,1,0,0,0,1,1),
     (0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,1,1,0,1,0,0,0,0,0,0,1,1,0,0,0,0,1,1,0,1,1,0,0,1,1,0,0,0),
     (0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,1,0,0,0,0,1,0,1,0,0,1,0,0,0,0,1,1,0,0,0,0,1,0,0,1,1,0,0,1,1,1),
     (0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,1,0,1,0,0,0,0,1,0,0,1,0,1,0,0,0,1,0,1,0,0,1,0,0,0,1,0,0,0,0),
     (0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,1,0,0,0,1,0,0,1,0,1,1,0,0,0,1,0,0,1,0,1,1,0,0,1,0,1,1,0,1,1,1,0,1,1,1,1)
   );

 Var { Const }
   cnt: array[1..55] of 0..4;  { count of 1s in each column }
   Adj: array[1..55, 1..55] of 1..55; { graph of compatible columns }
   Deg: array[1..55] of 0..55; { degrees of graph vertices }

 Procedure InitCnt;
 Var k: 1..55; i: 1..8;
 Begin
   for k := 1 to 55 do begin
     cnt[k] := 0;
     for i := 1 to 8 do
       if PossibleColumns[i,k] > 0
       then Inc(cnt[k])
   end
 End;

 Procedure AddToGraph(k1,k2: Byte);
 Begin
   Inc(Deg[k1]);
   Adj[k1,Deg[k1]] := k2
 End;

 Function CompatibleColumns(k1,k2: Byte): Boolean;
 Var i: 2..7;
 Begin
   CompatibleColumns := False;
   if PossibleColumns[1,k1] > 0 then begin
     if PossibleColumns[2,k2] > 0 then Exit;
     if PossibleColumns[1,k2] > 0 then Exit
   end;
   if PossibleColumns[8,k1] > 0 then begin
     if PossibleColumns[7,k2] > 0 then Exit;
     if PossibleColumns[8,k2] > 0 then Exit
   end;
   for i := 2 to 7 do begin
     if PossibleColumns[i,k1] > 0 then begin
       if PossibleColumns[Pred(i),k2] > 0 then Exit;
       if PossibleColumns[Succ(i),k2] > 0 then Exit;
       if PossibleColumns[     i ,k2] > 0 then Exit
     end
   end;
   CompatibleColumns := True
 End;

 Procedure InitGraph;
 Var k1, k2: 1..55;
 Begin
   for k1 := 1 to 55 do
     Deg[k1] := 0;
   AddToGraph(1,1);
   for k1 := 1 to 54 do
     for k2 := Succ(k1) to 55 do
       if CompatibleColumns(k1,k2) then begin
         AddToGraph(k1,k2);
         AddToGraph(k2,k1)
       end
 End;

 Procedure Init;
 Begin
   InitCnt;
   InitGraph
 End;

 Var
   dyn: array[0..8,0..16,1..55] of Longint;

 Procedure DynProg;
 Var
   i: 1..8;
   j: 0..16;
   k, k2, ind: 1..55;
   cnt2: 0..4;
 Begin
   FillChar(dyn, SizeOf(dyn), #0);
   for k := 1 to 55 do
     dyn[0][0][k] := 1;
   for i := 1 to 8 do begin
     for k := 1 to 55 do begin
       for ind := 1 to Deg[k] do begin
         k2 := Adj[k,ind];
         cnt2 := cnt[k2];
         for j := cnt2 to 16 do
           Inc(dyn[i,j,k], dyn[Pred(i),j-cnt2,k2])
       end
     end
   end
 End;

 Procedure PrintResult;
 Begin
   WriteLn;
   WriteLn;
   WriteLn('Count = ',dyn[8,16,1]);
   WriteLn
 End;

 Function IntToStr(n: Integer): String;
 Var s: String;
 Begin
   Str(n,s);
   IntToStr := s
 End;

 Function StrToInt(const s: string): integer;
 Var v, code: integer;
 Begin
   Val(s,v,code);
   StrToInt := v
 End;

 Procedure PrintConfig(config: string);
 Var
   Ks: array[1..8] of 1..55;
   i,j,p: Byte;
   kings: array[1..8,1..8] of Boolean;
   kingsR: array[1..4,1..4] of Boolean;
   kingsC: array[1..4,1..4] of Boolean;
   r,c: array[1..4] of 0..4;
   s: string;
 Begin
   i := 0;
   Delete(config,1,1);
   config := config + ' ';
   while Length(config) > 0 do begin
     p := Pos(' ',config);
     Inc(i);
     Ks[i] := StrToInt(Copy(config,1,Pred(p)));
     Delete(config,1,p)
   end;
   for i := 1 to 8 do
   for j := 1 to 8 do
     kings[i,j] := Boolean(PossibleColumns[i,Ks[j]]);
   for i := 1 to 4 do
   for j := 1 to 4 do
     kingsR[i,j] := kings[i shl 1, Pred(j shl 1)] or kings[Pred(i shl 1), Pred(j shl 1)];
   for j := 1 to 4 do
   for i := 1 to 4 do
     kingsC[i,j] := kings[Pred(i shl 1), j shl 1] or kings[Pred(i shl 1), Pred(j shl 1)];
   for i := 1 to 4 do begin
     r[i] := 4;
     for j := 1 to 4 do
       if not kingsR[i,j] then begin
         r[i] := Pred(j);
         break
       end
   end;
   for j := 1 to 4 do begin
     c[j] := 4;
     for i := 1 to 4 do
       if not kingsC[i,j] then begin
         c[j] := Pred(i);
         break
       end
   end;
   s := '';
   for i := 1 to 4 do s := s + IntToStr(r[i]);
   for j := 1 to 4 do s := s + IntToStr(c[j]);
   WriteLn(s)
 End;

 Function SearchSpace(i,j,k: Byte; const config: string): Longint;
 Var
   sum: Longint;
   ind, k2: 1..55;
   cnt2: 1..8;
 Begin
   if dyn[i,j,k] = 0 then
     SearchSpace := 0
   else if i = 0 then begin
     if j = 0 then begin
       SearchSpace := 1;
       PrintConfig(config)
     end
     else
       SearchSpace := 0
   end
   else begin
     sum := 0;
     for ind := 1 to Deg[k] do begin
       k2 := Adj[k,ind];
       cnt2 := cnt[k2];
       if j >= cnt2 then
         Inc(sum, SearchSpace(Pred(i),j-cnt2,k2,config+' '+IntToStr(k2)))
     end;
     SearchSpace := sum
   end
 End;

 Var res: Longint;

 BEGIN
   Init;
   WriteLn;
   WriteLn;
   DynProg;
   res := SearchSpace(8,16,1,'');
   WriteLn;
   WriteLn('Count = ',res); { result from SearchSpace }
   PrintResult { result from DynProg }
 END.