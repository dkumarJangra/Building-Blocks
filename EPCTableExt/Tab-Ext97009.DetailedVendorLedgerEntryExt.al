tableextension 97009 "EPC Dtled Vend Ledg. Entry Ext" extends "Detailed Vendor Ledg. Entry"
{
    fields
    {
        // Add changes to table fields here
        field(90016; "Posting Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL,ALLERE';
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD,Mobilization Advance,Equipment Advance,,,,Commission,Travel Allowance,Bonanza,Incentive,CommAndTA';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance",,,,Commission,"Travel Allowance",Bonanza,Incentive,CommAndTA;
        }
        field(50104; "Land Agreement No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90050; "Order Ref No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
        }
        field(90051; "Milestone Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
        }
        field(90052; "Ref Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
            OptionCaption = ' ,Order,,,Blanket Order';
            OptionMembers = " ","Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(90063; "Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            TableRelation = Job;
        }
        field(90064; "Broker Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERE';
            //TableRelation = Vendor."No." WHERE("Vendor Type" = FILTER(Broker));
        }
        field(90065; "Tran Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionCaption = ' ,Purchase,Sale';
            OptionMembers = " ",Purchase,Sale;
        }

    }

    keys
    {
        key(Key50001; "Vendor No.", "Posting Date", "Entry Type")
        {
            SumIndexFields = Amount, "Amount (LCY)";
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}