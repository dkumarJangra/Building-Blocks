page 50205 "Silver Coin Eligibility"
{
    // // BBG1.01_NB 231012 : Adding functionality of approving the selected lines.

    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Gold Coin Eligibility";
    SourceTableView = WHERE("Send for Approval" = FILTER(false),
                            "Issued to Customer" = FILTER(false),
                            "Item Type" = CONST(Silver));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Select; Rec.Select)
                {
                }
                field("Item Type"; Rec."Item Type")
                {
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
                field("Issue Request"; Rec."Issue Request")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Send for Approval"; Rec."Send for Approval")
                {
                    Editable = false;
                }
                field("Sent By for Approval"; Rec."Sent By for Approval")
                {
                    Editable = false;
                }
                field("Sent By for Approval Name"; Rec."Sent By for Approval Name")
                {
                }
                field("Issued to Customer"; Rec."Issued to Customer")
                {
                }
                field("Issued Date"; Rec."Issued Date")
                {
                }
                field("Eligibility Gold / Silver"; Rec."Eligibility Gold / Silver")
                {
                    Caption = 'Eligibility Gold/Silver';
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
                action("Select All")
                {
                    Image = SelectEntries;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.SETRANGE("Send for Approval", FALSE);
                        IF Rec.FINDSET THEN
                            REPEAT
                                Rec.Select := TRUE;
                                Rec.MODIFY;
                            UNTIL Rec.NEXT = 0;
                    end;
                }
                action("Unselect All")
                {
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.SETRANGE("Send for Approval", FALSE);
                        IF Rec.FINDSET THEN
                            REPEAT
                                Rec.Select := FALSE;
                                Rec.MODIFY;
                            UNTIL Rec.NEXT = 0;
                    end;
                }
                action("Send for &A&pproval")
                {
                    Caption = 'Send for &A&pproval';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        // BBG1.01 231012 START
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        Memberof.RESET;
                        Memberof.SETRANGE(Memberof."User ID",USERID);
                        Memberof.SETRANGE(Memberof."Role ID",'A_GOLDCOINELIG.');
                        IF NOT Memberof.FINDFIRST THEN
                          ERROR('You do not have permission of role :A_GOLDCOINELIG.');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016


                        IF NOT CONFIRM(Text50000, FALSE) THEN
                            EXIT;

                        IF Rec."Project Code" = '' THEN
                            ERROR(Text50002);

                        //MARKEDONLY(TRUE);
                        Rec.SETRANGE(Select, TRUE);
                        IF Rec.FINDSET THEN
                            REPEAT
                                Rec.VALIDATE("Send for Approval", TRUE);
                                Rec.VALIDATE(Status, Rec.Status::Normal);
                                Rec.VALIDATE("Approval Date", TODAY);
                                Rec.Select := FALSE;
                                Rec.MODIFY(TRUE);
                            UNTIL Rec.NEXT = 0;
                        MESSAGE(Text50001);
                        //MARKEDONLY(FALSE);
                        // BBG1.01 231012 END

                    end;
                }
            }
            group("Calculate Eligibility1")
            {
                Caption = 'F&unction';
                Visible = true;
                action("Calculate &Eligibility")
                {
                    Caption = 'Calculate &Eligibility';
                    Image = CalculateHierarchy;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        //ALLECK 060313 START
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        Memberof.RESET;
                        Memberof.SETRANGE(Memberof."User ID",USERID);
                        Memberof.SETRANGE(Memberof."Role ID",'A_GOLDCOINELIG.');
                        IF NOT Memberof.FINDFIRST THEN
                          ERROR('You do not have permission of role :A_GOLDCOINELIG.');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        //ALLECK 060313 End

                        CLEAR(GenerateCoinEntry);
                        //SetRecordFilters1(ConfOrder);
                        //GenerateCoinEntry.SETTABLEVIEW(ConfOrder);
                        GenerateCoinEntry.SetValues(CustNoFilter, ProjectCodeFilter, Stdate, Endate, 2);
                        GenerateCoinEntry.RUNMODAL;
                        MESSAGE('Batch Run Successfully');

                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TESTFIELD(Approved, FALSE);
        ConfOrder.RESET;
        IF ConfOrder.GET(Rec."Application No.") THEN BEGIN
            IF Rec."Item Type" = Rec."Item Type"::Gold THEN
                ConfOrder."Gold Generated for R2" := FALSE;
            IF Rec."Item Type" = Rec."Item Type"::Silver THEN
                ConfOrder."Silver Coin Generated" := FALSE;
            ConfOrder.MODIFY;
        END;
    end;

    trigger OnInit()
    begin
        ProjectCodeFilter := '';
        CustNoFilter := '';
        Endate := 0D;
    end;

    trigger OnOpenPage()
    begin
        ProjectCodeFilter := '';
        CustNoFilter := '';
        Endate := 0D;
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
        GenerateCoinEntry: Report "Generate Coin Entry";
        Text50000: Label 'Do you want send the selected lines for approval?';
        Text50001: Label 'Selected lines have been sent for approval.';
        Text50002: Label 'There is nothing to send for approval.';
        Cust: Record Customer;
        CustName: Text[60];
        GenJnlSetup: Record "General Ledger Setup";
        DimValue: Record "Dimension Value";
        ProjectName: Text[60];
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

        IF (Endate <> 0D) THEN
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

        IF (Endate <> 0D) THEN
            ConfOrder.SETRANGE("Posting Date", 0D, Endate)
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

    local procedure EndateOnAfterValidate()
    begin
        CurrPage.UPDATE(FALSE);
    end;
}

