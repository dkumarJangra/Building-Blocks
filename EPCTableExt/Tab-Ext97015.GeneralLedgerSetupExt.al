tableextension 97015 "EPC General Ledger Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        // Add changes to table fields here
        field(60000; "FD No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50030; "FD Template Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(50031; "FD Liquidation Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("FD Template Name"));
        }
        field(50032; "FD Liquidation Account Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                IF "FD Liquidation Account Code" <> '' THEN
                    IF GLAccount.GET("FD Liquidation Account Code") THEN
                        GLAccount.TESTFIELD(GLAccount."Direct Posting");
            end;
        }
        field(50033; "FD Placement Account Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                IF "FD Placement Account Code" <> '' THEN
                    IF GLAccount.GET("FD Placement Account Code") THEN
                        GLAccount.TESTFIELD(GLAccount."Direct Posting");
            end;
        }
        field(50034; "FD Placement Batch Name"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("FD Template Name"));
        }
        field(50035; "FD Liquidation Interest Acc."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                IF "FD Liquidation Interest Acc." <> '' THEN
                    IF GLAccount.GET("FD Liquidation Interest Acc.") THEN
                        GLAccount.TESTFIELD(GLAccount."Direct Posting");
            end;
        }
        field(50036; "FD Placement Dimension Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Global Dimension 1 Code"));
        }
        field(50037; "FD Liquidation Dimension Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FIELD("Global Dimension 1 Code"));
        }

        field(60001; "FD Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account" WHERE("Direct Posting" = FILTER(true));
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
        GLAccount: Record "G/L Account";
}