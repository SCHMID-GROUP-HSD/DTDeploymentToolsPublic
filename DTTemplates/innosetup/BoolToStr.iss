function BoolToStr(Value: Boolean): String; 
begin
  if Value then
    Result := 'Yes'
  else
    Result := 'No';
end;
