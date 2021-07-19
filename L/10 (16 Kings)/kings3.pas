 Program Kings3;

 {$M 40000, 0, 0}

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

 Type
   Matrix = array[1..55, 1..55] of Longint;

 Var { Const }
   cnt: array[1..55] of 0..4;  { count of 1s in each column }
   A,B: Matrix; { binary (0-1) matrices:
   A[k1][k2] = 1 <=> columns k1 and k2 are compatible (non-attacking kings);
   B[k1][k2] = 1 <=> A[k1][k2] and cnt[k1] + cnt[k2] = 4 }

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

 Procedure InitMatrices;
 Var k1, k2: 1..55;
 Begin
   FillChar(A,SizeOf(A),0);
   FillChar(B,SizeOf(B),0);
   A[1,1] := 1;
   for k1 := 1 to 54 do
     for k2 := Succ(k1) to 55 do
       if CompatibleColumns(k1,k2) then begin
         A[k1,k2] := 1;
         A[k2,k1] := 1;
         if cnt[k1] + cnt[k2] = 4 then begin
           B[k1,k2] := 1;
           B[k2,k1] := 1
         end
       end
 End;

 Procedure Init;
 Begin
   InitCnt;
   InitMatrices
 End;

 Procedure Mult(var X,Y,Z: Matrix); { Z := XY }
 Var k1,k2,k3: 1..55;
 Begin
   FillChar(Z,SizeOf(Z),0);
   for k1 := 1 to 55 do
     for k2 := 1 to 55 do
       for k3 := 1 to 55 do
         Inc(Z[k1,k2], X[k1,k3] * Y[k3,k2])
 End;

 Function CalcBoardCount: Longint;
 Var
   C,D,Tmp: Matrix;
   k1,k2: 1..55;
   sum: Longint;
 Begin
   C := B;
   Mult(B,A,C);
   { C = BA }
   Mult(C,C,D);
   { D = C^2 }
   Mult(D,C,Tmp);
   { Tmp = C^3 }
   Mult(Tmp,B,D);
   { D = (C^3)B = ((BA)^3)B = BABABAB }
   sum := 0;
   for k1 := 1 to 55 do
     for k2 := 1 to 55 do
       Inc(sum,D[k1,k2]);
   CalcBoardCount := sum
 End;

 BEGIN
   Init;
   WriteLn;
   WriteLn;
   WriteLn('Count = ',CalcBoardCount)
 END.