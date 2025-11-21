page 97966 "Travel Payment / Bank Entry"
{
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Travel Payment / Bank Entry";
    SourceTableView = WHERE(Post = CONST(false));
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
                    Caption = 'Associate Code';
                    TableRelation = Vendor;

                    trigger OnValidate()
                    begin
                        SetRecordFilters;
                        CalculateArea;
                        CustNoFilterOnAfterValidate;
                    end;
                }
                field(Stdate; Stdate)
                {
                    Caption = 'Upto Date';

                    trigger OnValidate()
                    begin
                        SetRecordFilters;
                        StdateOnAfterValidate;
                    end;
                }
                field(ProjectCodeFilter; ProjectCodeFilter)
                {
                    Caption = 'Project Code';
                    TableRelation = "Responsibility Center 1";

                    trigger OnValidate()
                    begin
                        SetRecordFilters;
                        CalculateArea;
                        ProjectCodeFilterOnAfterValida;
                    end;
                }
                field(TotalArea; TotalArea)
                {
                    Caption = 'Total Area';
                }
                field(RateSqrd; RateSqrd)
                {
                    Caption = 'Rate / Sqrd';
                }
                field(TotalAmt; TotalAmt)
                {
                    Caption = 'Total Amount';
                }
            }
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Total Area"; Rec."Total Area")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Amount to Associate"; Rec."Amount to Associate")
                {
                }
                field(Rate; Rec.Rate)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Sub Associate Code"; Rec."Sub Associate Code")
                {
                }
                field("Amount to Pay"; Rec."Amount to Pay")
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
        TravelPayDetails: Record "Travel Payment Entry";
        TotalArea: Decimal;
        RateSqrd: Decimal;
        TotalAmt: Decimal;
        Travelsetup: Record "Travel Setup Header";


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
            Rec.SETFILTER("Associate Code", CustNoFilter)
        ELSE
            Rec.SETRANGE("Associate Code");

        IF ProjectCodeFilter <> '' THEN
            Rec.SETFILTER("Project Code", ProjectCodeFilter)
        ELSE
            Rec.SETRANGE("Project Code");
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
        TravelPayDetails.RESET;
        TravelPayDetails.SETRANGE("Team Lead", CustNoFilter);
        IF ProjectCodeFilter <> '' THEN
            TravelPayDetails.SETRANGE("Project Code", ProjectCodeFilter);
        IF TravelPayDetails.FINDSET THEN
            REPEAT
                TotalArea := TotalArea + Rec."Total Area";
            UNTIL TravelPayDetails.NEXT = 0;
    end;

    local procedure CustNoFilterOnAfterValidate()
    begin
        CurrPage.UPDATE(FALSE);
    end;

    local procedure StdateOnAfterValidate()
    begin
        CurrPage.UPDATE(FALSE);
    end;

    local procedure ProjectCodeFilterOnAfterValida()
    begin
        CurrPage.UPDATE(FALSE);
    end;
}

