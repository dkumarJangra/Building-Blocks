page 50274 "Ref. LLP Item Details"
{
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Ref. LLP Item Details";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                }
                field("Ref. LLP Name"; Rec."Ref. LLP Name")
                {
                }
                field("Ref. LLP Item No."; Rec."Ref. LLP Item No.")
                {

                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("Available Inventory"; Rec."Available Inventory")
                {
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                }
                field("Ref. LLP Item Project Code"; Rec."Ref. LLP Item Project Code")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

