page 97959 "Gold Coin Eligibility App"
{
    // // BBG1.01_NB 231012 : Adding functionality of approving the selected lines.

    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Gold Coin Eligibility";
    SourceTableView = WHERE("Send for Approval" = FILTER(true),
                            Approved = CONST(false),
                            "Item Type" = CONST(Gold));
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
                field(Select; Rec.Select)
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
                field("Sent By for Approval"; Rec."Sent By for Approval")
                {
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
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Approve ")
            {
                Caption = '&Approve ';
                action("Select All")
                {
                    Image = SelectEntries;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.SETRANGE("Send for Approval", TRUE);
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
                        Rec.SETRANGE("Send for Approval", TRUE);
                        IF Rec.FINDSET THEN
                            REPEAT
                                Rec.Select := FALSE;
                                Rec.MODIFY;
                            UNTIL Rec.NEXT = 0;
                    end;
                }
                action("&Approve Lines")
                {
                    Caption = '&Approve Lines';
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        // BBG1.01 231012 START
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User ID",USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID",'GOLDCOINAPP');
                        IF NOT MemberOf.FIND('-') THEN
                          ERROR('UnAuthorised User for Verifying MIN');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

                        IF NOT CONFIRM(Text50000, FALSE) THEN
                            EXIT;

                        IF Rec."Project Code" = '' THEN
                            ERROR(Text50004);

                        //MARKEDONLY(TRUE);
                        Rec.SETRANGE("Send for Approval", TRUE);
                        Rec.SETRANGE(Select, TRUE);
                        IF Rec.FINDFIRST THEN
                            REPEAT
                                Rec.VALIDATE(Approved, TRUE);
                                Rec.VALIDATE(Status, Rec.Status::Normal);
                                Rec.MODIFY(TRUE);
                            UNTIL Rec.NEXT = 0;
                        MESSAGE(Text50001);
                        //MARKEDONLY(FALSE);
                        // BBG1.01 231012 END

                    end;
                }
                action("&Return Request")
                {
                    Caption = '&Return Request';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        // BBG1.01 231012 START
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User ID",USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID",'GOLDCOINAPP');
                        IF NOT MemberOf.FIND('-') THEN
                          ERROR('UnAuthorised User for Verifying MIN');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016




                        IF NOT CONFIRM(Text50002, FALSE) THEN
                            EXIT;





                        IF Rec."Project Code" = '' THEN
                            MESSAGE(Text50004);

                        //MARKEDONLY(TRUE);
                        Rec.SETRANGE(Select, TRUE);
                        IF Rec.FINDSET THEN
                            REPEAT

                                //    TESTFIELD("Total No. of Gold Issued");


                                Rec.VALIDATE(Status, Rec.Status::Return);
                                Rec.VALIDATE("Send for Approval", FALSE);
                                Rec.MODIFY;
                            UNTIL Rec.NEXT = 0;
                        MESSAGE(Text50003);
                        //MARKEDONLY(FALSE);
                        // BBG1.01 231012 END

                    end;
                }
            }
        }
        area(processing)
        {
            action(OK)
            {
                Caption = 'OK';
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    IF CONFIRM(Text001, FALSE) THEN BEGIN
                        GoldCoinEligibility.COPY(Rec);
                        CurrPage.SETSELECTIONFILTER(GoldCoinEligibility);
                        GoldCoinEligibility.SETRANGE(GoldCoinEligibility.Approved, TRUE);
                        IF GoldCoinEligibility.FIND('-') THEN
                            REPEAT
                                GoldCoinSetup.RESET;
                                GoldCoinSetup.SETRANGE("Project Code", Rec."Project Code");
                                GoldCoinSetup.SETRANGE("Plot Size", Rec.Extent);
                                GoldCoinSetup.SETFILTER("Effective Date", '<%1', Rec."Application Date");
                                IF GoldCoinSetup.FINDLAST THEN BEGIN
                                    InsertLineData(Rec, GoldCoinSetup."Item Code");
                                    GoldCoinEligibility."Min Doc No." := DocNo;
                                    GoldCoinEligibility.MODIFY;
                                END ELSE
                                    ERROR('Gold Coin Setup is not defined for this Period');
                            UNTIL GoldCoinEligibility.NEXT = 0;
                        CurrPage.CLOSE;
                    END;
                end;
            }
        }
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
        Text50000: Label 'Do you want to approve the selected lines?';
        Text50001: Label 'Selected lines are approved.';
        Text50002: Label 'Do you want to return these lines?';
        Text50003: Label 'Selected lines are returned.';
        Text50004: Label 'There is nothing to approve.';
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

