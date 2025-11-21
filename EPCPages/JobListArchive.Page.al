page 97781 "Job List Archive"
{
    Editable = false;
    PageType = Card;
    SourceTable = "EPC Job Archive";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Version No."; Rec."Version No.")
                {
                }
                field("Archived By"; Rec."Archived By")
                {
                }
                field("Date Archived"; Rec."Date Archived")
                {
                }
                field("Time Archived"; Rec."Time Archived")
                {
                }
                field("Total Project Cost"; Rec."Total Project Cost")
                {
                }
                field("Total No. of Units"; Rec."Total No. of Units")
                {
                }
                field("Project Saleable Area"; Rec."Project Saleable Area")
                {
                }
                field("Total Unit Sold"; Rec."Total Unit Sold")
                {
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;

                    trigger OnAction()
                    begin
                        PAGE.RUN(PAGE::"Job Archive", Rec);
                    end;
                }
            }
        }
    }
}

