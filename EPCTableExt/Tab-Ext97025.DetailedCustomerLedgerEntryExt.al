tableextension 97025 "EPC Dted Cust. Ledg. Entry Ext" extends "Detailed Cust. Ledg. Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50005; "User Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0014 22-08-2007';
            TableRelation = Job;
        }
        field(60002; "Posting Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'VSID 0051 ALLE NAM, ALLERE';
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD,Mobilization Advance,Equipment Advance,,,,Commission,Travel Allowance,Bonanza,Incentive';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance",,,,Commission,"Travel Allowance",Bonanza,Incentive;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
            end;
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