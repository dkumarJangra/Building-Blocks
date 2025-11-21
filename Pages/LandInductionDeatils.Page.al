page 60720 "Land Induction Deatils"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Lead Inducation Details";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Lead ID"; Rec."Lead ID")
                {
                }
                field(Comments; Rec.Comments)
                {
                }
                field("Inducation Kit"; Rec."Inducation Kit")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
            }
            part("1"; "Lead Image Details")
            {
                SubPageLink = "Lead ID" = FIELD("Lead ID");
                SubPageView = SORTING("Lead ID", "Line No.");
            }
        }
    }

    actions
    {
    }
}

