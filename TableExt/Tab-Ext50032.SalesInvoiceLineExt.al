tableextension 50032 "BBG Sales Invoice Line Ext" extends "Sales Invoice Line"
{
    fields
    {
        // Add changes to table fields here
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
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
        field(50018; "BOQ Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50019; "Steel Works"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'for client billing ALLEPS';
        }
        field(50020; "Explode Bom Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 060512';
            Editable = false;
        }
        field(80000; "Escalation Account"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'for client billing ALLEAB';
        }
        field(90019; "BOQ Rate Inclusive Tax"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB20-03';
        }
        field(90022; "Phase Code 1"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'Upgrade';
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
        field(90025; "Application No."; Code[20])
        {
            CalcFormula = Lookup("Sales Invoice Header"."Application No." WHERE("No." = FIELD("Document No.")));
            FieldClass = FlowField;
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