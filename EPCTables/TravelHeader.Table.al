table 97834 "Travel Header"
{
    DrillDownPageID = "Travel List";
    LookupPageID = "Travel List";

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Team Lead"; Code[20])
        {
            TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)" | "CP(Channel Partner)"));

            trigger OnValidate()
            begin
                IF "Team Lead" <> '' THEN
                    IF Vend.GET("Team Lead") THEN BEGIN
                        "Associate Name" := Vend.Name;
                        Vend.TESTFIELD("BBG Black List", FALSE);
                    END ELSE
                        "Associate Name" := '';
            end;
        }
        field(3; "End Date"; Date)
        {

            trigger OnValidate()
            begin
                IF "End Date" < "Start Date" THEN
                    ERROR('End Date can not be less than Start Date');
            end;
        }
        field(4; "Project Code"; Code[20])
        {
            TableRelation = "Responsibility Center 1";
        }
        field(5; "Total Saleable Area"; Decimal)
        {
            CalcFormula = Sum("Travel Payment Details"."Saleable Area" WHERE("Document No." = FIELD("Document No."),
                                                                              Select = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Total Assigned Amount"; Decimal)
        {
            CalcFormula = Sum("Travel Payment Entry"."Amount to Pay" WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Project Rate"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                CALCFIELDS("Total Saleable Area");
                "Total Travell Amount" := "Project Rate" * "Total Saleable Area";
            end;
        }
        field(8; "Total Travell Amount"; Decimal)
        {
            CalcFormula = Sum("Travel Payment Details"."Total Amount Area" WHERE("Document No." = FIELD("Document No."),
                                                                                  Select = FILTER(true)));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CALCFIELDS("Total Assigned Amount");
                IF "Total Travell Amount" < "Total Assigned Amount" THEN
                    ERROR('Assigend amount must not be greater than Total Amount');
            end;
        }
        field(9; "Sent for Approval"; Boolean)
        {
        }
        field(10; Approved; Boolean)
        {
        }
        field(11; "Start Date"; Date)
        {
        }
        field(12; Month; Option)
        {
            OptionCaption = 'January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(13; Year; Integer)
        {
        }
        field(14; "Associate Name"; Text[60])
        {
        }
        field(15; Type; Option)
        {
            OptionCaption = 'Team,Individual';
            OptionMembers = Team,Individual;
        }
        field(16; "Branch Code"; Code[20])
        {
            TableRelation = Location.Code WHERE("BBG Branch" = FILTER(true));

            trigger OnValidate()
            begin
                IF "Branch Code" <> '' THEN BEGIN
                    IF Loc.GET("Branch Code") THEN
                        "Branch Name" := Loc.Name
                    ELSE
                        "Branch Name" := '';
                END
                ELSE
                    "Branch Name" := '';
            end;
        }
        field(17; "Branch Name"; Text[60])
        {
            Editable = false;
        }
        field(18; "Project Filter"; Text[200])
        {
        }
        field(19; "Top Person"; Code[20])
        {
            TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)" | "CP(Channel Partner)"));
        }
        field(20; "ARM TA Code"; Code[20])
        {
            Description = 'BBG1.2 191213';
        }
        field(21; "TA Month"; Integer)
        {
        }
        field(22; dimTACode; Code[20])
        {
        }
        field(23; "Receipt Cutoff Date"; Date)
        {
        }
        field(24; "Region/Rank Code"; Code[10])
        {
            TableRelation = "Rank Code Master";
        }
        field(50000; "Reversal Required"; Boolean)
        {
        }
        field(50001; "Company Name"; Text[30])
        {
            Editable = false;
            TableRelation = Company;
        }
        field(50002; "Document Date"; Date)
        {
        }
        field(50010; "TA Transfer in LLP"; Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
            SumIndexFields = "Project Rate";
        }
        key(Key2; "Top Person")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD("Sent for Approval", FALSE);
        TravelPaymentDetails.RESET;
        TravelPaymentDetails.SETRANGE("Document No.", "Document No.");
        IF TravelPaymentDetails.FINDFIRST THEN BEGIN
            REPEAT
                ConfORder.RESET;
                ConfORder.SETRANGE("No.", TravelPaymentDetails."Application No.");
                IF ConfORder.FINDFIRST THEN BEGIN
                    ConfORder."Travel Generate" := FALSE;
                    ConfORder.MODIFY;
                END;
            UNTIL TravelPaymentDetails.NEXT = 0;
            TravelPaymentDetails.DELETEALL;
        END;

        TravelPaymentEntry.RESET;
        TravelPaymentEntry.SETRANGE("Document No.", "Document No.");
        IF TravelPaymentEntry.FINDFIRST THEN
            TravelPaymentEntry.DELETEALL;
    end;

    trigger OnInsert()
    begin
        Unitsetup.GET;
        IF "Document No." = '' THEN
            "Document No." := NoseriesMgt.GetNextNo(Unitsetup."Travel No. Series", WORKDATE, TRUE);

        "Document Date" := TODAY;
    end;

    var
        Unitsetup: Record "Unit Setup";
        NoseriesMgt: Codeunit NoSeriesManagement;
        TravelPaymentDetails: Record "Travel Payment Details";
        TravelPaymentEntry: Record "Travel Payment Entry";
        Vend: Record Vendor;
        Loc: Record Location;
        ConfORder: Record "Confirmed Order";
}

