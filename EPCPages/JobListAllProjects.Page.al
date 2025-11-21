page 50067 "Job List (All Projects)"
{
    // //RAHEE1.00 070512 Code for show according to Responsibility Center

    Caption = 'Job List';
    Editable = false;
    PageType = Card;
    SourceTable = Job;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Description; Rec.Description)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Trading; Rec.Trading)
                {
                }
                field("Non-Trading"; Rec."Non-Trading")
                {
                }
                field("Region Code for Rank Hierarcy"; Rec."Region Code for Rank Hierarcy")
                {
                }
                field("Default Project Type"; Rec."Default Project Type")
                {
                }
                field("Total No. of Units"; Rec."Total No. of Units")
                {
                }
                field("Total Unit Sold"; Rec."Total Unit Sold")
                {
                }
                field("Total Project Cost"; Rec."Total Project Cost")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Launch Date"; Rec."Launch Date")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field(Status; Rec.Status)
                {
                    Visible = false;
                }
                field("Person Responsible"; Rec."Person Responsible")
                {
                    Visible = false;
                }
                field("Job Posting Group"; Rec."Job Posting Group")
                {
                    Visible = false;
                }
                field("Company Name"; Rec."Company Name")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Job")
            {
                Caption = '&Job';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Job Card";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Job),
                                  "No." = FIELD("No.");
                }
                action("Project Card")
                {
                    Caption = 'Project Card';
                    Image = "1099Form";
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Project Card";
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    action("Dimensions-Single")
                    {
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = CONST(167),
                                      "No." = FIELD("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        Caption = 'Dimensions-&Multiple';

                        trigger OnAction()
                        var
                            Job: Record Job;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SETSELECTIONFILTER(Job);
                            //DefaultDimMultiple.SetMultiJob(Job);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Job Ledger Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Job Task Lines")
                {
                    Caption = 'Job Task Lines';
                    Image = TaskList;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        JTLines: Page "Job Task Lines";
                    begin
                        JTLines.SetJobNo(Rec."No.");
                        JTLines.RUN;
                    end;
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Job Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
            }
            group("W&IP")
            {
                Caption = 'W&IP';
                action("Calculate WIP")
                {
                    Caption = 'Calculate WIP';
                    Ellipsis = true;
                    Image = CalculateWIP;

                    trigger OnAction()
                    var
                        Job: Record Job;
                    begin
                        Rec.TESTFIELD("No.");
                        Job.COPY(Rec);
                        Job.SETRANGE("No.", Rec."No.");
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
                        Rec.TESTFIELD("No.");
                        Job.COPY(Rec);
                        Job.SETRANGE("No.", Rec."No.");
                        REPORT.RUNMODAL(REPORT::"Job Post WIP to G/L", TRUE, FALSE, Job);
                    end;
                }
                action("WIP Entries")
                {
                    Caption = 'WIP Entries';
                    RunObject = Page "Job WIP Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.", "Job Posting Group", "WIP Posting Date");
                }
                action("WIP G/L Entries")
                {
                    Caption = 'WIP G/L Entries';
                    RunObject = Page "Job WIP G/L Entries";
                    RunPageLink = "Job No." = FIELD("No.");
                    RunPageView = SORTING("Job No.");
                }
            }
            group("&Prices")
            {
                Caption = '&Prices';
                action(Resource)
                {
                    Caption = 'Resource';
                    RunObject = Page "Job Resource Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                }
                action(Item)
                {
                    Caption = 'Item';
                    RunObject = Page "Job Item Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                }
                action("G/L Account")
                {
                    Caption = 'G/L Account';
                    RunObject = Page "Job G/L Account Prices";
                    RunPageLink = "Job No." = FIELD("No.");
                }
            }
            group("Plan&ning")
            {
                Caption = 'Plan&ning';
                action("Resource &Allocated per Job")
                {
                    Caption = 'Resource &Allocated per Job';
                    RunObject = Page "Resource Allocated per Job";
                }
                action("Res. Group All&ocated per Job")
                {
                    Caption = 'Res. Group All&ocated per Job';
                    RunObject = Page "Res. Gr. Allocated per Job";
                }
            }
        }
    }

    var
        UserMgt: Codeunit "EPC User Setup Management";
        OpenJob: Boolean;


    procedure OpenJobfromBG(VOpen: Boolean)
    begin
    end;
}

