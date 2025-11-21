page 98018 "Job Planning Lines1"
{
    Caption = 'Job Planning Lines';
    DataCaptionExpression = Rec.Caption;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Job Task";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Job Task No."; Rec."Job Task No.")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                }
            }
            part(PlanningLines; "Job Planning Line Subform1")
            {
                SubPageLink = "Job No." = FIELD("Job No."),
                              "Job Task No." = FIELD("Job Task No.");
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        IF Job.GET(Rec."Job No.") THEN
            CurrPage.EDITABLE(NOT (Job.Blocked = Job.Blocked::All));
    end;

    var
        Job: Record Job;
}

