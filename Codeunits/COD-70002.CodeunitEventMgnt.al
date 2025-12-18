codeunit 70002 "BBG Codeunit Event Mgnt."
{
    Permissions = tabledata "Approval Entry" = RIMD;
    trigger OnRun()
    begin

    end;

    var
        myInt: Integer;
        t: Record "Workflow Step Buffer";
        WorkflowManagement: Codeunit "Workflow Management";
        CU: Codeunit "Workflow Request Page Handling";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        ToJobPlanning: Record "Job Planning Line";
        OldValue: Decimal;
        FromBOMComp: Record "BOM Component";
        NoOfBOMComp: Integer;
        UOMMgt: Codeunit "Unit of Measure Management";
        NextLineNo: Integer;
        LineSpacing: Integer;
        BOMItemNo: Code[20];
        Text003: Label 'There is not enough space to explode the BOM.';
        Text000: Label 'The BOM cannot be exploded on the sales lines because it is associated with purchase order %1.';
        Text001: Label 'Item %1 is not a BOM.';
        Text004: Label '&Copy dimensions from BOM,&Retrieve dimensions from components';
        WorkFlowSetup: Codeunit "Workflow Setup";

    //======= Codeunit 11 "Gen. Jnl.-Check Line" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", OnBeforeRunCheck, '', false, false)]
    local procedure OnBeforeRunCheck_GenJnlCheckLine(OverrideDimErr: Boolean; sender: Codeunit "Gen. Jnl.-Check Line"; var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    var
        CompanyInfo: Record "Company Information";
        Vend: Record Vendor;
        UserSetup: Record "User Setup";
    begin
        //NDALLE 041207 START - stop Back Voucher
        UserSetup.GET(USERID);
        IF UserSetup."Stop Back Date" THEN BEGIN
            IF GenJournalLine."Posting Date" < (TODAY - UserSetup."Back Date Margin Days") THEN
                ERROR('Posting Date should be between %1 and %2', TODAY - UserSetup."Back Date Margin Days", TODAY);
        END;
        //NDALLE 041207 STOP

        //ALLEAA 141209
        CompanyInfo.GET;
        IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer) AND
          (CompanyInfo."JV Fields Mandetory") AND
          (GenJournalLine."Source Code" = 'JOURNALV')
        THEN BEGIN
            GenJournalLine.TESTFIELD("Project Unit No.");
            GenJournalLine.TESTFIELD("Sales Order No.");
            GenJournalLine.TESTFIELD(Reason);
        END;
        //ALLEAA 141209
    end;

    PROCEDURE CheckPostingType(GenJournalLine: Record "Gen. Journal Line");
    BEGIN
        IF (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer) OR
           (GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor) THEN BEGIN
            IF GenJournalLine."Account No." <> '' THEN
                GenJournalLine.TESTFIELD("Posting Type");
        END;
        IF (GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::Customer) OR
           (GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::Vendor) THEN BEGIN
            IF GenJournalLine."Bal. Account No." <> '' THEN
                GenJournalLine.TESTFIELD("Posting Type");
        END;
    END;

    //======= Codeunit 11 "Gen. Jnl.-Check Line" ========END<<

    //======= codeunit 150 "System Initialization" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"System Initialization", OnAfterLogin, '', false, false)]
    local procedure UserRespCenterSelection()
    var
        UserSetup: Record "User Setup";
    begin
        IF NOT GUIALLOWED THEN
            EXIT;

        CODEUNIT.RUN(CODEUNIT::"Users - Create Super User");
        IF NOT UserSetup.GET(USERID) THEN BEGIN
            UserSetup.INIT();
            UserSetup."User ID" := USERID;
            UserSetup.INSERT();
        END;

        COMMIT();

        IF PAGE.RUNMODAL(PAGE::"User Resp. Center Selection") = ACTION::OK THEN;
    end;

    //======= codeunit 150 "System Initialization" ========END<<

    //======= Codeunit 12 "Gen. Jnl.-Post Line" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeCode, '', false, false)]
    local procedure OnBeforeCode_GenJnlPostLine(CheckLine: Boolean; sender: Codeunit "Gen. Jnl.-Post Line"; var GenJnlLine: Record "Gen. Journal Line"; var GLEntryNo: Integer; var GLReg: Record "G/L Register"; var IsPosted: Boolean)
    begin
        CheckPostingTypeFORCU12(GenJnlLine); // VSID 0051 ALLE
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforePostGLAcc, '', false, false)]
    local procedure OnBeforePostGLAcc_GenJnlPostLine(GenJournalLine: Record "Gen. Journal Line"; sender: Codeunit "Gen. Jnl.-Post Line"; var GLEntry: Record "G/L Entry"; var GLEntryNo: Integer; var IsHandled: Boolean; var TempGLEntryBuf: Record "G/L Entry" temporary)
    var
        UnitSetup: Record "Unit Setup";
    begin
        //IF GenJnlLine."Payment Mode" = GenJnlLine."Payment Mode"::AJVM THEN       //ALLEDK 2612
        UnitSetup.GET;
        IF (GenJournalLine."Payment Mode" = GenJournalLine."Payment Mode"::AJVM) OR
          (GenJournalLine."Journal Template Name" = UnitSetup."Assoc. Recov. Temp Name") THEN; // AND
                                                                                               // (GenJnlLine."Journal Batch Name"=UnitSetup."Assoc. Recov. Batch Name")) THEN //ALLETDK2503
                                                                                               //InitPostedJnlBankCharge(GenJnlLine, 0); //ALLEDK 2612

        //IF GenJnlLine."Payment Mode" = GenJnlLine."Payment Mode"::AJVM THEN       //ALLEDK 2612
        IF (GenJournalLine."Payment Mode" = GenJournalLine."Payment Mode"::AJVM) OR
           (GenJournalLine."Journal Template Name" = UnitSetup."Assoc. Recov. Temp Name") THEN;// AND
                                                                                               // (GenJnlLine."Journal Batch Name"=UnitSetup."Assoc. Recov. Batch Name")) THEN  //ALLETDK2503
                                                                                               //InitPostedJnlBankCharge(GenJnlLine, 1); //ALLEDK 2612

    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeCalcPmtTolerancePossible, '', false, false)]
    local procedure OnBeforeCalcPmtTolerancePossible_GenJnlPostLine(GenJnlLine: Record "Gen. Journal Line"; PmtDiscountDate: Date; var IsHandled: Boolean; var MaxPaymentTolerance: Decimal; var PmtDiscToleranceDate: Date)
    begin
        UpdatePaymentMadeFlag_Vend(GenJnlLine);  //VSID 0051 ALLE NAM <<
    end;

    PROCEDURE CheckPostingTypeFORCU12(GenJournalLine: Record "Gen. Journal Line")
    var
        Vend: Record Vendor;
    BEGIN
        IF ((GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer) AND (GenJournalLine."Journal Template Name" <> ''))
        THEN
            IF GenJournalLine."Account No." <> '' THEN
                GenJournalLine.TESTFIELD("Posting Type");

        IF ((GenJournalLine."Account Type" = GenJournalLine."Account Type"::Vendor) AND (GenJournalLine."Journal Template Name" <> '')) THEN
            IF GenJournalLine."Account No." <> '' THEN
                IF Vend.GET(GenJournalLine."Account No.") THEN BEGIN
                    GenJournalLine.TESTFIELD("Posting Type");
                    GenJournalLine.VALIDATE("Posting Type");
                END;
    END;

    PROCEDURE UpdatePaymentMadeFlag_Vend(Var GenJnlLine: Record "Gen. Journal Line")
    VAR
        recVendorLedgerEntry: Record "Vendor Ledger Entry";
        VendLedgerEntryAmount: Decimal;
        PaymentTermsLine: Record "Payment Terms Line";
        PaymentTermsLines: Record "Payment Terms Line";
        txtMilestoneError: Label 'You cannot Post more than the milestone code DUE AMOUNT.\\The Amount for the milestone code already posted is %1.\\The total due amount for the Milestone code is %2';

    BEGIN
        IF ((GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) AND
           (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) AND (GenJnlLine."Order Ref No." <> '')
           AND (GenJnlLine."Milestone Code" <> '')) THEN BEGIN

            recVendorLedgerEntry.RESET;
            //recVendorLedgerEntry.SETRANGE("Document Type",recVendorLedgerEntry."Document Type"::Payment);
            recVendorLedgerEntry.SETRANGE("Ref Document Type", GenJnlLine."Ref Document Type");
            recVendorLedgerEntry.SETRANGE("Order Ref No.", GenJnlLine."Order Ref No.");
            recVendorLedgerEntry.SETRANGE("Milestone Code", GenJnlLine."Milestone Code");
            recVendorLedgerEntry.SETRANGE("Posting Type", GenJnlLine."Posting Type");
            IF recVendorLedgerEntry.FINDFIRST THEN
                REPEAT
                    recVendorLedgerEntry.CALCFIELDS(Amount);
                    VendLedgerEntryAmount := VendLedgerEntryAmount + recVendorLedgerEntry.Amount;
                UNTIL recVendorLedgerEntry.NEXT = 0;


            IF (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) AND (GenJnlLine."Tran Type" = GenJnlLine."Tran Type"::Purchase
            )
             THEN BEGIN
                PaymentTermsLine.RESET;
                PaymentTermsLine.SETRANGE(PaymentTermsLine."Document Type", GenJnlLine."Ref Document Type");
                PaymentTermsLine.SETRANGE(PaymentTermsLine."Document No.", GenJnlLine."Order Ref No.");
                //PaymentTermsLine.SETRANGE(PaymentTermsLine."Milestone Code",GenJnlLine."Milestone Code"); // ALLE MM Code Commented
                IF PaymentTermsLine.FIND('-') THEN;
            END;

            //Alleab
            IF (GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) AND (GenJnlLine."Tran Type" = GenJnlLine."Tran Type"::Sale)
             THEN BEGIN
                PaymentTermsLines.RESET;
                PaymentTermsLines.SETRANGE(PaymentTermsLines."Document Type", GenJnlLine."Ref Document Type");
                PaymentTermsLines.SETRANGE(PaymentTermsLines."Document No.", GenJnlLine."Order Ref No.");
                //PaymentTermsLines.SETRANGE(PaymentTermsLines.Sequence, GenJnlLine."Milestone Code");
                IF PaymentTermsLines.FINDFIRST THEN;
            END;

            IF (GenJnlLine."Tran Type" = GenJnlLine."Tran Type"::Sale) AND (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor) THEN BEGIN
                // IF ABS(VendLedgerEntryAmount) + ABS(GenJnlLine.Amount) > PaymentTermsLines."Brokerage Amount" THEN
                //     ERROR('You can not post more then Brokerage Amount', VendLedgerEntryAmount, PaymentTermsLines."Brokerage Amount");

            END
            ELSE
                //Alleab

                IF ABS(VendLedgerEntryAmount) + ABS(GenJnlLine.Amount) > PaymentTermsLine."Due Amount" THEN
                    ERROR(txtMilestoneError, VendLedgerEntryAmount, PaymentTermsLine."Due Amount");

            IF ABS(VendLedgerEntryAmount) + ABS(GenJnlLine.Amount) = PaymentTermsLine."Due Amount" THEN BEGIN
                PaymentTermsLine."Payment Made" := TRUE;
                PaymentTermsLine.MODIFY;
            END
        END;
    END;

    PROCEDURE UpdatePaymentMadeFlag_Cust()
    VAR
        recCustLedgerEntry: Record "Cust. Ledger Entry";
        CustLedgerEntryAmount: Decimal;
    BEGIN
        //ALLETD081112--COMMENT CODE BEGIN

        //   IF ((GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment) AND
        //      (GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer) AND (GenJnlLine."Order Ref No." <> '')
        //      AND (GenJnlLine."Milestone Code" <> ''))  THEN BEGIN

        //     recCustLedgerEntry.RESET;
        //   //  recCustLedgerEntry.SETRANGE("Document Type",recCustLedgerEntry."Document Type"::Payment);
        //     recCustLedgerEntry.SETRANGE(recCustLedgerEntry."Ref Document Type",GenJnlLine."Ref Document Type");
        //     recCustLedgerEntry.SETRANGE(recCustLedgerEntry."Order Ref No.",GenJnlLine."Order Ref No.");
        //     recCustLedgerEntry.SETRANGE(recCustLedgerEntry."Milestone Code",GenJnlLine."Milestone Code");
        //     recCustLedgerEntry.SETRANGE(recCustLedgerEntry."Posting Type",GenJnlLine."Posting Type");
        //     IF recCustLedgerEntry.FIND('-') THEN REPEAT
        //           recCustLedgerEntry.CALCFIELDS(Amount);
        //           //ALLE PS Commented Code for Calculatin Total Amount Recieved
        //           //CustLedgerEntryAmount := CustLedgerEntryAmount + ABS(recCustLedgerEntry.Amount);
        //           CustLedgerEntryAmount := CustLedgerEntryAmount + recCustLedgerEntry.Amount;
        //     UNTIL recCustLedgerEntry.NEXT = 0;

        //   IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment THEN BEGIN
        //     PaymentTermsLines.RESET;
        //     PaymentTermsLines.SETRANGE(PaymentTermsLines."Document Type",GenJnlLine."Ref Document Type");
        //     PaymentTermsLines.SETRANGE(PaymentTermsLines."Document No.",GenJnlLine."Order Ref No.");
        //     PaymentTermsLines.SETRANGE(PaymentTermsLines."Milestone Code",GenJnlLine."Milestone Code");
        //     IF PaymentTermsLines.FIND('-') THEN ;
        //   END;


        //   IF ABS(CustLedgerEntryAmount) + ABS(GenJnlLine.Amount) > PaymentTermsLines."Due Amount" THEN
        //      ERROR(txtMilestoneError,ABS(CustLedgerEntryAmount),PaymentTermsLines."Due Amount");
        //   IF ABS(CustLedgerEntryAmount) + ABS(GenJnlLine.Amount) = PaymentTermsLines."Due Amount" THEN BEGIN
        //       PaymentTermsLines."Payment Made":=TRUE;
        //       PaymentTermsLines.MODIFY;
        //   END
        //   END;

        //ALLETD081112--COMMENT CODE END
    END;




    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine_GLEntry(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
        //ALLE021219
        GLEntry."BBG Order Ref No." := GenJournalLine."Order Ref No.";
        GLEntry."BBG Milestone Code" := GenJournalLine."Milestone Code";
        GLEntry."BBG Ref Document Type" := GenJournalLine."Ref Document Type";
        GLEntry."BBG Verified By" := GenJournalLine."Verified By";
        GLEntry."BBG Created By" := GenJournalLine."Created By";


        GLEntry."BBG Narration" := GenJournalLine.Narration;
        GLEntry."BBG Month" := DATE2DMY(GenJournalLine."Posting Date", 2);
        GLEntry."BBG Year" := DATE2DMY(GenJournalLine."Posting Date", 3);
        IF GenJournalLine."BBG Cheque No." = '' then
            GLEntry."BBG Cheque No." := GenJournalLine."Cheque No."
        Else
            GLEntry."BBG Cheque No." := GenJournalLine."BBG Cheque No.";
        GLEntry."BBG Cheque Date" := GenJournalLine."Cheque Date";

        GLEntry."BBG Work Type" := GenJournalLine."Work Type";   // AlleDK 030708
        GLEntry."BBG Tranasaction Type" := GenJournalLine."Tranasaction Type"; //BBG1.00 110815
        GLEntry."BBG Insurance No." := GenJournalLine."Insurance No.";  //KLND1.00  140311
        GLEntry."BBG LC/BG No." := GenJournalLine."LC/BG No.";  //KLND1.00  140311
        GLEntry."BBG BG Charges Type" := GenJournalLine."BG Charges Type";  //KLND1.00  140311
        GLEntry."BBG Introducer Code" := GenJournalLine."Introducer Code";//MPS
        GLEntry."BBG Cheque clear Date" := GenJournalLine."Cheque clear Date";//MPS
                                                                              //IF (GLAcc."Employee Account") THEN//GKG01
        GLEntry."BBG Employee No." := GenJournalLine."Employee No.";

        //ALLE021219
        GLEntry."BBG Direct Incentive App. No." := GenJournalLine."Application No.";  //100924 Added new code
        GLEntry."BBG Special Incentive Bonanza" := GenJournalLine."Special Incentive Bonanza";//100924 Added new code
        GLEntry."BBG Posting Type" := GenJournalLine."Posting Type";  //100924 Added new code
        GLEntry."Ref. Invoice No." := GenJournalLine."Ref. Invoice No.";
        GLEntry."Ref. External Doc. No." := GenJournalLine."Ref. External Doc. No.";  //Added new code 15122025
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine_VendorLedgerEntry(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        //ALLE190619

        //ALLEAS02  <<
        VendorLedgerEntry."Order Ref No." := GenJournalLine."Order Ref No.";
        VendorLedgerEntry."Milestone Code" := GenJournalLine."Milestone Code";
        VendorLedgerEntry."Ref Document Type" := GenJournalLine."Ref Document Type";
        VendorLedgerEntry."Vendor Invoice Date" := GenJournalLine."Vendor Invoice Date";
        VendorLedgerEntry."Posting Type" := GenJournalLine."Posting Type";
        VendorLedgerEntry."Provisional Bill" := GenJournalLine."Provisional Bill";
        VendorLedgerEntry.Month := DATE2DMY(GenJournalLine."Posting Date", 2);
        VendorLedgerEntry.Year := DATE2DMY(GenJournalLine."Posting Date", 3);
        IF GenJournalLine."BBG Cheque No." = '' then
            VendorLedgerEntry."Cheque No." := GenJournalLine."Cheque No."
        Else
            VendorLedgerEntry."Cheque No." := GenJournalLine."BBG Cheque No.";
        VendorLedgerEntry."Cheque Date" := GenJournalLine."Cheque Date";
        VendorLedgerEntry."Received Invoice Amount" := GenJournalLine."Received Invoice Amount";
        VendorLedgerEntry."ARM Invoice" := GenJournalLine."ARM Invoice";  //BBG1.00 280513
        VendorLedgerEntry."IC Land Purchase" := GenJournalLine."IC Land Purchase"; //BBG 280417
        VendorLedgerEntry."Application No." := GenJournalLine."Application No.";
        VendorLedgerEntry."Special Incentive Bonanza" := GenJournalLine."Special Incentive Bonanza"; //110924 Added new field
        VendorLedgerEntry."Credit Memo from ARM" := GenJournalLine."TA/Comm Credit Memo";
        //ALLEAS02  >>
        VendorLedgerEntry."User Branch Code" := GenJournalLine."Branch Code"; //ALLETDK141112
        //VendorLedgerEntry."TDS Nature of Deduction" := GenJournalLine."TDS Nature of Deduction";
        VendorLedgerEntry."Payment Mode" := GenJournalLine."Payment Mode"; //ALLEDK 010313
        VendorLedgerEntry."Tranasaction Type" := GenJournalLine."Tranasaction Type"; //110815
        VendorLedgerEntry."Club 9 Entry" := GenJournalLine."Club 9 Entry"; //260225
        VendorLedgerEntry."Ref. External Doc. No." := GenJournalLine."Ref. External Doc. No.";  //Added new code 15122025
        //ALLE190619
    End;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnBeforeInsertDtldCustLedgEntry, '', false, false)]
    local procedure OnBeforeInsertDtldCustLedgEntry_GenJnlPostLine(DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register"; var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        //ALLEAB
        DtldCustLedgEntry."Posting Type" := GenJournalLine."Posting Type";
        DtldCustLedgEntry."User Branch Code" := GenJournalLine."Project Code";
        DtldCustLedgEntry."Initial Entry Global Dim. 1" := GenJournalLine."Shortcut Dimension 1 Code"; //INS1.0
        DtldCustLedgEntry."Posting Type" := GenJournalLine."Posting Type";
        //ALLEAB
    end;

    //======= Codeunit 12 "Gen. Jnl.-Post Line" ========END<<



    //======= Codeunit 22 "Item Jnl.-Post Line" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterInitItemLedgEntry, '', false, false)]
    local procedure OnAfterInitItemLedgEntry_GenJnlPostLine(var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer; var NewItemLedgEntry: Record "Item Ledger Entry")
    var
        Item: Record Item;
    begin
        Item.Get(ItemJournalLine."Item No.");
        NewItemLedgEntry."Application No." := ItemJournalLine."Application No."; //BBG 151012
        NewItemLedgEntry."Application Line No." := ItemJournalLine."Application Line No."; //BBG 151012
        NewItemLedgEntry."Item Type" := ItemJournalLine."Item Type"; //180216

        //JPL21 START
        NewItemLedgEntry."Vendor No." := ItemJournalLine."Vendor No.";
        NewItemLedgEntry."PO No." := ItemJournalLine."PO No.";
        NewItemLedgEntry."Indent No" := ItemJournalLine."Indent No";
        NewItemLedgEntry."Indent Line No" := ItemJournalLine."Indent Line No";
        NewItemLedgEntry."Transfer FG" := ItemJournalLine."Transfer FG";  //RAHEE1.00
        //SC ->>
        NewItemLedgEntry."Issue Type" := ItemJournalLine."Issue Type";
        NewItemLedgEntry."Reference No." := ItemJournalLine."Reference No.";
        //SC <<-
        //JPL21 STOP

        //Alleab-FA: for flowing fields from Item to Ile specific to FA
        NewItemLedgEntry."Item-FA" := Item."Item-FA";
        NewItemLedgEntry.Capacity := Item.Capacity;
        NewItemLedgEntry."FA SubClass Code" := Item."FA SubClass Code";
        NewItemLedgEntry."FA Sub Group" := Item."FA Sub Group";
        NewItemLedgEntry."Item-FA Code" := Item."Item-FA Code"; //ALLEAA
        //ALLEDDS01July
        NewItemLedgEntry.Leased := Item.Leased;
        //ALLEDDS01July
        //Alleab
        NewItemLedgEntry."BBG Product Group Code" := Item."BBG Product Group Code";
        NewItemLedgEntry."Fixed Asset No" := ItemJournalLine."Fixed Asset No";//ALLE PS
        NewItemLedgEntry."R194_Application No." := ItemJournalLine."R194_Application No.";  //050525 Added new code

    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnInitValueEntryOnAfterAssignFields, '', false, false)]
    local procedure OnInitValueEntryOnAfterAssignFields_GenJnlPostLine(ItemJnlLine: Record "Item Journal Line"; ItemLedgEntry: Record "Item Ledger Entry"; var ValueEntry: Record "Value Entry")
    begin
        ValueEntry."Application No." := ItemJnlLine."Application No."; //BBG 151012
    end;


    //======= Codeunit 22 "Item Jnl.-Post Line" ========END<<

    //======= Codeunit 40 LogInManagement ========Start>>

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::LogInManagement, OnShowTermsAndConditions, '', false, false)]
    // local procedure OnShowTermsAndConditions_LogInManagement()
    // var
    //     locUser: Record "User Setup";
    //     locActiveSession: Record "Active Session";
    // begin

    //     //ALLE_130220

    //     IF (USERID <> '100360') AND (USERID <> 'navsvc') AND (USERID <> 'navsvc') AND (USERID <> 'NAVSVC') AND (USERID <> 'BCUSER') THEN BEGIN
    //         locUser.GET(UPPERCASE(USERID));
    //         IF NOT locUser.Multilogin THEN BEGIN
    //             locActiveSession.RESET;
    //             locActiveSession.SETRANGE("User ID", UPPERCASE(USERID));
    //             locActiveSession.SETRANGE("Client Type", locActiveSession."Client Type"::"Windows Client"); //For   RTC\Windows Clients
    //             IF locActiveSession.COUNT > 1 THEN
    //                 ERROR('You are currently logged in NAV, you canÂt have more sessions!');
    //         END;
    //     END;

    //     //ALLE_130220
    // End;

    //======= Codeunit 40 LogInManagement ========END<<


    //======= Codeunit 46 SelectionFilterManagement ========Start>>

    PROCEDURE GetSelectionFilterForTeamCode(VAR TeamMaster: Record "Team Master"): Text;
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(TeamMaster);
        EXIT(SelectionFilterManagement.GetSelectionFilter(RecRef, TeamMaster.FIELDNO("Team Code")));
    END;

    PROCEDURE GetSelectionFilterForTargetField(VAR Targetfieldmaster: Record "Target field master"): Text;
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(Targetfieldmaster);
        EXIT(SelectionFilterManagement.GetSelectionFilter(RecRef, Targetfieldmaster.FIELDNO(Code)));
    END;

    //050525 added new function start
    PROCEDURE GetSelectionFilterForConforderField(VAR Targetfieldmaster: Record "Confirmed order"): Text;
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(Targetfieldmaster);
        EXIT(SelectionFilterManagement.GetSelectionFilter(RecRef, Targetfieldmaster.FIELDNO("No.")));
    END;

    //050525 added new funcation END

    PROCEDURE GetSelectionFilterForLeaderCode(VAR LeaderMaster: Record "Leader Master"): Text;
    VAR
        RecRef: RecordRef;
    BEGIN
        RecRef.GETTABLE(LeaderMaster);
        EXIT(SelectionFilterManagement.GetSelectionFilter(RecRef, LeaderMaster.FIELDNO("Leader Code")));
    END;

    //======= Codeunit 46 SelectionFilterManagement ========END<<


    //======= Codeunit 63 "Sales-Explode BOM" ========Start>>


    PROCEDURE InsertBomComponentonJobPlaning(VAR JobPlanning: Record "Job Planning Line");
    VAR
        Selection: Integer;
        Item: Record Item;
    BEGIN
        JobPlanning.TESTFIELD(Type, JobPlanning.Type::Item);
        JobPlanning.TESTFIELD(Quantity);
        JobPlanning.TESTFIELD("Location Code"); //ALLEDK 090412
        JobPlanning.TESTFIELD("Insert Explode Lines", FALSE);
        //IF JobPlanning."Job Contract Entry No." <> 0 THEN BEGIN
        //  JobPlanning.TESTFIELD("Job No.",'');
        //  JobPlanning.TESTFIELD("Job Contract Entry No.",0);
        //END;
        FromBOMComp.SETRANGE("Parent Item No.", JobPlanning."No.");
        NoOfBOMComp := FromBOMComp.COUNT;
        IF NoOfBOMComp = 0 THEN
            ERROR(
              Text001,
              JobPlanning."No.");

        Selection := STRMENU(Text004, 2);
        IF Selection = 0 THEN
            EXIT;

        ToJobPlanning.RESET;
        ToJobPlanning.SETRANGE("Job No.", JobPlanning."Job No.");
        ToJobPlanning.SETRANGE("Job Task No.", JobPlanning."Job Task No.");
        ToJobPlanning := JobPlanning;
        IF ToJobPlanning.FIND('>') THEN BEGIN
            LineSpacing := (ToJobPlanning."Line No." - JobPlanning."Line No.") DIV (1 + NoOfBOMComp);
            IF LineSpacing = 0 THEN
                ERROR(Text003);
        END ELSE
            LineSpacing := 10000;

        IF JobPlanning."Line Type" = JobPlanning."Line Type"::Contract THEN BEGIN
            ToJobPlanning := JobPlanning;
            FromBOMComp.SETRANGE(Type, FromBOMComp.Type::Item);
            FromBOMComp.SETFILTER("No.", '<>%1', '');
            IF FromBOMComp.FINDSET THEN
                REPEAT
                    FromBOMComp.TESTFIELD(Type, FromBOMComp.Type::Item);
                    Item.GET(FromBOMComp."No.");
                    ToJobPlanning."Line No." := 0;
                    ToJobPlanning."No." := FromBOMComp."No.";
                    ToJobPlanning."Variant Code" := FromBOMComp."Variant Code";
                    ToJobPlanning."Unit of Measure Code" := FromBOMComp."Unit of Measure Code";
                    ToJobPlanning."Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, FromBOMComp."Unit of Measure Code");
                    ToJobPlanning.Quantity := ROUND(JobPlanning.Quantity * FromBOMComp."Quantity per", 0.00001);
                UNTIL FromBOMComp.NEXT = 0;
        END;

        IF JobPlanning."BOM Item No." = '' THEN
            BOMItemNo := JobPlanning."No."
        ELSE
            BOMItemNo := JobPlanning."BOM Item No.";

        ToJobPlanning := JobPlanning;

        ToJobPlanning.INIT;
        ToJobPlanning.Description := JobPlanning.Description;
        ToJobPlanning."Description 2" := JobPlanning."Description 2";
        ToJobPlanning."BOM Item No." := BOMItemNo;
        ToJobPlanning.Type := JobPlanning.Type;
        IF BOMItemNo = FromBOMComp."Parent Item No." THEN
            ToJobPlanning."Contract Line" := TRUE
        ELSE
            ToJobPlanning."Contract Line" := FALSE;

        ToJobPlanning.MODIFY;
        ToJobPlanning.DELETE;
        //FromDocDim.SETRANGE("Table ID",DATABASE::"Sales Line");
        //FromDocDim.SETRANGE("Document Type","Document Type");
        //FromDocDim.SETRANGE("Document No.","Document No.");
        //FromDocDim.SETRANGE("Line No.","Line No.");

        //ToDocDim.SETRANGE("Table ID",DATABASE::"Sales Line");
        //ToDocDim.SETRANGE("Document Type","Document Type");
        //ToDocDim.SETRANGE("Document No.","Document No.");

        //DimMgt.CopyDocDimToDocDim(FromDocDim,TempDocDim);
        //CLEAR(TempDocDim);
        //FromDocDim.DELETEALL;

        FromBOMComp.RESET;
        FromBOMComp.SETRANGE("Parent Item No.", JobPlanning."No.");
        FromBOMComp.FINDSET;
        NextLineNo := JobPlanning."Line No.";
        REPEAT

            ToJobPlanning.INIT;
            NextLineNo := NextLineNo + LineSpacing;
            ToJobPlanning."Line No." := NextLineNo;
            CASE FromBOMComp.Type OF
                FromBOMComp.Type::Item:
                    ToJobPlanning.Type := ToJobPlanning.Type::Item;
                FromBOMComp.Type::Resource:
                    ToJobPlanning.Type := ToJobPlanning.Type::Resource;
            END;
            ToJobPlanning.VALIDATE("No.", FromBOMComp."No.");
            IF ToJobPlanning.Type = ToJobPlanning.Type::Item THEN BEGIN
                Item.GET(FromBOMComp."No.");
                ToJobPlanning.VALIDATE("Unit of Measure Code", FromBOMComp."Unit of Measure Code");
                ToJobPlanning."Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, ToJobPlanning."Unit of Measure Code");
                ToJobPlanning.VALIDATE(Quantity,
                  ROUND(
                    JobPlanning.Quantity * FromBOMComp."Quantity per" *
                    UOMMgt.GetQtyPerUnitOfMeasure(Item, ToJobPlanning."Unit of Measure Code") /
                    ToJobPlanning."Qty. per Unit of Measure",
                    0.00001));
            END;
            // ELSE
            //  ToJobPlanning.VALIDATE(Quantity,"Quantity (Base)" * FromBOMComp."Quantity per");

            //  IF SalesHeader."Language Code" = '' THEN
            //    ToJobPlanning.Description := FromBOMComp.Description
            //  ELSE
            //    IF NOT ItemTranslation.GET(FromBOMComp."No.",FromBOMComp."Variant Code",SalesHeader."Language Code") THEN
            //      ToJobPlanning.Description := FromBOMComp.Description;
            ToJobPlanning."Location Code" := JobPlanning."Location Code";
            ToJobPlanning."Line Type" := JobPlanning."Line Type";
            ToJobPlanning."BOM Item No." := BOMItemNo;
            ToJobPlanning."BOQ Type" := JobPlanning."BOQ Type";
            IF BOMItemNo <> ToJobPlanning."No." THEN BEGIN
                ToJobPlanning."Explode Lines" := TRUE;
                ToJobPlanning."Insert Explode Lines" := FALSE;
            END ELSE BEGIN
                ToJobPlanning."Explode Lines" := FALSE;
                ToJobPlanning."Insert Explode Lines" := TRUE;
                ToJobPlanning."Unit Price" := JobPlanning."Unit Price";
                ToJobPlanning.VALIDATE("Unit Price");
                ToJobPlanning."Line Amount" := JobPlanning."Line Amount";
                ToJobPlanning.VALIDATE("Line Amount");
            END;
            IF ToJobPlanning."No." = FromBOMComp."Parent Item No." THEN
                ToJobPlanning."Contract Line" := TRUE
            ELSE
                ToJobPlanning."Contract Line" := FALSE;
            ToJobPlanning."Schedule Line" := FALSE;
            ToJobPlanning.INSERT(TRUE);

        //  IF (ToJobPlanning.Type = ToJobPlanning.Type::Item) AND (ToJobPlanning.Reserve = ToJobPlanning.Reserve::Always) THEN
        //    ToJobPlanning.AutoReserve;

        //  IF Selection = 1 THEN BEGIN
        //    ToJobPlanning."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        //    ToJobPlanning."Shortcut Dimension 2 Code" := JobPlanning."Shortcut Dimension 2 Code";
        //    ToJobPlanning.MODIFY;
        //    ToDocDim.SETRANGE("Line No.",ToJobPlanning."Line No.");
        //    ToDocDim.DELETEALL;
        //    IF TempDocDim.FINDSET THEN BEGIN
        //      REPEAT
        //        ToDocDim.INIT;
        //        ToDocDim."Table ID" := DATABASE::"Sales Line";
        //        ToDocDim."Document Type" := ToJobPlanning."Document Type";
        //        ToDocDim."Document No." := ToJobPlanning."Document No.";
        //        ToDocDim."Line No." := ToJobPlanning."Line No.";
        //        ToDocDim."Dimension Code" := TempDocDim."Dimension Code";
        //        ToDocDim."Dimension Value Code" := TempDocDim."Dimension Value Code";
        //        ToDocDim.INSERT;
        //      UNTIL TempDocDim.NEXT = 0;
        //    END;
        //  END;

        UNTIL FromBOMComp.NEXT = 0;
    END;



    //======= Codeunit 63 "Sales-Explode BOM" ========END<<

    //======= Codeunit 74 "Purch.-Get Receipt" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Get Receipt", OnAfterPurchRcptLineSetFilters, '', false, false)]
    local procedure OnAfterPurchRcptLineSetFilters_PurchGetReceipt(PurchaseHeader: Record "Purchase Header"; var PurchRcptLine: Record "Purch. Rcpt. Line")
    begin
        PurchRcptLine.SETRANGE("Order No.", PurchaseHeader."Order Ref. No.");   //Added new filter 20042022
    end;


    //======= Codeunit 74 "Purch.-Get Receipt" ========END<<

    //======= Codeunit 80 "Sales-Post" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnInsertPostedHeadersOnAfterInsertInvoiceHeader, '', false, false)]
    local procedure OnInsertPostedHeadersOnAfterInsertInvoiceHeader_SalesPost(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SHeadRec: Record "Sales Header";
    begin
        //alleab
        IF SalesHeader."Raised Client Bill Ref. No." <> '' THEN BEGIN
            SHeadRec.RESET;
            SHeadRec.SETRANGE("Document Type", SHeadRec."Document Type"::Invoice);
            SHeadRec.SETFILTER("No.", SalesHeader."Raised Client Bill Ref. No.");

            IF SHeadRec.FINDFIRST THEN BEGIN
                SHeadRec."Client Bill Status" := SHeadRec."Client Bill Status"::Closed;
                SHeadRec.MODIFY;
            END;
        END;
        //alleab
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnPostSalesLineOnBeforeTestJobNo, '', false, false)]
    local procedure OnPostSalesLineOnBeforeTestJobNo_SalesPost(SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
        if not (SalesLine."Document Type" in [SalesLine."Document Type"::Invoice, SalesLine."Document Type"::"Credit Memo", SalesLine."Document Type"::Order]) then
            SalesLine.TestField("Job No.", '');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnBeforePostCustomerEntry, '', false, false)]
    local procedure OnBeforePostCustomerEntry_SalesPost(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header")
    begin
        //VSID Alle ND Job0007
        GenJnlLine."Order Ref No." := SalesHeader."No.";
        GenJnlLine."Milestone Code" := SalesHeader."Last Stage Completed"; // ALLE SP
        GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
        //VSID Alle ND Job0007
    End;

    PROCEDURE PostRetentionEntries(SalesHeader: Record "Sales Header");
    VAR
        PaymentTermsLine: Record "Payment Terms Line Sale";
        Customer: Record Customer;
        GenJournalLine: Record "Gen. Journal Line";
        PaymentType: Option " ",Advance,Running,Retention;
        Cntr: Integer;
        LineNo: Integer;
        GenJnlLineDocNo: Code[20];
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    BEGIN
        // ALLEAS02 <<
        PaymentTermsLine.RESET;
        PaymentTermsLine.SETRANGE("Document Type", SalesHeader."Document Type");
        PaymentTermsLine.SETRANGE("Document No.", SalesHeader."No.");
        PaymentTermsLine.SETRANGE("Payment Type", PaymentType::Retention);
        PaymentTermsLine.SETRANGE(Adjust, TRUE);
        IF PaymentTermsLine.FIND('-') THEN BEGIN
            LineNo := 10000;
            Customer.RESET;
            Customer.GET(SalesHeader."Bill-to Customer No.");
            FOR Cntr := 1 TO 2 DO BEGIN
                GenJournalLine.INIT;
                GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
                GenJournalLine."Line No." := LineNo;
                LineNo := LineNo + 10000;
                GenJournalLine."Document No." := GenJnlLineDocNo;
                GenJournalLine."Posting Date" := SalesHeader."Posting Date";
                GenJournalLine."Document Date" := SalesHeader."Document Date";
                GenJournalLine.Description := SalesHeader."Posting Description";
                GenJournalLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
                GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                GenJournalLine."Account No." := SalesHeader."Bill-to Customer No.";
                GenJournalLine."Currency Code" := SalesHeader."Currency Code";

                IF Cntr = 1 THEN BEGIN

                    //GenJournalLine.Amount := -(InvAmount*(PaymentTermsLine."Calculation Value"/100)); ROUNDING
                    //GenJournalLine.Amount := ROUND(-(InvAmount*(PaymentTermsLine."Calculation Value"/100)),0.01,'=');


                    GenJournalLine.Amount := ROUND(-PaymentTermsLine."Due Amount", 0.01, '='); // PANDITA
                    GenJournalLine."Due Date" := SalesHeader."Document Date";
                    GenJournalLine."Posting Group" := Customer."BBG Cust. Posting Group-Running";
                    GenJournalLine."Posting Type" := GenJournalLine."Posting Type"::Running;
                    //ALLEAS03 <<
                    GenJournalLine."Order Ref No." := SalesHeader."No.";
                    GenJournalLine."Milestone Code" := SalesHeader."Last Stage Completed";
                    GenJournalLine."Ref Document Type" := SalesHeader."Document Type".AsInteger();
                    //ALLEAS03 >>


                    IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] THEN
                        GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice
                    ELSE
                        GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::"Credit Memo";
                    GenJournalLine."Applies-to Doc. No." := GenJnlLineDocNo;
                END
                ELSE BEGIN

                    //GenJournalLine.Amount := (InvAmount*(PaymentTermsLine."Calculation Value"/100)); ROUNDING
                    //GenJournalLine.Amount := ROUND((InvAmount*(PaymentTermsLine."Calculation Value"/100)),0.01,'=');


                    GenJournalLine.Amount := ROUND(PaymentTermsLine."Due Amount", 0.01, '=');
                    GenJournalLine."Due Date" := PaymentTermsLine."Due Date";
                    GenJournalLine."Posting Group" := Customer."BBG Cust. Posting Group-Retention";
                    GenJournalLine."Posting Type" := GenJournalLine."Posting Type"::Retention;
                    //ALLEAS03 <<
                    GenJournalLine."Order Ref No." := SalesHeader."No.";
                    GenJournalLine."Milestone Code" := PaymentTermsLine.Sequence;
                    GenJournalLine."Ref Document Type" := SalesHeader."Document Type".AsInteger();
                    //ALLEAS03 >>


                END;
                //   TempJnlLineDim.DELETEALL;
                //   TempDocDim.RESET;
                //   TempDocDim.SETRANGE("Table ID",DATABASE::"Sales Header");
                //   DimMgt.CopyDocDimToJnlLineDim(TempDocDim,TempJnlLineDim);
                GenJnlPostLine.RunWithCheck(GenJournalLine);
            END;
        END;

        //ALLEAS02 >>
    END;

    PROCEDURE ApplyAdvanceEntries(SHRec: Record "Sales Header");
    VAR
        PaymentTermsLine: Record "Payment Terms Line";
        Customer: Record Customer;
        GenJournalLine: Record "Gen. Journal Line";
        PaymentType: Option " ",Advance,Running,Retention;
        Cntr: Integer;
        LineNo: Integer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        TotalAdvAmt: Decimal;
        RecordFound: Boolean;
        AppliedDocType: Code[20];
        SalesHeader: Record "Sales Header";
        GenJnlLineDocNo: Code[20];
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    BEGIN
        //ALLEAS02 <<

        TotalAdvAmt := 0;
        RecordFound := FALSE;
        PaymentTermsLine.RESET;
        PaymentTermsLine.SETRANGE("Document Type", SalesHeader."Document Type");
        PaymentTermsLine.SETRANGE("Document No.", SalesHeader."No.");
        PaymentTermsLine.SETRANGE("Payment Type", PaymentType::Advance);
        PaymentTermsLine.SETRANGE(Adjust, TRUE);
        PaymentTermsLine.SETRANGE("Payment Made", TRUE);
        PaymentTermsLine.SETFILTER("Calculation Value", '<>%1', 0);
        IF PaymentTermsLine.FIND('-') THEN
            REPEAT

                CustLedgerEntry.RESET;
                //ALLEAS03 <<
                CustLedgerEntry.SETRANGE("BBG Ref Document Type", CustLedgerEntry."BBG Ref Document Type"::"Blanket Order");
                CustLedgerEntry.SETRANGE(CustLedgerEntry."BBG App. No. / Order Ref No.", SalesHeader."Blanket Order Ref No.");
                CustLedgerEntry.SETRANGE("BBG Milestone Code", PaymentTermsLine."Milestone Code");
                //ALLEAS03 >>

                CustLedgerEntry.SETRANGE("BBG Posting Type", CustLedgerEntry."BBG Posting Type"::Advance);
                IF CustLedgerEntry.FIND('+') THEN
                    AppliedDocType := CustLedgerEntry."Document No.";

                IF AppliedDocType <> '' THEN BEGIN
                    LineNo := 10000;
                    RecordFound := TRUE;
                    Customer.RESET;
                    Customer.GET(SalesHeader."Bill-to Customer No.");

                    GenJournalLine.INIT;
                    GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
                    GenJournalLine."Line No." := LineNo;
                    LineNo := LineNo + 10000;
                    GenJournalLine."Document No." := GenJnlLineDocNo;
                    GenJournalLine."Posting Date" := SalesHeader."Posting Date";
                    GenJournalLine."Document Date" := SalesHeader."Document Date";
                    GenJournalLine.Description := SalesHeader."Posting Description";
                    GenJournalLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
                    GenJournalLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
                    GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
                    GenJournalLine."Account No." := SalesHeader."Bill-to Customer No.";
                    GenJournalLine."Currency Code" := SalesHeader."Currency Code";

                    //GenJournalLine.Amount := (InvAmount*(PaymentTermsLine."Calculation Value"/100));     ROUNDING
                    //GenJournalLine.Amount := ROUND((InvAmount*(PaymentTermsLine."Calculation Value"/100)),0.01,'=');

                    GenJournalLine.Amount := ROUND(PaymentTermsLine."Due Amount", 0.01, '='); // PANDITA
                    TotalAdvAmt += GenJournalLine.Amount;

                    //ALLEAS03 <<
                    GenJournalLine."Ref Document Type" := SalesHeader."Document Type".AsInteger();
                    //ALLEAS03 >>


                    GenJournalLine."Due Date" := SalesHeader."Document Date";
                    GenJournalLine."Posting Group" := Customer."BBG Cust. Posting Group-Advance";
                    GenJournalLine."Posting Type" := GenJournalLine."Posting Type"::Advance;
                    //ALLEAS03 <<
                    GenJournalLine."Order Ref No." := SalesHeader."No.";
                    GenJournalLine."Milestone Code" := PaymentTermsLine."Milestone Code"; //ALLE SP 050705 for Payment Milestone to GL
                                                                                          //ALLEAS03 >>



                    IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] THEN
                        GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Payment;

                    GenJournalLine."Applies-to Doc. No." := AppliedDocType;


                    //   TempJnlLineDim.DELETEALL;
                    //   TempDocDim.RESET;
                    //   TempDocDim.SETRANGE("Table ID",DATABASE::"Sales Header");
                    //   DimMgt.CopyDocDimToJnlLineDim(TempDocDim,TempJnlLineDim);
                    GenJnlPostLine.RunWithCheck(GenJournalLine);
                END;
            UNTIL PaymentTermsLine.NEXT = 0;

        //Inserting Balancing Line
        IF RecordFound THEN BEGIN
            GenJournalLine.INIT;
            GenJournalLine."Document Type" := GenJournalLine."Document Type"::" ";
            GenJournalLine."Line No." := LineNo + 10000;
            LineNo := LineNo + 10000;
            GenJournalLine."Document No." := GenJnlLineDocNo;
            GenJournalLine."Posting Date" := SalesHeader."Posting Date";
            GenJournalLine."Document Date" := SalesHeader."Document Date";
            GenJournalLine.Description := SalesHeader."Posting Description";
            GenJournalLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
            GenJournalLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::Customer;
            GenJournalLine."Account No." := SalesHeader."Bill-to Customer No.";
            GenJournalLine."Currency Code" := SalesHeader."Currency Code";

            //GenJournalLine.Amount := - TotalAdvAmt; ROUNDING
            GenJournalLine.Amount := ROUND(-TotalAdvAmt, 0.01, '=');

            //ALLEAS03 <<
            GenJournalLine."Ref Document Type" := SalesHeader."Document Type".AsInteger();
            //ALLEAS03 >>


            GenJournalLine."Due Date" := SalesHeader."Document Date";
            GenJournalLine."Posting Group" := Customer."BBG Cust. Posting Group-Running";
            GenJournalLine."Posting Type" := GenJournalLine."Posting Type"::Running;
            //ALLEAS03 <<
            GenJournalLine."Order Ref No." := SalesHeader."No.";
            GenJournalLine."Milestone Code" := SalesHeader."Last Stage Completed"; //ALLE SP 050705 for Payment Milestone to GL
                                                                                   //ALLEAS03 >>

            GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
            GenJournalLine."Applies-to Doc. No." := GenJnlLineDocNo;
            //ERROR('%1',GenJnlLineDocNo);

            // TempJnlLineDim.DELETEALL;
            // TempDocDim.RESET;
            // TempDocDim.SETRANGE("Table ID",DATABASE::"Sales Header");
            // DimMgt.CopyDocDimToJnlLineDim(TempDocDim,TempJnlLineDim);
            GenJnlPostLine.RunWithCheck(GenJournalLine);
        END;

        //ALLEAS02 >>
    END;

    //======= Codeunit 80 "Sales-Post" ========END<<


    //======= Codeunit 81 "Sales-Post (Yes/No)" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", OnBeforeConfirmSalesPost, '', false, false)]
    local procedure OnBeforeConfirmSalesPost_SalesPost(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        IF SalesHeader."Client Bill Type" = SalesHeader."Client Bill Type"::Raised THEN
            ERROR('Sorry you can not post raised bill');
    End;


    //======= Codeunit 81 "Sales-Post (Yes/No)" ========END<<

    //======= Codeunit 96 "Purch.-Quote to Order" ========Start>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", OnCreatePurchHeaderOnBeforeInitRecord, '', false, false)]
    local procedure OnCreatePurchHeaderOnBeforeInitRecord_PurchQuotetoOrder(var PurchHeader: Record "Purchase Header"; var PurchOrderHeader: Record "Purchase Header")
    var
        PRHeader: Record "Purchase Request Header";
    begin
        //ALLERP 22-11-2010 Start:
        IF PRHeader.GET(PRHeader."Document Type"::Indent, PurchHeader."Indent No.") THEN BEGIN
            IF PRHeader."Indent Type" = PRHeader."Indent Type"::Supply THEN
                PurchOrderHeader."Sub Document Type" := PurchOrderHeader."Sub Document Type"::"Regular PO"
            ELSE
                PurchOrderHeader."Sub Document Type" := PurchOrderHeader."Sub Document Type"::"WO-NICB";
        END;
        //ALLERP 22-11-2010 End:
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", OnBeforeInsertPurchOrderLine, '', false, false)]
    local procedure OnBeforeInsertPurchOrderLine_PurchQuotetoOrder(PurchOrderHeader: Record "Purchase Header"; PurchQuoteHeader: Record "Purchase Header"; PurchQuoteLine: Record "Purchase Line"; var PurchOrderLine: Record "Purchase Line")
    begin
        //ALLE PS Added code to populate unit ratre from purchase Quote
        PurchOrderLine.VALIDATE("Direct Unit Cost", PurchQuoteLine."Direct Unit Cost");
        PurchOrderLine."Job Code" := PurchQuoteLine."Job Code";
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", OnAfterInsertPurchOrderLine, '', false, false)]
    local procedure OnAfterInsertPurchOrderLine_PurchQuotetoOrder(var PurchaseOrderLine: Record "Purchase Line"; var PurchaseQuoteLine: Record "Purchase Line")
    begin
        //ALLETG RIL0011 22-06-2011: START>>
        PurchaseOrderLine.InsertDlvrSchdLines(PurchaseOrderLine);
        //ALLETG RIL0011 22-06-2011: END<<

    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Quote to Order", OnBeforeDeletePurchQuote, '', false, false)]
    local procedure OnBeforeDeletePurchQuote_PurchQuotetoOrder(var IsHandled: Boolean; var OrderPurchHeader: Record "Purchase Header"; var QuotePurchHeader: Record "Purchase Header")
    var
        PurchTerms: Record Terms;
        OldPurchTerms: Record Terms;
    begin
        //ALLERP
        PurchTerms.SETRANGE("Document Type", QuotePurchHeader."Document Type");
        PurchTerms.SETRANGE("Document No.", QuotePurchHeader."No.");
        IF NOT PurchTerms.ISEMPTY THEN BEGIN
            PurchTerms.LOCKTABLE;
            IF PurchTerms.FINDSET THEN
                REPEAT
                    OldPurchTerms := PurchTerms;
                    PurchTerms.DELETE;
                    PurchTerms."Document Type" := OrderPurchHeader."Document Type".AsInteger();
                    PurchTerms."Document No." := OrderPurchHeader."No.";
                    PurchTerms.INSERT;
                    PurchTerms := OldPurchTerms;
                UNTIL PurchTerms.NEXT = 0;
        END;
        //ALLERP
        //ALLERP Allebugfix 24-11-2010:Start:
        IF QuotePurchHeader."Enquiry No." <> '' THEN
            ChangeEnqStatus(QuotePurchHeader."Enquiry No.");
        //ALLERP Allebugfix 24-11-2010:End:

    End;




    PROCEDURE ChangeEnqStatus(EnqNo: Code[20]);
    VAR
        EnqHeader: Record "Vendor Enquiry Details";
    BEGIN
        //ALLERP Start:
        IF EnqHeader.GET(EnqNo) THEN BEGIN
            EnqHeader.Status := EnqHeader.Status::Close;
            EnqHeader.MODIFY;
        END;
        //ALLERP End:
    END;

    //======= Codeunit 96 "Purch.-Quote to Order" ========END<<

    //======= Codeunit 212 "Res. Jnl.-Post Line" ========Start>>

    [EventSubscriber(ObjectType::Table, Database::"Res. Ledger Entry", 'OnAfterCopyFromResJnlLine', '', false, false)]
    local procedure OnAfterCopyFromResJnlLine_ResLedgerEntry(ResJournalLine: Record "Res. Journal Line"; var ResLedgerEntry: Record "Res. Ledger Entry")
    begin
        //AlleDK 160708
        ResLedgerEntry.Remark := ResJournalLine.Remark;
        ResLedgerEntry.Verified := ResJournalLine.Verified;
        ResLedgerEntry."Verified By" := ResJournalLine."Verified By";
        ResLedgerEntry."Work Type Description" := ResJournalLine."Work Type Description";
        //AlleDK 160708
    end;
    //======= Codeunit 212 "Res. Jnl.-Post Line" ========END<<


    //======= Codeunit 213 "Res. Jnl.-Post Batch" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Res. Jnl.-Post Batch", OnBeforeRunUpdateAnalysisView, '', false, false)]
    local procedure OnBeforeRunUpdateAnalysisView_ResJnlPostBatch(var IsHandled: Boolean)
    begin
        IsHandled := true;
    END;

    //======= Codeunit 213 "Res. Jnl.-Post Batch" ========END<<

    //======= Codeunit 226 "CustEntry-Apply Posted Entries" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustEntry-Apply Posted Entries", OnApplyCustEntryFormEntryOnBeforeRunCustEntryEdit, '', false, false)]
    local procedure OnApplyCustEntryFormEntryOnBeforeRunCustEntryEdit_CustEntryApplyPostedEntries(var ApplyingCustLedgEntry: Record "Cust. Ledger Entry")
    begin
        ApplyingCustLedgEntry.CALCFIELDS(ApplyingCustLedgEntry."Remaining Amount"); //ALLEAA
        ApplyingCustLedgEntry."Amount to Apply" := ApplyingCustLedgEntry."Remaining Amount";
    END;

    //======= Codeunit 226 "CustEntry-Apply Posted Entries" ========END<<

    //======= Codeunit 227 "VendEntry-Apply Posted Entries" ========Start>>

    PROCEDURE AutoAppliesVLEntry(VLEntry_1: Record "Vendor Ledger Entry"; ApplyAmount_1: Decimal);
    VAR
        EntriesToApply: Record "Vendor Ledger Entry";
        ApplicationDate: Date;
        UpdateAnalysisView: Codeunit "Update Analysis View";
        VLEntry_2: Record "Vendor Ledger Entry";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        PostApplication: Page "Post Application";
        GenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        EntryNoBeforeApplication: Integer;
        EntryNoAfterApplication: Integer;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        VendEntryApply: Codeunit "VendEntry-Apply Posted Entries";
    BEGIN
        VLEntry_2.RESET;
        //VLEntry_2.SETCURRENTKEY("Vendor No.");
        VLEntry_2.SETRANGE(VLEntry_2."Vendor No.", VLEntry_1."Vendor No.");
        //  VLEntry_2.SETFILTER(VLEntry_2."Document Type",'%1|%2',VLEntry_2."Document Type"::Payment,
        //                      VLEntry_2."Document Type"::"Credit Memo");
        VLEntry_2.SETFILTER(VLEntry_2."Document Type", '%1', VLEntry_2."Document Type"::Payment);
        VLEntry_2.SETRANGE(Open, TRUE);
        VLEntry_2.SETRANGE(VLEntry_2.Reversed, FALSE);
        VLEntry_2.SETRANGE("Posting Date", 0D, 20170630D);
        VLEntry_2.SETRANGE("TDS Section Code", '');//"TDS Nature of Deduction"
        IF VLEntry_2.FINDSET THEN
            REPEAT
                VLEntry_2.CALCFIELDS(VLEntry_2."Remaining Amount");
                IF ApplyAmount_1 >= VLEntry_2."Remaining Amount" THEN BEGIN
                    VLEntry_2."Applies-to ID" := USERID;
                    VLEntry_2."Amount to Apply" := VLEntry_2."Remaining Amount";
                    ApplyAmount_1 := ApplyAmount_1 - VLEntry_2."Remaining Amount";
                    //        VLEntry_2."Applying Entry" := TRUE;
                END ELSE IF ApplyAmount_1 > 0 THEN BEGIN
                    VLEntry_2."Applies-to ID" := USERID;
                    VLEntry_2."Amount to Apply" := VLEntry_2."Remaining Amount";
                    ApplyAmount_1 := 0;
                    //      VLEntry_2."Applying Entry" := TRUE;
                END;
                VLEntry_2.MODIFY;
            UNTIL (VLEntry_2.NEXT = 0) OR (ApplyAmount_1 = 0);


        IF NOT PaymentToleranceMgt.PmtTolVend(VLEntry_1) THEN
            EXIT;
        VLEntry_1.GET(VLEntry_1."Entry No.");

        ApplicationDate := 0D;
        //EntriesToApply.SetAppliesToIDFilter(VLEntry_1."Vendor No.", USERID);
        EntriesToApply.FINDSET;
        REPEAT
            IF EntriesToApply."Posting Date" > ApplicationDate THEN
                ApplicationDate := EntriesToApply."Posting Date";
        UNTIL EntriesToApply.NEXT = 0;
        //PostApplication.SetValues(VLEntry_1."Document No.", ApplicationDate);
        PostApplication.LOOKUPMODE(TRUE);
        //  IF ACTION::LookupOK = PostApplication.RUNMODAL THEN BEGIN
        GenJnlLine.INIT;
        //PostApplication.GetValues(GenJnlLine."Document No.", GenJnlLine."Posting Date");
        IF GenJnlLine."Posting Date" < ApplicationDate THEN
            ERROR(
              Text003,
              GenJnlLine.FIELDCAPTION("Posting Date"), VLEntry_1.FIELDCAPTION("Posting Date"), VLEntry_1.TABLECAPTION);
        //END ELSE
        //  EXIT;

        // Window.OPEN(Text001);

        SourceCodeSetup.GET;

        GenJnlLine."Document Date" := GenJnlLine."Posting Date";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine."Account No." := VLEntry_1."Vendor No.";
        VLEntry_1.CALCFIELDS("Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");
        GenJnlLine.Correction :=
          (VLEntry_1."Debit Amount" < 0) OR (VLEntry_1."Credit Amount" < 0) OR
          (VLEntry_1."Debit Amount (LCY)" < 0) OR (VLEntry_1."Credit Amount (LCY)" < 0);
        GenJnlLine."Document Type" := VLEntry_1."Document Type";
        GenJnlLine.Description := VLEntry_1.Description;
        GenJnlLine."Shortcut Dimension 1 Code" := VLEntry_1."Global Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := VLEntry_1."Global Dimension 2 Code";
        GenJnlLine."Posting Group" := VLEntry_1."Vendor Posting Group";
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source No." := VLEntry_1."Vendor No.";
        GenJnlLine."Source Code" := SourceCodeSetup."Purchase Entry Application";
        GenJnlLine."System-Created Entry" := TRUE;
        GenJnlLine."Offline Application" := TRUE;
        //GenJnlLine."Input Service Distribution" := "Input Service Distribution";
        //GenJnlLine."Serv. Tax on Advance Payment" := "Serv. Tax on Advance Payment";
        //GenJnlLine.PoT := PoT;
        GenJnlLine."Applies-to ID" := USERID;
        GenJnlLine."Currency Code" := VLEntry_1."Currency Code";

        EntryNoBeforeApplication := FindLastApplDtldVendLedgEntry;

        GenJnlPostLine.VendPostApplyVendLedgEntry(GenJnlLine, VLEntry_1);

        EntryNoAfterApplication := FindLastApplDtldVendLedgEntry;
        //  IF EntryNoAfterApplication = EntryNoBeforeApplication THEN
        //  ERROR(Text004);

        COMMIT;
        //  Window.CLOSE;
        UpdateAnalysisView.UpdateAll(0, TRUE);
        // MESSAGE(Text002);
    END;

    PROCEDURE BatchPostUnApplyVendor(VAR DtldVendLedgEntryBuf: Record "Detailed Vendor Ledg. Entry"; DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry"; VAR DocNo: Code[20]; VAR PostingDate: Date);
    VAR
        GLEntry: Record "G/L Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlLine: Record "Gen. Journal Line";
        DateComprReg: Record "Date Compr. Register";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        //ServiceTaxMgt: Codeunit 16471;
        Window: Dialog;
        ApplicationEntryNo: Integer;
        LastTransactionNo: Integer;
        AddCurrChecked: Boolean;
        MaxPostingDate: Date;
        VendEntryApply: Codeunit "VendEntry-Apply Posted Entries";
        Text008: Label 'Unapplying and posting...';
        Text015: Label 'The latest %3 must be an application in %1 No. %2.';
        Text012: Label 'Before you can unapply this entry, you must first unapply all application entries in %1 No. %2 that were posted after this entry.';
    BEGIN
        MaxPostingDate := 0D;
        GLEntry.LOCKTABLE;
        DtldVendLedgEntry.LOCKTABLE;
        VendLedgEntry.LOCKTABLE;
        VendLedgEntry.GET(DtldVendLedgEntry2."Vendor Ledger Entry No.");
        CheckPostingDate(PostingDate, MaxPostingDate);
        IF PostingDate < DtldVendLedgEntry2."Posting Date" THEN
            ERROR(Text003,
              DtldVendLedgEntry2.FIELDCAPTION("Posting Date"),
              DtldVendLedgEntry2.FIELDCAPTION("Posting Date"),
              DtldVendLedgEntry2.TABLECAPTION);
        DtldVendLedgEntry.SETCURRENTKEY("Transaction No.", "Vendor No.", "Entry Type");
        DtldVendLedgEntry.SETRANGE("Transaction No.", DtldVendLedgEntry2."Transaction No.");
        DtldVendLedgEntry.SETRANGE("Vendor No.", DtldVendLedgEntry2."Vendor No.");
        IF DtldVendLedgEntry.FINDFIRST THEN
            REPEAT
                IF (DtldVendLedgEntry."Entry Type" <> DtldVendLedgEntry."Entry Type"::"Initial Entry") AND
                   NOT DtldVendLedgEntry.Unapplied
                THEN BEGIN
                    IF NOT AddCurrChecked THEN BEGIN
                        CheckAdditionalCurrency(PostingDate, DtldVendLedgEntry."Posting Date");
                        AddCurrChecked := TRUE;
                    END;
                    VendEntryApply.CheckReversal(DtldVendLedgEntry."Vendor Ledger Entry No.");
                    IF DtldVendLedgEntry."Entry Type" = DtldVendLedgEntry."Entry Type"::Application THEN BEGIN
                        LastTransactionNo :=
                          FindLastApplTransactionEntry(DtldVendLedgEntry."Vendor Ledger Entry No.");
                        IF (LastTransactionNo <> 0) AND (LastTransactionNo <> DtldVendLedgEntry."Transaction No.") THEN
                            ERROR(Text012, VendLedgEntry.TABLECAPTION, DtldVendLedgEntry."Vendor Ledger Entry No.");
                    END;
                    LastTransactionNo := FindLastTransactionNo(DtldVendLedgEntry."Vendor Ledger Entry No.");
                    IF (LastTransactionNo <> 0) AND (LastTransactionNo <> DtldVendLedgEntry."Transaction No.") THEN
                        ERROR(
                          Text015,
                          VendLedgEntry.TABLECAPTION,
                          DtldVendLedgEntry."Vendor Ledger Entry No.",
                          VendLedgEntry.FIELDCAPTION("Transaction No."));
                END;
            UNTIL DtldVendLedgEntry.NEXT = 0;

        //ServiceTaxMgt.CheckUnapplyServiceTax(DtldVendLedgEntry2);
        //ServiceTaxMgt.CheckUnapplyServiceTaxAndTDS(DtldVendLedgEntry2."Transaction No.", VendLedgEntry);

        DateComprReg.CheckMaxDateCompressed(MaxPostingDate, 0);

        SourceCodeSetup.GET;
        VendLedgEntry.GET(DtldVendLedgEntry2."Vendor Ledger Entry No.");
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
        GenJnlLine."Account No." := DtldVendLedgEntry2."Vendor No.";
        GenJnlLine.Correction := TRUE;
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::" ";
        GenJnlLine.Description := VendLedgEntry.Description;
        GenJnlLine."Shortcut Dimension 1 Code" := VendLedgEntry."Global Dimension 1 Code";
        GenJnlLine."Shortcut Dimension 2 Code" := VendLedgEntry."Global Dimension 2 Code";
        IF VendLedgEntry."TDS Section Code" <> '' THEN BEGIN // "TDS Nature of Deduction"
            GenJnlLine."Party Type" := GenJnlLine."Party Type"::Vendor;
            GenJnlLine.VALIDATE("Party Code", DtldVendLedgEntry2."Vendor No.");
            //GenJnlLine."TDS Nature of Deduction" := VendLedgEntry."TDS Nature of Deduction";
            //GenJnlLine."TDS Group" := VendLedgEntry."TDS Group";
        END;
        GenJnlLine."Posting Group" := VendLedgEntry."Vendor Posting Group";
        GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
        GenJnlLine."Source No." := DtldVendLedgEntry2."Vendor No.";
        GenJnlLine."Source Code" := SourceCodeSetup."Unapplied Purch. Entry Appln.";
        GenJnlLine."Source Currency Code" := DtldVendLedgEntry2."Currency Code";
        GenJnlLine."System-Created Entry" := TRUE;
        //GenJnlLine.PoT := VendLedgEntry.PoT;

        Window.OPEN(Text008);
        GenJnlPostLine.UnapplyVendLedgEntry(GenJnlLine, DtldVendLedgEntry2);
        DtldVendLedgEntryBuf.DELETEALL;
        DocNo := '';
        PostingDate := 0D;
        COMMIT;
        Window.CLOSE;
    END;

    LOCAL PROCEDURE CheckPostingDate(PostingDate: Date; VAR MaxPostingDate: Date);
    VAR
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        NotAllowedPostingDatesErr: Label 'Posting date is not within the range of allowed posting dates.';

    BEGIN
        IF GenJnlCheckLine.DateNotAllowed(PostingDate) THEN
            ERROR(NotAllowedPostingDatesErr);

        IF PostingDate > MaxPostingDate THEN
            MaxPostingDate := PostingDate;
    END;

    procedure FindLastApplTransactionEntry(VendLedgEntryNo: Integer): Integer
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        LastTransactionNo: Integer;
    begin
        DtldVendLedgEntry.SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
        DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntryNo);
        DtldVendLedgEntry.SetRange("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
        LastTransactionNo := 0;
        if DtldVendLedgEntry.Find('-') then
            repeat
                if (DtldVendLedgEntry."Transaction No." > LastTransactionNo) and not DtldVendLedgEntry.Unapplied then
                    LastTransactionNo := DtldVendLedgEntry."Transaction No.";
            until DtldVendLedgEntry.Next() = 0;
        exit(LastTransactionNo);
    end;

    procedure FindLastTransactionNo(VendLedgEntryNo: Integer): Integer
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        LastTransactionNo: Integer;
    begin
        DtldVendLedgEntry.SetCurrentKey("Vendor Ledger Entry No.", "Entry Type");
        DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", VendLedgEntryNo);
        DtldVendLedgEntry.SetRange(Unapplied, false);
        DtldVendLedgEntry.SetFilter(
            "Entry Type", '<>%1&<>%2',
            DtldVendLedgEntry."Entry Type"::"Unrealized Loss", DtldVendLedgEntry."Entry Type"::"Unrealized Gain");
        LastTransactionNo := 0;
        if DtldVendLedgEntry.FindSet() then
            repeat
                if LastTransactionNo < DtldVendLedgEntry."Transaction No." then
                    LastTransactionNo := DtldVendLedgEntry."Transaction No.";
            until DtldVendLedgEntry.Next() = 0;
        exit(LastTransactionNo);
    end;

    local procedure CheckAdditionalCurrency(OldPostingDate: Date; NewPostingDate: Date)
    var
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        CannotUnapplyExchRateErr: Label 'You cannot unapply the entry with the posting date %1, because the exchange rate for the additional reporting currency has been changed.';
    begin
        if OldPostingDate = NewPostingDate then
            exit;
        GLSetup.GetRecordOnce();
        if GLSetup."Additional Reporting Currency" <> '' then
            if CurrExchRate.ExchangeRate(OldPostingDate, GLSetup."Additional Reporting Currency") <>
               CurrExchRate.ExchangeRate(NewPostingDate, GLSetup."Additional Reporting Currency")
            then
                Error(CannotUnapplyExchRateErr, NewPostingDate);
    end;

    procedure FindLastApplDtldVendLedgEntry(): Integer
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry.LockTable();
        exit(DtldVendLedgEntry.GetLastEntryNo());
    end;

    //======= Codeunit 227 "VendEntry-Apply Posted Entries" ========END<<

    //======= Codeunit 370 "Bank Acc. Reconciliation Post" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Reconciliation Post", OnCloseBankAccLedgEntryOnBeforeBankAccLedgEntryModify, '', false, false)]
    local procedure OnCloseBankAccLedgEntryOnBeforeBankAccLedgEntryModify_BankAccReconciliationPost(BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        BankAccountLedgerEntry."New Value Dt." := BankAccReconciliationLine."Value Date";  //ALLEDK 211021
    End;



    //======= Codeunit 370 "Bank Acc. Reconciliation Post" ========END<<


    //======= Codeunit 375 "Bank Acc. Entry Set Recon.-No." ========Start>>

    PROCEDURE ToggleReconNo(VAR BankAccLedgEntry: Record "Bank Account Ledger Entry"; VAR BankAccReconLine: Record "Bank Acc. Reconciliation Line"; ChangeAmount: Boolean);
    var
        BnkAccRecoLine: Record "Bank Acc. Reconciliation Line";
        CheckLedgEntry: Record "Check Ledger Entry";
        BAERNo: codeunit "Bank Acc. Entry Set Recon.-No.";
    BEGIN
        BankAccLedgEntry.LOCKTABLE;
        CheckLedgEntry.LOCKTABLE;
        BankAccReconLine.LOCKTABLE;
        //ALLERK 27-07-2009: Code added: START >>
        BnkAccRecoLine.COPY(BankAccReconLine);
        BnkAccRecoLine.FIND;
        IF BnkAccRecoLine."Doc. No Of Applied Entry" <> '' THEN BEGIN
            BnkAccRecoLine.RESET;
            BnkAccRecoLine.SETRANGE("Doc. No Of Applied Entry", BankAccReconLine."Doc. No Of Applied Entry");
            BnkAccRecoLine.SETRANGE("Statement No.", BankAccReconLine."Statement No.");
            IF BnkAccRecoLine.FINDFIRST THEN
                REPEAT
                    IF BankAccLedgEntry."Statement No." = '' THEN BEGIN
                        BnkAccRecoLine."Applied Amount" := BnkAccRecoLine."Applied Amount" + BnkAccRecoLine.Difference;
                        BnkAccRecoLine."Applied Entries" := BnkAccRecoLine."Applied Entries" + 1;
                    END ELSE BEGIN
                        BnkAccRecoLine."Applied Amount" := BnkAccRecoLine."Applied Amount" - BnkAccRecoLine."Applied Difference Amt";
                        BnkAccRecoLine."Applied Entries" := BnkAccRecoLine."Applied Entries" - 1;
                    END;
                    IF ChangeAmount THEN
                        BnkAccRecoLine.VALIDATE("Statement Amount", BankAccReconLine."Applied Amount")
                    ELSE
                        BnkAccRecoLine.VALIDATE("Statement Amount");
                    BnkAccRecoLine.MODIFY;
                UNTIL BnkAccRecoLine.NEXT = 0;
            IF BankAccLedgEntry."Statement No." = '' THEN
                BAERNo.SetReconNo(BankAccLedgEntry, BnkAccRecoLine)
            ELSE
                BAERNo.RemoveReconNo(BankAccLedgEntry, BnkAccRecoLine, TRUE);
            BnkAccRecoLine.MODIFY;
        END ELSE BEGIN
            //ALLERK 27-07-2009: END <<
            BankAccReconLine.FIND;
            IF BankAccLedgEntry."Statement No." = '' THEN BEGIN
                BAERNo.SetReconNo(BankAccLedgEntry, BankAccReconLine);
                BankAccReconLine."Applied Amount" :=
                  BankAccReconLine."Applied Amount" + BankAccLedgEntry."Remaining Amount";
                BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" + 1;
            END ELSE BEGIN
                BAERNo.RemoveReconNo(BankAccLedgEntry, BankAccReconLine, TRUE);
                BankAccReconLine."Applied Amount" :=
                  BankAccReconLine."Applied Amount" - BankAccLedgEntry."Remaining Amount";
                BankAccReconLine."Applied Entries" := BankAccReconLine."Applied Entries" - 1;
            END;
            IF ChangeAmount THEN
                BankAccReconLine.VALIDATE("Statement Amount", BankAccReconLine."Applied Amount")
            ELSE
                BankAccReconLine.VALIDATE("Statement Amount");
            BankAccReconLine.MODIFY;
        END;
    END;

    //======= Codeunit 375 "Bank Acc. Entry Set Recon.-No." ========END<<

    //======= Codeunit 410 "Update Analysis View" ========Start>>


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Update Analysis View", OnUpdateAnalysisViewEntryOnAfterTempAnalysisViewEntryAssignment, '', false, false)]
    local procedure OnUpdateAnalysisViewEntryOnAfterTempAnalysisViewEntryAssignment_UpdateAnalysisView(var AnalysisView: Record "Analysis View"; var GLEntry: Record "G/L Entry"; var TempAnalysisViewEntry: Record "Analysis View Entry" temporary; var UpdAnalysisViewEntryBuffer: Record "Upd Analysis View Entry Buffer" temporary)
    var
        Item: Record Item;
        AnalysisView1: Record "Analysis View";
    begin
        // ALLEPG 220509 Start
        IF AnalysisView1.GET('WORKCENTER') THEN BEGIN
            IF AnalysisView1."Date Compression" = AnalysisView1."Date Compression"::None THEN BEGIN
                TempAnalysisViewEntry."Document No." := GLEntry."Document No.";
                TempAnalysisViewEntry."Item Code" := GLEntry."BBG Item Code";
                IF Item.GET(GLEntry."BBG Item Code") THEN
                    TempAnalysisViewEntry."Item Description" := Item.Description;
            END;
        END;
        // ALLEPG 220509 End
    End;

    //======= Codeunit 410 "Update Analysis View" ========END<<


    //======= Codeunit 415 "Release Purchase Document" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", OnReopenOnBeforePurchaseHeaderModify, '', false, false)]
    local procedure OnReopenOnBeforePurchaseHeaderModify_ReleasePurchaseDocument(var PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader.Approved := FALSE; //120220
    end;

    //======= Codeunit 415 "Release Purchase Document" ========END<<

    //======= Codeunit 418 "User Management" ========Start>>

    PROCEDURE GetUser(UserName: Code[50]; VAR User: Record User): Boolean;
    BEGIN
        User.RESET;
        User.SETCURRENTKEY("User Name");
        User.SETRANGE(User."User Name", UserName);
        EXIT(User.FINDFIRST);
    END;

    //======= Codeunit 418 "User Management" ========END<<

    //======= Codeunit 427 "ICInboxOutboxMgt" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ICInboxOutboxMgt", OnCreatePurchDocumentOnBeforePurchHeaderInsert, '', false, false)]
    local procedure OnCreatePurchDocumentOnBeforePurchHeaderInsert_ICInboxOutboxMgt(ICInboxPurchaseHeader: Record "IC Inbox Purchase Header"; var PurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader."Workflow Sub Document Type" := PurchaseHeader."Workflow Sub Document Type"::Direct;
    End;

    //======= Codeunit 427 "ICInboxOutboxMgt" ========END<<

    //======= Codeunit 1011 "Job Jnl.-Check Line" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Check Line", OnAfterRunCheck, '', false, false)]
    local procedure OnAfterRunCheck_JobJnlCheckLine(var JobJnlLine: Record "Job Journal Line")
    begin

        //ALLETG RIL0100 15-06-2011: START>>
        IF JobJnlLine."Entry Type" = JobJnlLine."Entry Type"::Progress THEN BEGIN
            JobJnlLine.TESTFIELD("Unit Cost", 0);
            JobJnlLine.TESTFIELD("Unit Price", 0);
            JobJnlLine.TESTFIELD("Line Type", JobJnlLine."Line Type"::" ");
        END;
        //ALLETG RIL0100 15-06-2011: END<<
    End;

    //======= Codeunit 1011 "Job Jnl.-Check Line" ========END<<

    //======= Codeunit 1012 "Job Jnl.-Post Line" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", OnAfterPostItem, '', false, false)]
    local procedure OnAfterPostItem_JobJnlPostLine(var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var JobJournalLine2: Record "Job Journal Line")
    begin
        //alle ps  060512
        // IF CalledfromSalesGlobal THEN BEGIN
        //     IF ItemLedgEntry.GET(ItemShptEntryNoGlobal) THEN BEGIN
        //         JobJournalLine2.VALIDATE(Quantity, -ItemLedgEntry.Quantity / JobJnlLine."Qty. per Unit of Measure");
        //         JobJournalLine2."Ledger Entry Type" := JobJournalLine2."Ledger Entry Type"::Item;
        //         JobJournalLine2."Ledger Entry No." := ItemShptEntryNoGlobal;
        //         JobLedgEntryNo := CreateJobLedgEntry(JobJournalLine2);
        //     END
        // END;
    End;



    PROCEDURE CalledFromSales(CalledfromSales: Boolean; ItemShptEntryNo: Integer);
    var
        CalledfromSalesGlobal: Boolean;
        ItemShptEntryNoGlobal: Integer;
    BEGIN
        CalledfromSalesGlobal := CalledfromSales;
        ItemShptEntryNoGlobal := ItemShptEntryNo;
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", OnCreateJobLedgerEntryOnAfterAssignLedgerEntryTypeAndNo, '', false, false)]
    local procedure OnCreateJobLedgerEntryOnAfterAssignLedgerEntryTypeAndNo_JobJnlPostLine(GLEntryNo: Integer; JobJournalLine: Record "Job Journal Line"; var JobLedgEntry: Record "Job Ledger Entry")
    begin
        if JobLedgEntry."Entry Type" = JobLedgEntry."Entry Type"::Sale then begin

            //ALLETG RIL0100 15-06-2011: START>>
        END ELSE IF JobLedgEntry."Entry Type" = JobLedgEntry."Entry Type"::Progress THEN BEGIN
            JobLedgEntry.Quantity := JobJournalLine.Quantity;
            JobLedgEntry."Quantity (Base)" := JobJournalLine."Quantity (Base)";
            JobLedgEntry."BOQ Code" := JobJournalLine."BOQ Code";
            JobLedgEntry."Entry No. (BOQ)" := JobJournalLine."Entry No.";
            //ALLETG RIL0100 15-06-2011: END<<
        End;
        //ALLE PS Added code to flow customized fields
        JobLedgEntry."Tax Group Code" := JobJournalLine."Tax Group Code";
        JobLedgEntry."Tax Area Code" := JobJournalLine."Tax Area Code";
        JobLedgEntry."Tax %" := JobJournalLine."Tax %";
        JobLedgEntry."Service Tax Base Amount" := JobJournalLine."Service Tax Base Amount";
        JobLedgEntry."Tax Amount" := JobJournalLine."Tax Amount";
        JobLedgEntry."Service Tax Amount" := JobJournalLine."Service Tax Amount";
        JobLedgEntry."Service Tax Ecess Amount" := JobJournalLine."Service Tax Ecess Amount";
        JobLedgEntry."Service Tax She cess Amount" := JobJournalLine."Service Tax She cess Amount";
        JobLedgEntry."Tax Base Amount" := JobJournalLine."Tax Base Amount";
        JobLedgEntry."Fixed Asset No" := JobJournalLine."Fixed Asset No";//alle PS
        JobLedgEntry."Job Contract Entry No." := JobJournalLine."Job Contract Entry No."; // ALLEAA
        JobLedgEntry."Verified By" := JobJournalLine."Verified By";    // ALLEPG 201211

    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", OnPostItemOnBeforeAssignItemJnlLine, '', false, false)]
    local procedure OnPostItemOnBeforeAssignItemJnlLine_JobJnlPostLine(JobPlanningLine: Record "Job Planning Line"; var ItemJnlLine: Record "Item Journal Line"; var JobJournalLine2: Record "Job Journal Line"; var JobJournalLine: Record "Job Journal Line")
    var
        GPHeader: Record "Gate Pass Header";
    begin
        ItemJnlLine."Fixed Asset No" := JobJournalLine2."Fixed Asset No";//ALLE PS
        IF GPHeader.GET(GPHeader."Document Type"::"Finished Goods", JobJournalLine2."Document No.") THEN  //RAHEE1.00 060512
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt."      //RAHEE1.00 060512
        ELSE
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";

        //NDALLE
        IF JobJournalLine2."Vendor No." <> '' THEN    //180321
            ItemJnlLine."Vendor No." := JobJournalLine2."Vendor No."    //180321
        ELSE
            ItemJnlLine."Vendor No." := JobJournalLine."Vendor No.";
        ItemJnlLine."PO No." := JobJournalLine."PO No.";
        ItemJnlLine."Indent No" := JobJournalLine."Indent No";
        ItemJnlLine."Indent Line No" := JobJournalLine."Indent Line No";
        ItemJnlLine."Issue Type" := JobJournalLine."Issue Type";
        ItemJnlLine."Reference No." := JobJournalLine."Reference No.";
        //NDALLE
    End;

    //======= Codeunit 1012 "Job Jnl.-Post Line" ========END<<

    //======= Codeunit 5059 "ProfileManagement" ========Start>>

    LOCAL PROCEDURE FindLegalProfileQuestionnaireCustomer(Cont: Record "Customers Lead_2")
    VAR
        ContBusRel: Record "Contact Business Relation";
        ProfileQuestnHeader: Record "Profile Questionnaire Header";
        ContProfileAnswer: Record "Contact Profile Answer";
        Valid: Boolean;
        ProfileQuestnHeaderTemp: Record "Profile Questionnaire Header" TEMPORARY;
    BEGIN
        ProfileQuestnHeaderTemp.DELETEALL;

        ProfileQuestnHeader.RESET;
        IF ProfileQuestnHeader.FIND('-') THEN
            REPEAT
                Valid := TRUE;
                IF (ProfileQuestnHeader."Contact Type" = ProfileQuestnHeader."Contact Type"::Companies) AND
                   (Cont.Type <> Cont.Type::Company)
                THEN
                    Valid := FALSE;
                IF (ProfileQuestnHeader."Contact Type" = ProfileQuestnHeader."Contact Type"::People) AND
                   (Cont.Type <> Cont.Type::Person)
                THEN
                    Valid := FALSE;
                IF Valid AND (ProfileQuestnHeader."Business Relation Code" <> '') THEN
                    IF NOT ContBusRel.GET(Cont."Company No.", ProfileQuestnHeader."Business Relation Code") THEN
                        Valid := FALSE;
                IF NOT Valid THEN BEGIN
                    ContProfileAnswer.RESET;
                    ContProfileAnswer.SETRANGE("Contact No.", Cont."No.");
                    ContProfileAnswer.SETRANGE("Profile Questionnaire Code", ProfileQuestnHeader.Code);
                    IF ContProfileAnswer.FINDFIRST THEN
                        Valid := TRUE;
                END;
                IF Valid THEN BEGIN
                    ProfileQuestnHeaderTemp := ProfileQuestnHeader;
                    ProfileQuestnHeaderTemp.INSERT;
                END;
            UNTIL ProfileQuestnHeader.NEXT = 0;
    END;

    PROCEDURE GetQuestionnaireCustomer(): Code[10]
    VAR
        ProfileQuestnHeader: Record "Profile Questionnaire Header";
    BEGIN
        IF ProfileQuestnHeader.FINDFIRST THEN
            EXIT(ProfileQuestnHeader.Code);

        ProfileQuestnHeader.INIT;
        ProfileQuestnHeader.Code := Text000;
        ProfileQuestnHeader.Description := Text000;
        ProfileQuestnHeader.INSERT;
        EXIT(ProfileQuestnHeader.Code);
    END;

    PROCEDURE ProfileQuestionnaireAllowedCustomer(Cont: Record "Customers Lead_2"; ProfileQuestnHeaderCode: Code[10]): Code[10]
    var
        ProfileQuestnHeaderTemp: Record "Profile Questionnaire Header" TEMPORARY;
    BEGIN
        FindLegalProfileQuestionnaireCustomer(Cont);

        IF ProfileQuestnHeaderTemp.GET(ProfileQuestnHeaderCode) THEN
            EXIT(ProfileQuestnHeaderCode);
        IF ProfileQuestnHeaderTemp.FINDFIRST THEN
            EXIT(ProfileQuestnHeaderTemp.Code);

        ERROR(Text001);
    END;

    PROCEDURE ShowContactQuestionnaireCardCustomer(Cont: Record "Customers Lead_2"; ProfileQuestnLineCode: Code[10]; ProfileQuestnLineLineNo: Integer)
    VAR
        ProfileQuestnLine: Record "Profile Questionnaire Line";
        ContProfileAnswers: Page "Cust Contact Profile Answers";
        ProfileQuestnHeaderTemp: Record "Profile Questionnaire Header" TEMPORARY;
    BEGIN
        //Cont.CheckIfMinorForProfiles;
        ContProfileAnswers.SetParameters(Cont, ProfileQuestionnaireAllowedCustomer(Cont, ''), ProfileQuestnLineCode, ProfileQuestnLineLineNo);
        IF ProfileQuestnHeaderTemp.GET(ProfileQuestnLineCode) THEN BEGIN
            ProfileQuestnLine.GET(ProfileQuestnLineCode, ProfileQuestnLineLineNo);
            ContProfileAnswers.SETRECORD(ProfileQuestnLine);
        END;
        ContProfileAnswers.RUN; //RUNMODAL;
    END;

    PROCEDURE CheckNameCustomer(CurrentQuestionsChecklistCode: Code[10]; VAR Cont: Record "Customers Lead_2")
    var
        ProfileQuestnHeaderTemp: Record "Profile Questionnaire Header" TEMPORARY;
    BEGIN
        FindLegalProfileQuestionnaireCustomer(Cont);
        ProfileQuestnHeaderTemp.GET(CurrentQuestionsChecklistCode);
    END;

    PROCEDURE SetNameCustomer(ProfileQuestnHeaderCode: Code[10]; VAR ProfileQuestnLine: Record "Profile Questionnaire Line"; ContactProfileAnswerLine: Integer)
    BEGIN
        ProfileQuestnLine.FILTERGROUP := 2;
        ProfileQuestnLine.SETRANGE("Profile Questionnaire Code", ProfileQuestnHeaderCode);
        ProfileQuestnLine.FILTERGROUP := 0;
        IF ContactProfileAnswerLine = 0 THEN
            IF ProfileQuestnLine.FIND('-') THEN;
    END;

    PROCEDURE LookupNameCustomer(VAR ProfileQuestnHeaderCode: Code[10]; VAR ProfileQuestnLine: Record "Profile Questionnaire Line"; VAR Cont: Record "Customers Lead_2")
    var
        ProfileQuestnHeaderTemp: Record "Profile Questionnaire Header" TEMPORARY;
        ProfileMgt: Codeunit "ProfileManagement";
    BEGIN
        COMMIT;
        FindLegalProfileQuestionnaireCustomer(Cont);
        IF ProfileQuestnHeaderTemp.GET(ProfileQuestnHeaderCode) THEN;
        IF PAGE.RUNMODAL(
             PAGE::"Profile Questionnaire List", ProfileQuestnHeaderTemp) = ACTION::LookupOK
        THEN
            ProfileQuestnHeaderCode := ProfileQuestnHeaderTemp.Code;

        ProfileMgt.SetName(ProfileQuestnHeaderCode, ProfileQuestnLine, 0);
    END;

    PROCEDURE ShowAnswerPointsCustomer(CurrProfileQuestnLine: Record "Profile Questionnaire Line");
    BEGIN
        CurrProfileQuestnLine.SETRANGE("Profile Questionnaire Code", CurrProfileQuestnLine."Profile Questionnaire Code");
        PAGE.RUNMODAL(PAGE::"Answer Points", CurrProfileQuestnLine);
    END;

    //======= Codeunit 5059 "ProfileManagement" ========END<<

    //======= Codeunit 5063 "ArchiveManagement" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ArchiveManagement", OnGetNextOccurrenceNo, '', false, false)]
    local procedure OnGetNextOccurrenceNo_ArchiveManagement(DocNo: Code[20]; DocType: Option; TableId: Integer; var OccurenceNo: Integer)
    var
        JobArchive: Record "EPC Job Archive";
    begin
        // ALLEPG 271211 Start
        IF TableId = 167 then BEGIN
            JobArchive.LOCKTABLE;
            JobArchive.SETRANGE("No.", DocNo);
            IF JobArchive.FINDLAST THEN
                OccurenceNo := JobArchive."Doc. No. Occurrence" + 1
            ELSE
                OccurenceNo := 1;
        END;
        // ALLEPG 271211 End
    End;

    PROCEDURE ArchiveJob(VAR Job: Record Job)
    var
        Text007: Label 'Archive %1 no.: %2?';
    BEGIN
        IF CONFIRM(
          Text007, TRUE, Job."No.")
        THEN BEGIN
            StoreJob2(Job);  // ALLEPG 271211
            MESSAGE(Text001, Job."No.");
        END;
    END;

    PROCEDURE StoreJob(VAR Job: Record Job)
    VAR
        JobArchive: Record "EPC Job Archive";
        JobTask: Record "Job Task";
        JobTaskArchive: Record "EPC Job Task Archive";
        JobPlanning: Record "Job Planning Line";
        JobPlanningArchive: Record "EPC Job Planning Line Archive";
        ArchiveManagement: Codeunit ArchiveManagement;
    BEGIN
        JobArchive.INIT;
        JobArchive.TRANSFERFIELDS(Job);
        JobArchive."Archived By" := USERID;
        JobArchive."Date Archived" := WORKDATE;
        JobArchive."Time Archived" := TIME;
        JobArchive."Version No." := ArchiveManagement.GetNextVersionNo(DATABASE::Job, 1, Job."No.", Job."Doc. No. Occurrence");
        JobArchive.INSERT;

        JobTask.RESET;
        JobTask.SETRANGE("Job No.", Job."No.");
        IF JobTask.FINDSET THEN
            REPEAT
                JobTaskArchive.INIT;
                JobTaskArchive.TRANSFERFIELDS(JobTask);
                JobTaskArchive."Version No." := JobArchive."Version No.";
                JobTaskArchive.INSERT;
            UNTIL JobTask.NEXT = 0;
        JobPlanning.RESET;
        JobPlanning.SETRANGE("Job No.", Job."No.");
        IF JobPlanning.FINDSET THEN
            REPEAT
                JobPlanningArchive.INIT;
                JobPlanningArchive.TRANSFERFIELDS(JobPlanning);
                JobPlanningArchive."Version No." := JobArchive."Version No.";
                JobPlanningArchive.INSERT;
            UNTIL JobPlanning.NEXT = 0;
    END;

    PROCEDURE StoreJob2(VAR Job: Record Job);
    VAR
        JobArchive: Record "EPC Job Archive";
        JobTask: Record "Job Task";
        JobTaskArchive: Record "EPC Job Task Archive";
        JobPlanning: Record "Job Planning Line";
        JobPlanningArchive: Record "EPC Job Planning Line Archive";
        ArchiveManagement: Codeunit ArchiveManagement;
    BEGIN
        JobArchive.INIT;
        JobArchive.TRANSFERFIELDS(Job);
        JobArchive."Archived By" := USERID;
        JobArchive."Date Archived" := WORKDATE;
        JobArchive."Time Archived" := TIME;
        JobArchive."Version No." := ArchiveManagement.GetNextVersionNo(DATABASE::Job, 1, Job."No.", 1);
        JobArchive.INSERT;

        JobTask.RESET;
        JobTask.SETRANGE("Job No.", Job."No.");
        IF JobTask.FINDSET THEN
            REPEAT
                JobTaskArchive.INIT;
                JobTaskArchive.TRANSFERFIELDS(JobTask);
                JobTaskArchive."Version No." := JobArchive."Version No.";
                JobTaskArchive.INSERT;
            UNTIL JobTask.NEXT = 0;
        JobPlanning.RESET;
        JobPlanning.SETRANGE("Job No.", Job."No.");
        IF JobPlanning.FINDSET THEN
            REPEAT
                JobPlanningArchive.INIT;
                JobPlanningArchive.TRANSFERFIELDS(JobPlanning);
                JobPlanningArchive."Version No." := JobArchive."Version No.";
                JobPlanningArchive.INSERT;
            UNTIL JobPlanning.NEXT = 0;
    END;

    //======= Codeunit 5063 "ArchiveManagement" ========END<<


    //======= Codeunit 6500 "Item Tracking Management" ========Start>>   

    PROCEDURE CallItemTrackingEntryForm(SourceType: Option " ",Customer,Vendor,Item; SourceNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[20]; SerialNo: Code[20]; LotNo: Code[20]; LocationCode: Code[10])
    VAR
        ItemLedgEntry: Record "Item Ledger Entry";
        TempItemLedgEntry: Record "Item Ledger Entry" TEMPORARY;
        Item: Record Item;
        Window: Dialog;
    BEGIN
        // Used when calling Item Tracking from Item, Stockkeeping Unit, Customer, Vendor and information card:
        Window.OPEN(Text004);

        IF SourceNo <> '' THEN BEGIN
            ItemLedgEntry.SETCURRENTKEY("Source Type", "Source No.", "Item No.", "Variant Code");
            ItemLedgEntry.SETRANGE("Source No.", SourceNo);
            ItemLedgEntry.SETRANGE("Source Type", SourceType);
        END ELSE
            ItemLedgEntry.SETCURRENTKEY("Item No.", Open, "Variant Code");

        IF LocationCode <> '' THEN
            ItemLedgEntry.SETRANGE("Location Code", LocationCode);

        IF ItemNo <> '' THEN BEGIN
            Item.GET(ItemNo);
            Item.TESTFIELD("Item Tracking Code");
            ItemLedgEntry.SETRANGE("Item No.", ItemNo);
        END;
        IF SourceType = 0 THEN
            ItemLedgEntry.SETRANGE("Variant Code", VariantCode);
        IF SerialNo <> '' THEN
            ItemLedgEntry.SETRANGE("Serial No.", SerialNo);
        IF LotNo <> '' THEN
            ItemLedgEntry.SETRANGE("Lot No.", LotNo);

        IF ItemLedgEntry.FINDSET THEN
            REPEAT
                IF (ItemLedgEntry."Serial No." <> '') OR (ItemLedgEntry."Lot No." <> '') THEN BEGIN
                    TempItemLedgEntry := ItemLedgEntry;
                    TempItemLedgEntry.INSERT;
                END
            UNTIL ItemLedgEntry.NEXT = 0;
        Window.CLOSE;
        PAGE.RUNMODAL(PAGE::"Item Tracking Entries", TempItemLedgEntry);
    END;

    //======= Codeunit 6500 "Item Tracking Management" ========END<<

    //======= Codeunit 7171 "Sales Info-Pane Management" ========Start>>

    PROCEDURE CalcAvailableCredit(CustNo: Code[20]): Decimal;
    VAR
        TotalAmountLCY: Decimal;
        Cust: Record Customer;
    BEGIN
        GetCust(CustNo, Cust);
        Cust.SETRANGE("Date Filter", 0D, WORKDATE);
        Cust.CALCFIELDS("Balance (LCY)", "Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)", "Outstanding Invoices (LCY)");
        TotalAmountLCY := Cust."Balance (LCY)" + Cust."Outstanding Orders (LCY)" + Cust."Shipped Not Invoiced (LCY)" + Cust."Outstanding Invoices (LCY)";
        IF Cust."Credit Limit (LCY)" <> 0 THEN
            EXIT(Cust."Credit Limit (LCY)" - TotalAmountLCY);
    END;

    LOCAL PROCEDURE GetCust(CustNo: Code[20]; var Cust: Record Customer)
    BEGIN
        IF CustNo <> '' THEN BEGIN
            IF CustNo <> Cust."No." THEN
                IF NOT Cust.GET(CustNo) THEN
                    CLEAR(Cust);
        END ELSE
            CLEAR(Cust);
    END;

    //======= Codeunit 7171 "Sales Info-Pane Management" ========END<<

    //======= Codeunit 1502 "Workflow Setup" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", OnAfterInitWorkflowTemplates, '', false, false)]
    local procedure OnAfterInitWorkflowTemplates_WorkflowSetup()
    var
    Begin
        //EPC2016Upgrade
        InsertWorkflowTemplatesDTS;
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", OnAfterInsertApprovalsTableRelations, '', false, false)]
    local procedure OnAfterInsertApprovalsTableRelations_WorkflowSetup()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        ApprovalEntry: Record "Approval Entry";
    begin
        //Nav Upgrade 2016
        WorkflowSetup.InsertTableRelation(DATABASE::Job, 0,
          DATABASE::"Approval Entry", ApprovalEntry.FIELDNO("Record ID to Approve"));

        WorkflowSetup.InsertTableRelation(DATABASE::"Transfer Header", 0,
        DATABASE::"Approval Entry", ApprovalEntry.FIELDNO("Record ID to Approve"));

        WorkflowSetup.InsertTableRelation(DATABASE::"Production BOM Header", 0,
        DATABASE::"Approval Entry", ApprovalEntry.FIELDNO("Record ID to Approve"));

        WorkflowSetup.InsertTableRelation(DATABASE::"Production Order", 0,
        DATABASE::"Approval Entry", ApprovalEntry.FIELDNO("Record ID to Approve"));

        //Nav Upgrade 2016
    end;

    PROCEDURE InitWorkflowDTS()
    VAR
        Workflow: Record Workflow;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowRequestPageHandling: Codeunit "Workflow Request Page Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    BEGIN
        WorkflowEventHandling.CreateEventsLibrary;
        WorkflowRequestPageHandling.CreateEntitiesAndFields;
        WorkflowRequestPageHandling.AssignEntitiesToWorkflowEvents;
        WorkflowResponseHandling.CreateResponsesLibrary;
        InsertWorkflowCategoriesDTS;
        InsertJobQueueData;
        /*
        //Temporary block this segment to create new workflow template - begin
         Workflow.SETRANGE(Template, TRUE);
          IF Workflow.FINDFIRST THEN
              EXIT;
        //Temporary block this segment to create new workflow template - end
        */
        InsertWorkflowTemplatesDTS;
    END;

    local procedure InsertJobQueueData()
    var
        JobQueueEntry: Record "Job Queue Entry";
        WorkflowSetup: Codeunit "Workflow Setup";
        JobQueueEntryDescTxt: Label 'Auto-created for sending of delegated approval requests. Can be deleted if not used. Will be recreated when the feature is activated.';
    begin
        if TASKSCHEDULER.CanCreateTask() then
            WorkflowSetup.CreateJobQueueEntry(
              JobQueueEntry."Object Type to Run"::Report,
              REPORT::"Delegate Approval Requests",
              CopyStr(JobQueueEntryDescTxt, 1, MaxStrLen(JobQueueEntry.Description)),
              CurrentDateTime,
              1440);
    end;

    LOCAL PROCEDURE InsertWorkflowTemplatesDTS()
    BEGIN
        InsertApprovalsTableRelationsDTS;

        //Temporary block this segment to create new workflow template - begin
        // InsertVendorApprovalWorkflowTemplate;
        //InsertPurchaseIndentApprovalWorkflowTemplate;
        //InsertJobApprovalWorkflowTemplate;
        // InsertPurchaseReceiptApprovalWorkflowTemplate;
        //InsertTransferOrderApprovalWorkflowTemplate;
        //InsertAwardNoteWorkflowTemplate;//ALLE TS 17012017
        //InsertNoteSheetWorkflowTemplate;//ALLE TS 17012017
        //Temporary block this segment to create new workflow template - end
    END;

    PROCEDURE InsertWorkflowCategoriesDTS()
    var
        WorkflowSetup: Codeunit "Workflow Setup";
        InventoryCategoryTxt: Label 'INVT';
        InventoryCategoryDescTxt: Label 'Inventory';
        InventoryDocCategoryTxt: Label 'INVTDOC';
        InventoryDocCategoryDescTxt: Label 'Inventory Documents';
    BEGIN
        //For New Category to Create
        WorkflowSetup.InsertWorkflowCategory(InventoryCategoryTxt, InventoryCategoryDescTxt);
        WorkflowSetup.InsertWorkflowCategory(InventoryDocCategoryTxt, InventoryDocCategoryDescTxt);

        //OnAddWorkflowCategoriesToLibrary;
    END;

    PROCEDURE InsertApprovalsTableRelationsDTS()
    VAR
        IncomingDocument: Record "Incoming Document";
        ApprovalEntry: Record "Approval Entry";
        WorkflowSetup: Codeunit "Workflow Setup";
    BEGIN
        WorkflowSetup.InsertTableRelation(DATABASE::"Purchase Request Header", 0,
          DATABASE::"Approval Entry", ApprovalEntry.FIELDNO("Record ID to Approve"));
        WorkflowSetup.InsertTableRelation(DATABASE::Job, 0,
          DATABASE::"Approval Entry", ApprovalEntry.FIELDNO("Record ID to Approve"));
        WorkflowSetup.InsertTableRelation(DATABASE::"GRN Header", 0,
          DATABASE::"Approval Entry", ApprovalEntry.FIELDNO("Record ID to Approve"));
        WorkflowSetup.InsertTableRelation(DATABASE::"Transfer Header", 0,
          DATABASE::"Approval Entry", ApprovalEntry.FIELDNO("Record ID to Approve"));

        /*
        InsertTableRelation(DATABASE::"Purchase Header",0,
          DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));
        InsertTableRelation(DATABASE::"Sales Header",0,
          DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));
        InsertTableRelation(DATABASE::Customer,0,
          DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));
        InsertTableRelation(DATABASE::Vendor,0,
          DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));
        InsertTableRelation(DATABASE::Item,0,
          DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));
        InsertTableRelation(DATABASE::"Gen. Journal Line",0,
          DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));
        InsertTableRelation(DATABASE::"Gen. Journal Batch",0,
          DATABASE::"Approval Entry",ApprovalEntry.FIELDNO("Record ID to Approve"));
        */
    END;

    LOCAL PROCEDURE InsertVendorApprovalWorkflowTemplate()
    VAR
        Workflow: Record Workflow;
    BEGIN
        //InsertWorkflowTemplate(Workflow,VendorApprWorkflowCodeTxt,VendorApprWorkflowDescTxt,PurchPayCategoryTxt);
        //InsertVendorApprovalWorkflowDetails(Workflow);
        //MarkWorkflowAsTemplate(Workflow);
    END;

    PROCEDURE InsertVendorApprovalWorkflow()
    VAR
        Workflow: Record Workflow;
    BEGIN
        //InsertWorkflow(Workflow,GetWorkflowCode(VendorApprWorkflowCodeTxt),VendorApprWorkflowDescTxt,PurchPayCategoryTxt);
        //InsertVendorApprovalWorkflowDetails(Workflow);
    END;

    LOCAL PROCEDURE InsertVendorApprovalWorkflowDetails(VAR Workflow: Record Workflow)
    VAR
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        BlankDateFormula: DateFormula;
    BEGIN
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
          0, '', BlankDateFormula, TRUE);

        WorkflowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildVendorTypeConditions,
          WorkflowEventHandling.RunWorkflowOnSendVendorForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelVendorApprovalRequestCode,
          WorkflowStepArgument,
          TRUE, TRUE);
    END;

    LOCAL PROCEDURE BuildVendorTypeConditions(): Text
    VAR
        Vendor: Record Vendor;
    BEGIN
        //EXIT(STRSUBSTNO(VendorTypeCondnTxt,Encode(Vendor.GETVIEW(FALSE))));
    END;

    LOCAL PROCEDURE InsertPurchaseIndentApprovalWorkflowTemplate()
    VAR
        Workflow: Record Workflow;
        WorkflowSetup: Codeunit "Workflow Setup";
        PurchIndentApprWorkflowCodeTxt: Label 'PINDAPW';
        PurchIndentApprWorkflowDescTxt: Label 'Purchase Indent Approval Workflow';
        PurchDocCategoryTxt: Label 'PURCHDOC';


    BEGIN
        WorkflowSetup.InsertWorkflowTemplate(Workflow, PurchIndentApprWorkflowCodeTxt, PurchIndentApprWorkflowDescTxt, PurchDocCategoryTxt);
        InsertPurchaseIndentApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertPurchaseIndentApprovalWorkflowDetails(VAR Workflow: Record Workflow)
    VAR
        PurchaseIndentHeader: Record "Purchase Request Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkFlowSetup: Codeunit "Workflow Setup";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        BlankDateFormula: DateFormula;
    BEGIN
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::"Workflow User Group", WorkflowStepArgument."Approver Limit Type"::"Approver Chain",
          0, '', BlankDateFormula, TRUE);

        WorkFlowSetup.InsertDocApprovalWorkflowSteps(Workflow, BuildPurchIndentHeaderTypeConditionsDTS(0, PurchaseIndentHeader."Workflow Approval Status"::Open, 0, '', '', FALSE),
          RunWorkflowOnSendPurchaseIndentDocForApprovalCode,
          BuildPurchIndentHeaderTypeConditionsDTS(0, PurchaseIndentHeader."Workflow Approval Status"::"Pending Approval", 0, '', '', FALSE),
          RunWorkflowOnCancelPurchaseIndentApprovalRequestCode,
          WorkflowStepArgument, TRUE);
    END;

    PROCEDURE InsertPurchaseIndentDocumentApprovalWorkflowDTS(VAR Workflow: Record Workflow; DocumentType: Option; ApproverType: Option; LimitType: Option; WorkflowUserGroupCode: Code[20]; DueDateFormula: DateFormula; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean)
    VAR
        PurchaseIndentHeader: Record "Purchase Request Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkFlowSetup: Codeunit "Workflow Setup";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        PurchIndentApprWorkflowCodeTxt: Label 'PINDAPW';
        PurchIndentApprWorkflowDescTxt: Label 'Purchase Indent Approval Workflow';
        BEGINPurchDocCategoryTxt: Label 'PURCHDOC';
        PurchDocCategoryTxt: Label 'PURCHDOC';
    Begin
        CASE DocumentType OF
            PurchaseIndentHeader."Document Type"::Indent:
                InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(PurchIndentApprWorkflowCodeTxt)), PurchIndentApprWorkflowDescTxt, PurchDocCategoryTxt);
        END;

        PopulateWorkflowStepArgument(WorkflowStepArgument, ApproverType, LimitType, 0,
          Workflow.Code, DueDateFormula, TRUE); //Workflow.Code as WorkflowUserGroupCode

        WorkFlowSetup.InsertDocApprovalWorkflowSteps(Workflow, BuildPurchIndentHeaderTypeConditionsDTS(0, PurchaseIndentHeader."Workflow Approval Status"::Open, SubDocumentType, ResponsibilityCenterCode, User, Amendment),
          RunWorkflowOnSendPurchaseIndentDocForApprovalCode,
          BuildPurchIndentHeaderTypeConditionsDTS(0, PurchaseIndentHeader."Workflow Approval Status"::"Pending Approval", SubDocumentType, ResponsibilityCenterCode, User, Amendment),
          RunWorkflowOnCancelPurchaseIndentApprovalRequestCode,
          WorkflowStepArgument, TRUE);
    END;

    PROCEDURE RunWorkflowOnSendPurchaseIndentDocForApprovalCode(): Code[128]
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnSendPurchaseIndentDocForApproval'));
    END;

    LOCAL PROCEDURE BuildPurchIndentHeaderTypeConditionsDTS(DocumentType: Option; Status: Option; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean): Text
    VAR
        PurchaseIndentHeader: Record "Purchase Request Header";
        PurchaseIndentLine: Record "Purchase Request Line";
        //WorkFlowSetup: Codeunit "Workflow Setup";
        PurchIndentHeaderTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Purchase Request Header">%1</DataItem><DataItem name="Purchase Request Line">%2</DataItem></DataItems></ReportParameters>"';
    BEGIN
        PurchaseIndentHeader.SETRANGE("Document Type", DocumentType);
        PurchaseIndentHeader.SETRANGE("Workflow Approval Status", Status);
        PurchaseIndentHeader.SETRANGE("Workflow Sub Document Type", SubDocumentType);
        PurchaseIndentHeader.SETRANGE("Responsibility Center", ResponsibilityCenterCode);
        PurchaseIndentHeader.SETRANGE("Initiator User ID", User);
        //PurchaseIndentHeader.SETRANGE(Amendment,Amendment);  //ALLE ANSH
        EXIT(STRSUBSTNO(PurchIndentHeaderTypeCondnTxt, WorkFlowSetup.Encode(PurchaseIndentHeader.GETVIEW(FALSE)), WorkFlowSetup.Encode(PurchaseIndentLine.GETVIEW(FALSE))));
    END;

    PROCEDURE InsertPurchaseDocumentApprovalWorkflowDTS(VAR Workflow: Record Workflow; DocumentType: Option; ApproverType: Option; LimitType: Option; WorkflowUserGroupCode: Code[20]; DueDateFormula: DateFormula; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean)
    VAR
        PurchaseHeader: Record "Purchase Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        PurchOrderApprWorkflowCodeTxt: Label 'POAPW';
        PurchInvoiceApprWorkflowDescTxt: Label 'Purchase Invoice Approval Workflow';
        PurchReturnOrderApprWorkflowDescTxt: Label 'Purchase Return Order Approval Workflow';
        PurchQuoteApprWorkflowDescTxt: Label 'Purchase Quote Approval Workflow';
        PurchOrderApprWorkflowDescTxt: Label 'Purchase Order Approval Workflow';
        PurchCreditMemoApprWorkflowDescTxt: Label 'Purchase Credit Memo Approval Workflow';
        PurchBlanketOrderApprWorkflowDescTxt: Label 'Blanket Purchase Order Approval Workflow';
        PurchDocCategoryTxt: Label 'PURCHDOC';
        PurchInvoiceApprWorkflowCodeTxt: Label 'PIAPW';
        PurchReturnOrderApprWorkflowCodeTxt: Label 'PROAPW';
        PurchQuoteApprWorkflowCodeTxt: Label 'PQAPW';
        PurchCreditMemoApprWorkflowCodeTxt: Label 'PCMAPW';
        PurchBlanketOrderApprWorkflowCodeTxt: Label 'BPOAPW';
    BEGIN
        CASE DocumentType OF
            PurchaseHeader."Document Type"::Order:
                InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(PurchOrderApprWorkflowCodeTxt)), PurchOrderApprWorkflowDescTxt, PurchDocCategoryTxt);
            PurchaseHeader."Document Type"::Invoice:
                InsertWorkflow(
                  Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(PurchInvoiceApprWorkflowCodeTxt)), PurchInvoiceApprWorkflowDescTxt, PurchDocCategoryTxt);
            PurchaseHeader."Document Type"::"Return Order":
                InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(PurchReturnOrderApprWorkflowCodeTxt)),
                  PurchReturnOrderApprWorkflowDescTxt, PurchDocCategoryTxt);
            PurchaseHeader."Document Type"::"Credit Memo":
                InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(PurchCreditMemoApprWorkflowCodeTxt)),
                  PurchCreditMemoApprWorkflowDescTxt, PurchDocCategoryTxt);
            PurchaseHeader."Document Type"::Quote:
                InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(PurchQuoteApprWorkflowCodeTxt)), PurchQuoteApprWorkflowDescTxt, PurchDocCategoryTxt);
            PurchaseHeader."Document Type"::"Blanket Order":
                InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(PurchBlanketOrderApprWorkflowCodeTxt)),
                  PurchBlanketOrderApprWorkflowDescTxt, PurchDocCategoryTxt);
        END;

        PopulateWorkflowStepArgument(WorkflowStepArgument, ApproverType, LimitType, 0,
          Workflow.Code, DueDateFormula, TRUE); //Workflow.Code as WorkflowUserGroupCode

        WorkFlowSetup.InsertDocApprovalWorkflowSteps(Workflow, BuildPurchHeaderTypeConditionsDTS(DocumentType, PurchaseHeader.Status::Open, SubDocumentType, ResponsibilityCenterCode, User, Amendment),
          WorkflowEventHandling.RunWorkflowOnSendPurchaseDocForApprovalCode,
          BuildPurchHeaderTypeConditionsDTS(DocumentType, PurchaseHeader.Status::"Pending Approval", SubDocumentType, ResponsibilityCenterCode, User, Amendment),
          WorkflowEventHandling.RunWorkflowOnCancelPurchaseApprovalRequestCode,
          WorkflowStepArgument, TRUE);
    END;

    LOCAL PROCEDURE BuildPurchHeaderTypeConditionsDTS(DocumentType: Option; Status: Option; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean): Text
    VAR
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchHeaderTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Purchase Header">%1</DataItem><DataItem name="Purchase Line">%2</DataItem></DataItems></ReportParameters>';
    BEGIN
        PurchaseHeader.SETRANGE("Document Type", DocumentType);
        PurchaseHeader.SETRANGE(Status, Status);
        PurchaseHeader.SETRANGE("Workflow Sub Document Type", SubDocumentType);
        PurchaseHeader.SETRANGE("Responsibility Center", ResponsibilityCenterCode);
        PurchaseHeader.SETRANGE("Initiator User ID", User);
        //PurchaseHeader.SETRANGE(Amendment,Amendment);
        EXIT(STRSUBSTNO(PurchHeaderTypeCondnTxt, WorkFlowSetup.Encode(PurchaseHeader.GETVIEW(FALSE)), WorkFlowSetup.Encode(PurchaseLine.GETVIEW(FALSE))));
    END;

    PROCEDURE InsertSalesDocumentApprovalWorkflowDTS(VAR Workflow: Record Workflow; DocumentType: Option; ApproverType: Option; LimitType: Option; WorkflowUserGroupCode: Code[20]; DueDateFormula: DateFormula; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean)
    VAR
        SalesHeader: Record "Sales Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkFlowSetup: Codeunit "Workflow Setup";
        SalesOrderApprWorkflowCodeTxt: Label '@@@={Locked}SOAPW';
        SalesOrderApprWorkflowDescTxt: Label 'Sales Order Approval Workflow';
        SalesDocCategoryTxt: Label 'SALESDOC';
        SalesInvoiceApprWorkflowCodeTxt: Label '@@@={Locked}SIAPW';
        SalesInvoiceApprWorkflowDescTxt: Label 'Sales Invoice Approval Workflow';
        SalesReturnOrderApprWorkflowCodeTxt: Label 'SROAPW';
        SalesReturnOrderApprWorkflowDescTxt: Label 'Sales Return Order Approval Workflow';
        SalesCreditMemoApprWorkflowCodeTxt: Label 'SCMAPW';
        SalesCreditMemoApprWorkflowDescTxt: Label 'Sales Credit Memo Approval Workflow';
        SalesQuoteApprWorkflowCodeTxt: Label 'SQAPW';
        SalesQuoteApprWorkflowDescTxt: Label 'Sales Quote Approval Workflow';
        SalesBlanketOrderApprWorkflowCodeTxt: Label 'BSOAPW';
        SalesBlanketOrderApprWorkflowDescTxt: Label 'Blanket Sales Order Approval Workflow';
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    BEGIN
        CASE DocumentType OF
            SalesHeader."Document Type"::Order:
                InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(SalesOrderApprWorkflowCodeTxt)), SalesOrderApprWorkflowDescTxt, SalesDocCategoryTxt);
            SalesHeader."Document Type"::Invoice:
                InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(SalesInvoiceApprWorkflowCodeTxt)),
                  SalesInvoiceApprWorkflowDescTxt, SalesDocCategoryTxt);
            SalesHeader."Document Type"::"Return Order":
                InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(SalesReturnOrderApprWorkflowCodeTxt)),
                  SalesReturnOrderApprWorkflowDescTxt, SalesDocCategoryTxt);
            SalesHeader."Document Type"::"Credit Memo":
                InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(SalesCreditMemoApprWorkflowCodeTxt)),
                  SalesCreditMemoApprWorkflowDescTxt, SalesDocCategoryTxt);
            SalesHeader."Document Type"::Quote:
                InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(SalesQuoteApprWorkflowCodeTxt)), SalesQuoteApprWorkflowDescTxt, SalesDocCategoryTxt);
            SalesHeader."Document Type"::"Blanket Order":
                InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(SalesBlanketOrderApprWorkflowCodeTxt)),
                  SalesBlanketOrderApprWorkflowDescTxt, SalesDocCategoryTxt);
        END;

        PopulateWorkflowStepArgument(WorkflowStepArgument, ApproverType, LimitType, 0,
          Workflow.Code, DueDateFormula, TRUE); //Workflow.Code as WorkflowUserGroupCode

        WorkFlowSetup.InsertDocApprovalWorkflowSteps(Workflow, BuildSalesHeaderTypeConditionsDTS(DocumentType, SalesHeader.Status::Open, SubDocumentType, ResponsibilityCenterCode, User, Amendment),
          WorkflowEventHandling.RunWorkflowOnSendSalesDocForApprovalCode,
          BuildSalesHeaderTypeConditionsDTS(DocumentType, SalesHeader.Status::"Pending Approval", SubDocumentType, ResponsibilityCenterCode, User, Amendment),
          WorkflowEventHandling.RunWorkflowOnCancelSalesApprovalRequestCode,
          WorkflowStepArgument, TRUE);
    END;

    PROCEDURE BuildSalesHeaderTypeConditionsDTS(DocumentType: Option; Status: Option; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean): Text
    VAR
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        //WorkFlowSetup: Codeunit "Workflow Setup";
        SalesHeaderTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Sales Header">%1</DataItem><DataItem name="Sales Line">%2</DataItem></DataItems></ReportParameters>';
    BEGIN
        SalesHeader.SETRANGE("Document Type", DocumentType);
        SalesHeader.SETRANGE(Status, Status);
        SalesHeader.SETRANGE("Workflow Sub Document Type", SubDocumentType);
        SalesHeader.SETRANGE("Responsibility Center", ResponsibilityCenterCode);
        SalesHeader.SETRANGE("Initiator User ID", User);
        //SalesHeader.SETRANGE(Amendment,Amendment);
        EXIT(STRSUBSTNO(SalesHeaderTypeCondnTxt, WorkFlowSetup.Encode(SalesHeader.GETVIEW(FALSE)), WorkFlowSetup.Encode(SalesLine.GETVIEW(FALSE))));
    END;

    PROCEDURE InsertGeneralJournalBatchApprovalWorkflowDTS(VAR Workflow: Record Workflow; DocumentType: Option; ApproverType: Option; LimitType: Option; WorkflowUserGroupCode: Code[20]; DueDateFormula: DateFormula; JnlTemplate: Code[20]; JnlBatch: Code[20])
    VAR
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkFlowSetup: Codeunit "Workflow Setup";
        GeneralJournalBatchApprWorkflowCodeTxt: Label 'GJBAPW';
        GeneralJournalBatchApprWorkflowDescTxt: Label 'General Journal Batch Approval Workflow';
        FinCategoryTxt: Label 'FIN';
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    BEGIN
        InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(GeneralJournalBatchApprWorkflowCodeTxt)),
          GeneralJournalBatchApprWorkflowDescTxt, FinCategoryTxt);

        PopulateWorkflowStepArgument(WorkflowStepArgument, ApproverType, LimitType, 0,
          Workflow.Code, DueDateFormula, TRUE); //Workflow.Code as WorkflowUserGroupCode

        WorkFlowSetup.InsertGenJnlBatchApprovalWorkflowSteps(Workflow, BuildGeneralJournalBatchTypeConditionsDTS(JnlTemplate, JnlBatch),
          WorkflowEventHandling.RunWorkflowOnSendGeneralJournalBatchForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelGeneralJournalBatchApprovalRequestCode,
          WorkflowStepArgument, TRUE);
    END;

    LOCAL PROCEDURE BuildGeneralJournalBatchTypeConditionsDTS(JnlTemplate: Code[20]; JnlBatch: Code[20]): Text
    VAR
        GenJournalBatch: Record "Gen. Journal Batch";
        //WorkFlowSetup: Codeunit "Workflow Setup";
        GeneralJournalBatchTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Gen. Journal Batch">%1</DataItem></DataItems></ReportParameters>';
    BEGIN
        GenJournalBatch.RESET;
        GenJournalBatch.SETRANGE("Journal Template Name", JnlTemplate);
        GenJournalBatch.SETRANGE(Name, JnlBatch);
        EXIT(STRSUBSTNO(GeneralJournalBatchTypeCondnTxt, WorkFlowSetup.Encode(GenJournalBatch.GETVIEW(FALSE))));
    END;

    PROCEDURE InsertGeneralJournalLineApprovalWorkflowDTS(VAR Workflow: Record Workflow; DocumentType: Option; ApproverType: Option; LimitType: Option; WorkflowUserGroupCode: Code[20]; DueDateFormula: DateFormula; ResponsibilityCenterCode: Code[20]; User: Code[50])
    VAR
        WorkflowStepArgument: Record "Workflow Step Argument";
        GenJournalLine: Record "Gen. Journal Line";
        WorkFlowSetup: Codeunit "Workflow Setup";
        GeneralJournalLineApprWorkflowCodeTxt: Label 'ENU=GJLAPW';
        GeneralJournalLineApprWorkflowDescTxt: Label 'General Journal Line Approval Workflow';
        FinCategoryTxt: Label 'FIN';
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    BEGIN
        InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(GeneralJournalLineApprWorkflowCodeTxt)),
          GeneralJournalLineApprWorkflowDescTxt, FinCategoryTxt);

        PopulateWorkflowStepArgument(WorkflowStepArgument, ApproverType, LimitType, 0,
          Workflow.Code, DueDateFormula, TRUE); //Workflow.Code as WorkflowUserGroupCode

        GenJournalLine.INIT;
        WorkFlowSetup.InsertRecApprovalWorkflowSteps(Workflow, BuildGeneralJournalLineTypeConditionsDTS(GenJournalLine),
          WorkflowEventHandling.RunWorkflowOnSendGeneralJournalLineForApprovalCode,
          WorkflowResponseHandling.CreateApprovalRequestsCode,
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode,
          WorkflowEventHandling.RunWorkflowOnCancelGeneralJournalLineApprovalRequestCode,
          WorkflowStepArgument,
          FALSE, FALSE);
    END;

    LOCAL PROCEDURE BuildGeneralJournalLineTypeConditionsDTS(VAR GenJournalLine: Record "Gen. Journal Line"): Text
    var
        GeneralJournalLineTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Gen. Journal Line">%1</DataItem></DataItems></ReportParameters>';
    //WorkFlowSetup: Codeunit "Workflow Setup";
    BEGIN
        //GenJournalLine.SETRANGE(Status,Status);
        //GenJournalLine.SETRANGE("Responsibility Center",ResponsibilityCenterCode);
        //GenJournalLine.SETRANGE("Initiator User ID",User);
        EXIT(STRSUBSTNO(GeneralJournalLineTypeCondnTxt, WorkFlowSetup.Encode(GenJournalLine.GETVIEW(FALSE))));
    END;

    LOCAL PROCEDURE GetWorkflowTemplateCodeDTS(WorkflowCode: Code[17]): Code[20]
    VAR
        Workflow: Record Workflow;
    BEGIN
        IF NOT Workflow.GET(WorkflowCode) THEN
            ERROR('');
        IF Workflow.Template OR (INCSTR(Workflow.Code) = '') THEN
            WorkflowCode := COPYSTR(Workflow.Code, 1, MAXSTRLEN(WorkflowCode) - 3) + '-01'
        ELSE
            WorkflowCode := Workflow.Code;
        WHILE Workflow.GET(WorkflowCode) DO
            WorkflowCode := INCSTR(WorkflowCode);

        EXIT(WorkflowCode);
    END;

    LOCAL PROCEDURE InsertJobApprovalWorkflowTemplate()
    VAR
        Workflow: Record Workflow;
        WorkFlowSetup: Codeunit "Workflow Setup";
        JobApprWorkflowCodeTxt: Label 'ENU=JOBAPW';
        JobApprWorkflowDescTxt: Label 'Job Approval Workflow';
        SalesDocCategoryTxt: Label 'SALESDOC';
    BEGIN
        WorkFlowSetup.InsertWorkflowTemplate(Workflow, JobApprWorkflowCodeTxt, JobApprWorkflowDescTxt, SalesDocCategoryTxt);
        InsertJobApprovalWorkflowDetails(Workflow);
        WorkFlowSetup.MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertJobApprovalWorkflowDetails(VAR Workflow: Record Workflow);
    VAR
        Job: Record Job;
        WorkflowStepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        WorkFlowSetup: Codeunit "Workflow Setup";
    BEGIN
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::"Workflow User Group", WorkflowStepArgument."Approver Limit Type"::"Approver Chain",
          0, '', BlankDateFormula, TRUE);

        WorkFlowSetup.InsertDocApprovalWorkflowSteps(Workflow, BuildJobTypeConditionsDTS(0, Job."Workflow Approval Status"::Open, 0, '', '', FALSE),
          RunWorkflowOnSendJobForApprovalCode,
          BuildJobTypeConditionsDTS(0, Job."Workflow Approval Status"::"Pending Approval", 0, '', '', FALSE),
          RunWorkflowOnCancelJobApprovalRequestCode,
          WorkflowStepArgument, TRUE);
    END;

    local procedure InsertWorkflow(var Workflow: Record Workflow; WorkflowCode: Code[20]; WorkflowDescription: Text[100]; CategoryCode: Code[20])
    begin
        Workflow.Init();
        Workflow.Code := WorkflowCode;
        Workflow.Description := WorkflowDescription;
        Workflow.Category := CategoryCode;
        Workflow.Enabled := false;
        Workflow.Insert();
    end;

    PROCEDURE InsertJobApprovalWorkflowDTS(VAR Workflow: Record Workflow; DocumentType: Option; ApproverType: Option; LimitType: Option; WorkflowUserGroupCode: Code[20]; DueDateFormula: DateFormula; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean)
    VAR
        Job: Record Job;
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkFlowSetup: Codeunit "Workflow Setup";
        JobApprWorkflowCodeTxt: Label 'JOBAPW';
        JobApprWorkflowDescTxt: Label 'Job Approval Workflow';
        SalesDocCategoryTxt: Label 'SALESDOC';

    BEGIN
        InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(JobApprWorkflowCodeTxt)), JobApprWorkflowDescTxt, SalesDocCategoryTxt);

        PopulateWorkflowStepArgument(WorkflowStepArgument, ApproverType, LimitType, 0,
          Workflow.Code, DueDateFormula, TRUE); //Workflow.Code as WorkflowUserGroupCode

        WorkFlowSetup.InsertDocApprovalWorkflowSteps(Workflow, BuildJobTypeConditionsDTS(0, Job."Workflow Approval Status"::Open, SubDocumentType, ResponsibilityCenterCode, User, Amendment),
          RunWorkflowOnSendJobForApprovalCode,
          BuildJobTypeConditionsDTS(0, Job."Workflow Approval Status"::"Pending Approval", SubDocumentType, ResponsibilityCenterCode, User, Amendment),
          RunWorkflowOnCancelJobApprovalRequestCode,
          WorkflowStepArgument, TRUE);
    END;

    PROCEDURE RunWorkflowOnSendJobForApprovalCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnSendJobForApproval'));
    END;

    LOCAL PROCEDURE PopulateWorkflowStepArgument(VAR WorkflowStepArgument: Record "Workflow Step Argument"; ApproverType: Option; ApproverLimitType: Option; ApprovalEntriesPage: Integer; WorkflowUserGroupCode: Code[20]; DueDateFormula: DateFormula; ShowConfirmationMessage: Boolean)
    BEGIN
        WorkflowStepArgument.INIT;
        WorkflowStepArgument.Type := WorkflowStepArgument.Type::Response;
        WorkflowStepArgument."Approver Type" := ApproverType;
        WorkflowStepArgument."Approver Limit Type" := ApproverLimitType;
        WorkflowStepArgument."Workflow User Group Code" := WorkflowUserGroupCode;
        WorkflowStepArgument."Due Date Formula" := DueDateFormula;
        WorkflowStepArgument."Link Target Page" := ApprovalEntriesPage;
        WorkflowStepArgument."Show Confirmation Message" := ShowConfirmationMessage;
    END;


    LOCAL PROCEDURE BuildJobTypeConditionsDTS(DocumentType: Option; Status: Option; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean): Text
    VAR
        Job: Record Job;
    BEGIN
        // Job.SETRANGE("Document Type",DocumentType);
        // Job.SETRANGE("Workflow Sub Document Type",SubDocumentType);
        Job.SETRANGE("Workflow Approval Status", Status);
        Job.SETRANGE("Responsibility Center", ResponsibilityCenterCode);
        Job.SETRANGE("Initiator User ID", User);
        //Job.SETRANGE(Amendment,Amendment);
        //EXIT(STRSUBSTNO(JobTypeCondnTxt, Encode(Job.GETVIEW(FALSE))));
    END;

    LOCAL PROCEDURE InsertPurchaseReceiptApprovalWorkflowTemplate()
    VAR
        Workflow: Record Workflow;
        WorkFlowSetup: Codeunit "Workflow Setup";
        PurchReceiptApprWorkflowCodeTxt: Label 'PRCTAPW';
        PurchReceiptApprWorkflowDescTxt: Label 'Purchase Receipt Approval Workflow';
        PurchDocCategoryTxt: Label 'PURCHDOC';

    BEGIN
        WorkFlowSetup.InsertWorkflowTemplate(Workflow, PurchReceiptApprWorkflowCodeTxt, PurchReceiptApprWorkflowDescTxt, PurchDocCategoryTxt);
        InsertPurchaseReceiptApprovalWorkflowDetails(Workflow);
        WorkFlowSetup.MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertPurchaseReceiptApprovalWorkflowDetails(VAR Workflow: Record Workflow)
    VAR
        GoodsReceiptHeader: Record "GRN Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
        BlankDateFormula: DateFormula;
        WorkFlowSetup: Codeunit "Workflow Setup";
    BEGIN
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::"Workflow User Group", WorkflowStepArgument."Approver Limit Type"::"Approver Chain",
          0, '', BlankDateFormula, TRUE);

        WorkFlowSetup.InsertDocApprovalWorkflowSteps(Workflow, BuildPurchReceiptHeaderTypeConditionsDTS(0, GoodsReceiptHeader."Workflow Approval Status"::Open, 0, '', '', FALSE),
          RunWorkflowOnSendPurchaseReceiptDocForApprovalCode,
          BuildPurchReceiptHeaderTypeConditionsDTS(0, GoodsReceiptHeader."Workflow Approval Status"::"Pending Approval", 0, '', '', FALSE),
          RunWorkflowOnCancelPurchaseReceiptApprovalRequestCode,
          WorkflowStepArgument, TRUE);
    END;

    PROCEDURE RunWorkflowOnSendPurchaseReceiptDocForApprovalCode(): Code[128]
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnSendPurchaseReceiptDocForApproval'));
    END;


    PROCEDURE InsertPurchaseReceiptDocumentApprovalWorkflowDTS(VAR Workflow: Record Workflow; DocumentType: Option; ApproverType: Option; LimitType: Option; WorkflowUserGroupCode: Code[20]; DueDateFormula: DateFormula; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean)
    VAR
        GoodsReceiptHeader: Record "GRN Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkFlowSetup: Codeunit "Workflow Setup";
        PurchReceiptApprWorkflowCodeTxt: Label 'PRCTAPW';
        PurchReceiptApprWorkflowDescTxt: Label 'Purchase Receipt Approval Workflow';
        PurchDocCategoryTxt: Label 'PURCHDOC';
    BEGIN
        CASE DocumentType OF
            GoodsReceiptHeader."Document Type"::GRN:
                InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(WorkFlowSetup.GetWorkflowTemplateCode(PurchReceiptApprWorkflowCodeTxt)), PurchReceiptApprWorkflowDescTxt, PurchDocCategoryTxt);
        END;

        PopulateWorkflowStepArgument(WorkflowStepArgument, ApproverType, LimitType, 0,
          Workflow.Code, DueDateFormula, TRUE); //Workflow.Code as WorkflowUserGroupCode

        WorkFlowSetup.InsertDocApprovalWorkflowSteps(Workflow, BuildPurchReceiptHeaderTypeConditionsDTS(0, GoodsReceiptHeader."Workflow Approval Status"::Open, SubDocumentType, ResponsibilityCenterCode, User, Amendment),
          RunWorkflowOnSendPurchaseReceiptDocForApprovalCode,
          BuildPurchReceiptHeaderTypeConditionsDTS(0, GoodsReceiptHeader."Workflow Approval Status"::"Pending Approval", SubDocumentType, ResponsibilityCenterCode, User, Amendment),
          RunWorkflowOnCancelPurchaseReceiptApprovalRequestCode,
          WorkflowStepArgument, TRUE);
    END;

    LOCAL PROCEDURE BuildPurchReceiptHeaderTypeConditionsDTS(DocumentType: Option; Status: Option; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean): Text
    VAR
        GoodsReceiptHeader: Record "GRN Header";
        GoodsReceiptLine: Record "GRN Line";
        //WorkFlowSetup: Codeunit "Workflow Setup";
        PurchReceiptHeaderTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="GRN Header">%1</DataItem><DataItem name="GRN Line">%2</DataItem></DataItems></ReportParameters>';
    BEGIN
        GoodsReceiptHeader.SETRANGE("Document Type", DocumentType);
        GoodsReceiptHeader.SETRANGE("Workflow Approval Status", Status);
        GoodsReceiptHeader.SETRANGE("Workflow Sub Document Type", SubDocumentType);
        GoodsReceiptHeader.SETRANGE("Responsibility Center", ResponsibilityCenterCode);
        GoodsReceiptHeader.SETRANGE("Initiator User ID", User);
        EXIT(STRSUBSTNO(PurchReceiptHeaderTypeCondnTxt, WorkFlowSetup.Encode(GoodsReceiptHeader.GETVIEW(FALSE)), WorkFlowSetup.Encode(GoodsReceiptLine.GETVIEW(FALSE))));
    END;

    LOCAL PROCEDURE InsertTransferOrderApprovalWorkflowTemplate()
    VAR
        Workflow: Record Workflow;
        WorkFlowSetup: Codeunit "Workflow Setup";
        TransferOrderApprWorkflowCodeTxt: Label 'TORDAPW';
        TransferOrderApprWorkflowDescTxt: Label 'Transfer Order Approval Workflow';
        InventoryDocCategoryTxt: Label 'INVTDOC';
    BEGIN
        WorkFlowSetup.InsertWorkflowTemplate(Workflow, TransferOrderApprWorkflowCodeTxt, TransferOrderApprWorkflowDescTxt, InventoryDocCategoryTxt);
        InsertTransferOrderApprovalWorkflowDetails(Workflow);
        WorkFlowSetup.MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertTransferOrderApprovalWorkflowDetails(VAR Workflow: Record Workflow)
    VAR
        TransferHeader: Record "Transfer Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
        WorkFlowSetup: Codeunit "Workflow Setup";
        BlankDateFormula: DateFormula;
    BEGIN
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::"Workflow User Group", WorkflowStepArgument."Approver Limit Type"::"Approver Chain",
          0, '', BlankDateFormula, TRUE);

        // WorkFlowSetup.InsertDocApprovalWorkflowSteps(Workflow, BuildTransferOrderHeaderTypeConditionsDTS(0, TransferHeader.Status::Open, 0, '', '', FALSE),
        //   RunWorkflowOnSendTransferOrderDocForApprovalCode,
        //   BuildTransferOrderHeaderTypeConditionsDTS(0, TransferHeader.Status::"Pending Approval", 0, '', '', FALSE),
        //   RunWorkflowOnCancelTransferOrderApprovalRequestCode,
        //   WorkflowStepArgument, TRUE); //Functionality is not used
    END;

    PROCEDURE InsertTransferOrderDocumentApprovalWorkflowDTS(VAR Workflow: Record Workflow; DocumentType: Option; ApproverType: Option; LimitType: Option; WorkflowUserGroupCode: Code[20]; DueDateFormula: DateFormula; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean)
    VAR
        TransferHeader: Record "Transfer Header";
        WorkflowStepArgument: Record "Workflow Step Argument";
    BEGIN
        // InsertWorkflow(Workflow, GetWorkflowTemplateCodeDTS(GetWorkflowTemplateCode(TransferOrderApprWorkflowCodeTxt)), TransferOrderApprWorkflowDescTxt, InventoryDocCategoryTxt);

        // PopulateWorkflowStepArgument(WorkflowStepArgument, ApproverType, LimitType, 0,
        //   Workflow.Code, DueDateFormula, TRUE); //Workflow.Code as WorkflowUserGroupCode

        // InsertDocApprovalWorkflowSteps(Workflow, BuildTransferOrderHeaderTypeConditionsDTS(0, TransferHeader.Status::Open, SubDocumentType, ResponsibilityCenterCode, User, Amendment),
        //   WorkflowEventHandling.RunWorkflowOnSendTransferOrderDocForApprovalCode,
        //   BuildTransferOrderHeaderTypeConditionsDTS(0, TransferHeader.Status::"Pending Approval", SubDocumentType, ResponsibilityCenterCode, User, Amendment),
        //   WorkflowEventHandling.RunWorkflowOnCancelTransferOrderApprovalRequestCode,
        //   WorkflowStepArgument, TRUE);//Functionality is not used
    END;

    LOCAL PROCEDURE BuildTransferOrderHeaderTypeConditionsDTS(DocumentType: Option; Status: Option; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean): Text
    VAR
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        TransferOrderApprWorkflowCodeTxt: Label 'TORDAPW';
        TransferOrderApprWorkflowDescTxt: Label 'Transfer Order Approval Workflow';
        InventoryDocCategoryTxt: Label 'INVTDOC';
        //WorkFlowSetup: Codeunit "Workflow Setup";
        TransferOrderHeaderTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Transfer Header">%1</DataItem><DataItem name="Transfer Line">%2</DataItem></DataItems></ReportParameters>';
    BEGIN
        //TransferHeader.SETRANGE("Document Type",DocumentType);
        TransferHeader.SETRANGE(Status, Status);
        TransferHeader.SETRANGE("Workflow Sub Document Type", SubDocumentType);
        TransferHeader.SETRANGE("Responsibility Center", ResponsibilityCenterCode);
        TransferHeader.SETRANGE("Initiator User ID", User);
        //TransferHeader.SETRANGE(Amendment,Amendment);
        EXIT(STRSUBSTNO(TransferOrderHeaderTypeCondnTxt, WorkFlowSetup.Encode(TransferHeader.GETVIEW(FALSE)), WorkFlowSetup.Encode(TransferLine.GETVIEW(FALSE))));
    END;

    LOCAL PROCEDURE "---ALLE TS---"()
    BEGIN
    END;

    PROCEDURE InsertAwardNoteWorkflowTemplate()
    VAR
        Workflow: Record Workflow;
        WorkFlowSetup: Codeunit "Workflow Setup";
        AwardNoteApprovalWorkflowCodeTxt: Label '';
        AwardApprWorkflowDescTxt: Label '';
        PurchDocCategoryTxt: Label 'PURCHDOC';
    BEGIN
        // WorkFlowSetup.InsertWorkflowTemplate(Workflow, AwardNoteApprovalWorkflowCodeTxt, AwardApprWorkflowDescTxt, PurchDocCategoryTxt);
        // InsertAwardNoteApprovalWorkflowDetails(Workflow);
        // WorkFlowSetup.MarkWorkflowAsTemplate(Workflow);
    END;

    LOCAL PROCEDURE InsertAwardNoteApprovalWorkflowDetails(VAR Workflow: Record Workflow)
    VAR
        AwardNote: Record "Confirmed Order";
        WorkflowStepArgument: Record "Workflow Step Argument";
    BEGIN
        /*
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::"Workflow User Group",WorkflowStepArgument."Approver Limit Type"::"Approver Chain",
          0,'',BlankDateFormula,TRUE);

        InsertDocApprovalWorkflowSteps(Workflow,BuildAwardNoteTypeConditionsDTS(0,AwardNote."Workflow Approval Status"::Open,0,'','',FALSE),
          WorkflowEventHandling.RunWorkflowOnSendAwardNoteForApprovalCode,
          BuildAwardNoteTypeConditionsDTS(0,AwardNote."Workflow Approval Status"::"Pending Approval",0,'','',FALSE),
          WorkflowEventHandling.RunWorkflowOnCancelAwardNoteApprovalRequestCode,
          WorkflowStepArgument,TRUE);
          */
    END;

    LOCAL PROCEDURE BuildAwardNoteTypeConditionsDTS(DocumentType: Option; Status: Option; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean): Text
    VAR
        AwardNote: Record "Confirmed Order";
    BEGIN
        /*
        AwardNote.SETRANGE("Workflow Approval Status",Status);
        AwardNote.SETRANGE("Workflow Sub Document Type",SubDocumentType);
        AwardNote.SETRANGE(Initiator,User);
        AwardNote.SETRANGE("Responsibility Center",ResponsibilityCenterCode);  // ALLE ANSH NTPC 280417
        EXIT(STRSUBSTNO(AwardNoteCondnTxt,Encode(AwardNote.GETVIEW(FALSE))));
        */
    END;

    PROCEDURE InsertAwardNoteApprovalWorkflowDTS(VAR Workflow: Record Workflow; DocumentType: Option; ApproverType: Option; LimitType: Option; WorkflowUserGroupCode: Code[20]; DueDateFormula: DateFormula; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean)
    VAR
        AwardNote: Record "Confirmed Order";
        WorkflowStepArgument: Record "Workflow Step Argument";
    BEGIN
        /*
        InsertWorkflow(Workflow,GetWorkflowTemplateCodeDTS(GetWorkflowTemplateCode(AwardNoteApprovalWorkflowCodeTxt)),
          AwardApprWorkflowDescTxt,PurchPayCategoryTxt);

        PopulateWorkflowStepArgument(WorkflowStepArgument,ApproverType,LimitType,0,
          Workflow.Code,DueDateFormula,TRUE);

        InsertDocApprovalWorkflowSteps(Workflow,BuildAwardNoteTypeConditionsDTS(0,AwardNote."Workflow Approval Status"::Open,SubDocumentType,ResponsibilityCenterCode,User,Amendment),
          WorkflowEventHandling.RunWorkflowOnSendAwardNoteForApprovalCode,
          BuildAwardNoteTypeConditionsDTS(0,AwardNote."Workflow Approval Status"::"Pending Approval",SubDocumentType,ResponsibilityCenterCode,User,Amendment),
          WorkflowEventHandling.RunWorkflowOnCancelAwardNoteApprovalRequestCode,
          WorkflowStepArgument,TRUE);
          */
    END;

    LOCAL PROCEDURE "---ALLE AP---"()
    BEGIN
    END;

    PROCEDURE InsertNoteSheetWorkflowTemplate()
    VAR
        Workflow: Record Workflow;
    BEGIN
        /*
        InsertWorkflowTemplate(Workflow,NoteSheetApprovalWorkflowCodeTxt,NoteSheetApprWorkflowDescTxt,PurchDocCategoryTxt);
        InsertNoteSheetApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
        */
    END;

    LOCAL PROCEDURE InsertNoteSheetApprovalWorkflowDetails(VAR Workflow: Record Workflow)
    VAR
        NoteSheet: Record Documentation;
        WorkflowStepArgument: Record "Workflow Step Argument";
    BEGIN
        /*
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::"Workflow User Group",WorkflowStepArgument."Approver Limit Type"::"Approver Chain",
          0,'',BlankDateFormula,TRUE);

        InsertDocApprovalWorkflowSteps(Workflow,BuildNoteSheetTypeConditionsDTS(0,NoteSheet."Workflow Approval Status"::Open,0,'','',FALSE),
          WorkflowEventHandling.RunWorkflowOnSendNoteSheetForApprovalCode,
          BuildNoteSheetTypeConditionsDTS(0,NoteSheet."Workflow Approval Status"::"Pending Approval",0,'','',FALSE),
          WorkflowEventHandling.RunWorkflowOnCancelNoteSheetApprovalRequestCode,
          WorkflowStepArgument,TRUE);
          */
    END;

    LOCAL PROCEDURE BuildNoteSheetTypeConditionsDTS(DocumentType: Option; Status: Option; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean): Text
    VAR
        NoteSheet: Record Documentation;
    BEGIN
        /*
        NoteSheet.SETRANGE("Workflow Approval Status",Status);
        NoteSheet.SETRANGE("Workflow Sub Document Type",SubDocumentType);
        NoteSheet.SETRANGE(Initiator,User);
        EXIT(STRSUBSTNO(NoteSheetCondnTxt,Encode(NoteSheet.GETVIEW(FALSE))));
        */
    END;

    PROCEDURE InsertNoteSheetApprovalWorkflowDTS(VAR Workflow: Record Workflow; DocumentType: Option; ApproverType: Option; LimitType: Option; WorkflowUserGroupCode: Code[20]; DueDateFormula: DateFormula; SubDocumentType: Option; ResponsibilityCenterCode: Code[20]; User: Code[50]; Amendment: Boolean)
    VAR
        NoteSheet: Record Documentation;
        WorkflowStepArgument: Record "Workflow Step Argument";
    BEGIN
        /*
        InsertWorkflow(Workflow,GetWorkflowTemplateCodeDTS(GetWorkflowTemplateCode(NoteSheetApprovalWorkflowCodeTxt)),
          NoteSheetApprWorkflowDescTxt,PurchPayCategoryTxt);

        PopulateWorkflowStepArgument(WorkflowStepArgument,ApproverType,LimitType,0,
          Workflow.Code,DueDateFormula,TRUE);

        InsertDocApprovalWorkflowSteps(Workflow,BuildNoteSheetTypeConditionsDTS(0,NoteSheet."Workflow Approval Status"::Open,SubDocumentType,ResponsibilityCenterCode,User,Amendment),
          WorkflowEventHandling.RunWorkflowOnSendNoteSheetForApprovalCode,
          BuildNoteSheetTypeConditionsDTS(0,NoteSheet."Workflow Approval Status"::"Pending Approval",SubDocumentType,ResponsibilityCenterCode,User,Amendment),
          WorkflowEventHandling.RunWorkflowOnCancelNoteSheetApprovalRequestCode,
          WorkflowStepArgument,TRUE);
          */
    END;

    //======= Codeunit 1502 "Workflow Setup" ========END<<


    //======= Codeunit 1520 "Workflow Event Handling" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", OnAddWorkflowEventsToLibrary, '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary_WorkflowSetup()
    var
        WorkflowEventHeadling: Codeunit "Workflow Event Handling";
        PurchIndentDocSendForApprovalEventDescTxt: Label 'Approval of a purchase indent document is requested.';
        PurchIndentDocApprReqCancelledEventDescTxt: Label 'An approval request for a purchase document is canceled.';
        PurchIndentDocReleasedEventDescTxt: Label 'A purchase document is released.';
        JobSendForApprovalEventDescTxt: Label 'Approval of a job is requested.';
        JobApprReqCancelledEventDescTxt: Label 'An approval request for a job is canceled.';
        JobReleasedEventDescTxt: Label 'A job is released.';
        PurchReceiptDocSendForApprovalEventDescTxt: Label 'Approval of a purchase receipt document is requested.';
        PurchReceiptDocApprReqCancelledEventDescTxt: Label 'An approval request for a purchase receipt document is canceled.';
        PurchReceiptDocReleasedEventDescTxt: Label 'A purchase receipt document is released.';
        TransferOrderDocSendForApprovalEventDescTxt: Label 'Approval of a transfer order document is requested.';
        TransferOrderDocApprReqCancelledEventDescTxt: Label 'An approval request for a transfer order document is canceled.';
        TransferOrderDocReleasedEventDescTxt: Label 'A transfer order document is released.';
        AwardNoteSendForApprovalEventDescTxt: Label 'Approval of a purchase document is requested.';
        AwardNoteDocApprReqCancelledEventDescTxt: Label 'An approval request for a purchase document is canceled.';
        AwardNoteDocReleasedEventDescTxt: Label 'A purchase document is released.';
        NoteSheetSendForApprovalEventDescTxt: Label 'Approval of a purchase document is requested.';
        NoteSheetDocApprReqCancelledEventDescTxt: Label 'An approval request for a purchase document is canceled.';
        NoteSheetDocReleasedEventDescTxt: Label 'Note Sheet is released.';
    begin
        //EPC2016Upgrade
        WorkflowEventHeadling.AddEventToLibrary(RunWorkflowOnSendPurchaseIndentDocForApprovalCode, DATABASE::"Purchase Request Header", PurchIndentDocSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHeadling.AddEventToLibrary(RunWorkflowOnCancelPurchaseIndentApprovalRequestCode, DATABASE::"Purchase Request Header", PurchIndentDocApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHeadling.AddEventToLibrary(RunWorkflowOnAfterReleasePurchaseIndentDocCode, DATABASE::"Purchase Request Header", PurchIndentDocReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHeadling.AddEventToLibrary(RunWorkflowOnSendJobForApprovalCode, DATABASE::Job, JobSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHeadling.AddEventToLibrary(RunWorkflowOnCancelJobApprovalRequestCode, DATABASE::Job, JobApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHeadling.AddEventToLibrary(RunWorkflowOnAfterReleaseJobCode, DATABASE::Job, JobReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHeadling.AddEventToLibrary(RunWorkflowOnSendPurchaseReceiptDocForApprovalCode, DATABASE::"GRN Header", PurchReceiptDocSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHeadling.AddEventToLibrary(RunWorkflowOnCancelPurchaseReceiptApprovalRequestCode, DATABASE::"GRN Header", PurchReceiptDocApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHeadling.AddEventToLibrary(RunWorkflowOnAfterReleasePurchaseReceiptDocCode, DATABASE::"GRN Header", PurchReceiptDocReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHeadling.AddEventToLibrary(RunWorkflowOnSendTransferOrderDocForApprovalCode, DATABASE::"Transfer Header", TransferOrderDocSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHeadling.AddEventToLibrary(RunWorkflowOnCancelTransferOrderApprovalRequestCode, DATABASE::"Transfer Header", TransferOrderDocApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHeadling.AddEventToLibrary(RunWorkflowOnAfterReleaseTransferOrderDocCode, DATABASE::"Transfer Header", TransferOrderDocReleasedEventDescTxt, 0, FALSE);
        /*
          //ALLE TS 17012017
          AddEventToLibrary(RunWorkflowOnSendAwardNoteForApprovalCode,DATABASE::"Award Note",AwardNoteSendForApprovalEventDescTxt,0,FALSE);
          AddEventToLibrary(RunWorkflowOnCancelAwardNoteApprovalRequestCode,DATABASE::"Award Note",AwardNoteDocApprReqCancelledEventDescTxt,0,FALSE);
          AddEventToLibrary(RunWorkflowOnAfterReleaseAwardNoteDocCode,DATABASE::"Award Note",AwardNoteDocReleasedEventDescTxt,0,FALSE);
          //ALLE TS 17012017

          //ALLE AP
          AddEventToLibrary(RunWorkflowOnSendNoteSheetForApprovalCode,DATABASE::"Note Sheet",NoteSheetSendForApprovalEventDescTxt,0,FALSE);
          AddEventToLibrary(RunWorkflowOnCancelNoteSheetApprovalRequestCode,DATABASE::"Note Sheet",NoteSheetDocApprReqCancelledEventDescTxt,0,FALSE);
          AddEventToLibrary(RunWorkflowOnAfterReleaseNoteSheetDocCode,DATABASE::"Note Sheet",NoteSheetDocReleasedEventDescTxt,0,FALSE);
          //ALLE AP
          */
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", OnAddWorkflowEventPredecessorsToLibrary, '', false, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary_WorkflowEventHandling(EventFunctionName: Code[128])
    var
        WorkflowEventHeadling: Codeunit "Workflow Event Handling";
    begin
        //EPC2016Upgrade
        case EventFunctionName of
            RunWorkflowOnCancelPurchaseIndentApprovalRequestCode:
                WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnCancelPurchaseIndentApprovalRequestCode, RunWorkflowOnSendPurchaseIndentDocForApprovalCode);
            RunWorkflowOnCancelJobApprovalRequestCode:
                WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnCancelJobApprovalRequestCode, RunWorkflowOnSendJobForApprovalCode);
            RunWorkflowOnCancelPurchaseReceiptApprovalRequestCode:
                WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnCancelPurchaseReceiptApprovalRequestCode, RunWorkflowOnSendPurchaseReceiptDocForApprovalCode);
            RunWorkflowOnCancelTransferOrderApprovalRequestCode:
                WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnCancelTransferOrderApprovalRequestCode, RunWorkflowOnSendTransferOrderDocForApprovalCode);
            //ALLE TS 17012017
            RunWorkflowOnCancelAwardNoteApprovalRequestCode:
                WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnCancelAwardNoteApprovalRequestCode, RunWorkflowOnSendAwardNoteForApprovalCode);
            //ALLE TS 17012017

            //ALLE AP
            RunWorkflowOnCancelNoteSheetApprovalRequestCode:
                WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnCancelNoteSheetApprovalRequestCode, RunWorkflowOnSendNoteSheetForApprovalCode);
            //ALLE AP
            RunWorkflowOnApproveApprovalRequestCode:
                BEGIN
                    //EPC2016Upgrade
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPurchaseIndentDocForApprovalCode);
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendJobForApprovalCode);
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPurchaseReceiptDocForApprovalCode);
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendTransferOrderDocForApprovalCode);
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendAwardNoteForApprovalCode);//ALLE TS 17012017
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendNoteSheetForApprovalCode);//ALLE AP
                End;
            RunWorkflowOnRejectApprovalRequestCode:
                BEGIN
                    //EPC2016Upgrade
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendJobForApprovalCode);
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPurchaseIndentDocForApprovalCode);
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPurchaseReceiptDocForApprovalCode);
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendTransferOrderDocForApprovalCode);
                End;
            RunWorkflowOnDelegateApprovalRequestCode:
                BEGIN
                    //EPC2016Upgrade
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendJobForApprovalCode);
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPurchaseIndentDocForApprovalCode);
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPurchaseReceiptDocForApprovalCode);
                    WorkflowEventHeadling.AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendTransferOrderDocForApprovalCode);
                End;
        End;
    end;

    procedure RunWorkflowOnDelegateApprovalRequestCode(): Code[128]
    begin
        exit('RUNWORKFLOWONDELEGATEAPPROVALREQUEST');
    end;


    procedure RunWorkflowOnRejectApprovalRequestCode(): Code[128]
    begin
        exit('RUNWORKFLOWONREJECTAPPROVALREQUEST');
    end;


    procedure RunWorkflowOnApproveApprovalRequestCode(): Code[128]
    begin
        exit('RUNWORKFLOWONAPPROVEAPPROVALREQUEST');
    end;



    PROCEDURE RunWorkflowOnCancelPurchaseIndentApprovalRequestCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnCancelPurchaseIndentApprovalRequest'));
    END;

    PROCEDURE RunWorkflowOnAfterReleasePurchaseIndentDocCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnAfterReleasePurchaseIndentDoc'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BBG Codeunit Event Mgnt.", OnSendPurchaseIndentDocForApproval, '', false, false)]
    PROCEDURE RunWorkflowOnSendPurchaseIndentDocForApproval(VAR PurchaseIndentHeader: Record "Purchase Request Header");
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPurchaseIndentDocForApprovalCode, PurchaseIndentHeader);
    END;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BBG Codeunit Event Mgnt.", OnCancelPurchaseIndentApprovalRequest, '', false, false)]
    PROCEDURE RunWorkflowOnCancelPurchaseIndentApprovalRequest(VAR PurchaseIndentHeader: Record "Purchase Request Header");
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPurchaseIndentApprovalRequestCode, PurchaseIndentHeader);
    END;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::97730, OnAfterReleasePurchaseDoc, '', false, false)]
    // PROCEDURE RunWorkflowOnAfterReleasePurchaseIndentDoc@1000000004(VAR PurchaseIndentHeader: Record "Purchase Request Header")
    // BEGIN
    //     WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleasePurchaseIndentDocCode, PurchaseIndentHeader);
    // END;



    PROCEDURE RunWorkflowOnCancelJobApprovalRequestCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnCancelJobApprovalRequest'));
    END;

    PROCEDURE RunWorkflowOnAfterReleaseJobCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseJob'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BBG Codeunit Event Mgnt.", OnSendJobForApproval, '', false, false)]
    PROCEDURE RunWorkflowOnSendJobForApproval(VAR Job: Record Job);
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnSendJobForApprovalCode, Job);
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BBG Codeunit Event Mgnt.", OnCancelJobApprovalRequest, '', false, false)]
    PROCEDURE RunWorkflowOnCancelJobApprovalRequest(VAR Job: Record Job);
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelJobApprovalRequestCode, Job);
    END;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bonus Correction", OnAfterReleaseJob, '', false, false)]
    // PROCEDURE RunWorkflowOnAfterReleaseJob(VAR Job: Record Job);
    // BEGIN
    //     WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseJobCode, Job);
    // END;



    PROCEDURE RunWorkflowOnCancelPurchaseReceiptApprovalRequestCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnCancelPurchaseReceiptApprovalRequest'));
    END;

    PROCEDURE RunWorkflowOnAfterReleasePurchaseReceiptDocCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnAfterReleasePurchaseReceiptDoc'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BBG Codeunit Event Mgnt.", OnSendPurchaseReceiptDocForApproval, '', false, false)]
    PROCEDURE RunWorkflowOnSendPurchaseReceiptDocForApproval(VAR GoodsReceiptHeader: Record "GRN Header");
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPurchaseReceiptDocForApprovalCode, GoodsReceiptHeader);
    END;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BBG Codeunit Event Mgnt.", OnCancelPurchaseReceiptApprovalRequest, '', false, false)]
    PROCEDURE RunWorkflowOnCancelPurchaseReceiptApprovalRequest(VAR GoodsReceiptHeader: Record "GRN Header")
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPurchaseReceiptApprovalRequestCode, GoodsReceiptHeader);
    END;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Amount To Words", OnAfterReleasePurchaseDoc, '', false, false)]
    // PROCEDURE RunWorkflowOnAfterReleasePurchaseReceiptDoc(VAR GoodsReceiptHeader: Record "GRN Header");
    // BEGIN
    //     WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleasePurchaseReceiptDocCode, GoodsReceiptHeader);
    // END;

    PROCEDURE RunWorkflowOnSendTransferOrderDocForApprovalCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnSendTransferOrderDocForApproval'));
    END;

    PROCEDURE RunWorkflowOnCancelTransferOrderApprovalRequestCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnCancelTransferOrderApprovalRequest'));
    END;

    PROCEDURE RunWorkflowOnAfterReleaseTransferOrderDocCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseTransferOrderDoc'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BBG Codeunit Event Mgnt.", OnSendTransferOrderDocForApproval, '', false, false)]
    PROCEDURE RunWorkflowOnSendTransferOrderDocForApproval(VAR TransferHeader: Record "Transfer Header");
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnSendTransferOrderDocForApprovalCode, TransferHeader);
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BBG Codeunit Event Mgnt.", OnCancelTransferOrderApprovalRequest, '', false, false)]
    PROCEDURE RunWorkflowOnCancelTransferOrderApprovalRequest(VAR TransferHeader: Record "Transfer Header");
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelTransferOrderApprovalRequestCode, TransferHeader);
    END;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Transfer Document", OnCancelTransferOrderApprovalRequest, '', false, false)]
    // PROCEDURE RunWorkflowOnAfterReleaseTransferOrderDoc(VAR TransferHeader: Record "Transfer Header");
    // var
    // BEGIN
    //     WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseTransferOrderDocCode, TransferHeader);
    // END;

    PROCEDURE RunWorkflowOnSendAwardNoteForApprovalCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnSendAwardNoteForApproval'));
    END;

    PROCEDURE RunWorkflowOnCancelAwardNoteApprovalRequestCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnCancelAwardNoteApprovalRequest'));
    END;

    PROCEDURE RunWorkflowOnAfterReleaseAwardNoteDocCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseAwardNoteDoc'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BBG Codeunit Event Mgnt.", OnSendAwardForApproval, '', false, false)]
    PROCEDURE RunWorkflowOnSendAwardNoteDocForApproval(VAR AwardNote: Record "Confirmed Order");
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnSendAwardNoteForApprovalCode, AwardNote);
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BBG Codeunit Event Mgnt.", OnCancelAwardApprovalRequest, '', false, false)]
    PROCEDURE RunWorkflowOnCancelAwardNoteApprovalRequest(VAR AwardNote: Record "Confirmed Order");
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelAwardNoteApprovalRequestCode, AwardNote);
    END;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"97733", OnAfterReleaseAward, '', false, false)]
    // PROCEDURE RunWorkflowOnAfterReleaseAwardNoteDoc(VAR AwardNote: Record "Confirmed Order");
    // BEGIN
    //     WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseAwardNoteDocCode, AwardNote);
    // END;

    PROCEDURE RunWorkflowOnSendNoteSheetForApprovalCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnSendNoteSheetForApproval'));
    END;

    PROCEDURE RunWorkflowOnCancelNoteSheetApprovalRequestCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnCancelNoteSheetApprovalRequest'));
    END;

    PROCEDURE RunWorkflowOnAfterReleaseNoteSheetDocCode(): Code[128];
    BEGIN
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseNoteSheetDoc'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BBG Codeunit Event Mgnt.", OnSendAwardForApproval2, '', false, false)]
    PROCEDURE RunWorkflowOnSendNoteSheetDocForApproval(VAR AwardNote: Record Documentation);
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnSendNoteSheetForApprovalCode, AwardNote);
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"BBG Codeunit Event Mgnt.", OnCancelAwardApprovalRequest2, '', false, false)]
    PROCEDURE RunWorkflowOnCancelNoteSheetApprovalRequest(VAR AwardNote: Record Documentation);
    BEGIN
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelNoteSheetApprovalRequestCode, AwardNote);
    END;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"97741", OnAfterReleaseAward, '', false, false)]
    // PROCEDURE RunWorkflowOnAfterReleaseNoteSheetDoc(VAR AwardNote: Record Documentation);
    // BEGIN
    //     WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseNoteSheetDocCode, AwardNote);
    // END;

    //======= Codeunit 1520 "Workflow Event Handling" ========END<<

    //======= Codeunit 1521 "Workflow Response Handling" ========Start>>

    PROCEDURE SetStatusToPendingApprovalCode(): Code[128]
    BEGIN
        EXIT(UPPERCASE('SetStatusToPendingApproval'));
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", OnAddWorkflowResponsePredecessorsToLibrary, '', false, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary_WorkflowResponseHandling(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHeadling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "BBG Codeunit Event Mgnt.";

    begin
        CASE ResponseFunctionName OF
            WorkflowResponseHeadling.SetStatusToPendingApprovalCode:
                BEGIN
                    //EPC2016Upgrade
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendJobForApprovalCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendPurchaseIndentDocForApprovalCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendJobForApprovalCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendPurchaseReceiptDocForApprovalCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendTransferOrderDocForApprovalCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.SetStatusToPendingApprovalCode, WorkflowEventHandling.RunWorkflowOnSendAwardNoteForApprovalCode);//ALLE TS
                end;
            WorkflowResponseHeadling.CreateApprovalRequestsCode:
                BEGIN
                    //EPC2016Upgrade
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.CreateApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnSendJobForApprovalCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.CreateApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnSendPurchaseIndentDocForApprovalCode);
                    //  AddResponsePredecessor(CreateApprovalRequestsCode,WorkflowEventHandling.RunWorkflowOnSendJobForApprovalCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.CreateApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnSendPurchaseReceiptDocForApprovalCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.CreateApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnSendTransferOrderDocForApprovalCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.CreateApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnSendAwardNoteForApprovalCode);//ALLE TS
                End;
            WorkflowResponseHeadling.SendApprovalRequestForApprovalCode:
                BEGIN
                    //EPC2016Upgrade
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendJobForApprovalCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendPurchaseIndentDocForApprovalCode);
                    //AddResponsePredecessor(SendApprovalRequestForApprovalCode,WorkflowEventHandling.RunWorkflowOnSendJobForApprovalCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendPurchaseReceiptDocForApprovalCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendTransferOrderDocForApprovalCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.SendApprovalRequestForApprovalCode, WorkflowEventHandling.RunWorkflowOnSendAwardNoteForApprovalCode);//ALLE TS
                End;
            WorkflowResponseHeadling.OpenDocumentCode:
                BEGIN
                    //EPC2016Upgrade
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelJobApprovalRequestCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelPurchaseIndentApprovalRequestCode);
                    // AddResponsePredecessor(OpenDocumentCode,WorkflowEventHandling.RunWorkflowOnCancelJobApprovalRequestCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelPurchaseReceiptApprovalRequestCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelTransferOrderApprovalRequestCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.OpenDocumentCode, WorkflowEventHandling.RunWorkflowOnCancelAwardNoteApprovalRequestCode);//ALLE TS

                End;

            WorkflowResponseHeadling.CancelAllApprovalRequestsCode:
                BEGIN
                    //EPC2016Upgrade
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelJobApprovalRequestCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelPurchaseIndentApprovalRequestCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelPurchaseReceiptApprovalRequestCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelTransferOrderApprovalRequestCode);
                    WorkflowResponseHeadling.AddResponsePredecessor(WorkflowResponseHeadling.CancelAllApprovalRequestsCode, WorkflowEventHandling.RunWorkflowOnCancelAwardNoteApprovalRequestCode);//ALLE TS
                End;
        End;
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", OnReleaseDocument, '', false, false)]
    local procedure OnReleaseDocument_WorkflowResponseHandling(RecRef: RecordRef; var Handled: Boolean)
    var
        ReleasePurchaseIndentDocument: Codeunit "Release Purch. Indent Document";
        ReleaseJob: Codeunit "Release Job";
        ReleasePurchaseReceiptDocument: Codeunit "Release Goods Receipt";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        Variant: Variant;
    begin
        Variant := RecRef;
        CASE RecRef.NUMBER OF
            //EPC2016Upgrade
            DATABASE::"Purchase Request Header":
                ReleasePurchaseIndentDocument.PerformManualRelease(Variant);
            DATABASE::Job:
                ReleaseJob.PerformManualRelease(Variant);
            DATABASE::"GRN Header":
                begin
                    ReleasePurchaseReceiptDocument.PerformManualRelease(Variant);
                    Handled := true;
                end;

            DATABASE::"Transfer Header":
                ReleaseTransferDocument.RUN(Variant);
        End;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", OnOpenDocument, '', false, false)]
    local procedure OnOpenDocument_WorkflowResponseHandling(RecRef: RecordRef; var Handled: Boolean)
    var
        ReleasePurchaseIndentDocument: Codeunit "Release Purch. Indent Document";
        ReleaseJob: Codeunit "Release Job";
        ReleasePurchaseReceiptDocument: Codeunit "Release Goods Receipt";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        Varient: Variant;
    Begin
        Varient := RecRef;
        CASE RecRef.NUMBER OF
            //EPC2016Upgrade
            // DATABASE::"Purchase Request Header":
            //     ReleasePurchaseIndentDocument.Reopen(Variant);
            // DATABASE::Job:
            //     ReleaseJob.Reopen(Variant);
            DATABASE::"GRN Header":
                begin
                    ReleasePurchaseReceiptDocument.Reopen(Varient);
                    Handled := true;
                end;

        // DATABASE::"Transfer Header":
        //     ReleaseTransferDocument.Reopen(Variant);
        //ALLE TS 19012017
        End;

    End;

    //======= Codeunit 1521 "Workflow Response Handling" ========END<<

    //======= Codeunit 1522 "Workflow Request Page Handling" ========Start>>

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Request Page Handling", OnAfterAssignEntitiesToWorkflowEvents, '', false, false)]
    local procedure OnAfterAssignEntitiesToWorkflowEvents_WorkflowResponseHandling()
    var
        WorkFlowRequestPageHeadling: Codeunit "Workflow Request Page Handling";
        PurchaseDocumentCodeTxt: Label 'PURCHDOC';
        SalesDocumentCodeTxt: Label 'SALESDOC';
        InventoryDocumentCodeTxt: Label 'INVTDOC';

    Begin
        //EPC2016Upgrade
        WorkFlowRequestPageHeadling.AssignEntityToWorkflowEvent(DATABASE::"Purchase Request Header", PurchaseDocumentCodeTxt);
        WorkFlowRequestPageHeadling.AssignEntityToWorkflowEvent(DATABASE::Job, SalesDocumentCodeTxt);
        WorkFlowRequestPageHeadling.AssignEntityToWorkflowEvent(DATABASE::"GRN Header", PurchaseDocumentCodeTxt);
        WorkFlowRequestPageHeadling.AssignEntityToWorkflowEvent(DATABASE::"Transfer Header", InventoryDocumentCodeTxt);
        //AssignEntityToWorkflowEvent(DATABASE::"Award Note",PurchaseDocumentCodeTxt);//ALLE TS

    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Request Page Handling", OnAfterInsertRequestPageEntities, '', false, false)]
    local procedure OnAfterInsertRequestPageEntities_WorkflowResponseHandling()
    var
        WorkFlowRequestPageHeadling: Codeunit "Workflow Request Page Handling";
        PurchaseDocumentCodeTxt: Label 'PURCHDOC';
        SalesDocumentCodeTxt: Label 'SALESDOC';
        InventoryDocumentCodeTxt: Label 'INVTDOC';
        PurchaseDocumentDescTxt: Label 'Purchase Document';
        SalesDocumentDescTxt: Label 'Sales Document';
        InventoryDocumentDescTxt: Label 'Purchase Document';
    Begin
        //EPC2016Upgrade
        WorkFlowRequestPageHeadling.InsertReqPageEntity(
          PurchaseDocumentCodeTxt, PurchaseDocumentDescTxt, DATABASE::"Purchase Request Header", DATABASE::"Purchase Request Line");
        //InsertReqPageEntity(
        //  SalesDocumentCodeTxt,SalesDocumentDescTxt,DATABASE::Job,0);
        WorkFlowRequestPageHeadling.InsertReqPageEntity(
          PurchaseDocumentCodeTxt, PurchaseDocumentDescTxt, DATABASE::"GRN Header", DATABASE::"GRN Line");
        WorkFlowRequestPageHeadling.InsertReqPageEntity(
          InventoryDocumentCodeTxt, InventoryDocumentDescTxt, DATABASE::"Transfer Header", DATABASE::"Transfer Line");
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Request Page Handling", OnAfterInsertRequestPageFields, '', false, false)]
    local procedure OnAfterInsertRequestPageFields_WorkflowResponseHandling()
    var
        WorkFlowRequestPageHeadling: Codeunit "Workflow Request Page Handling";
    Begin

        //EPC2016Upgrade
        InsertPurchaseIndentHeaderReqPageFields;
        InsertPurchaseIndentLineReqPageFields;
        //InsertJobReqPageFields;
        InsertPurchaseReceiptHeaderReqPageFields;
        InsertPurchaseReceiptLineReqPageFields;
        InsertTransferOrderHeaderReqPageFields;
        InsertTransferOrderLineReqPageFields;
    End;

    LOCAL PROCEDURE InsertPurchaseIndentHeaderReqPageFields()
    VAR
        WorkFlowRequestPageHeadling: Codeunit "Workflow Request Page Handling";
        PurchaseIndentHeader: Record "Purchase Request Header";
    BEGIN
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"Purchase Request Header", PurchaseIndentHeader.FIELDNO("Location code"));
        //InsertDynReqPageField(DATABASE::"Purchase Request Header",PurchaseIndentHeader.FIELDNO("Job No."));
        //InsertDynReqPageField(DATABASE::"Purchase Request Header",PurchaseIndentHeader.FIELDNO("Job Task No."));
        //InsertDynReqPageField(DATABASE::"Indent Header",PurchaseIndentHeader.FIELDNO("Indent Type Code"));
    END;

    LOCAL PROCEDURE InsertPurchaseIndentLineReqPageFields()
    VAR
        PurchaseIndentLine: Record "Purchase Request Line";
        WorkFlowRequestPageHeadling: Codeunit "Workflow Request Page Handling";
    BEGIN
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"Purchase Request Line", PurchaseIndentLine.FIELDNO(Type));
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"Purchase Request Line", PurchaseIndentLine.FIELDNO("No."));
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"Purchase Request Line", PurchaseIndentLine.FIELDNO("Indented Quantity"));
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"Purchase Request Line", PurchaseIndentLine.FIELDNO("Direct Unit Cost"));
    END;

    LOCAL PROCEDURE InsertJobReqPageFields()
    VAR
        Job: Record Job;
    BEGIN
        //InsertDynReqPageField(DATABASE::Job,Job.FIELDNO("Location Code"));
    END;

    LOCAL PROCEDURE InsertPurchaseReceiptHeaderReqPageFields()
    VAR
        GoodsReceiptHeader: Record "GRN Header";
        WorkFlowRequestPageHeadling: Codeunit "Workflow Request Page Handling";
    BEGIN
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"GRN Header", GoodsReceiptHeader.FIELDNO("Location Code"));
        //InsertDynReqPageField(DATABASE::"GRN Header",GoodsReceiptHeader.FIELDNO("Job No."));
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"GRN Header", GoodsReceiptHeader.FIELDNO("Purchase Order No."));
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"GRN Header", GoodsReceiptHeader.FIELDNO("Responsibility Center"));
    END;

    LOCAL PROCEDURE InsertPurchaseReceiptLineReqPageFields()
    VAR
        GoodsReceiptLine: Record "GRN Line";
        WorkFlowRequestPageHeadling: Codeunit "Workflow Request Page Handling";
    BEGIN
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"GRN Line", GoodsReceiptLine.FIELDNO(Type));
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"GRN Line", GoodsReceiptLine.FIELDNO("No."));
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"GRN Line", GoodsReceiptLine.FIELDNO("Accepted Qty"));
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"GRN Line", GoodsReceiptLine.FIELDNO("Direct Unit Cost"));
    END;

    LOCAL PROCEDURE InsertTransferOrderHeaderReqPageFields()
    VAR
        TransferHeader: Record "Transfer Header";
        WorkFlowRequestPageHeadling: Codeunit "Workflow Request Page Handling";
    BEGIN
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"Transfer Header", TransferHeader.FIELDNO("Transfer-from Code"));
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"Transfer Header", TransferHeader.FIELDNO("Transfer-to Code"));
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"Transfer Header", TransferHeader.FIELDNO("Responsibility Center"));
        //InsertDynReqPageField(DATABASE::"Transfer Header",TransferHeader.FIELDNO("Currency Code"));
    END;

    LOCAL PROCEDURE InsertTransferOrderLineReqPageFields()
    VAR
        TransferLine: Record "Transfer Line";
        WorkFlowRequestPageHeadling: Codeunit "Workflow Request Page Handling";
    BEGIN
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"Transfer Line", TransferLine.FIELDNO("Item No."));
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"Transfer Line", TransferLine.FIELDNO(Quantity));
        WorkFlowRequestPageHeadling.InsertDynReqPageField(DATABASE::"Transfer Line", TransferLine.FIELDNO("Transfer Price"));
    END;


    //======= Codeunit 1522 "Workflow Request Page Handling" ========END<<

    //======= Codeunit 1535 "Approvals Mgmt." ========Start>>


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforeCreateApprReqForApprTypeWorkflowUserGroup, '', false, false)]
    local procedure OnBeforeCreateApprReqForApprTypeWorkflowUserGroup_ApprovalsMgmt(ApprovalEntry: Record "Approval Entry"; sender: Codeunit "Approvals Mgmt."; SequenceNo: Integer; var IsHandled: Boolean; var WorkflowUserGroupMember: Record "Workflow User Group Member"; WorkflowStepArgument: Record "Workflow Step Argument")
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[50];
        WorkflowUserGroup: Record "Workflow User Group";
        AlternateApproval: Code[50];
        Approvalsmgmts: Codeunit "Approvals Mgmt.";
        NoWFUserGroupMembersErr: Label 'A workflow user group with at least one member must be set up.';
        NoSuitableApproverFoundErr: Label 'No qualified approver was found.';
        WFUserGroupNotInSetupErr: Label 'The workflow user group member with user ID %1 does not exist in the Approval User Setup window.', Comment = 'The workflow user group member with user ID NAVUser does not exist in the Approval User Setup window.';

    Begin

        IsHandled := TRUE;

        AlternateApproval := '';  //ALLE ANSH
        SequenceNo := Approvalsmgmts.GetLastSequenceNo(ApprovalEntry);

        WorkflowUserGroupMember.SETCURRENTKEY("Workflow User Group Code", "Sequence No.");
        WorkflowUserGroupMember.SETRANGE("Workflow User Group Code", WorkflowStepArgument."Workflow User Group Code");

        IF NOT WorkflowUserGroupMember.FINDSET THEN
            ERROR(NoWFUserGroupMembersErr);
        //EPC2016Upgrade
        WorkflowUserGroup.GET(WorkflowStepArgument."Workflow User Group Code");
        WorkflowUserGroup.CALCFIELDS(WorkflowUserGroup."Approval Limit Exists");
        IF WorkflowUserGroup."Approval Limit Exists" = 0 THEN BEGIN
            REPEAT
                ApproverId := WorkflowUserGroupMember."User Name";
                //AlternateApproval := WorkflowUserGroupMember."Alternate Approval Code";  // ALLE ANSH
                //EPC2016Upgrade
                IF ApproverId = '' THEN
                    ERROR(NoSuitableApproverFoundErr);
                IF NOT UserSetup.GET(ApproverId) THEN
                    ERROR(WFUserGroupNotInSetupErr, ApproverId);
                MakeApprovalEntry(ApprovalEntry, SequenceNo + WorkflowUserGroupMember."Sequence No.", ApproverId, WorkflowStepArgument, AlternateApproval);
            UNTIL WorkflowUserGroupMember.NEXT = 0;
        END ELSE BEGIN
            //Workflow User Group with Approval Limit
            REPEAT
                ApproverId := WorkflowUserGroupMember."User Name";
                //AlternateApproval := WorkflowUserGroupMember."Alternate Approval Code";  // ALLE ANSH
                //EPC2016Upgrade
                IF ApproverId = '' THEN
                    ERROR(NoSuitableApproverFoundErr);

                IF NOT UserSetup.GET(ApproverId) THEN
                    ERROR(WFUserGroupNotInSetupErr, ApproverId);
                MakeApprovalEntry(ApprovalEntry, SequenceNo + WorkflowUserGroupMember."Sequence No.", ApproverId, WorkflowStepArgument, AlternateApproval);
            UNTIL (IsSufficientApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntry)) OR (WorkflowUserGroupMember.NEXT = 0);
        END;
    end;

    local procedure MakeApprovalEntry(ApprovalEntryArgument: Record "Approval Entry"; SequenceNo: Integer; ApproverId: Code[50]; WorkflowStepArgument: Record "Workflow Step Argument"; AlterNateApproval: Code[50])
    var
        ApprovalEntry: Record "Approval Entry";
        SalesHdr_1: Record "Sales Header";
        PurchHdr_1: Record "Purchase Header";
        //GRNHdr_1: Record "GRN Header";
        //IndentHdr_1: Record "Indent Header";
        THdr_1: Record "Transfer Header";
    begin
        ApprovalEntry."Table ID" := ApprovalEntryArgument."Table ID";
        ApprovalEntry."Document Type" := ApprovalEntryArgument."Document Type";
        ApprovalEntry."Document No." := ApprovalEntryArgument."Document No.";
        ApprovalEntry."Salespers./Purch. Code" := ApprovalEntryArgument."Salespers./Purch. Code";
        ApprovalEntry."Sequence No." := SequenceNo;
        ApprovalEntry."Sender ID" := USERID;
        ApprovalEntry.Amount := ApprovalEntryArgument.Amount;
        ApprovalEntry."Amount (LCY)" := ApprovalEntryArgument."Amount (LCY)";
        ApprovalEntry."Currency Code" := ApprovalEntryArgument."Currency Code";
        ApprovalEntry."Approver ID" := ApproverId;
        ApprovalEntry."Workflow Step Instance ID" := ApprovalEntryArgument."Workflow Step Instance ID";
        IF ApproverId = USERID THEN
            ApprovalEntry.Status := ApprovalEntry.Status::Approved
        ELSE
            ApprovalEntry.Status := ApprovalEntry.Status::Created;
        ApprovalEntry."Date-Time Sent for Approval" := CREATEDATETIME(TODAY, TIME);
        ApprovalEntry."Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
        ApprovalEntry."Last Modified By User ID" := USERID;
        ApprovalEntry."Due Date" := CALCDATE(WorkflowStepArgument."Due Date Formula", TODAY);

        CASE WorkflowStepArgument."Delegate After" OF
            WorkflowStepArgument."Delegate After"::Never:
                EVALUATE(ApprovalEntry."Delegation Date Formula", '');
            WorkflowStepArgument."Delegate After"::"1 day":
                EVALUATE(ApprovalEntry."Delegation Date Formula", '<1D>');
            WorkflowStepArgument."Delegate After"::"2 days":
                EVALUATE(ApprovalEntry."Delegation Date Formula", '<2D>');
            WorkflowStepArgument."Delegate After"::"5 days":
                EVALUATE(ApprovalEntry."Delegation Date Formula", '<5D>');
            ELSE
                EVALUATE(ApprovalEntry."Delegation Date Formula", '');
        END;
        ApprovalEntry."Available Credit Limit (LCY)" := ApprovalEntryArgument."Available Credit Limit (LCY)";
        SetApproverType(WorkflowStepArgument, ApprovalEntry);
        SetLimitType(WorkflowStepArgument, ApprovalEntry);
        ApprovalEntry."Record ID to Approve" := ApprovalEntryArgument."Record ID to Approve";
        ApprovalEntry."Approval Code" := ApprovalEntryArgument."Approval Code";
        ApprovalEntry.INSERT(TRUE);
    end;

    local procedure SetApproverType(WorkflowStepArgument: Record "Workflow Step Argument"; var ApprovalEntry: Record "Approval Entry")
    begin
        CASE WorkflowStepArgument."Approver Type" OF
            WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser":
                ApprovalEntry."Approval Type" := ApprovalEntry."Approval Type"::"Sales Pers./Purchaser";
            WorkflowStepArgument."Approver Type"::Approver:
                ApprovalEntry."Approval Type" := ApprovalEntry."Approval Type"::Approver;
            WorkflowStepArgument."Approver Type"::"Workflow User Group":
                ApprovalEntry."Approval Type" := ApprovalEntry."Approval Type"::"Workflow User Group";
        END;
    end;

    local procedure SetLimitType(WorkflowStepArgument: Record "Workflow Step Argument"; var ApprovalEntry: Record "Approval Entry")
    begin
        CASE WorkflowStepArgument."Approver Limit Type" OF
            WorkflowStepArgument."Approver Limit Type"::"Approver Chain",
          WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver":
                ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"Approval Limits";
            WorkflowStepArgument."Approver Limit Type"::"Direct Approver":
                ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"No Limits";
        END;

        IF ApprovalEntry."Approval Type" = ApprovalEntry."Approval Type"::"Workflow User Group" THEN
            ApprovalEntry."Limit Type" := ApprovalEntry."Limit Type"::"No Limits";
    end;


    procedure IsSufficientApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; ApprovalEntryArgument: Record "Approval Entry"): Boolean
    var
        ApporvalChainIsUnsupportedMsg: Label 'Only Direct Approver is supported as Approver Limit Type option for %1. The approval request will be approved automatically.', Comment = 'Only Direct Approver is supported as Approver Limit Type option for Gen. Journal Batch DEFAULT, CASH. The approval request will be approved automatically.';
    begin
        CASE ApprovalEntryArgument."Table ID" OF

            DATABASE::"Purchase Header":
                EXIT(IsSufficientPurchApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type".AsInteger(), ApprovalEntryArgument."Amount (LCY)"));
            DATABASE::"Sales Header":
                EXIT(IsSufficientSalesApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Amount (LCY)"));
            DATABASE::"Gen. Journal Batch":
                MESSAGE(ApporvalChainIsUnsupportedMsg, FORMAT(ApprovalEntryArgument."Record ID to Approve"));
            DATABASE::"Gen. Journal Line":
                EXIT(IsSufficientGenJournalLineApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument));
            DATABASE::"Purchase Request Header":
                EXIT(IsSufficientPurchIndentApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type".AsInteger(), ApprovalEntryArgument."Amount (LCY)"));
            DATABASE::Job:
                EXIT(IsSufficientJobApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type".AsInteger(), ApprovalEntryArgument."Amount (LCY)"));
            DATABASE::"GRN Header":
                EXIT(IsSufficientPurchReceiptApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type".AsInteger(), ApprovalEntryArgument."Amount (LCY)"));
            DATABASE::"Transfer Header":
                EXIT(IsSufficientTransferOrderApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type".AsInteger(), ApprovalEntryArgument."Amount (LCY)"));
        //ALLE TS 19012017
        // DATABASE::Table97793:
        //     EXIT(IsSufficientAwardApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type".AsInteger(), ApprovalEntryArgument."Amount (LCY)"));
        // //ALLE TS 19012017
        // //ALLE AP
        // DATABASE::Table97792:
        //     EXIT(IsSufficientAwardApproverInUserGroup2(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type".AsInteger(), ApprovalEntryArgument."Amount (LCY)"));
        //ALLE AP
        END;

        EXIT(TRUE);
    end;

    local procedure IsSufficientTransferOrderApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    var
        TransferHeader: Record "Transfer Header";
    begin
        //CASE DocumentType OF
        //  GoodsReceiptHeader."Document Type"::GRN:
        IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
        THEN
            EXIT(TRUE);
        //END;

        EXIT(FALSE);
    end;


    local procedure IsSufficientPurchReceiptApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    var
        GoodsReceiptHeader: Record "GRN Header";
    begin
        CASE DocumentType OF
            GoodsReceiptHeader."Document Type"::GRN:
                IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
                THEN
                    EXIT(TRUE);
        END;

        EXIT(FALSE);
    end;


    local procedure IsSufficientJobApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    var
        Job: Record "Job";
    begin
        //CASE DocumentType OF
        //Job."Document Type"::Order:
        IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
        THEN
            EXIT(TRUE);
        //END;

        EXIT(FALSE);
    end;


    // local procedure IsSufficientPurchIndentApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    // var
    //     PurchaseIndentHeader: Record "Purchase Request Header";
    // begin
    //     CASE DocumentType OF
    //         PurchaseIndentHeader."Document Type"::Indent:
    //             IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
    //             THEN
    //                 EXIT(TRUE);
    //     END;

    //     EXIT(FALSE);
    // end;


    local procedure IsSufficientPurchApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        //IF UserSetup."User ID" = UserSetup."Approver ID" THEN
        //  EXIT(TRUE);

        CASE DocumentType OF
            PurchaseHeader."Document Type"::Quote.AsInteger():
                IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
                THEN
                    EXIT(TRUE);
            ELSE
                IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
                THEN
                    EXIT(TRUE);
        END;

        EXIT(FALSE);
    end;

    local procedure IsSufficientSalesApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; ApprovalAmountLCY: Decimal): Boolean
    begin
        //IF UserSetup."User ID" = UserSetup."Approver ID" THEN
        //  EXIT(TRUE);

        IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
        THEN
            EXIT(TRUE);

        EXIT(FALSE);
    end;

    local procedure IsSufficientGenJournalLineApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; ApprovalEntryArgument: Record "Approval Entry"): Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
        RecRef: RecordRef;
    begin
        RecRef.GET(ApprovalEntryArgument."Record ID to Approve");
        RecRef.SETTABLE(GenJournalLine);

        IF GenJournalLine.IsForPurchase THEN
            EXIT(IsSufficientPurchApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type".AsInteger(), ApprovalEntryArgument."Amount (LCY)"));

        IF GenJournalLine.IsForSales THEN
            EXIT(IsSufficientSalesApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Amount (LCY)"));

        EXIT(TRUE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnPopulateApprovalEntryArgument, '', false, false)]
    local procedure OnPopulateApprovalEntryArgument_ApprovalsMgmt(var ApprovalEntryArgument: Record "Approval Entry"; var RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        PurchaseIndentHeader: Record "Purchase Request Header";
        Job: Record Job;
        GoodsReceiptHeader: Record "GRN Header";
        TransferHeader: Record "Transfer Header";
        AwardNote: Record "Confirmed Order";
        NoteSheet: Record Documentation;
        TempPurchaseHeader: Record "Purchase Header";
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
    Begin
        CASE RecRef.NUMBER OF
            //EPC2016Upgrade
            DATABASE::"Purchase Request Header":
                BEGIN
                    RecRef.SETTABLE(PurchaseIndentHeader);
                    CalcPurchaseIndentDocAmount(PurchaseIndentHeader, ApprovalAmount, ApprovalAmountLCY);
                    ApprovalEntryArgument."Document Type" := PurchaseIndentHeader."Document Type";
                    ApprovalEntryArgument."Document No." := PurchaseIndentHeader."Document No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := PurchaseIndentHeader."Purchaser Code";
                    ApprovalEntryArgument.Amount := ApprovalAmount;
                    ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    //ApprovalEntryArgument."Currency Code" := PurchaseIndentHeader."Currency Code";
                END;
            DATABASE::Job:
                BEGIN
                    RecRef.SETTABLE(Job);
                    CalcJobAmount(Job, ApprovalAmount, ApprovalAmountLCY);
                    //ApprovalEntryArgument."Document Type" := Job."Document Type";
                    ApprovalEntryArgument."Document No." := Job."No.";
                    //ApprovalEntryArgument."Salespers./Purch. Code" := Job."Purchaser Code";
                    ApprovalEntryArgument.Amount := ApprovalAmount;
                    ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    ApprovalEntryArgument."Currency Code" := Job."Currency Code";
                END;
            DATABASE::"GRN Header":
                BEGIN
                    RecRef.SETTABLE(GoodsReceiptHeader);
                    CalcPurchaseReceiptDocAmount(GoodsReceiptHeader, ApprovalAmount, ApprovalAmountLCY);
                    ApprovalEntryArgument."Document Type" := GoodsReceiptHeader."Document Type";
                    ApprovalEntryArgument."Document No." := GoodsReceiptHeader."GRN No.";
                    ApprovalEntryArgument.Amount := ApprovalAmount;
                    ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                END;
            DATABASE::"Transfer Header":
                BEGIN
                    RecRef.SETTABLE(TransferHeader);
                    CalcTransferOrderDocAmount(TransferHeader, ApprovalAmount, ApprovalAmountLCY);
                    //ApprovalEntryArgument."Document Type" := TransferHeader."Document Type";
                    ApprovalEntryArgument."Document No." := TransferHeader."No.";
                    ApprovalEntryArgument.Amount := ApprovalAmount;
                    ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                END;
        //ALLE TS 18012017
        /*
        DATABASE::"Award Note":
          BEGIN
            RecRef.SETTABLE(AwardNote);
            //ALLE ANSH NTPC START 250517
            CLEAR(TempPurchaseHeader);
            TempPurchaseHeader.RESET;
            TempPurchaseHeader.SETRANGE("Document Type",TempPurchaseHeader."Document Type"::Quote);
            TempPurchaseHeader.SETRANGE("No.",AwardNote."Selected Quotation");
            TempPurchaseHeader.SETRANGE("Quote Converted to Order",FALSE);
            IF TempPurchaseHeader.FINDFIRST THEN BEGIN
              CalcPurchaseDocAmountforAward(TempPurchaseHeader,ApprovalAmount,ApprovalAmountLCY);
            END ELSE BEGIN
             CLEAR(TempPurchaseHeader);
             TempPurchaseHeader.RESET;
             TempPurchaseHeader.SETRANGE("Document Type",TempPurchaseHeader."Document Type"::Order);
             TempPurchaseHeader.SETRANGE("Quote No.",AwardNote."Selected Quotation");
             IF TempPurchaseHeader.FINDFIRST THEN BEGIN
               CalcPurchaseDocAmountforAward(TempPurchaseHeader,ApprovalAmount,ApprovalAmountLCY);
             END;
            END;
           //ALLE ANSH  NTPC END 250517
            ApprovalEntryArgument."Document No." := AwardNote."Document No.";
            ApprovalEntryArgument.Amount := ApprovalAmount;
            ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
          END;
        //ALLE TS 18012017
        //ALLE AP
        DATABASE::"Note Sheet":
          BEGIN
            RecRef.SETTABLE(NoteSheet);
            ApprovalEntryArgument."Document No." := NoteSheet."Document No.";
            ApprovalEntryArgument.Amount := ApprovalAmount;
            ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
          END;
        //ALLE AP
        */
        End;
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnAfterIsSufficientApprover, '', false, false)]
    local procedure OnAfterIsSufficientApprover_ApprovalsMgmt(ApprovalEntryArgument: Record "Approval Entry"; UserSetup: Record "User Setup"; var IsHandled: Boolean; var IsSufficient: Boolean)
    begin
        CASE ApprovalEntryArgument."Table ID" OF
            //EPC2016Upgrade
            DATABASE::"Purchase Request Header":
                IsSufficient := IsSufficientPurchIndentApprover(UserSetup, ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Amount (LCY)");
            DATABASE::Job:
                IsSufficient := IsSufficientJobApprover(UserSetup, ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Amount (LCY)");
            DATABASE::"GRN Header":
                IsSufficient := IsSufficientPurchReceiptApprover(UserSetup, ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Amount (LCY)");
            DATABASE::"Transfer Header":
                IsSufficient := IsSufficientTransferOrderApprover(UserSetup, ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Amount (LCY)");
        //ALLE TS 18012017
        //DATABASE::"Award Note":
        //EXIT(IsSufficientAwardApprover(UserSetup,ApprovalEntryArgument."Document Type",ApprovalEntryArgument."Amount (LCY)"));
        //ALLE TS 18012017
        //ALLE AP
        //DATABASE::"Note Sheet":
        //EXIT(IsSufficientAwardApprover2(UserSetup,ApprovalEntryArgument."Document Type",ApprovalEntryArgument."Amount (LCY)"));
        //ALLE AP
        End;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforePrePostApprovalCheckSales, '', false, false)]
    local procedure OnBeforePrePostApprovalCheckSales_ApprovalsMgmt(var IsHandled: Boolean; var Result: Boolean; var SalesHeader: Record "Sales Header")
    begin
        //EPC2016Upgrade
        //SalesHeader.TESTFIELD("Assigned User ID", USERID); Not Required
    End;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforePrePostApprovalCheckPurch, '', false, false)]
    local procedure OnBeforePrePostApprovalCheckPurch_ApprovalsMgmt(var IsHandled: Boolean; var PurchaseHeader: Record "Purchase Header"; var Result: Boolean)
    begin
        //EPC2016Upgrade
        ///PurchaseHeader.TESTFIELD("Assigned User ID", USERID); Not Required
    End;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnSetStatusToPendingApproval, '', false, false)]
    local procedure OnSetStatusToPendingApproval_ApprovalsMgmt(var Variant: Variant; RecRef: RecordRef; var IsHandled: Boolean)
    var

        PurchaseIndentHeader: Record "Purchase Request Header";
        Job: Record Job;
        GoodsReceiptHeader: Record "GRN Header";
        TransferHeader: Record "Transfer Header";
        AwardNote: Record "Confirmed Order";
        NoteSheet: Record Documentation;
    begin
        RecRef.GetTable(Variant);

        case RecRef.Number of

            DATABASE::"Purchase Header":
                BEGIN
                    // RecRef.SETTABLE(PurchaseHeader);
                    // //EPC2016Upgrade
                    // PurchaseHeader.CheckBeforeRelease;
                End;
            //EPC2016Upgrade
            DATABASE::"Purchase Request Header":
                BEGIN
                    RecRef.SETTABLE(PurchaseIndentHeader);
                    PurchaseIndentHeader.CheckBeforeRelease;
                    PurchaseIndentHeader.VALIDATE("Workflow Approval Status", PurchaseIndentHeader."Workflow Approval Status"::"Pending Approval");
                    PurchaseIndentHeader.SuspendStatusCheck(TRUE);
                    PurchaseIndentHeader.MODIFY(TRUE);
                    Variant := PurchaseIndentHeader;
                    IsHandled := true;
                END;
            DATABASE::Job:
                BEGIN
                    RecRef.SETTABLE(Job);
                    Job.CheckBeforeRelease;
                    Job.VALIDATE("Workflow Approval Status", Job."Workflow Approval Status"::"Pending Approval");
                    //Job.SuspendStatusCheck(TRUE);
                    Job.MODIFY(TRUE);
                    Variant := Job;
                    IsHandled := true;
                END;
            DATABASE::"GRN Header":
                BEGIN
                    RecRef.SETTABLE(GoodsReceiptHeader);
                    GoodsReceiptHeader.CheckBeforeRelease;
                    GoodsReceiptHeader.VALIDATE("Workflow Approval Status", Job."Workflow Approval Status"::"Pending Approval");
                    GoodsReceiptHeader.SuspendStatusCheck(TRUE);
                    GoodsReceiptHeader.MODIFY(TRUE);
                    Variant := GoodsReceiptHeader;
                    IsHandled := true;
                END;
            DATABASE::"Transfer Header":
                BEGIN
                    RecRef.SETTABLE(TransferHeader);
                    //TransferHeader.CheckBeforeRelease;
                    //TransferHeader.VALIDATE(Status,TransferHeader.Status::"Pending Approval");
                    TransferHeader.MODIFY(TRUE);
                    Variant := TransferHeader;
                    IsHandled := true;
                END;
        //ALLE TS 18012017
        //ALLE TS 18012017
        //ALLE AP
        End;
    End;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", OnBeforeSetCommonApprovalCommentLineFilters, '', false, false)]
    local procedure OnBeforeSetCommonApprovalCommentLineFilters_ApprovalsMgmt(var ApprovalCommentLine: Record "Approval Comment Line"; var IsHandle: Boolean; var RecRef: RecordRef)
    var
        PurchaseIndentHeader: Record "Purchase Request Header";
        Job: Record Job;
        GoodsReceiptHeader: Record "GRN Header";
        TransferHeader: Record "Transfer Header";
        AwardNote: Record "Confirmed Order";
        NoteSheet: Record Documentation;
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
    Begin

        case RecRef.Number of
            DATABASE::"Purchase Header":
                BEGIN
                    //PurchaseHeader := Variant;
                    ApprovalCommentLine.SETRANGE("Table ID", DATABASE::"Purchase Header");
                    ApprovalCommentLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
                    ApprovalCommentLine.SETRANGE("Document No.", PurchaseHeader."No.");
                    ApprovalCommentLine.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                    IsHandle := true;
                END;
            DATABASE::"Sales Header":
                BEGIN
                    // SalesHeader := Variant;
                    ApprovalCommentLine.SETRANGE("Table ID", DATABASE::"Sales Header");
                    ApprovalCommentLine.SETRANGE("Document Type", SalesHeader."Document Type");
                    ApprovalCommentLine.SETRANGE("Document No.", SalesHeader."No.");
                    ApprovalCommentLine.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                    IsHandle := true;
                END;
            //EPC2016Upgrade
            DATABASE::"Purchase Request Header":
                BEGIN
                    //   PurchaseHeader := Variant;
                    ApprovalCommentLine.SETRANGE("Table ID", DATABASE::"Purchase Request Header");
                    ApprovalCommentLine.SETRANGE("Document Type", PurchaseIndentHeader."Document Type");
                    ApprovalCommentLine.SETRANGE("Document No.", PurchaseIndentHeader."Document No.");
                    ApprovalCommentLine.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                    IsHandle := true;
                END;
            DATABASE::Job:
                BEGIN
                    //       Job := Variant;
                    ApprovalCommentLine.SETRANGE("Table ID", DATABASE::Job);
                    //ApprovalCommentLine.SETRANGE("Document Type",PurchaseIndentHeader."Document Type");
                    ApprovalCommentLine.SETRANGE("Document No.", Job."No.");
                    ApprovalCommentLine.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                END;
            DATABASE::"GRN Header":
                BEGIN
                    //         GoodsReceiptHeader := Variant;
                    ApprovalCommentLine.SETRANGE("Table ID", DATABASE::"GRN Header");
                    ApprovalCommentLine.SETRANGE("Document Type", GoodsReceiptHeader."Document Type");
                    ApprovalCommentLine.SETRANGE("Document No.", GoodsReceiptHeader."GRN No.");
                    ApprovalCommentLine.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                    IsHandle := true;
                END;
            DATABASE::"Transfer Header":
                BEGIN
                    //     TransferHeader := Variant;
                    ApprovalCommentLine.SETRANGE("Table ID", DATABASE::"Transfer Header");
                    //ApprovalCommentLine.SETRANGE("Document Type",TransferHeader."Document Type");
                    ApprovalCommentLine.SETRANGE("Document No.", TransferHeader."No.");
                    ApprovalCommentLine.SETRANGE("Record ID to Approve", RecRef.RECORDID);
                    IsHandle := true;
                END;
        //ALLE TS 18012017
        End;
    End;

    PROCEDURE DeleteApprovalEntry(TableId: Integer; DocumentType: Option; DocumentNo: Code[20])
    VAR
        ApprovalEntry: Record "Approval Entry";
    BEGIN
        ApprovalEntry.SETRANGE("Table ID", TableId);
        ApprovalEntry.SETRANGE("Document Type", DocumentType);
        ApprovalEntry.SETRANGE("Document No.", DocumentNo);
        ApprovalEntry.DELETEALL;
        DeleteApprovalCommentLine(TableId, DocumentType, DocumentNo);
    END;

    LOCAL PROCEDURE DeleteApprovalCommentLine(TableId: Integer; DocumentType: option Quote,Order,Invoice,"Credit Memo","Blanket Order","Return Order"; DocumentNo: Code[20])
    VAR
        ApprovalCommentLine: Record "Approval Comment Line";
    BEGIN
        ApprovalCommentLine.SETRANGE("Table ID", TableId);
        ApprovalCommentLine.SETRANGE("Document Type", DocumentType);
        ApprovalCommentLine.SETRANGE("Document No.", DocumentNo);
        ApprovalCommentLine.DELETEALL;
    END;

    LOCAL PROCEDURE ShowPurchIndentApprovalStatus(PurchaseIndentHeader: Record "Purchase Request Header");
    var
        DocStatusChangedMsg: Label '@@@=Order 1001 has been automatically approved. The status has been changed to Released. %1 %2 has been automatically approved. The status has been changed to %3.';
        PendingApprovalMsg: Label 'An approval request has been sent.';
    BEGIN
        PurchaseIndentHeader.FIND;

        CASE PurchaseIndentHeader."Workflow Approval Status" OF
            PurchaseIndentHeader."Workflow Approval Status"::Released:
                MESSAGE(DocStatusChangedMsg, PurchaseIndentHeader."Document Type", PurchaseIndentHeader."Document No.", PurchaseIndentHeader."Workflow Approval Status");
            PurchaseIndentHeader."Workflow Approval Status"::"Pending Approval":
                MESSAGE(PendingApprovalMsg);
        //PurchaseIndentHeader."Workflow Approval Status"::"Pending Prepayment":
        //  MESSAGE(DocStatusChangedMsg,PurchaseIndentHeader."Document Type",PurchaseIndentHeader."No.",PurchaseIndentHeader."Workflow Approval Status");
        END;
    END;

    PROCEDURE CalcPurchaseIndentDocAmount(PurchaseIndentHeader: Record "Purchase Request Header"; VAR ApprovalAmount: Decimal; VAR ApprovalAmountLCY: Decimal)
    VAR
        TempPurchaseIndentLine: Record "Purchase Request Line" TEMPORARY;
        TotalPurchaseIndentLine: Record "Purchase Request Line";
        TotalPurchaseIndentLineLCY: Record "Purchase Request Line";
        PurchPost: Codeunit "Purch.-Post";
        TempAmount: Decimal;
        VAtText: Text[30];
    BEGIN
        //PurchaseIndentHeader.CalcInvDiscForHeader;
        //PurchPost.GetPurchLines(PurchaseIndentHeader,TempPurchaseLine,0);
        //CLEAR(PurchPost);
        //PurchPost.SumPurchLinesTemp(
        //  PurchaseHeader,TempPurchaseLine,0,TotalPurchaseLine,TotalPurchaseLineLCY,
        //  TempAmount,VAtText);
        ApprovalAmount := TotalPurchaseIndentLine.Amount;
        ApprovalAmountLCY := TotalPurchaseIndentLineLCY.Amount;
    END;

    LOCAL PROCEDURE IsSufficientPurchIndentApprover(UserSetup: Record "User Setup"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    VAR
        PurchaseIndentHeader: Record "Purchase Request Header";
    BEGIN
        IF UserSetup."User ID" = UserSetup."Approver ID" THEN
            EXIT(TRUE);

        CASE DocumentType OF
            PurchaseIndentHeader."Document Type"::Indent:
                IF UserSetup."Unlimited Purchase Approval" OR
                   ((ApprovalAmountLCY <= UserSetup."Purchase Amount Approval Limit") AND (UserSetup."Purchase Amount Approval Limit" <> 0))
                THEN
                    EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    // PROCEDURE IsSufficientApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; ApprovalEntryArgument: Record "Approval Entry"): Boolean
    // BEGIN
    //     CASE ApprovalEntryArgument."Table ID" OF

    //         // DATABASE::"Purchase Header":
    //         //     EXIT(IsSufficientPurchApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Amount (LCY)"));
    //         // DATABASE::"Sales Header":
    //         //     EXIT(IsSufficientSalesApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Amount (LCY)"));
    //         // DATABASE::"Gen. Journal Batch":
    //         //     MESSAGE(ApporvalChainIsUnsupportedMsg, FORMAT(ApprovalEntryArgument."Record ID to Approve"));
    //         // DATABASE::"Gen. Journal Line":
    //         //     EXIT(IsSufficientGenJournalLineApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument));

    //         // DATABASE::"Purchase Request Header":
    //         //     EXIT(IsSufficientPurchIndentApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Amount (LCY)"));
    //         DATABASE::Job:
    //             EXIT(IsSufficientJobApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Amount (LCY)"));
    //         DATABASE::"GRN Header":
    //             EXIT(IsSufficientPurchReceiptApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Amount (LCY)"));
    //         DATABASE::"Transfer Header":
    //             EXIT(IsSufficientTransferOrderApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Amount (LCY)"));
    //     END;

    //     EXIT(TRUE);
    // END;

    LOCAL PROCEDURE IsSufficientPurchIndentApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    VAR
        PurchaseIndentHeader: Record "Purchase Request Header";
    BEGIN
        CASE DocumentType OF
            PurchaseIndentHeader."Document Type"::Indent:
                IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
                THEN
                    EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    // LOCAL PROCEDURE IsSufficientPurchApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    // VAR
    //     PurchaseHeader: Record "Purchase Header";
    // BEGIN
    //     //IF UserSetup."User ID" = UserSetup."Approver ID" THEN
    //     //  EXIT(TRUE);

    //     CASE DocumentType OF
    //         PurchaseHeader."Document Type"::Quote:
    //             IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
    //             THEN
    //                 EXIT(TRUE);
    //         ELSE
    //             IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
    //             THEN
    //                 EXIT(TRUE);
    //     END;

    //     EXIT(FALSE);
    // END;

    // LOCAL PROCEDURE IsSufficientSalesApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; ApprovalAmountLCY: Decimal): Boolean
    // BEGIN
    //     //IF UserSetup."User ID" = UserSetup."Approver ID" THEN
    //     //  EXIT(TRUE);

    //     IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
    //     THEN
    //         EXIT(TRUE);

    //     EXIT(FALSE);
    // END;

    // LOCAL PROCEDURE IsSufficientGenJournalLineApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; ApprovalEntryArgument: Record "Approval Entry"): Boolean
    // VAR
    //     GenJournalLine: Record "Gen. Journal Line";
    //     RecRef: RecordRef;
    // BEGIN
    //     RecRef.GET(ApprovalEntryArgument."Record ID to Approve");
    //     RecRef.SETTABLE(GenJournalLine);

    //     IF GenJournalLine.IsForPurchase THEN
    //         EXIT(IsSufficientPurchApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Document Type", ApprovalEntryArgument."Amount (LCY)"));

    //     IF GenJournalLine.IsForSales THEN
    //         EXIT(IsSufficientSalesApproverInUserGroup(WorkflowUserGroupMember, ApprovalEntryArgument."Amount (LCY)"));

    //     EXIT(TRUE);
    // END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendJobForApproval(VAR Job: Record Job)
    BEGIN
    END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelJobApprovalRequest(VAR Job: Record Job)
    BEGIN
    END;

    PROCEDURE CheckJobApprovalsWorkflowEnabled(VAR Job: Record Job): Boolean
    var
        NoWorkflowEnabledErr: Label 'This record is not supported by related approval workflow.';
    BEGIN
        IF NOT IsJobApprovalsWorkflowEnabled(Job) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    END;

    PROCEDURE IsJobApprovalsWorkflowEnabled(VAR Job: Record Job): Boolean;
    BEGIN
        EXIT(WorkflowManagement.CanExecuteWorkflow(Job, RunWorkflowOnSendJobForApprovalCode));
    END;



    LOCAL PROCEDURE ShowJobApprovalStatus(Job: Record Job)
    var
        DocStatusChangedMsg: Label '@@@=Order 1001 has been automatically approved. The status has been changed to Released. %1 %2 has been automatically approved. The status has been changed to %3.';
        PendingApprovalMsg: Label 'An approval request has been sent.';
    BEGIN
        Job.FIND;

        CASE Job."Workflow Approval Status" OF
            Job."Workflow Approval Status"::Released:
                MESSAGE(DocStatusChangedMsg, 'Job', Job."No.", Job."Workflow Approval Status"); //Job."Document Type"
            Job."Workflow Approval Status"::"Pending Approval":
                MESSAGE(PendingApprovalMsg);
        // Job."Workflow Approval Status"::"Pending Prepayment":
        //  MESSAGE(DocStatusChangedMsg,Job."Document Type",Job."No.",Job.Status);
        END;
    END;

    PROCEDURE CalcJobAmount(Job: Record Job; VAR ApprovalAmount: Decimal; VAR ApprovalAmountLCY: Decimal)
    VAR
        TempJobPlanningLine: Record "Job Planning Line" TEMPORARY;
        TotalJobPlanningLine: Record "Job Planning Line";
        TotalJobPlanningLineLCY: Record "Job Planning Line";
        PurchPost: Codeunit "Purch.-Post";
        TempAmount: Decimal;
        VAtText: Text[30];
    BEGIN
        //PurchaseIndentHeader.CalcInvDiscForHeader;
        //PurchPost.GetPurchLines(PurchaseIndentHeader,TempPurchaseLine,0);
        //CLEAR(PurchPost);
        //PurchPost.SumPurchLinesTemp(
        //  PurchaseHeader,TempPurchaseLine,0,TotalPurchaseLine,TotalPurchaseLineLCY,
        //  TempAmount,VAtText);
        ApprovalAmount := TotalJobPlanningLine."Line Amount";
        ApprovalAmountLCY := TotalJobPlanningLineLCY."Line Amount (LCY)";
    END;

    LOCAL PROCEDURE IsSufficientJobApprover(UserSetup: Record "User Setup"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    VAR
        Job: Record Job;
    BEGIN
        IF UserSetup."User ID" = UserSetup."Approver ID" THEN
            EXIT(TRUE);

        //CASE DocumentType OF
        //Job."Document Type"::Order:
        IF UserSetup."Unlimited Sales Approval" OR
           ((ApprovalAmountLCY <= UserSetup."Sales Amount Approval Limit") AND (UserSetup."Sales Amount Approval Limit" <> 0))
        THEN
            EXIT(TRUE);
        //END;

        EXIT(FALSE);
    END;

    // LOCAL PROCEDURE IsSufficientJobApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    // VAR
    //     Job: Record Job;
    // BEGIN
    //     //CASE DocumentType OF
    //     //Job."Document Type"::Order:
    //     IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
    //     THEN
    //         EXIT(TRUE);
    //     //END;

    //     EXIT(FALSE);
    // END;







    LOCAL PROCEDURE ShowPurchReceiptApprovalStatus(GoodsReceiptHeader: Record "GRN Header");
    var
        DocStatusChangedMsg: Label '@@@=Order 1001 has been automatically approved. The status has been changed to Released. %1 %2 has been automatically approved. The status has been changed to %3.';
        PendingApprovalMsg: Label 'An approval request has been sent.';
    BEGIN
        GoodsReceiptHeader.FIND;

        CASE GoodsReceiptHeader."Workflow Approval Status" OF
            GoodsReceiptHeader."Workflow Approval Status"::Released:
                MESSAGE(DocStatusChangedMsg, GoodsReceiptHeader."Document Type", GoodsReceiptHeader."GRN No.", GoodsReceiptHeader."Workflow Approval Status");
            GoodsReceiptHeader."Workflow Approval Status"::"Pending Approval":
                MESSAGE(PendingApprovalMsg);
        //PurchaseIndentHeader."Workflow Approval Status"::"Pending Prepayment":
        //  MESSAGE(DocStatusChangedMsg,PurchaseIndentHeader."Document Type",PurchaseIndentHeader."No.",PurchaseIndentHeader."Workflow Approval Status");
        END;
    END;

    PROCEDURE CalcPurchaseReceiptDocAmount(GoodsReceiptHeader: Record "GRN Header"; VAR ApprovalAmount: Decimal; VAR ApprovalAmountLCY: Decimal)
    VAR
        TempGoodsReceiptLine: Record "GRN Line" TEMPORARY;
        TotalGoodsReceiptLine: Record "GRN Line";
        TotalGoodsReceiptLineLCY: Record "GRN Line";
        PurchPost: Codeunit "Purch.-Post";
        TempAmount: Decimal;
        VAtText: Text[30];
    BEGIN
        //PurchaseIndentHeader.CalcInvDiscForHeader;
        //PurchPost.GetPurchLines(PurchaseIndentHeader,TempPurchaseLine,0);
        //CLEAR(PurchPost);
        //PurchPost.SumPurchLinesTemp(
        //  PurchaseHeader,TempPurchaseLine,0,TotalPurchaseLine,TotalPurchaseLineLCY,
        //  TempAmount,VAtText);
        ApprovalAmount := TotalGoodsReceiptLine."Line Amount";
        ApprovalAmountLCY := TotalGoodsReceiptLineLCY."Line Amount";
    END;

    LOCAL PROCEDURE IsSufficientPurchReceiptApprover(UserSetup: Record "User Setup"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    VAR
        GoodsReceiptHeader: Record "GRN Header";
    BEGIN
        IF UserSetup."User ID" = UserSetup."Approver ID" THEN
            EXIT(TRUE);

        CASE DocumentType OF
            GoodsReceiptHeader."Document Type"::GRN:
                IF UserSetup."Unlimited Purchase Approval" OR
                   ((ApprovalAmountLCY <= UserSetup."Purchase Amount Approval Limit") AND (UserSetup."Purchase Amount Approval Limit" <> 0))
                THEN
                    EXIT(TRUE);
        END;

        EXIT(FALSE);
    END;

    // LOCAL PROCEDURE IsSufficientPurchReceiptApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    // VAR
    //     GoodsReceiptHeader: Record "GRN Header";
    // BEGIN
    //     CASE DocumentType OF
    //         GoodsReceiptHeader."Document Type"::GRN:
    //             IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
    //             THEN
    //                 EXIT(TRUE);
    //     END;

    //     EXIT(FALSE);
    // END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendTransferOrderDocForApproval(VAR TransferHeader: Record "Transfer Header")
    BEGIN
    END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelTransferOrderApprovalRequest(VAR TransferHeader: Record "Transfer Header")
    BEGIN
    END;

    PROCEDURE CheckTransferOrderApprovalsWorkflowEnabled(VAR TransferHeader: Record "Transfer Header"): Boolean
    var
        NoWorkflowEnabledErr: Label 'This record is not supported by related approval workflow.';
    BEGIN
        IF NOT IsTransferOrderApprovalsWorkflowEnabled(TransferHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    END;

    PROCEDURE IsTransferOrderApprovalsWorkflowEnabled(VAR TransferHeader: Record "Transfer Header"): Boolean
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    BEGIN
        EXIT(WorkflowManagement.CanExecuteWorkflow(TransferHeader, RunWorkflowOnSendTransferOrderDocForApprovalCode));
    END;

    LOCAL PROCEDURE ShowTransferOrderApprovalStatus(TransferHeader: Record "Transfer Header")
    var
        DocStatusChangedMsg: Label '@@@=Order 1001 has been automatically approved. The status has been changed to Released. %1 %2 has been automatically approved. The status has been changed to %3.';
    BEGIN
        TransferHeader.FIND;

        CASE TransferHeader.Status OF
            TransferHeader.Status::Released:
                MESSAGE(DocStatusChangedMsg, 'Order', TransferHeader."No.", TransferHeader.Status); //TransferHeader."Document Type"
        //TransferHeader.Status::"Pending Approval":
        // MESSAGE(PendingApprovalMsg);
        //PurchaseIndentHeader."Workflow Approval Status"::"Pending Prepayment":
        //  MESSAGE(DocStatusChangedMsg,PurchaseIndentHeader."Document Type",PurchaseIndentHeader."No.",PurchaseIndentHeader."Workflow Approval Status");
        END;
    END;

    PROCEDURE CalcTransferOrderDocAmount(TransferHeader: Record "Transfer Header"; VAR ApprovalAmount: Decimal; VAR ApprovalAmountLCY: Decimal)
    VAR
        TempTransferLine: Record "Transfer Line" TEMPORARY;
        TotalTransferLine: Record "Transfer Line";
        TotalTransferLineLCY: Record "Transfer Line";
        PurchPost: Codeunit "Purch.-Post";
        TempAmount: Decimal;
        VAtText: Text[30];
    BEGIN
        //PurchaseIndentHeader.CalcInvDiscForHeader;
        //PurchPost.GetPurchLines(PurchaseIndentHeader,TempPurchaseLine,0);
        //CLEAR(PurchPost);
        //PurchPost.SumPurchLinesTemp(
        //  PurchaseHeader,TempPurchaseLine,0,TotalPurchaseLine,TotalPurchaseLineLCY,
        //  TempAmount,VAtText);
        ApprovalAmount := TotalTransferLine.Amount;
        ApprovalAmountLCY := TotalTransferLineLCY.Amount;
    END;

    LOCAL PROCEDURE IsSufficientTransferOrderApprover(UserSetup: Record "User Setup"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    VAR
        TransferHeader: Record "Transfer Header";
    BEGIN
        IF UserSetup."User ID" = UserSetup."Approver ID" THEN
            EXIT(TRUE);

        //CASE DocumentType OF
        //  GoodsReceiptHeader."Document Type"::GRN:
        IF UserSetup."Unlimited Purchase Approval" OR
           ((ApprovalAmountLCY <= UserSetup."Purchase Amount Approval Limit") AND (UserSetup."Purchase Amount Approval Limit" <> 0))
        THEN
            EXIT(TRUE);
        //END;

        EXIT(FALSE);
    END;

    // LOCAL PROCEDURE IsSufficientTransferOrderApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    // VAR
    //     TransferHeader: Record "Transfer Header";
    // BEGIN
    //     //CASE DocumentType OF
    //     //  GoodsReceiptHeader."Document Type"::GRN:
    //     IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
    //     THEN
    //         EXIT(TRUE);
    //     //END;

    //     EXIT(FALSE);
    // END;


    [IntegrationEvent(false, false)]
    PROCEDURE OnSendAwardForApproval(VAR AwardNote: Record "Confirmed Order")
    BEGIN
    END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelAwardApprovalRequest(VAR AwardNote: Record "Confirmed Order")
    BEGIN
    END;

    PROCEDURE CheckAwardApprovalsWorkflowEnabled(VAR AwardNote: Record "Confirmed Order"): Boolean
    BEGIN
        // IF NOT IsAwardApprovalsWorkflowEnabled(AwardNote) THEN
        //     ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    END;

    PROCEDURE IsAwardApprovalsWorkflowEnabled(VAR AwardNote: Record "Confirmed Order"): Boolean
    BEGIN
        // EXIT(WorkflowManagement.CanExecuteWorkflow(AwardNote, WorkflowEventHandling.RunWorkflowOnSendAwardNoteForApprovalCode));
    END;

    LOCAL PROCEDURE ShowAwardApprovalStatus(AwardNote: Record "Confirmed Order")
    BEGIN
        AwardNote.FIND;
        /*
        CASE AwardNote."Workflow Approval Status" OF
          AwardNote."Workflow Approval Status"::Released:
            MESSAGE(DocStatusChangedMsg,'Award',AwardNote."Document No.",AwardNote."Workflow Approval Status");
          AwardNote."Workflow Approval Status"::"Pending Approval":
            MESSAGE(PendingApprovalMsg);

        END;
        */
    END;

    PROCEDURE CalcAwardAmount(AwardNote: Record "Confirmed Order"; VAR ApprovalAmount: Decimal; VAR ApprovalAmountLCY: Decimal)
    VAR
        TempPurchaseHeader: Record "Purchase Header";
    BEGIN

        //ALLE ANSH START 250517
        CLEAR(TempPurchaseHeader);
        TempPurchaseHeader.RESET;
        TempPurchaseHeader.SETRANGE("Document Type", TempPurchaseHeader."Document Type"::Quote);
        //TempPurchaseHeader.SETRANGE("No.",AwardNote."Selected Quotation");
        //TempPurchaseHeader.SETRANGE("Quote Converted to Order",FALSE);
        IF TempPurchaseHeader.FINDFIRST THEN BEGIN
            TempPurchaseHeader.CALCFIELDS(Amount);
            ApprovalAmount := TempPurchaseHeader.Amount;
            //MESSAGE('Quote..%1',TempPurchaseHeader.Amount);
            ApprovalAmountLCY := TempPurchaseHeader.Amount;
        END ELSE BEGIN
            CLEAR(TempPurchaseHeader);
            TempPurchaseHeader.RESET;
            TempPurchaseHeader.SETRANGE("Document Type", TempPurchaseHeader."Document Type"::Order);
            //TempPurchaseHeader.SETRANGE("Quote No.",AwardNote."Selected Quotation");
            IF TempPurchaseHeader.FINDFIRST THEN BEGIN
                TempPurchaseHeader.CALCFIELDS(Amount);
                //MESSAGE('Order..%1',TempPurchaseHeader.Amount);
                ApprovalAmount := TempPurchaseHeader.Amount;
                ApprovalAmountLCY := TempPurchaseHeader.Amount;
            END;
        END;
        //ALLE ANSH END 250517
    END;

    LOCAL PROCEDURE IsSufficientAwardApprover(UserSetup: Record "User Setup"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    VAR
        AwardNote: Record "Confirmed Order";
    BEGIN
        IF UserSetup."User ID" = UserSetup."Approver ID" THEN
            EXIT(TRUE);

        IF UserSetup."Unlimited Purchase Approval" OR
            ((ApprovalAmountLCY <= UserSetup."Purchase Amount Approval Limit") AND (UserSetup."Purchase Amount Approval Limit" <> 0))
        THEN
            EXIT(TRUE);

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsSufficientAwardApproverInUserGroup(WorkflowUserGroupMember: Record "Workflow User Group Member"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    VAR
        AwardNote: Record "Confirmed Order";
    BEGIN
        IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
        THEN
            EXIT(TRUE);

        EXIT(FALSE);
    END;


    [IntegrationEvent(false, false)]
    PROCEDURE OnSendAwardForApproval2(VAR AwardNote: Record Documentation)
    BEGIN
    END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendPurchaseIndentDocForApproval(VAR PurchaseIndentHeader: Record "Purchase Request Header");
    BEGIN
    END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelPurchaseIndentApprovalRequest(VAR PurchaseIndentHeader: Record "Purchase Request Header");
    BEGIN
    END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelAwardApprovalRequest2(VAR AwardNote: Record Documentation)
    BEGIN
    END;

    PROCEDURE CheckAwardApprovalsWorkflowEnabled2(VAR AwardNote: Record Documentation): Boolean
    BEGIN
        // IF NOT IsAwardApprovalsWorkflowEnabled2(AwardNote) THEN
        //     ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    END;

    PROCEDURE IsAwardApprovalsWorkflowEnabled2(VAR AwardNote: Record Documentation): Boolean
    BEGIN
        //EXIT(WorkflowManagement.CanExecuteWorkflow(AwardNote, WorkflowEventHandling.RunWorkflowOnSendNoteSheetForApprovalCode));
    END;

    LOCAL PROCEDURE ShowAwardApprovalStatus2(AwardNote: Record Documentation)
    BEGIN
        AwardNote.FIND;
        /*
        CASE AwardNote."Workflow Approval Status" OF
          AwardNote."Workflow Approval Status"::Released:
            MESSAGE(DocStatusChangedMsg,'Note Sheet',AwardNote."Document No.",AwardNote."Workflow Approval Status");
          AwardNote."Workflow Approval Status"::"Pending Approval":
            MESSAGE(PendingApprovalMsg);
        END;
        */
    END;

    PROCEDURE CalcAwardAmount2(AwardNote: Record Documentation; VAR ApprovalAmount: Decimal; VAR ApprovalAmountLCY: Decimal)
    VAR
        TempPurchaseHeader: Record "Purchase Header" TEMPORARY;
    BEGIN
        ApprovalAmount := TempPurchaseHeader.Amount;
        ApprovalAmountLCY := TempPurchaseHeader.Amount;
    END;

    LOCAL PROCEDURE IsSufficientAwardApprover2(UserSetup: Record "User Setup"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    VAR
        AwardNote: Record Documentation;
    BEGIN
        IF UserSetup."User ID" = UserSetup."Approver ID" THEN
            EXIT(TRUE);

        IF UserSetup."Unlimited Purchase Approval" OR
            ((ApprovalAmountLCY <= UserSetup."Purchase Amount Approval Limit") AND (UserSetup."Purchase Amount Approval Limit" <> 0))
        THEN
            EXIT(TRUE);

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE IsSufficientAwardApproverInUserGroup2(WorkflowUserGroupMember: Record "Workflow User Group Member"; DocumentType: Option; ApprovalAmountLCY: Decimal): Boolean
    VAR
        AwardNote: Record Documentation;
    BEGIN
        IF ((ApprovalAmountLCY <= WorkflowUserGroupMember."Approval Amount Limit") AND (WorkflowUserGroupMember."Approval Amount Limit" <> 0))
        THEN
            EXIT(TRUE);

        EXIT(FALSE);
    END;

    LOCAL PROCEDURE CalcPurchaseDocAmountforAward(PurchaseHeader: Record "Purchase Header"; VAR ApprovalAmount: Decimal; VAR ApprovalAmountLCY: Decimal)
    VAR
        TempPurchaseLine: Record "Purchase Line" TEMPORARY;
        TotalPurchaseLine: Record "Purchase Line";
        TotalPurchaseLineLCY: Record "Purchase Line";
        PurchPost: Codeunit "Purch.-Post";
        TempAmount: Decimal;
        VAtText: Text[30];
    BEGIN
        PurchaseHeader.CalcInvDiscForHeader;
        PurchPost.GetPurchLines(PurchaseHeader, TempPurchaseLine, 0);
        CLEAR(PurchPost);
        PurchPost.SumPurchLinesTemp(
          PurchaseHeader, TempPurchaseLine, 0, TotalPurchaseLine, TotalPurchaseLineLCY,
          TempAmount, VAtText);
        ApprovalAmount := TotalPurchaseLine.Amount;
        ApprovalAmountLCY := TotalPurchaseLineLCY.Amount;
        //MESSAGE('PO Amount..%1',TotalPurchaseLine.Amount);
        //MESSAGE('PO Amount LCY ..%1',TotalPurchaseLineLCY.Amount);
    END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnSendPurchaseReceiptDocForApproval(VAR GoodsReceiptHeader: Record "GRN Header");
    BEGIN
    END;

    [IntegrationEvent(false, false)]
    PROCEDURE OnCancelPurchaseReceiptApprovalRequest(VAR GoodsReceiptHeader: Record "GRN Header");
    BEGIN
    END;



    //======= Codeunit 1535 "Approvals Mgmt." ========END<<

    //======= Codeunit 1252 "Match Bank Rec. Lines" ========Start>>

    LOCAL PROCEDURE GetCheckNoMatchScore(BankRecCheckNo: Text; BankEntryCheckNo: Text): Integer;
    VAR
        RecordMatchMgt: Codeunit "Record Match Mgt.";
        Nearness: Integer;
        Score: Integer;
        MatchLengthTreshold: Integer;
        NormalizingFactor: Integer;
    BEGIN
        BankRecCheckNo := RecordMatchMgt.Trim(BankRecCheckNo);
        BankEntryCheckNo := RecordMatchMgt.Trim(BankEntryCheckNo);

        MatchLengthTreshold := 6;//GetMatchLengthTreshold;
                                 // NormalizingFactor := GetNormalizingFactor;
        Score := 0;


        Nearness := RecordMatchMgt.CalculateStringNearness(BankRecCheckNo, BankEntryCheckNo,
            MatchLengthTreshold, NormalizingFactor);
        IF Nearness >= 0.9 * NormalizingFactor THEN BEGIN
            Score += Nearness;
        END;

        EXIT(Score);
    END;

    //======= Codeunit 1252 "Match Bank Rec. Lines" ========END<<

    //---1496 report ---------


    [EventSubscriber(ObjectType::Report, Report::"Suggest Bank Acc. Recon. Lines", OnBeforeInsertBankAccReconLine, '', false, false)]
    local procedure OnBeforeInsertBankAccReconLine(var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; var BankAccLedgEntry: Record "Bank Account Ledger Entry")
    var

    begin
        IF BankAccLedgEntry."Cheque No.1" = '' Then begin
            BankAccReconLine."Check No." := BankAccLedgEntry."Cheque No.";
            BankAccReconLine."Cheque No." := BankAccLedgEntry."Cheque No.";
        end Else begin
            BankAccReconLine."Check No." := BankAccLedgEntry."Cheque No.1";
            BankAccReconLine."Cheque No." := BankAccLedgEntry."Cheque No.1";
        end;
        BankAccReconLine."Cheque Date" := BankAccLedgEntry."Cheque Date";
        BankAccReconLine."User ID" := USERID;
    end;

    //---1496 report ---------

    //-------Find TDS %--------->>

    procedure GetTDSPer(Var VendorNo: Code[20]; Var TDSSectionCode: Code[10]; var AssesseeCode: Code[10]): Decimal
    var
        BBGTaxRateBuffer: Record "BBG Tax Rate Buffer";
        Vend: Record Vendor;
    begin
        IF VendorNo = '' Then
            Error('Vendor No. must have a value');

        IF TDSSectionCode = '' then
            Error('TDS Section Code must have a value');

        IF AssesseeCode = '' then
            Error('Assessee Code must have a value');

        InsertBBGTaxRateBuffer(TDSSectionCode);
        Vend.Get(VendorNo);
        IF (Vend."P.A.N. Status" = Vend."P.A.N. Status"::" ") AND (Vend."P.A.N. No." <> '') THEN Begin
            BBGTaxRateBuffer.Reset();
            BBGTaxRateBuffer.SetCurrentKey("TDS Section", "Effective Date", "Assessee Code");
            BBGTaxRateBuffer.SetRange("TDS Section", TDSSectionCode);
            BBGTaxRateBuffer.SetRange("Effective Date", 0D, Today);
            BBGTaxRateBuffer.SetRange("Assessee Code", AssesseeCode);
            //BBGTaxRateBuffer.SetRange("PAN/NON PAN", true);
            IF BBGTaxRateBuffer.FindLast() Then begin
                exit(BBGTaxRateBuffer."TDS %");
            end;
        End Else Begin
            BBGTaxRateBuffer.Reset();
            BBGTaxRateBuffer.SetCurrentKey("TDS Section", "Effective Date", "Assessee Code");
            BBGTaxRateBuffer.SetRange("TDS Section", TDSSectionCode);
            BBGTaxRateBuffer.SetRange("Effective Date", 0D, Today);
            BBGTaxRateBuffer.SetRange("Assessee Code", AssesseeCode);
            //BBGTaxRateBuffer.SetRange("PAN/NON PAN", false);
            IF BBGTaxRateBuffer.FindLast() Then begin
                exit(BBGTaxRateBuffer."NON PAN TDS %");
            end;
        End;
    end;

    procedure InsertBBGTaxRateBuffer(Var TDSSection: Code[10])
    var
        TaxRateValue: Record "Tax Rate Value";
        TaxRateValue2: Record "Tax Rate Value";
        BBGTaxRateBuffer: Record "BBG Tax Rate Buffer";
    begin
        BBGTaxRateBuffer.DeleteAll();
        TaxRateValue.Reset();
        TaxRateValue.SetRange("Tax Type", 'TDS');
        TaxRateValue.SetRange("Column ID", 26);
        TaxRateValue.SetRange(Value, TDSSection);
        IF TaxRateValue.FindSet() then begin
            repeat
                TaxRateValue2.Reset();
                TaxRateValue2.SetRange("Config ID", TaxRateValue."Config ID");
                TaxRateValue2.SetFilter("Column ID", '<>%1', 26);
                TaxRateValue2.SetRange("Tax Type", 'TDS');
                IF TaxRateValue2.FindSet() then begin
                    BBGTaxRateBuffer.Init();
                    BBGTaxRateBuffer."Entry ID" := CreateGuid();
                    BBGTaxRateBuffer."TDS Section" := TaxRateValue.Value;
                    BBGTaxRateBuffer.Insert();
                    repeat
                        IF TaxRateValue2."Column ID" = 27 then
                            BBGTaxRateBuffer."Assessee Code" := TaxRateValue2.Value;
                        IF TaxRateValue2."Column ID" = 28 then
                            Evaluate(BBGTaxRateBuffer."Effective Date", TaxRateValue2.Value);
                        IF TaxRateValue2."Column ID" = 33 then Begin
                            Evaluate(BBGTaxRateBuffer."TDS %", TaxRateValue2.Value);
                            BBGTaxRateBuffer."PAN/NON PAN" := true;
                        End;
                        IF TaxRateValue2."Column ID" = 34 then Begin
                            Evaluate(BBGTaxRateBuffer."NON PAN TDS %", TaxRateValue2.Value);
                            BBGTaxRateBuffer."PAN/NON PAN" := false;
                        End;
                        BBGTaxRateBuffer.Modify();
                    until TaxRateValue2.Next() = 0;
                end;
            until TaxRateValue.Next() = 0;
        end;
    end;
    //-------Find TDS %---------<<

    //======= Codeunit 90 Purch.-Post ========Start>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnRunOnAfterFillTempLines, '', false, false)]
    local procedure OnRunOnAfterFillTempLines_PurchPost(sender: Codeunit "Purch.-Post"; var PurchHeader: Record "Purchase Header")
    var
        UnitSetup: Record "Unit Setup";
        vPurchHeader: Record "Purchase Header";
        vJobAllocationReq: Boolean;
        SingleJobAll: Boolean;
        POHdrL: Record "Purchase Header";
        DocTypSetup: Record "Document Type Setup";
        vJobAllocation: Record "Job Allocation";
        vPurchLine: Record "Purchase Line";
        vJobAmt: Decimal;
        JobAllCount: Integer;
    begin

        UnitSetup.GET;  //ALLEDK 101212

        IF NOT (PurchHeader."Posting No. Series" = UnitSetup."Posting Voucher No. Series") THEN BEGIN  //ALLEDK 101212
                                                                                                       //JPL22 START
            IF (PurchHeader."Document Type" = PurchHeader."Document Type"::Order) OR (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice)
              OR (PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo")
            THEN
                PurchHeader.TESTFIELD(Status, PurchHeader.Status::Released);
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN BEGIN
                IF PurchHeader."Order Ref. No." <> '' THEN BEGIN
                    vPurchHeader.GET(vPurchHeader."Document Type"::Order, PurchHeader."Order Ref. No.");
                    vPurchHeader.TESTFIELD(Status, vPurchHeader.Status::Released);
                END;
            END;

            //   IF "Document Type" = "Document Type"::Invoice THEN BEGIN
            //     DocInitiator.GET(DocInitiator."Document Type"::Invoice, "Sub Document Type"::" ", Initiator);
            //     IF UPPERCASE(DocInitiator."Posting User Code") <> UPPERCASE(USERID) THEN
            //         ERROR('Unauthorised user for posting this invoice!');
            // END;

            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN
                PurchHeader.TESTFIELD("Received Invoice Amount");
            vJobAllocationReq := FALSE;
            SingleJobAll := TRUE; //ALLEAA 301110
            IF PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice THEN BEGIN
                IF POHdrL.GET(POHdrL."Document Type"::Order, PurchHeader."Order Ref. No.") THEN BEGIN
                    //DocTypSetup.GET(DocTypSetup."Document Type"::"Purchase Order",POHdrL."Sub Document Type"); 051219
                    IF DocTypSetup."Job Allocation" THEN BEGIN
                        vJobAllocation.RESET;
                        vJobAllocation.SETRANGE("Document Type", PurchHeader."Document Type");
                        vJobAllocation.SETRANGE("Document No.", PurchHeader."No.");
                        IF vJobAllocation.FIND('-') THEN BEGIN
                            vJobAllocationReq := TRUE;
                            vPurchLine.RESET;
                            vPurchLine.SETCURRENTKEY(Type);  //JPL-OPt-01
                            vPurchLine.SETRANGE("Document Type", PurchHeader."Document Type");
                            vPurchLine.SETRANGE("Document No.", PurchHeader."No.");
                            vPurchLine.SETRANGE(Type, vPurchLine.Type::"G/L Account");
                            vPurchLine.SETFILTER(Amount, '<>0');
                            IF vPurchLine.FIND('-') THEN BEGIN
                                REPEAT
                                    vJobAmt := 0;
                                    vJobAllocation.RESET;
                                    vJobAllocation.SETRANGE("Document Type", PurchHeader."Document Type");
                                    vJobAllocation.SETRANGE("Document No.", PurchHeader."No.");
                                    vJobAllocation.SETRANGE("Line No.", vPurchLine."Line No.");
                                    IF vJobAllocation.FIND('-') THEN
                                        REPEAT
                                            //ALLEAA 301110
                                            JobAllCount := vJobAllocation.COUNT;
                                            IF JobAllCount > 1 THEN
                                                SingleJobAll := FALSE;
                                            vJobAllocation.TESTFIELD("GL Account No.");
                                            //ALLEAA 301110
                                            vJobAmt := vJobAmt + vJobAllocation.Amount;
                                        UNTIL vJobAllocation.NEXT = 0;
                                    IF vPurchLine."Line Amount" <> vJobAmt THEN
                                        ERROR('Job Allocation Amount and Line Amount does not match,' +
                                            'Job Allocation Amount = %1 and Line amount = %2', vJobAmt, vPurchLine."Line Amount");

                                UNTIL vPurchLine.NEXT = 0;
                            END;
                        END
                        ELSE
                            ERROR('Job Allocation not done');
                    END;
                END;
            END;
        END; //ALLEDK 101212
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", OnAfterPostPurchaseDoc, '', false, false)]
    local procedure OnAfterPostPurchaseDoc_PurchPost(PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean; PurchInvHdrNo: Code[20]; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var PurchaseHeader: Record "Purchase Header")
    var
    Begin
        IF PurchaseHeader.CommissionVoucher THEN  //ALLEDK 150213
            UpdateVoucherHeader(PurchaseHeader."No.");
        //ALLE-SR-081107 <<
    End;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostVendorEntry', '', false, false)]
    local procedure InsertTDSSectionCodeGenJnlLineOnPostLedgerEntryOnBeforeGenJnlPostLine(
           var GenJnlLine: Record "Gen. Journal Line";
           var PurchHeader: Record "Purchase Header")
    var
    Begin
        GenJnlLine."Application No." := PurchHeader."Application No.";
        if PurchHeader."Associate Posting Type" <> PurchHeader."Associate Posting Type"::" " then
            GenJnlLine."Posting Type" := PurchHeader."Associate Posting Type"
        Else
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;

        GenJnlLine."Ref. External Doc. No." := PurchHeader."Ref. External Doc. No."; //Added new code 15122025
    End;

    procedure UpdateVoucherHeader(VAR VoucherNo: Code[20])
    var
        Amt: Decimal;
        EligibleAmt: Decimal;
        VoucherHdr: Record "Assoc Pmt Voucher Header";
        VoucherLine: Record "Voucher Line";
        CommEntry: Record "Commission Entry";
        TVEntry: Record "Travel Payment Entry";
        IncEntry: Record "Incentive Summary";
    Begin
        Amt := 0;
        EligibleAmt := 0;
        VoucherHdr.RESET;
        VoucherHdr.SETRANGE("Document No.", VoucherNo);
        IF VoucherHdr.FINDFIRST THEN BEGIN
            VoucherHdr.Post := TRUE;
            VoucherHdr.MODIFY;
            IF NOT VoucherHdr."From MS Company" THEN BEGIN  //BBG2.01 110115

                IF VoucherHdr."Sub Type" = VoucherHdr."Sub Type"::Regular THEN BEGIN
                    //..........
                    VoucherLine.RESET;
                    VoucherLine.SETRANGE("Voucher No.", VoucherHdr."Document No.");
                    VoucherLine.SETRANGE(Type, VoucherLine.Type::Commission);
                    IF VoucherLine.FINDFIRST THEN BEGIN
                        REPEAT
                            Amt += VoucherLine.Amount;
                            EligibleAmt += VoucherLine."Eligible Amount";
                        UNTIL VoucherLine.NEXT = 0;
                        IF (EligibleAmt - Amt) >= 0 THEN BEGIN
                            CommEntry.RESET;
                            CommEntry.SETCURRENTKEY("Associate Code", "Posting Date");
                            CommEntry.SETRANGE("Associate Code", VoucherHdr."Paid To");
                            CommEntry.SETFILTER("Remaining Amount", '<>%1', 0);
                            IF CommEntry.FINDSET THEN BEGIN
                                REPEAT
                                    CommEntry."Remaining Amount" := 0;
                                    CommEntry.MODIFY;
                                UNTIL CommEntry.NEXT = 0;
                            END;
                            CLEAR(CommEntry);
                            CommEntry.RESET;
                            CommEntry.SETCURRENTKEY("Associate Code", "Posting Date");
                            CommEntry.SETRANGE("Associate Code", VoucherHdr."Paid To");
                            CommEntry.SETRANGE("Opening Entries", FALSE); //BBG1.00 090513
                                                                          //CommEntry.SETRANGE("Posting Date",0D,VoucherHdr."Commission Date");
                            IF CommEntry.FINDLAST THEN BEGIN
                                REPEAT
                                    CommEntry."Remaining Amount" := EligibleAmt - Amt;
                                    CommEntry.MODIFY;
                                UNTIL CommEntry.NEXT = 0;
                            END;
                        END;
                    END;
                    //-------------Commisison


                    Amt := 0;
                    EligibleAmt := 0;

                    VoucherLine.RESET;
                    VoucherLine.SETRANGE("Voucher No.", VoucherHdr."Document No.");
                    VoucherLine.SETRANGE(Type, VoucherLine.Type::TA);
                    IF VoucherLine.FINDFIRST THEN BEGIN
                        REPEAT
                            Amt += VoucherLine.Amount;
                            EligibleAmt += VoucherLine."Eligible Amount";
                        UNTIL VoucherLine.NEXT = 0;
                        IF (EligibleAmt - Amt) >= 0 THEN BEGIN
                            TVEntry.RESET;
                            TVEntry.SETCURRENTKEY("Sub Associate Code", "Creation Date");
                            TVEntry.SETRANGE("Sub Associate Code", VoucherHdr."Paid To");
                            TVEntry.SETFILTER("Remaining Amount", '<>%1', 0);
                            IF TVEntry.FINDSET THEN BEGIN
                                REPEAT
                                    TVEntry."Remaining Amount" := 0;
                                    TVEntry.MODIFY;
                                UNTIL TVEntry.NEXT = 0;
                            END;

                            CLEAR(TVEntry);
                            TVEntry.RESET;
                            TVEntry.SETCURRENTKEY("Sub Associate Code", "Creation Date");
                            TVEntry.SETRANGE("Sub Associate Code", VoucherHdr."Paid To");
                            IF TVEntry.FINDLAST THEN BEGIN
                                REPEAT
                                    TVEntry."Remaining Amount" := EligibleAmt - Amt;
                                    TVEntry.MODIFY;
                                UNTIL TVEntry.NEXT = 0;
                            END;
                        END;
                    END;


                    Amt := 0;
                    EligibleAmt := 0;


                    //--------------------Incentive
                    VoucherLine.RESET;
                    VoucherLine.SETRANGE("Voucher No.", VoucherHdr."Document No.");
                    VoucherLine.SETRANGE(Type, VoucherLine.Type::Incentive);
                    IF VoucherLine.FINDFIRST THEN BEGIN
                        REPEAT
                            Amt += VoucherLine.Amount;
                            EligibleAmt += VoucherLine."Eligible Amount";
                        UNTIL VoucherLine.NEXT = 0;
                        IF (EligibleAmt - Amt) >= 0 THEN BEGIN
                            IncEntry.RESET;
                            IncEntry.SETCURRENTKEY("Associate Code");
                            IncEntry.SETRANGE("Associate Code", VoucherHdr."Paid To");
                            IncEntry.SETFILTER("Remaining Amount", '<>%1', 0);
                            IF IncEntry.FINDSET THEN BEGIN
                                REPEAT
                                    IncEntry."Remaining Amount" := 0;
                                    IncEntry.MODIFY;
                                UNTIL IncEntry.NEXT = 0;
                            END;
                            CLEAR(IncEntry);
                            IncEntry.RESET;
                            IncEntry.SETCURRENTKEY("Associate Code");
                            IncEntry.SETRANGE("Associate Code", VoucherHdr."Paid To");
                            IF IncEntry.FINDLAST THEN BEGIN
                                REPEAT
                                    IncEntry."Remaining Amount" := EligibleAmt - Amt;
                                    IncEntry.MODIFY;
                                UNTIL IncEntry.NEXT = 0;
                            END;
                        END;
                    END;
                END;
            END;
        END;
    End;


    //======= Codeunit 90 Purch.-Post ========END<<
}