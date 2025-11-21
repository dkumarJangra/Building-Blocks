tableextension 50070 "BBG Sales & Receiv. Setup Ext" extends "Sales & Receivables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Escalation Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
            TableRelation = "G/L Account" WHERE("Direct Posting" = CONST(true));
        }
        field(50001; "RA Bill Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 27-08-2007';
            TableRelation = "No. Series";
        }
        field(50002; "Posted RA Bill Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 27-08-2007';
            TableRelation = "No. Series";
        }
        field(50003; "Escalation Bill Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-08-2007';
            TableRelation = "No. Series";
        }
        field(50004; "Posted Escalation Bill Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-08-2007';
            TableRelation = "No. Series";
        }

        field(50006; "FBW RA Bill Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50007; "FBW Posted RA Bill Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50008; "FBW Credit Memo Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50009; "FBW Posted Credit Memo Nos."; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 231211';
            TableRelation = "No. Series";
        }
        field(50010; "Cash Max. Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Cash A/c No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }
        field(50012; "Bank A/C No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }
        field(50013; "Commission A/C"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(50014; "Bonus A/c"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(50015; "Interest A/C"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(50016; "Cheque in Hand"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }
        field(50017; "DD in Hand"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }
        field(50018; "Dr. Source Code"; Code[10])
        {
            Caption = 'Debit Voucher Source Code';
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
        }
        field(50019; "Bonus Dr. Source Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
        }
        field(50020; "Cr. Source Code"; Code[10])
        {
            Caption = 'Credit Voucher Source Code';
            DataClassification = ToBeClassified;
            TableRelation = "Source Code";
        }
        field(50021; "Bonus Payable A/c"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(50022; "Commission Payable A/C"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." WHERE("Account Type" = CONST(Posting));
        }
        field(50023; "Comm. No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50024; "Bonus No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50025; "Rounding Account(Commission)"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50026; "RoundingOff(Bonus)"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50027; "TDS Nature of Deduction"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "TDS Section";
        }
        field(50028; "No. Series MSC Cust code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "PPLAN-A"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "PPLAN-B"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50031; "PPLAN-C"; Code[10])
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
}