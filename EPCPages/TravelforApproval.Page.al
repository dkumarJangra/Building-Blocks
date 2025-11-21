page 97967 "Travel for Approval"
{
    // // BBG1.01 ALLE_NB 261012 : Executing the travel Generator Report from form itself.

    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Travel Payment Entry";
    SourceTableView = WHERE("Sent for Approval" = FILTER(true),
                            Approved = CONST(false),
                            "Post from Approval" = CONST(false));
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
                    Caption = 'Team Lead ';
                    TableRelation = Vendor;

                    trigger OnValidate()
                    begin
                        SetRecordFilters;

                        TotalAmt := 0;
                        RateSqrd := 0;
                        TotalArea := 0;
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

                        TotalAmt := 0;
                        RateSqrd := 0;
                        TotalArea := 0;
                        ProjectCodeFilterOnAfterValida;
                    end;
                }
                field(TADocNo; TADocNo)
                {
                    Caption = 'Document No.';
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
                field(TotalAmttoPay; TotalAmttoPay)
                {
                    Caption = 'Allocation Amount';
                    Editable = false;
                }
            }
            part("1"; "Travel Payment Details")
            {
                Editable = true;
                SubPageLink = "Associate Code" = FIELD("Team Lead"),
                              "Document No." = FIELD("Document No."),
                              Approved = FILTER(false),
                              Select = FILTER(true);
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
                field("Team Lead"; Rec."Team Lead")
                {
                }
                field("Team Lead Name"; Rec."Team Lead Name")
                {
                }
                field("Sub Associate Code"; Rec."Sub Associate Code")
                {
                }
                field("Sub Associate Name"; Rec."Sub Associate Name")
                {
                }
                field("Amount to Pay"; Rec."Amount to Pay")
                {

                    trigger OnValidate()
                    begin
                        AmounttoPayOnAfterValidate;
                    end;
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                }
                field("Approval Sender  Name"; Rec."Approval Sender  Name")
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Calculate Eligibility")
            {
                Caption = '&Approval';
                Visible = true;
                action("&Approved")
                {
                    Caption = '&Approved';

                    trigger OnAction()
                    begin
                        // BBG1.01 231012 START
                        IF NOT CONFIRM(Text50000, FALSE) THEN
                            EXIT;

                        IF Rec."Project Code" = '' THEN
                            ERROR(Text50004);

                        IF TADocNo = '' THEN
                            ERROR('Enter the Document No.');
                        //MARKEDONLY(TRUE);
                        Rec.SETRANGE("Document No.", TADocNo);
                        IF Rec.FINDFIRST THEN
                            REPEAT
                                Rec.VALIDATE(Approved, TRUE);
                                Rec.VALIDATE(Status, Rec.Status::Normal);
                                Rec.MODIFY(TRUE);
                            UNTIL Rec.NEXT = 0;

                        APPTADetails.RESET;
                        APPTADetails.SETRANGE("Document No.", TADocNo);
                        APPTADetails.SETRANGE(Select, TRUE);
                        IF APPTADetails.FINDFIRST THEN
                            REPEAT
                                APPTADetails.Approved := TRUE;
                                APPTADetails.MODIFY;
                            UNTIL APPTADetails.NEXT = 0;

                        MESSAGE(Text50001);
                        Rec.MARKEDONLY(FALSE);
                        // BBG1.01 231012 END
                    end;
                }
                action("&Return")
                {
                    Caption = '&Return';

                    trigger OnAction()
                    begin
                        // BBG1.01 231012 START
                        IF NOT CONFIRM(Text50002, FALSE) THEN
                            EXIT;

                        IF Rec."Project Code" = '' THEN
                            MESSAGE(Text50004);

                        IF TADocNo = '' THEN
                            ERROR('Enter the Document No.');
                        //MARKEDONLY(TRUE);
                        Rec.SETRANGE("Document No.", TADocNo);
                        IF Rec.FINDSET THEN
                            REPEAT
                                Rec.VALIDATE(Status, Rec.Status::Return);
                                Rec.VALIDATE("Sent for Approval", FALSE);
                                Rec.MODIFY;
                            UNTIL Rec.NEXT = 0;
                        MESSAGE(Text50003);
                        Rec.MARKEDONLY(FALSE);
                        // BBG1.01 231012 END
                    end;
                }
            }
        }
        area(processing)
        {
            action("Calc. Disp.Amount")
            {
                Caption = 'Calc. Disp.Amount';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CalculateArea;

                    /*
                    IF CustNoFilter = '' THEN
                      ERROR('Please select Team Lead');
                    IF Stdate = 0D THEN
                      ERROR('Please define TODate');
                    
                    IF ProjectCodeFilter = '' THEN
                      ERROR('Please select Project Code');
                    
                    TAEntry.RESET;
                    //TAEntry.SETCURRENTKEY("Project Code","Creation Date","Sub Associate Code","Team Lead");
                    TAEntry.SETFILTER("Project Code",ProjectCodeFilter);
                    TAEntry.SETRANGE("Creation Date",Stdate);
                    TAEntry.SETRANGE("Team Lead","Team Lead");
                    IF TAEntry.FINDSET THEN
                      REPEAT
                        TAEntry1.RESET;
                      //  TAEntry1.SETCURRENTKEY("Project Code","Creation Date","Sub Associate Code","Team Lead");
                        TAEntry1.SETFILTER("Project Code",ProjectCodeFilter);
                        TAEntry1.SETRANGE("Creation Date",Stdate);
                        TAEntry1.SETRANGE("Sub Associate Code",TAEntry."Sub Associate Code");
                        TAEntry1.SETRANGE("Team Lead",TAEntry."Team Lead");
                        IF TAEntry1.FINDFIRST THEN
                          REPORT.RUNMODAL(50070,FALSE,FALSE,TAEntry1);
                      UNTIL TAEntry.NEXT = 0;
                     */

                end;
            }
        }
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
        Vend: Record Vendor;
        TravelGenEntry: Record "Travel Payment Entry";
        TravelEntry: Record "Travel Payment Entry";
        TotalArea1: Decimal;
        TAEntry: Record "Travel Payment Entry";
        TAEntry1: Record "Travel Payment Entry";
        //GenerateTAEntry1: Report 50070;
        //AssociatTAHierarchy: Report 50094;
        TADetails: Record "Travel Payment Details";
        TotalAmttoPay: Decimal;
        Text50000: Label 'Do you want to approve the selected lines?';
        Text50001: Label 'Selected lines are approved.';
        Text50002: Label 'Do you want to return these lines?';
        Text50003: Label 'Selected lines are returned.';
        Text50004: Label 'There is nothing to approve.';
        TADocNo: Code[20];
        APPTADetails: Record "Travel Payment Details";


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
    end;


    procedure CalculateTotalamtToPay(): Decimal
    var
        TravelPaymentEntry: Record "Travel Payment Entry";
    begin
        TravelPaymentEntry.RESET;
        TravelPaymentEntry.SETCURRENTKEY("Project Code", "Creation Date", "Sub Associate Code", "Team Lead");
        IF CustNoFilter <> '' THEN
            TravelPaymentEntry.SETFILTER("Team Lead", CustNoFilter);
        IF ProjectCodeFilter <> '' THEN
            TravelPaymentEntry.SETFILTER("Project Code", ProjectCodeFilter);
        IF (Stdate <> 0D) THEN
            TravelPaymentEntry.SETRANGE("Creation Date", 0D, Stdate);

        TravelPaymentEntry.CALCSUMS("Amount to Pay");
        TotalAmttoPay := TravelPaymentEntry."Amount to Pay";
    end;

    local procedure AmounttoPayOnAfterValidate()
    begin
        CalculateTotalamtToPay;
        TotalAmttoPay += Rec."Amount to Pay" - xRec."Amount to Pay";

        IF TotalAmt < TotalAmttoPay THEN
            ERROR('Amount to Pay can not be greater than Total Amt =' + FORMAT(TotalAmt));
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

