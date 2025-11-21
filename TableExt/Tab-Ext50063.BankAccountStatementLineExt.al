tableextension 50063 "BBG Bank Acc. Stment Line Ext" extends "Bank Account Statement Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Value Date")
        {
            trigger OnAfterValidate()
            begin
                //GKG001 Start
                IF ("Value Date" <> 0D) AND ("Value Date" > TODAY) THEN
                    ERROR(Text50001, FIELDNAME("Value Date"), TODAY);
                //GKG Start002
            end;
        }
        field(50001; "Application No."; Code[20])
        {
            CalcFormula = Lookup("Bank Account Ledger Entry"."Application No." WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                      "Statement No." = FIELD("Statement No."),
                                                                                      "Statement Line No." = FIELD("Statement Line No."),
                                                                                      Open = FILTER(false),
                                                                                      "Statement Status" = FILTER(Closed),
                                                                                      "Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50026; Bounced; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
            Editable = false;
        }
        field(50027; "New Application No."; Code[20])
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
        field(50028; BouncedEntryPosted; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
        }
        field(50029; "External Doc. No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
        }
        field(50030; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
        }
        field(50031; "Bounce Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
            OptionCaption = ' ,Tech,Non';
            OptionMembers = " ",Tech,Non;

            trigger OnValidate()
            begin
                TESTFIELD(Bounced, FALSE);
            end;
        }

        field(50033; "Receipt Line No."; Integer)
        {
            CalcFormula = Lookup("Bank Account Ledger Entry"."Receipt Line No." WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                       "Statement No." = FIELD("Statement No."),
                                                                                       "Statement Line No." = FIELD("Statement Line No."),
                                                                                       Open = CONST(false),
                                                                                       "Statement Status" = CONST(Closed)));
            Description = 'ALLEDK 111116';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50101; "Development Application No."; Code[20])
        {
            CalcFormula = Lookup("Bank Account Ledger Entry"."Development Application No." WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                                  "Statement No." = FIELD("Statement No."),
                                                                                                  "Statement Line No." = FIELD("Statement Line No."),
                                                                                                  Open = CONST(false),
                                                                                                  "Statement Status" = CONST(Closed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50102; "Development Appl. Rcpt LineNo."; Integer)
        {
            CalcFormula = Lookup("Bank Account Ledger Entry"."Development Appl. Rcpt LineNo." WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                                     "Statement No." = FIELD("Statement No."),
                                                                                                     "Statement Line No." = FIELD("Statement Line No."),
                                                                                                     Open = CONST(false),
                                                                                                     "Statement Status" = CONST(Closed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50103; "New Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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
        Text50001: Label '%1 cannot be greater than %2';
}