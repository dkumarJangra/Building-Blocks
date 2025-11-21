pageextension 50062 "BBG Sales & Receiva. Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group("BBG Fields")
            {
                Caption = 'BBG Fields';
                field("Escalation Account"; Rec."Escalation Account")
                {
                    ApplicationArea = All;
                }
                field("PPLAN-A"; Rec."PPLAN-A")
                {
                    ApplicationArea = All;
                }
                field("PPLAN-B"; Rec."PPLAN-B")
                {
                    ApplicationArea = All;
                }
                field("PPLAN-C"; Rec."PPLAN-C")
                {
                    ApplicationArea = All;
                }
                field("RA Bill Nos."; Rec."RA Bill Nos.")
                {
                    ApplicationArea = All;
                }
                field("Escalation Bill Nos."; Rec."Escalation Bill Nos.")
                {
                    ApplicationArea = All;
                }
                field("FBW RA Bill Nos."; Rec."FBW RA Bill Nos.")
                {
                    ApplicationArea = All;
                }
                field("FBW Posted RA Bill Nos."; Rec."FBW Posted RA Bill Nos.")
                {
                    ApplicationArea = All;
                }
                field("FBW Credit Memo Nos."; Rec."FBW Credit Memo Nos.")
                {
                    ApplicationArea = All;
                }
                field("FBW Posted Credit Memo Nos."; Rec."FBW Posted Credit Memo Nos.")
                {
                    ApplicationArea = All;
                }
                field("Posted RA Bill Nos."; Rec."Posted RA Bill Nos.")
                {
                    ApplicationArea = All;
                }
                field("Posted Escalation Bill Nos."; Rec."Posted Escalation Bill Nos.")
                {
                    ApplicationArea = All;
                }
                field("No. Series MSC Cust code"; Rec."No. Series MSC Cust code")
                {
                    ApplicationArea = All;
                }
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