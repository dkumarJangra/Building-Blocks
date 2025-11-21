tableextension 50025 "BBG G/L Budget Entry Ext" extends "G/L Budget Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Budget Allocated"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Line Amount" WHERE("Enquiry No." = FIELD("Budget Name"),
                                                                   "Enquiry Line No." = FIELD("Entry No."),
                                                                   "Document Type" = FILTER(Order)));
            Description = 'JPL03: to identify budget allocated on PO Lines--JPL';
            Enabled = false;
            FieldClass = FlowField;
        }
        field(50001; "Account Name"; Text[100])
        {
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("G/L Account No.")));
            Description = '--JPL';
            FieldClass = FlowField;
        }
        field(50002; "Budget Consumed"; Decimal)
        {
            // CalcFormula = Sum("Purch. Inv. Line"."Line Amount" WHERE(Field50001 = FIELD("Budget Name"),
            //                                                           Field50002 = FIELD("Entry No.")));
            // Description = 'JPL03: to identify budget allocated on PO Lines--JPL';
            // Enabled = false;
            // FieldClass = FlowField;
        }
        field(50003; "Budget Base Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50004; "Budget Taxes Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50005; "Job Lines"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Job Contract Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 041011';
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