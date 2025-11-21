tableextension 50116 "BBG Voucher Post. Dbt Acc Ext" extends "Voucher Posting Debit Account"
{
    fields
    {
        // Add changes to table fields here
        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                IF "Account Type" = "Account Type"::"G/L Account" THEN BEGIN
                    IF GLAc.GET("Account No.") THEN BEGIN
                        "Account Name" := GLAc.Name;
                    END;
                END;
                IF "Account Type" = "Account Type"::"Bank Account" THEN BEGIN
                    IF BankAcc.GET("Account No.") THEN Begin
                        "Account Name" := BankAcc.Name;
                        "Bank Account No." := BankAcc."Bank Account No.";
                    End;
                END;

                IF "Account No." = '' THEN
                    "Account Name" := '';
            end;
        }
        field(50001; "Maximum Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleAB 032 020408';
        }
        field(50002; "ARM Account Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG1.00 ALLEDK 070313';
            OptionCaption = ' ,Collection,Assc Payment,Both';
            OptionMembers = " ",Collection,"Assc Payment",Both;
        }
        field(50003; "Payment Method Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG1.00 ALLEDK 070313';
            TableRelation = "Payment Method";
        }
        field(50004; "Account Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG1.00 ALLECK 100313';
        }
        field(50005; "Bank Account No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLECK 210313';
        }
        field(50006; "Bank Filter for Main Comp"; Boolean)
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
        GLAc: Record "G/L Account";
        BankAcc: Record "Bank Account";
}