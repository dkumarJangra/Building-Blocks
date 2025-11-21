tableextension 50066 "BBG Customer Bank Account Ext" extends "Customer Bank Account"
{
    fields
    {
        // Add changes to table fields here

        field(50007; "Created Date"; Date)
        {
            DataClassification = ToBeClassified;
        }

        field(50011; "No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
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



    PROCEDURE AssistEdit(OldCustomerBankAccount: Record "Customer Bank Account"): Boolean;
    VAR
        CustomerBankAccount: Record "Customer Bank Account";
        BondSetup: Record "Unit Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    BEGIN
        WITH CustomerBankAccount DO BEGIN
            OldCustomerBankAccount := Rec;
            BondSetup.GET;
            BondSetup.TESTFIELD(BondSetup."Customer Bank Code");
            IF NoSeriesMgt.SelectSeries(BondSetup."Customer Bank Code", OldCustomerBankAccount."No. Series", "No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries(Code);
                Rec := CustomerBankAccount;
                EXIT(TRUE);
            END;
        END;
    END;
}