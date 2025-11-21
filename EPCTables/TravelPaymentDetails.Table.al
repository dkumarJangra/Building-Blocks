table 97830 "Travel Payment Details"
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
            Editable = false;
        }
        field(6; "Line no."; Integer)
        {
        }
        field(7; "Sub Associate Code"; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;

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
        field(9; "Creation Date"; Date)
        {
        }
        field(10; Post; Boolean)
        {
            Editable = false;
        }
        field(12; "Saleable Area"; Decimal)
        {
            Editable = false;
        }
        field(13; "Application No."; Code[20])
        {
            Editable = false;
            TableRelation = "Confirmed Order";
        }
        field(14; "Document No."; Code[20])
        {
            TableRelation = "Travel Header"."Document No." WHERE("Document No." = FIELD("Document No."));
        }
        field(15; "Total Area"; Decimal)
        {
        }
        field(16; Select; Boolean)
        {

            trigger OnValidate()
            begin
                IF NOT Select THEN BEGIN
                    "User ID" := '';
                    "Total Amount Area" := 0;
                    TravelPaymentEntry.RESET;
                    TravelPaymentEntry.SETRANGE("Document No.", "Document No.");
                    TravelPaymentEntry.SETRANGE("Application No.", "Application No.");
                    IF TravelPaymentEntry.FINDSET THEN BEGIN
                        REPEAT
                            TravelPaymentEntry."Total Area" := 0;
                            TravelPaymentEntry."Amount to Pay" := 0;
                            TravelPaymentEntry.MODIFY;
                        UNTIL TravelPaymentEntry.NEXT = 0;
                    END;
                END ELSE BEGIN
                    "User ID" := USERID;
                    TravelHdr.RESET;
                    IF TravelHdr.GET("Document No.") THEN BEGIN
                        "Total Amount Area" := "Saleable Area" * TravelHdr."Project Rate";
                    END;
                    TravelPaymentEntry.RESET;
                    TravelPaymentEntry.SETRANGE("Document No.", "Document No.");
                    TravelPaymentEntry.SETRANGE("Application No.", "Application No.");
                    IF TravelPaymentEntry.FINDSET THEN BEGIN
                        REPEAT
                            TravelPaymentEntry."Total Area" := "Saleable Area";
                            TravelPaymentEntry."Amount to Pay" := "Saleable Area" * TravelPaymentEntry."TA Rate";
                            TravelPaymentEntry.MODIFY;
                        UNTIL TravelPaymentEntry.NEXT = 0;
                    END;
                END;
            end;
        }
        field(17; "User ID"; Code[20])
        {
            Editable = false;
        }
        field(18; "Posting Date"; Date)
        {
            Editable = false;
        }
        field(19; Approved; Boolean)
        {
            Editable = false;
        }
        field(20; "Total Amount Area"; Decimal)
        {
        }
        field(21; "Sent for Approval"; Boolean)
        {
            Editable = false;
        }
        field(22; Month; Integer)
        {
        }
        field(23; Year; Integer)
        {
        }
        field(24; Type; Option)
        {
            OptionCaption = 'Team,Individual';
            OptionMembers = Team,Individual;
        }
        field(25; Reverse; Boolean)
        {
            Description = 'ALLETDK250413';
        }
        field(26; "TA Re Generated"; Boolean)
        {
            CalcFormula = Exist("Travel Payment Entry" WHERE("Application No." = FIELD("Application No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "Gross TA Rate"; Decimal)
        {
            CalcFormula = Sum("Travel Header"."Project Rate" WHERE("Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(28; "ARM TA Code"; Code[20])
        {
            CalcFormula = Lookup("Travel Header"."ARM TA Code" WHERE("Document No." = FIELD("Document No.")));
            Description = 'BBG1.2 230114';
            FieldClass = FlowField;
        }
        field(29; "Confirmed Order Date"; Date)
        {
            Description = 'BBG1.2 230114';
        }
        field(50000; "Application Exists"; Boolean)
        {
            Description = 'after 18 dec';
        }
        field(50001; "Application Date"; Date)
        {
            CalcFormula = Lookup("Confirmed Order"."Posting Date" WHERE("No." = FIELD("Application No.")));
            FieldClass = FlowField;
        }
        field(50002; "Transfer Document Data"; Boolean)
        {
            Description = 'for Trading company';
        }
        field(50003; "Data Transfer"; Boolean)
        {
        }
        field(50004; "Regd App"; Boolean)
        {
        }
        field(50006; Status; Option)
        {
            CalcFormula = Lookup("Confirmed Order".Status WHERE("No." = FIELD("Application No.")));
            Editable = true;
            FieldClass = FlowField;
            OptionCaption = 'Open,,,,,,,,,,,,Registered,Cancelled,Vacate,Forfeit';
            OptionMembers = Open,Documented,"Cash Dispute","Documentation Dispute",Verified,Active,"Death Claim","Maturity Claim","Maturity Dispute",Matured,Dispute,"Blocked (Loan)",Registered,Cancelled,Vacate,Forfeit;
        }
        field(50010; "Paid TA"; Decimal)
        {
            CalcFormula = Sum("Travel Payment Entry"."Amount to Pay" WHERE("Document No." = FIELD("Document No."),
                                                                            "Post Payment" = FILTER(true)));
            FieldClass = FlowField;
        }
        field(50011; "Payment Post Date"; Date)
        {
            CalcFormula = Lookup("Travel Payment Entry"."Payment PostDate" WHERE("Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(50012; "FIND Ent"; Boolean)
        {
        }
        field(50013; "App Transfer in LLp"; Boolean)
        {
            Editable = true;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line no.")
        {
        }
        key(Key2; "Project Code", "Associate Code", "Line no.")
        {
            Clustered = true;
        }
        key(Key3; "Project Code", "Document No.")
        {
            SumIndexFields = "Saleable Area";
        }
        key(Key4; "Project Code", "Associate Code", "Sub Associate Code")
        {
            SumIndexFields = "Saleable Area";
        }
        key(Key5; "Document No.", Select)
        {
            SumIndexFields = "Saleable Area", "Total Amount Area";
        }
        key(Key6; "Application No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF TrHeader.GET("Document No.") THEN
            ERROR('First delete the Header Part');
    end;

    var
        Vend: Record Vendor;
        DimValue: Record "Dimension Value";
        LedgerSetup: Record "General Ledger Setup";
        TravelHdr: Record "Travel Header";
        TravelPayDetails: Record "Travel Payment Details";
        TotalArea: Decimal;
        TAForm: Page "Travel Generation 1";
        TrHeader: Record "Travel Header";
        TravelPaymentEntry: Record "Travel Payment Entry";
}

