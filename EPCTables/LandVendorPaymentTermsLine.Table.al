table 50056 "Land Vendor Payment Terms Line"
{
    DataPerCompany = true;
    DrillDownPageID = "Update BLEntry";
    LookupPageID = "Update BLEntry";

    fields
    {
        field(1; "Land Document No."; Code[20])
        {
        }
        field(2; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            Editable = false;
        }
        field(3; "Land Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Payment Term Code"; Code[20])
        {
            TableRelation = "Payment Terms".Code;

            trigger OnValidate()
            begin
                PaymentTerms.RESET;
                IF PaymentTerms.GET("Payment Term Code") THEN BEGIN
                    VALIDATE("Due Date Calculation", PaymentTerms."Due Date Calculation");
                END
            end;
        }
        field(6; "Actual Milestone"; Code[20])
        {
        }
        field(7; "Base Amount"; Decimal)
        {
        }
        field(8; "Calculation Type"; Option)
        {
            OptionMembers = "% age","Fixed Value";
        }
        field(10; "Calculation Value"; Decimal)
        {

            trigger OnValidate()
            begin
                CalculateCriteriaValue;
            end;
        }
        field(11; "Due Date Calculation"; DateFormula)
        {
            trigger OnValidate()
            var
                LandLeadOppHeader: Record "Land Lead/Opp Header";
            begin
                IF LandLeadOppHeader.GET(LandLeadOppHeader."Document Type"::Opportunity, "Land Document No.") THEN
                    "Due Date" := CALCDATE("Due Date Calculation", LandLeadOppHeader."Creation Date")
                ELSE
                    IF LandMasterHeader.GET("Land Document No.") THEN
                        "Due Date" := CALCDATE("Due Date Calculation", LandMasterHeader."Creation Date");
            end;
        }
        field(12; "Due Amount"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(16; Description; Text[50])
        {
        }
        field(17; "Due Date"; Date)
        {
            Editable = false;
        }
        field(20; "Payment Type"; Option)
        {
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD/Interest,ROI,Ticket Control,Mobile,Conveyance,Travel';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,"LD/Interest",ROI,"Ticket Control",Mobile,Conveyance,Travel;
        }
        field(21; "Land Value"; Decimal)
        {
            CalcFormula = Sum("Land Agreement Line"."Land Value" WHERE("Document No." = FIELD("Land Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Fixed Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Due Amount" := ROUND("Fixed Amount", 1);
            end;
        }
        field(23; "Vendor Land Value"; Decimal)
        {
            CalcFormula = Sum("Land Agreement Line"."Land Value" WHERE("Document No." = FIELD("Land Document No."),
                                                                        "Line No." = FIELD("Land Document Line No."),
                                                                        "Vendor Code" = FIELD("Vendor No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(25; "Balance Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Payment Released Amount"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("Vendor No."),
                                                                          "Order Ref No." = FIELD("Land Document No."),
                                                                          "Milestone Code" = FIELD("Actual Milestone")));
            FieldClass = FlowField;
        }
        field(27; "Allow Payment"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Opportunity Vendor Land Value"; Decimal)
        {
            CalcFormula = Sum("Land Lead/Opp Line"."Land Value" WHERE("Document No." = FIELD("Land Document No."),
                                                                       "Line No." = FIELD("Land Document Line No."),
                                                                       "Vendor Code" = FIELD("Vendor No.")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Land Document No.", "Vendor No.", "Land Document Line No.", "Actual Milestone", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        PaymentTerms: Record "Payment Terms";
        LandDocumentMasterLine: Record "Land Agreement Line";
        LandMasterHeader: Record "Land Agreement Header";
        LandVendorPaymentTermsLine: Record "Land Vendor Payment Terms Line";


    procedure CalculateCriteriaValue()
    var
        TotalPercentage: Decimal;
    begin
        IF LandMasterHeader.GET("Land Document No.") THEN BEGIN
            CALCFIELDS("Vendor Land Value");
            "Base Amount" := "Vendor Land Value";
        END ELSE BEGIN
            CALCFIELDS("Opportunity Vendor Land Value");
            "Base Amount" := "Opportunity Vendor Land Value";
        END;
        IF "Calculation Type" = "Calculation Type"::"% age" THEN
            "Due Amount" := ("Base Amount" * "Calculation Value") / 100;
        IF "Calculation Type" = "Calculation Type"::"Fixed Value" THEN
            "Due Amount" := ROUND("Fixed Amount", 1);

        TotalPercentage := 0;
        LandVendorPaymentTermsLine.RESET;
        LandVendorPaymentTermsLine.SETRANGE("Land Document No.", "Land Document No.");
        LandVendorPaymentTermsLine.SETRANGE("Vendor No.", "Vendor No.");
        LandVendorPaymentTermsLine.SETRANGE("Land Document Line No.", "Land Document Line No.");
        LandVendorPaymentTermsLine.SETFILTER("Line No.", '<>%1', "Line No.");
        IF LandVendorPaymentTermsLine.FINDSET THEN
            REPEAT
                TotalPercentage := TotalPercentage + LandVendorPaymentTermsLine."Calculation Value";
            UNTIL LandVendorPaymentTermsLine.NEXT = 0;

        IF (TotalPercentage + "Calculation Value") > 100 THEN
            ERROR('Total of Calculation Value can not be greater than 100');
    end;
}

