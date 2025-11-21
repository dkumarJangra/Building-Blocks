pageextension 50075 "BBG Job Task Lines Ext" extends "Job Task Lines"
{
    layout
    {
        // Add changes to page layout here
        addafter("Job No.")
        {
            field("BOQ Qty."; Rec."BOQ Qty.")
            {
                ApplicationArea = All;
            }
            field("BOQ Code"; Rec."BOQ Code")
            {
                ApplicationArea = All;
            }
            field("BOQ Type"; Rec."BOQ Type")
            {
                ApplicationArea = All;
            }
            field("BOQ Job Type"; Rec."BOQ Job Type")
            {
                ApplicationArea = All;
            }
            field("BOQ Amt."; Rec."BOQ Amt.")
            {
                ApplicationArea = All;
            }
            field(Remark; Rec.Remark)
            {
                ApplicationArea = All;

            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("F&unctions")
        {
            action("Edit Planning Lines - Contract")
            {
                Caption = 'Edit Planning Lines - Contract';
                ApplicationArea = All;

                trigger OnAction()
                var
                    JT: Record "Job Task";
                begin
                    Rec.TESTFIELD("Job Task Type", Rec."Job Task Type"::Posting);
                    Rec.TESTFIELD("Job No.");
                    Job.GET(Rec."Job No.");
                    Rec.TESTFIELD("Job Task No.");
                    JT.GET(Rec."Job No.", Rec."Job Task No.");
                    JT.FILTERGROUP := 2;
                    JT.SETRANGE("Job No.", Rec."Job No.");
                    JT.SETRANGE("Job Task Type", JT."Job Task Type"::Posting);
                    JT.FILTERGROUP := 0;
                    PAGE.RUNMODAL(PAGE::"Job Planning Lines", JT);
                end;
            }
            action("Edit Planning Lines - Schedule")
            {
                Caption = 'Edit Planning Lines - Schedule';
                ApplicationArea = All;

                trigger OnAction()
                var
                    JT: Record "Job Task";
                begin
                    Rec.TESTFIELD("Job Task Type", Rec."Job Task Type"::Posting);
                    Rec.TESTFIELD("Job No.");
                    Job.GET(Rec."Job No.");
                    Rec.TESTFIELD("Job Task No.");
                    JT.GET(Rec."Job No.", Rec."Job Task No.");
                    JT.FILTERGROUP := 2;
                    JT.SETRANGE("Job No.", Rec."Job No.");
                    JT.SETRANGE("Job Task Type", JT."Job Task Type"::Posting);
                    JT.FILTERGROUP := 0;
                    PAGE.RUNMODAL(PAGE::"Job Planning Lines Schedule", JT);
                end;
            }
        }
    }

    var
        myInt: Integer;

        Job: Record Job;

        JobDescription: Text[50];

    trigger OnOpenPage()
    begin
        //RAHEE1.00 090412
        IF (Job.Approved) THEN BEGIN
            IF (Job.Amended = TRUE) AND (Job."Amendment Approved" = FALSE) THEN
                CurrPage.EDITABLE(TRUE)
            ELSE
                CurrPage.EDITABLE(FALSE);
        END;
        //RAHEE1.00 090412
    end;


}