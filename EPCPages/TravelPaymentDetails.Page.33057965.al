page 97965 "Travel Payment Details"
{
    DelayedInsert = true;
    Editable = true;
    PageType = ListPart;
    SourceTable = "Travel Payment Details";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select; Rec.Select)
                {

                    trigger OnValidate()
                    begin
                        SelectOnPush;
                    end;
                }
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
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Gross TA Rate"; Rec."Gross TA Rate")
                {
                }
                field("Total Amount Area"; Rec."Total Amount Area")
                {
                    Caption = 'Amount';
                    Editable = false;
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Confirmed Order Date"; Rec."Confirmed Order Date")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                    Visible = false;
                }
                field("Associate Name"; Rec."Associate Name")
                {
                    Visible = false;
                }
                field("TA Re Generated"; Rec."TA Re Generated")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Sub Associate Code"; Rec."Sub Associate Code")
                {
                }
                field("Sub Associate Name"; Rec."Sub Associate Name")
                {
                    Editable = false;
                }
                field(Post; Rec.Post)
                {
                    Editable = false;
                }
                field("User ID"; Rec."User ID")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        IF TravelHdr.GET(Rec."Document No.") THEN BEGIN
            Test1 := 0;
            Test2 := 0;

            TravelPayDetails.RESET;
            TravelPayDetails.SETRANGE("Document No.", Rec."Document No.");
            TravelPayDetails.SETFILTER(Select, '%1', TRUE);
            IF TravelPayDetails.FINDSET THEN BEGIN
                REPEAT
                    Test1 := Test1 + TravelPayDetails."Saleable Area";
                    Test2 := Test2 + TravelPayDetails."Total Amount Area";
                UNTIL TravelPayDetails.NEXT = 0;
                TravelHdr."Total Saleable Area" := TotalArea;
                TravelHdr."Total Travell Amount" := TotalArea * TravelHdr."Project Rate";
                TravelHdr.MODIFY;
            END;
        END;
    end;

    var
        GatePassLine: Record "Gate Pass Line";
        GoldCoinSetup: Record "Gold Coin Line";
        GoldCoinEligibility: Record "Gold Coin Eligibility";
        GatePassHeader: Record "Gate Pass Header";
        DocNo: Code[20];
        Text001: Label 'Do you want to Insert the Lines?';
        CustNoFilter: Text[30];
        Stdate: Text[50];
        ConfOrder: Record "Confirmed Order";
        ProjectCodeFilter: Code[20];
        //GenerateTAEntry: Report 50067;
        TravelHdr: Record "Travel Header";
        TravelPayDetails: Record "Travel Payment Details";
        TotalArea: Decimal;
        TAForm: Page "Travel Generation 1";
        Test1: Decimal;
        Test2: Decimal;


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

        IF (Stdate <> '') THEN
            ConfOrder.SETFILTER("Posting Date", Stdate)
        ELSE
            ConfOrder.SETRANGE("Posting Date");
    end;

    local procedure SelectOnPush()
    begin
        Test1 := 0;
        Test2 := 0;
        IF TravelHdr.GET(Rec."Document No.") THEN BEGIN
            TravelPayDetails.RESET;
            TravelPayDetails.SETRANGE("Document No.", Rec."Document No.");
            TravelPayDetails.SETFILTER(Select, '%1', TRUE);
            IF TravelPayDetails.FINDSET THEN BEGIN
                REPEAT
                    Test1 := Test1 + TravelPayDetails."Saleable Area";
                    Test2 := Test2 + TravelPayDetails."Total Amount Area";
                UNTIL TravelPayDetails.NEXT = 0;
                TravelHdr."Total Saleable Area" := Test1;
                TravelHdr."Total Travell Amount" := Test2;
                TravelHdr.MODIFY;
            END;
        END;
    end;
}

