tableextension 50058 "BBG Bank Account Ext" extends "Bank Account"
{
    fields
    {
        // Add changes to table fields here
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                //ALLECK 120313 START

                DebitVAccount.SETRANGE("Account No.", "No.");
                IF DebitVAccount.FINDSET THEN
                    REPEAT
                        DebitVAccount."Account Name" := Name;
                        MODIFY;
                    UNTIL DebitVAccount.NEXT = 0;
                CreditVAccount.SETRANGE("Account No.", "No.");
                IF CreditVAccount.FINDSET THEN
                    REPEAT
                        CreditVAccount."Account Name" := Name;
                        MODIFY;
                    UNTIL CreditVAccount.NEXT = 0;
                //Need to check the code in UAT

                //ALLECK 120313 END
            end;
        }
        modify("Bank Account No.")
        {
            trigger OnAfterValidate()
            begin
                //ALLECK 210313 START

                DebitVAccount.SETRANGE("Account No.", "No.");
                IF DebitVAccount.FINDSET THEN
                    REPEAT
                        DebitVAccount."Bank Account No." := "Bank Account No.";
                        DebitVAccount.MODIFY;
                    UNTIL DebitVAccount.NEXT = 0;

                CreditVAccount.SETRANGE("Account No.", "No.");
                IF CreditVAccount.FINDSET THEN
                    REPEAT
                        CreditVAccount."Bank Account No." := "Bank Account No.";
                        CreditVAccount.MODIFY;
                    UNTIL CreditVAccount.NEXT = 0;

                //Need to check the code in UAT

                //ALLECK 210313 END
            end;
        }
        field(50000; "Responsibility Center Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            TableRelation = "Responsibility Center 1".Code;
        }

        field(50002; "Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
            TableRelation = Location;
        }

        field(50004; "Hide Bank Account"; Boolean)
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
        //VAccount: Record 16547;//Need to check the code in UAT
        DebitVAccount: Record "Voucher Posting Debit Account";
        CreditVAccount: Record "Voucher Posting Credit Account";

    trigger OnAfterInsert()
    begin
        IF WORKDATE < 20080221D THEN
            ERROR('You can not work on this workdate');

    end;
}