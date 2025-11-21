table 50004 "Project Milestone Line"
{
    DataCaptionFields = "Document Type", "Code", Description;
    DataPerCompany = false;
    DrillDownPageID = "Document Master";
    LookupPageID = "Document Master";

    fields
    {
        field(1; "Document No."; Integer)
        {
            Editable = false;
            TableRelation = "Project Milestone Header"."Document No." WHERE("Document No." = FIELD("Document No."));
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(3; "Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Unit Charge & Payment Pl. Code";

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(4; "Document Type"; Option)
        {
            Editable = false;
            OptionCaption = ',Unit,Zone,Charge,Brand,Payment Plan,Co-Applicants,Project Price Groups';
            OptionMembers = ,Unit,Zone,Charge,Brand,"Payment Plan","Co-Applicants","Project Price Groups";

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(5; Description; Text[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(6; "Project Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Responsibility Center 1";

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(7; "Rate/Sq. Yd"; Decimal)
        {
            DecimalPlaces = 0 : 4;
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(8; "Fixed Price"; Decimal)
        {
            DecimalPlaces = 0 : 4;
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(9; "BP Dependency"; Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(10; "Rate Not Allowed"; Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(11; "Project Price Dependency Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Project Price Groups"),
                                                          "Project Code" = FIELD("Project Code"),
                                                          "Sale/Lease" = FIELD("Sale/Lease"));

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(12; "Payment Plan Type"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Construction Linked,Down Payment,Time Linked,Special,Others';
            OptionMembers = " ","Construction Linked","Down Payment","Time Linked",Special,Others;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(13; "Sale/Lease"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Sale,Lease';
            OptionMembers = " ",Sale,Lease;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(14; "Commision Applicable"; Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(15; "Direct Associate"; Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(16; Sequence; Integer)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(18; "Membership Fee"; Boolean)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(19; "App. Charge Code"; Code[20])
        {
            Editable = false;
            TableRelation = "App. Charge Code";

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(20; "App. Charge Name"; Text[60])
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(22; Status; Option)
        {
            Description = 'ALLECK 040113';
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(25; "Effective From Date"; Date)
        {
            Editable = false;
        }
        field(26; "Effective To Date"; Date)
        {
            Editable = false;
        }
        field(27; "First Milestone %"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
                IF "First Milestone %" < 0 THEN
                    ERROR('Value must be Positive');
                IF "First Milestone %" > 100 THEN
                    ERROR('First Milestone % can not be greater than 100');
                TESTFIELD("Commision Applicable", TRUE);
                "Second Milestone %" := 100 - "First Milestone %";
            end;
        }
        field(28; "Second Milestone %"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Project Code", "Effective From Date", "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

