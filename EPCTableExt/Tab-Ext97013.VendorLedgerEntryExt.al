tableextension 97013 "EPC Vendor Ledger Entry Ext" extends "Vendor Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(90016; "Posting Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL';
            Editable = false;
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD,Mobilization Advance,Equipment Advance,,,,Commission,Travel Allowance,Bonanza,Incentive,CommAndTA';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance",,,,Commission,"Travel Allowance",Bonanza,Incentive,CommAndTA;
        }
        field(50101; "Payment Trasnfer from Other"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50100; "Company Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company;
        }
        field(90050; "Order Ref No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
            Editable = false;
        }
        field(90051; "Milestone Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
            Editable = false;
        }
        field(90052; "Ref Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
            Editable = false;
            OptionCaption = ' ,Order,,,Blanket Order';
            OptionMembers = " ","Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(90053; Narration; Text[200])
        {
            CalcFormula = Lookup("G/L Entry"."BBG Narration" WHERE("Entry No." = FIELD("Entry No.")));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90054; Month; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'SR-070705--JPL';
            Editable = false;
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(90055; Year; Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'SR-070705--JPL';
            Editable = false;
        }
        field(90056; "Cheque No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            Editable = true;
        }
        field(90057; "Cheque Date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
            Editable = false;
        }
        field(90058; Reconciled; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(90059; "Received Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'NDALLE240108';
            Editable = false;
        }
        field(90060; "User Branch Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Location.Code WHERE("BBG Branch" = FILTER(true));
        }
        field(90113; "Payment Mode"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 010313';
            OptionCaption = ' ,Cash,Bank,D.D.,MJVM,D.C./C.C./Net Banking,Refund Cash,Refund Bank,AJVM,Debit Note,JV,Negative Adjmt.';
            OptionMembers = " ",Cash,Bank,"D.D.",MJVM,"D.C./C.C./Net Banking","Refund Cash","Refund Bank",AJVM,"Debit Note",JV,"Negative Adjmt.";
        }
        field(90114; "Opening Invoice TDS adj"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG1.00 15/04/13';
        }
        field(90115; "ARM Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG1.00 29/05/13';
            Editable = false;
        }
        field(90116; "Find records"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90117; "Check Remaining Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90118; "TDSAmt for Associate"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Document No." = FIELD("Document No."),
                                                        "G/L Account No." = FILTER(116400),
                                                        "Document Type" = FIELD("Document Type"),
                                                        "Transaction No." = FIELD("Transaction No.")));
            FieldClass = FlowField;
        }
        field(90119; "Club 9 for Associate"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Document No." = FIELD("Document No."),
                                                        "G/L Account No." = FILTER(122900),
                                                        "Document Type" = FIELD("Document Type")));
            FieldClass = FlowField;
        }
        field(90120; "Credit Memo from ARM"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90121; "Not consider in Comm Report"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '01102015 ALLE';
            Editable = false;
        }
        field(90122; "Payment As Advance"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90123; "Find Same Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90125; "Commission GL Amount"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                        "Document No." = FIELD("Document No."),
                                                        "G/L Account No." = FILTER(158500)));
            Description = 'ALLE 150116';
            FieldClass = FlowField;
        }
        field(90150; "Invoice Adjust amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90151; "Payment From Company"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Company;
        }
        field(90152; "Block Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90154; "Direct ARM Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90155; "Not consider in Elegiblity"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90156; "P.A.N. No."; Code[20])
        {
            CalcFormula = Lookup(Vendor."P.A.N. No." WHERE("No." = FIELD("Vendor No.")));
            FieldClass = FlowField;
        }
        field(90157; "BBG Vendor Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            FieldClass = FlowField;
        }
        field(90158; "Find Entry_1"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90202; "Drawing Ledger Data Exclude"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90203; "Purchase Company Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90208; "Special Incentive Bonanza"; Boolean)
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