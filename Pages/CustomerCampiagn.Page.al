page 50284 "Customer Campiagn"
{
    PageType = List;
    SourceTable = "Customer Campiagn";
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
                field("Submitted At"; Rec."Submitted At")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field("Phone No."; Rec."Phone No.")
                {
                }
                field("Type of Property"; Rec."Type of Property")
                {
                }
                field(Medium; Rec.Medium)
                {
                }
                field(Source; Rec.Source)
                {
                }
                field(Campiagn; Rec.Campiagn)
                {
                }
                field("Ad group"; Rec."Ad group")
                {
                }
                field(Term; Rec.Term)
                {
                }
                field("Landing Page"; Rec."Landing Page")
                {
                }
                field("Lead Relevance"; Rec."Lead Relevance")
                {
                }
                field("Appointment Status"; Rec."Appointment Status")
                {
                }
                field("Lead Converted"; Rec."Lead Converted")
                {
                }
                field("Picked By"; Rec."Picked By")
                {
                }
                field("Picked On"; Rec."Picked On")
                {
                }
                field("Converted to Lead"; Rec."Converted to Lead")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field("Remarks 2"; Rec."Remarks 2")
                {
                }
                field("Remarks 3"; Rec."Remarks 3")
                {
                }
                field("Picked Update Date"; Rec."Picked Update Date")
                {
                    Caption = 'Picked Date';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import Data")
            {
                RunObject = XMLport "Customer Campign";
            }
        }
    }
}

