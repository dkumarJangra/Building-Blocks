tableextension 97039 "EPC Customer Bank Account Ext" extends "Customer Bank Account"
{
    fields
    {
        // Add changes to table fields here
        field(50005; "Entry Completed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "USER ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        Txt001: Label 'ENU=Please check Branch Code and IFSC Code.';
        Txt002: Label 'ENU=Please immediately contact System Admin.\You are trying to insert wrong %1.';


    PROCEDURE Checking()
    VAR
        CustomerBank: Record "Customer Bank Account";
        CustomerBank2: Record "Customer Bank Account";
        UserSetup: Record "User Setup";
    BEGIN
        IF STRLEN("Bank Branch No.") > STRLEN("SWIFT Code") THEN
            ERROR(Txt001);
        IF "Bank Branch No." <> COPYSTR("SWIFT Code", STRLEN("SWIFT Code") - STRLEN("Bank Branch No.") + 1, STRLEN("Bank Branch No.")) THEN
            ERROR(Txt001);

        UserSetup.GET(USERID);
        IF NOT (UserSetup."NEFT Modification Permission" AND "Entry Completed") THEN BEGIN
            CustomerBank.SETCURRENTKEY(Code, "Bank Branch No.", "SWIFT Code");
            CustomerBank.SETRANGE(Code, Code);
            CustomerBank.SETRANGE("Bank Branch No.", "Bank Branch No.");
            IF CustomerBank.FINDFIRST THEN
                IF CustomerBank."SWIFT Code" <> "SWIFT Code" THEN
                    ERROR(Txt002, 'IFSC Code');

            CustomerBank.RESET;
            CustomerBank.SETCURRENTKEY(Code, "Bank Branch No.", "SWIFT Code");
            CustomerBank.SETRANGE(Code, Code);
            CustomerBank.SETRANGE("SWIFT Code", "SWIFT Code");
            IF CustomerBank.FINDFIRST THEN
                IF CustomerBank."Bank Branch No." <> "Bank Branch No." THEN
                    ERROR(Txt002, 'Bank Branch No.');
        END;
    END;
}