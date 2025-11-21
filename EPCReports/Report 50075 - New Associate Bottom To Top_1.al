report 50075 "New Associate Bottom To Top_1"
{
    // version using

    //DefaultLayout = RDLC;
    ProcessingOnly = True;
    //RDLCLayout = './Reports/New Associate Bottom To Top_1.rdl';
    ApplicationArea = All;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = FILTER(1 ..));

            trigger OnAfterGetRecord()
            begin

                IF Number = 1 THEN
                    Chain.FIND('-')
                ELSE
                    Chain.NEXT;
                CLEAR(Vend);
                Designation := '';


                IF Vend.GET(Chain."No.") THEN BEGIN
                END ELSE
                    CurrReport.SKIP;

                EntryNo := EntryNo + 1;
                AssBottomtoTopData.INIT;
                AssBottomtoTopData."Entry No." := EntryNo;
                AssBottomtoTopData."Associate Code" := Chain."No.";
                AssBottomtoTopData."User Id" := USERID;
                AssBottomtoTopData."Active Data" := TRUE;
                AssBottomtoTopData."Current Associate Code" := AssociateCode;
                AssBottomtoTopData."Creation Date" := TODAY;
                AssBottomtoTopData.INSERT;
            end;

            trigger OnPostDataItem()
            begin

                AssocaiteCreationSMSData.RESET;
                AssocaiteCreationSMSData.SETRANGE("User Id", USERID);
                IF AssocaiteCreationSMSData.FINDLAST THEN
                    IF AssocaiteCreationSMSData."Entry No." > 4 THEN BEGIN
                        LAstEntryNo := AssocaiteCreationSMSData."Entry No.";
                        AssCreationSMSData.RESET;
                        AssCreationSMSData.SETRANGE("User Id", USERID);
                        AssCreationSMSData.SETRANGE("Entry No.", 3, LAstEntryNo - 2);
                        IF AssCreationSMSData.FINDSET THEN
                            REPEAT
                                AssCreationSMSData."Active Data" := FALSE;
                                AssCreationSMSData.MODIFY;
                            UNTIL AssCreationSMSData.NEXT = 0;
                    END;

                IF VFromAssociateCreation THEN
                    AssociateCreation;

                //IF VFromAssociateChange THEN
                //  AssociateChange;
                IF VFromCustomerChequeBounce THEN
                    CustomerChequeBounced;
                IF VFromAssociatePromotion THEN
                    AssociatePromotion;

                IF VFromAssociateDemotion THEN
                    AssociateDemotion;

                IF VFromAssociateParentchange THEN
                    AssociateParentChange;
                IF vCustomerRefund THEN
                    CustomerRefund;
            end;

            trigger OnPreDataItem()
            begin

                WEDate := TODAY;
                //AssociateCode := 'IBA0156664';
                //RankCode := 'R0001';
                IF RankCode = '' THEN
                    ERROR('Please fill the Rank Code');
                ChainMgt.NewInitChain;
                ChainMgt.NewChainFromToUp(AssociateCode, WEDate, FALSE, RankCode);
                ChainMgt.NewUpdateChainRank(WEDate, RankCode);
                ChainMgt.NewReturnChain(Chain);
                Chain.SETCURRENTKEY("Rank Code");
                Chain.ASCENDING(FALSE);
                SETRANGE(Number, 1, Chain.COUNT);

                AssBottomtoTopData.RESET;
                AssBottomtoTopData.SETRANGE("User Id", USERID);
                IF AssBottomtoTopData.FINDSET THEN
                    REPEAT
                        AssBottomtoTopData.DELETE;
                    UNTIL AssBottomtoTopData.NEXT = 0;

                AssBottomtoTopData.RESET;
                AssBottomtoTopData.SETRANGE("User Id", USERID);
                IF AssBottomtoTopData.FINDLAST THEN
                    EntryNo := AssBottomtoTopData."Entry No."
                ELSE
                    EntryNo := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
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
    end;

    var
        Text000: Label 'Invalid Parameters.';
        CompInfo: Record "Company Information";
        Filters: Text[30];
        AssociateCode: Code[20];
        ChainMgt: Codeunit "Unit Post";
        Chain: Record "Region wise Vendor" temporary;
        LastRank: Integer;
        Vend: Record Vendor;
        GetDesc: Codeunit GetDescription;
        SlNo: Integer;
        Rank: Record Rank;
        Designation: Text[30];
        Vend2: Record Vendor;
        VendStatus: Option " ",Provisional,Active,Inactive;
        ExportToExcel: Boolean;
        Vend3: Record Vendor;
        VName: Text[30];
        WEDate: Date;
        "VendMobNo.": Text[30];
        RankCode: Code[10];
        AssBottomtoTopData: Record "SMS Associate Promotion/Demot";
        EntryNo: Integer;
        AssocaiteCreationSMSData: Record "SMS Associate Promotion/Demot";
        LAstEntryNo: Integer;
        AssCreationSMSData: Record "SMS Associate Promotion/Demot";
        CustMobileNo: Text[30];
        CustSMSText: Text[500];
        RecVendor: Record Vendor;
        SMSVendor: Record Vendor;
        PostPayment: Codeunit PostPayment;
        VFromAssociateCreation: Boolean;
        VFromAssociateChange: Boolean;
        VFromCustomerChequeBounce: Boolean;
        VFromAssociatePromotion: Boolean;
        VFromAssociateDemotion: Boolean;
        VFromAssociateParentchange: Boolean;
        VTText: Text[30];
        PPSetup: Record "Purchases & Payables Setup";
        VPostDate: Date;
        VassociateCode: Code[20];
        VRegionCode: Code[10];
        VAppNo: Code[20];
        VProjectName: Text[50];
        VAppAmount: Decimal;
        VCheqDate: Date;
        VCustomerName: Text[50];
        VAssociateName: Text[50];
        vCustomerRefund: Boolean;
        VCustMbNo: Text[30];
        VCustName: Text[50];
        VProjName: Text[50];
        VRefundAmt: Decimal;
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text;
        SmsMessage1: Text;
        NewConfirmedOrder: Record "New Confirmed Order";
        Customer: Record Customer;
        GetDescription: Codeunit GetDescription;
        CheckMobileNoforSMS: Codeunit "Check Mobile No for SMS";
        ExitMessage: Boolean;

    procedure SetfValues(AssociateCode1: Code[20]; RankCode1: Code[10]; FromAssociateCreation: Boolean; FromAssociatePromotion: Boolean; FromAssociateDemotion: Boolean; FromAssociateParentchange: Boolean; TText: Text[30]; PostDate: Date)
    begin
        AssociateCode := AssociateCode1;
        RankCode := RankCode1;
        VFromAssociateCreation := FromAssociateCreation;
        //VFromAssociateChange := FromAssociateChange;
        VFromAssociatePromotion := FromAssociatePromotion;
        VFromAssociateDemotion := FromAssociateDemotion;
        VFromAssociateParentchange := FromAssociateParentchange;
        VTText := TText;
        VPostDate := PostDate;
    end;

    procedure AssociateCreation()
    begin
        PPSetup.GET;
        RecVendor.GET(AssociateCode);
        AssocaiteCreationSMSData.RESET;
        AssocaiteCreationSMSData.SETRANGE("User Id", USERID);
        AssocaiteCreationSMSData.SETRANGE("Active Data", TRUE);
        AssocaiteCreationSMSData.SETRANGE("Current Associate Code", AssociateCode);
        AssocaiteCreationSMSData.SETFILTER("Associate Code", '<>%1', AssociateCode);
        IF AssocaiteCreationSMSData.FINDSET THEN BEGIN
            REPEAT
                SMSVendor.GET(AssocaiteCreationSMSData."Associate Code");
                Vend.GET(AssociateCode);
                IF SMSVendor."BBG Mob. No." <> '' THEN BEGIN
                    CustSMSText := '';
                    CustMobileNo := '';
                    CustMobileNo := SMSVendor."BBG Mob. No.";
                    CustSMSText :=
                     'Dear Mr/Ms:' + RecVendor.Name + '' + '. Congratulation. Your new member has got enrolled in' +
                     'Building Blocks Group with Business Id No:' + AssociateCode + ', Name' + Vend.Name + ', Date: ' + FORMAT(TODAY) +
                     'Team BBG';
                    CLEAR(PostPayment);
                    PostPayment.SendSMS(CustMobileNo, CustSMSText);

                    //ALLEDK15112022 Start
                    CLEAR(SMSLogDetails);
                    SmsMessage := '';
                    SmsMessage1 := '';
                    SmsMessage := COPYSTR(CustSMSText, 1, 250);
                    SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', SMSVendor."No.", SMSVendor.Name, 'New Associate Enrolled', '', '', '');
                    //ALLEDK15112022 END
                    SLEEP(100);
                    COMMIT;
                END;
            UNTIL AssocaiteCreationSMSData.NEXT = 0;
            MESSAGE('%1', 'SMS Sent');
        END;
    end;

    procedure CustomerChequeBounced()
    begin
        PPSetup.GET;
        RecVendor.GET(AssociateCode);
        AssocaiteCreationSMSData.RESET;
        AssocaiteCreationSMSData.SETRANGE("User Id", USERID);
        AssocaiteCreationSMSData.SETRANGE("Active Data", TRUE);
        AssocaiteCreationSMSData.SETRANGE("Current Associate Code", AssociateCode);
        IF AssocaiteCreationSMSData.FINDSET THEN
            REPEAT
                SMSVendor.GET(AssocaiteCreationSMSData."Associate Code");
                IF SMSVendor."BBG Mob. No." <> '' THEN BEGIN
                    CustMobileNo := '';
                    CustSMSText := '';
                    CustMobileNo := SMSVendor."BBG Mob. No.";
                    CustSMSText :=
                       'Dear Customer, Your CHEQUE Got Bounced & Request to process the Payment immediately. Name:' +
                        VCustomerName + ', Appl No: ' + VAppNo + ',Project: ' + VProjectName + ', Amount: Rs.' +
                        FORMAT(VAppAmount) + ', Date:' + FORMAT(VCheqDate) + ',' +
                        'Thank you & Assuring you of Best Property Services with Building Blocks Group';


                    CLEAR(PostPayment);
                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                    SLEEP(100);
                END;
            UNTIL AssocaiteCreationSMSData.NEXT = 0;

        IF VCustMbNo <> '' THEN BEGIN
            CustMobileNo := '';
            CustMobileNo := VCustMbNo;
            CustSMSText := '';
            CustSMSText :=
                'Dear Customer, Your CHEQUE Got Bounced & Request to process the Payment immediately. Name: Mr/Ms ' +
                 VCustomerName + ', Appl No: ' + VAppNo + ',Project: ' + VProjectName + ', Amount: Rs.' +
                 FORMAT(VAppAmount) + ', Date:' + FORMAT(VCheqDate) + ',' +
                 'Thank you & Assuring you of Best Property Services with Building Blocks Group';
            MESSAGE('%1', CustSMSText);
            CLEAR(PostPayment);
            PostPayment.SendSMS(CustMobileNo, CustSMSText);
            //  MESSAGE('%1','SMS Sent');
        END;
    end;

    procedure AssociatePromotion()
    begin
        PPSetup.GET;
        RecVendor.GET(AssociateCode);
        AssocaiteCreationSMSData.RESET;
        AssocaiteCreationSMSData.SETRANGE("User Id", USERID);
        AssocaiteCreationSMSData.SETRANGE("Active Data", TRUE);
        AssocaiteCreationSMSData.SETRANGE("Current Associate Code", AssociateCode);
        IF AssocaiteCreationSMSData.FINDSET THEN BEGIN
            REPEAT
                SMSVendor.GET(AssocaiteCreationSMSData."Associate Code");
                IF SMSVendor."BBG Mob. No." <> '' THEN BEGIN
                    CustMobileNo := '';
                    CustSMSText := '';
                    CustMobileNo := SMSVendor."BBG Mob. No.";
                    CustSMSText :=
                    'Dear Mr/Ms:' + RecVendor.Name + ', Your associate ID is ' + FORMAT(RecVendor."No.") + '.Congrats on getting promoted as ' + VTText + ' Today' +
                    '. Assuring of our best support at all times.Good luck and God bless-Your loving BBG family ';

                    //SMS change on 230224 above new and below old.
                    //'Dear Mr/Ms:' + RecVendor.Name+ ', Your associate ID is '+ FORMAT(RecVendor."No.")+'. Congratulations you are promoted as'+VTText+' Dt:'+FORMAT(VPostDate)+
                    //'Thank and Assure you of our Best Support in Transforming Your Dreams into Reality. Good Luck and God Bless. BBGIND';
                    CLEAR(PostPayment);
                    MESSAGE('%1', CustSMSText);

                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                    SLEEP(100);
                END;
            UNTIL AssocaiteCreationSMSData.NEXT = 0;
            MESSAGE('%1', 'SMS Sent');
        END;
    end;

    procedure AssociateDemotion()
    begin
        PPSetup.GET;
        RecVendor.GET(AssociateCode);
        AssocaiteCreationSMSData.RESET;
        AssocaiteCreationSMSData.SETRANGE("User Id", USERID);
        AssocaiteCreationSMSData.SETRANGE("Active Data", TRUE);
        AssocaiteCreationSMSData.SETRANGE("Current Associate Code", AssociateCode);
        IF AssocaiteCreationSMSData.FINDSET THEN BEGIN
            REPEAT
                SMSVendor.GET(AssocaiteCreationSMSData."Associate Code");
                IF SMSVendor."BBG Mob. No." <> '' THEN BEGIN
                    CustMobileNo := '';
                    CustSMSText := '';
                    CustMobileNo := SMSVendor."BBG Mob. No.";
                    CustSMSText :=
                 'Dear Mr/Ms:' + RecVendor.Name + ', Your associate ID is ' + FORMAT(RecVendor."No.") + '.Congrats on getting demoted as' + VTText + ' Today' +
                    '. Assuring of our best support at all times.Good luck and God bless-Your loving BBG family ';

                    //Code change 230224 above new and below old.

                    //'Dear Mr/Ms:' + RecVendor.Name+ ''+'. You are demoted to '+' '+VTText+' '+'Dt: '+FORMAT(VPostDate)+
                    //' Good Luck for next time. Thank you. BBGIND.';
                    MESSAGE('%1', CustSMSText);
                    CLEAR(PostPayment);
                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                    SLEEP(100);
                END;
            UNTIL AssocaiteCreationSMSData.NEXT = 0;
            MESSAGE('%1', 'SMS Sent');
        END;
    end;

    procedure AssociateParentChange()
    begin
        PPSetup.GET;
        RecVendor.GET(AssociateCode);
        AssocaiteCreationSMSData.RESET;
        AssocaiteCreationSMSData.SETRANGE("User Id", USERID);
        AssocaiteCreationSMSData.SETRANGE("Active Data", TRUE);
        AssocaiteCreationSMSData.SETRANGE("Current Associate Code", AssociateCode);
        IF AssocaiteCreationSMSData.FINDSET THEN BEGIN
            REPEAT
                SMSVendor.GET(AssocaiteCreationSMSData."Associate Code");
                IF SMSVendor."BBG Mob. No." <> '' THEN BEGIN
                    CustMobileNo := '';
                    CustSMSText := '';
                    CustMobileNo := SMSVendor."BBG Mob. No.";
                    CustSMSText :=
                          'Dear Mr/Ms:' + RecVendor.Name + '' + '. Your Parent is changed to' + ' ' + VTText + ' ' + 'Dt: ' + FORMAT(VPostDate) + '. Assuring of our ' +
                          'best support at all times.Good Luck and God Bless-Your loving BBG family.';

                    //Added Above code 140224, 190224

                    //Comment below code 140224 , 190224
                    //'Dear Mr/Ms:' + RecVendor.Name+ ''+'. Your Parent is changed as '+' '+VTText+' '+'Dt: '+FORMAT(VPostDate)+
                    //'Thank and Assure you of our Best Support in Transforming Your Dreams into Reality. Good Luck and God Bless.BBGIND';


                    MESSAGE('%1', CustSMSText);
                    CLEAR(PostPayment);
                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                    SLEEP(100);
                END;
            UNTIL AssocaiteCreationSMSData.NEXT = 0;
            MESSAGE('%1', 'SMS Sent');
        END;
    end;

    procedure SetCustValues(AssCode: Code[20]; RegionCode1: Code[10]; AppNo: Code[20]; CustomerName: Text[50]; ProjectName: Text[50]; AppAmount: Decimal; CheqDate: Date; MbNo: Text[30])
    begin
        AssociateCode := AssCode;
        RankCode := RegionCode1;
        VAppNo := AppNo;
        VProjectName := ProjectName;
        VAppAmount := AppAmount;
        VCheqDate := CheqDate;
        VFromCustomerChequeBounce := TRUE;
        VCustomerName := CustomerName;
        VCustMbNo := MbNo;
    end;

    procedure CustomerRefund()
    begin
        NewConfirmedOrder.RESET;
        IF NewConfirmedOrder.GET(VAppNo) THEN;
        PPSetup.GET;
        RecVendor.GET(AssociateCode);
        AssocaiteCreationSMSData.RESET;
        AssocaiteCreationSMSData.SETRANGE("User Id", USERID);
        AssocaiteCreationSMSData.SETRANGE("Active Data", TRUE);
        //AssocaiteCreationSMSData.SETRANGE("Current Associate Code",AssociateCode);
        IF AssocaiteCreationSMSData.FINDSET THEN
            REPEAT
                SMSVendor.GET(AssocaiteCreationSMSData."Associate Code");
                IF SMSVendor."BBG Mob. No." <> '' THEN BEGIN
                    CustMobileNo := '';
                    CustSMSText := '';
                    CustMobileNo := SMSVendor."BBG Mob. No.";
                    CustSMSText := 'Dear Customer, Your PLOT REFUND is Completed. Name: Mr/Ms ' + VCustName + ', Appl No: ' + VAppNo +
                     ', Project: ' + VProjName + ', Amount: Rs.' + FORMAT(ABS(VRefundAmt)) +
                     ', Date: ' + FORMAT(VPostDate) + ', *Thank you & Look Forward for your Next Plot Purchase with Building Blocks Group.';
                    MESSAGE('%1', CustSMSText);

                    CLEAR(PostPayment);
                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                    //ALLEDK05122022 Start
                    CLEAR(SMSLogDetails);
                    SmsMessage := '';
                    SmsMessage1 := '';
                    SmsMessage := COPYSTR(CustSMSText, 1, 250);
                    SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', SMSVendor."No.", SMSVendor.Name, 'Refund Completed', NewConfirmedOrder."Shortcut Dimension 1 Code",
                    GetDescription.GetDimensionName(NewConfirmedOrder."Shortcut Dimension 1 Code", 1), VAppNo);
                    //ALLEDK05122022  END
                    SLEEP(100);
                    COMMIT;
                END;
            UNTIL AssocaiteCreationSMSData.NEXT = 0;

        IF VCustMbNo <> '' THEN BEGIN
            CustMobileNo := '';
            CustSMSText := '';
            CustMobileNo := VCustMbNo;
            CustSMSText := 'Dear Customer, Your PLOT REFUND is Completed. Name: Mr/Ms ' + VCustName + ', Appl No: ' + VAppNo +
                  ', Project: ' + VProjName + ', Amount: Rs.' + FORMAT(ABS(VRefundAmt)) +
                  ', Date: ' + FORMAT(VPostDate) + ', *Thank you & Look Forward for your Next Plot Purchase with Building Blocks Group.';
            MESSAGE('%1', CustSMSText);
            CLEAR(PostPayment);
            PostPayment.SendSMS(CustMobileNo, CustSMSText);
            //ALLEDK05122022 Start


            CLEAR(SMSLogDetails);
            SmsMessage := '';
            SmsMessage1 := '';
            SmsMessage := COPYSTR(CustSMSText, 1, 250);
            SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
            SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', NewConfirmedOrder."Customer No.", VCustName, 'Refund Completed', NewConfirmedOrder."Shortcut Dimension 1 Code",
            GetDescription.GetDimensionName(NewConfirmedOrder."Shortcut Dimension 1 Code", 1), VAppNo);
            //ALLEDK05122022  END
            MESSAGE('%1', 'SMS Sent');
        END;
    end;

    procedure SetCustRefund(CustMbNo: Text[30]; CustName: Text[50]; AppNo: Code[20]; ProjName: Text[50]; RefundAmt: Decimal; PostDate: Date; RegionCode1: Code[10]; AssCode: Code[20])
    begin
        VPostDate := PostDate;
        VRefundAmt := RefundAmt;
        VProjName := ProjName;
        VAppNo := AppNo;
        VCustName := CustName;
        VCustMbNo := CustMbNo;
        vCustomerRefund := TRUE;
        AssociateCode := AssCode;
        RankCode := RegionCode1;
    end;
}

