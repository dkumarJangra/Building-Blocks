page 97962 "Travel Sent for Approval"
{
    // // BBG1.01 ALLE_NB 261012 : Executing the travel Generator Report from form itself.

    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Travel Payment Entry";
    SourceTableView = WHERE("Appl. Not Show on Travel Form" = FILTER(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Project Code"; Rec."Project Code")
                {
                    Visible = false;
                }
                field("Project Name"; Rec."Project Name")
                {
                    Visible = false;
                }
                field("Sub Associate Code"; Rec."Sub Associate Code")
                {
                }
                field("Sub Associate Name"; Rec."Sub Associate Name")
                {
                }
                field("TA Rate"; Rec."TA Rate")
                {

                    trigger OnValidate()
                    begin
                        TARateOnAfterValidate;
                    end;
                }
                field("Total Area"; Rec."Total Area")
                {
                    Caption = 'Area';
                }
                field("Amount to Pay"; Rec."Amount to Pay")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        CalculateTotalamtToPay;
                        AmounttoPayOnAfterValidate;
                    end;
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                    Editable = false;
                }
                field("Approval Sender  Name"; Rec."Approval Sender  Name")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CalculateArea;
    end;

    trigger OnOpenPage()
    begin
        CalculateTotalamtToPay;
    end;

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
        //GenerateTAEntry: Report 50067;
        TravelPaymentEntry: Record "Travel Payment Entry";
        TravelPayDetails: Record "Travel Payment Entry";
        TotalArea: Decimal;
        RateSqrd: Decimal;
        TotalAmt: Decimal;
        Travelsetup: Record "Travel Setup Header";
        THeader: Record "Travel Header";
        Vend: Record Vendor;
        Text50000: Label 'Do you want to generate lines?';
        TravelGenEntry: Record "Travel Payment Entry";
        TravelEntry: Record "Travel Payment Entry";
        TotalArea1: Decimal;
        TAEntry: Record "Travel Payment Entry";
        TAEntry1: Record "Travel Payment Entry";
        //GenerateTAEntry1: Report 50070;
        Text50001: Label 'Selected lines have been sent for approval.';
        Text50003: Label 'Do you want send the selected lines for approval?';
        Text50002: Label 'There is nothing to send for approval.';
        //AssociatTAHierarchy: Report 50094;
        TADetails: Record "Travel Payment Details";
        TotalAmttoPay: Decimal;
        TAPayDetail: Record "Travel Payment Details";
        TADocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Unitsetup: Record "Unit Setup";
        ChainMgt: Codeunit "Unit Post";
        Chain: Record Vendor;
        AmountPaid: Decimal;
        Integer1: Record Integer;
        TopMember: Code[20];
        TravelHeader: Record "Travel Header";
        CheckRate: Decimal;
        Text50004: Label 'Assigned TA Rate is= %1. This Rate can not be greater than Project Rate=%2';


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
            Rec.SETFILTER("Team Lead", CustNoFilter)
        ELSE
            Rec.SETRANGE("Team Lead");

        IF ProjectCodeFilter <> '' THEN
            Rec.SETFILTER("Project Code", ProjectCodeFilter)
        ELSE
            Rec.SETRANGE("Project Code");

        IF (Stdate <> 0D) THEN
            Rec.SETRANGE("Creation Date", 0D, Stdate)
        ELSE
            Rec.SETRANGE("Creation Date");

        CalculateTotalamtToPay;
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

        IF (Stdate <> 0D) THEN
            ConfOrder.SETRANGE("Posting Date", 0D, Stdate)
        ELSE
            ConfOrder.SETRANGE("Posting Date");
    end;


    procedure CalculateArea()
    begin
        TotalAmt := 0;
        RateSqrd := 0;
        TotalArea := 0;
        TADetails.RESET;
        TADetails.SETRANGE("Associate Code", CustNoFilter);
        TADetails.SETRANGE(Select, TRUE);
        TADetails.SETRANGE("Creation Date", Stdate);
        TADetails.SETRANGE("User ID", USERID);
        IF ProjectCodeFilter <> '' THEN
            TADetails.SETRANGE("Project Code", ProjectCodeFilter);
        IF TADetails.FINDSET THEN
            REPEAT
                TotalArea := TotalArea + TADetails."Saleable Area";
            UNTIL TADetails.NEXT = 0;

        //TotalAmt := TotalArea * RateSqrd;
    end;


    procedure CalculateTotalamtToPay(): Decimal
    var
        TravelPaymentEntry: Record "Travel Payment Entry";
    begin

        TravelPaymentEntry.RESET;
        TravelPaymentEntry.SETCURRENTKEY("Document No.");
        TravelPaymentEntry.SETRANGE("Document No.", Rec."Document No.");
        TravelPaymentEntry.CALCSUMS("Amount to Pay");
        TotalAmttoPay := TravelPaymentEntry."Amount to Pay";
    end;

    local procedure TARateOnAfterValidate()
    begin
        IF THeader.GET(Rec."Document No.") THEN BEGIN
            CheckRate := 0;
            TravelPaymentEntry.RESET;
            TravelPaymentEntry.SETRANGE("Document No.", Rec."Document No.");
            TravelPaymentEntry.SETFILTER("Line No.", '<>%1', Rec."Line No.");
            //IF TravelPaymentEntry.FINDSET THEN
            TravelPaymentEntry.CALCSUMS("TA Rate");
            CheckRate := CheckRate + TravelPaymentEntry."TA Rate";
            IF (CheckRate + Rec."TA Rate") > THeader."Project Rate" THEN BEGIN
                MESSAGE(Text50004, FORMAT((CheckRate + Rec."TA Rate")), FORMAT(THeader."Project Rate"));
                Rec."TA Rate" := 0;
            END;
            Rec.VALIDATE("Amount to Pay", (Rec."TA Rate" * Rec."Total Area"));
        END;
    end;

    local procedure AmounttoPayOnAfterValidate()
    begin
        CalculateTotalamtToPay;

        TotalAmttoPay += Rec."Amount to Pay" - xRec."Amount to Pay";
        //TotalAmttoPay += "Amount to Pay";
        IF TravelHeader.GET(Rec."Document No.") THEN BEGIN
            TravelHeader.CALCFIELDS(TravelHeader."Total Travell Amount");
            IF TravelHeader."Total Travell Amount" < TotalAmttoPay THEN BEGIN
                MESSAGE('Amount to Pay can not be greater than Total Amt =' + FORMAT(TotalAmt));
                Rec."Amount to Pay" := 0;
                Rec."TDS Amount" := 0;
                TotalAmttoPay := 0;
            END;
        END;
    end;
}

