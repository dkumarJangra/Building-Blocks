
table 80004 "BBG Vendor wise"
{
    Caption = 'BBG Detailed Vendor Ledg. Entry';
    DataCaptionFields = "Vendor No.";
    // DrillDownPageID = "Detailed Vendor Ledg. Entries";
    // LookupPageID = "Detailed Vendor Ledg. Entries";
    //Permissions = TableData "Detailed Vendor Ledg. Entry" =;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(2; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(3; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type';
        }


        field(4; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" where("Ledger Entry Amount" = const(true),
            "Vendor No." = Field("vendor No."), "Posting Date" = field("Date Filter")));
            Caption = 'Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90016; "Posting Type"; Option)
        {
            //DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL';
            Editable = false;
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD,Mobilization Advance,Equipment Advance,,,,Commission,Travel Allowance,Bonanza,Incentive,CommAndTA';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance",,,,Commission,"Travel Allowance",Bonanza,Incentive,CommAndTA;
            FieldClass = FlowFilter;
        }
    }


    keys
    {
        key(Key1; "Vendor No.")
        {
            Clustered = true;
        }

    }

    var
        re: Record 25;
}

