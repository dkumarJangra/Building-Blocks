table 97816 "Unit & Comm. Creation Buffer"
{
    DrillDownPageID = "FA Purchase Request Subform";
    LookupPageID = "FA Purchase Request Subform";

    fields
    {
        field(1; "Unit No."; Code[20])
        {
            TableRelation = "Confirmed Order";
        }
        field(2; "Installment No."; Integer)
        {
        }
        field(3; "Posting Date"; Date)
        {
        }
        field(4; "Introducer Code"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(5; "Base Amount"; Decimal)
        {
        }
        field(6; "Project Type"; Code[20])
        {
            TableRelation = "Unit Type".Code;
        }
        field(7; Duration; Integer)
        {
        }
        field(8; "Year Code"; Integer)
        {
        }
        field(9; "Investment Type"; Option)
        {
            Caption = 'Investment Type';
            OptionCaption = ' ,RD,FD,MIS';
            OptionMembers = " ",RD,FD,MIS;
        }
        field(10; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                RespCenter.RESET;
                RespCenter.SETRANGE(Code, "Shortcut Dimension 1 Code");
                IF RespCenter.FINDFIRST THEN
                    "Branch Code" := RespCenter.Branch;
            end;
        }
        field(11; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(12; "Bond Created"; Boolean)
        {
        }
        field(13; "Application No."; Code[20])
        {
        }
        field(14; "Commission Created"; Boolean)
        {
            Editable = true;
        }
        field(15; "Paid by cheque"; Boolean)
        {
        }
        field(16; "Milestone Code"; Code[10])
        {
        }
        field(17; "Direct Associate"; Boolean)
        {
        }
        field(18; "Min. Allotment Amount Not Paid"; Boolean)
        {
        }
        field(19; "Cheque No."; Code[20])
        {
        }
        field(20; "Cheque not Cleared"; Boolean)
        {
        }
        field(21; "Cheque Cleared Date"; Date)
        {
            Description = 'AlleDK 180113';
        }
        field(22; "Posted document No"; Code[20])
        {
        }
        field(23; "Update entries"; Boolean)
        {
        }
        field(24; "Opening Commision Adj."; Boolean)
        {
        }
        field(50001; "Branch Code"; Code[20])
        {
        }
        field(50002; "Comm Not Release after FullPmt"; Boolean)
        {
        }
        field(50003; "Charge Code"; Code[10])
        {
            Editable = true;
        }
        field(50004; "Unit Payment Line No."; Integer)
        {
        }
        field(50005; "insert Entry"; Boolean)
        {
        }
        field(50006; "Creation Date"; Date)
        {
        }
        field(50007; "Application DOJ"; Date)
        {
            CalcFormula = Lookup("Confirmed Order"."Posting Date" WHERE("No." = FIELD("Unit No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; "Commission Not Generate"; Boolean)
        {
            CalcFormula = Lookup("Confirmed Order"."Commission Not Generate" WHERE("No." = FIELD("Unit No.")));
            FieldClass = FlowField;
        }
        field(50009; "Vizag data"; Boolean)
        {
        }
        field(50010; "Balance CommissionAmt"; Decimal)
        {
            Editable = false;

        }
    }

    keys
    {
        key(Key1; "Unit No.", "Installment No.", "Milestone Code")
        {
            Clustered = true;
        }
        key(Key2; "Posting Date")
        {
        }
        key(Key3; "Unit No.", "Charge Code", "Unit Payment Line No.", "Commission Created", "Direct Associate")
        {
            SumIndexFields = "Base Amount";
        }
        key(Key4; "Commission Created")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label '%1 already exists.';
        Text002: Label 'You cannot rename a %1.';
        SchemeHeader: Record "Document Type Initiator";
        BondSetup: Record "Unit Setup";
        UserSetup: Record "User Setup";
        Customer: Record Customer;
        PaymentMethod: Record "Payment Method";
        BondPostingGroup: Record "ID 2 Group";
        PostPayment: Codeunit PostPayment;
        Text003: Label 'Please select correct Investment Amount';
        RespCenter: Record "Responsibility Center 1";


    procedure GetIntroducerCode(BondNo: Code[20]): Code[20]
    var
        Appl: Record Application;
        Bond: Record "Confirmed Order";
    begin
        IF Bond.GET(BondNo) THEN
            EXIT(Bond."Introducer Code")
        ELSE BEGIN
            Appl.RESET;
            Appl.SETRANGE("Unit No.", BondNo);
            IF Appl.FINDFIRST THEN
                EXIT(Appl."Associate Code")
        END;
    end;
}

