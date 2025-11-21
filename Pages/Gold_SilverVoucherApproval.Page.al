page 50354 "Get Gold/Silver Voucher"
{
    // 251121 code comment

    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Gold/Silver Voucher Eleg.";
    SourceTableView = WHERE(Approved = FILTER(true),
                            "Gold/Silver Issue Status" = FILTER(Partial));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Issue Request"; Rec."Issue Request")
                {
                }
                field("Gold/Silver Voucher Elg."; Rec."Gold/Silver Voucher Elg.")
                {
                }
                field("Total No.of Gold/Silver Issued"; Rec."Total No.of Gold/Silver Issued")
                {
                    Visible = false;
                }
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
                field("Send for Approval"; Rec."Send for Approval")
                {
                }
                field(Approved; Rec.Approved)
                {
                }
                field("Issued to Customer"; Rec."Issued to Customer")
                {
                }
                field("Issued Date"; Rec."Issued Date")
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
                    IF CONFIRM(Text001, FALSE) THEN BEGIN
                        Unitsetup.GET;
                        GoldCoinEligibility.RESET;
                        GoldCoinEligibility.SETRANGE("Issue Request", TRUE);
                        GoldCoinEligibility.SETRANGE(GoldCoinEligibility.Approved, TRUE);
                        IF GoldCoinEligibility.FIND('-') THEN
                            REPEAT
                                GoldCoinEligibility.CALCFIELDS("Issued Gold / Silver");
                                //GoldCoinSetup.RESET;
                                // GoldCoinSetup.SETRANGE("Project Code","Project Code");
                                //  GoldCoinSetup.SETRANGE("Plot Size",Extent);
                                // GoldCoinSetup.SETFILTER("Effective Date",'<=%1',"Application Date");
                                //  IF GoldCoinSetup.FINDLAST THEN BEGIN
                                Unitsetup.TESTFIELD("Gold/Silver Voucher Item Code");

                                InsertLineData(GoldCoinEligibility, Unitsetup."Gold/Silver Voucher Item Code");
                                GoldCoinEligibility."Min Doc No." := DocNo;
                                GoldCoinEligibility."Issue Request" := FALSE;
                                GoldCoinEligibility.MODIFY;

                            //  END ELSE
                            //   ERROR('Gold Coin Setup is not defined for this Period');
                            UNTIL GoldCoinEligibility.NEXT = 0;
                        CurrPage.CLOSE;
                    END;
                end;
            }
        }
    }

    var
        GatePassLine: Record "Gate Pass Line";
        GoldCoinSetup: Record "Project Gold/Silver Voucher";
        GoldCoinEligibility: Record "Gold/Silver Voucher Eleg.";
        GatePassHeader: Record "Gate Pass Header";
        DocNo: Code[20];
        Text001: Label 'Do you want to Insert the Lines?';
        CustNoFilter: Text[30];
        Stdate: Text[50];
        ConfOrder: Record "Confirmed Order";
        ProjectCodeFilter: Code[20];
        Item: Record Item;
        Unitsetup: Record "Unit Setup";
        ItemJnl: Record "Item Journal Line";


    procedure SetDocNo(OrDocNo: Code[20])
    begin
        DocNo := OrDocNo;
    end;


    procedure InsertLineData(GoldCoinApproval: Record "Gold/Silver Voucher Eleg."; ItemNo: Code[20])
    var
        ConfirmedOrder: Record "Confirmed Order";
        ItemJnlLines_2: Record "Item Journal Line";
        Unitsetup: Record "Unit Setup";

        GatePassLines: Record "Gate Pass Line";
        ItemJournal: Record "Item Journal Line";
        EndLineNo: Integer;
        Gatepassheader: Record "Gate Pass Header";


    begin
        GatePassHeader.GET(GatePassHeader."Document Type"::MIN, DocNo);
        GatePassLine.INIT;
        GatePassLine."Document Type" := GatePassLine."Document Type"::MIN;
        GatePassLine."Document No." := DocNo;
        GatePassLine."Line No." := AssignLineNo;
        //Unitsetup.TESTFIELD("Item No.");

        GatePassLine.VALIDATE("Item No.", ItemNo);
        GatePassLine."Required Qty" := GoldCoinApproval."Gold/Silver Voucher Elg." - GoldCoinEligibility."Issued Gold / Silver";
        GatePassLine."Gold Coin Qty" := GoldCoinApproval."Gold/Silver Voucher Elg." - GoldCoinEligibility."Issued Gold / Silver";
        GatePassLine."Application No." := GoldCoinApproval."Application No.";
        GatePassLine."Application Line No." := GoldCoinApproval."Line No.";
        //BBG2.0
        //IF ConfirmedOrder.GET(GoldCoinApproval."Application No.") THEN   //251121 code comment
        //  GatePassLine."Shortcut Dimension 1 Code" := ConfirmedOrder."Shortcut Dimension 1 Code"  //251121 code comment
        //ELSE     //251121 code comment
        GatePassLine."Shortcut Dimension 1 Code" := GatePassHeader."Shortcut Dimension 1 Code";
        IF Item.GET(ItemNo) THEN
            Item.TESTFIELD(Item."Global Dimension 2 Code");
        GatePassLine."Shortcut Dimension 2 Code" := Item."Global Dimension 2 Code";
        GatePassLine."Cost Centre Name" := GatePassHeader."Cost Centre Name";
        GatePassLine."Purchase Order No." := GatePassHeader."Purchase Order No.";
        GatePassLine."Gen. Bus. Posting Group" := 'DOMESTIC';
        GatePassLine."Location Code" := GatePassLine."Shortcut Dimension 1 Code";
        GatePassHeader."Shortcut Dimension 1 Code" := GatePassLine."Shortcut Dimension 1 Code";  //BBG2.0
        GatePassHeader."Location Code" := GatePassLine."Shortcut Dimension 1 Code";    //BBG2.0
        GatePassHeader."Job No." := GatePassLine."Shortcut Dimension 1 Code";   //BBG2.0
        GatePassHeader."Responsibility Center" := GatePassLine."Shortcut Dimension 1 Code";   //BBG2.0
        GatePassHeader.MODIFY;
        GatePassLine.INSERT(TRUE);


        Unitsetup.GET;
        Unitsetup.TestField("Gold/Silver Voucher Template");
        Unitsetup.TestField("Gold/Silver Voucher Batch");

        ItemJournal.RESET;
        ItemJournal.SetRange("Journal Template Name", Unitsetup."Gold/Silver Voucher Template");
        ItemJournal.SetRange("Journal Batch Name", Unitsetup."Gold/Silver Voucher Batch");

        IF ItemJournal.FINDLAST THEN
            EndLineNo := ItemJournal."Line No." + 10000
        ELSE
            EndLineNo := 10000;


        ItemJnl.VALIDATE("Journal Template Name", Unitsetup."Gold/Silver Voucher Template");
        ItemJnl.VALIDATE("Journal Batch Name", Unitsetup."Gold/Silver Voucher Batch");
        ItemJnl.VALIDATE("Document No.", GatePassLine."Document No.");
        ItemJnl.VALIDATE("Line No.", EndLineNo);
        ItemJnl.VALIDATE("Vendor No.", Gatepassheader."Vendor No.");
        ItemJnl.VALIDATE("PO No.", Gatepassheader."Purchase Order No.");
        ItemJnl.VALIDATE("Item Shpt. Entry No.", 0);
        ItemJnl.INSERT(TRUE);
        ItemJnl.VALIDATE("Posting Date", Gatepassheader."Posting Date");
        ItemJnl.VALIDATE("Entry Type", ItemJnl."Entry Type"::"Negative Adjmt.");
        ItemJnl.VALIDATE("Item No.", GatePassLine."Item No.");
        ItemJnl.VALIDATE("Location Code", GatePassLine."Location Code");
        ItemJnl.VALIDATE(Quantity, GatePassLine.Qty);
        IF GatePassLine."Gen. Bus. Posting Group" <> '' THEN
            ItemJnl.VALIDATE("Gen. Bus. Posting Group", GatePassLine."Gen. Bus. Posting Group");
        IF GatePassLine."Gen. Prod. Posting Group" <> '' THEN
            ItemJnl.VALIDATE("Gen. Prod. Posting Group", GatePassLine."Gen. Prod. Posting Group");
        ItemJnl.VALIDATE("Shortcut Dimension 1 Code", GatePassLine."Shortcut Dimension 1 Code");
        ItemJnl.VALIDATE("Shortcut Dimension 2 Code", GatePassLine."Shortcut Dimension 2 Code");
        IF GatePassLine."Applies-to Entry" <> 0 THEN
            ItemJnl.VALIDATE("Applies-to Entry", GatePassLine."Applies-to Entry");
        ItemJnl.VALIDATE("Issue Type", Gatepassheader."Issue Type");
        ItemJnl."Reference No." := Gatepassheader."Reference No.";
        ItemJnl."Application No." := Rec."Application No.";
        ItemJnl."Application Line No." := GatePassLine."Application Line No.";
        ItemJnl."Item Type" := Gatepassheader."Item Type";

        ItemJnl.VALIDATE("Bin Code", GatePassLine."Bin Code");
        ItemJnl.Narration := GatePassLine.Description + ' Qty:' + FORMAT(GatePassLine.Qty);
        ItemJnl.MODIFY(TRUE);
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

        IF (Stdate <> '') THEN
            Rec.SETFILTER("Application Date", Stdate)
        ELSE
            Rec.SETRANGE("Application Date");
    end;
}

