page 50235 "Gold/Silver Voucher Approval"
{

    Caption = 'Gold/Silver Voucher Approval';
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Gold/Silver Voucher Eleg.";
    SourceTableView = WHERE("Send for Approval" = FILTER(true),
                            Approved = CONST(false));
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
                field("Gold/Silver Voucher Elg."; Rec."Gold/Silver Voucher Elg.")
                {
                    Caption = 'Eligibility Gold/Silver Voucher';
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

                        IF NOT CONFIRM(Text50002, FALSE) THEN
                            EXIT;

                        IF Rec."Project Code" = '' THEN
                            MESSAGE(Text50004);


                        Rec.SETRANGE(Select, TRUE);
                        IF Rec.FINDSET THEN
                            REPEAT
                                Rec.VALIDATE(Status, Rec.Status::Return);
                                Rec.VALIDATE("Send for Approval", FALSE);
                                Rec.MODIFY;
                            UNTIL Rec.NEXT = 0;
                        MESSAGE(Text50003);
                    end;
                }
            }
        }
        area(processing)
        {
        }

    }

    var
        GatePassLine: Record "Gate Pass Line";
        GoldCoinSetup: Record "Gold Coin Line";
        GoldCoinEligibility: Record "Gold/Silver Voucher Eleg.";
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




    // procedure AssignLineNo(): Integer
    // var
    //     TempGatePassLine: Record "Gate Pass Line";
    // begin
    //     TempGatePassLine.RESET;
    //     TempGatePassLine.SETRANGE("Document No.", DocNo);
    //     IF TempGatePassLine.FINDLAST THEN
    //         EXIT(TempGatePassLine."Line No." + 10000)
    //     ELSE
    //         EXIT(10000);
    // end;


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

