tableextension 97047 "EPC Sales Line Ext" extends "Sales Line"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "BOQ Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 16-07-2007';
            Editable = false;
        }
        field(50011; "Upto Date Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 12-09-2007';
        }
        field(50002; "Qty Since Last Bill"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'ALLESP BCL0016 17-07-2007';
        }
        field(50018; "BOQ Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(50001; "IPA Qty"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Description = 'ALLESP BCL0016 17-07-2007';

            trigger OnValidate()
            begin
                Quantity := "IPA Qty";
                VALIDATE(Quantity);
            end;
        }
        field(50004; "Invoice Type1"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0006 27-07-2007';
            OptionCaption = 'Normal,RA,Escalation';
            OptionMembers = Normal,RA,Escalation;
        }
        field(80000; "Escalation Account"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'for client billing ALLEAB';

            trigger OnValidate()
            begin
                "Invoice Type1" := "Invoice Type1"::RA;
                "BOQ Rate Inclusive Tax" := TRUE;
            end;
        }
        field(90019; "BOQ Rate Inclusive Tax"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB20-03';
        }
        field(50019; "Steel Works"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'for client billing ALLEPS';
        }
        field(90020; "RIT Done"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB25-03';

            trigger OnValidate()
            begin
                IF "RIT Done" = FALSE THEN BEGIN
                    "RIT Tax" := 0;
                    //"Amount Including Tax" := 0;
                    //"Tax Base Amount" := 0;
                    //"Amount Added to Tax Base" := 0;
                END
            end;
        }
        field(50012; "Charge Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0016 20-09-2007';
            OptionCaption = ' ,Rent,Electricity,Water,Explosive,Materials,Others';
            OptionMembers = " ",Rent,Electricity,Water,Explosive,Materials,Others;
        }
        field(90021; "RIT Tax"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Super Area"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
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