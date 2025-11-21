page 50286 "Loan EMI Master"
{
    PageType = List;
    SourceTable = "LOAN EMI MASTER";
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
                field("Document Type"; Rec."Document Type")
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
            }
        }
    }

    actions
    {
    }
}

