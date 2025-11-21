page 97816 "Job Phases"
{
    // ALLESP BCL0011 10-07-2007: New Form created to create group of Phases,Sub Phases etc for a Job

    Caption = 'Job Phases';
    DataCaptionFields = "Job No.";
    PageType = Card;
    SaveValues = true;
    SourceTable = "Job Task";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            field(JobNo; CurrentJobNo)
            {
                Caption = 'Project No.';
                TableRelation = Job;

                trigger OnValidate()
                begin
                    CurrentJobNoOnAfterValidate;
                end;
            }
            repeater(Group)
            {
                IndentationColumn = NameIndent;
                IndentationControls = Name;
                field("Phase Job No."; Phase."Job No.")
                {
                    Editable = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                }
                field("BOQ Code"; Rec."BOQ Code")
                {
                    Editable = false;
                }
                field(Name; Rec."Phase Desc")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Job Task Type"; Rec."Job Task Type")
                {
                    Caption = 'Value Type';
                    Editable = false;
                }
                field(Totaling; Rec.Totaling)
                {
                    Editable = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Editable = false;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    Editable = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    Visible = false;
                }
                field(Indentation; Rec.Indentation)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Parent Phase Code"; Rec."Parent Phase Code")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Parent Phase Description"; Rec."Parent Phase Description")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Item; Rec.Item)
                {
                }
                field("Job No."; Rec."Job No.")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        NameIndent := 0;
        Rec.SETRANGE("Job No.", CurrentJobNo);
        PhaseDescOnFormat;
        DescriptionOnFormat;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Job No." := CurrentJobNo;
    end;

    trigger OnOpenPage()
    begin
        CurrentJobNo := Rec."Job No.";
        IF CurrentJobNo <> '' THEN
            IF NOT Job.GET(CurrentJobNo) THEN
                CurrentJobNo := '';

        IF CurrentJobNo = '' THEN BEGIN
            IF Phase.FIND('-') THEN
                CurrentJobNo := Phase."Job No."
            ELSE
                CurrentJobNo := '';
        END;

        SelectCurrentJobNo;
    end;

    var
        Job: Record Job;
        CurrentJobNo: Code[20];
        Phase: Record "Job Task";
        JobBudgetLine: Record "Job Planning Line";

        NameEmphasize: Boolean;

        NameIndent: Integer;

    local procedure SelectCurrentJobNo()
    begin
        IF CurrentJobNo <> '' THEN
            Rec.SETRANGE("Job No.", CurrentJobNo);
        CurrPage.UPDATE(FALSE);
    end;


    procedure SetJobNo(pJobNo: Code[20])
    begin
        CurrentJobNo := pJobNo;
    end;


    procedure ClearJobNo()
    begin
        CurrentJobNo := '';
    end;

    local procedure CurrentJobNoOnAfterValidate()
    begin
        SelectCurrentJobNo;
    end;

    local procedure PhaseDescOnFormat()
    begin
        //CurrPage.Name.UPDATEINDENT((Indentation) * 220); // ALLE MM Code Commented
        NameEmphasize := Rec."Job Task Type" <> Rec."Job Task Type"::Posting;
    end;

    local procedure DescriptionOnFormat()
    begin
        NameEmphasize := Rec."Job Task Type" <> Rec."Job Task Type"::Posting;
        NameIndent := Rec.Indentation;
    end;
}

