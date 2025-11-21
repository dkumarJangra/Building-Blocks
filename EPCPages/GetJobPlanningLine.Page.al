page 97830 "Get Job Planning Line"
{
    AutoSplitKey = true;
    Caption = 'Job Planning Line Subform';
    DataCaptionExpression = Rec.Caption;
    DelayedInsert = true;
    Editable = false;
    PageType = Card;
    SourceTable = "Job Planning Line";
    SourceTableView = WHERE("Line Type" = FILTER('Schedule'));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job Contract Entry No."; Rec."Job Contract Entry No.")
                {
                    Visible = true;
                }
                field("Job Master Code"; Rec."Job Master Code")
                {
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
                field("Total Amount"; Rec."Total Amount")
                {
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
                field("Ending Date"; Rec."Ending Date")
                {
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
                field("Description 2"; Rec."Description 2")
                {
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
                field("Indent Quantity"; Rec."Indent Quantity")
                {
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
                    Editable = "Direct Unit Cost (LCY)Editable";
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
            action(OK)
            {
                Caption = 'OK';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CurrPage.SETSELECTIONFILTER(Rec);
                    CreatePRRequest(Rec);
                    CurrPage.CLOSE;
                end;
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
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //TESTFIELD(Transferred,FALSE); // ALLE MM
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
        BBGOnAfterGetCurrRecord;
    end;

    var
        PRRequestLine: Record "Purchase Request Line";
        PRRequestDoctype: Option Indent;
        PRRequestDocNo: Code[20];
        PurchaseLIne: Record "Purchase Line";
        TargetCost: Decimal;

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

        "Direct Unit Cost (LCY)Editable": Boolean;

        "Unit CostEditable": Boolean;


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
        //CurrPAGE."Line Type".EDITABLE := Edit;
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
        //CurrPAGE."Line Amount (LCY)".EDITABLE := Edit;
        "Direct Unit Cost (LCY)Editable" := Edit;
        //CurrPAGE."Unit Cost (LCY)".EDITABLE := Edit;
        "Unit CostEditable" := Edit;
    end;


    procedure GetInvoice()
    var
        JobCreateInvoice: Codeunit "Job Create-Invoice";
    begin
        JobCreateInvoice.GetJobPlanningLineInvoices(Rec);
    end;


    procedure CreatePRRequest(var PlanningLine3: Record "Job Planning Line")
    var
        PRRequest: Record "Purchase Request Header";
        PlanningLine2: Record "Job Planning Line";
    begin
        IF PlanningLine3.FIND('-') THEN BEGIN
            PRRequest.LOCKTABLE;
            REPEAT
                PRRequest.GET(PRRequestDoctype, PRRequestDocNo);
                PRRequestLine.FillJobPlanningLine(PlanningLine3, PRRequest);
            //TargetCost := TargetCost + PlanningLine3."Target Cost";
            UNTIL PlanningLine3.NEXT = 0;
            //PRRequest."Cost Centre Name" := PRRequest."Cost Centre Name" + TargetCost;
            PRRequest.MODIFY
        END;
    end;


    procedure Setpurchseheader(PRHeaderDocType: Option Indent; PRHeaderDocNo: Code[20])
    begin
        PRRequestDoctype := PRHeaderDocType;
        PRRequestDocNo := PRHeaderDocNo;
    end;


    procedure CreatePurchaseLine(var PlanningLine3: Record "Job Planning Line")
    var
        Purchheader: Record "Purchase Header";
        PlanningLine2: Record "Job Planning Line";
    begin
        IF PlanningLine3.FIND('-') THEN BEGIN
            Purchheader.LOCKTABLE;
            REPEAT
                Purchheader.GET(PRRequestDoctype, PRRequestDocNo);
            //PRRequestLine.FillJobPlanningLine(PlanningLine3,Purchheader);
            UNTIL PlanningLine3.NEXT = 0;
        END;
    end;


    procedure Setpurchaseheader(PRHeaderDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; PRHeaderDocNo: Code[20])
    begin
        PRRequestDoctype := PRHeaderDocType;
        PRRequestDocNo := PRHeaderDocNo;
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        //SetEditable(NOT Transferred); // ALLE MM
    end;
}

