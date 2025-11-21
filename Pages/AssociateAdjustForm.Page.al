page 50064 "Associate Adjust Form"
{
    PageType = Card;
    SourceTable = "Associate OD Ajustment Entry";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field("Document No."; Rec."Document No.")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("From Company Name"; Rec."From Company Name")
                {
                }
                field("To Company Name"; Rec."To Company Name")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                }
                field("Adjust OD Amount"; Rec."Adjust OD Amount")
                {
                }
                field("Posted in From Company Name"; Rec."Posted in From Company Name")
                {
                }
                field("Posted in To Company Name"; Rec."Posted in To Company Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

