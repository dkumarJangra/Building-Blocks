page 97761 "Job Planning Lines Schedule"
{
    // ALLEPG 271211 : Set editable property of the form.

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
            part(PlanningLines; "Job Planning Line Subform Sch.")
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

        // ALLEPG 271211 Start
        IF Job.GET(Rec."Job No.") THEN BEGIN
            IF ((Job.Approved = FALSE) AND (Job.Amended = FALSE) AND (Job."Amendment Approved" = FALSE)) THEN
                CurrPage.EDITABLE
            ELSE IF ((Job.Approved = TRUE) AND (Job.Amended = FALSE) AND (Job."Amendment Approved" = FALSE)) THEN
                CurrPage.EDITABLE(FALSE)
            ELSE IF ((Job.Approved = TRUE) AND (Job.Amended = TRUE) AND (Job."Amendment Approved" = FALSE)) THEN
                CurrPage.EDITABLE
            ELSE IF ((Job.Approved = TRUE) AND (Job.Amended = TRUE) AND (Job."Amendment Approved" = TRUE)) THEN
                CurrPage.EDITABLE(FALSE);
        END;
        // ALLEPG 271211 End
    end;

    var
        Job: Record Job;
}

