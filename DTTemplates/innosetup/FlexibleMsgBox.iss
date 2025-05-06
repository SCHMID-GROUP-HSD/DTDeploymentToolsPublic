function FlexibleMsgBox(const Text: String; const Typ: TMsgBoxType; const Buttons: Integer): Integer;
begin
    if ExpandConstant('{param:Mode|Normal}') = 'Unattended' then
    begin
        Log('FlexibleMsgBox: ' + Text);
        CloseInstaller(88);
    end
    else
    begin
        Result:=MsgBox(Text, Typ, Buttons);
    end;
end;
