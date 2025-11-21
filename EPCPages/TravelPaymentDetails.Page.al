page 97840 "TravelPayment Details"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Travel Payment Details";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Sub Associate Code"; Rec."Sub Associate Code")
                {
                }
                field("Sub Associate Name"; Rec."Sub Associate Name")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

