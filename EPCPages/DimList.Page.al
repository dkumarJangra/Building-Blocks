page 50050 "Dim List"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = Card;
    SourceTable = "Associate Hierarcy with App.";
    SourceTableView = WHERE(Status = CONST(Active));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Rank Code"; Rec."Rank Code")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        UplinePAGE: Page "UpLine Form";
        CommissionEntry: Record "Commission Entry";
        CommEntry: Record "Commission Entry";
        Amt: Decimal;
        EntryNo: Integer;
        BaseAmount: Decimal;
        Bond: Record "Confirmed Order";
        APPEntry: Record "Application Payment Entry";
        RecAmt: Decimal;
        ExistCommEntry: Record "Commission Entry";
        NoofRec: Integer;
        PTLSales: Record "Payment Terms Line Sale";
        CommAmt: Decimal;
}

