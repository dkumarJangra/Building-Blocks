table 97832 "Travel Payment / Bank Entry"
{

    fields
    {
        field(1; "Project Code"; Code[20])
        {
            TableRelation = "Responsibility Center 1";

            trigger OnValidate()
            begin
                LedgerSetup.GET;
                IF DimValue.GET(LedgerSetup."Global Dimension 1 Code", "Project Code") THEN
                    "Project Name" := DimValue.Name;
            end;
        }
        field(2; "Project Name"; Text[50])
        {
        }
        field(3; "Associate Code"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                IF "Associate Code" <> '' THEN BEGIN
                    IF Vend.GET("Associate Code") THEN
                        "Associate Name" := Vend.Name;
                END ELSE
                    "Associate Name" := '';
            end;
        }
        field(4; "Associate Name"; Text[60])
        {
            Editable = false;
        }
        field(5; "Amount to Pay"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Amount to Pay" > Amount THEN
                    ERROR('Amount to Pay can not be greater than Amount');

                "Amount to Associate" := Amount - "Amount to Pay";
            end;
        }
        field(7; "Sub Associate Code"; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                IF "Sub Associate Code" <> '' THEN BEGIN
                    IF Vend.GET("Sub Associate Code") THEN
                        "Sub Associate Name" := Vend.Name;
                END ELSE
                    "Sub Associate Name" := '';
            end;
        }
        field(8; "Sub Associate Name"; Text[60])
        {
            Editable = false;
        }
        field(9; "Posting Date"; Date)
        {
        }
        field(10; Post; Boolean)
        {
        }
        field(11; "Document No."; Code[20])
        {
        }
        field(12; "Line No."; Integer)
        {
        }
        field(13; "Total Area"; Decimal)
        {
            CalcFormula = Sum("Travel Payment Details"."Saleable Area" WHERE("Document No." = FIELD("Document No."),
                                                                              "Project Code" = FIELD("Project Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Amount to Associate"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                "Amount to Associate" := Amount - "Amount to Pay";
            end;
        }
        field(15; Rate; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                CALCFIELDS("Total Area");
                Amount := Rate * "Total Area";
                VALIDATE(Amount);
                VALIDATE("Amount to Pay");
            end;
        }
        field(16; Amount; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                "Amount to Associate" := Amount - "Amount to Pay";
            end;
        }
        field(17; "Cheque No."; Code[10])
        {
        }
        field(18; "Bank Acc. No."; Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                IF "Bank Acc. No." <> '' THEN
                    IF BAcc.GET("Bank Acc. No.") THEN
                        "Bank Name" := BAcc.Name;
            end;
        }
        field(19; "Cheque Date"; Date)
        {
        }
        field(20; "Bank Name"; Text[60])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
        key(Key2; "Project Code", "Associate Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TravelpaymentDetails.RESET;
        TravelpaymentDetails.SETRANGE("Document No.", "Document No.");
        IF TravelpaymentDetails.FINDSET THEN
            REPEAT
                TravelpaymentDetails.DELETEALL;
            UNTIL TravelpaymentDetails.NEXT = 0;
    end;

    var
        Vend: Record Vendor;
        DimValue: Record "Dimension Value";
        LedgerSetup: Record "General Ledger Setup";
        TravelpaymentDetails: Record "Travel Payment Details";
        BAcc: Record "Bank Account";
}

