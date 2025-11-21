table 97844 "Debit App. Payment Entry"
{
    // ALLEDK 101012 Added code for Bank Name
    // // BBG1.01_NB 191012: Add additonal option of D.C./C.C/ Net Banking in Payment Mode.
    // ALLEPG 221012 : Code modify for cheque date.
    // ALLETDK081112...Added "Posted","Cheque Status" fields to Key "Document Type","Application No."
    // ALLETDK061212..Added new option "Refund Cash" and "Refund Cheque" in "Pyament Mode" field

    Caption = 'Debit App. Payment Entry';
    DrillDownPageID = "Discount Entries Details";

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
        field(4; "Unit Code"; Code[20])
        {
            Caption = 'Unit Code';
            TableRelation = "Unit Master";
        }
        field(5; "Payment Method"; Code[10])
        {
            Caption = 'Payment Method';
            NotBlank = true;
            TableRelation = "Payment Method" WHERE("Bal. Account Type" = CONST("G/L Account"));

            trigger OnValidate()
            begin
                IF PaymentMethod.GET("Payment Method") THEN BEGIN
                    IF ("Payment Mode" <> "Payment Mode"::"Refund Cash") AND ("Payment Mode" <> "Payment Mode"::"Refund Cheque") THEN //ALLETDK
                        PaymentMethod.TESTFIELD(PaymentMethod."Bal. Account No.");
                    Description := PaymentMethod.Description;
                END;
            end;
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(7; "Commission Adj. Amount"; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            begin
                "Net Payable Amt" := "Commission Adj. Amount" + "Principal Adj. Amount";
            end;
        }
        field(14; "Application No."; Code[20])
        {
            Caption = 'Application No.';
        }
        field(15; "Payment Mode"; Option)
        {
            Caption = 'Payment Mode';
            OptionCaption = ' ,Cash,Cheque,D.D.,MJVM,D.C./C.C./Net Banking,Refund Cash,Refund Cheque,AJVM,Debit Note';
            OptionMembers = " ",Cash,Cheque,"D.D.",MJVM,"D.C./C.C./Net Banking","Refund Cash","Refund Cheque",AJVM,"Debit Note";

            trigger OnValidate()
            begin
                "Payment Method" := 'CASH';
            end;
        }
        field(17; Posted; Boolean)
        {
            Caption = 'Posted';
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
        field(32; "Explode BOM"; Boolean)
        {
            Editable = true;
        }
        field(50003; "Introducer Code"; Code[20])
        {
            Description = 'BBG181012';
            Editable = true;
            TableRelation = Vendor;
        }
        field(50004; "Branch Code"; Code[20])
        {
        }
        field(50005; "Base Amount"; Decimal)
        {
            Editable = false;
        }
        field(50006; "Net Payable Amt"; Decimal)
        {
            DecimalPlaces = 0 : 2;
            Editable = false;
        }
        field(50007; "Principal Adj. Amount"; Decimal)
        {
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                IF "Principal Adj. Amount" < 0 THEN
                    ERROR('Amount must be +Ve');

                "Net Payable Amt" := "Commission Adj. Amount" + "Principal Adj. Amount";
            end;
        }
        field(50008; "BSP Type"; Code[10])
        {
            TableRelation = "Unit Charge & Payment Pl. Code";
        }
        field(50009; "Commission %"; Decimal)
        {
            Description = 'ALLEDK 270113';
            Editable = false;
        }
        field(50010; "User ID"; Code[20])
        {
            Description = 'ALLETDK310113';
        }
        field(50011; "BBG Discount"; Boolean)
        {
            Description = 'ALLEDK 180213';
            Editable = false;
        }
        field(50012; "Introducer Name"; Text[30])
        {
            Description = 'ALLEDK 180213';
        }
        field(50013; Narration; Text[60])
        {
            Description = 'ALLECK 130413';
        }
        field(50014; "Member Code"; Code[20])
        {
            Description = 'BBG1.6';
            Editable = false;
            TableRelation = Customer;
        }
        field(50015; "Discount Payment Type"; Option)
        {
            Description = 'BBG1.6 311213';
            OptionCaption = ' ,Forfeit,Excess Payment';
            OptionMembers = " ",Forfeit,"Excess Payment";
        }
        field(50016; "Data Transfered"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Commission Adj. Amount";
        }
        key(Key2; "Shortcut Dimension 1 Code", "Document No.")
        {
        }
        key(Key3; "Document No.", "Shortcut Dimension 1 Code", "Posting date")
        {
        }
        key(Key4; "Introducer Code", "Document No.", "Shortcut Dimension 1 Code", "Posting date")
        {
        }
        key(Key5; "Introducer Code", "Shortcut Dimension 1 Code", "Document No.", "Posting date")
        {
        }
        key(Key6; "Unit Code")
        {
        }
        key(Key7; "Document No.", Posted)
        {
            SumIndexFields = "Net Payable Amt";
        }
        key(Key8; "Document No.", "Posting date", Posted, "Introducer Code")
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

    trigger OnInsert()
    begin
        BPayEntry.RESET;
        BPayEntry.SETRANGE("Document Type", "Document Type");
        BPayEntry.SETFILTER(BPayEntry."Document No.", "Document No.");
        IF BPayEntry.FIND('+') THEN BEGIN
            "Line No." := BPayEntry."Line No." + 10000;
        END ELSE
            "Line No." := 10000;

        "Posting date" := WORKDATE;
        "Document Date" := GetDescription.GetDocomentDate;
        UserSetup.GET(USERID);
        "Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
        "Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        "Branch Code" := UserSetup."User Branch";

        "Application No." := "Document No."; //ALLEDK 091012

        "Payment Mode" := "Payment Mode"::"Debit Note";
    end;

    trigger OnModify()
    begin
        IF USERID = 'PRAKASHSARKAR' THEN
            EXIT;
        // TESTFIELD(Posted,FALSE);

        IF ("Payment Mode" <> "Payment Mode"::AJVM) THEN
            TESTFIELD("Payment Method");
        IF ("Payment Mode" <> "Payment Mode"::Cash) AND ("Payment Mode" <> "Payment Mode"::MJVM)
          AND ("Payment Mode" <> "Payment Mode"::"Refund Cash") AND ("Payment Mode" <> "Payment Mode"::AJVM) THEN BEGIN //ALLETDK

        END;
    end;

    var
        PaymentMethod: Record "Payment Method";
        BondSetup: Record "Unit Setup";
        Text0001: Label 'Please enter a valid cheque no.';
        Text0002: Label 'Please enter a valid cheque date.';
        Text0003: Label 'You cannot change Line No. %1.';
        Text0004: Label 'Cheque Already Cleared and Posted';
        Text0005: Label 'Payment Mode is %1';
        Text0006: Label 'Please enter Cheque Clearance Date';
        Text0007: Label 'Please enter a valid cheque Clearance date.';
        Text0008: Label 'Cheque Clearance date cannot be changed';
        Application: Record Application;
        Bond: Record "Confirmed Order";
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
        BPayEntry: Record "Debit App. Payment Entry";
        Text0013: Label 'The Order is already Exploded.\Not allowed to enter New Line';
        Text0014: Label 'Order is already Registered.\Not allowed to modify or delete';
        Text0015: Label 'Order is already Cancelled.\Not allowed to modify or delete';
        TotalRcvdAmt2: Decimal;
        Vendor: Record Vendor;
        Text50000: Label 'Associate %1 PAN No. not verified';
        BankAccount: Record "Bank Account";
        ConfirmOrder: Record "Confirmed Order";
        APPNo: Record Application;
        Text50001: Label 'Total Receipt Amount is greater than Due Amount = %1. Do you want to continue?';
        RecConfirmOrder: Record "Confirmed Order";
        RecConfOrder: Record "Confirmed Order";
        AppPayEntry: Record "Application Payment Entry";
        UnitReversal: Codeunit "Unit Reversal";
        Amt: Decimal;
        CommissionEntry: Record "Commission Entry";
        CommAmt: Decimal;
        UnitSetup: Record "Unit Setup";
        Vend: Record Vendor;
        TDSP: Decimal;
        ClubP: Decimal;
        ConfOrder: Record "Confirmed Order";
    //NODNOCHdr: Record 13786;
}

