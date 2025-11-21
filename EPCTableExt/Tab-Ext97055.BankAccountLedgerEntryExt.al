tableextension 50059 "BBG Bank Acc. Ledger Entry Ext" extends "Bank Account Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50002; "Issuing Bank"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'NAVIN';
        }
        field(50003; Test; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Alledk 050908 for updating the Data BRS';
        }
        field(50004; "Value Date"; Date)
        {
            CalcFormula = Lookup("Bank Account Statement Line"."Value Date" WHERE("Bank Account No." = FIELD("Bank Account No."),
                                                                                   "Statement No." = FIELD("Statement No."),
                                                                                   "Statement Line No." = FIELD("Statement Line No.")));
            Description = 'RAHEE1.00 170412';
            FieldClass = FlowField;
        }
        field(50005; "Receipt Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 10112016';
            Editable = false;
        }
        field(50101; "Development Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50102; "Development Appl. Rcpt LineNo."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(50250; "New Value Dt."; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90012; Month; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEMSN01';
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(90013; Year; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEMSN01';
        }
        field(90101; Narration; Text[200])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90102; "TO Region Code"; Code[20])
        {
            Description = 'AlleBLK';
        }
        field(90103; "TO Region Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90108; "User Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(90109; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLETDK';
        }

        field(90111; "Send SMS on Cheq bounce"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(97748; "UTR No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'EPC2016';
        }
        field(50006; "Old Cheque No."; Code[20])
        {

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
}