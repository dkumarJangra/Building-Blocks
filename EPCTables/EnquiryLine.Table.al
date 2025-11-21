table 97756 "Enquiry Line"
{
    // Alledk 090610 For Enquiry Report.


    fields
    {
        field(1; "Enquiry No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Type; Option)
        {
            OptionCaption = ' ,G/L Account,Item,Resources,Fixed Asset,Job Master';
            OptionMembers = " ","G/L Account",Item,Resources,"Fixed Asset","Job Master";
        }
        field(4; "No."; Code[20])
        {
            TableRelation = IF (Type = FILTER("G/L Account")) "G/L Account"
            ELSE IF (Type = FILTER(Item)) Item
            ELSE IF (Type = FILTER(Resources)) Resource
            ELSE IF (Type = FILTER("Fixed Asset")) "Fixed Asset"
            ELSE IF (Type = FILTER("Job Master")) "Job Master";

            trigger OnValidate()
            begin

                IF EnquiryHeader.GET("Enquiry No.") THEN
                    "Global Dimension 1 Code" := EnquiryHeader."Project Code";



                CASE Type OF
                    Type::"G/L Account":
                        BEGIN
                            IF GLAccount.GET("No.") THEN
                                Description := GLAccount.Name
                        END;
                    Type::Item:
                        BEGIN
                            IF Item.GET("No.") THEN
                                Description := Item.Description
                        END;
                    Type::"Fixed Asset":
                        BEGIN
                            IF FixedAssest.GET("No.") THEN
                                Description := FixedAssest.Description
                        END;
                    Type::Resources:
                        BEGIN
                            IF Resource.GET("No.") THEN
                                Description := Resource.Name
                        END;
                END
            end;
        }
        field(5; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(6; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(15; Description; Text[50])
        {
        }
        field(17; "Unit cost"; Decimal)
        {

            trigger OnValidate()
            begin
                "Line Amount" := "Unit cost" * Quantity;
            end;
        }
        field(18; "Line Amount"; Decimal)
        {
        }
        field(21; Quantity; Decimal)
        {

            trigger OnValidate()
            begin
                "Line Amount" := "Unit cost" * Quantity;
            end;
        }
        field(50034; "Location Code"; Code[20])
        {
            Editable = false;
            TableRelation = Location;
        }
        field(50035; "PR No."; Code[20])
        {
        }
        field(50036; "PR Line No."; Integer)
        {
        }
        field(50037; "Uint of Measure"; Code[10])
        {
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE IF (Type = CONST(Resources)) "Resource Unit of Measure".Code WHERE("Resource No." = FIELD("No."))
            ELSE
            "Unit of Measure";
        }
        field(50038; "Delivery Date"; Date)
        {
        }
        field(50039; Description2; Text[50])
        {
            Description = 'Alle SH for NASL';
        }
        field(50056; "Job No."; Code[20])
        {
            Description = 'AlleDK 090610 for Enquiry Report';
            TableRelation = Job;

            trigger OnValidate()
            begin
                //CheckStatus; // ALLEAA
            end;
        }
        field(50057; "Job Task No."; Code[20])
        {
            Description = 'AlleDK 090610 for Enquiry Report';
            TableRelation = "Job Task"."Job Task No." WHERE("Job No." = FIELD("Job No."));

            trigger OnValidate()
            begin
                //CheckStatus; // ALLEAA
            end;
        }
        field(90029; "Inspection by"; Text[30])
        {
        }
        field(90030; Source; Code[20])
        {
            TableRelation = Vendor;
        }
        field(90031; "Job Master Code"; Code[20])
        {
            Editable = false;
            TableRelation = "Job Master".Code;
        }
    }

    keys
    {
        key(Key1; "Enquiry No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Enquiry No.", "Job No.", "Job Task No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EnquiryHeader: Record "Vendor Enquiry Details";
        GLAccount: Record "G/L Account";
        Item: Record Item;
        FixedAssest: Record "Fixed Asset";
        Resource: Record Resource;
        INDhdr: Record "Purchase Request Header";
}

