pageextension 50008 "BBG Cust. ledger Entries Ext" extends "Customer Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        modify("External Document No.")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("Certificate Received")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("Certificate No.")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("TDS Certificate Rcpt Date")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("TDS Certificate Amount")
        {
            ApplicationArea = all;
            Visible = true;
        }

        addafter("Posting Date")
        {
            field("BBG App. No. / Order Ref No."; Rec."BBG App. No. / Order Ref No.")
            {
                ApplicationArea = all;
            }
            field("BBG Sales Order No."; Rec."BBG Sales Order No.")
            {
                ApplicationArea = all;
            }
            field("BBG Project Unit No."; Rec."BBG Project Unit No.")
            {
                ApplicationArea = all;
            }
            field("BBG Posting Type"; Rec."BBG Posting Type")
            {
                ApplicationArea = all;
            }
            field("BBG Reason"; Rec."BBG Reason")
            {
                ApplicationArea = all;
            }
            field("Closed by Amount"; Rec."Closed by Amount")
            {
                ApplicationArea = all;
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