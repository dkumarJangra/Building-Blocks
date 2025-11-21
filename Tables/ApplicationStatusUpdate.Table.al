table 50032 "Application Status Update"
{
    // ALLEDK 101012 Added code for Bank Name
    // // BBG1.01_NB 191012: Add additonal option of D.C./C.C/ Net Banking in Payment Mode.
    // ALLEPG 221012 : Code modify for cheque date.
    // ALLETDK081112...Added "Posted","Cheque Status" fields to Key "Document Type","Application No."
    // ALLETDK061212..Added new option "Refund Cash" and "Refund Cheque" in "Pyament Mode" field
    // AD230213:BBG1.00 CODE COMMENTED: NOT REQUIRED IN BBG
    //  ADCOMMENTED280313

    Caption = 'Application Status Update Entry';

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
            Editable = true;
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
        }
        field(6; Description; Text[50])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(7; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            var
                AdjmtAmt: Decimal;
            begin
            end;
        }
        field(8; "Cheque No./ Transaction No."; Code[20])
        {
        }
        field(9; "Cheque Date"; Date)
        {

            trigger OnValidate()
            var
                Application: Record Application;
                BondSetup: Record "Unit Setup";
            begin
            end;
        }
        field(10; "Cheque Bank and Branch"; Text[50])
        {
        }
        field(12; "Cheque Status"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Cleared,Bounced,,Cancelled';
            OptionMembers = " ",Cleared,Bounced,,Cancelled;
        }
        field(13; "Chq. Cl / Bounce Dt."; Date)
        {
        }
        field(15; "Payment Mode"; Option)
        {
            Caption = 'Payment Mode';
            OptionCaption = ' ,Cash,Bank,D.D.,MJVM,D.C./C.C./Net Banking,Refund Cash,Refund Bank,AJVM,Debit Note,JV,Negative Adjmt.';
            OptionMembers = " ",Cash,Bank,"D.D.",MJVM,"D.C./C.C./Net Banking","Refund Cash","Refund Bank",AJVM,"Debit Note",JV,"Negative Adjmt.";
        }
        field(17; Posted; Boolean)
        {
            Caption = 'Posted';
        }
        field(19; "Deposit/Paid Bank"; Code[20])
        {
        }
        field(22; "Posted Document No."; Code[20])
        {
        }
        field(24; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(25; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(27; "Posting date"; Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(34; "Order Ref No."; Code[20])
        {
            TableRelation = "Confirmed Order";

            trigger OnLookup()
            var
                ConfOrder_1: Record "New Confirmed Order";
                GetConfOrder_1: Record "New Confirmed Order";
            begin
            end;

            trigger OnValidate()
            var
                NewconfOrder_1: Record "New Confirmed Order";
                RecConfOrder_1: Record "New Confirmed Order";
                RecConfirmOrder_1: Record "New Confirmed Order";
                UnitPaymentEntry_1: Record "Unit Payment Entry";
            begin
            end;
        }
        field(36; "User Branch Code"; Code[20])
        {
            TableRelation = Location WHERE("BBG Branch" = CONST(true));
        }
        field(50000; "Created From Application"; Boolean)
        {
            Description = 'ALLEDK 091012';
            Editable = true;
        }
        field(50001; "Deposit / Paid Bank Name"; Text[60])
        {
            Description = 'ALLEDK 101012';
            Editable = false;
        }
        field(50002; "Gold Coin Eligibility"; Boolean)
        {
            Description = 'BBG161012';
        }
        field(50003; "Introducer Code"; Code[20])
        {
            Description = 'BBG181012';
            TableRelation = Vendor;
        }
        field(50008; "User ID"; Code[50])
        {
            Description = 'ALLEDK 271212';
            Editable = false;
            TableRelation = User;
        }
        field(50009; "Associate Transfer Amount"; Decimal)
        {
        }
        field(50016; "AJVM Associate Code"; Code[20])
        {
            CalcFormula = Lookup("Vendor Ledger Entry"."Vendor No." WHERE("Document No." = FIELD("Posted Document No."),
                                                                           "Order Ref No." = FIELD("Document No.")));
            Description = 'ALLETDK280213';
            FieldClass = FlowField;
        }
        field(50019; "User Branch Name"; Text[70])
        {
            Description = 'ALLECK 280313';
            Editable = false;
        }
        field(50020; "AJVM Transfer Type"; Option)
        {
            Description = 'ALLETDK290313';
            OptionCaption = ',Commission,Incentive';
            OptionMembers = ,Commission,Incentive;
        }
        field(50102; "LD Amount"; Decimal)
        {
        }
        field(50205; "MSC Post Doc. No."; Code[20])
        {
            Editable = false;
        }
        field(50220; "Bank Type"; Option)
        {
            OptionCaption = ' ,CollectionCompany,ProjectCompany';
            OptionMembers = " ",CollectionCompany,ProjectCompany;
        }
        field(50221; "MSC Bank Code"; Code[20])
        {
            Editable = false;
        }
        field(50230; "Commission Reversed"; Boolean)
        {
            Description = 'ALLE240415';
            Editable = false;
        }
        field(50231; "Order Status"; Option)
        {
            CalcFormula = Lookup("Confirmed Order".Status WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
            OptionCaption = 'Open,Documented,Cash Dispute,Documentation Dispute,Verified,Active,Death Claim,Maturity Claim,Maturity Dispute,Matured,Dispute,Blocked (Loan),Registered,Cancelled,Vacate,Forfeit';
            OptionMembers = Open,Documented,"Cash Dispute","Documentation Dispute",Verified,Active,"Death Claim","Maturity Claim","Maturity Dispute",Matured,Dispute,"Blocked (Loan)",Registered,Cancelled,Vacate,Forfeit;
        }
        field(50234; "Balance Account No."; Code[20])
        {
        }
        field(50235; "Payment Mode New"; Option)
        {
            OptionCaption = ' ,AJVM ELEG,AJVM ADV';
            OptionMembers = " ","AJVM ELEG","AJVM ADV";
        }
        field(50236; "Receipt Line No."; Integer)
        {
            Editable = false;
        }
        field(50302; "Statement No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50303; "Statement Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50304; "BLE Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50305; "Posted BRS"; Boolean)
        {
            DataClassification = ToBeClassified;
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
        key(Key2; "Posted BRS")
        {
        }
    }

    fieldgroups
    {
    }
}

