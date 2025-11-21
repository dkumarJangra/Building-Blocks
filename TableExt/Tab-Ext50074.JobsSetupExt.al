tableextension 50074 "BBG Jobs Setup Ext" extends "Jobs Setup"
{
    fields
    {
        // Add changes to table fields here

        field(50002; "Default project Budget Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERP';
            TableRelation = "G/L Budget Name".Name;
        }
        field(50003; "Transporting Charges"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERP';
            TableRelation = "G/L Account";
        }
        field(50004; Material; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERP';
            TableRelation = "G/L Account";
        }
        field(50005; "Sub- contractor (Drain)"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERP';
            TableRelation = "G/L Account";
        }
        field(50006; "Sub- contractor (Concrete)"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERP';
            TableRelation = "G/L Account";
        }
        field(50007; "Direct Salary Exp. Acc."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERP';
            TableRelation = "G/L Account";
        }
        field(50008; "Type of Work Dimension"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERP';
            TableRelation = Dimension.Code;
        }
        field(50009; "Machinery Hire Charges"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERP';
            TableRelation = "G/L Account";
        }
        field(50011; "Staff Salary"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Alle RP';
            TableRelation = "G/L Account";
        }
        field(90001; "Project Dimension"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            TableRelation = Dimension.Code;
        }
        field(90002; "Project Unit Dimension"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            TableRelation = Dimension.Code;
        }
        field(90003; "Project Unit of Measure"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            TableRelation = "Unit of Measure".Code;
        }
        field(90004; "Project Unit Item Category"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            TableRelation = "Item Category".Code WHERE(Property = FILTER(true));
        }
        field(90006; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Description = 'RAHEE 1.00 020512';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}