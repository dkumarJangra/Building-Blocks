page 97893 "Unit Print Log Subform"
{
    Caption = 'Print Log';
    PageType = ListPart;
    SourceTable = "Unit Print Log";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Editable = false;
                field("Report Type"; Rec."Report Type")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field(Date; Rec.Date)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Printing Status"; Rec."Printing Status")
                {
                }
                field(Time; Rec.Time)
                {
                }
            }
        }
    }

    actions
    {
    }
}

