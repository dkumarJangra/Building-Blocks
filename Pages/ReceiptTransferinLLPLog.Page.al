page 60690 "Receipt Transfer in LLP Log"
{
    Editable = false;
    PageType = List;
    SourceTable = "Receipt transfer in LLP Log";
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Application Code"; Rec."Application Code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Error Message"; Rec."Error Message")
                {
                }
            }
        }
    }

    actions
    {
    }
}

