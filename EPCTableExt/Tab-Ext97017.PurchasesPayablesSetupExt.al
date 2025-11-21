tableextension 97017 "EPC Purch & Payables Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Material Issue Note"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "No. Series";
        }
        field(50002; "Material Return Note"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "No. Series";
        }
        field(50010; "Budget Check For PO Required"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50003; "Outward Gate Pass"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "No. Series";
        }
        field(50004; "Inward Gate Pass"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "No. Series";
        }
        field(50030; "Consumption FOC Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 180412';
            TableRelation = "No. Series";
        }
        field(50031; "Consumption Chargable Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 180412';
            TableRelation = "No. Series";
        }
        field(50032; "FG Recipt Nos."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'RAHEE1.00 060512';
            TableRelation = "No. Series";
        }
        field(50033; "Incentive No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLENB 051112';
            TableRelation = "No. Series";
        }
        field(50034; "Incentive Unit Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLENB 061112';
            TableRelation = "No. Series";
        }
        field(50015; "Job No"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAB001';
            TableRelation = "No. Series";
        }
        field(50000; "Indent Nos"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "No. Series";
        }
        field(50018; "Enquiry No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'KLND1.00';
            TableRelation = "No. Series".Code;
        }
        field(50009; "Rejection No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            TableRelation = "No. Series";
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