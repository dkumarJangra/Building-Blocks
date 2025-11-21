page 97815 "Job Phases Overview"
{
    // ALLESP BCL0011 10-07-2007: New Form created to show Phase in Groups
    // ALLESP BCL0018 18-07-2007: Function Created to open the Hindrance form corresponding to BOQ item
    // KLND1.00 ALLEPG 190510 : Form adjusted.
    // ALLERP KRN0008 18-08-2010: Control added for Tender Rate and Premium/Discount Amount
    //                14-09-2010: control removed for premium discount amount

    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = "Job Task";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ActualExpansionStatus; ActualExpansionStatus)
                {
                    Caption = 'Expand';
                    Editable = false;
                    //OptionCaption = 'Integer';

                    trigger OnValidate()
                    begin
                        ActualExpansionStatusOnPush;
                    end;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                }
                field("BOQ Code"; Rec."BOQ Code")
                {
                    Caption = 'BoQ''s No.';
                    Editable = false;
                }
                field("BOQ Type"; Rec."BOQ Type")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Name; Rec."Phase Desc")
                {
                    Caption = 'Description 2';
                    Editable = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    Editable = false;
                    Visible = false;
                }
                field("BOQ Qty."; Rec."BOQ Qty.")
                {
                    Caption = 'Ordered BoQ''s Qty.';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Total Sales BOQ Amount"; Rec."Total Sales BOQ Amount")
                {
                    Caption = 'Total BoQ''s Amount';
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Total Purchase BOQ Amount"; Rec."Total Purchase BOQ Amount")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Total Tender Rate"; Rec."Total Tender Rate")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Completed Qty."; Rec."Completed Qty.")
                {
                    Caption = 'Completed BoQ''s Qty.';
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                }
                field("Completed Amt."; Rec."Completed Amt.")
                {
                    Caption = 'Completed BoQ''s Amount';
                    Editable = false;
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                }
                field("Rejected Qty."; Rec."Rejected Qty.")
                {
                    Caption = 'Rejected BoQ''s Qty.';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Rejected Amt."; Rec."Rejected Amt.")
                {
                    Caption = 'Rejected BoQ''s Amount';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Pending Qty."; Rec."Pending Qty.")
                {
                    Caption = 'Pending BoQ''s Qty.';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Pending Amt."; Rec."Pending Amt.")
                {
                    Caption = 'Pending BoQ''s Amount';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Status; Percent)
                {
                    Caption = 'Status';
                    Enabled = true;
                    ExtendedDatatype = Ratio;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin

        IF IsExpanded(Rec) THEN
            ActualExpansionStatus := 1
        ELSE
            IF HasChildren(Rec) THEN
                ActualExpansionStatus := 0
            ELSE
                ActualExpansionStatus := 2;

        //CALCFIELDS("Budgeted Cost","Usage (Cost)");
        Rec."Pending Qty." := Rec."BOQ Qty." - Rec."Completed Qty.";
        Rec."Pending Amt." := Rec."BOQ Amt." - Rec."Completed Amt.";

        Percent := 0;
        IF Rec."BOQ Qty." <> 0 THEN
            Percent := (Rec."Completed Qty." * 100 * 100) / Rec."BOQ Qty.";
        PhaseDescOnFormat;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        Found: Boolean;
    begin
        TempProjectTask.COPY(Rec);
        Found := TempProjectTask.FIND(Which);
        Rec := TempProjectTask;
        EXIT(Found);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        ResultSteps: Integer;
    begin
        TempProjectTask.COPY(Rec);
        ResultSteps := TempProjectTask.NEXT(Steps);
        Rec := TempProjectTask;
        EXIT(ResultSteps);
    end;

    trigger OnOpenPage()
    begin

        InitTempTable;
    end;

    var
        TempProjectTask: Record "Job Task" temporary;
        ActualExpansionStatus: Integer;
        Job: Record Job;
        CurrentJobNo: Code[20];
        JobBudgetLine: Record "Job Planning Line";
        Percent: Decimal;
        JT: Record "Job Task";

        NameEmphasize: Boolean;

    local procedure InitTempTable()
    begin
        CopyProjectTaskToTemp(TRUE);
    end;

    local procedure CopyProjectTaskToTemp(OnlyRoot: Boolean)
    var
        ProjectTask: Record "Job Task";
    begin
        TempProjectTask.DELETEALL;
        TempProjectTask.SETCURRENTKEY("Job No.");

        ProjectTask.SETFILTER("Job Task Type", '<>%1', ProjectTask."Job Task Type"::"End-Total");
        IF OnlyRoot THEN
            ProjectTask.SETRANGE(Indentation, 0);
        IF ProjectTask.FIND('-') THEN
            REPEAT
                TempProjectTask := ProjectTask;
                IF ProjectTask."Job Task Type" = ProjectTask."Job Task Type"::"Begin-Total" THEN
                    TempProjectTask.Totaling := GetEndTotal(ProjectTask);

                TempProjectTask.INSERT;
            UNTIL ProjectTask.NEXT = 0;
    end;

    local procedure IsExpanded(ActualProjectTask: Record "Job Task"): Boolean
    begin
        TempProjectTask := ActualProjectTask;
        IF TempProjectTask.NEXT = 0 THEN
            EXIT(FALSE)
        ELSE
            EXIT(TempProjectTask.Indentation > ActualProjectTask.Indentation);
    end;

    local procedure HasChildren(ActualProjectTask: Record "Job Task"): Boolean
    var
        ProjectTask2: Record "Job Task";
    begin
        ProjectTask2 := ActualProjectTask;
        IF ProjectTask2.NEXT = 0 THEN
            EXIT(FALSE)
        ELSE
            EXIT(ProjectTask2.Indentation > ActualProjectTask.Indentation);
    end;

    local procedure ToggleExpandCollapse()
    var
        ProjectTask: Record "Job Task";
    begin
        IF ActualExpansionStatus = 0 THEN BEGIN // Has children, but not expanded
            ProjectTask.SETRANGE("Job No.", Rec."Job No.");
            ProjectTask.SETFILTER("Job Task No.", '>%1', Rec."Job Task No.");
            ProjectTask.SETRANGE(Indentation, Rec.Indentation, Rec.Indentation + 1);
            ProjectTask.SETFILTER("Job Task Type", '<>%1', ProjectTask."Job Task Type"::"End-Total");//AERENGKG01
            ProjectTask := Rec;
            IF ProjectTask.NEXT <> 0 THEN
                REPEAT
                    IF ProjectTask.Indentation > Rec.Indentation THEN BEGIN
                        TempProjectTask := ProjectTask;
                        IF ProjectTask."Job Task Type" = ProjectTask."Job Task Type"::"Begin-Total" THEN
                            TempProjectTask.Totaling := GetEndTotal(ProjectTask);
                        IF TempProjectTask.INSERT THEN;
                    END;
                UNTIL (ProjectTask.NEXT = 0) OR (ProjectTask.Indentation = Rec.Indentation);
        END ELSE
            IF ActualExpansionStatus = 1 THEN BEGIN // Has children and is already expanded
                TempProjectTask := Rec;
                WHILE (TempProjectTask.NEXT <> 0) AND (TempProjectTask.Indentation > Rec.Indentation) DO
                    TempProjectTask.DELETE;
            END;

        CurrPage.UPDATE;
    end;


    procedure RefreshPAGE()
    begin
        InitTempTable;
        CurrPage.UPDATE(FALSE);
    end;


    procedure IndentF()
    var
        ProjectTask: Record "Job Task";
        ProjectTask2: Record "Job Task";
    begin
        ProjectTask.RESET;
        ProjectTask.MODIFYALL(Bold, FALSE);
        IF ProjectTask.FIND('-') THEN
            REPEAT
                ProjectTask2 := ProjectTask;
                IF ProjectTask2.NEXT <> 0 THEN
                    IF ProjectTask.Indentation < ProjectTask2.Indentation THEN BEGIN
                        ProjectTask.Bold := TRUE;
                        ProjectTask.MODIFY;
                    END;
            UNTIL ProjectTask.NEXT = 0;
    end;

    local procedure SelectCurrentJobNo()
    begin
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


    procedure OpenBudgetLines()
    var
        FrmJobBudget: Page "Job Planning Lines";
    begin
        IF Rec."Job Task Type" <> Rec."Job Task Type"::Posting THEN
            EXIT;
        JobBudgetLine.RESET;
        JobBudgetLine.FILTERGROUP := 4;
        JobBudgetLine.SETRANGE("Job No.", Rec."Job No.");
        JobBudgetLine.SETRANGE("Job Task No.", Rec."Job Task No.");
        JobBudgetLine.FILTERGROUP := 0;
        FrmJobBudget.SETTABLEVIEW(JobBudgetLine);
        //FrmJobBudget.SetJobPhase("Job No.",Code);
        FrmJobBudget.RUNMODAL;
    end;


    procedure Referesh()
    begin
        Rec.RESET;
        Rec.SETRANGE("Job No.", CurrentJobNo);
        IF Rec.FIND('-') THEN;
        TempProjectTask.DELETEALL;
        IndentF;
        InitTempTable;
    end;

    local procedure GetEndTotal(var ProjectTask: Record "Job Task"): Text[250]
    var
        ProjectTask2: Record "Job Task";
    begin
        ProjectTask2.SETFILTER("Job Task No.", '>%1', ProjectTask."Job Task No.");
        ProjectTask2.SETRANGE(Indentation, ProjectTask.Indentation);
        ProjectTask2.SETRANGE("Job Task Type", ProjectTask2."Job Task Type"::"End-Total");
        IF ProjectTask2.FIND('-') THEN
            EXIT(ProjectTask2.Totaling)
        ELSE
            EXIT('');
    end;


    procedure GetJobPlanningLine()
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

    local procedure ActualExpansionStatusOnPush()
    begin
        ToggleExpandCollapse;
    end;

    local procedure PhaseDescOnFormat()
    begin
        //CurrPage.Name.UPDATEINDENT((Indentation) * 220); // ALLE MM Code Commented
        NameEmphasize := Rec."Job Task Type" <> Rec."Job Task Type"::Posting;
    end;
}

