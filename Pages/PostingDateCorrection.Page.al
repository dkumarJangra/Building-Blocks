page 50012 "Posting Date Correction"
{
    // ALLECK 160313: Added Role for Cheque Correction
    // ALLEAD-170313: Length of Cheque No/Transaction No. increased from 7 to 20
    // //ALLECK 240313 :Developed the functionality of Posting Date Correction

    PageType = List;
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Cust. Ledger Entry" = rimd,
                  TableData "Bank Account Ledger Entry" = rimd,
                  TableData "Detailed Cust. Ledg. Entry" = rimd;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Confirmed Order No."; BondNo)
                {
                    Caption = 'Confirmed Order No.';
                    TableRelation = "Application Payment Entry"."Document No.";
                }
                field("Posted Document No."; PostDocNo)
                {
                    Caption = 'Posted Document No.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        APPEntry.RESET;
                        APPEntry.SETRANGE("Document No.", BondNo);
                        APPEntry.SETRANGE(Posted, TRUE);
                        IF APPEntry.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"Application Payment Entry List", APPEntry) = ACTION::LookupOK THEN BEGIN
                                ApplicationPaymentEntry := APPEntry;
                                PostDocNo := ApplicationPaymentEntry."Posted Document No.";
                            END;
                        END;
                    end;
                }
                field("Existing Posting Date"; ApplicationPaymentEntry."Posting date")
                {
                    Caption = 'Existing Posting Date';
                    Editable = false;
                }
                field("Posting Date Correction"; PDateCorrection)
                {
                    Caption = 'Posting Date Correction';

                    trigger OnValidate()
                    begin
                        PDateCorrectionOnPush;
                    end;
                }
                field(NewPDate; NewPDate)
                {
                    Caption = 'New Posting Date';
                    Enabled = NewPDateEnable;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Function)
            {
                Caption = 'Function';
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        ReleaseBondApplication: Codeunit "Release Unit Application";
                        ConfirmedOrder: Record "Confirmed Order";
                    begin
                        //ALLECK 160313 START
                        Companywise.RESET;
                        Companywise.SETRANGE(Companywise."MSC Company", TRUE);
                        IF Companywise.FINDFIRST THEN;
                        //  IF Companywise."Company Code" = COMPANYNAME THEN
                        //   ERROR('This process will do from LLP Company');
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        Memberof.SETRANGE(Memberof."User Name", USERID);
                        Memberof.SETRANGE(Memberof."Role ID", 'A_PDATECORRECTION');
                        IF NOT Memberof.FINDFIRST THEN
                            ERROR('You do not have permission of role  :A_PDATECORRECTION');
                        //ALLECK 160313 End
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        IF BondNo = '' THEN
                            ERROR('Please define the Bond No');
                        IF NewPDate = 0D THEN
                            ERROR('Please define the New Posting Date');

                        IF CONFIRM('Change Posting Date Details') THEN BEGIN
                            IF ConfirmedOrder.GET(ApplicationPaymentEntry."Document No.") THEN BEGIN
                                ConfirmedOrder.TESTFIELD("Application Closed", FALSE);
                                ConfirmedOrder.TESTFIELD("Registration Status", ConfirmedOrder."Registration Status"::" "); //090921
                            END;

                            IF (ApplicationPaymentEntry."Payment Mode" <> ApplicationPaymentEntry."Payment Mode"::JV) THEN BEGIN
                                CommEntry.RESET;
                                CommEntry.SETRANGE("Application No.", BondNo);
                                CommEntry.SETRANGE("Opening Entries", FALSE);
                                CommEntry.SETRANGE("Posting Date", ApplicationPaymentEntry."Posting date");
                                IF CommEntry.FINDFIRST THEN BEGIN
                                    ERROR('Commission already Created');
                                END;
                            END ELSE BEGIN
                                IF (ApplicationPaymentEntry."Adjmt. Line No." <> 0) THEN BEGIN
                                    CLEAR(APE);
                                    APE.SETRANGE("Document No.", BondNo);
                                    APE.SETRANGE("Adjmt. Line No.", ApplicationPaymentEntry."Adjmt. Line No.");
                                    APE.SETFILTER("Line No.", '<>%1', ApplicationPaymentEntry."Line No.");
                                    IF APE.FINDFIRST THEN BEGIN
                                        IF PDateCorrection THEN BEGIN
                                            APE."Posting date" := NewPDate;
                                            APE.MODIFY;
                                        END;
                                        UnitPaymentEntry.RESET;
                                        UnitPaymentEntry.SETRANGE("Document No.", BondNo);
                                        UnitPaymentEntry.SETRANGE("App. Pay. Entry Line No.", APE."Line No.");
                                        IF UnitPaymentEntry.FINDSET THEN
                                            REPEAT
                                                IF PDateCorrection THEN
                                                    UnitPaymentEntry."Posting date" := NewPDate;
                                                UnitPaymentEntry.MODIFY;
                                            UNTIL UnitPaymentEntry.NEXT = 0;
                                        GLEntry.RESET;
                                        GLEntry.SETCURRENTKEY("Document Type", "BBG Order Ref No.");
                                        GLEntry.SETRANGE("BBG Order Ref No.", BondNo);
                                        GLEntry.SETRANGE("Document No.", APE."Posted Document No.");
                                        IF GLEntry.FINDSET THEN
                                            REPEAT
                                                IF PDateCorrection THEN
                                                    GLEntry."Posting Date" := NewPDate;
                                                GLEntry."Document Date" := NewPDate;
                                                GLEntry.MODIFY;
                                            UNTIL GLEntry.NEXT = 0;

                                        CustLedgerEntry.RESET;
                                        CustLedgerEntry.SETCURRENTKEY("Document No.", "BBG App. No. / Order Ref No.");
                                        CustLedgerEntry.SETRANGE("BBG App. No. / Order Ref No.", BondNo);
                                        CustLedgerEntry.SETRANGE("Document No.", APE."Posted Document No.");
                                        IF CustLedgerEntry.FINDSET THEN
                                            REPEAT
                                                IF PDateCorrection THEN BEGIN
                                                    CustLedgerEntry."Posting Date" := NewPDate;
                                                    CustLedgerEntry."Due Date" := NewPDate;
                                                    CustLedgerEntry."Document Date" := NewPDate;
                                                END;
                                                CustLedgerEntry.MODIFY;
                                            UNTIL CustLedgerEntry.NEXT = 0;

                                        DetCustLdgrE.RESET;
                                        DetCustLdgrE.SETCURRENTKEY("Document Type", "Ref Document Type", "Order Ref No.", "Entry Type");
                                        DetCustLdgrE.SETRANGE("Order Ref No.", BondNo);
                                        DetCustLdgrE.SETRANGE("Document No.", APE."Posted Document No.");
                                        IF DetCustLdgrE.FINDSET THEN
                                            REPEAT
                                                IF PDateCorrection THEN
                                                    DetCustLdgrE."Posting Date" := NewPDate;
                                                DetCustLdgrE."Initial Entry Due Date" := NewPDate;
                                                DetCustLdgrE.MODIFY;
                                            UNTIL DetCustLdgrE.NEXT = 0;
                                    END;
                                    CLEAR(CommEntry);
                                    CommEntry.RESET;
                                    CommEntry.SETRANGE("Application No.", BondNo);
                                    CommEntry.SETRANGE("Posting Date", ApplicationPaymentEntry."Posting date");
                                    IF CommEntry.FINDSET THEN
                                        REPEAT
                                            CommEntry."Posting Date" := NewPDate;
                                            CommEntry.MODIFY;
                                        UNTIL CommEntry.NEXT = 0;
                                END;
                            END;

                            TPDetails.RESET;
                            TPDetails.SETRANGE("Application No.", BondNo);
                            IF TPDetails.FINDFIRST THEN BEGIN
                                ERROR('Travel already Created');
                            END;
                            IDEntry.RESET;
                            IDEntry.SETRANGE("Application No.", BondNo);
                            IF IDEntry.FINDFIRST THEN BEGIN
                                ERROR('Incentive already created');
                            END;
                            //ALLECK 250313

                            UnitCommCreationBuffer.RESET;
                            UnitCommCreationBuffer.SETRANGE("Unit No.", BondNo);
                            UnitCommCreationBuffer.SETRANGE("Posting Date", ApplicationPaymentEntry."Posting date");
                            IF UnitCommCreationBuffer.FINDSET THEN BEGIN
                                IF PDateCorrection THEN
                                    REPEAT
                                        UnitCommCreationBuffer."Posting Date" := NewPDate;
                                        UnitCommCreationBuffer.MODIFY;
                                    UNTIL UnitCommCreationBuffer.NEXT = 0;
                            END;



                            ApplicationPaymentEntry.SETRANGE("Document No.", BondNo);
                            ApplicationPaymentEntry.SETRANGE("Posted Document No.", PostDocNo);
                            IF ApplicationPaymentEntry.FINDSET THEN
                                REPEAT
                                    IF PDateCorrection THEN
                                        ApplicationPaymentEntry."Posting date" := NewPDate;
                                    ApplicationPaymentEntry.MODIFY;
                                UNTIL ApplicationPaymentEntry.NEXT = 0;

                            CLEAR(UnitPaymentEntry);
                            UnitPaymentEntry.RESET;
                            UnitPaymentEntry.SETRANGE("Document No.", BondNo);
                            UnitPaymentEntry.SETRANGE("App. Pay. Entry Line No.", ApplicationPaymentEntry."Line No.");
                            IF UnitPaymentEntry.FINDSET THEN
                                REPEAT
                                    IF PDateCorrection THEN
                                        UnitPaymentEntry."Posting date" := NewPDate;
                                    UnitPaymentEntry.MODIFY;
                                UNTIL UnitPaymentEntry.NEXT = 0;

                            CLEAR(GLEntry);
                            GLEntry.RESET;
                            GLEntry.SETCURRENTKEY("Document Type", "BBG Order Ref No.");
                            GLEntry.SETRANGE("BBG Order Ref No.", BondNo);
                            GLEntry.SETRANGE("Document No.", PostDocNo);
                            IF GLEntry.FINDSET THEN
                                REPEAT
                                    IF PDateCorrection THEN
                                        GLEntry."Posting Date" := NewPDate;
                                    GLEntry."Document Date" := NewPDate;
                                    GLEntry.MODIFY;
                                UNTIL GLEntry.NEXT = 0;

                            BALEntry.RESET;
                            //BALEntry.SETCURRENTKEY("Application No.");
                            BALEntry.SETRANGE("Application No.", BondNo);
                            BALEntry.SETRANGE("Document No.", PostDocNo);
                            IF BALEntry.FINDSET THEN
                                REPEAT
                                    IF PDateCorrection THEN
                                        BALEntry."Posting Date" := NewPDate;
                                    BALEntry.MODIFY;
                                UNTIL BALEntry.NEXT = 0;

                            CLEAR(CustLedgerEntry);
                            CustLedgerEntry.RESET;
                            CustLedgerEntry.SETCURRENTKEY("Document No.", "BBG App. No. / Order Ref No.");
                            CustLedgerEntry.SETRANGE("BBG App. No. / Order Ref No.", BondNo);
                            CustLedgerEntry.SETRANGE("Document No.", PostDocNo);
                            IF CustLedgerEntry.FINDSET THEN
                                REPEAT
                                    IF PDateCorrection THEN BEGIN
                                        CustLedgerEntry."Posting Date" := NewPDate;
                                        CustLedgerEntry."Due Date" := NewPDate;
                                        CustLedgerEntry."Document Date" := NewPDate;
                                    END;
                                    CustLedgerEntry.MODIFY;
                                UNTIL CustLedgerEntry.NEXT = 0;

                            CLEAR(DetCustLdgrE);
                            DetCustLdgrE.RESET;
                            DetCustLdgrE.SETCURRENTKEY("Document Type", "Ref Document Type", "Order Ref No.", "Entry Type");
                            DetCustLdgrE.SETRANGE("Order Ref No.", BondNo);
                            DetCustLdgrE.SETRANGE("Document No.", PostDocNo);
                            IF DetCustLdgrE.FINDSET THEN
                                REPEAT
                                    IF PDateCorrection THEN
                                        DetCustLdgrE."Posting Date" := NewPDate;
                                    DetCustLdgrE."Initial Entry Due Date" := NewPDate;
                                    DetCustLdgrE.MODIFY;
                                UNTIL DetCustLdgrE.NEXT = 0;

                            CnfOrder.RESET;
                            CnfOrder.SETRANGE(CnfOrder."No.", BondNo);
                            IF CnfOrder.FINDFIRST THEN BEGIN
                                ArchiveConfirmedOrder.RESET;
                                ArchiveConfirmedOrder.SETRANGE(ArchiveConfirmedOrder."No.", BondNo);
                                IF ArchiveConfirmedOrder.FINDLAST THEN
                                    LastVersion := ArchiveConfirmedOrder."Version No."
                                ELSE
                                    LastVersion := 0;
                                CnfOrder.CALCFIELDS("Amount Received");
                                CnfOrder.CALCFIELDS("Total Received Amount");
                                CnfOrder.CALCFIELDS("Amount Refunded");
                                ArchiveConfirmedOrder.INIT;
                                ArchiveConfirmedOrder.TRANSFERFIELDS(CnfOrder);
                                ArchiveConfirmedOrder."Version No." := LastVersion + 1;
                                ArchiveConfirmedOrder."Amount Received" := CnfOrder."Amount Received";
                                ArchiveConfirmedOrder."Archive Date" := TODAY;
                                ArchiveConfirmedOrder."Archive Time" := TIME;
                                ArchiveConfirmedOrder.INSERT;

                                ApplicationPaymentEntry.RESET;
                                ApplicationPaymentEntry.SETRANGE("Document No.", CnfOrder."No.");
                                IF ApplicationPaymentEntry.FINDSET THEN
                                    REPEAT
                                        Count1 += 1;
                                    UNTIL ApplicationPaymentEntry.NEXT = 0;
                                IF Count1 = 1 THEN BEGIN
                                    IF PDateCorrection THEN
                                        CnfOrder."Posting Date" := NewPDate;
                                    CnfOrder.MODIFY;
                                    PaymentPlanDetails1.RESET;
                                    PaymentPlanDetails1.SETRANGE(PaymentPlanDetails1."Document No.", BondNo);
                                    IF PaymentPlanDetails1.FINDSET THEN
                                        REPEAT
                                            //IF PDateCorrection THEN
                                            PaymentPlanDetails1."Project Milestone Due Date" :=
                                              CALCDATE(PaymentPlanDetails1."Due Date Calculation", NewPDate);
                                            IF FORMAT(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat") <> '' THEN //ALLEDK 040821
                                                PaymentPlanDetails1."Auto Plot Vacate Due Date" := CALCDATE(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat", PaymentPlanDetails1."Project Milestone Due Date") //ALLEDK 21
                                            ELSE
                                                PaymentPlanDetails1."Auto Plot Vacate Due Date" := PaymentPlanDetails1."Project Milestone Due Date";  //ALLEDK 040821

                                            PaymentPlanDetails1.MODIFY;
                                        UNTIL PaymentPlanDetails1.NEXT = 0;
                                    UnitPost.NewUpdateTEAMHierarcy(CnfOrder, FALSE);
                                END;
                            END;
                            //--------For MSC company-------------
                            CLEAR(APPEntry);
                            APPEntry.SETRANGE("Document No.", BondNo);
                            APPEntry.SETRANGE("Posted Document No.", PostDocNo);
                            IF APPEntry.FINDSET THEN
                                REPEAT
                                    IF APPEntry."MSC Post Doc. No." <> '' THEN BEGIN
                                        NewAppPayEntry.RESET;
                                        NewAppPayEntry.SETRANGE("Document No.", BondNo);
                                        NewAppPayEntry.SETRANGE("Posted Document No.", APPEntry."MSC Post Doc. No.");
                                        IF NewAppPayEntry.FINDFIRST THEN BEGIN
                                            CLEAR(GLEntry);
                                            GLEntry.RESET;
                                            GLEntry.CHANGECOMPANY(Companywise."Company Code");
                                            GLEntry.SETCURRENTKEY("Document Type", "BBG Order Ref No.");
                                            GLEntry.SETRANGE("BBG Order Ref No.", BondNo);
                                            GLEntry.SETRANGE("Document No.", NewAppPayEntry."Posted Document No.");
                                            IF GLEntry.FINDSET THEN
                                                REPEAT
                                                    IF PDateCorrection THEN
                                                        GLEntry."Posting Date" := NewPDate;
                                                    GLEntry."Document Date" := NewPDate;
                                                    GLEntry.MODIFY;
                                                UNTIL GLEntry.NEXT = 0;

                                            BALEntry.RESET;
                                            BALEntry.CHANGECOMPANY(Companywise."Company Code");
                                            BALEntry.SETRANGE("Application No.", BondNo);
                                            BALEntry.SETRANGE("Document No.", NewAppPayEntry."Posted Document No.");
                                            IF BALEntry.FINDSET THEN
                                                REPEAT
                                                    IF PDateCorrection THEN
                                                        BALEntry."Posting Date" := NewPDate;
                                                    BALEntry.MODIFY;
                                                UNTIL BALEntry.NEXT = 0;
                                            NewAppPayEntry."Posting date" := NewPDate;
                                            NewAppPayEntry.MODIFY;
                                        END;
                                    END ELSE BEGIN
                                        CLEAR(NewAppPayEntry);
                                        NewAppPayEntry.RESET;
                                        NewAppPayEntry.SETRANGE("Document No.", BondNo);
                                        NewAppPayEntry.SETRANGE("Line No.", APPEntry."Line No.");
                                        IF NewAppPayEntry.FINDFIRST THEN BEGIN
                                            NewAppPayEntry."Posting date" := NewPDate;
                                            NewAppPayEntry.MODIFY;
                                        END;
                                    END;
                                UNTIL APPEntry.NEXT = 0;



                            //--------For MSC company-------------
                            MESSAGE('Posting Date successfully update');
                            CLEARALL;
                        END;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        NewPDateEnable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        CurrPageUpdateControl;
    end;

    var
        BondNo: Code[20];
        ApplicationPaymentEntry: Record "Application Payment Entry";
        UnitPaymentEntry: Record "Unit Payment Entry";
        PostDocNo: Code[20];
        GLEntry: Record "G/L Entry";
        BALEntry: Record "Bank Account Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        UnitCommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        APPEntry: Record "Application Payment Entry";
        PDateCorrection: Boolean;
        NewPDate: Date;
        DetCustLdgrE: Record "Detailed Cust. Ledg. Entry";
        CnfOrder: Record "Confirmed Order";
        PmntTrmsLineSale: Record "Payment Terms Line Sale";
        PmntPlanDet: Record "Payment Plan Details";
        Count1: Integer;
        PaymentPlanDetails1: Record "Payment Plan Details";
        CommEntry: Record "Commission Entry";
        TPDetails: Record "Travel Payment Details";
        IDEntry: Record "Incentive Detail Entry";
        APE: Record "Application Payment Entry";
        UnitPost: Codeunit "Unit Post";
        ArchiveConfirmedOrder: Record "Archive Confirmed Order";
        LastVersion: Integer;
        Companywise: Record "Company wise G/L Account";
        NewAppPayEntry: Record "NewApplication Payment Entry";

        NewPDateEnable: Boolean;
        Memberof: Record "Access Control";


    procedure CurrPageUpdateControl()
    begin
        NewPDateEnable := PDateCorrection;
    end;

    local procedure PDateCorrectionOnPush()
    begin
        CurrPageUpdateControl;
    end;
}

