pageextension 50053 "BBG Bank Acc. State. Lines Ext" extends "Bank Account Statement Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Transaction Date")
        {
            field("Statement Line No."; Rec."Statement Line No.")
            {
                ApplicationArea = All;
            }
            field("Application No."; Rec."Application No.")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field(Bounced; Rec.Bounced)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}