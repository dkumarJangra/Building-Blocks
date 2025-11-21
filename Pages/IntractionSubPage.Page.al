page 60699 "Intraction Sub Page"
{
    AutoSplitKey = true;
    Editable = false;
    PageType = ListPart;
    SourceTable = "Customer Intraction Details";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer Prospect Line No."; Rec."Customer Prospect Line No.")
                {
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Duration; Rec.Duration)
                {
                }
                field("Followup Type"; Rec."Followup Type")
                {
                }
                field("Followup Date"; Rec."Followup Date")
                {
                }
                field("Followup Time"; Rec."Followup Time")
                {
                }
            }
        }
    }

    actions
    {
    }
}

