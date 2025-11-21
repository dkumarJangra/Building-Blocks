pageextension 50005 "BBG General Ledger Entries Ext" extends "General Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        modify("Source No.")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("Debit Amount")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("Credit Amount")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("External Document No.")
        {
            ApplicationArea = all;
            Visible = true;
        }
        addafter("Document No.")
        {
            field("BBG PW Posted Doc. No."; Rec."BBG PW Posted Doc. No.")
            {
                ApplicationArea = all;
            }
        }
        addafter("Job No.")
        {
            field("BBG Posting Type"; Rec."BBG Posting Type")
            {
                ApplicationArea = all;
            }
        }
        addafter("Global Dimension 2 Code")
        {
            field("BBG Cheque Status in Application"; Rec."BBG Cheque Status in Application")
            {
                ApplicationArea = all;
            }
            field("BBG TDS Entry TDS Amt"; Rec."BBG TDS Entry TDS Amt")
            {
                ApplicationArea = all;
            }
            field("BBG Comp Code"; Rec."BBG Comp Code")
            {
                ApplicationArea = all;
            }
            field("BBG TDS Base Amount From TDS"; Rec."BBG TDS Base Amount From TDS")
            {
                ApplicationArea = all;
            }
            field("BBG Direct Incentive App. No."; Rec."BBG Direct Incentive App. No.")
            {
                ApplicationArea = all;
            }
            field("BBG Special Incentive Bonanza"; Rec."BBG Special Incentive Bonanza")
            {
                ApplicationArea = all;
            }
            field("Journal Batch Name"; Rec."Journal Batch Name")
            {
                ApplicationArea = all;
            }
            field("BBG Verified By"; Rec."BBG Verified By")
            {
                ApplicationArea = all;
            }
            field("BBG TO Region code"; Rec."BBG TO Region code")
            {
                ApplicationArea = all;
            }
            field("BBG TO Region Name"; Rec."BBG TO Region Name")
            {
                ApplicationArea = all;
            }
            field("Prior-Year Entry"; Rec."Prior-Year Entry")
            {
                ApplicationArea = all;
            }
            field("BBG Order Ref No."; Rec."BBG Order Ref No.")
            {
                ApplicationArea = all;
            }
            field("BBG P.A.N No."; Rec."BBG P.A.N No.")
            {
                ApplicationArea = all;
            }
            field("BBG Vendor No."; Rec."BBG Vendor No.")
            {
                ApplicationArea = all;
            }
            field("BBG Vendor Name"; Rec."BBG Vendor Name")
            {
                ApplicationArea = all;
            }
            field("BBG Cheque No."; Rec."BBG Cheque No.")
            {
                ApplicationArea = all;
            }
            field("BBG Cheque Date"; Rec."BBG Cheque Date")
            {
                ApplicationArea = all;
            }
            field("Ref. Invoice No."; Rec."Ref. Invoice No.")
            {
                ApplicationArea = All;
            }


        }

    }

    actions
    {
        addafter("F&unctions")
        {
            action("BBG Posted Narration")
            {
                Caption = 'BBG Posted Narration';
                Image = "Page";
                Promoted = true;
                RunObject = Page "BBG Posted Narration";
                RunPageLink = "Document No." = FIELD("Document No.");
                ApplicationArea = All;
            }
        }
    }

    var
        myInt: Integer;
}