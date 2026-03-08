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
        NoSeriesMgt: Codeunit "No. Series"; //NoSeriesManagement;
    BEGIN
        WITH CustomerBankAccount DO BEGIN
            OldCustomerBankAccount := Rec;
            BondSetup.GET;
            BondSetup.TESTFIELD(BondSetup."Customer Bank Code");
            // IF NoSeriesMgt.SelectSeries(BondSetup."Customer Bank Code", OldCustomerBankAccount."No. Series", "No. Series") THEN BEGIN  //Old code commented 07032026
            //  NoSeriesMgt.SetSeries(Code);  //Old code commented 07032026
            if NoSeriesMgt.LookupRelatedNoSeries(BondSetup."Customer Bank Code", Rec."No. Series") then BEGIN  //New code Added 07032026
                Rec.Validate("No. Series"); //New code Added 07032026
                NoSeriesMgt.TestManual("No. Series"); //New code Added 07032026
                Rec := CustomerBankAccount;
                EXIT(TRUE);
            END;
        END;
    END;
}