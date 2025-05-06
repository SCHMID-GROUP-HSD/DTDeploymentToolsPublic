var
  //InstallingNewerVersion: Boolean;
  CheckDependentVersionsAgain: boolean;
  CustomExitCode: Integer;

function CheckDependentVersions(): Boolean;
var
    PrevVersion, CurVersion: string;
    VersionDependencies, UpdatePackageVersion, BaseInstallPackageVersion, InstallerVersion, LocalUpdatePackageVersion, LocalBaseInstallPackageVersion, LocalInstallerVersion, BaseInstallUpdatePackageVersion, {LocalBaseInstallUpdatePackageVersion,} BuiltVersions, BuiltLocalVersions, BuiltVersionDependencies: AnsiString;
    FileName: string;
    baseInstallExeDescription: string;
    ResultCode: Integer;
    baseInstallIsFinished, versionsAreCompatible : Boolean;
    PackageUUID:string;
    BaseInstallUUID:string;
    InstallerOnlyUUID:string;
    args:string;
begin

    CheckDependentVersionsAgain := false;

    // nur dann etwas abpruefen, wenn es kein baseinstall ist, weil baseinstall ueberschreibt sowieso alles
    if (ExpandConstant('{#SetupSetting("AppId")}') = '{CC0EA0E5-D49B-4AD6-8696-129264259DEE}') or (ExpandConstant('{#SetupSetting("AppId")}') = '{5FD0B594-C89A-4351-87C0-482CD41E11D4}') then
    begin

        Result := false;

        {===========
        if RegQueryStringValue(HKLM, UninstallKey, DisplayVersionValue, PrevVersion) or
            RegQueryStringValue(HKCU, UninstallKey, DisplayVersionValue, PrevVersion) then
        begin
            Log(Format('Previous version %s', [PrevVersion]));
            CurVersion := '{#SetupSetting('AppVersion')}';
            Log(Format('Installing version %s', [CurVersion]));
            InstallingNewerVersion := (CompareVersion(PrevVersion, CurVersion) < 0);
            if InstallingNewerVersion then Log('Installing newer version')
            else Log('Not installing newer version')
        end;
        ============}

        //=======================
        ExtractTemporaryFiles('{tmp}\VersionDependencies.txt');
        LoadStringFromFile(ExpandConstant('{tmp}\VersionDependencies.txt'), VersionDependencies);
        ExtractTemporaryFiles('{tmp}\UpdatePackageVersion.txt');
        LoadStringFromFile(ExpandConstant('{tmp}\UpdatePackageVersion.txt'), UpdatePackageVersion);
        ExtractTemporaryFiles('{tmp}\BaseInstallPackageVersion.txt');
        LoadStringFromFile(ExpandConstant('{tmp}\BaseInstallPackageVersion.txt'), BaseInstallPackageVersion);
        ExtractTemporaryFiles('{tmp}\InstallerVersion.txt');
        LoadStringFromFile(ExpandConstant('{tmp}\InstallerVersion.txt'), InstallerVersion);
        LocalUpdatePackageVersion := GetUpdatePackageVersion();
        LocalBaseInstallPackageVersion := GetBaseInstallVersion();
        ////// LocalBaseInstallUpdatePackageVersion := GetBaseInstallUpdatePackageVersion();
        LocalInstallerVersion := GetInstallerVersion();
        BuiltVersions := UpdatePackageVersion + ', ' + BaseInstallPackageVersion + ', ' + InstallerVersion  ;

        BuiltLocalVersions := LocalUpdatePackageVersion + ', ' + LocalBaseInstallPackageVersion + ', ' + LocalInstallerVersion   ;

        //=======================

        PackageUUID:='{CC0EA0E5-D49B-4AD6-8696-129264259DEE}';
        BaseInstallUUID:='{163E16F6-29DC-416E-A0A8-EEA6583784D0}';
        InstallerOnlyUUID:='{5FD0B594-C89A-4351-87C0-482CD41E11D4}';

        if ExpandConstant('{#SetupSetting("AppId")}') = PackageUUID then
        begin
            BuiltVersionDependencies := '[' + UpdatePackageVersion + '|' + LocalBaseInstallPackageVersion + '|' + InstallerVersion + ']'  ;
        end
        else if ExpandConstant('{#SetupSetting("AppId")}') = BaseInstallUUID then
        begin
            ExtractTemporaryFiles('{tmp}\BaseInstallUpdatePackageVersion.txt');
            LoadStringFromFile(ExpandConstant('{tmp}\BaseInstallUpdatePackageVersion.txt'), BaseInstallUpdatePackageVersion);
            BuiltVersionDependencies := '[' + BaseInstallUpdatePackageVersion + '|' + LocalBaseInstallPackageVersion + '|' + InstallerVersion + ']'  ;
        end
        else if ExpandConstant('{#SetupSetting("AppId")}') = InstallerOnlyUUID then
        begin
            BuiltVersionDependencies := '[' + LocalUpdatePackageVersion + '|' + LocalBaseInstallPackageVersion + '|' + InstallerVersion + ']'  ;
        end
        else
        begin
            FlexibleMsgBox('AppId ' + ExpandConstant('{#SetupSetting("AppId")}') + ' not handled in include.iss', mbError, MB_OK);
        end;

        //=======================
        // folgende kriterien müssen erfüllt sein, wenn es mit der installation weiter gehen soll:
        // 1. Die Versionsangaben müssen passen
        versionsAreCompatible := Pos(BuiltVersionDependencies, VersionDependencies) <> 0;
        // 2. der Finished-Job des Baseintalls muss durchgelaufen sein.
        baseInstallIsFinished := IsBaseInstallFinished;
        
        if (not baseInstallIsFinished) or (not versionsAreCompatible) then
        begin
            baseInstallExeDescription := '"SCHMIDwatchInstallerBaseInstall-[VERSION].exe"' ;
            if FlexibleMsgBox('Installing of '+baseInstallExeDescription +' needed. Please click OK to choose this file in the upcoming dialog.' + #13#10 + #13#10 + 'More information:' + #13#10 + 'To be installed: [' + BuiltVersions +']' + #13#10 + 'Locally installed: [' + BuiltLocalVersions + ']'+#13#10+'BaseInstall finished: '+BoolToStr(baseInstallIsFinished), mbInformation, MB_OKCANCEL) = IDOK then
            begin
                // Set the initial filename
                FileName := '';
                if GetOpenFileName('Please choose '+baseInstallExeDescription, FileName, '', baseInstallExeDescription+'|*.exe', 'exe') then
                begin
                    if Pos(Lowercase('SCHMIDwatchInstallerBaseInstall'),Lowercase(FileName)) <> 0 then
                    begin
// /Mode=Unattended
args := '/skipwelcome=yes /RunBeforeInstallation="$Global:SWISKIPREBOOTQUESTION=$true;$Global:SWISKIPBACKUPQUESTION=$True;" /RunAfterInstallation="if(Test-SWIVariableExistsNotNull SWIMACHINEWILLBERESTARTED) {<#Register-SWIInstallUpdatePackageAfterLogon '''+ExpandConstant('{srcexe}')+'''; #> ExitInstaller 101} else {ExitInstaller 100}" ';
Log('ExecAndLogOutput: ' + ExpandConstant(FileName) + ' ' + args);
                       if ExecAndLogOutput(ExpandConstant(FileName), args, '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode, @ExecAndGetFirstLineLog) then
                        begin

                            //----wizardform ist beim init noch nicht da ---- WizardForm.StatusLabel.Caption := 'Running BaseInstall in a separate window. After successfully finishing BaseInstall the installation will continue here.'
                            if (ResultCode = 100) then
                            begin
                                CustomExitCode := ResultCode;
                                //FlexibleMsgBox('BaseInstall finished successfully. Continuing update package installation.', mbInformation, MB_OK);
                                CheckDependentVersionsAgain := true;
                            end
                            // Wenn im Installer dem Neustart zugestimmt wurde 
                            else if (ResultCode = 101) then
                            begin
                                CustomExitCode := ResultCode;
                                CheckDependentVersionsAgain := true;
                            end
                            else
                            begin
                                if FlexibleMsgBox('BaseInstall was not able to finish successfully. Would you like to try again?', mbError, MB_YESNO) = IDYES then
                                begin
                                    CheckDependentVersionsAgain := true;
                                end
                            end
                        end
                        else
                        begin
                            FlexibleMsgBox('Failed to run exe file' + #13#10 +
                                SysErrorMessage(ResultCode), mbError, MB_OK);
                        end;
                    end
                    else
                    begin
                        FlexibleMsgBox('Not a BaseInstall-file.'+#13#10+#13#10+'The filename of the chosen file has to be starting with "SCHMIDwatchInstallerBaseInstall".', mbError, MB_OK);
                        CheckDependentVersionsAgain := true;
                    end;
                end;
            end
        end
        else
        begin
            Result := true;
        end;
        //=======================
    end
    else
    begin
        Result := true;
    end;
end;
