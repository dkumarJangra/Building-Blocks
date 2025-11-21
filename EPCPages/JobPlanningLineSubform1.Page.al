page 98017 "Job Planning Line Subform1"
{
    AutoSplitKey = true;
    DataCaptionExpression = Rec.Caption;
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Job Planning Line";
    SourceTableView = WHERE("Line Type" = CONST(Schedule),
                            Type = CONST(Item));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Contract Entry No."; Rec."Job Contract Entry No.")
                {
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Line Type"; Rec."Line Type")
                {
                    Editable = "Line TypeEditable";
                }
                field("Planning Date"; Rec."Planning Date")
                {
                    Editable = "Planning DateEditable";
                }
                field("Currency Date"; Rec."Currency Date")
                {
                    Editable = "Currency DateEditable";
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = "Document No.Editable";
                }
                field(Type; Rec.Type)
                {
                    Editable = TypeEditable;
                }
                field("No."; Rec."No.")
                {
                    Editable = "No.Editable";
                }
                field(Description; Rec.Description)
                {
                    Editable = DescriptionEditable;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Visible = false;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = false;
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    Editable = "Variant CodeEditable";
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = "Location CodeEditable";
                }
                field("Work Type Code"; Rec."Work Type Code")
                {
                    Editable = "Work Type CodeEditable";
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = "Unit of Measure CodeEditable";
                }
                field(Quantity; Rec.Quantity)
                {
                    Editable = QuantityEditable;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                }
                field("Total Cost (LCY)"; Rec."Total Cost (LCY)")
                {
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    Editable = "Unit PriceEditable";
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    Editable = "Line AmountEditable";
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    Editable = "Line Discount AmountEditable";
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    Editable = "Line Discount %Editable";
                }
                field("Unit Price (LCY)"; Rec."Unit Price (LCY)")
                {
                    Visible = false;
                }
                field("Total Price"; Rec."Total Price")
                {
                    Visible = false;
                }
                field("Line Amount (LCY)"; Rec."Line Amount (LCY)")
                {
                    Visible = false;
                }
                field("Direct Unit Cost (LCY)"; Rec."Direct Unit Cost (LCY)")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    Editable = "Unit CostEditable";
                    Visible = false;
                }
                field("Total Cost"; Rec."Total Cost")
                {
                    Visible = false;
                }
                field("Total Price (LCY)"; Rec."Total Price (LCY)")
                {
                    Visible = false;
                }
                field("Invoiced Amount (LCY)"; Rec."Invoiced Amount (LCY)")
                {
                }
                field("Invoiced Cost Amount (LCY)"; Rec."Invoiced Cost Amount (LCY)")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Create &Sales Invoice")
                {
                    Caption = 'Create &Sales Invoice';
                    Ellipsis = true;
                    Image = Invoice;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #98018. Unsupported part was commented. Please check it.
                        /*CurrPage.PlanningLines.PAGE.*/
                        _CreateSalesInvoice(FALSE);

                    end;
                }
                action("Create Sales &Credit Memo")
                {
                    Caption = 'Create Sales &Credit Memo';
                    Ellipsis = true;
                    Image = CreditMemo;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #98018. Unsupported part was commented. Please check it.
                        /*CurrPage.PlanningLines.PAGE.*/
                        _CreateSalesInvoice(TRUE);

                    end;
                }
                action("Get Sales Invoice/Credit Memo")
                {
                    Caption = 'Get Sales Invoice/Credit Memo';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #98018. Unsupported part was commented. Please check it.
                        /*CurrPage.PlanningLines.PAGE.*/
                        GetInvoice;

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Unit CostEditable" := TRUE;
        "Line AmountEditable" := TRUE;
        "Line Discount %Editable" := TRUE;
        "Line Discount AmountEditable" := TRUE;
        "Unit PriceEditable" := TRUE;
        "Work Type CodeEditable" := TRUE;
        "Location CodeEditable" := TRUE;
        "Variant CodeEditable" := TRUE;
        "Unit of Measure CodeEditable" := TRUE;
        QuantityEditable := TRUE;
        DescriptionEditable := TRUE;
        "No.Editable" := TRUE;
        TypeEditable := TRUE;
        "Document No.Editable" := TRUE;
        "Currency DateEditable" := TRUE;
        "Planning DateEditable" := TRUE;
        "Line TypeEditable" := TRUE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //TESTFIELD(Transferred,FALSE); // ALLE MM

        IF Rec."System-Created Entry" = TRUE THEN
            IF NOT CONFIRM(Text001, FALSE) THEN
                ERROR('')
            ELSE
                Rec."System-Created Entry" := FALSE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
        BBGOnAfterGetCurrRecord;
    end;

    var
        Text001: Label 'This Job Planning Line is generated automatically. Do you want to continue?';

        "Line TypeEditable": Boolean;

        "Planning DateEditable": Boolean;

        "Currency DateEditable": Boolean;

        "Document No.Editable": Boolean;

        TypeEditable: Boolean;

        "No.Editable": Boolean;

        DescriptionEditable: Boolean;

        QuantityEditable: Boolean;

        "Unit of Measure CodeEditable": Boolean;

        "Variant CodeEditable": Boolean;

        "Location CodeEditable": Boolean;

        "Work Type CodeEditable": Boolean;

        "Unit PriceEditable": Boolean;

        "Line Discount AmountEditable": Boolean;

        "Line Discount %Editable": Boolean;

        "Line AmountEditable": Boolean;

        "Unit CostEditable": Boolean;


    procedure _CreateSalesInvoice(CrMemo: Boolean)
    var
        JobPlanningLine: Record "Job Planning Line";
        JobCreateInvoice: Codeunit "Job Create-Invoice";
    begin
        Rec.TESTFIELD("Line No.");
        JobPlanningLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(JobPlanningLine);
        JobCreateInvoice.CreateSalesInvoice(JobPlanningLine, CrMemo)
    end;


    procedure CreateSalesInvoice(CrMemo: Boolean)
    var
        JobPlanningLine: Record "Job Planning Line";
        JobCreateInvoice: Codeunit "Job Create-Invoice";
    begin
        Rec.TESTFIELD("Line No.");
        JobPlanningLine.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(JobPlanningLine);
        JobCreateInvoice.CreateSalesInvoice(JobPlanningLine, CrMemo)
    end;

    local procedure SetEditable(Edit: Boolean)
    begin
        "Line TypeEditable" := Edit;
        "Planning DateEditable" := Edit;
        "Currency DateEditable" := Edit;
        "Document No.Editable" := Edit;
        TypeEditable := Edit;
        "No.Editable" := Edit;
        DescriptionEditable := Edit;
        QuantityEditable := Edit;
        "Unit of Measure CodeEditable" := Edit;
        "Variant CodeEditable" := Edit;
        "Location CodeEditable" := Edit;
        "Work Type CodeEditable" := Edit;
        "Unit PriceEditable" := Edit;
        "Line Discount AmountEditable" := Edit;
        "Line Discount %Editable" := Edit;
        "Line AmountEditable" := Edit;
        "Unit CostEditable" := Edit;
    end;


    procedure GetInvoice()
    var
        JobCreateInvoice: Codeunit "Job Create-Invoice";
    begin
        JobCreateInvoice.GetJobPlanningLineInvoices(Rec);
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        //SetEditable(NOT Transferred); // ALLE MM
    end;
}

