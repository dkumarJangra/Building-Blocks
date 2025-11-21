tableextension 50008 "BBG Vendor Ledger Entry Ext" extends "Vendor Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "Advance Amt"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor Ledger Entry No." = FIELD("Entry No."),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Posting Type" = FILTER(Advance),
                                                                          "Order Ref No." = FIELD("Order Ref No."),
                                                                          "Milestone Code" = FIELD("Milestone Code"),
                                                                          "Ref Document Type" = FIELD("Ref Document Type")));
            Description = 'AlleBLK';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Running Amt"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor Ledger Entry No." = FIELD("Entry No."),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Posting Type" = FILTER(Running),
                                                                          "Order Ref No." = FIELD("Order Ref No."),
                                                                          "Milestone Code" = FIELD("Milestone Code"),
                                                                          "Ref Document Type" = FIELD("Ref Document Type")));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Retention Amt"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor Ledger Entry No." = FIELD("Entry No."),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Posting Type" = FILTER(Retention),
                                                                          "Order Ref No." = FIELD("Order Ref No."),
                                                                          "Milestone Code" = FIELD("Milestone Code"),
                                                                          "Ref Document Type" = FIELD("Ref Document Type")));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Secured Advance Amt"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor Ledger Entry No." = FIELD("Entry No."),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Posting Type" = FILTER("Secured Advance"),
                                                                          "Order Ref No." = FIELD("Order Ref No."),
                                                                          "Milestone Code" = FIELD("Milestone Code"),
                                                                          "Ref Document Type" = FIELD("Ref Document Type")));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Adhoc Advance Amt"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor Ledger Entry No." = FIELD("Entry No."),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Posting Type" = FILTER("Adhoc Advance"),
                                                                          "Order Ref No." = FIELD("Order Ref No."),
                                                                          "Milestone Code" = FIELD("Milestone Code"),
                                                                          "Ref Document Type" = FIELD("Ref Document Type")));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Provisional Amt"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor Ledger Entry No." = FIELD("Entry No."),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Posting Type" = FILTER(Provisional),
                                                                          "Order Ref No." = FIELD("Order Ref No."),
                                                                          "Milestone Code" = FIELD("Milestone Code"),
                                                                          "Ref Document Type" = FIELD("Ref Document Type")));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "LD Amt"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor Ledger Entry No." = FIELD("Entry No."),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Posting Type" = FILTER(LD),
                                                                          "Order Ref No." = FIELD("Order Ref No."),
                                                                          "Milestone Code" = FIELD("Milestone Code"),
                                                                          "Ref Document Type" = FIELD("Ref Document Type")));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Vendor Invoice Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'Alle VK VSID are added for Report Booking Voucher (ID 50025)--JPL';
            Editable = false;
        }
        field(50021; "Entry Project Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'INS1.0';
            Editable = false;
        }


        field(50102; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "IC Land Purchase"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50244; "Cheque No.1"; Code[20])
        {
            CalcFormula = Lookup("Bank Account Ledger Entry"."Cheque No.1" WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(55009; "Tranasaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Trading';
            OptionMembers = " ",Trading;
        }
        field(60010; "Emp Advance Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            Editable = false;
            OptionCaption = ' ,Travel Advance,Salary Advance,LTA Advance,Other Advance,Amex Corporate Card';
            OptionMembers = " ",Travel,Salary,LTA,Other,Amex;
        }
        field(70030; "Provisional Bill"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            Editable = false;
        }
        field(70031; "Club 9 Entry"; Boolean)
        {
            DataClassification = ToBeClassified;

            Editable = false;
        }
        field(70032; "Region Code"; Code[20])
        {
            DataClassification = ToBeClassified;

            Editable = false;
            TableRelation = "Rank Code Master";
        }
        field(70033; "Region Code Description"; TExt[50])
        {
            DataClassification = ToBeClassified;

            Editable = false;
        }
        field(70034; "Rank Code"; Decimal)
        {
            DataClassification = ToBeClassified;
            TableRelation = Rank;

            Editable = false;
        }
        field(70035; "Rank Description"; Text[30])
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