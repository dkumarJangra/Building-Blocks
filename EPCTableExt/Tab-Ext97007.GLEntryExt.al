tableextension 97007 "EPC G/L Entry" extends "G/L Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50024; "BBG Do Not Show"; Boolean)
        {
            Caption = 'Do Not Show';
            Description = 'MPS1.0';
        }
        field(50018; "BBG Paid To/Received From"; Option)
        {
            Caption = 'Paid To/Received From';
            Description = 'MPS1.0';
            Editable = true;
            OptionMembers = " ","Marketing Member","Bond Holder";
        }
        field(50019; "BBG Paid To/Received From Code"; Code[20])
        {
            Caption = 'Paid To/Received From Code';
            Description = 'MPS1.0';
            Editable = true;
            TableRelation = IF ("BBG Paid To/Received From" = CONST("Marketing Member")) Vendor."No."
            ELSE IF ("BBG Paid To/Received From" = CONST("Bond Holder")) Customer."No.";
        }

        field(90011; "BBG Narration"; Text[200])
        {
            Caption = 'Narration';
            Description = 'ALLEMSN01--JPL';
        }
        field(90012; "BBG Month"; Option)
        {
            Caption = 'Month';
            Description = 'ALLEMSN01--JPL';
            OptionCaption = ' ,January,February,March,April,May,June,July,August,September,October,November,December';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(90013; "BBG Year"; Integer)
        {
            Caption = 'Year';
            Description = 'ALLEMSN01--JPL';
        }
        field(90016; "BBG Posting Type"; Option)
        {
            Caption = 'Posting Type';
            Description = 'ALLEAS02--JPL';
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD,Mobilization Advance,Equipment Advance,,,,Commission,Travel Allowance,Bonanza,Incentive,CommAndTA';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance",,,,Commission,"Travel Allowance",Bonanza,Incentive,CommAndTA;
        }
        field(90050; "BBG Order Ref No."; Code[20])
        {
            Caption = 'Order Ref No.';
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
        }
        field(90051; "BBG Milestone Code"; Code[20])
        {
            Caption = 'Milestone Code';
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
        }
        field(90052; "BBG Ref Document Type"; Option)
        {
            Caption = 'Ref Document Type';
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones--JPL';
            OptionCaption = ',Order,,,Blanket Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(90096; "BBG Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            Description = 'ALLEAS01--JPL';
            TableRelation = Employee;
        }
        field(90097; "BBG Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            Description = 'ALLEAS01--JPL';
            TableRelation = Resource WHERE(Type = CONST(Person));
        }
        field(90098; "BBG Account Name"; Text[100])
        {
            Caption = 'Account Name';
            CalcFormula = Lookup("G/L Account".Name WHERE("No." = FIELD("G/L Account No.")));
            Description = '--JPL';
            FieldClass = FlowField;
            TableRelation = "G/L Account";
        }
        field(90099; "BBG Cheque No."; Code[20])
        {
            Caption = 'Cheque No.';
            Description = '--JPL';
            Editable = false;
        }
        field(90100; "BBG Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            Description = '--JPL';
        }
        field(90101; "BBG Order Line No."; Integer)
        {
            Caption = 'Order Line No.';
            Description = '--JPL';
        }
        field(90102; "BBG TO Region code"; Code[20])
        {
            Caption = 'TO Region code';
            Description = 'AlleBLK';
            Editable = false;
            FieldClass = Normal;
        }
        field(90103; "BBG TO Region Name"; Text[50])
        {
            Caption = 'TO Region Name';
            Description = 'AlleBLK';
            Editable = false;
        }
        field(90106; "BBG Introducer Code"; Code[20])
        {
            Caption = 'Introducer Code';
            Description = 'MPS1.0';
        }
        field(90107; "BBG Cheque clear Date"; Date)
        {
            Caption = 'Cheque clear Date';
            Description = 'MPS1.0';
        }
        field(90108; "BBG User Branch Code"; Code[20])
        {
            Caption = 'User Branch Code';
            Description = 'BBG1.00';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('COLLCENTERS'));
        }
        field(90109; "BBG Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            CalcFormula = Lookup("Vendor Ledger Entry"."Vendor No." WHERE("Document No." = FIELD("Document No."),
                                                                           "Transaction No." = FIELD("Transaction No.")));
            Description = 'ALLETDK200813';
            FieldClass = FlowField;
        }
        field(90110; "BBG P.A.N No."; Code[20])
        {
            Caption = 'P.A.N No.';
            CalcFormula = Lookup(Vendor."P.A.N. No." WHERE("No." = FIELD("BBG Vendor No.")));
            Description = 'ALLETDK200813';
            FieldClass = FlowField;
        }
        field(90111; "BBG Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("BBG Vendor No.")));
            FieldClass = FlowField;
        }
        field(90112; "BBG PW Posted Doc. No."; Code[20])
        {
            Caption = 'PW Posted Doc. No.';
            CalcFormula = Lookup("Associate Payment Hdr"."Document No." WHERE("Posted Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(90113; "BBG TDS Entry TDS Amt"; Decimal)
        {
            Caption = 'TDS Entry TDS Amt';
            CalcFormula = Sum("G/L Entry".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                        "Document No." = FIELD("Document No."),
                                                        "G/L Account No." = FILTER(116400)));
            FieldClass = FlowField;
        }
        field(90200; "BBG Comp Code"; Text[30])
        {
            Caption = 'Comp Code';
            Editable = false;
        }
        field(90201; "BBG Cheque Status in Application"; Option)
        {
            Caption = 'Cheque Status in Application';
            CalcFormula = Lookup("Application Payment Entry"."Cheque Status" WHERE("Posted Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Cleared,Bounced,,Cancelled';
            OptionMembers = " ",Cleared,Bounced,,Cancelled;
        }
        field(90202; "BBG TDS Base Amount From TDS"; Decimal)
        {
            Caption = 'TDS Base Amount From TDS';
            CalcFormula = Sum("TDS Entry"."TDS Base Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                   "Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(90205; "BBG Land Agreement Expense Entry"; Boolean)
        {
            Caption = 'Land Agreement Expense Entry';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90206; "BBG Land Agreement No."; Code[20])
        {
            Caption = 'Land Agreement No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90207; "BBG Direct Incentive App. No."; Code[20])
        {
            Caption = 'Direct Incentive App. No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90208; "BBG Special Incentive Bonanza"; Boolean)
        {
            Caption = 'Special Incentive Bonanza';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(90209; "Ref. Invoice No."; Code[20])
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