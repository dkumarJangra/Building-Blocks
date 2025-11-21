page 97985 "Incentive List"
{
    CardPageID = "Incentive Header Form";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Incentive Header";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Incentive Code"; Rec."Incentive Code")
                {
                }
                field("W.e.f. Date"; Rec."W.e.f. Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Incentive Type"; Rec."Incentive Type")
                {
                }
                field("No. of Units"; Rec."No. of Units")
                {
                }
                field("No. Series"; Rec."No. Series")
                {
                }
            }
        }
    }

    actions
    {
    }
}

