program hello;

function sum(env, obj: Pointer; a, b: Integer): Integer; cdecl;
begin
  Result := a + b;
end;

begin
end.