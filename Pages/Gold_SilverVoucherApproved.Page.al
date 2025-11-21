page 50387 "Gold_Silver VoucherApproved"
{
    // // BBG1.01_NB 231012 : Adding functionality of approving the selected lines.
    Caption = 'Approved Gold/Silver voucher Elegibility';
    DelayedInsert = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Gold/Silver Voucher Eleg.";
    SourceTableView = WHERE(Approved = CONST(true));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(CustNoFilter; CustNoFilter)
                {
                    Caption = 'Customer Filter';
                    TableRelation = Customer;

                    trigger OnValidate()
                    begin
                        SetRecordFilters;
                        CustNoFilterOnAfterValidate;
                    end;
                }
                field(Stdate; Stdate)
                {
                    Caption = 'From Date';

                    trigger OnValidate()
                    begin
                        SetRecordFilters;
                        StdateOnAfterValidate;
                    end;
                }
                field(Endate; Endate)
                {
                    Caption = 'To Date';

                    trigger OnValidate()
                    begin
                        SetRecordFilters;
                        EndateOnAfterValidate;
                    end;
                }
                field(ProjectCodeFilter; ProjectCodeFilter)
                {
                    Caption = 'Project Filter';
                    TableRelation = "Responsibility Center 1";

                    trigger OnValidate()
                    begin
                        SetRecordFilters;
                        ProjectCodeFilterOnAfterValida;
                    end;
                }
            }
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Application Date"; Rec."Application Date")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                // field("Item Type"; Rec."Item Type")
                // {
                // }
                field("Due Amount"; Rec."Due Amount")
                {
                }
                field("Amount Received"; Rec."Amount Received")
                {
                }
                field("Min. Allotment"; Rec."Min. Allotment")
                {
                }
                field("Plot No."; Rec."Plot No.")
                {
                }
                field("Total Unit Amount"; Rec."Total Unit Amount")
                {
                }
                field("Issue Request"; Rec."Issue Request")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Send for Approval"; Rec."Send for Approval")
                {
                }
                field("Sent By for Approval"; Rec."Sent By for Approval")
                {
                }
                field("Sent By for Approval Name"; Rec."Sent By for Approval Name")
                {
                }
                field(Approved; Rec.Approved)
                {
                }
                field("Approved By"; Rec."Approved By")
                {
                }
                field("Approver Name"; Rec."Approver Name")
                {
                }
                field("Issued Date"; Rec."Issued Date")
                {
                }
                field("Issued Gold / Silver"; Rec."Issued Gold / Silver")
                {
                    Editable = false;
                }
                field("Eligibility Gold / Silver"; Rec."Gold/Silver Voucher Elg.")
                {
                }
            }
        }
    }

    actions
    {

    }

    var
        GatePassLine: Record "Gate Pass Line";
        GoldCoinSetup: Record "Gold Coin Line";
        GoldCoinEligibility: Record "Gold Coin Eligibility";
        GatePassHeader: Record "Gate Pass Header";
        DocNo: Code[20];
        Text001: Label 'Do you want to Insert the Lines?';
        CustNoFilter: Text[30];
        Stdate: Date;
        ConfOrder: Record "Confirmed Order";
        ProjectCodeFilter: Code[20];
        GenerateCoinEntry: Report "Generate Coin Entry";
        Text50002: Label 'Do you want to return the selected lines?';
        Text50003: Label 'Selected lines are returned.';
        Text50004: Label 'There is nothing to return.';
        GoldCoin: Record "Gold Coin Eligibility";
        Endate: Date;


    procedure SetDocNo(OrDocNo: Code[20])
    begin
        DocNo := OrDocNo;
    end;


    procedure InsertLineData(GoldCoinApproval: Record "Gold Coin Eligibility"; ItemNo: Code[20])
    begin
        GatePassHeader.GET(GatePassHeader."Document Type"::MIN, DocNo);
        GatePassLine.INIT;
        GatePassLine."Document Type" := GatePassLine."Document Type"::MIN;
        GatePassLine."Document No." := DocNo;
        GatePassLine."Line No." := AssignLineNo;
        GatePassLine.VALIDATE("Item No.", ItemNo);
        GatePassLine."Required Qty" := GoldCoinApproval."Eligibility Gold / Silver";
        GatePassLine."Application No." := GoldCoinApproval."Application No.";
        GatePassLine."Application Line No." := GoldCoinApproval."Line No.";
        GatePassLine."Shortcut Dimension 1 Code" := GatePassHeader."Shortcut Dimension 1 Code";
        GatePassLine."Shortcut Dimension 2 Code" := GatePassHeader."Shortcut Dimension 2 Code";
        GatePassLine."Cost Centre Name" := GatePassHeader."Cost Centre Name";
        GatePassLine."Purchase Order No." := GatePassHeader."Purchase Order No.";
        GatePassLine."Gen. Bus. Posting Group" := GatePassHeader."Gen. Business Posting Group";
        GatePassLine."Location Code" := GatePassHeader."Location Code";
        GatePassLine.INSERT(TRUE);
    end;


    procedure AssignLineNo(): Integer
    var
        TempGatePassLine: Record "Gate Pass Line";
    begin
        TempGatePassLine.RESET;
        TempGatePassLine.SETRANGE("Document No.", DocNo);
        IF TempGatePassLine.FINDLAST THEN
            EXIT(TempGatePassLine."Line No." + 10000)
        ELSE
            EXIT(10000);
    end;


    procedure SetRecordFilters()
    begin
        IF CustNoFilter <> '' THEN
            Rec.SETFILTER("Customer No.", CustNoFilter)
        ELSE
            Rec.SETRANGE("Customer No.");

        IF ProjectCodeFilter <> '' THEN
            Rec.SETFILTER("Project Code", ProjectCodeFilter)
        ELSE
            Rec.SETRANGE("Project Code");

        IF (Stdate <> 0D) AND (Endate <> 0D) THEN
            Rec.SETRANGE("Application Date", Stdate, Endate)
        ELSE
            Rec.SETRANGE("Application Date");
    end;


    procedure SetRecordFilters1(var ConfOrder: Record "Confirmed Order")
    begin
        IF CustNoFilter <> '' THEN
            ConfOrder.SETFILTER("Customer No.", CustNoFilter)
        ELSE
            ConfOrder.SETRANGE("Customer No.");

        IF ProjectCodeFilter <> '' THEN
            ConfOrder.SETFILTER("Shortcut Dimension 1 Code", ProjectCodeFilter)
        ELSE
            ConfOrder.SETRANGE("Shortcut Dimension 1 Code");

        IF (Stdate <> 0D) AND (Endate <> 0D) THEN
            ConfOrder.SETRANGE("Posting Date", Stdate, Endate)
        ELSE
            ConfOrder.SETRANGE("Posting Date");
    end;

    local procedure CustNoFilterOnAfterValidate()
    begin
        CurrPage.UPDATE(FALSE);
    end;

    local procedure ProjectCodeFilterOnAfterValida()
    begin
        CurrPage.UPDATE(FALSE);
    end;

    local procedure StdateOnAfterValidate()
    begin
        CurrPage.UPDATE(FALSE);
    end;

    local procedure EndateOnAfterValidate()
    begin
        CurrPage.UPDATE(FALSE);
    end;
}

