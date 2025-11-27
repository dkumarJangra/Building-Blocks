pageextension 50120 RestrictConfigPackageAccess extends "Config. Packages"
{
    trigger OnOpenPage()
    var
        Usersetup: Record "User Setup";
    begin
        Usersetup.Reset();
        Usersetup.SetRange("User ID", USERID);
        Usersetup.SetRange("Allow configurationPckg", false);
        IF Usersetup.FindFirst() then
            Error('You are not authorized to access configuration packages.');

    end;
}