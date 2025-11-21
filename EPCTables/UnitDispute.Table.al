table 97783 "Unit Dispute"
{
    // Below key has been used in the PAGE 50080
    // Investment Type,Bond No.,Introducer Code,Status,Return Payment Mode,Blocked

    Caption = 'Bond Dispute';
    DrillDownPageID = "Unit List";
    LookupPageID = "Unit List";

    fields
    {
        field(1; "Unit No."; Code[20])
        {
            Editable = false;
            NotBlank = true;
        }
        field(2; "Scheme Code"; Code[20])
        {
            Editable = false;
        }
        field(3; "Project Type"; Code[20])
        {
            Editable = false;
            TableRelation = "Unit Type".Code;
        }
        field(4; Duration; Integer)
        {
            Editable = false;
        }
        field(5; "Customer No."; Code[20])
        {
            Editable = false;
            TableRelation = Customer;
        }
        field(6; "Introducer Code"; Code[20])
        {
            Caption = 'Introducer Code';
            Editable = false;
            TableRelation = Vendor;
        }
        field(7; "Maturity Date"; Date)
        {
            Editable = false;
        }
        field(8; "Maturity Amount"; Decimal)
        {
            Editable = false;
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(11; "Application No."; Code[20])
        {
            Editable = false;
            NotBlank = true;
        }
        field(12; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Documented,Cash Dispute,Documentation Dispute,Verified,Active,Death Claim,Maturity Claim,Maturity Dispute,Matured,Dispute,Blocked (Loan),Cancelled,Completed';
            OptionMembers = Open,Documented,"Cash Dispute","Documentation Dispute",Verified,Active,"Death Claim","Maturity Claim","Maturity Dispute",Matured,Dispute,"Blocked (Loan)",Cancelled,Completed;
        }
        field(13; "User Id"; Code[20])
        {
            Editable = false;
            TableRelation = User;
        }
        field(14; Amount; Decimal)
        {
            Description = 'Investment Amount';
            Editable = false;
        }
        field(15; "Posting Date"; Date)
        {
            Editable = false;
        }
        field(16; "Document Date"; Date)
        {
            Editable = false;
        }
        field(17; "Investment Frequency"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Monthly,Quarterly,Half Yearly,Annually';
            OptionMembers = " ",Monthly,Quarterly,"Half Yearly",Annually;
        }
        field(18; "Return Frequency"; Option)
        {
            Description = 'prev Dateformula';
            Editable = false;
            OptionCaption = ' ,Monthly,Quarterly,Half Yearly,Annually';
            OptionMembers = " ",Monthly,Quarterly,"Half Yearly",Annually;
        }
        field(19; "Service Charge Amount"; Decimal)
        {
            Editable = false;
        }
        field(21; "Bond Category"; Option)
        {
            Editable = false;
            OptionMembers = "A Type","B Type";
        }
        field(22; "Posted Doc No."; Code[20])
        {
            Editable = false;
        }
        field(23; "Discount Amount"; Decimal)
        {
            Editable = false;
        }
        field(24; "Return Payment Mode"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Cash,Cheque,D.D.,Banker''s Cheque,P.O.,Cheque by Post,NEFT,Stopped,NEFT Updated';
            OptionMembers = " ",Cash,Cheque,"D.D.","Banker's Cheque","P.O.","Cheque by Post",NEFT,Stopped,"NEFT Updated";
        }
        field(25; "Received From"; Option)
        {
            Editable = false;
            OptionMembers = " ","Marketing Member","Bond Holder";
        }
        field(26; "Received From Code"; Code[20])
        {
            Editable = false;
            TableRelation = IF ("Received From" = CONST("Marketing Member")) Vendor."No."
            ELSE IF ("Received From" = CONST("Bond Holder")) Customer."No.";
        }
        field(27; "Version No."; Integer)
        {
            Editable = false;
        }
        field(28; "Maturity Bonus Amount"; Decimal)
        {
            Editable = false;
        }
        field(29; "Creation Time"; Time)
        {
            Editable = false;
        }
        field(30; "Customer No. 2"; Code[20])
        {
            TableRelation = Customer;
        }
        field(32; "Bond Posting Group"; Code[20])
        {
            Editable = false;
            TableRelation = "Confirmed Order";
        }
        field(34; "Investment Type"; Option)
        {
            Caption = 'Investment Type';
            Editable = false;
            OptionCaption = ' ,RD,FD,MIS';
            OptionMembers = " ",RD,FD,MIS;
        }
        field(35; "Dispute Remark"; Text[50])
        {
            Editable = false;
        }
        field(36; "Return Bank Account Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Customer Bank Account" WHERE("Customer No." = FIELD("Customer No."),
                                                           Code = FIELD("Return Bank Account Code"));
        }
        field(37; "Return Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Return Amount';
            Editable = false;
        }
        field(38; "With Cheque"; Boolean)
        {
            Editable = false;
        }
        field(39; "Last Certificate Printed On"; Date)
        {
            CalcFormula = Max("Unit Print Log".Date WHERE("Unit No." = FIELD("Unit No."),
                                                           "Report Type" = CONST(Certificate)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Unit No.")
        {
            Clustered = true;
        }
        key(Key2; "Investment Type", "Unit No.", "Introducer Code", Status, "Return Payment Mode")
        {
        }
        key(Key3; Status, "Unit No.")
        {
        }
        key(Key4; "Project Type", "Posting Date", Duration, "Bond Category", "Unit No.", "Application No.")
        {
        }
        key(Key5; "Introducer Code", "Posting Date")
        {
        }
        key(Key6; "Shortcut Dimension 1 Code", "Project Type", "Return Frequency", Duration, "Unit No.", "Return Payment Mode")
        {
        }
        key(Key7; "Project Type", "Scheme Code", "Shortcut Dimension 1 Code", "Maturity Date", "Unit No.", Status)
        {
        }
        key(Key8; "Customer No.", "Return Bank Account Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        SchemeHeader: Record "Document Type Initiator";
        Text001: Label 'You cannot rename a %1.';


    procedure TotalApplicationAmount(): Decimal
    begin
    end;
}

