pageextension 50063 "BBG Purchases & Pay. Setup Ext" extends "Purchases & Payables Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group("BBG Fields")
            {
                Caption = 'BBG Fields';
                field("Reserve Associate Payment Amt"; Rec."Reserve Associate Payment Amt")
                {
                    ApplicationArea = All;
                }
                field("Request No."; Rec."Request No.")
                {
                    ApplicationArea = All;
                }
                field("Inter Purchase No.Seires"; Rec."Inter Purchase No.Seires")
                {
                    ApplicationArea = all;
                }
                field("Posted Inter Purch. No.Seires"; Rec."Posted Inter Purch. No.Seires")
                {
                    ApplicationArea = All;
                }
                field("Inter Purchase Cr. No.Seires"; Rec."Inter Purchase Cr. No.Seires")
                {
                    ApplicationArea = all;
                }
                field("Posted Inter Purch CrMemo NoSr"; Rec."Posted Inter Purch CrMemo NoSr")
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