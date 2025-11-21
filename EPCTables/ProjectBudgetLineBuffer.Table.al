table 97768 "Project Budget Line Buffer"
{
    // ALLEAA -  New Field Added
    // AALEPG 090209 : Added new fields.
    // ALLERP KRN0008 18-08-2010: Field 90026 and 90027 added

    Caption = 'Project Budget Line Buffer';
    //DrillDownPageID = 216;
    //LookupPageID = 216;

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;
        }
        field(2; "Phase Code"; Code[10])
        {
            Caption = 'Phase Code';
            //TableRelation = Table161;
        }
        field(3; "Task Code"; Code[10])
        {
            Caption = 'Task Code';
            //TableRelation = Table162;
        }
        field(4; "Step Code"; Code[10])
        {
            Caption = 'Step Code';
            //TableRelation = Table163;
        }
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Resource,Item,G/L Account, ';
            OptionMembers = Resource,Item,"G/L Account","Group (Resource)";
        }
        field(6; "No."; Code[20])
        {
            Caption = 'Sale';
            TableRelation = IF (Type = CONST(Resource)) Resource
            ELSE
            IF (Type = CONST(Item)) Item
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE IF (Type = CONST("Group (Resource)")) "Resource Group";

            trigger OnValidate()
            begin
                IF "No." = '' THEN
                    EXIT;

                CASE Type OF
                    Type::"G/L Account":
                        BEGIN
                            GLAcc.GET("No.");
                            GLAcc.CheckGLAcc;
                            GLAcc.TESTFIELD("Direct Posting", TRUE);
                        END;
                END;
            end;
        }
        field(7; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            FieldClass = Normal;
        }
        field(10; "Direct Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
        }
        field(11; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
        }
        field(13; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(27; "User ID"; Code[20])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
            end;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));
        }
        field(90001; "BOQ Code"; Code[20])
        {
        }
        field(90002; "Description 2"; Text[50])
        {
        }
        field(90003; "Ending Date"; Date)
        {
        }
        field(90004; "Unit of Measure"; Code[20])
        {
            Editable = false;
            TableRelation = "Unit of Measure";
        }
        field(90013; "Entry No."; Integer)
        {
            TableRelation = "BOQ Item"."Entry No." WHERE("Project Code" = FIELD("Job No."));

            trigger OnValidate()
            var
                BOQMst: Record "BOQ Item";
            begin
            end;
        }
        field(90014; Bold; Boolean)
        {
        }
        field(90015; Indentation; Integer)
        {
        }
        field(90016; Usage; Code[20])
        {
            Caption = 'Usage';
            TableRelation = IF (Type = CONST(Resource)) Resource
            ELSE IF (Type = CONST(Item)) Item
            ELSE IF (Type = CONST("G/L Account")) "G/L Account"
            ELSE IF (Type = CONST("Group (Resource)")) "Resource Group";

            trigger OnValidate()
            begin
                IF Usage = '' THEN
                    EXIT;

                CASE Type OF
                    Type::"G/L Account":
                        BEGIN
                            GLAcc.GET(Usage);
                            GLAcc.CheckGLAcc;
                            GLAcc.TESTFIELD("Direct Posting", TRUE);
                        END;
                END;
            end;
        }
        field(90022; "BOQ Type"; Option)
        {
            Caption = 'BOQ Type';
            Description = 'ALLEAA';
            Editable = false;
            OptionCaption = ' ,Sale,Purchase';
            OptionMembers = " ",Sale,Purchase;
        }
        field(90023; "Shortcut Dimension 2 Code"; Code[20])
        {
            Description = 'ALLEPG';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(90024; "G/L Account"; Code[20])
        {
            Description = 'ALLEPG';
            TableRelation = "G/L Account";
        }
        field(90026; "BOQ Tender Rate"; Decimal)
        {
            Caption = 'Tender Rate';
            Description = 'ALLERP KRN0008 18-08-2010:';
        }
        field(90027; "BOQ Tender Amount"; Decimal)
        {
            Caption = 'Premium/Discount Amount';
            Description = 'ALLERP KRN0008 18-08-2010:';
        }
    }

    keys
    {
        key(Key1; "Job No.", "Phase Code", "Task Code", "Step Code", Type)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label 'It is not allowed to rename %1. ';
        Text001: Label 'Delete this line and enter a new line.';
        GLAcc: Record "G/L Account";
}

