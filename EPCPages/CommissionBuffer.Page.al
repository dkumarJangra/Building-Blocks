page 50048 "Commission Buffer"
{
    PageType = Card;
    SourceTable = "Unit & Comm. Creation Buffer";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Unit No."; Rec."Unit No.")
                {
                }
                field("Installment No."; Rec."Installment No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Base Amount"; Rec."Base Amount")
                {
                }
                field("Charge Code"; Rec."Charge Code")
                {
                }
                field("Project Type"; Rec."Project Type")
                {
                }
                field(Duration; Rec.Duration)
                {
                }
                field("Year Code"; Rec."Year Code")
                {
                }
                field("Investment Type"; Rec."Investment Type")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Bond Created"; Rec."Bond Created")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Commission Created"; Rec."Commission Created")
                {
                }
                field("Paid by cheque"; Rec."Paid by cheque")
                {
                }
                field("Milestone Code"; Rec."Milestone Code")
                {
                }
                field("Direct Associate"; Rec."Direct Associate")
                {
                }
                field("Min. Allotment Amount Not Paid"; Rec."Min. Allotment Amount Not Paid")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Cheque not Cleared"; Rec."Cheque not Cleared")
                {
                }
                field("Cheque Cleared Date"; Rec."Cheque Cleared Date")
                {
                }
                field("Posted document No"; Rec."Posted document No")
                {
                }
                field("Update entries"; Rec."Update entries")
                {
                }
                field("Opening Commision Adj."; Rec."Opening Commision Adj.")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        IF USERID <> '1003' THEN
            ERROR('You donnot have permissions to modify/delete');
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IF USERID <> '1003' THEN
            ERROR('You donnot have permissions to modify/delete');
    end;

    trigger OnOpenPage()
    begin
        IF USERID <> '1003' THEN
            CurrPage.EDITABLE(FALSE);
    end;
}

