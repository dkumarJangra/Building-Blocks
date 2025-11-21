tableextension 97048 "EPC TDS Entry Ext" extends "TDS Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Region Dimension code"; Code[20])
        {
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            Description = 'ALLEAB';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50002; "Clearing date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Entry find"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Applied Ass TDS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Ass Applied amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Applied Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90118; "TDSAmt for Associate"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum("G/L Entry".Amount WHERE("Document No." = FIELD("Document No."),
                                                         "G/L Account No." = FILTER(116400),
                                                         "Document Type" = FIELD("Document Type")));

        }
        field(90119; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
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