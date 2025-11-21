page 50283 "Loan EMI Sub Form"
{
    PageType = ListPart;
    SourceTable = "LOAN EMI Document Details";
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
                field("Reference No."; Rec."Reference No.")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Creation Time"; Rec."Creation Time")
                {
                }
                field("Field Name"; Rec."Field Name")
                {
                }
                field("Field Type"; Rec."Field Type")
                {
                }
                field("Field Heading"; Rec."Field Heading")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}

