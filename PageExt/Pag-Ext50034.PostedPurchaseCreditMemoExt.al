pageextension 50034 "BBG Ptd Purch. Credit Memo Ext" extends "Posted Purchase Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group("BBG Fields")
            {
                Caption = 'BBG Fields';
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ApplicationArea = All;
                }
                field("Sent for Approval Date"; Rec."Sent for Approval Date")
                {
                    ApplicationArea = All;
                }
                field("Sent for Approval Time"; Rec."Sent for Approval Time")
                {
                    ApplicationArea = All;
                }
                field(Approved; Rec.Approved)
                {
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = All;
                }
                field("Approved Time"; Rec."Approved Time")
                {
                    ApplicationArea = All;
                }
                field(Initiator; Rec.Initiator)
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