program hello;

function sum(env, obj: Pointer; a, b: Integer): Integer; cdecl;
begin
  Result := a + b;
end;

const
  PREFIX = 'Java_hello_';
	
exports 
  sum name PREFIX + 'sum';
begin
end.