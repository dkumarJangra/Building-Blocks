page 50390 "R194 Gift Setup"
{
    Caption = 'R194 Gift Setup';

    PageType = List;
    SourceTable = "R194 Gift Setup";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Start Date"; Rec."Start Date")
                {
                }
                field("Extent"; Rec."Extent")
                {
                }
                field("Gift Amount"; Rec."Gift Amount")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Creation Time"; Rec."Creation Time")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field(Plots; Rec.Plots)
                {

                }
                Field("Gift Item No."; Rec."Gift Item No.")
                {

                }

            }
        }
    }

    actions
    {
    }
}

