page 60719 "Lead Image Details"
{
    PageType = ListPart;
    SourceTable = "Lead Image Details";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Lead ID"; Rec."Lead ID")
                {
                }
                field("Ref. Document No."; Rec."Ref. Document No.")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                }
                field("Image Path"; Rec."Image Path")
                {
                }
                field(Type; Rec.Type)
                {
                }
            }
        }
    }

    actions
    {
    }
}

