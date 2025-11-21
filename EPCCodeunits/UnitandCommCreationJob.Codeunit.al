codeunit 97726 "Unit and Comm. Creation Job"
{
    // //To Change
    // //Application Can be deleted now
    // 
    // //-Bond-and-Commission-
    // //Create Bond and Commission from Commission Buffer
    // //-RD-
    // //Create RD Payment Schedule Posted from RDPayment Schedule Buffer
    // //-MIS-
    // //Create MIS Payment Schedule Posted from MISPayment Schedule Buffer
    // //-Bonus-
    // //Create Bonus Entry Posted from Bonus Payment Posting Buffer
    // //-Commission-
    // //Create Commission Entry Posted from Commission Payment Posting Buffer
    // 
    // BBG1.00 ALLEDK 130313 Create new function for commission temporary report purpose. CreateBondandCommissionTemp


    trigger OnRun()
    begin
        IF GUIALLOWED THEN
            IF NOT CONFIRM('Start Job ?', FALSE) THEN
                EXIT;

        //CreateBondandCommission(;
        //COMMIT;

        /*
        CreateRDPmtSchPosted;
        COMMIT;
        
        CreateMISPmtSchPosted;
        COMMIT;
        
        CreateBonusEntryPosted;
        COMMIT;
        
        CreateCommissionEntryPosted;
        COMMIT;
         */

        Documentation;
        COMMIT;

        /*
        OpenCommforChequeEntries;
        COMMIT;
        
        CreateBonusforChequeEntries;
        COMMIT;
        
        
        CreateBondandCommissionOld;
        COMMIT;
        */

        IF GUIALLOWED THEN
            MESSAGE('Done');

    end;

    var
        BondPost: Codeunit "Unit Post";
        PostPayment: Codeunit PostPayment;
        ReleaseBondApplication: Codeunit "Release Unit Application";
        CommCreationBuffer1: Record "Unit & Comm. Creation Buffer";
        UnitSetup: Record "Unit Setup";
        RecConfOrder: Record "Confirmed Order";
        Amt: Decimal;
        RecUnitCommBufferEntry: Record "Unit & Comm. Creation Buffer";
        AppCode: Code[20];
        MinAmt: Decimal;
        ConfOrder: Record "Confirmed Order";
        AppPayEntry: Record "Application Payment Entry";
        NewConfiirmOrder: Record "New Confirmed Order";
        CommCreationBufferDel: Record "Unit & Comm. Creation Buffer";


    procedure "-Bond-and-Commission-"()
    begin
    end;


    procedure CreateBondandCommission(PostDate: Date; IntroducerCode: Code[20]; ConfOrdNo: Code[20]; BranchCode: Code[20]; ProjFilter: Code[20]; FromProjectChange: Boolean)
    var
        Application: Record Application;
        Bond: Record "Confirmed Order";
        CommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        NewCommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        RDPmtSchBuff: Record "Template Field";
        RDPmtSchPosted: Record "FD Payment Schedule Posted";
        TempApplication: Record Application temporary;
        CommEntry: Record "Commission Entry";
        oldCommEntry: Record "Commission Entry";
        CommissionStructrAmountBase: Record "Commission Structr Amount Base";
        v_UnitCommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        PPLANCode: Code[10];
        PmtTermsLines: Record "Payment Terms Line Sale";
        ProjectwisePPLanComm: Record "Project wise PPLAN Commission";
        RecNewConforder: Record "Confirmed Order";
        ProjCode: code[20];
        DOJ: Date;
        TotalcommAmt: Decimal;
        UnitNo: Code[20];
        TotalBSAmt: Decimal;
        Amountupdate: Boolean;
        PreviousBSAmt: Decimal;
        RecNewCommEntry: Record "Commission Entry";
        TotalCommBaseAmt: Decimal;
        NewCommCreationBuffer_1: Record "Unit & Comm. Creation Buffer";
        NewCommCreationBuffer_2: Record "Unit & Comm. Creation Buffer";
        NEWUPEntry_2: Record "Unit Payment Entry";
        Newminamt: Decimal;

    begin
        UnitSetup.GET;
        IF UnitSetup."Commission Batch Run Date" <> 0D THEN
            PostDate := UnitSetup."Commission Batch Run Date";

        //Create Bond and Commission from Commission Buffer
        //Code added Start 26092025

        NewCommCreationBuffer_1.RESET;
        IF ConfOrdNo <> '' THEN
            NewCommCreationBuffer_1.SETRANGE("Unit No.", ConfOrdNo);

        IF BranchCode <> '' THEN
            NewCommCreationBuffer_1.SETRANGE("Branch Code", BranchCode);

        IF ProjFilter <> '' THEN
            NewCommCreationBuffer_1.SETRANGE("Shortcut Dimension 1 Code", ProjFilter);

        NewCommCreationBuffer_1.SETRANGE("Posting Date", 20010409D, PostDate);  //ALLEDK 1801
        NewCommCreationBuffer_1.SETRANGE("Min. Allotment Amount Not Paid", True);
        NewCommCreationBuffer_1.SETRANGE("Cheque not Cleared", FALSE);
        NewCommCreationBuffer_1.SETRANGE("Commission Created", FALSE);
        NewCommCreationBuffer_1.SETRANGE("Opening Commision Adj.", FALSE);
        NewCommCreationBuffer_1.SETRANGE("Comm Not Release after FullPmt", FALSE);  //ALLE 301014
        IF (IntroducerCode <> '') AND (IntroducerCode <> 'IBA9999999') THEN
            NewCommCreationBuffer_1.SETRANGE("Introducer Code", IntroducerCode)
        ELSE
            NewCommCreationBuffer_1.SETFILTER("Introducer Code", '<>%1', 'IBA9999999');
        IF NewCommCreationBuffer_1.FINDSET THEN
            REPEAT

                MinAmt := 0;
                RecConfOrder.RESET;
                IF RecConfOrder.GET(NewCommCreationBuffer_1."Application No.") THEN begin
                    MinAmt := CheckMinAmount(PostDate, IntroducerCode, NewCommCreationBuffer_1."Application No.");
                    IF MinAmt >= RecConfOrder."Min. Allotment Amount" THEN BEGIN
                        NewCommCreationBuffer_1."Min. Allotment Amount Not Paid" := False;
                        NewCommCreationBuffer_1.Modify;
                    end;
                END;


            Until NewCommCreationBuffer_1.Next = 0;


        //Code Added End 26092025
        CommCreationBuffer.RESET;
        IF ConfOrdNo <> '' THEN
            CommCreationBuffer.SETRANGE("Unit No.", ConfOrdNo);

        IF BranchCode <> '' THEN
            CommCreationBuffer.SETRANGE("Branch Code", BranchCode);

        IF ProjFilter <> '' THEN
            CommCreationBuffer.SETRANGE("Shortcut Dimension 1 Code", ProjFilter);

        CommCreationBuffer.SETRANGE("Posting Date", 20010409D, PostDate);  //ALLEDK 1801
        CommCreationBuffer.SETRANGE(CommCreationBuffer."Min. Allotment Amount Not Paid", FALSE);
        CommCreationBuffer.SETRANGE(CommCreationBuffer."Cheque not Cleared", FALSE);
        CommCreationBuffer.SETRANGE(CommCreationBuffer."Commission Created", FALSE);
        CommCreationBuffer.SETRANGE("Opening Commision Adj.", FALSE);
        CommCreationBuffer.SETRANGE("Comm Not Release after FullPmt", FALSE);  //ALLE 301014
        IF (IntroducerCode <> '') AND (IntroducerCode <> 'IBA9999999') THEN
            CommCreationBuffer.SETRANGE(CommCreationBuffer."Introducer Code", IntroducerCode)
        ELSE
            CommCreationBuffer.SETFILTER(CommCreationBuffer."Introducer Code", '<>%1', 'IBA9999999');
        IF CommCreationBuffer.FINDSET THEN
            REPEAT
                MinAmt := 0;
                RecConfOrder.RESET;
                RecConfOrder.SETRANGE("No.", CommCreationBuffer."Application No.");
                RecConfOrder.SETFILTER(Status, '<>%1', RecConfOrder.Status::Cancelled);  //ALLEDK 170213
                IF FromProjectChange = FALSE THEN
                    RecConfOrder.SETRANGE("Commission Not Generate", FALSE);
                RecConfOrder.SETRANGE("Comm hold for Old Process", FALSE);  //140219
                IF CommCreationBuffer."Direct Associate" then  //Code added 01072025
                    RecConfOrder.SetRange("Registration Bouns (BSP2)", True);  //Code added 01072025
                IF RecConfOrder.FINDFIRST THEN BEGIN
                    MinAmt := CheckMinAmount(PostDate, IntroducerCode, CommCreationBuffer."Application No.");
                    IF MinAmt >= RecConfOrder."Min. Allotment Amount" THEN BEGIN
                        //ALLEDK 251212
                        CommCreationBuffer."Bond Created" := TRUE;
                        CommCreationBuffer.MODIFY;
                        IF CommCreationBuffer."Bond Created" THEN
                            CommCreationBuffer.MARK(TRUE);
                        //251023
                        //280425 code commented start New commission stru amount base
                        PPLANCode := '';
                        //PPLANCode := ReleaseUnitApplication.CheckUnitPaymentPlan(RecConfOrder."Shortcut Dimension 1 Code",RecConfOrder."No.");
                        CommissionStructrAmountBase.RESET;
                        CommissionStructrAmountBase.SETRANGE("Project Code", RecConfOrder."Shortcut Dimension 1 Code");
                        CommissionStructrAmountBase.SETRANGE("Payment Plan Code", RecConfOrder."Unit Payment Plan");
                        CommissionStructrAmountBase.SETFILTER("Start Date", '<=%1', RecConfOrder."Posting Date");
                        CommissionStructrAmountBase.SETFILTER("End Date", '>=%1', RecConfOrder."Posting Date");
                        CommissionStructrAmountBase.SetRange("Rank Code", RecConfOrder."Region Code");  //Code added 01072025
                                                                                                        //CommissionStructrAmountBase.SETFILTER("Payment Plan Code", PPLANCode);  //071223   //03062025
                        IF CommissionStructrAmountBase.FINDFIRST THEN BEGIN
                            IF NOT CommCreationBuffer."Commission Created" THEN BEGIN
                                IF FromProjectChange = FALSE THEN BEGIN

                                    BondPost.CalculateComissionNew(CommCreationBuffer, PostDate);
                                    //280425 code commented start

                                    //   v_UnitCommCreationBuffer.RESET;
                                    //   v_UnitCommCreationBuffer.SETRANGE("Unit No.",RecConfOrder."No.");
                                    //   IF v_UnitCommCreationBuffer.FINDSET THEN
                                    //     REPEAT
                                    //       v_UnitCommCreationBuffer."Commission Created" := TRUE;
                                    //       v_UnitCommCreationBuffer.MODIFY;
                                    //     UNTIL v_UnitCommCreationBuffer.NEXT = 0;
                                    //280425 code commented END
                                END;
                            END;

                            //251023

                        END ELSE BEGIN
                            //*/ //280425 code Open 

                            //Commission Creation
                            IF NOT CommCreationBuffer."Commission Created" THEN BEGIN
                                IF FromProjectChange = FALSE THEN
                                    BondPost.CalculateComissionNew(CommCreationBuffer, PostDate)
                                ELSE BEGIN
                                    oldCommEntry.RESET;
                                    oldCommEntry.SETCURRENTKEY("Commission Run Date");
                                    oldCommEntry.SETFILTER("Commission Run Date", '<>%1', 0D);
                                    IF oldCommEntry.FINDLAST THEN;

                                    BondPost.CalculateComissionNew(CommCreationBuffer, oldCommEntry."Commission Run Date");
                                END;
                            END;
                            IF CommCreationBuffer."Installment No." > 1 THEN
                                CommCreationBuffer.MARK(TRUE);
                            //ALLEDK 180113
                        END;    //Codecommented  22123
                    END;
                END;
            UNTIL CommCreationBuffer.NEXT = 0;

        //Clear Buffer Table
        CommCreationBufferDel.RESET;
        CommCreationBufferDel.SETCURRENTKEY(CommCreationBufferDel."Commission Created");
        CommCreationBufferDel.SETRANGE("Commission Created", TRUE);
        IF CommCreationBufferDel.FINDSET THEN
            REPEAT
                CommCreationBufferDel.DELETEALL;
            UNTIL CommCreationBufferDel.NEXT = 0;

        //  CommCreationBuffer.MARKEDONLY(TRUE);
        //CommCreationBuffer.DELETEALL;

        IF TempApplication.FINDSET THEN
            REPEAT
                IF Application.GET(TempApplication."Application No.") THEN
                    Application.DELETE;
            UNTIL TempApplication.NEXT = 0;

        COMMIT;

    end;


    procedure CreateBond(var
                             Application: Record Application;

    var
        BondCommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        CreateOnlyBond: Boolean)
    var
        Bond: Record "Confirmed Order";
        ApplCommentLine: Record "Comment Line";
        BondCommentLine: Record "Comment Line";
        ComissionPostingBuffer: Record "Unit & Comm. Creation Buffer";
        BondDispute: Record "Document Tracking";
    begin
        //Create Bond
        Bond.INIT;
        Bond."No." := Application."Unit No.";
        Bond."Scheme Code" := Application."Scheme Code";
        Bond."Project Type" := Application."Project Type";
        Bond.Duration := Application.Duration;
        Bond."Customer No." := Application."Customer No.";
        Bond."Introducer Code" := Application."Associate Code";
        Bond."Maturity Date" := Application."Maturity Date";
        Bond."Maturity Amount" := Application."Maturity Amount";
        Bond."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
        Bond."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
        Bond."Application No." := Application."Application No.";
        Bond.Type := Application.Type;
        IF BondDispute.GET(Application."Unit No.") THEN
            Bond.Status := Bond.Status::Documented
        ELSE
            Bond.Status := Bond.Status::Open;
        Bond."User Id" := Application."User ID";
        Bond.Amount := Application."Investment Amount" + Application."Discount Amount";
        Bond."Posting Date" := Application."Posting Date";
        Bond."Document Date" := Application."Document Date";
        Bond."Investment Frequency" := Application."Investment Frequency";
        Bond."Return Frequency" := Application."Return Frequency";
        Bond."Service Charge Amount" := Application."Service Charge Amount";
        Bond."Bond Category" := Application.Category;
        Bond."Posted Doc No." := Application."Posted Doc No.";
        Bond."Discount Amount" := Application."Discount Amount";
        Bond."Return Payment Mode" := Application."Return Payment Mode";
        Bond."Received From" := Bond."Received From"::"Marketing Member";
        Bond."Received From Code" := Application."Received From Code";
        Bond."Version No." := Application."Scheme Version No.";
        Bond."Maturity Bonus Amount" := Application."Maturity Bonus Amount";
        Bond."Bond Posting Group" := Application."Bond Posting Group";
        //Bond."Creation Time" := TIME; //ALLETDK
        Bond."Creation Time" := Application."Creation Time"; //ALLETDK
        Bond."Creation Date" := Application."Creation Date"; //ALLETDK
        Bond."Investment Type" := Application."Investment Type";
        Bond."Return Amount" := Application."Return Amount";
        Bond."With Cheque" := Application."With Cheque";
        Bond."Unit Code" := Application."Unit Code";
        Bond."Min. Allotment Amount" := Application."Min. Allotment Amount";
        Bond."Saleable Area" := Application."Saleable Area";
        Bond."Branch Code" := Application."Branch Code";  //ALLEDK 161212
        Bond."Payment Plan" := Application."Payment Plan";
        Bond."Pass Book No." := Application."Pass Book No."; //ALLETDK010313
        Bond."Commission Hold on Full Pmt" := TRUE;
        Bond."Project Type" := Application."Project Type";  //Code added 01072025
        Bond."Region Code" := Application."Rank Code";  //Code added 01072025
        Bond."Travel applicable" := Application."Travel applicable";  //Code added 01072025
        Bond."Registration Bouns (BSP2)" := Application."Registration Bouns (BSP2)";  //Code added 01072025
        //Code added Start 23072025
        Bond."District Code" := Application."District Code";
        Bond."Customer State Code" := Application."Customer State Code";
        Bond."Mandal Code" := Application."Mandal Code";
        Bond."Village Code" := Application."Village Code";

        //Code added END 23072025

        Bond.INSERT;

        ReleaseBondApplication.InsertBondHistory(Application."Unit No.", 'Unit Created.', 0, Application."Application No.");

        //Comment Line Creation;
        ApplCommentLine.RESET;
        ApplCommentLine.SETRANGE("Table Name", ApplCommentLine."Table Name"::"Activity Master");
        ApplCommentLine.SETRANGE("No.", Application."Application No.");
        IF ApplCommentLine.FINDSET THEN
            REPEAT
                BondCommentLine.INIT;
                BondCommentLine.TRANSFERFIELDS(ApplCommentLine);
                BondCommentLine."Table Name" := BondCommentLine."Table Name"::"Confirmed order";
                BondCommentLine."No." := Application."Unit No.";
                BondCommentLine.INSERT;
            UNTIL ApplCommentLine.NEXT = 0;

        Application.Status := Application.Status::Converted;
        Application.MODIFY;

        BondCommCreationBuffer."Bond Created" := TRUE;
        BondCommCreationBuffer.MODIFY;

        //Create Bond Payment Entry
        CreateBondPaymentEntry(Application);
        CreateAppPaymentEntry(Application);

        ChangeDocumentationStatus(Application."Unit No.");

        IF CreateOnlyBond THEN
            EXIT;

        CreatePaymentSchedule(Application);

        CreateApplicationBondLedger(Application);

        //Delete Application Payment Entry
        DeleteApplicationPaymentEntry(Application);
        DeleteAppPaymentEntry(Application);
    end;


    procedure CreateBondPaymentEntry(var Application: Record Application)
    var
        ApplicationPaymentEntry: Record "Unit Payment Entry";
        BondPaymentEntry: Record "Unit Payment Entry";
    begin
        ApplicationPaymentEntry.RESET;
        ApplicationPaymentEntry.SETRANGE("Document Type", ApplicationPaymentEntry."Document Type"::Application);
        ApplicationPaymentEntry.SETRANGE("Document No.", Application."Application No.");
        IF ApplicationPaymentEntry.FINDSET THEN BEGIN
            REPEAT
                BondPaymentEntry := ApplicationPaymentEntry;
                BondPaymentEntry."Document Type" := BondPaymentEntry."Document Type"::BOND;
                BondPaymentEntry."Document No." := Application."Unit No.";
                BondPaymentEntry."Created from Application" := TRUE;
                BondPaymentEntry.INSERT;
            UNTIL ApplicationPaymentEntry.NEXT = 0;
        END;
    end;


    procedure DeleteApplicationPaymentEntry(var Application: Record Application)
    var
        ApplicationPaymentEntry: Record "Unit Payment Entry";
    begin
        ApplicationPaymentEntry.RESET;
        ApplicationPaymentEntry.SETRANGE("Document Type", ApplicationPaymentEntry."Document Type"::Application);
        ApplicationPaymentEntry.SETRANGE("Document No.", Application."Application No.");
        ApplicationPaymentEntry.DELETEALL;
    end;


    procedure CreateAppPaymentEntry(var Application: Record Application)
    var
        ApplicationPaymentEntry: Record "Application Payment Entry";
        BondPaymentEntry: Record "Application Payment Entry";
    begin
        ApplicationPaymentEntry.RESET;
        ApplicationPaymentEntry.SETRANGE("Document Type", ApplicationPaymentEntry."Document Type"::Application);
        ApplicationPaymentEntry.SETRANGE("Document No.", Application."Application No.");
        IF ApplicationPaymentEntry.FINDSET THEN BEGIN
            REPEAT
                BondPaymentEntry := ApplicationPaymentEntry;
                BondPaymentEntry."Document Type" := BondPaymentEntry."Document Type"::BOND;
                BondPaymentEntry."Document No." := Application."Unit No.";
                BondPaymentEntry."Created From Application" := TRUE;    //ALLEDK 091012
                BondPaymentEntry.INSERT;
            UNTIL ApplicationPaymentEntry.NEXT = 0;
        END;
    end;


    procedure DeleteAppPaymentEntry(var Application: Record Application)
    var
        ApplicationPaymentEntry: Record "Application Payment Entry";
    begin
        ApplicationPaymentEntry.RESET;
        ApplicationPaymentEntry.SETRANGE("Document Type", ApplicationPaymentEntry."Document Type"::Application);
        ApplicationPaymentEntry.SETRANGE("Document No.", Application."Application No.");
        ApplicationPaymentEntry.DELETEALL;
    end;


    procedure CreatePaymentSchedule(var Application: Record Application)
    var
        RDPaymentSchedule: Record Terms;
        MISPaymentSchedule: Record "MIS Payment Schedule";
        MISPaymentSchedulePosted: Record "FD Payment Schedule Posted";
        RDPaymentSchedulePosted: Record "FD Payment Schedule Posted";
        FDPaymentSchedulePosted: Record "FD Payment Schedule Posted";
        PostedPmtSChReqd: Boolean;
    begin
        //Payment Schedule Creation
        IF Application."Investment Type" = Application."Investment Type"::RD THEN BEGIN
            //RD Pmt Sch Exists or not
            /*
            RDPaymentSchedule.RESET;
            RDPaymentSchedule.SETRANGE("No.",Application."Bond No.");
            IF RDPaymentSchedule.ISEMPTY THEN
              PostPayment.GeneratePaymentScheduleForRD(Application);

            //RD Pmt Sch Posted Exists or not
            RDPaymentSchedulePosted.RESET;
            RDPaymentSchedulePosted.SETRANGE("Bond No.",Application."Bond No.");
            IF RDPaymentSchedulePosted.ISEMPTY THEN
              PostedPmtSChReqd := TRUE;
              */
        END ELSE
            IF Application."Investment Type" = Application."Investment Type"::MIS THEN BEGIN
                //MIS Pmt Sch Exists or not
                MISPaymentSchedule.RESET;
                MISPaymentSchedule.SETRANGE("Unit No.", Application."Unit No.");
                IF MISPaymentSchedule.ISEMPTY THEN
                    PostPayment.GeneratePaymentScheduleForMIS(Application);

                //MIS Pmt Sch Posted Exists or not
                MISPaymentSchedulePosted.RESET;
                MISPaymentSchedulePosted.SETRANGE("Unit No.", Application."Unit No.");
                IF MISPaymentSchedulePosted.ISEMPTY THEN
                    PostedPmtSChReqd := TRUE;
            END ELSE
                IF Application."Investment Type" = Application."Investment Type"::FD THEN BEGIN
                    //FD Pmt Sch Posted Exists or not
                    FDPaymentSchedulePosted.RESET;
                    FDPaymentSchedulePosted.SETRANGE("Unit No.", Application."Unit No.");
                    IF FDPaymentSchedulePosted.ISEMPTY THEN
                        PostedPmtSChReqd := TRUE;
                END;

        IF PostedPmtSChReqd THEN BEGIN
            PostPayment.GeneratePaymentScheduleNewBusi(Application, 1, 1, USERID);
            ReleaseBondApplication.InsertBondHistory(Application."Unit No.", 'Payment Schedule Created.', 0, Application."Application No.");
        END;

    end;


    procedure CreateApplicationBondLedger(var Application: Record Application)
    var
        BondLedgerEntry: Record "Unit Ledger Entry";
        BondLedgerLastLine: Integer;
    begin
        BondLedgerEntry.RESET;
        BondLedgerEntry.SETRANGE("Unit No.", Application."Unit No.");
        IF NOT BondLedgerEntry.ISEMPTY THEN
            EXIT;

        //Get Bond Ledger Last Entry
        BondLedgerLastLine := GetBondLedgerLastLine(Application."Unit No.") + 10000;

        BondLedgerEntry.INIT;
        BondLedgerEntry."Line No." := BondLedgerLastLine;
        BondLedgerEntry."Investment Type" := Application."Investment Type";
        BondLedgerEntry."Document No." := Application."Posted Doc No.";
        BondLedgerEntry."Posting Date" := Application."Posting Date";
        BondLedgerEntry."Document Date" := Application."Document Date";
        BondLedgerEntry."Due Date" := Application."Posting Date";
        BondLedgerEntry."Unit No." := Application."Unit No.";
        BondLedgerEntry."Project Type" := Application."Project Type";
        BondLedgerEntry."Scheme Code" := Application."Scheme Code";
        BondLedgerEntry."Version No." := Application."Scheme Version No.";
        BondLedgerEntry."Bond Category" := Application.Category;
        BondLedgerEntry."Customer No." := Application."Customer No.";
        BondLedgerEntry."Associate Code" := Application."Associate Code";
        BondLedgerEntry.Duration := Application.Duration;
        BondLedgerEntry."Installment No." := 1;
        BondLedgerEntry."Original Amount" := (Application."Investment Amount" + Application."Discount Amount");
        BondLedgerEntry."Discount Amount" := Application."Discount Amount";
        BondLedgerEntry."Shortcut Dimension 1 Code" := Application."Shortcut Dimension 1 Code";
        BondLedgerEntry."Shortcut Dimension 2 Code" := Application."Shortcut Dimension 2 Code";
        BondLedgerEntry."User ID" := USERID;
        BondLedgerEntry.INSERT;

        ReleaseBondApplication.InsertBondHistory(Application."Unit No.", 'Unit Ledger Created.', 0, Application."Application No.");
    end;


    procedure "-RD-"()
    begin
    end;


    procedure CreateRDPmtSchPosted()
    var
        RDPmtSchBuff: Record "Template Field";
        RDPmtSch: Record Terms;
        RDPmtSchPosted: Record "FD Payment Schedule Posted";
        RPPaymentCons: Record "Insurance Detail";
    begin
    end;


    procedure InsertRDPmtSchPosted(var RDPmtSchBuff: Record "Template Field"; var RDPmtSch: Record Terms)
    var
        LineNo: Integer;
    begin
        /*
        LineNo := (GetLastLineNoRDPmtSchPosted(RDPmtSchBuff,RDPmtSch,RDPmtSchPosted) + 1);
        
        RDPmtSchPosted.INIT;
        RDPmtSchPosted."Bond No." := RDPmtSch."Document Type";
        RDPmtSchPosted."Line No." := LineNo;
        RDPmtSchPosted."Installment No." := RDPmtSch."Installment No.";
        RDPmtSchPosted."Entry Type" := RDPmtSchBuff."Entry Type";
        RDPmtSchPosted."Scheme Code" := RDPmtSch."Document No.";
        RDPmtSchPosted."Bond Type" := RDPmtSch."Line No.";
        RDPmtSchPosted."Bond Holder No." := RDPmtSch."Term Type";
        RDPmtSchPosted.Duration := RDPmtSch.Narration;
        RDPmtSchPosted."Bond Posting Group" := RDPmtSchBuff.RelationTableNo;
        RDPmtSchPosted."Payment Mode" := RDPmtSchBuff.RelationTableFieldNo;
        RDPmtSchPosted."Installment Amount" := RDPmtSchBuff.Active;
        RDPmtSchPosted."Original Amount" := (RDPmtSchBuff.Active + RDPmtSchBuff."Discount Amount");
        RDPmtSchPosted."Discount Amount" := RDPmtSch."Discount Amount";
        RDPmtSchPosted."Due Date" := RDPmtSch."Due Date";
        //RDPmtSchPosted."Interest Amount" :=
        RDPmtSchPosted."Introducer Code" := RDPmtSch."Introducer Code";
        RDPmtSchPosted."Shortcut Dimension 1 Code" := RDPmtSchBuff."Shortcut Dimension 1 Code";
        RDPmtSchPosted."Shortcut Dimension 2 Code" := RDPmtSchBuff."Shortcut Dimension 2 Code";
        RDPmtSchPosted."Year Code" := RDPmtSch."Year Code";
        RDPmtSchPosted."Posted Doc. No." := RDPmtSchBuff."Posted Doc. No.";
        //RDPmtSchPosted."Bond Date" :=
        RDPmtSchPosted."Investment Frequency" := RDPmtSchBuff."Investment Frequency";
        RDPmtSchPosted."Bond Category" := RDPmtSch."Bond Category";
        RDPmtSchPosted."Paid To/Received From" := RDPmtSchBuff."Paid To/Received From";
        RDPmtSchPosted."Paid To/Received From Code" := RDPmtSchBuff."Paid To/Received From Code";
        RDPmtSchPosted."Posting Date" := RDPmtSchBuff."Posting Date";
        RDPmtSchPosted."Late Charge" := RDPmtSchBuff."Late Charge";
        RDPmtSchPosted."Unit Office Code(Paid)" := RDPmtSchBuff."Shortcut Dimension 1 Code";
        RDPmtSchPosted."Counter Code(Paid)" := RDPmtSchBuff."Shortcut Dimension 2 Code";
        //RDPmtSchPosted."Introducer Rank" :=
        RDPmtSchPosted."Version No." := RDPmtSchBuff."Version No.";
        RDPmtSchPosted."Document Date" := RDPmtSchBuff."Document Date";
        RDPmtSchPosted."Posted By User ID" := RDPmtSchBuff."User ID";
        RDPmtSchPosted."Cheque No." := RDPmtSchBuff."Cheque No.";
        RDPmtSchPosted."Cheque Date" := RDPmtSchBuff."Cheque Date";
        RDPmtSchPosted."Cheque Clearance Date" := RDPmtSchBuff."Cheque Clearance Date";
        RDPmtSchPosted.INSERT;
         */

    end;


    procedure GetLastLineNoRDPmtSchPosted(var RDPmtSchBuff: Record "Template Field"; var RDPmtSch: Record Terms): Integer
    var
        LineNo: Integer;
    begin

        /*RDPmtSchPosted.RESET;
        RDPmtSchPosted.SETRANGE("Bond No.",RDPmtSchBuff."Template Name");
        //RDPmtSchPosted.SETRANGE("Line No.",RDPmtSchBuff."Installment No.");
        IF RDPmtSchPosted.FINDLAST THEN
          LineNo := RDPmtSchPosted."Line No.";
        EXIT(LineNo);
         */

    end;


    procedure InsertRDBondLedger(var RDPmtSchBuff: Record "Template Field")
    var
        BondLedgerEntry: Record "Unit Ledger Entry";
        BondLedgerLastLine: Integer;
    begin
        /*
        //Get Bond Ledger Last Entry
        BondLedgerLastLine := GetBondLedgerLastLine(RDPmtSchPosted."Bond No.") + 10000;
        
        BondLedgerEntry.INIT;
        BondLedgerEntry."Line No." := BondLedgerLastLine;
        BondLedgerEntry."Investment Type" := BondLedgerEntry."Investment Type"::RD;
        BondLedgerEntry."Document No." := RDPmtSchPosted."Posted Doc. No.";
        BondLedgerEntry."Posting Date" := RDPmtSchPosted."Posting Date";
        BondLedgerEntry."Document Date" := RDPmtSchPosted."Document Date";
        BondLedgerEntry."Due Date" := RDPmtSchPosted."Due Date";
        BondLedgerEntry."Bond No." := RDPmtSchPosted."Bond No.";
        BondLedgerEntry."Bond Type" := RDPmtSchPosted."Bond Type";
        BondLedgerEntry."Scheme Code" := RDPmtSchPosted."Scheme Code";
        BondLedgerEntry."Version No." := RDPmtSchPosted."Version No.";
        BondLedgerEntry."Bond Category" := RDPmtSchPosted."Bond Category";
        BondLedgerEntry."Bond Holder No." := RDPmtSchPosted."Bond Holder No.";
        BondLedgerEntry."MM Code" := RDPmtSchPosted."Introducer Code";
        BondLedgerEntry.Duration := RDPmtSchPosted.Duration;
        BondLedgerEntry."Installment No." := RDPmtSchPosted."Installment No.";
        BondLedgerEntry."Original Amount" := RDPmtSchPosted."Original Amount";
        BondLedgerEntry."Discount Amount" := RDPmtSchPosted."Discount Amount";
        BondLedgerEntry."Late Fine" := RDPmtSchPosted."Late Charge";
        BondLedgerEntry."Cheque Clearance Date" := RDPmtSchBuff."Cheque Clearance Date";
        BondLedgerEntry."Shortcut Dimension 1 Code" := RDPmtSchPosted."Shortcut Dimension 1 Code";
        BondLedgerEntry."Shortcut Dimension 2 Code" := RDPmtSchPosted."Shortcut Dimension 2 Code";
        BondLedgerEntry."User ID" := RDPmtSchPosted."Posted By User ID";
        BondLedgerEntry.INSERT;
        */

    end;


    procedure "-MIS-"()
    begin
    end;


    procedure CreateMISPmtSchPosted()
    var
        MISPmtSchBuff: Record "Project Budget Line Buffer";
        MISPmtSch: Record "MIS Payment Schedule";
        MISPmtSchPosted: Record "FD Payment Schedule Posted";
        MISPaymentConsolidated: Record "Document Setup";
    begin
    end;


    procedure InsertMISPmtSchPosted(var MISPmtSchBuff: Record "Project Budget Line Buffer"; var MISPmtSch: Record "MIS Payment Schedule"; var MISPmtSchPosted: Record "FD Payment Schedule Posted")
    var
        LineNo: Integer;
    begin
        /*
        LineNo := (GetLastLineNoMISPmtSchPosted(MISPmtSchBuff,MISPmtSch,MISPmtSchPosted) + 1);
        
        MISPmtSchPosted.INIT;
        MISPmtSchPosted."Bond No." := MISPmtSch."Bond No.";
        MISPmtSchPosted."Line No." := LineNo;
        //MISPaymentSchedulePosted."Line No." := MISPmtSchBuff."Line No.";
        MISPmtSchPosted."Installment No." := MISPmtSch."Installment No.";
        MISPmtSchPosted."Entry Type" := MISPmtSchBuff."Task Code";
        MISPmtSchPosted."Scheme Code" := MISPmtSch."Scheme Code";
        MISPmtSchPosted."Bond Type" := MISPmtSch."Bond Type";
        MISPmtSchPosted."Bond Holder No." := MISPmtSch."Customer No.";
        MISPmtSchPosted.Duration := MISPmtSch.Duration;
        MISPmtSchPosted."Bond Posting Group" := MISPmtSchBuff."No.";
        MISPmtSchPosted."Payment Mode" := MISPmtSchBuff."Starting Date";
        MISPmtSchPosted."Due Date" := MISPmtSch."Due Date";
        MISPmtSchPosted."Interest Amount" := MISPmtSch."Interest Amount";
        MISPmtSchPosted."Introducer Code" := MISPmtSch."Introducer Code";
        MISPmtSchPosted."Year Code" := MISPmtSch."Year Code";
        MISPmtSchPosted."Posted Doc. No." := MISPmtSchBuff."Posted Doc. No.";
        MISPmtSchPosted."Bond Category" := MISPmtSch."Return Frequency";
        MISPmtSchPosted."Paid To/Received From" := MISPmtSchBuff.Description;
        MISPmtSchPosted."Paid To/Received From Code" := MISPmtSchBuff.Quantity;
        MISPmtSchPosted."Posting Date" := MISPmtSchBuff."Direct Unit Cost";
        MISPmtSchPosted."Unit Office Code(Paid)" := MISPmtSchBuff."Unit Cost";
        MISPmtSchPosted."Counter Code(Paid)" := MISPmtSchBuff."Counter Code(Paid)";
        MISPmtSchPosted."Document Date" := MISPmtSchBuff."Unit Price";
        MISPmtSchPosted."Posted By User ID" := MISPmtSchBuff."Posted By User ID";
        MISPmtSchPosted."Entry Type" := MISPmtSchBuff."Cheque Date";
        MISPmtSchPosted."Cheque Date" := MISPmtSchBuff."Cheque No.";
        MISPmtSchPosted."Payment A/C Code" := MISPmtSchBuff."Payment A/C Code";
        //MISPmtSchPosted."Bank Code" := MISPmtSch."Bank Code";
        MISPmtSchPosted.INSERT;
         */

    end;


    procedure GetLastLineNoMISPmtSchPosted(var MISPmtSchBuff: Record "Project Budget Line Buffer"; var MISPmtSch: Record "MIS Payment Schedule"; var MISPmtSchPosted: Record "FD Payment Schedule Posted"): Integer
    var
        LineNo: Integer;
    begin
        MISPmtSchPosted.RESET;
        MISPmtSchPosted.SETRANGE("Unit No.", MISPmtSchBuff."Job No.");
        //MISPmtSchPosted.SETRANGE("Line No.",MISPmtSchBuff."Installment No.");
        IF MISPmtSchPosted.FINDLAST THEN
            LineNo := MISPmtSchPosted."Line No.";
        EXIT(LineNo);
    end;


    procedure "-Bonus-"()
    begin
    end;


    procedure CreateBonusEntryPosted()
    var
        BonusPmtPostBuffer: Record "Bonus Posting Buffer";
        BonusEntry: Record "Bonus Entry";
        BonusEntryPosted: Record "Bonus Entry Posted";
        BondToken: Record "Vendor Enquiry Details";
        PostedEntryNo: Integer;
    begin
    end;


    procedure InsertBonusEntryPosted(var BonusPmtPostBuffer: Record "Bonus Posting Buffer"; var BonusEntry: Record "Bonus Entry"; var BonusEntryPosted: Record "Bonus Entry Posted"; PostedEntryNo: Integer)
    begin
        BonusEntryPosted.INIT;
        BonusEntryPosted."Entry No." := PostedEntryNo;  //BonusEntry."Entry No.";
        BonusEntryPosted."Unit No." := BonusEntry."Unit No.";
        BonusEntryPosted."Posting Date" := BonusEntry."Posting Date";
        BonusEntryPosted."Associate Code" := BonusEntry."Associate Code";
        BonusEntryPosted."Base Amount" := BonusEntry."Base Amount";
        BonusEntryPosted."Bonus %" := BonusEntry."Bonus %";
        BonusEntryPosted."Bonus Amount" := BonusEntry."Bonus Amount";
        BonusEntryPosted."Installment No." := BonusEntry."Installment No.";
        BonusEntryPosted."Bond Category" := BonusEntry."Bond Category";
        BonusEntryPosted."Business Type" := BonusEntry."Business Type";
        BonusEntryPosted."Introducer Code" := BonusEntry."Introducer Code";
        BonusEntryPosted."Scheme Code" := BonusEntry."Scheme Code";
        BonusEntryPosted."Project Type" := BonusEntry."Project Type";
        BonusEntryPosted.Duration := BonusEntry.Duration;
        BonusEntryPosted."Paid To" := BonusPmtPostBuffer."Paid To";
        BonusEntryPosted."Posted Doc. No." := BonusPmtPostBuffer."Posted Doc. No.";
        BonusEntryPosted."Shortcut Dimension 1 Code" := BonusEntry."Shortcut Dimension 1 Code";
        BonusEntryPosted."Shortcut Dimension 2 Code" := BonusEntry."Shortcut Dimension 2 Code";
        BonusEntryPosted."Unit Office Code(Paid)" := BonusPmtPostBuffer."Unit Office Code(Paid)";
        BonusEntryPosted."Counter Code(Paid)" := BonusPmtPostBuffer."Counter Code(Paid)";
        BonusEntryPosted."Associate Rank" := BonusEntry."Associate Rank";
        BonusEntryPosted."Pmt Received From Code" := BonusEntry."Pmt Received From Code";
        BonusEntryPosted."Document Date" := BonusEntry."Document Date";
        BonusEntryPosted."G/L Posting Date" := BonusPmtPostBuffer."G/L Posting Date";
        BonusEntryPosted."G/L Document Date" := BonusPmtPostBuffer."G/L Document Date";
        BonusEntryPosted."Token No." := BonusPmtPostBuffer."Token No.";
        BonusEntryPosted.INSERT;
    end;


    procedure "-Commission-"()
    begin
    end;


    procedure CreateCommissionEntryPosted()
    var
        CommVoucherPostBuffer: Record "Comm. Voucher Posting Buffer";
        CommVoucher: Record "Commission Voucher";
        CommVoucherPosted: Record "Commission Voucher Posted";
        CommEntry: Record "Commission Entry";
        CommEntryPosted: Record "Commission Entry Posted";
    begin
    end;


    procedure InsertCommVoucherPosted(var CommVoucherPostBuffer: Record "Comm. Voucher Posting Buffer"; var CommVoucher: Record "Commission Voucher"; var CommVoucherPosted: Record "Commission Voucher Posted")
    begin
        CommVoucherPosted.INIT;
        CommVoucherPosted.TRANSFERFIELDS(CommVoucher);
        CommVoucherPosted."Unit Office Code(Paid)" := CommVoucherPostBuffer."Unit Office Code(Paid)";
        CommVoucherPosted."Counter Code(Paid)" := CommVoucherPostBuffer."Counter Code(Paid)";
        CommVoucherPosted."Posted Doc. No." := CommVoucherPostBuffer."Posted Doc. No.";
        CommVoucherPosted."Paid To" := CommVoucherPostBuffer."Paid To";
        CommVoucherPosted."Posting Date" := CommVoucherPostBuffer."Posting Date";
        CommVoucherPosted."Document Date" := CommVoucherPostBuffer."Document Date";
        CommVoucherPosted.INSERT;
    end;


    procedure InsertCommEntryPosted(var CommVoucherPostBuffer: Record "Comm. Voucher Posting Buffer"; var CommEntry: Record "Commission Entry"; var CommEntryPosted: Record "Commission Entry Posted")
    begin
        CommEntryPosted.INIT;
        CommEntryPosted.TRANSFERFIELDS(CommEntry);
        CommEntryPosted."Shortcut Dimension 1 Code" := CommVoucherPostBuffer."Unit Office Code(Paid)";
        CommEntryPosted."Shortcut Dimension 2 Code" := CommVoucherPostBuffer."Counter Code(Paid)";
        CommEntryPosted."Posted Doc. No." := CommVoucherPostBuffer."Posted Doc. No.";
        CommEntryPosted."G/L Posting Date" := CommVoucherPostBuffer."Posting Date";
        CommEntryPosted."G/L Document Date" := CommVoucherPostBuffer."Document Date";
        CommEntryPosted.INSERT;
    end;


    procedure "-EntryNos-"()
    begin
    end;


    procedure GetBondLedgerLastLine(BondNo: Code[20]): Integer
    var
        LastLineNo: Integer;
        BondLedgerEntry: Record "Unit Ledger Entry";
    begin
        //Get Bond Ledger Last Line
        BondLedgerEntry.RESET;
        BondLedgerEntry.SETRANGE("Unit No.", BondNo);
        IF BondLedgerEntry.FINDLAST THEN
            LastLineNo := BondLedgerEntry."Line No.";

        EXIT(LastLineNo);
    end;


    procedure "-Documentation-"()
    begin
    end;


    procedure Documentation()
    var
        Documentation: Record Documentation;
        BondDispute: Record "Document Tracking";
    begin
        Documentation.SETRANGE(Status, Documentation.Status::Documented);
        Documentation.DELETEALL;

        // BondDispute.SETRANGE(Status, BondDispute.Status::"13");
        // BondDispute.DELETEALL;
    end;


    procedure ChangeDocumentationStatus(BondNo: Code[20])
    var
        Documentation: Record Documentation;
    begin
        IF Documentation.GET(BondNo) AND (Documentation.Status = Documentation.Status::" ") THEN BEGIN
            Documentation.Status := Documentation.Status::Open;
            Documentation.MODIFY;
        END;
    end;


    procedure "-Bonus for existing cheques-"()
    begin
    end;


    procedure CreateBonusforChequeEntries()
    var
        BondPmtEntXChqQ: Record "Unit Pmt. Ent. Existing(Chq Q)";
        Application: Record Application;
        Bond: Record "Confirmed Order";
        ChequeCleared: Boolean;
        RDPmtSchBuff: Record "Template Field";
        "-": Integer;
        BondNo: Code[20];
        InstallmentNo: Integer;
        YearCode: Integer;
        InvestmentAmount: Decimal;
        MMCode: Code[10];
        PostDate: Date;
        DocDate: Date;
        InvestmentType: Integer;
        Duration: Integer;
        BondType: Code[10];
        BondCat: Option "A Type","B Type";
        SchemeCode: Code[10];
        Dim1Code: Code[10];
        Dim2Code: Code[10];
        ReceivedFromCode: Code[20];
    begin
    end;


    procedure "-Open Comm for existing cheque"()
    begin
    end;


    procedure OpenCommforChequeEntries()
    var
        BondPmtEntXChqQ: Record "Unit Pmt. Ent. Existing(Chq Q)";
        Application: Record Application;
        Bond: Record "Confirmed Order";
        ChequeCleared: Boolean;
        RDPmtSchPosted: Record "Unit Pmt. Ent. Existing(Chq Q)";
        RDPmtSchBuff: Record "Template Field";
        "-": Integer;
        BondNo: Code[20];
        InstallmentNo: Integer;
        YearCode: Integer;
        InvestmentAmount: Decimal;
        MMCode: Code[10];
        PostDate: Date;
        DocDate: Date;
        InvestmentType: Integer;
        Duration: Integer;
        BondType: Code[10];
        BondCat: Option "A Type","B Type";
        SchemeCode: Code[10];
        Dim1Code: Code[10];
        Dim2Code: Code[10];
        ReceivedFromCode: Code[20];
    begin
    end;


    procedure CreateBondandCommissionOld()
    var
        Application: Record Application;
        Bond: Record "Confirmed Order";
        CommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        RDPmtSchBuff: Record "Template Field";
        RDPmtSchPosted: Record "Unit Pmt. Ent. Existing(Chq Q)";
        TempApplication: Record Application temporary;
    begin
    end;


    procedure CreateBondfromApplication(var NewApplication: Record Application)
    var
        Bond: Record "Confirmed Order";
        ApplCommentLine: Record "Comment Line";
        BondCommentLine: Record "Comment Line";
        ComissionPostingBuffer: Record "Unit & Comm. Creation Buffer";
        BondDispute: Record "Document Tracking";
        UnitMaster: Record "Unit Master";
    begin
        //Create Bond
        Bond.INIT;
        Bond."No." := NewApplication."Unit No.";
        Bond."Scheme Code" := NewApplication."Scheme Code";
        Bond."Project Type" := NewApplication."Project Type";
        Bond.Duration := NewApplication.Duration;
        Bond."Customer No." := NewApplication."Customer No.";
        Bond."Introducer Code" := NewApplication."Associate Code";
        Bond."Maturity Date" := NewApplication."Maturity Date";
        Bond."Maturity Amount" := NewApplication."Maturity Amount";
        Bond."Shortcut Dimension 1 Code" := NewApplication."Shortcut Dimension 1 Code";
        Bond."Shortcut Dimension 2 Code" := NewApplication."Shortcut Dimension 2 Code";
        Bond."Application No." := NewApplication."Application No.";
        Bond.Type := NewApplication.Type;
        Bond."Expexted Discount by BBG" := NewApplication."Expexted Discount by BBG"; //ALLEDK 150313
        IF BondDispute.GET(NewApplication."Unit No.") THEN
            Bond.Status := Bond.Status::Documented
        ELSE
            Bond.Status := Bond.Status::Open;
        Bond."User Id" := NewApplication."User ID";
        Bond.Amount := NewApplication."Investment Amount" + NewApplication."Discount Amount";
        Bond."Posting Date" := NewApplication."Posting Date";
        Bond."Document Date" := NewApplication."Document Date";
        Bond."Investment Frequency" := NewApplication."Investment Frequency";
        Bond."Return Frequency" := NewApplication."Return Frequency";
        Bond."Service Charge Amount" := NewApplication."Service Charge Amount";
        Bond."Bond Category" := NewApplication.Category;
        Bond."Posted Doc No." := NewApplication."Posted Doc No.";
        Bond."Discount Amount" := NewApplication."Discount Amount";
        Bond."Return Payment Mode" := NewApplication."Return Payment Mode";
        Bond."Received From" := Bond."Received From"::"Marketing Member";
        Bond."Received From Code" := NewApplication."Received From Code";
        Bond."Version No." := NewApplication."Scheme Version No.";
        Bond."Maturity Bonus Amount" := NewApplication."Maturity Bonus Amount";
        Bond."Bond Posting Group" := NewApplication."Bond Posting Group";
        //Bond."Creation Time" := TIME;
        Bond."Creation Time" := NewApplication."Creation Time"; //ALLETDK
        Bond."Creation Date" := NewApplication."Creation Date"; //ALLETDK
        Bond."Investment Type" := NewApplication."Investment Type";
        Bond."Return Amount" := NewApplication."Return Amount";
        Bond."With Cheque" := NewApplication."With Cheque";
        Bond."Unit Code" := NewApplication."Unit Code";
        Bond."Min. Allotment Amount" := NewApplication."Min. Allotment Amount";
        Bond."Saleable Area" := NewApplication."Saleable Area";
        Bond."Branch Code" := NewApplication."Branch Code";  //ALLEDK 161212
        Bond."Payment Plan" := NewApplication."Payment Plan";
        Bond."Bill-to Customer Name" := NewApplication."Bill-to Customer Name"; //BBG1.00 300313
        Bond."Pass Book No." := NewApplication."Pass Book No."; //ALLETDK010313
        Bond."Registration Bonus Hold(BSP2)" := NewApplication."Registration Bonus Hold(BSP2)"; //BBG1.00 010413
        Bond."Commission Hold on Full Pmt" := TRUE;  //ALLE301014
        Bond."Company Name" := NewApplication."Company Name";
        Bond."Application Type" := NewApplication."Application Type";
        Bond."Unit Payment Plan" := NewApplication."Unit Payment Plan";
        Bond."Unit Plan Name" := NewApplication."Unit Plan Name";
        Bond."Development Charges" := NewApplication."Development Charges"; //BBG2.0
        Bond."Project Type" := NewApplication."Project Type";  //Code Added 01072025
        Bond."Region Code" := NewApplication."Rank Code";  //Code added 01072025
        Bond."Travel applicable" := NewApplication."Travel applicable";  //Code added 01072025
        Bond."Registration Bouns (BSP2)" := NewApplication."Registration Bouns (BSP2)";  //Code added 01072025
                                                                                         //Code added Start 23072025
        Bond."District Code" := NewApplication."District Code";
        Bond."Customer State Code" := NewApplication."Customer State Code";
        Bond."Mandal Code" := NewApplication."Mandal Code";
        Bond."Village Code" := NewApplication."Village Code";
        //Code added END 23072025

        UnitMaster.RESET;  //090921
        UnitMaster.GET(Bond."Unit Code");   //090921
        Bond."60 feet road" := UnitMaster."60 feet Road"; //090921
        Bond."100 feet road" := UnitMaster."100 feet Road";  //090921

        Bond.INSERT;


        ReleaseBondApplication.InsertBondHistory(NewApplication."Unit No.", 'Unit Created.', 0, NewApplication."Application No.");

        //Comment Line Creation;
        ApplCommentLine.RESET;
        ApplCommentLine.SETRANGE("Table Name", ApplCommentLine."Table Name"::"Activity Master");
        ApplCommentLine.SETRANGE("No.", NewApplication."Application No.");
        IF ApplCommentLine.FINDSET THEN
            REPEAT
                BondCommentLine.INIT;
                BondCommentLine.TRANSFERFIELDS(ApplCommentLine);
                BondCommentLine."Table Name" := BondCommentLine."Table Name"::"Confirmed order";
                BondCommentLine."No." := NewApplication."Unit No.";
                BondCommentLine.INSERT;
            UNTIL ApplCommentLine.NEXT = 0;

        //NewApplication.Status := NewApplication.Status::Converted;
        //NewApplication.MODIFY;

        //Create Bond Payment Entry
        CreateBondPaymentEntry(NewApplication);
        CreateAppPaymentEntry(NewApplication);

        ChangeDocumentationStatus(NewApplication."Unit No.");

        CreatePaymentSchedule(NewApplication);

        CreateApplicationBondLedger(NewApplication);

        //Delete Application Payment Entry
        DeleteApplicationPaymentEntry(NewApplication);
        DeleteAppPaymentEntry(NewApplication);
    end;


    procedure CheckMinAmount(PostDate1: Date; IntroducerCode1: Code[20]; AppNo: Code[20]): Decimal
    var
        Application2: Record Application;
        Bond2: Record "Confirmed Order";
        CommCreationBuffer2: Record "Unit & Comm. Creation Buffer";
    begin
        UnitSetup.GET;
        Amt := 0;
        //ALLETDK310513>>
        /*
        CommCreationBuffer2.RESET;
        CommCreationBuffer2.SETRANGE("Application No.",AppNo);
        CommCreationBuffer2.SETRANGE("Posting Date",040901D,PostDate1);  //ALLEDK 1801
        CommCreationBuffer2.SETRANGE("Min. Allotment Amount Not Paid",FALSE);
        CommCreationBuffer2.SETRANGE("Cheque not Cleared",FALSE);
        IF IntroducerCode1 <> '' THEN
          CommCreationBuffer2.SETRANGE("Introducer Code",IntroducerCode1);
        IF CommCreationBuffer2.FINDSET THEN
          REPEAT
              IF (CommCreationBuffer2."Cheque Cleared Date" = 0D) AND
                (CommCreationBuffer2."Posting Date" <=PostDate1) THEN BEGIN
               Amt := Amt + CommCreationBuffer2."Base Amount";
               END;
             IF (CommCreationBuffer2."Cheque Cleared Date" <> 0D) AND
               (CommCreationBuffer2."Cheque Cleared Date"<=CALCDATE(UnitSetup."No. of Cheque Buffer Days",
               CommCreationBuffer2."Posting Date")) THEN BEGIN
               Amt := Amt + CommCreationBuffer2."Base Amount";
            END;
          UNTIL CommCreationBuffer2.NEXT = 0;
        */

        CLEAR(AppPayEntry);
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document No.", AppNo);
        AppPayEntry.SETRANGE(Posted, TRUE);
        AppPayEntry.SETRANGE("Posting date", 20010409D, PostDate1);
        AppPayEntry.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::Cleared);
        IF AppPayEntry.FINDSET THEN
            REPEAT
                IF (AppPayEntry."Chq. Cl / Bounce Dt." = 0D) AND
                  (AppPayEntry."Posting date" <= PostDate1) THEN BEGIN
                    Amt := Amt + AppPayEntry.Amount;
                END;
                IF (AppPayEntry."Chq. Cl / Bounce Dt." <> 0D) AND
                  (AppPayEntry."Chq. Cl / Bounce Dt." <= CALCDATE(UnitSetup."No. of Cheque Buffer Days",
                  AppPayEntry."Posting date")) THEN BEGIN
                    Amt := Amt + AppPayEntry.Amount;
                END;
            UNTIL AppPayEntry.NEXT = 0;
        //ALLETDK310513<<

        EXIT(Amt);

    end;


    procedure CreateBondandCommissionTemp(PostDate: Date; IntroducerCode: Code[20])
    var
        Application: Record Application;
        Bond: Record "Confirmed Order";
        CommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        RDPmtSchBuff: Record "Template Field";
        RDPmtSchPosted: Record "FD Payment Schedule Posted";
        TempApplication: Record Application temporary;
        CommEntry: Record "Commission Entry";
    begin
        //BBG1.00 ALLEDK 130313
        UnitSetup.GET;

        //Create Bond and Commission from Commission Buffer
        CommCreationBuffer.RESET;
        CommCreationBuffer.SETRANGE("Posting Date", 20100409D, PostDate);  //ALLEDK 1801
        CommCreationBuffer.SETRANGE(CommCreationBuffer."Min. Allotment Amount Not Paid", FALSE);
        CommCreationBuffer.SETRANGE(CommCreationBuffer."Cheque not Cleared", FALSE);
        IF IntroducerCode <> '' THEN
            CommCreationBuffer.SETRANGE(CommCreationBuffer."Introducer Code", IntroducerCode);
        IF CommCreationBuffer.FINDSET THEN
            REPEAT
                MinAmt := 0;
                RecConfOrder.RESET;
                RecConfOrder.SETRANGE("No.", CommCreationBuffer."Application No.");
                RecConfOrder.SETFILTER(Status, '<>%1', RecConfOrder.Status::Cancelled);  //ALLEDK 170213
                RecConfOrder.SETRANGE("Commission Not Generate", FALSE);
                IF RecConfOrder.FINDFIRST THEN BEGIN
                    MinAmt := CheckMinAmount(PostDate, IntroducerCode, CommCreationBuffer."Application No.");
                    /*
                    CommEntry.RESET;
                    CommEntry.SETRANGE("Application No.",RecConfOrder."No.");
                    IF CommEntry.FINDSET THEN
                    REPEAT
                      MinAmt+=CommEntry."Base Amount";
                    UNTIL CommEntry.NEXT=0;
                    */
                    IF MinAmt >= RecConfOrder."Min. Allotment Amount" THEN BEGIN

                        //ALLEDK 251212
                        CommCreationBuffer."Bond Created" := TRUE;
                        CommCreationBuffer.MODIFY;
                        IF CommCreationBuffer."Bond Created" THEN
                            CommCreationBuffer.MARK(TRUE);

                        //Commission Creation
                        IF NOT CommCreationBuffer."Commission Created" THEN
                            BondPost.CalculateComissionTemp(CommCreationBuffer);

                        //Subsequent RD Installments
                        IF CommCreationBuffer."Installment No." > 1 THEN
                            CommCreationBuffer.MARK(TRUE);
                        //ALLEDK 180113
                    END;
                END;
            UNTIL CommCreationBuffer.NEXT = 0;
        COMMIT;

    end;


    procedure CreateBondandCommissionforOpen(PostDate: Date; IntroducerCode: Code[20])
    var
        Application: Record Application;
        Bond: Record "Confirmed Order";
        CommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        RDPmtSchBuff: Record "Template Field";
        RDPmtSchPosted: Record "FD Payment Schedule Posted";
        TempApplication: Record Application temporary;
        CommEntry: Record "Commission Entry";
    begin
        UnitSetup.GET;


        //Create Bond and Commission from Commission Buffer
        CommCreationBuffer.RESET;
        CommCreationBuffer.SETRANGE("Posting Date", 20010409D, PostDate);  //ALLEDK 1801
        CommCreationBuffer.SETRANGE(CommCreationBuffer."Min. Allotment Amount Not Paid", FALSE);
        CommCreationBuffer.SETRANGE(CommCreationBuffer."Cheque not Cleared", FALSE);
        CommCreationBuffer.SETRANGE("Opening Commision Adj.", TRUE);
        IF (IntroducerCode <> '') AND (IntroducerCode <> 'IBA9999999') THEN
            CommCreationBuffer.SETRANGE(CommCreationBuffer."Introducer Code", IntroducerCode)
        ELSE
            CommCreationBuffer.SETFILTER(CommCreationBuffer."Introducer Code", '<>%1', 'IBA9999999');
        IF CommCreationBuffer.FINDSET THEN
            REPEAT
                MinAmt := 0;
                RecConfOrder.RESET;
                RecConfOrder.SETRANGE("No.", CommCreationBuffer."Application No.");
                RecConfOrder.SETFILTER(Status, '<>%1', RecConfOrder.Status::Cancelled);  //ALLEDK 170213
                RecConfOrder.SETRANGE("Commission Not Generate", FALSE);
                IF RecConfOrder.FINDFIRST THEN BEGIN
                    //MinAmt := CheckMinAmount(PostDate,IntroducerCode,CommCreationBuffer."Application No."); ////ALLETDK180713
                    MinAmt := CheckRcvdOpngAmt(PostDate, IntroducerCode, CommCreationBuffer."Application No."); ////ALLETDK180713
                                                                                                                /*
                                                                                                                CommEntry.RESET;
                                                                                                                CommEntry.SETRANGE("Application No.",RecConfOrder."No.");
                                                                                                                IF CommEntry.FINDSET THEN
                                                                                                                REPEAT
                                                                                                                  MinAmt+=CommEntry."Base Amount";
                                                                                                                UNTIL CommEntry.NEXT=0;
                                                                                                                */
                                                                                                                //IF MinAmt >= RecConfOrder."Min. Allotment Amount" THEN BEGIN
                    IF MinAmt >= CheckMinAmountOpng(RecConfOrder) THEN BEGIN
                        //ALLEDK 251212
                        CommCreationBuffer."Bond Created" := TRUE;
                        CommCreationBuffer.MODIFY;
                        IF CommCreationBuffer."Bond Created" THEN
                            CommCreationBuffer.MARK(TRUE);
                        //Commission Creation
                        IF NOT CommCreationBuffer."Commission Created" THEN
                            BondPost.CalculateComissionNew(CommCreationBuffer, PostDate); //050613
                                                                                          //Subsequent RD Installments
                        IF CommCreationBuffer."Installment No." > 1 THEN
                            CommCreationBuffer.MARK(TRUE);
                        //ALLEDK 180113
                    END;
                END;
            UNTIL CommCreationBuffer.NEXT = 0;
        //Clear Buffer Table
        CommCreationBuffer.MARKEDONLY(TRUE);
        CommCreationBuffer.DELETEALL;

        IF TempApplication.FINDSET THEN
            REPEAT
                IF Application.GET(TempApplication."Application No.") THEN
                    Application.DELETE;
            UNTIL TempApplication.NEXT = 0;

        COMMIT;

    end;


    procedure CheckRcvdOpngAmt(PostDate1: Date; IntroducerCode1: Code[20]; AppNo: Code[20]): Decimal
    var
        Application2: Record Application;
        Bond2: Record "Confirmed Order";
        CommCreationBuffer2: Record "Unit & Comm. Creation Buffer";
    begin
        //ALLETDK180713>>
        Amt := 0;
        CLEAR(AppPayEntry);
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document No.", AppNo);
        AppPayEntry.SETRANGE(Posted, TRUE);
        AppPayEntry.SETRANGE("Posting date", 20010409D, PostDate1);
        AppPayEntry.SETRANGE("Cheque Status", AppPayEntry."Cheque Status"::Cleared);
        AppPayEntry.SETRANGE("User ID", '1003');
        IF AppPayEntry.FINDSET THEN
            REPEAT
                Amt := Amt + AppPayEntry.Amount;
            UNTIL AppPayEntry.NEXT = 0;
        //ALLETDK180713<<

        EXIT(Amt);
    end;


    procedure CheckMinAmountOpng(ConfirmedOrd: Record "Confirmed Order"): Decimal
    var
        ACO: Record "Archive Confirmed Order";
    begin
        ConfirmedOrd.CALCFIELDS("Version No.");
        IF ConfirmedOrd."Version No." <> 0 THEN BEGIN
            ACO.RESET;
            ACO.SETRANGE("No.", ConfirmedOrd."No.");
            IF ACO.FINDFIRST THEN
                EXIT(ACO."Min. Allotment Amount");
        END ELSE
            EXIT(ConfirmedOrd."Min. Allotment Amount");
    end;


    procedure UpdateMilestonePercentage(ApplicationCode: Code[20]; FromApplication: Boolean)
    var
        PTLineSale: Record "Payment Terms Line Sale";
        ArchivePTLineSale: Record "Archive Payment Terms Line";
        ProjectMilestoneLine: Record "Project Milestone Line";
        ProjectMilestoneHdr: Record "Project Milestone Header";
        RecConfirmedOrder: Record "Confirmed Order";
        RecApplication: Record Application;
        VersionNo: Integer;
    begin
        IF FromApplication THEN BEGIN
            CLEAR(ProjectMilestoneHdr);
            IF RecApplication.GET(ApplicationCode) THEN;
            ProjectMilestoneHdr.RESET;
            ProjectMilestoneHdr.SETCURRENTKEY(ProjectMilestoneHdr."Project Code", ProjectMilestoneHdr."Effective From Date",
                                              ProjectMilestoneHdr."Effective To Date");
            ProjectMilestoneHdr.SETRANGE("Project Code", RecApplication."Shortcut Dimension 1 Code");
            ProjectMilestoneHdr.SETRANGE(Status, ProjectMilestoneHdr.Status::Release);
            IF ProjectMilestoneHdr.FINDSET THEN BEGIN
                REPEAT
                    CLEAR(ProjectMilestoneLine);
                    IF ProjectMilestoneHdr."Effective To Date" = 0D THEN BEGIN
                        IF (RecApplication."Posting Date" >= ProjectMilestoneHdr."Effective From Date") THEN BEGIN
                            ProjectMilestoneLine.RESET;
                            ProjectMilestoneLine.SETRANGE("Document No.", ProjectMilestoneHdr."Document No.");
                            IF ProjectMilestoneLine.FINDSET THEN
                                REPEAT
                                    CLEAR(PTLineSale);
                                    PTLineSale.RESET;
                                    PTLineSale.SETRANGE("Document No.", RecApplication."Application No.");
                                    PTLineSale.SETRANGE("Charge Code", ProjectMilestoneLine.Code);
                                    IF PTLineSale.FINDSET THEN
                                        REPEAT
                                            PTLineSale."First Milestone %" := ProjectMilestoneLine."First Milestone %";
                                            PTLineSale."Second Milestone %" := ProjectMilestoneLine."Second Milestone %";
                                            PTLineSale.MODIFY;
                                        UNTIL PTLineSale.NEXT = 0;
                                UNTIL ProjectMilestoneLine.NEXT = 0;
                        END;
                    END ELSE
                        IF ProjectMilestoneHdr."Effective To Date" <> 0D THEN BEGIN
                            IF (RecApplication."Posting Date" >= ProjectMilestoneHdr."Effective From Date") AND
                              (RecApplication."Posting Date" <= ProjectMilestoneHdr."Effective To Date") THEN BEGIN
                                ProjectMilestoneLine.RESET;
                                ProjectMilestoneLine.SETRANGE("Document No.", ProjectMilestoneHdr."Document No.");
                                IF ProjectMilestoneLine.FINDSET THEN
                                    REPEAT
                                        CLEAR(PTLineSale);
                                        PTLineSale.RESET;
                                        PTLineSale.SETRANGE("Document No.", RecApplication."Application No.");
                                        PTLineSale.SETRANGE("Charge Code", ProjectMilestoneLine.Code);
                                        IF PTLineSale.FINDSET THEN
                                            REPEAT
                                                PTLineSale."First Milestone %" := ProjectMilestoneLine."First Milestone %";
                                                PTLineSale."Second Milestone %" := ProjectMilestoneLine."Second Milestone %";
                                                PTLineSale.MODIFY;
                                            UNTIL PTLineSale.NEXT = 0;
                                    UNTIL ProjectMilestoneLine.NEXT = 0;
                            END;
                        END;
                UNTIL ProjectMilestoneHdr.NEXT = 0;
            END ELSE BEGIN
                CLEAR(PTLineSale);
                PTLineSale.RESET;
                PTLineSale.SETRANGE("Document No.", RecApplication."Application No.");
                PTLineSale.SETRANGE("Commision Applicable", TRUE);
                IF PTLineSale.FINDSET THEN
                    REPEAT
                        PTLineSale."First Milestone %" := 100;
                        PTLineSale."Second Milestone %" := 0;
                        PTLineSale.MODIFY;
                    UNTIL PTLineSale.NEXT = 0;
            END;
        END ELSE BEGIN
            CLEAR(ProjectMilestoneHdr);
            VersionNo := 0;
            IF RecConfirmedOrder.GET(ApplicationCode) THEN;

            ArchivePTLineSale.RESET;
            ArchivePTLineSale.SETRANGE("Document No.", RecConfirmedOrder."No.");
            IF ArchivePTLineSale.FINDLAST THEN
                VersionNo := ArchivePTLineSale."Version No.";


            ProjectMilestoneHdr.RESET;
            ProjectMilestoneHdr.SETCURRENTKEY(ProjectMilestoneHdr."Project Code", ProjectMilestoneHdr."Effective From Date",
                                              ProjectMilestoneHdr."Effective To Date");
            ProjectMilestoneHdr.SETRANGE("Project Code", RecConfirmedOrder."Shortcut Dimension 1 Code");
            ProjectMilestoneHdr.SETRANGE(Status, ProjectMilestoneHdr.Status::Release);
            IF ProjectMilestoneHdr.FINDSET THEN BEGIN
                REPEAT
                    CLEAR(ProjectMilestoneLine);
                    IF ProjectMilestoneHdr."Effective To Date" <> 0D THEN BEGIN
                        IF (RecConfirmedOrder."Posting Date" >= ProjectMilestoneHdr."Effective From Date") AND
                           (RecConfirmedOrder."Posting Date" <= ProjectMilestoneHdr."Effective To Date") THEN BEGIN
                            ProjectMilestoneLine.RESET;
                            ProjectMilestoneLine.SETRANGE("Document No.", ProjectMilestoneHdr."Document No.");
                            IF ProjectMilestoneLine.FINDSET THEN
                                REPEAT
                                    ArchivePTLineSale.RESET;
                                    ArchivePTLineSale.SETRANGE("Document No.", RecConfirmedOrder."No.");
                                    ArchivePTLineSale.SETRANGE("Charge Code", ProjectMilestoneLine.Code);
                                    ArchivePTLineSale.SETRANGE("Version No.", VersionNo);
                                    IF ArchivePTLineSale.FINDSET THEN
                                        REPEAT
                                            PTLineSale.RESET;
                                            PTLineSale.SETRANGE("Document No.", RecConfirmedOrder."No.");
                                            PTLineSale.SETRANGE("Charge Code", ProjectMilestoneLine.Code);
                                            IF PTLineSale.FINDSET THEN
                                                REPEAT
                                                    IF ArchivePTLineSale."Comm Generated on Old App" = FALSE THEN BEGIN
                                                        PTLineSale."First Milestone %" := ProjectMilestoneLine."First Milestone %";
                                                        PTLineSale."Second Milestone %" := ProjectMilestoneLine."Second Milestone %";
                                                    END;
                                                    IF ArchivePTLineSale."Comm Generated on Old App" THEN BEGIN
                                                        PTLineSale."First Milestone %" := ArchivePTLineSale."First Milestone %";
                                                        PTLineSale."Second Milestone %" := ArchivePTLineSale."Second Milestone %";
                                                        PTLineSale."Comm Generated on Old App" := TRUE;
                                                    END;
                                                    PTLineSale.MODIFY;
                                                UNTIL PTLineSale.NEXT = 0;
                                        UNTIL ArchivePTLineSale.NEXT = 0;
                                UNTIL ProjectMilestoneLine.NEXT = 0;
                        END;
                    END ELSE BEGIN
                        IF (RecConfirmedOrder."Posting Date" >= ProjectMilestoneHdr."Effective From Date") THEN BEGIN
                            ProjectMilestoneLine.RESET;
                            ProjectMilestoneLine.SETRANGE("Document No.", ProjectMilestoneHdr."Document No.");
                            IF ProjectMilestoneLine.FINDSET THEN
                                REPEAT
                                    ArchivePTLineSale.RESET;
                                    ArchivePTLineSale.SETRANGE("Document No.", RecConfirmedOrder."No.");
                                    ArchivePTLineSale.SETRANGE("Charge Code", ProjectMilestoneLine.Code);
                                    ArchivePTLineSale.SETRANGE("Version No.", VersionNo);
                                    IF ArchivePTLineSale.FINDSET THEN
                                        REPEAT
                                            PTLineSale.RESET;
                                            PTLineSale.SETRANGE("Document No.", RecConfirmedOrder."No.");
                                            PTLineSale.SETRANGE("Charge Code", ProjectMilestoneLine.Code);
                                            IF PTLineSale.FINDSET THEN
                                                REPEAT
                                                    IF ArchivePTLineSale."Comm Generated on Old App" = FALSE THEN BEGIN
                                                        PTLineSale."First Milestone %" := ProjectMilestoneLine."First Milestone %";
                                                        PTLineSale."Second Milestone %" := ProjectMilestoneLine."Second Milestone %";
                                                    END;
                                                    IF ArchivePTLineSale."Comm Generated on Old App" THEN BEGIN
                                                        PTLineSale."First Milestone %" := ArchivePTLineSale."First Milestone %";
                                                        PTLineSale."Second Milestone %" := ArchivePTLineSale."Second Milestone %";
                                                        PTLineSale."Comm Generated on Old App" := TRUE;
                                                    END;
                                                    PTLineSale.MODIFY;
                                                UNTIL PTLineSale.NEXT = 0;
                                        UNTIL ArchivePTLineSale.NEXT = 0;
                                UNTIL ProjectMilestoneLine.NEXT = 0;
                        END;
                    END;
                UNTIL ProjectMilestoneHdr.NEXT = 0;
            END ELSE BEGIN
                CLEAR(PTLineSale);
                PTLineSale.RESET;
                PTLineSale.SETRANGE("Document No.", RecConfirmedOrder."No.");
                PTLineSale.SETRANGE("Commision Applicable", TRUE);
                IF PTLineSale.FINDSET THEN
                    REPEAT
                        PTLineSale."First Milestone %" := 100;
                        PTLineSale."Second Milestone %" := 0;
                        PTLineSale.MODIFY;
                    UNTIL PTLineSale.NEXT = 0;
            END;
        END;
    end;


    procedure NewCreateBondfromApplication(var NewApplication: Record "New Application Booking")
    var
        Bond: Record "New Confirmed Order";
        ApplCommentLine: Record "Comment Line";
        BondCommentLine: Record "Comment Line";
        ApplicationPaymentEntry: Record "NewApplication Payment Entry";
        UnitMaster_2: Record "Unit Master";
        Job_2: Record Job;
        v_CompanyInformation: Record "Company Information";
    begin
        //Create Bond
        Bond.INIT;
        Bond."No." := NewApplication."Application No.";
        Bond."Scheme Code" := NewApplication."Scheme Code";
        Bond."Project Type" := NewApplication."Project Type";
        Bond.Duration := NewApplication.Duration;
        Bond."Customer No." := NewApplication."Customer No.";
        Bond."Introducer Code" := NewApplication."Associate Code";
        Bond."Maturity Date" := NewApplication."Maturity Date";
        Bond."Maturity Amount" := NewApplication."Maturity Amount";
        Bond."Shortcut Dimension 1 Code" := NewApplication."Shortcut Dimension 1 Code";
        Bond."Shortcut Dimension 2 Code" := NewApplication."Shortcut Dimension 2 Code";
        Bond."Application No." := NewApplication."Application No.";
        Bond.Type := NewApplication.Type;
        Bond."Expexted Discount by BBG" := NewApplication."Expexted Discount by BBG"; //ALLEDK 150313
        Bond.Status := Bond.Status::Open;
        Bond."User Id" := NewApplication."User Id";
        Bond.Amount := NewApplication."Investment Amount" + NewApplication."Discount Amount";
        Bond."Posting Date" := NewApplication."Posting Date";
        Bond."Document Date" := NewApplication."Document Date";
        Bond."Investment Frequency" := NewApplication."Investment Frequency";
        Bond."Return Frequency" := NewApplication."Return Frequency";
        Bond."Service Charge Amount" := NewApplication."Service Charge Amount";
        Bond."Bond Category" := NewApplication.Category;
        Bond."Posted Doc No." := NewApplication."Posted Doc No.";
        Bond."Discount Amount" := NewApplication."Discount Amount";
        Bond."Return Payment Mode" := NewApplication."Return Payment Mode";
        Bond."Received From" := Bond."Received From"::"Marketing Member";
        Bond."Received From Code" := NewApplication."Received From Code";
        Bond."Version No." := NewApplication."Scheme Version No.";
        Bond."Maturity Bonus Amount" := NewApplication."Maturity Bonus Amount";
        Bond."Bond Posting Group" := NewApplication."Bond Posting Group";
        Bond."Creation Time" := NewApplication."Creation Time"; //ALLETDK
        Bond."Creation Date" := NewApplication."Creation Date"; //ALLETDK
        Bond."Investment Type" := NewApplication."Investment Type";
        Bond."Return Amount" := NewApplication."Return Amount";
        Bond."With Cheque" := NewApplication."With Cheque";
        Bond."Unit Code" := NewApplication."Unit Code";
        Bond."Min. Allotment Amount" := NewApplication."Min. Allotment Amount";
        Bond."Saleable Area" := NewApplication."Saleable Area";
        Bond."Branch Code" := NewApplication."Branch Code";  //ALLEDK 161212
        Bond."Payment Plan" := NewApplication."Payment Plan";
        Bond."Bill-to Customer Name" := NewApplication."Bill-to Customer Name"; //BBG1.00 300313
        Bond."Pass Book No." := NewApplication."Pass Book No."; //ALLETDK010313
        Bond."Registration Bonus Hold(BSP2)" := NewApplication."Registration Bonus Hold(BSP2)"; //BBG1.00 010413
        Bond."Commission Hold on Full Pmt" := TRUE;  //ALLE301014
        Bond."Company Name" := NewApplication."Company Name";
        Bond."Application Type" := NewApplication."Application Type";
        Bond."Unit Payment Plan" := NewApplication."Unit Payment Plan";
        Bond."Unit Plan Name" := NewApplication."Unit Plan Name";
        Bond."Commission Hold on Full Pmt" := TRUE;
        //BBG2.0
        Bond."Development Charges" := NewApplication."Development Charges";
        v_CompanyInformation.RESET;
        v_CompanyInformation.CHANGECOMPANY(NewApplication."Company Name");
        IF v_CompanyInformation.FINDFIRST THEN BEGIN
            v_CompanyInformation.TESTFIELD("Development Company Name");
            Bond."Development Company Name" := v_CompanyInformation."Development Company Name";
            Bond."60 feet road" := NewApplication."60 feet road";
            Bond."100 feet road" := NewApplication."100 feet road";
        END;
        Bond."Allow Auto Plot Vacate" := TRUE;  //08022022
        Bond."Project Type" := NewApplication."Project Type";  //Code added 01072025
        Bond."Region Code" := NewApplication."Rank Code";  //Code added 01072025
        Bond."Travel applicable" := NewApplication."Travel applicable";  //Code added 01072025
        Bond."Registration Bouns (BSP2)" := NewApplication."Registration Bouns (BSP2)";  //Code added 01072025

        //Code added Start 23072025
        Bond."District Code" := NewApplication."District Code";
        Bond."Customer State Code" := NewApplication."Customer State Code";
        Bond."Mandal Code" := NewApplication."Mandal Code";
        Bond."Village Code" := NewApplication."Village Code";
        Bond."Aadhar No." := NewApplication."Aadhar No.";  //Code added 19082025
        //Code added END 23072025
        //BBG2.0
        Bond.INSERT;

        NewCreateAppPaymentEntry(NewApplication);
        ApplicationPaymentEntry.RESET;
        ApplicationPaymentEntry.SETRANGE("Document Type", ApplicationPaymentEntry."Document Type"::Application);
        ApplicationPaymentEntry.SETRANGE("Document No.", NewApplication."Application No.");
        ApplicationPaymentEntry.DELETEALL;
    end;


    procedure NewCreateAppPaymentEntry(var Application: Record "New Application Booking")
    var
        ApplicationPaymentEntry: Record "NewApplication Payment Entry";
        BondPaymentEntry: Record "NewApplication Payment Entry";
    begin
        ApplicationPaymentEntry.RESET;
        ApplicationPaymentEntry.SETRANGE("Document Type", ApplicationPaymentEntry."Document Type"::Application);
        ApplicationPaymentEntry.SETRANGE("Document No.", Application."Application No.");
        IF ApplicationPaymentEntry.FINDSET THEN BEGIN
            REPEAT
                BondPaymentEntry := ApplicationPaymentEntry;
                BondPaymentEntry."Document Type" := BondPaymentEntry."Document Type"::BOND;
                BondPaymentEntry."Document No." := Application."Application No.";
                BondPaymentEntry."Created From Application" := TRUE;    //ALLEDK 091012


                BondPaymentEntry.INSERT;
            UNTIL ApplicationPaymentEntry.NEXT = 0;
        END;
    end;
}

