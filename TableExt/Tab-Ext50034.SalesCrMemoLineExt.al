tableextension 50034 "BBG Sales Cr. Memo Line Ext" extends "Sales Cr.Memo Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
        }
        field(50000; "BOQ Item Code"; Code[20])
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
        field(50001; "IPA Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'ALLESP BCL0016 17-07-2007';
        }
        field(50002; "Qty Since Last Bill"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'ALLESP BCL0016 17-07-2007';
        }
        field(50003; "Escalation Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
            OptionCaption = ' ,Labour,Cement,Steel,Bitumen,POL,Plant & Machinery,Explosives,Detonator,Others';
            OptionMembers = " ",Labour,Cement,Steel,Bitumen,POL,"Plant & Machinery",Explosives,Detonator,Others;
        }
        field(50004; "Invoice Type1"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
            OptionCaption = 'Normal,RA,Escalation';
            OptionMembers = Normal,RA,Escalation;
        }
        field(50005; "Present Price Index"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
        }
        field(50006; "Old Price Index"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
        }
        field(50007; "Escalation Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
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
        field(50010; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 17-07-2007';
            TableRelation = Job;
        }
        field(50011; "Upto Date Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 12-09-2007';
        }
        field(50012; "Charge Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 20-09-2007';
            OptionCaption = ' ,Rent,Electricity,Water,Explosive,Materials,Others';
            OptionMembers = " ",Rent,Electricity,Water,Explosive,Materials,Others;
        }
        field(90023; "Tender Rate"; Decimal)
        {
            Caption = 'Tender Rate';
            DataClassification = ToBeClassified;
            Description = 'ALLERP KRN0008 18-08-2010:';
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