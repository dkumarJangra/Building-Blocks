table 97760 "Unit Pmt. Ent. Existing(Chq Q)"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Application,RD,FD,MIS,BOND';
            OptionMembers = Application,RD,FD,MIS,BOND;
        }
        field(2; "Document No."; Code[20])
        {
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(4; "Unit No."; Code[20])
        {
            Caption = 'Unit No.';
            TableRelation = "Confirmed Order";
        }
        field(5; "Payment Method"; Code[10])
        {
            Caption = 'Payment Method';
            NotBlank = true;
            TableRelation = "Payment Method" WHERE("Bal. Account Type" = CONST("G/L Account"));
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(8; "Cheque No."; Code[20])
        {
        }
        field(9; "Cheque Date"; Date)
        {

            trigger OnValidate()
            var
                Application: Record "Job Master";
                BondSetup: Record "User Session";
            begin
            end;
        }
        field(10; "Cheque Bank and Branch"; Text[50])
        {
        }
        field(12; "Cheque Status"; Option)
        {
            OptionCaption = ' ,Cleared,Bounced';
            OptionMembers = " ",Cleared,Bounced;
        }
        field(13; "Cheque Clearance Date"; Date)
        {
        }
        field(14; "Application No."; Code[20])
        {
            Caption = 'Application No.';
        }
        field(15; "Payment Mode"; Option)
        {
            Caption = 'Payment Mode';
            OptionCaption = ' ,Cash,Cheque,D.D.';
            OptionMembers = " ",Cash,Cheque,"D.D.";
        }
        field(17; Posted; Boolean)
        {
            Caption = 'Posted';
        }
        field(18; "Installment No."; Integer)
        {
        }
        field(19; "Deposit/Paid Bank"; Code[20])
        {
            TableRelation = IF ("Payment Mode" = FILTER(Cheque | "D.D.")) "Bank Account"."No.";
        }
        field(20; "Not Refundable"; Boolean)
        {
            Editable = false;
        }
        field(22; "Posted Document No."; Code[20])
        {
        }
        field(23; Type; Option)
        {
            Editable = false;
            OptionCaption = ' ,Received,Interest,Principal,Interest + Principal';
            OptionMembers = " ",Received,Interest,Principal,"Interest + Principal";
        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(26; "Document Date"; Date)
        {
        }
        field(27; "Posting date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(28; Reversed; Boolean)
        {
            CalcFormula = Max("G/L Entry"."BBG Do Not Show" WHERE("Document No." = FIELD("Posted Document No.")));
            FieldClass = FlowField;
        }
        field(100; "Bonus Generated"; Boolean)
        {
            Editable = false;
        }
        field(101; "Commission Generated"; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount;
        }
        key(Key2; Posted, "Payment Mode", "Cheque Status", "Cheque Clearance Date", "Document Type", "Document No.", "Document Date", "Posting date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Posted, FALSE);
    end;

    trigger OnModify()
    begin
        TESTFIELD(Posted, FALSE);
    end;

    var
        PaymentMethod: Record "Payment Method";
        BondSetup: Record "User Session";
        Text0001: Label 'Please enter a valid cheque no.';
        Text0002: Label 'Please enter a valid cheque date.';
        Text0003: Label 'You cannot change Line No. %1.';
        Text0004: Label 'Cheque Already Cleared and Posted';
        Text0005: Label 'Payment Mode is %1';
        Text0006: Label 'Please enter Cheque Clearance Date';
        Text0007: Label 'Please enter a valid cheque Clearance date.';
        Text0008: Label 'Cheque Clearance date cannot be changed';
        Application: Record "Job Master";
        Bond: Record Category;
        TotalApplAmt: Decimal;
        TotalRcvdAmt: Decimal;
        Text0009: Label 'Payment mode %1 already exists.';
        Text0010: Label 'Maximum permitted amount in %1 is %2.';
        Text0011: Label 'Amount should not be greater than Due Amount = %1.';
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        DefaultDim: Record "Default Dimension";
        Text0012: Label 'Error';
        GLSetupRead: Boolean;
        GetDescription: Codeunit GetDescription;
}

