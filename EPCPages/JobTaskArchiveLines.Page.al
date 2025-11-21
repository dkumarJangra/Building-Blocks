page 97803 "EPC Job Task Archive Lines"
{
    // ALLERP KRN0014 19-08-2010: Control added for total tender rate and total premium discount

    Caption = 'Job Task Archive Lines';
    DataCaptionFields = "Job No.";
    DelayedInsert = true;
    PageType = Card;
    SaveValues = true;
    SourceTable = "EPC Job Task Archive";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            field(CurrentJobNo; CurrentJobNo)
            {
                Caption = 'Job No.';
                TableRelation = "Job Archive";
                Visible = false;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SAVERECORD;
                    COMMIT;
                    Job."No." := CurrentJobNo;
                    IF PAGE.RUNMODAL(0, Job) = ACTION::LookupOK THEN BEGIN
                        Job.GET(Job."No.");
                        CurrentJobNo := Job."No.";
                        JobDescription := Job.Description;
                        Rec.FILTERGROUP := 2;
                        Rec.SETRANGE("Job No.", CurrentJobNo);
                        Rec.FILTERGROUP := 0;
                        IF Rec.FIND('-') THEN;
                        CurrPage.UPDATE(FALSE);
                    END;
                end;

                trigger OnValidate()
                begin
                    Job.GET(CurrentJobNo);
                    JobDescription := Job.Description;
                    CurrentJobNoOnAfterValidate;
                end;
            }
            field(JobDescription; JobDescription)
            {
                Editable = false;
                Visible = false;
            }
            repeater(Group)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                field("BOQ Type"; Rec."BOQ Type")
                {
                }
                field("BOQ Code"; Rec."BOQ Code")
                {
                }
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                }
                field("BOQ Qty."; Rec."BOQ Qty.")
                {
                    Editable = false;
                }
                field("BOQ Amt."; Rec."BOQ Amt.")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                }
                field("Job Task Type"; Rec."Job Task Type")
                {
                }
                field("WIP-Total"; Rec."WIP-Total")
                {
                }
                field(Totaling; Rec.Totaling)
                {
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                }
                field("Schedule (Total Cost)"; Rec."Schedule (Total Cost)")
                {
                }
                field("Schedule (Total Price)"; Rec."Schedule (Total Price)")
                {
                }
                field("Usage (Total Cost)"; Rec."Usage (Total Cost)")
                {
                    Visible = false;
                }
                field("Usage (Total Price)"; Rec."Usage (Total Price)")
                {
                    Visible = false;
                }
                field("Contract (Total Cost)"; Rec."Contract (Total Cost)")
                {
                }
                field("Contract (Total Price)"; Rec."Contract (Total Price)")
                {
                }
                field("Contract (Invoiced Cost)"; Rec."Contract (Invoiced Cost)")
                {
                    Visible = false;
                }
                field("Contract (Invoiced Price)"; Rec."Contract (Invoiced Price)")
                {
                    Visible = false;
                }
                field("WIP Amount"; Rec."WIP Amount")
                {
                    Visible = false;
                }
                field("Total Tender Rate"; Rec."Total Tender Rate")
                {
                }
                field("Total Premium/Disc. Amount"; Rec."Total Premium/Disc. Amount")
                {
                }
                field("Invoiced Sales Amount"; Rec."Invoiced Sales Amount")
                {
                    Visible = false;
                }
                field("Cost Completion %"; Rec."Cost Completion %")
                {
                    Visible = false;
                }
                field("Invoiced %"; Rec."Invoiced %")
                {
                    Visible = false;
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Outstanding Orders"; Rec."Outstanding Orders")
                {
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        PurchLine: Record "Purchase Line";
                    begin
                        PurchLine.SETCURRENTKEY("Document Type", "Job No.", "Job Task No.");
                        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
                        PurchLine.SETRANGE("Job No.", Rec."Job No.");
                        PurchLine.SETRANGE("Job Task No.", Rec."Job Task No.");
                        PurchLine.SETFILTER("Outstanding Amount (LCY)", '<> 0');
                        PAGE.RUNMODAL(PAGE::"Purchase Lines", PurchLine);
                    end;
                }
                field("Amt. Rcd. Not Invoiced"; Rec."Amt. Rcd. Not Invoiced")
                {
                    Editable = false;
                    Visible = false;

                    trigger OnDrillDown()
                    var
                        PurchLine: Record "Purchase Line";
                    begin
                        PurchLine.SETCURRENTKEY("Document Type", "Job No.", "Job Task No.");
                        PurchLine.SETRANGE("Document Type", PurchLine."Document Type"::Order);
                        PurchLine.SETRANGE("Job No.", Rec."Job No.");
                        PurchLine.SETRANGE("Job Task No.", Rec."Job Task No.");
                        PurchLine.SETFILTER("Amt. Rcd. Not Invoiced (LCY)", '<> 0');
                        PAGE.RUNMODAL(PAGE::"Purchase Lines", PurchLine);
                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("W&IP")
            {
                Caption = 'W&IP';
                Visible = false;
                action("Calculate WIP")
                {
                    Caption = 'Calculate WIP';
                    Ellipsis = true;
                    Image = CalculateWIP;

                    trigger OnAction()
                    var
                        Job: Record Job;
                    begin
                        Rec.TESTFIELD("Job No.");
                        Job.GET(Rec."Job No.");
                        Job.SETRANGE("No.", Job."No.");
                        REPORT.RUNMODAL(REPORT::"Job Calculate WIP", TRUE, FALSE, Job);
                    end;
                }
                action("Post WIP to G/L")
                {
                    Caption = 'Post WIP to G/L';
                    Ellipsis = true;
                    Image = Post;

                    trigger OnAction()
                    var
                        Job: Record Job;
                    begin
                        Rec.TESTFIELD("Job No.");
                        Job.GET(Rec."Job No.");
                        Job.SETRANGE("No.", Job."No.");
                        REPORT.RUNMODAL(REPORT::"Job Post WIP to G/L", TRUE, FALSE, Job);
                    end;
                }
                action("WIP Entries")
                {
                    Caption = 'WIP Entries';
                    RunObject = Page "Job WIP Entries";
                    RunPageLink = "Job No." = FIELD("Job No.");
                    RunPageView = SORTING("Job No.", "Job Posting Group", "WIP Posting Date");
                }
                action("WIP G/L Entries")
                {
                    Caption = 'WIP G/L Entries';
                    RunObject = Page "Job WIP G/L Entries";
                    RunPageLink = "Job No." = FIELD("Job No.");
                    RunPageView = SORTING("Job No.");
                }
            }
            group("&Job Task")
            {
                Caption = '&Job Task';
                action("Job &Task Card")
                {
                    Caption = 'Job &Task Card';
                    RunObject = Page "Job Task Card";
                    RunPageLink = "Job No." = FIELD("Job No."),
                                  "Job Task No." = FIELD("Job Task No.");
                    ShortCutKey = 'Shift+F7';
                    Visible = false;
                }
                action("Job Task Ledger E&ntries")
                {
                    Caption = 'Job Task Ledger E&ntries';
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No." = FIELD("Job No."),
                                  "Job Task No." = FIELD("Job Task No.");
                    RunPageView = SORTING("Job No.", "Job Task No.");
                    ShortCutKey = 'Ctrl+F7';
                    Visible = false;
                }
                action("Job Task &Planning Lines")
                {
                    Caption = 'Job Task &Planning Lines';
                    RunObject = Page "Associate Advance Payment Form";
                    RunPageLink = "Paid To" = FIELD("Job No.");
                    //   Field1000 = FIELD("Job Task No."),
                    //   Field50085 = FIELD("Version No.");
                }
                action("Job Task &Statistics")
                {
                    Caption = 'Job Task &Statistics';
                    RunObject = Page "Job Task Statistics";
                    RunPageLink = "Job No." = FIELD("Job No."),
                                  "Job Task No." = FIELD("Job Task No.");
                    ShortCutKey = 'F7';
                    Visible = false;
                }
                separator("-")
                {
                    Caption = '-';
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Job Task Dimensions";
                    RunPageLink = "Job No." = FIELD("Job No."),
                                  "Job Task No." = FIELD("Job Task No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    Visible = false;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Visible = false;
                action("Edit Planning Lines - Contract")
                {
                    Caption = 'Edit Planning Lines - Contract';
                    Ellipsis = true;

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
                action("Create Sales Invoice")
                {
                    Caption = 'Create Sales Invoice';
                    Ellipsis = true;
                    Image = Invoice;

                    trigger OnAction()
                    var
                        Job: Record "EPC Job Archive";
                        JT: Record "EPC Job Task Archive";
                    begin
                        Rec.TESTFIELD("Job No.");
                        Job.GET(Rec."Job No.");
                        IF Job.Blocked = Job.Blocked::All THEN
                            Job.TestBlocked;

                        JT := Rec;
                        JT.SETRANGE("Job No.", Job."No.");
                        REPORT.RUNMODAL(REPORT::"Job Create Sales Invoice", TRUE, FALSE, JT);
                    end;
                }
                action("Split Planning Lines")
                {
                    Caption = 'Split Planning Lines';
                    Ellipsis = true;
                    Image = Splitlines;

                    trigger OnAction()
                    var
                        Job: Record "EPC Job Archive";
                        JT: Record "EPC Job Task Archive";
                    begin
                        Rec.TESTFIELD("Job No.");
                        Rec.TESTFIELD("Job Task No.");
                        JT := Rec;
                        Job.GET(Rec."Job No.");
                        IF Job.Blocked = Job.Blocked::All THEN
                            Job.TestBlocked;
                        JT.SETRANGE("Job No.", Job."No.");
                        JT.SETRANGE("Job Task No.", Rec."Job Task No.");

                        REPORT.RUNMODAL(REPORT::"Job Split Planning Line", TRUE, FALSE, JT);
                    end;
                }
                action("Change &Dates")
                {
                    Caption = 'Change &Dates';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        Job: Record Job;
                        JT: Record "Job Task";
                    begin
                        Rec.TESTFIELD("Job No.");
                        Job.GET(Rec."Job No.");
                        IF Job.Blocked = Job.Blocked::All THEN
                            Job.TestBlocked;
                        JT.SETRANGE("Job No.", Job."No.");
                        JT.SETRANGE("Job Task No.", Rec."Job Task No.");
                        REPORT.RUNMODAL(REPORT::"Change Job Dates", TRUE, FALSE, JT);
                    end;
                }
                action("Copy Job Task &From")
                {
                    Caption = 'Copy Job Task &From';
                    Ellipsis = true;
                    Image = CopyFromTask;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Job Task Type", Rec."Job Task Type"::Posting);
                        //CopyJobTask.SetCopyFrom(Rec);
                        //CopyJobTask.RUNMODAL;
                    end;
                }
                action("Copy Job Task &To")
                {
                    Caption = 'Copy Job Task &To';
                    Ellipsis = true;
                    Image = CopyToTask;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Job Task Type", Rec."Job Task Type"::Posting);
                        //CopyJobTask.SetCopyTo(Rec);
                        //CopyJobTask.RUNMODAL;
                    end;
                }
                action("Indent Job Tasks")
                {
                    Caption = 'Indent Job Tasks';
                    RunObject = Codeunit "Job Task-Indent";
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        DescriptionIndent := 0;
        JobNoOnFormat;
        JobTaskNoOnFormat;
        DescriptionOnFormat;
    end;

    var
        Job: Record "EPC Job Archive";
        CurrentJobNo: Code[20];
        CurrentJobNo3: Code[20];
        JobDescription: Text[50];

        "Job No.Emphasize": Boolean;

        "Job Task No.Emphasize": Boolean;

        DescriptionEmphasize: Boolean;

        DescriptionIndent: Integer;


    procedure SetJobNo(CurrentJobNo2: Code[20])
    begin
        CurrentJobNo3 := CurrentJobNo2;
    end;

    local procedure CurrentJobNoOnAfterValidate()
    begin
        CurrPage.SAVERECORD;
        Rec.FILTERGROUP := 2;
        Rec.SETRANGE("Job No.", CurrentJobNo);
        Rec.FILTERGROUP := 0;
        IF Rec.FIND('-') THEN;
        CurrPage.UPDATE(FALSE);
    end;

    local procedure JobNoOnFormat()
    begin
        "Job No.Emphasize" := Rec."Job Task Type" <> Rec."Job Task Type"::Posting;
    end;

    local procedure JobTaskNoOnFormat()
    begin
        "Job Task No.Emphasize" := Rec."Job Task Type" <> Rec."Job Task Type"::Posting;
    end;

    local procedure DescriptionOnFormat()
    begin
        DescriptionIndent := Rec.Indentation;
        DescriptionEmphasize := Rec."Job Task Type" <> Rec."Job Task Type"::Posting;
    end;
}

