report 50007 "New Assoc Drawing Job queue"
{
    // version BBG format
    //280225 Added new code

    DefaultLayout = RDLC;
    RDLCLayout = './Reports/New Assoc Drawing Job queue.rdl';
    UseRequestPage = false;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.")
                                WHERE("BBG Vendor Category" = FILTER("IBA(Associates)"),
                                      "BBG Black List" = FILTER(false));
            RequestFilterFields = "No.", "Vendor Posting Group";
            column(CompName; CompInfo.Name)
            {
            }
            column(Address_; CompInfo.Address + ' ' + CompInfo."Address 2" + ' ' + CompInfo.City + ' ' + CompInfo."Post Code" + ' ' + CompInfo.County)
            {
            }
            column(ReportCaption; 'Associate Drawing Ledger')
            {
            }
            column(REportfilters_; 'Associate :' + "No." + '  -  ' + Vendor.Name)
            {
            }
            column(OpeningDAte_; SDate - 1)
            {
            }
            column(SDate_; SDate)
            {
            }
            column(EDate_; EDate)
            {
            }
            column(TPSAmt_; TPSAmt)
            {
            }
            column(OpeningFromTPSAmt_; TotalTOPAmt + TotalTTDSO + TotalTClbO)
            {
            }
            column(FromDAte_; CMAmt + TotalTOPAmt)
            {
            }
            column(Opening_; CMAmt + TotalTOPAmt)
            {
            }
            column(TotalIncludingOpening_; CMAmt + TotalTOPAmt + TPSAmt)
            {
            }
            column(F_Inv_Adj; TotalAmt_Invoice + TOpenInvAmt_1)
            {
            }
            column(F_TDS; TDS_Invoice)
            {
            }
            column(F_Club; Club_Invoice)
            {
            }
            column(F_Inv_Adj_1; TotalAmt_Invoice_1)
            {
            }
            column(F_TDS_1; TDS_Invoice_1)
            {
            }
            column(F_Club_1; Club_Invoice_1)
            {
            }
            column(F_TDS_2; TDS_Pmt)
            {
            }
            column(F_Club_2; Club_Pmt)
            {
            }
            column(F_PAymentnet; Amt_Pmt + TDS_Pmt + Club_Pmt + TPSAmt)
            {
            }
            column(LF_ELEGGross_; TotalAmt_Invoice + TOpenInvAmt_1 + TotalAmt_Invoice_1 + TDS_Invoice + TDS_Invoice_1 + Club_Invoice + Club_Invoice_1)
            {
            }
            column(LF_TDS_; ABS(TDS_Invoice + TDS_Invoice_1 + TDS_Pmt))
            {
            }
            column(LF_Club_; ABS(Club_Invoice + Club_Invoice_1 + Club_Pmt))
            {
            }
            column(LF_NetPayment; Amt_Pmt + TDS_Pmt + Club_Pmt + TPSAmt)
            {
            }
            column(LF_ElegNet_; TotalAmt_Invoice + TOpenInvAmt_1 + TotalAmt_Invoice_1 - TDS_Pmt - Club_Pmt + (Amt_Pmt + TDS_Pmt + Club_Pmt + TPSAmt))
            {
            }
            column(GV_VendorNo_; '[ Total For' + '  ' + TempVLEntry."Vendor No.")
            {
            }
            column(GV_CMAmt_; CMAmt)
            {
            }
            column(GV_Total_; CMAmt + TotalTOPAmt)
            {
            }
            column(GV_TotalWithOpening_; CMAmt + TotalTOPAmt + TPSAmt)
            {
            }
            column(ShowDetils_1; ShowDetils_1)
            {
            }
            column(ShowSummary_1; ShowSummary_1)
            {
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(PostDAte_; FORMAT(TempVLEntry."Posting Date"))
                {
                }
                column(DocNo_; TempVLEntry."Document No.")
                {
                }
                column(DocType_; DocType)
                {
                }
                column(BNAme_; BName)
                {
                }
                column(ChequeNo_; TempVLEntry."Cheque No.")
                {
                }
                column(ChequeDate_; FORMAT(TempVLEntry."Cheque Date"))
                {
                }
                column(BAMt_; BAmt)
                {
                }
                column(CMAmt_; CMAmt)
                {
                }
                column(PostType_; PostingType)
                {
                }
                column(OrderREfNo_; TempVLEntry."Order Ref No.")
                {
                }
                column(TotalforchecqeNo_; 'Total for Cheque No.  ' + ' ' + TempVLEntry."Cheque No.")
                {
                }
                column(Cheqamt_; CheqAmt)
                {
                }
                column(PrintBody2_; PrintBody2)
                {
                }
                column(PrintOpening_; PrintOpening)
                {
                }
                column(Narration_1; Narration_1)
                {
                }

                trigger OnAfterGetRecord()
                var
                    VLE_1: Record "Vendor Ledger Entry";
                    VLEExtDocumentNo: Code[20];
                begin

                    IF Number = 1 THEN BEGIN
                        IF NOT TempVLEntry.FIND('-') THEN
                            CurrReport.SKIP;
                    END ELSE BEGIN

                        TempVLEntry.NEXT;
                    END;
                    TempVLEntry.CALCFIELDS(Amount);
                    Unitstup.GET;

                    //---------Narration------------------
                    Narration_1 := '';
                    TempPostedNarration.RESET;
                    TempPostedNarration.SETFILTER("Entry No.", '=%1', 0);
                    TempPostedNarration.SETRANGE("Document No.", TempVLEntry."Document No.");
                    TempPostedNarration.SETRANGE("Transaction No.", TempVLEntry."Transaction No.");
                    IF TempPostedNarration.FINDFIRST THEN
                        Narration_1 := TempPostedNarration.Narration;

                    TempAppEntry.RESET;
                    TempAppEntry.SETCURRENTKEY("Posted Document No.");
                    TempAppEntry.SETRANGE("Posted Document No.", TempVLEntry."Document No.");
                    IF TempAppEntry.FINDFIRST THEN
                        Narration_1 := TempAppEntry.Narration;

                    VLEExtDocumentNo := '';                                                 //100820
                    VLEExtDocumentNo := COPYSTR(TempVLEntry."External Document No.", 1, 20);  //100820
                    IF VLEExtDocumentNo <> '' THEN BEGIN                                    //100820
                        TempAssocPmtVoucherHeader.RESET;
                        TempAssocPmtVoucherHeader.SETCURRENTKEY("Document No.");
                        TempAssocPmtVoucherHeader.SETRANGE("Document No.", VLEExtDocumentNo);
                        IF TempAssocPmtVoucherHeader.FINDFIRST THEN BEGIN
                            TempVoucherLine.RESET;
                            TempVoucherLine.SETCURRENTKEY("Voucher No.");
                            TempVoucherLine.SETRANGE("Voucher No.", TempAssocPmtVoucherHeader."Document No.");
                            IF TempVoucherLine.FINDFIRST THEN
                                Narration_1 := TempVoucherLine.Narration;
                        END;
                    END;   //100820
                    //--------Narration-----------------





                    //ALLETDK081013>>>
                    IF (TempVLEntry."Document Type" = TempVLEntry."Document Type"::" ") AND
                        (NOT TempVLEntry.Positive) AND (TempVLEntry."Payment Mode" = TempVLEntry."Payment Mode"::" ") AND
                       (TempVLEntry."Source Code" <> 'TDSADJNL') THEN
                        CurrReport.SKIP;
                    //ALLETDK081013<<<
                    DimValueName := '';
                    VendorName := '';
                    CLEAR(PostingType);
                    CLEAR(CrAmt);
                    CLEAR(SubDoc);
                    CLEAR(TOPAmt);
                    Clear(BAmt);


                    CLEAR(DocType);
                    IF TempVLEntry."Document Type" <> TempVLEntry."Document Type"::" " THEN
                        DocType := FORMAT(TempVLEntry."Document Type")
                    ELSE
                        DocType := 'ADJ';


                    IF DimValue.GET('BUSINESSUNIT', TempVLEntry."Global Dimension 1 Code") THEN
                        DimValueName := DimValue.Name;

                    VendorName := Vendor.Name;
                    //ALLECK 160513 START
                    IF Options = Options::Bank THEN BEGIN
                        BLE.RESET;
                        BLE.SETCURRENTKEY("Document No.");
                        BLE.CHANGECOMPANY(TempVLEntry."Company Name");
                        BLE.SETRANGE("Document No.", TempVLEntry."Document No.");
                        IF NOT BLE.FINDFIRST THEN
                            CurrReport.SKIP;
                    END;
                    //ALLECK 160513 END

                    //ALLECK 130513 START
                    IF TempVLEntry."Document Type" IN [TempVLEntry."Document Type"::Payment, TempVLEntry."Document Type"::Refund] THEN
                        CrAmt := TempVLEntry."Credit Amount";

                    IF TempVLEntry."Posting Type" = TempVLEntry."Posting Type"::"Travel Allowance" THEN
                        PostingType := 'C'
                    ELSE IF TempVLEntry."Posting Type" = TempVLEntry."Posting Type"::Commission THEN
                        PostingType := 'C'
                    ELSE IF TempVLEntry."Posting Type" = TempVLEntry."Posting Type"::Incentive THEN
                        PostingType := 'I'
                    ELSE IF TempVLEntry."Posting Type" = TempVLEntry."Posting Type"::CommAndTA THEN
                        PostingType := 'C'
                    ELSE IF TempVLEntry."Posting Type" = TempVLEntry."Posting Type"::Bonanza THEN
                        PostingType := 'B'
                    ELSE IF TempVLEntry."Posting Type" = TempVLEntry."Posting Type"::Running THEN
                        PostingType := 'C'
                    ELSE
                        PostingType := 'O';
                    //ALLECK 130513 END

                    //ALLECK 060513 START
                    IF (SDate < 20130301D) OR (EDate < 20130301D) THEN//Alle--deeksha
                        ERROR('Please enter the date 01-March 13 Onwards');
                    //ALLECK 060513 END

                    Unitstup.GET;
                    CLEAR(TDSAmt);
                    Clear(Clb9);

                    VLE_1.RESET;
                    VLE_1.CHANGECOMPANY(TempVLEntry."Company Name");
                    VLE_1.SETCURRENTKEY("Document No.");
                    VLE_1.SETRANGE("Document No.", TempVLEntry."Document No.");
                    VLE_1.SETRANGE("Transaction No.", TempVLEntry."Transaction No.");
                    IF VLE_1.FINDSET THEN
                        REPEAT  //271015
                            VLE_1.CALCFIELDS(Amount);
                            BAmt := BAmt + VLE_1.Amount;
                        UNTIL VLE_1.NEXT = 0;

                    GLE_CurrTDS.RESET;
                    GLE_CurrTDS.CHANGECOMPANY(TempVLEntry."Company Name");
                    GLE_CurrTDS.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                    GLE_CurrTDS.SETRANGE("Document No.", TempVLEntry."Document No.");
                    GLE_CurrTDS.SETRANGE("Document Type", GLE_CurrTDS."Document Type"::Payment);
                    GLE_CurrTDS.SETRANGE("G/L Account No.", Unitstup."Corpus A/C");
                    GLE_CurrTDS.SETRANGE("Transaction No.", TempVLEntry."Transaction No.");
                    IF GLE_CurrTDS.FINDSET THEN
                        REPEAT
                            TDSAmt := TDSAmt + GLE_CurrTDS.Amount;
                        UNTIL GLE_CurrTDS.NEXT = 0;

                    GLE_CurrClub.RESET;
                    GLE_CurrClub.CHANGECOMPANY(TempVLEntry."Company Name");
                    GLE_CurrClub.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                    GLE_CurrClub.SETRANGE("Document No.", TempVLEntry."Document No.");
                    GLE_CurrClub.SETRANGE("Document Type", GLE_CurrClub."Document Type"::Payment);
                    GLE_CurrClub.SETRANGE("Transaction No.", TempVLEntry."Transaction No.");
                    GLE_CurrClub.SETRANGE("G/L Account No.", '116400', '117100');
                    IF GLE_CurrClub.FINDSET THEN
                        REPEAT
                            Clb9 := Clb9 + GLE_CurrClub.Amount;
                        UNTIL GLE_CurrClub.NEXT = 0;


                    //IF TempVLEntry."Payment As Advance" THEN
                    BAmt := BAmt + TDSAmt + Clb91 + Clb9;


                    //ALLECK 310513 START
                    CLEAR(BName);
                    BLE3.RESET;
                    BLE3.CHANGECOMPANY(TempVLEntry."Company Name");
                    BLE3.SETCURRENTKEY("Document No.");
                    BLE3.SETRANGE("Document No.", TempVLEntry."Document No.");
                    IF BLE3.FINDFIRST THEN BEGIN
                        BAcnt.RESET;
                        BAcnt.CHANGECOMPANY(TempVLEntry."Company Name");
                        BAcnt.SETRANGE("No.", BLE3."Bank Account No.");
                        IF BAcnt.FINDFIRST THEN
                            BName := BAcnt.Name;
                    END;
                    //ALLECK 310513 END

                    PrintBody1 := 0;

                    IF AllPayment_1 = AllPayment_1::"Without Adjustment" THEN BEGIN
                        IF TempVLEntry."Document Type" = TempVLEntry."Document Type"::Payment THEN
                            CMAmt += BAmt;
                    END ELSE BEGIN
                        CMAmt += BAmt;
                    END;


                    IF AllPayment_1 = AllPayment_1::"Without Adjustment" THEN BEGIN
                        IF (DocType = 'ADJ') OR (DocType = 'Credit Memo') THEN BEGIN
                            CurrReport.SKIP;
                            PrintBody1 := 0;
                        END ELSE BEGIN
                            SNO := SNO + 1;
                            PrintOpening := 0;
                            IF SNO = 1 THEN
                                PrintOpening := 1
                            ELSE
                                PrintOpening := 0;
                            PrintBody1 := 1;

                        END;
                    END ELSE BEGIN

                    END;





                    ChqRecordCount := 0;
                    TempCheckVLEntry.RESET;
                    TempCheckVLEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
                    TempCheckVLEntry.SETRANGE("Vendor No.", TempVLEntry."Vendor No.");
                    TempCheckVLEntry.SETRANGE("Cheque No.", TempVLEntry."Cheque No.");
                    TempCheckVLEntry.SETRANGE("Posting Date", TempVLEntry."Posting Date");
                    IF TempCheckVLEntry.FINDSET THEN
                        ChqRecordCount := TempCheckVLEntry.COUNT;
                    IF ChqRecordCount = 1 THEN
                        CheqAmt := 0;

                    LastChqNo := TempVLEntry."Cheque No.";

                    IF LastChqNo <> TempVLEntry."Cheque No." THEN
                        CheqAmt := 0;
                    PrintBody2 := 0;
                    IF ChqRecordCount > 1 THEN BEGIN
                        TempCheckVLEntry.RESET;
                        TempCheckVLEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
                        TempCheckVLEntry.SETRANGE("Vendor No.", TempVLEntry."Vendor No.");
                        TempCheckVLEntry.SETRANGE("Cheque No.", TempVLEntry."Cheque No.");
                        TempCheckVLEntry.SETRANGE("Posting Date", TempVLEntry."Posting Date");
                        TempCheckVLEntry.SETFILTER("Document Type", '<>%1', TempCheckVLEntry."Document Type"::"Credit Memo");
                        IF TempCheckVLEntry.FINDLAST THEN BEGIN
                            CheqAmt := CheqAmt + BAmt;
                            IF TempCheckVLEntry."Entry No." = TempVLEntry."Entry No." THEN BEGIN
                                PrintBody2 := 1;
                            END ELSE
                                PrintBody2 := 0;
                        END;
                    END;
                    IF ChqRecordCount = 1 THEN
                        PrintBody2 := 0;


                    IF AllPayment_1 = AllPayment_1::"Without Adjustment" THEN BEGIN
                        PrintBody2 := 0;
                    END ELSE
                        PrintBody2 := 1;
                end;

                trigger OnPreDataItem()
                begin

                    CurrReport.CREATETOTALS(Clb9, Clb91, BAmt, TDSAmt, TempVLEntry."Credit Amount", TempVLEntry."Debit Amount", NAmt,
                    TempVLEntry.Amount);

                    TempVLEntry.SETCURRENTKEY("Vendor No.", "Posting Date", "Cheque No.");
                    SETRANGE(Number, 1, NoofRecord);
                    SNO := 0;

                    PrintBody1 := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                VLEExtDocNo: Code[20];
            begin

                Unitstup.GET;
                CLEAR(NOpAmt);
                Club_Invoice := 0;
                TDS_Invoice := 0;
                TotalAmt_Invoice := 0;
                Club_Invoice_1 := 0;
                TDS_Invoice_1 := 0;
                TotalAmt_Invoice_1 := 0;
                OpenInvAmt_1 := 0;
                TDS_Pmt := 0;
                Amt_Pmt := 0;
                Club_Pmt := 0;
                Doc_Pmt := '';
                Doc_Inv := '';
                TPSAmt := 0;

                CLEAR(PTDS);
                CLEAR(PClb);
                CLEAR(PAmt);
                CLEAR(PSAmt);
                CLEAR(Print);
                TotalTOPAmt := 0;
                TotalTClbO := 0;
                TotalTTDSO := 0;
                EntryNo := 0;
                CMAmt := 0;
                TempVLEntry.DELETEALL;
                TempPostedNarration.DELETEALL;
                TempAssocPmtVoucherHeader.DELETEALL;
                TempVoucherLine.DELETEALL;
                TempAppEntry.DELETEALL;
                TempCheckVLEntry.DELETEALL;

                CLEAR(CopyVLEntry);
                CLEAR(CopyPostedNarration);
                CLEAR(CopyAssocPmtVoucherHeader);
                CLEAR(CopyVoucherLine);
                CLEAR(CopyAppEntry);

                Unitstup.GET;
                CompanyWise.RESET;
                //CompanyWise.SETRANGE(CompanyWise."MSC Company",FALSE);  230915
                IF CompanyFilter <> '' THEN
                    CompanyWise.SETRANGE(CompanyWise."Company Code", CompanyFilter);
                CompanyWise.SETRANGE("Active for Reports", TRUE);
                IF CompanyWise.FINDSET THEN
                    REPEAT
                        CLEAR(NOpAmt);
                        CLEAR(PTDS);
                        CLEAR(PClb);
                        CLEAR(PAmt);
                        CLEAR(PSAmt);
                        CLEAR(Print);
                        OpenInvAmt_1 := 0;
                        VLE.RESET;
                        VLE.CHANGECOMPANY(CompanyWise."Company Code");
                        VLE.SETCURRENTKEY("Vendor No.", "Posting Date");
                        VLE.SETRANGE("Posting Date", 0D, 20130228D);//280213D
                        VLE.SETRANGE("Vendor No.", "No.");
                        VLE.SETRANGE("Drawing Ledger Data Exclude", FALSE); //130917
                        IF PostTypeFilter = PostTypeFilter::Incentive THEN
                            VLE.SETRANGE("Posting Type", VLE."Posting Type"::Incentive)
                        ELSE IF PostTypeFilter = PostTypeFilter::CommissionTA THEN
                            VLE.SETFILTER("Posting Type", '<>%1', VLE."Posting Type"::Incentive);
                        IF VLE.FINDSET THEN BEGIN
                            REPEAT
                                VLE.CALCFIELDS("Original Amt. (LCY)");
                                PAmt += VLE."Original Amt. (LCY)";
                            UNTIL VLE.NEXT = 0;
                            IF PAmt > 0 THEN BEGIN
                                PSAmt := PAmt;
                                PTDS := PSAmt * 10 / 100;
                                PClb := PSAmt * 1 / 100;
                            END ELSE BEGIN
                                PSAmt := 0;
                                OpenInvAmt_1 := PAmt;
                            END;
                            NOpAmt := PSAmt - PTDS - PClb;
                        END;
                        TPSAmt += PSAmt - PTDS - PClb;
                        TOpenInvAmt_1 += OpenInvAmt_1;

                        VLE2.RESET;
                        VLE2.CHANGECOMPANY(CompanyWise."Company Code");
                        VLE2.SETCURRENTKEY("Vendor No.", "Posting Date");
                        VLE2.SETRANGE("Vendor No.", "No.");
                        VLE2.SETRANGE("Posting Date", SDate, EDate);
                        VLE2.SETRANGE("Drawing Ledger Data Exclude", FALSE); //1309172
                        IF VLE2.FINDFIRST THEN
                            Print := TRUE;
                        IF (PSAmt = 0) AND (NOT Print) THEN BEGIN
                            //CurrReport.SKIP;
                        END ELSE BEGIN
                            DocNo := '';
                            CopyVLEntry.RESET;
                            CopyVLEntry.CHANGECOMPANY(CompanyWise."Company Code");
                            CopyVLEntry.SETCURRENTKEY("Vendor No.", "Document No.");
                            CopyVLEntry.SETRANGE("Vendor No.", "No.");
                            IF (SDate <> 0D) AND (EDate <> 0D) THEN
                                CopyVLEntry.SETRANGE("Posting Date", SDate, EDate);
                            CopyVLEntry.SETFILTER("Document Type", '%1|%2|%3|%4', CopyVLEntry."Document Type"::Payment,
                                         CopyVLEntry."Document Type"::"Credit Memo", CopyVLEntry."Document Type"::Refund,
                                         CopyVLEntry."Document Type"::" ");

                            CopyVLEntry.SETRANGE(Reversed, FALSE);
                            IF PostTypeFilter = PostTypeFilter::Incentive THEN
                                CopyVLEntry.SETRANGE("Posting Type", CopyVLEntry."Posting Type"::Incentive)
                            ELSE IF PostTypeFilter = PostTypeFilter::CommissionTA THEN
                                CopyVLEntry.SETFILTER("Posting Type", '<>%1', CopyVLEntry."Posting Type"::Incentive);
                            CopyVLEntry.SETRANGE("Payment Trasnfer from Other", FALSE);
                            CopyVLEntry.SETRANGE("Drawing Ledger Data Exclude", FALSE); //130917
                            CopyVLEntry.SetRange("Club 9 Entry", False);  //280225
                            IF CopyVLEntry.FINDSET THEN
                                REPEAT
                                    IF DocNo <> CopyVLEntry."Document No." THEN BEGIN
                                        DocNo := CopyVLEntry."Document No.";
                                        CopyVLEntry.CALCFIELDS(CopyVLEntry.Amount, CopyVLEntry."Amount (LCY)", CopyVLEntry."Debit Amount",
                                            CopyVLEntry."Credit Amount", CopyVLEntry."Debit Amount (LCY)", CopyVLEntry."Credit Amount (LCY)");

                                        VLEExtDocNo := '';                                                      //100820
                                        VLEExtDocNo := COPYSTR(CopyVLEntry."External Document No.", 1, 20);       //100820
                                        IF VLEExtDocNo <> '' THEN BEGIN                                         //100820
                                            CopyAssocPmtVoucherHeader.RESET;
                                            CopyAssocPmtVoucherHeader.CHANGECOMPANY(CompanyWise."Company Code");
                                            CopyAssocPmtVoucherHeader.SETRANGE("Document No.", VLEExtDocNo);
                                            CopyAssocPmtVoucherHeader.SETRANGE("Sub Type", CopyAssocPmtVoucherHeader."Sub Type"::Direct);
                                            IF CopyAssocPmtVoucherHeader.FINDSET THEN
                                                REPEAT
                                                    TempAssocPmtVoucherHeader.RESET;
                                                    TempAssocPmtVoucherHeader.SETRANGE("Document No.", CopyAssocPmtVoucherHeader."Document No.");
                                                    IF NOT TempAssocPmtVoucherHeader.FINDFIRST THEN BEGIN
                                                        TempAssocPmtVoucherHeader.INIT;
                                                        TempAssocPmtVoucherHeader.TRANSFERFIELDS(CopyAssocPmtVoucherHeader);
                                                        TempAssocPmtVoucherHeader.INSERT;

                                                        CopyVoucherLine.RESET;
                                                        CopyVoucherLine.CHANGECOMPANY(CompanyWise."Company Code");
                                                        CopyVoucherLine.SETRANGE("Voucher No.", CopyAssocPmtVoucherHeader."Document No.");
                                                        IF CopyVoucherLine.FINDSET THEN
                                                            REPEAT
                                                                TempVoucherLine.INIT;
                                                                TempVoucherLine.TRANSFERFIELDS(CopyVoucherLine);
                                                                TempVoucherLine.INSERT;
                                                            UNTIL CopyVoucherLine.NEXT = 0;
                                                    END;
                                                UNTIL CopyAssocPmtVoucherHeader.NEXT = 0;
                                        END;  //100820
                                              ///060417..........
                                        //OLD Code comment start  060417
                                        //          TempVLEntry.INIT;
                                        //          TempVLEntry.TRANSFERFIELDS(CopyVLEntry);
                                        //          TempVLEntry."Entry No." := EntryNo + 1;
                                        //          EntryNo := TempVLEntry."Entry No.";
                                        //         TempVLEntry."Company Name" := CompanyWise."Company Code";
                                        //         IF TempVLEntry."Cheque No." = '' THEN BEGIN
                                        //          TempVLEntry."Cheque No." := CopyAssocPmtVoucherHeader."Cheque No.";
                                        //         TempVLEntry."Cheque Date" := CopyAssocPmtVoucherHeader."Cheque Date";
                                        //      END;
                                        //     TempVLEntry.INSERT;
                                        //OLD Code Comment END 060417
                                        CopyVLEntry_1.RESET;
                                        CopyVLEntry_1.CHANGECOMPANY(CompanyWise."Company Code");
                                        CopyVLEntry_1.SETCURRENTKEY("Vendor No.", "Document No.");
                                        CopyVLEntry_1.SETRANGE("Vendor No.", "No.");
                                        CopyVLEntry_1.SETRANGE("Document No.", CopyVLEntry."Document No.");
                                        // IF (SDate <> 0D) AND (EDate <> 0D) THEN
                                        //   CopyVLEntry_1.SETRANGE("Posting Date",SDate,EDate);
                                        CopyVLEntry_1.SETFILTER("Document Type", '%1', CopyVLEntry_1."Document Type"::Refund);
                                        //      CopyVLEntry_1.SETRANGE(Reversed,FALSE);
                                        CopyVLEntry_1.SetRange("Club 9 Entry", False);  //280225
                                        IF NOT CopyVLEntry_1.FINDFIRST THEN BEGIN
                                            TempVLEntry.INIT;
                                            TempVLEntry.TRANSFERFIELDS(CopyVLEntry);
                                            TempVLEntry."Entry No." := EntryNo + 1;
                                            EntryNo := TempVLEntry."Entry No.";
                                            TempVLEntry."Company Name" := CompanyWise."Company Code";
                                            IF TempVLEntry."Cheque No." = '' THEN BEGIN
                                                TempVLEntry."Cheque No." := CopyAssocPmtVoucherHeader."Cheque No.";
                                                TempVLEntry."Cheque Date" := CopyAssocPmtVoucherHeader."Cheque Date";
                                            END;
                                            TempVLEntry.INSERT;
                                        END;
                                        ///060417..........

                                        TempCheckVLEntry.RESET;
                                        TempCheckVLEntry.SETRANGE("Entry No.", TempVLEntry."Entry No.");
                                        IF TempCheckVLEntry.FINDFIRST THEN BEGIN
                                            TempCheckVLEntry.TRANSFERFIELDS(TempVLEntry);
                                            TempCheckVLEntry.MODIFY;
                                        END ELSE BEGIN
                                            TempCheckVLEntry.INIT;
                                            TempCheckVLEntry.TRANSFERFIELDS(TempVLEntry);
                                            TempCheckVLEntry.INSERT;
                                        END;
                                        //05
                                        CopyPostedNarration.RESET;
                                        CopyPostedNarration.CHANGECOMPANY(CompanyWise."Company Code");
                                        //CopyPostedNarration.SETRANGE("Document No.",CopyVLEntry."Document No.");
                                        CopyPostedNarration.SETRANGE("Transaction No.", CopyVLEntry."Transaction No.");
                                        IF CopyPostedNarration.FINDSET THEN
                                            REPEAT
                                                TempPostedNarration.INIT;
                                                TempPostedNarration.TRANSFERFIELDS(CopyPostedNarration);
                                                TempPostedNarration."Line No." := PNarrLineNo + 1;
                                                TempPostedNarration.INSERT;
                                                PNarrLineNo := TempPostedNarration."Line No.";
                                            UNTIL CopyPostedNarration.NEXT = 0;

                                        CopyAppEntry.RESET;
                                        CopyAppEntry.CHANGECOMPANY(CompanyWise."Company Code");
                                        CopyAppEntry.SETRANGE("Posted Document No.", CopyVLEntry."Document No.");
                                        IF CopyAppEntry.FINDSET THEN
                                            REPEAT
                                                TempAppEntry.INIT;
                                                TempAppEntry.TRANSFERFIELDS(CopyAppEntry);
                                                TempAppEntry.INSERT;
                                            UNTIL CopyAppEntry.NEXT = 0;
                                    END;

                                UNTIL CopyVLEntry.NEXT = 0;

                            //--------------Opening Start------------------
                            CLEAR(TTDSO);
                            CLEAR(TOPAmt);
                            CLEAR(TClbO);

                            VLEntry.RESET;
                            VLEntry.CHANGECOMPANY(CompanyWise."Company Code");
                            VLEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
                            VLEntry.SETRANGE("Vendor No.", "No.");//1705
                            VLEntry.SETRANGE("Posting Date", 20130301D, SDate - 1);//010313D
                            VLEntry.SETRANGE("Document Type", VLEntry."Document Type"::Payment);
                            VLEntry.SETRANGE(Reversed, FALSE);
                            VLEntry.SETRANGE("Drawing Ledger Data Exclude", FALSE); //130917
                            IF VLEntry.FINDSET THEN BEGIN
                                REPEAT
                                    GLE_OpenTDS.RESET;
                                    GLE_OpenTDS.CHANGECOMPANY(CompanyWise."Company Code");
                                    GLE_OpenTDS.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                    GLE_OpenTDS.SETRANGE("Document No.", VLEntry."Document No.");
                                    GLE_OpenTDS.SETRANGE("Document Type", GLE_OpenTDS."Document Type"::Payment);
                                    GLE_OpenTDS.SETRANGE("G/L Account No.", Unitstup."Corpus A/C");
                                    GLE_OpenTDS.SETRANGE("Transaction No.", VLEntry."Transaction No.");
                                    IF GLE_OpenTDS.FINDSET THEN
                                        REPEAT
                                            TTDSO := TTDSO + GLE_OpenTDS.Amount;
                                        UNTIL GLE_OpenTDS.NEXT = 0;
                                    GLE_OpenClub.RESET;
                                    GLE_OpenClub.CHANGECOMPANY(CompanyWise."Company Code");
                                    GLE_OpenClub.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                    GLE_OpenClub.SETRANGE("Document No.", VLEntry."Document No.");
                                    GLE_OpenClub.SETRANGE("Document Type", GLE_OpenClub."Document Type"::Payment);
                                    GLE_OpenClub.SETRANGE("Transaction No.", VLEntry."Transaction No.");
                                    GLE_OpenClub.SETRANGE("G/L Account No.", '116400', '117100');
                                    IF GLE_OpenClub.FINDSET THEN
                                        REPEAT
                                            TClbO := TClbO + GLE_OpenClub.Amount;
                                        UNTIL GLE_OpenClub.NEXT = 0;

                                UNTIL VLEntry.NEXT = 0;
                            END;

                            TotalTOPAmt := TotalTOPAmt + TOPAmt;
                            TotalTClbO := TotalTClbO + TClbO;
                            TotalTTDSO := TotalTTDSO + TTDSO;

                            //---------------------For Opening--------------END-----------------
                        END;

                        //------------ Total TDS and Club Amount Start
                        Doc_Inv := '';
                        Doc_Pmt := '';
                        VLE_Invoice.RESET;
                        VLE_Invoice.CHANGECOMPANY(CompanyWise."Company Code");
                        VLE_Invoice.SETCURRENTKEY("Vendor No.", "Document No.");
                        VLE_Invoice.SETRANGE("Vendor No.", "No.");
                        // VLE_Invoice.SETFILTER("Document Type",'<>%1',VLE_Invoice."Document Type"::Payment);
                        VLE_Invoice.SETRANGE(Reversed, FALSE);
                        VLE_Invoice.SETRANGE("Posting Date", DMY2DATE(1, 3, 2013), EDate);
                        IF PostTypeFilter = PostTypeFilter::Incentive THEN
                            VLE_Invoice.SETRANGE("Posting Type", VLE_Invoice."Posting Type"::Incentive)
                        ELSE IF PostTypeFilter = PostTypeFilter::CommissionTA THEN
                            VLE_Invoice.SETFILTER("Posting Type", '<>%1', VLE_Invoice."Posting Type"::Incentive);
                        //   VLE_Invoice.SETRANGE("Payment Trasnfer from Other",FALSE);
                        VLE_Invoice.SETRANGE("Drawing Ledger Data Exclude", FALSE); //130917
                        IF VLE_Invoice.FINDSET THEN
                            REPEAT
                                IF VLE_Invoice."Document Type" = VLE_Invoice."Document Type"::Payment THEN BEGIN
                                    IF Doc_Pmt <> VLE_Invoice."Document No." THEN BEGIN
                                        Doc_Pmt := VLE_Invoice."Document No.";

                                        VLE_Payment_2.RESET;
                                        VLE_Payment_2.CHANGECOMPANY(CompanyWise."Company Code");
                                        VLE_Payment_2.SETCURRENTKEY("Document No.", "Document Type", "Vendor No.");
                                        VLE_Payment_2.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                        //          VLE_Payment_2.SETRANGE("Document Type",VLE_Invoice."Document Type");  //ALLEDK 070417
                                        VLE_Payment_2.SETFILTER("Document Type", '%1|%2', VLE_Invoice."Document Type", VLE_Payment_2."Document Type"::Refund);//070417

                                        VLE_Payment_2.SETRANGE("Vendor No.", VLE_Invoice."Vendor No.");
                                        IF VLE_Payment_2.FINDSET THEN
                                            REPEAT
                                                VLE_Payment_2.CALCFIELDS(Amount);
                                                Amt_Pmt := Amt_Pmt + VLE_Payment_2.Amount;
                                            UNTIL VLE_Payment_2.NEXT = 0;

                                        GLE_Payment.RESET;
                                        GLE_Payment.CHANGECOMPANY(CompanyWise."Company Code");
                                        GLE_Payment.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                        GLE_Payment.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                        GLE_Payment.SETRANGE("Document Type", GLE_Payment."Document Type"::Payment);
                                        GLE_Payment.SETRANGE("G/L Account No.", Unitstup."Corpus A/C");
                                        GLE_Payment.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                        IF GLE_Payment.FINDSET THEN
                                            REPEAT
                                                Club_Pmt := Club_Pmt + GLE_Payment.Amount;
                                            UNTIL GLE_Payment.NEXT = 0;
                                        GLE_Payment1.RESET;
                                        GLE_Payment1.CHANGECOMPANY(CompanyWise."Company Code");
                                        GLE_Payment1.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                        GLE_Payment1.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                        GLE_Payment1.SETRANGE("Document Type", GLE_Payment1."Document Type"::Payment);
                                        GLE_Payment1.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                        GLE_Payment1.SETRANGE("G/L Account No.", '116400', '117100');
                                        IF GLE_Payment1.FINDSET THEN
                                            REPEAT
                                                TDS_Pmt := TDS_Pmt + GLE_Payment1.Amount;
                                            //MESSAGE('%1..%2...%3',GLE_Invoice1.Amount,TDS_Invoice,GLE_Invoice1."Document No.");
                                            UNTIL GLE_Payment1.NEXT = 0;
                                    END;
                                END ELSE BEGIN

                                    VLE_Invoice.CALCFIELDS(Amount);
                                    IF VLE_Invoice."Posting Date" <= DMY2DATE(31, 8, 2016) THEN BEGIN
                                        IF Doc_Inv <> VLE_Invoice."Document No." THEN BEGIN
                                            GLE_Invoice.RESET;
                                            GLE_Invoice.CHANGECOMPANY(CompanyWise."Company Code");
                                            GLE_Invoice.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                            GLE_Invoice.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                            GLE_Invoice.SETRANGE("G/L Account No.", Unitstup."Corpus A/C");
                                            GLE_Invoice.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                            IF GLE_Invoice.FINDSET THEN
                                                REPEAT
                                                    Club_Invoice := Club_Invoice + GLE_Invoice.Amount;
                                                UNTIL GLE_Invoice.NEXT = 0;
                                            GLE_Invoice1.RESET;
                                            GLE_Invoice1.CHANGECOMPANY(CompanyWise."Company Code");
                                            GLE_Invoice1.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                            GLE_Invoice1.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                            GLE_Invoice1.SETRANGE("G/L Account No.", '116400', '117100');
                                            GLE_Invoice1.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                            IF GLE_Invoice1.FINDSET THEN
                                                REPEAT
                                                    TDS_Invoice := TDS_Invoice + GLE_Invoice1.Amount;
                                                //MESSAGE('%1..%2...%3',GLE_Invoice1.Amount,TDS_Invoice,GLE_Invoice1."Document No.");
                                                UNTIL GLE_Invoice1.NEXT = 0;
                                            //END;
                                        END;

                                        TotalAmt_Invoice := TotalAmt_Invoice + VLE_Invoice.Amount;
                                        //  VLE_Invoice."Find Entry_1" := TRUE;
                                        //  VLE_Invoice.MODIFY;

                                    END ELSE BEGIN
                                        IF Doc_Inv <> VLE_Invoice."Document No." THEN BEGIN
                                            GLE_Invoice.RESET;
                                            GLE_Invoice.CHANGECOMPANY(CompanyWise."Company Code");
                                            GLE_Invoice.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                            GLE_Invoice.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                            GLE_Invoice.SETRANGE("G/L Account No.", Unitstup."Corpus A/C");
                                            GLE_Invoice.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                            IF GLE_Invoice.FINDSET THEN
                                                REPEAT
                                                    Club_Invoice_1 := Club_Invoice_1 + GLE_Invoice.Amount;
                                                UNTIL GLE_Invoice.NEXT = 0;
                                            GLE_Invoice1.RESET;
                                            GLE_Invoice1.CHANGECOMPANY(CompanyWise."Company Code");
                                            GLE_Invoice1.SETCURRENTKEY("Document No.", "Posting Date", Amount);
                                            GLE_Invoice1.SETRANGE("Document No.", VLE_Invoice."Document No.");
                                            GLE_Invoice1.SETRANGE("G/L Account No.", '116400', '117100');
                                            GLE_Invoice1.SETRANGE("Transaction No.", VLE_Invoice."Transaction No.");
                                            IF GLE_Invoice1.FINDSET THEN
                                                REPEAT
                                                    TDS_Invoice_1 := TDS_Invoice_1 + GLE_Invoice1.Amount;
                                                UNTIL GLE_Invoice1.NEXT = 0;
                                            //END; Payment docuemnt skip
                                        END;

                                        TotalAmt_Invoice_1 := TotalAmt_Invoice_1 + VLE_Invoice.Amount;
                                        //  VLE_Invoice."Find Entry_1" := TRUE;
                                        // VLE_Invoice.MODIFY;
                                    END;
                                END;
                            UNTIL VLE_Invoice.NEXT = 0;



                    //------------ Total TDS and Club Amount End

                    UNTIL CompanyWise.NEXT = 0;
                NoofRecord := TempVLEntry.COUNT;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("No.", VendFilters);

                TPSAmt := 0;
                TOpenInvAmt_1 := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompInfo.GET;
        //ALLECK 120113 Start
        // ReportRequestfromWebMb.RESET;
        // ReportRequestfromWebMb.SETRANGE("Report Id", 33057782);
        // ReportRequestfromWebMb.SETRANGE("Report Generated", FALSE);
        // ReportRequestfromWebMb.SETFILTER("Associate Code", '<>%1', '');
        // IF ReportRequestfromWebMb.FindFirst THEN begin
        //     SDate := ReportRequestfromWebMb."From Date";
        //     EDate := ReportRequestfromWebMb."To Date";
        //     VendFilters := ReportRequestfromWebMb."Associate Code";
        //     ShowDetils_1 := TRUE;
        //     ShowSummary_1 := TRUE;
        // END;

        SDate := Stdt_1;
        EDate := EndDt_1;
        ShowDetils_1 := TRUE;
        ShowSummary_1 := TRUE;



    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Total: Decimal;
        ChqNo: Text[50];
        ChqDt: Date;
        CompInfo: Record "Company Information";
        DimValue: Record "Dimension Value";
        DimValueName: Text[50];
        VendorName: Text[50];
        AplctnPmtn: Record "Application Payment Entry";
        PMode: Option " ",Cash,Cheque,"D.D.",Transfer,"D.C./C.C./Net Banking","Refund Cash","Refund Cheque",AJVM;
        Unitstup: Record "Unit Setup";
        Clb9: Decimal;
        "G/LE": Record "G/L Entry";
        FilterUsed: Text[250];
        ExportToExcel: Boolean;
        //TDSE: Record 13729;
        TDSAmt: Decimal;
        BLE: Record "Bank Account Ledger Entry";
        BAmt: Decimal;
        CLE: Record "Cust. Ledger Entry";
        SDate: Date;
        EDate: Date;
        Options: Option All,Bank,Cash;
        CrAmt: Decimal;
        SubDoc: Text[30];
        PostingType: Text[30];
        Show: Boolean;
        ShowLNr: Boolean;
        GLE: Record "G/L Entry";
        NAmt: Decimal;
        OpAmt: Decimal;
        TOPAmt: Decimal;
        GLE2: Record "G/L Entry";
        CLE2: Record "Cust. Ledger Entry";
        BLE2: Record "Bank Account Ledger Entry";
        VLEntry: Record "Vendor Ledger Entry";
        VLE: Record "Vendor Ledger Entry";
        PAmt: Decimal;
        PTDS: Decimal;
        PClb: Decimal;
        NOpAmt: Decimal;
        PSAmt: Decimal;
        VLE2: Record "Vendor Ledger Entry";
        Print: Boolean;
        //TDSE2: Record 13729;
        TDSO: Decimal;
        TTDSO: Decimal;
        GLE3: Record "G/L Entry";
        ClbO: Decimal;
        TClbO: Decimal;
        DocType: Text[30];
        VLE4: Record "Vendor Ledger Entry";
        //TDSE4: Record 13729;
        VLE5: Record "Vendor Ledger Entry";
        GLE5: Record "G/L Entry";
        GLE1: Record "G/L Entry";
        Clb91: Decimal;
        BLE3: Record "Bank Account Ledger Entry";
        BName: Text[60];
        BAcnt: Record "Bank Account";
        CMAmt: Decimal;
        Narr: Text[200];
        ChLE: Record "Check Ledger Entry";
        PostTypeFilter: Option " ",Incentive,CommissionTA;
        VH: Record "Assoc Pmt Voucher Header";
        "-------------------------": Integer;
        CompanyWise: Record "Company wise G/L Account";
        CopyVLEntry: Record "Vendor Ledger Entry";
        TempVLEntry: Record "Vendor Ledger Entry" temporary;
        EntryNo: Integer;
        NoofRecord: Integer;
        CopyPostedNarration: Record "Posted Narration";//16548
        TempPostedNarration: Record "Posted Narration" temporary;//16548
        CopyAssocPmtVoucherHeader: Record "Assoc Pmt Voucher Header";
        TempAssocPmtVoucherHeader: Record "Assoc Pmt Voucher Header" temporary;
        CopyVoucherLine: Record "Voucher Line";
        TempVoucherLine: Record "Voucher Line" temporary;
        PNarrLineNo: Integer;
        CopyAppEntry: Record "Application Payment Entry";
        TempAppEntry: Record "Application Payment Entry" temporary;
        PNarrRec: Integer;
        TotalTOPAmt: Decimal;
        TotalTClbO: Decimal;
        TotalTTDSO: Decimal;
        TempCheckVLEntry: Record "Vendor Ledger Entry" temporary;
        ChqRecordCount: Integer;
        CheqAmt: Decimal;
        LastChqNo: Code[20];
        ShowRecord: Boolean;
        DocNo: Code[20];
        AllPayment_1: Option "Without Adjustment","With Adjustment";
        VLE_Invoice: Record "Vendor Ledger Entry";
        Doc_Inv: Code[20];
        GLE_Invoice: Record "G/L Entry";
        GLE_Invoice1: Record "G/L Entry";
        Club_Invoice: Decimal;
        TDS_Invoice: Decimal;
        TotalAmt_Invoice: Decimal;
        VLE_Payment: Record "Vendor Ledger Entry";
        Club_Invoice_1: Decimal;
        TDS_Invoice_1: Decimal;
        TotalAmt_Invoice_1: Decimal;
        OpenInvAmt_1: Decimal;
        GLE_Payment: Record "G/L Entry";
        GLE_Payment1: Record "G/L Entry";
        Club_Pmt: Decimal;
        TDS_Pmt: Decimal;
        Doc_Pmt: Code[20];
        VLE_Payment_2: Record "Vendor Ledger Entry";
        Amt_Pmt: Decimal;
        ShowDetils_1: Boolean;
        GLE_OpenTDS: Record "G/L Entry";
        GLE_OpenClub: Record "G/L Entry";
        GLE_CurrTDS: Record "G/L Entry";
        GLE_CurrClub: Record "G/L Entry";
        CompanyFilter: Text[60];
        Memberof: Record "Access Control";
        TPSAmt: Decimal;
        TOpenInvAmt_1: Decimal;
        ShowSummary_1: Boolean;
        ExistTempAssocPmtVoucherHeader: Record "Assoc Pmt Voucher Header";
        CopyVLEntry_1: Record "Vendor Ledger Entry";
        PrintBody2: Integer;
        PrintBody1: Integer;
        SNO: Integer;
        PrintOpening: Integer;
        Narration_1: Text;
        CompanywiseGLAccount: Record "Company wise G/L Account";
        UserSetup: Record "User Setup";
        RunAsExcel: Boolean;
        Single: Label '''';
        //ReportDetailsUpdate: Codeunit 50018;
        ReportFilters: Text;
        EntryNo_1: Integer;
        VendFilters: Code[20];
        BatchNos: Code[20];
        Stdt_1: Date;
        EndDt_1: Date;
        ReportRequestfromWebMb: Record "Report Request from Web/Mb.";

    procedure Setfilters(VendFilter: Code[20]; BatchNo: Code[20]; Stdt: Date; EndDt: Date)
    begin
        VendFilters := VendFilter;
        BatchNos := BatchNo;
        Stdt_1 := Stdt;
        EndDt_1 := EndDt;
    end;
}

