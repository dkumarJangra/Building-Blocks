tableextension 50006 "BBG Cust. Ledger Entry Ext" extends "Cust. Ledger Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50001; "BBG Narration"; Text[250])
        {
            Caption = 'Narration';
            DataClassification = ToBeClassified;
            Description = 'SR-070705';
        }
        field(50003; "BBG Month"; Option)
        {
            Caption = 'Month';
            DataClassification = ToBeClassified;
            Description = 'SR-070705';
            OptionMembers = " ",January,February,March,April,May,June,July,August,September,October,November,December;
        }
        field(50004; "BBG Year"; Integer)
        {
            Caption = 'Year';
            DataClassification = ToBeClassified;
            Description = 'SR-070705';
        }


        field(50021; "BBG Entry Project Code"; Code[20])
        {
            Caption = 'Entry Project Code';
            DataClassification = ToBeClassified;
            Description = 'INS1.0';
            Editable = false;
        }
        field(50244; "BBG Cheque No.1"; Code[20])
        {
            Caption = 'Cheque No.1';
            CalcFormula = Lookup("Bank Account Ledger Entry"."Cheque No.1" WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(55009; "BBG Tranasaction Type"; Option)
        {
            Caption = 'Tranasaction Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Trading';
            OptionMembers = " ",Trading;
        }
        field(60000; "BBG User Branch Code_1"; Code[20])
        {
            Caption = 'User Branch Code_1';
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0014 22-08-2007';
            TableRelation = Job;
        }
        field(90016; "BBG Posting Type"; Option)
        {
            Caption = 'Posting Type';
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02';
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD,Mobilization Advance,Equipment Advance,,,,Commission,Travel Allowance,Bonanza,Incentive';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance",,,,Commission,"Travel Allowance",Bonanza,Incentive;
        }

        field(90051; "BBG Milestone Code"; Code[20])
        {
            Caption = 'Milestone Code';
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones';
        }
        field(90052; "BBG Ref Document Type"; Option)
        {
            Caption = 'Ref Document Type';
            DataClassification = ToBeClassified;
            Description = 'ALLEAS03 Fields Added to Link Payments with the Milestones';
            OptionCaption = ' ,Order,,,Blanket Order';
            OptionMembers = " ","Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(90103; "BBG Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA 141209';
            Editable = false;
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FILTER(Order),
                                                      "Sell-to Customer No." = FIELD("Customer No."));
        }
        field(90104; "BBG Project Unit No."; Code[20])
        {
            Caption = 'Project Unit No.';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA 14120';
            Editable = false;
        }
        field(90105; "BBG Reason"; Option)
        {
            Caption = 'Reason';
            DataClassification = ToBeClassified;
            Description = 'ALLEAA 141209';
            Editable = false;
            OptionCaption = ' ,Cancel,Forfeit,Transfer,Other';
            OptionMembers = " ",Cancel,Forfeit,Transfer,Other;
        }
        field(90106; "BBG User Branch Code"; Code[10])
        {
            Caption = 'User Branch Code';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Location.Code WHERE("BBG Branch" = FILTER(true));
        }
        field(90113; "BBG Payment Mode"; Option)
        {
            Caption = 'Payment Mode';
            DataClassification = ToBeClassified;
            Description = 'ALLEDK 010313';
            OptionCaption = ' ,Cash,Bank,D.D.,MJVM,D.C./C.C./Net Banking,Refund Cash,Refund Bank,AJVM,Debit Note,JV,Negative Adjmt.';
            OptionMembers = " ",Cash,Bank,"D.D.",MJVM,"D.C./C.C./Net Banking","Refund Cash","Refund Bank",AJVM,"Debit Note",JV,"Negative Adjmt.";
        }
        field(90114; "BBG Transfered"; Boolean)
        {
            Caption = 'Transfered';
            DataClassification = ToBeClassified;
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

    PROCEDURE BBGGetAdjustedCurrencyFactor(): Decimal;
    BEGIN
        IF "Adjusted Currency Factor" = 0 THEN
            EXIT(1);
        EXIT("Adjusted Currency Factor");
    END;
}