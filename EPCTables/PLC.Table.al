table 97776 PLC
{
    Caption = 'PLC';
    LookupPageID = "PLC List";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[60])
        {
        }
        field(3; "Rate (sq ft)"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Fixed Amount", 0);
                TESTFIELD("PLC %", 0);
            end;
        }
        field(4; "Discount Applicable"; Boolean)
        {
        }
        field(5; "Job Code"; Code[20])
        {
            Caption = 'Project Code';
            TableRelation = Job."No.";
        }
        field(6; "Fixed Amount"; Decimal)
        {
            Description = 'ALLEAB for BLK';

            trigger OnValidate()
            begin
                TESTFIELD("Rate (sq ft)", 0);
                TESTFIELD("PLC %", 0);
            end;
        }
        field(7; "PLC %"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Fixed Amount", 0);
                TESTFIELD("Rate (sq ft)", 0);
            end;
        }
        field(8; "PLC % Amount"; Decimal)
        {
        }
        field(9; "PLC Dependency Code"; Code[20])
        {
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Project Price Groups"),
                                                          "Project Code" = FIELD("Job Code"));

            trigger OnValidate()
            begin
                TESTFIELD("PLC %");
                PPGRec.RESET;
                PPGRec.SETFILTER(PPGRec."Project Price Group", "PLC Dependency Code");
                PPGRec.SETRANGE(PPGRec."Project Code", "Job Code");
                IF PPGRec.FINDLAST THEN BEGIN
                    DocMastRec.RESET;
                    DocMastRec.SETRANGE("Document Type", DocMastRec."Document Type"::"Project Price Groups");
                    DocMastRec.SETFILTER(DocMastRec."Project Code", "Job Code");
                    DocMastRec.SETFILTER(Code, "PLC Dependency Code");
                    IF DocMastRec.FINDFIRST THEN BEGIN
                        IF DocMastRec."Sale/Lease" = DocMastRec."Sale/Lease"::Sale THEN
                            "PLC % Amount" := PPGRec."Sales Rate (per sq ft)" * "PLC %" / 100;
                        IF DocMastRec."Sale/Lease" = DocMastRec."Sale/Lease"::Lease THEN
                            "PLC % Amount" := PPGRec."Lease Rate (per sq ft)" * "PLC %" / 100;
                    END;
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Job Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PPGRec: Record "Project Price Group Details";
        DocMastRec: Record "Document Master";
}

