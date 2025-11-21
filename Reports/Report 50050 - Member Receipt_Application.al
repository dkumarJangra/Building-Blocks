report 50050 "Member Receipt_Application"
{
    // version ALLE-SS

    // ALLECK 180313: Flowed User Branch Code in place of Shortcut Dimension1 Code
    // ALLEAD 040713: LOGO REMOVED AS REQUESTED
    DefaultLayout = RDLC;
    RDLCLayout = './EPCReports/Member Receipt_Application.rdl';
    ApplicationArea = All;


    dataset
    {
        dataitem("New Application Booking"; "New Application Booking")
        {
            CalcFields = "Total Received Amount";
            column(CustName; 'Mr./Ms. ' + UPPERCASE(CustName))
            {
            }
            column(CustName1; UPPERCASE(CustName))
            {
            }
            column(No; "New Application Booking"."Application No.")
            {
            }
            column(BarcodeScan; BarcodeConverter("New Application Booking"."Application No."))//'*' + "New Application Booking"."Application No." + '*'
            {
            }
            column(CustMobile; '+91' + Cust."BBG Mobile No.")
            {
            }
            column(CustEmail; Cust."E-Mail")
            {
            }
            column(PostingDate_NewConfirmedOrder; FORMAT("New Application Booking"."Posting Date"))
            {
            }
            column(DimValueName; DimValueName)
            {
            }
            column(SaleableArea_NewConfirmedOrder; FORMAT("New Application Booking"."Saleable Area") + ' Sqd ')
            {
            }
            column(UmasterFacing; Umaster.Facing)
            {
            }
            column(TotalReceivedAmount_NewConfirmedOrder; FORMAT("New Application Booking"."Total Received Amount"))
            {
            }
            column(PlotAmt; FORMAT(PlotAmt))
            {
            }
            column(DueAmt; FORMAT(DueAmt))
            {
            }
            column(PlotNo1; PlotNo1)
            {
            }
            column(PaymentMethod; NewAppPay1."Payment Method")
            {
            }
            column(Amount; NewAppPay1.Amount)
            {
            }
            column(BankAndBranch; NewAppPay1."Cheque Bank and Branch")
            {
            }
            column(ChecqueNo; NewAppPay1."Cheque No./ Transaction No.")
            {
            }
            column(ChecqueDate; FORMAT(NewAppPay1."Cheque Date"))
            {
            }
            column(DataText; DataText)
            {
            }
            column(BackPagePicture; CompInfo."Back Page Picture")
            {
            }
            column(HeaderPicture; CompInfo."Header Picture")
            {
            }
            column(FooterPicture; CompInfo."Footer Picture")
            {
            }
            column(RespCentrePicture; RespCenter.Picture)
            {
            }
            column(PlotCaption_; PlotCaption)
            {
            }
            column(PrintPlotNo; PlotNo)
            {
            }
            dataitem("NewApplication Payment Entry"; "NewApplication Payment Entry")
            {
                DataItemLink = "Document No." = FIELD("Application No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Payment Mode" = FILTER(<> JV),
                                          "Cheque Status" = FILTER(<> Cancelled));
                RequestFilterFields = "Posting date", "Posted Document No.";
                column(Postingdate_NewApplicationPaymentEntry; FORMAT("NewApplication Payment Entry"."Posting date"))
                {
                }
                column(PostedDocumentNo_NewApplicationPaymentEntry; "NewApplication Payment Entry"."Posted Document No.")
                {
                }
                column(Amount_NewApplicationPaymentEntry; "NewApplication Payment Entry".Amount)
                {
                }
                column(ChequeStatus_NewApplicationPaymentEntry1; "NewApplication Payment Entry"."Cheque Status")
                {
                }
                column(ChequeNoTransactionNo_NewApplicationPaymentEntry; "NewApplication Payment Entry"."Cheque No./ Transaction No.")
                {
                }
                column(ChequeDate_NewApplicationPaymentEntry; FORMAT("NewApplication Payment Entry"."Cheque Date"))
                {
                }
                column(PaymentMethod_NewApplicationPaymentEntry; "NewApplication Payment Entry"."Payment Method")
                {
                }
                column(BarCodeNo; BarCodeNo)
                {
                }
                column(SkipRow; SkipRow)
                {
                }
                column(FooterDesc; FooterDesc)
                {
                }
                column(ChequeStatus_NewApplicationPaymentEntry; CheqStatus)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SkipRow += 1;


                    CheqStatus := '';
                    IF "NewApplication Payment Entry"."Cheque Status" = "NewApplication Payment Entry"."Cheque Status"::" " THEN
                        CheqStatus := 'UC';

                    IF "NewApplication Payment Entry"."Cheque Status" = "NewApplication Payment Entry"."Cheque Status"::Cleared THEN
                        CheqStatus := 'C';

                    IF "NewApplication Payment Entry"."Cheque Status" = "NewApplication Payment Entry"."Cheque Status"::Bounced THEN
                        CheqStatus := 'B';


                    IF "NewApplication Payment Entry"."Deposit/Paid Bank" <> '' THEN
                        BankAccount.CHANGECOMPANY("New Application Booking"."Company Name");
                    IF BankAccount.GET("NewApplication Payment Entry"."Deposit/Paid Bank") THEN;
                    FooterDesc := '';

                    IF "New Application Booking"."Company Name" = 'BBG India Developers LLP' THEN BEGIN
                        FooterDesc := 'All Payments to be made in favour of ' + "Company Name" + ', A/C No: ' +
                        BankAccount."Bank Account No." + ', IFSC: ' + BankAccount."RTGS/IFSC"
                        + ', Bank/Branch: ' + BankAccount."Branch Name";

                    END ELSE BEGIN
                        RespCenters_1.RESET;
                        IF RespCenters_1.GET("New Application Booking"."Shortcut Dimension 1 Code") THEN BEGIN
                            IF (RespCenters_1."Project Bank Account No." <> '') THEN BEGIN
                                FooterDesc := 'All Payments to be made in favour of ' + "Company Name" + ', A/C No: ' +
                                RespCenters_1."Project Bank Account No." + ', IFSC: ' + RespCenters_1."Project Bank IFSC Code"
                                + ', Bank/Branch: ' + RespCenters_1."Project Branch Name";
                            END ELSE
                                FooterDesc := 'All Payments to be made in favour of ' + "Company Name" + ', A/C No: ' +
                                Companyinformation_1."Company Bank Account No." + ', IFSC: ' + Companyinformation_1."Company Bank IFSC Code"
                                + ', Bank/Branch: ' + Companyinformation_1."Company Branch Name";
                        END;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    SkipRow := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                //IF Cust.GET("Customer No.")THEN;

                CapPlot := '';
                PlotNo := '';
                THeadName := '';
                THeadPHNo := '';
                THeadEmailID := '';
                PlotCaption := '';
                LLPTXT := '';
                IF ("Posting Date" >= DMY2DATE(1, 7, 2017)) THEN
                    LLPTXT := 'Company Name';
                LLPName := '';

                IF ShowPlot THEN BEGIN
                    PlotCaption := 'Plot No.';
                    //CapPlot := 'Plot No. :';
                    PlotNo := "Unit Code";
                END;

                IF "Unit Code" <> '' THEN BEGIN
                    IF Umaster.GET("Unit Code") THEN
                        LLPName := ':' + ' ' + Umaster."Company Name";
                END;
                /*
              END ELSE BEGIN
                IF "LLP Name" <> '' THEN
                  LLPName := ':'+' '+"LLP Name"
                ELSE
                  LLPName := ':'+' '+"Company Name";

              END;
              */
                IF ("Posting Date" < DMY2DATE(1, 7, 2017)) THEN
                    LLPName := '';
                PlotCost := '';
                PlotAmt := 0;
                CapDueAmt := '';
                DueAmt := 0;

                RespCenter.RESET;
                IF RespCenter.GET("Shortcut Dimension 1 Code") THEN BEGIN
                    RespCenter.CALCFIELDS(Picture);
                    IF NOT RespCenter."Fields Not Show on Receipt" THEN BEGIN
                        PlotCost := 'Plot Cost';
                        PlotAmt := "New Application Booking"."Investment Amount";
                        CapDueAmt := 'Amount Due';
                        DueAmt := "New Application Booking"."Investment Amount" - ABS("Total Received Amount");
                    END;
                END;

                //IF "Bill-to Customer Name" = '' THEN BEGIN
                IF Cust.GET("Customer No.") THEN
                    CustName := Cust.Name;
                //END ELSE
                //  CustName := "Bill-to Customer Name";


                TotalAmt := 0;
                TotalAmt := "Total Received Amount";
                //AlleCk 050113 Start
                CLEAR(NewAppPay1);
                NewAppPay1.RESET;
                NewAppPay1.SETRANGE("Document No.", "Application No.");
                IF NewAppPay1.FINDLAST THEN BEGIN
                    AmountToWords.InitTextVariable;
                    AmountToWords.FormatNoText(AmountText, NewAppPay1.Amount, '');
                END;

                BarCodeNo := '';
                DataText := '';
                CLEAR(NewApEntry);
                NewApEntry.RESET;
                NewApEntry.SETRANGE("Document No.", "Application No.");
                NewApEntry.SETFILTER("BarCode No.", '<>%1', '');
                IF NewApEntry.FINDLAST THEN BEGIN
                    BarCodeNo := NewApEntry."BarCode No.";
                END;
                IF Cust.GET("Customer No.") THEN;
                DataText := 'Received with thanks from Mr/Ms.' + ' ' + UPPERCASE(Cust.Name) + ' ' + 'a sum of rupees Rs.' + ' ' +
                            FORMAT(NewAppPay1.Amount) + '/- (' + AmountText[1] + AmountText[2] + ')';


                //AlleCk 050113 End
                GenLedSetup.GET;
                IF DimValue.GET(GenLedSetup."Global Dimension 1 Code", "Shortcut Dimension 1 Code") THEN
                    DimValueName := DimValue.Name;

                IF NOT CurrReport.PREVIEW THEN BEGIN
                    InsertPrintLog('Member Receipt', "Application No.");
                END;

                //040517 code comment
                /*
                  CLEAR(AsswithApp);
                  AsswithApp.RESET;
                  AsswithApp.CHANGECOMPANY("Company Name");
                  AsswithApp.SETRANGE("Application Code","Application No.");
                  AsswithApp.SETRANGE(Status,Status::Active);
                  AsswithApp.SETFILTER("Rank Code",'<>%1',13);
                  IF AsswithApp.FINDLAST THEN BEGIN
                    CLEAR(Vend);
                    THeadName :='';
                    THeadPHNo := '';
                    THeadEmailID :='';
                    IF Vend.GET(AsswithApp."Associate Code") THEN BEGIN
                     IF Vend."Print Associate Name/Mobile" THEN BEGIN
                      THeadName := Vend.Name;
                      THeadPHNo := '+91 '+Vend."Mob. No.";
                      THeadEmailID := Vend."E-Mail";
                     END;
                    END;
                END ELSE BEGIN
                  AsswithApp.RESET;
                  AsswithApp.SETRANGE("Application Code","Application No.");
                  AsswithApp.SETFILTER("Rank Code",'<>%1',13);
                  IF AsswithApp.FINDLAST THEN BEGIN
                    CLEAR(Vend);
                    THeadName :='';
                    THeadPHNo := '';
                    THeadEmailID :='';
                    IF Vend.GET(AsswithApp."Associate Code") THEN BEGIN
                      IF Vend."Print Associate Name/Mobile" THEN BEGIN
                      THeadName := Vend.Name;
                      THeadPHNo := '+91 '+Vend."Mob. No.";
                      THeadEmailID := Vend."E-Mail";
                      END;
                    END;
                  END;
                END;
                */ //040517 code comment

                //040517 Added
                RecJob_1.RESET;
                RecJob_1.GET("Shortcut Dimension 1 Code");
                RegionwiseVendor_1.RESET;
                RegionwiseVendor_1.SETRANGE("Region Code", RecJob_1."Region Code for Rank Hierarcy");
                RegionwiseVendor_1.SETFILTER("No.", "Associate Code");
                IF RegionwiseVendor_1.FINDFIRST THEN BEGIN
                    CLEAR(Vend);
                    THeadName := '';
                    THeadPHNo := '';
                    THeadEmailID := '';
                    IF RegionwiseVendor_1."Print Team Head" <> '' THEN
                        IF Vend.GET(RegionwiseVendor_1."Print Team Head") THEN
                            IF Vend."BBG Print Associate Name/Mobile" THEN BEGIN
                                IF Vend."BBG Alternate Name" <> '' THEN
                                    THeadName := Vend."BBG Alternate Name"
                                ELSE
                                    THeadName := Vend.Name;

                                //        THeadName := Vend.Name;
                                THeadPHNo := '91 ' + Vend."BBG Mob. No.";
                                THeadEmailID := Vend."E-Mail";
                            END;
                END;

                NofoRecord := 0;


                CLEAR(AsswithApp);
                AsswithApp.RESET;
                //  AsswithApp.CHANGECOMPANY("Company Name");
                AsswithApp.SETRANGE("Application Code", "Application No.");
                AsswithApp.SETRANGE(Status, AsswithApp.Status::Active);
                AsswithApp.SETFILTER("Rank Code", '<>%1', 13);
                AsswithApp.ASCENDING(FALSE);
                IF AsswithApp.FINDFIRST THEN BEGIN
                    REPEAT
                        NofoRecord := NofoRecord + 1;
                        IF NofoRecord = 2 THEN BEGIN
                            CLEAR(Vend);
                            THeadName1 := '';
                            THeadPHNo1 := '';
                            IF Vend.GET(AsswithApp."Associate Code") THEN BEGIN
                                //       IF Vend."Print Associate Name/Mobile" THEN BEGIN
                                IF Vend."BBG Alternate Name" <> '' THEN
                                    THeadName1 := Vend."BBG Alternate Name"
                                ELSE
                                    THeadName1 := Vend.Name;

                                THeadPHNo1 := '+91 ' + Vend."BBG Mob. No.";
                            END;
                        END;
                        IF NofoRecord = 3 THEN BEGIN
                            CLEAR(Vend);
                            THeadName2 := '';
                            THeadPHNo2 := '';
                            IF Vend.GET(AsswithApp."Associate Code") THEN BEGIN
                                //       IF Vend."Print Associate Name/Mobile" THEN BEGIN
                                IF Vend."BBG Alternate Name" <> '' THEN
                                    THeadName2 := Vend."BBG Alternate Name"
                                ELSE
                                    THeadName2 := Vend.Name;

                                //          THeadName2 := Vend.Name;
                                THeadPHNo2 := '+91 ' + Vend."BBG Mob. No.";
                            END;
                        END;
                    UNTIL AsswithApp.NEXT = 0;
                END;

                RegName := '';
                RegVend.RESET;
                RegVend.GET("Associate Code");
                IF RegVend."BBG Alternate Name" <> '' THEN
                    RegName := RegVend."BBG Alternate Name"
                ELSE
                    RegName := RegVend.Name;

                //040517 Added

                CLEAR(NewAppPay);
                NewAppPay.RESET;
                NewAppPay.SETRANGE("Document No.", "Application No.");
                IF NewAppPay.FINDFIRST THEN;

            end;

            trigger OnPreDataItem()
            begin

                SETRANGE("Application No.", AppNo1);
                IF Users.GET(USERID) THEN BEGIN
                    UserName := Users."User ID";
                    //UserIden := Users."User ID";  //ALLECK 200113 START
                END;

                CustName := '';

                CLEAR(Vend);
                IF Vend.GET("Associate Code") THEN;
            end;
        }
        dataitem(Integer; Integer)
        {
            DataItemTableView = WHERE(Number = CONST(1));

            trigger OnAfterGetRecord()
            begin
                RespCenter.RESET;
                IF RespCenter.GET("New Application Booking"."Shortcut Dimension 1 Code") THEN
                    IF RespCenter."Print Image on Reciept" THEN BEGIN
                        RespCenter.CALCFIELDS(Picture);
                    END;
            end;

            trigger OnPreDataItem()
            begin
                //setrange(Number,1,15);
            end;
        }
        dataitem(Integer_1; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1));
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Print Plot"; ShowPlot)
                {
                    ApplicationArea = All;
                }
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
        CompInfo.CALCFIELDS("Header Picture");
        CompInfo.CALCFIELDS("Footer Picture");
        CompInfo.CALCFIELDS("Back Page Picture");
    end;

    var
        CompInfo: Record "Company Information";
        Cust: Record Customer;
        FormatAddr: Codeunit "Format Address";
        AmountToWords: Codeunit "Amount To Words";
        CompanyAddr: array[8] of Text[300];
        AmountText: array[2] of Text[300];
        Counter: Integer;
        TotalAmount: array[2] of Text[300];
        TextConvert: Report Check;
        Users: Record "User Setup";
        UserName: Text[300];
        UserIden: Code[20];
        ApplicationPaymentEntry: Record "NewApplication Payment Entry";
        Head: Code[20];
        DimValue: Record "Dimension Value";
        DimValueName: Text[50];
        RoundingFactor: Decimal;
        ChequeInfo: Text[300];
        Branch: Text[100];
        AplctnPmntEntry: Record "NewApplication Payment Entry";
        Amt: Decimal;
        PMode: Text[30];
        CompCompInfo: Record "Company Information";
        GenLedSetup: Record "General Ledger Setup";
        AppPayEntry: Record "NewApplication Payment Entry";
        TotalAmt: Decimal;
        BRNAme: Text[60];
        BondPrintLog: Record "Unit Print Log";
        PostDocNo: Code[20];
        AppNo1: Code[20];
        Description: Text[30];
        NoofRec: Integer;
        AmountText1: array[2] of Text[300];
        CustName: Text[60];
        RespCenter: Record "Responsibility Center 1";
        Vend: Record Vendor;
        THeadName: Text[50];
        THeadPHNo: Text[30];
        DueDate: Date;
        RecdAmt: Decimal;
        MOPayment: Text[30];
        ChqNo: Text[30];
        NewAppPay: Record "NewApplication Payment Entry";
        AsswithApp: Record "Associate Hierarcy with App.";
        DueAmtArry: array[6] of Decimal;
        RecdAmtArry: array[6] of Decimal;
        RemAmtArry: array[6] of Decimal;
        DueDateArry: array[6] of Date;
        PayPlanDetails: Record "Payment Plan Details";
        PayPlanDetails1: Record "Payment Plan Details";
        i: Integer;
        Elg: Decimal;
        IG: Decimal;
        Umaster: Record "Unit Master";
        THeadEmailID: Text[100];
        NewAppPay1: Record "NewApplication Payment Entry";
        CheqStatus: Text[5];
        CapPlot: Text[20];
        PlotNo: Text[60];
        ShowPlot: Boolean;
        PlotCost: Text[17];
        PlotAmt: Decimal;
        CapDueAmt: Text[15];
        DueAmt: Decimal;
        PlotNo1: Text[30];
        DataText: Text[500];
        BarCodeNo: Code[20];
        NewApEntry: Record "NewApplication Payment Entry";
        RegionwiseVendor_1: Record "Region wise Vendor";
        RecJob_1: Record Job;
        LLPName: Text[70];
        LLPTXT: Text[30];
        Companyinformation_1: Record "Company Information";
        FooterDesc: Text[500];
        THeadName1: Text[60];
        THeadPHNo1: Code[20];
        THeadPHNo2: Code[20];
        THeadName2: Text[60];
        NofoRecord: Integer;
        RegVend: Record Vendor;
        RegName: Text[60];
        RespCenters_1: Record "Responsibility Center 1";
        BankAccount: Record "Bank Account";
        Text0007: Label 'Received with tahnks from %1 a sum of rupees Rs. %2/-(%3)';
        SkipRow: Integer;
        PlotCaption: Text;

    procedure InsertPrintLog(Description: Text[250]; BondNo: Code[20])
    var
        EntryNo: Integer;
    begin
        BondPrintLog.SETRANGE("Unit No.", BondNo);
        IF BondPrintLog.FINDLAST THEN
            EntryNo := BondPrintLog."Line No." + 1
        //EntryNo += BondPrintLog."Line No."
        ELSE
            EntryNo := 1;
        BondPrintLog.INIT;
        BondPrintLog."Unit No." := BondNo;
        BondPrintLog."Report Type" := BondPrintLog."Report Type"::Acknowledgement;
        BondPrintLog."Line No." := EntryNo;
        BondPrintLog."User ID" := USERID;
        BondPrintLog.Date := WORKDATE;
        BondPrintLog.Description := Description;
        BondPrintLog.Time := TIME;
        BondPrintLog."Printing Status" := BondPrintLog."Printing Status"::Printed;
        BondPrintLog.INSERT;
    end;

    procedure SetPostFilter(AppNo: Code[20]; PostedDocNo: Code[20])
    begin
        AppNo1 := AppNo;
        PostDocNo := PostedDocNo;
    end;

    procedure BarcodeConverter(GlobalBarcodeString: Text): Text
    var
        BarcodeString: Text;
        BarcodeSymbology: Enum "Barcode Symbology";
        BarcodeFontProvider: Interface "Barcode Font Provider";
        EncodedText: Text;
    Begin
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        BarcodeSymbology := Enum::"Barcode Symbology"::Code39;
        BarcodeString := GlobalBarcodeString;
        BarcodeFontProvider.ValidateInput(BarcodeString, BarcodeSymbology);
        EncodedText := BarcodeFontProvider.EncodeFont(BarcodeString, BarcodeSymbology);
        exit(EncodedText);
    End;

    procedure BarcodeConverter2D(GlobalBarcodeString: Text): Text
    var
        BarcodeString: Text;
        BarcodeSymbology2D: Enum "Barcode Symbology 2D";
        BarcodeFontProvider2D: Interface "Barcode Font Provider 2D";
        EncodedText: Text;
    Begin
        //QR.GenerateQRCodeImage(GlobalBarcodeString, TempBlob);
        BarcodeFontProvider2D := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
        BarcodeSymbology2D := Enum::"Barcode Symbology 2D"::"QR-Code";
        BarcodeString := GlobalBarcodeString;
        //BarcodeFontProvider2D.ValidateInput(BarcodeString, BarcodeSymbology);
        EncodedText := BarcodeFontProvider2D.EncodeFont(BarcodeString, BarcodeSymbology2D);
        exit(EncodedText);
    End;

}

