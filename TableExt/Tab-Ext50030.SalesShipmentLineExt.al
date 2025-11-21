tableextension 50030 "BBG Sales Shipment Line Ext" extends "Sales Shipment Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
        }
        field(50000; "BOQ Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 16-07-2007';
            TableRelation = "BOQ Item";

            trigger OnValidate()
            var
                JobMst: Record "BOQ Item";
                DimVal: Record "Dimension Value";
            begin
            end;
        }
        field(50008; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 24-08-2007';

            trigger OnValidate()
            var
                JobMst: Record "BOQ Item";
                DimVal: Record "Dimension Value";
            begin
            end;
        }
        field(50020; "Explode Bom Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 060512';
            Editable = false;
        }
        field(90023; "Tender Rate"; Decimal)
        {
            Caption = 'Tender Rate';
            DataClassification = ToBeClassified;
            Description = 'ALLERP KRN0008 18-08-2010:';
            Editable = true;
        }
        field(90024; "Premium/Discount Amount"; Decimal)
        {
            Caption = 'Premium/Discount Amount';
            DataClassification = ToBeClassified;
            Description = 'ALLERP KRN0008 18-08-2010:';
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