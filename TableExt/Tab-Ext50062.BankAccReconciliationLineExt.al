tableextension 50062 "BBG Bank Acc. Rection Line Ext" extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Value Date")
        {
            trigger OnAfterValidate()
            begin
                //TESTFIELD(BouncedEntryPosted,FALSE);
                IF "Transaction Date" <> 0D THEN BEGIN
                    IF "Value Date" <> 0D THEN
                        IF "Value Date" < "Transaction Date" THEN
                            ERROR(Text50000);
                END;
                "User ID" := USERID; //ALLETDK

                IF "Value Date" > TODAY THEN
                    ERROR('Value Date can not be greater than Today');
            end;
        }
        modify("Check No.")
        {
            trigger OnAfterValidate()
            begin
                "Cheque No." := "Check No.";  //Alledk 180821
            end;
        }


        field(50004; Verified; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';

            trigger OnValidate()
            var
                OK: Boolean;
            begin
                BEGIN
                    //JPL-13Sept2007 - s
                    IF xRec.Verified = TRUE THEN
                        OK := CONFIRM('Do you want to remove VERIFIED?', FALSE);
                    IF OK = TRUE THEN
                        Verified := FALSE
                    ELSE
                        Verified := TRUE;
                    //JPL-13Sept2007 - e
                END;
            end;
        }
        field(50005; "Cheque Amount"; Decimal)
        {
            CalcFormula = Sum("Bank Acc. Reconciliation Line"."Statement Amount" WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                        "Statement No." = FIELD("Statement No."),
                                                                                        "Cheque No." = FIELD("Cheque No.")));
            Description = 'AlleBLK';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50023; "Doc. No Of Applied Entry"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERK 27-07-2009: Document No Of Applied entry added.';
            Editable = false;
        }
        field(50024; "Applied Difference Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERK 28-07-2009.';
        }


        field(50027; "Application No."; Code[20])
        {
            CalcFormula = Lookup("Bank Account Ledger Entry"."Application No." WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                      "Statement No." = FIELD("Statement No."),
                                                                                      "Statement Line No." = FIELD("Statement Line No.")));
            Description = 'ALLETDK';
            Editable = false;
            FieldClass = FlowField;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = true;
        }


        field(50030; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
            Editable = false;
        }

        field(50032; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
        }
        field(50033; "Receipt Line No."; Integer)
        {
            CalcFormula = Lookup("Bank Account Ledger Entry"."Receipt Line No." WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                       "Statement No." = FIELD("Statement No."),
                                                                                       "Statement Line No." = FIELD("Statement Line No.")));
            Description = 'ALLEDK 10112016';
            Editable = false;
            FieldClass = FlowField;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = true;
        }
        field(50101; "Development Application No."; Code[20])
        {
            CalcFormula = Lookup("Bank Account Ledger Entry"."Development Application No." WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                                  "Statement No." = FIELD("Statement No."),
                                                                                                  "Statement Line No." = FIELD("Statement Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50102; "Development Appl. Rcpt LineNo."; Integer)
        {
            CalcFormula = Lookup("Bank Account Ledger Entry"."Development Appl. Rcpt LineNo." WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                                     "Statement No." = FIELD("Statement No."),
                                                                                                     "Statement Line No." = FIELD("Statement Line No.")));
            Editable = false;
            FieldClass = FlowField;
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
        VLE: Record "Vendor Ledger Entry";
        BLE: Record "Bank Account Ledger Entry";
        ReversalEntry: Record "Reversal Entry";
        Text50000: Label 'ENU=Value Date should not be less than Transaction Date.';

    trigger OnAfterDelete()
    begin
        //ALLETDK>>
        IF BouncedEntryPosted THEN
            ERROR('You can not delete this entry');
        //ALLETDK<<
    end;
}