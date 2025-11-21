page 50202 "Associate Payment Form Incenti"
{
    // //BBG1.00 220815
    // // 171016 Code comment for not send SMS

    Caption = 'Associate Payment Form Incentive';
    DelayedInsert = true;
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Associate Payment Hdr";
    SourceTableView = WHERE(Post = CONST(false),
                            Type = FILTER(Incentive));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(VendNoFilter; VendNoFilter)
                {
                    Caption = 'Associate Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        EXIT(PAGELookUpDimFilter(Text));
                    end;

                    trigger OnValidate()
                    var
                        Vendor_2: Record Vendor;
                    begin
                        SetRecordFilters;
                        //CompanyWise.RESET;
                        //CompanyWise.SETRANGE(CompanyWise."MSC Company",TRUE);
                        //IF CompanyWise.FINDFIRST THEN
                        // IF CompanyWise."Company Code" <> COMPANYNAME THEN
                        //   ERROR('The process will run from MSCompany Only');

                        IF VendNoFilter <> '' THEN
                            IF Vendor_2.GET(VendNoFilter) THEN BEGIN
                                CustName := Vendor_2.Name;
                                Vendor_2.TESTFIELD("BBG Black List", FALSE);
                                ReleaseUnitApp.CheckVendStatus(VendNoFilter); //BBG 090816
                            END;
                    end;
                }
                field(CustName; CustName)
                {
                    Caption = 'Name';
                    Editable = false;
                }
                field(CutoffDate; CutoffDate)
                {
                    Caption = 'Cutoff Date';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        SetRecordFilters;
                        CutoffDateOnAfterValidate;
                    end;
                }
                field(TypeFilter; TypeFilter)
                {
                    Caption = 'Type Filter';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        SetRecordFilters;
                        TypeFilterOnAfterValidate;
                    end;
                }
            }
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                    Editable = false;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                }
                field("Bank/G L Code"; Rec."Bank/G L Code")
                {
                }
                field("Bank/G L Name"; Rec."Bank/G L Name")
                {
                }
                field("Cheque No."; Rec."Cheque No.")
                {
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                }
                field("Eligible Amount"; Rec."Eligible Amount")
                {
                }
                field("Payable Amount"; Rec."Payable Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Club 9 Amount"; Rec."Club 9 Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Advance Amount"; Rec."Advance Amount")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Net Payable (As per Actual)"; Rec."Net Payable (As per Actual)")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Amt applicable for Payment"; Rec."Amt applicable for Payment")
                {
                    Editable = false;
                }
                field("Cheque Amount"; Rec."Cheque Amount")
                {

                    trigger OnValidate()
                    begin
                        Rec."Not Refresh Amount" := TRUE;
                    end;
                }
                field("Adjust OD Amount"; Rec."Adjust OD Amount")
                {
                }
                field("Total Payable Amount"; Rec."Total Payable Amount")
                {
                }
                field("Cut-off Date"; Rec."Cut-off Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = true;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Ignore Advance Payment"; Rec."Ignore Advance Payment")
                {
                    Visible = false;
                }
                field("Rejected/Approved"; Rec."Rejected/Approved")
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
                Visible = false;
                action("Send for &A&pproval")
                {
                    Caption = 'Send for &A&pproval';

                    trigger OnAction()
                    begin
                        // BBG1.01 231012 START
                        Memberof.RESET;
                        Memberof.SETRANGE("User Name", USERID);
                        Memberof.SETRANGE("Role ID", 'A_GOLDCOINELIG.');
                        IF NOT Memberof.FINDFIRST THEN
                            ERROR('You do not have permission of role :A_GOLDCOINELIG.');
                    end;
                }
            }
            group("Calculate Eligibility1")
            {
                Caption = 'F&unction';
                Visible = true;
                action("Get Lines")
                {
                    Caption = 'Get Lines';

                    trigger OnAction()
                    var
                        BondSetup: Record "Unit Setup";
                        PostedDocNo: Code[20];
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                        VLEntry: Record "Vendor Ledger Entry";
                        VLEntry_2: Record "Vendor Ledger Entry";
                        CompanyWiseGL_1: Record "Company wise G/L Account";
                        CompanyWiseGL_2: Record "Company wise G/L Account";
                        TotalInvAmount: Decimal;
                        LineNo: Integer;
                        Vend: Record Vendor;
                        USERSETUP: Record "User Setup";
                        EntryNo: Integer;
                        AdjustOD_1: Record "Associate OD Ajustment Entry";
                        TotalInvAmount_1: Decimal;
                    begin

                        //ERROR('Work is progress');
                        //CompanyWise.RESET;
                        //CompanyWise.SETRANGE(CompanyWise."MSC Company",TRUE);
                        //IF CompanyWise.FINDFIRST THEN
                        //  IF CompanyWise."Company Code" <> COMPANYNAME THEN
                        //    ERROR('The process will run from MSCompany Only');

                        IF VendNoFilter = '' THEN
                            ERROR('Please fill the Associate filter');
                        //IF TypeFilter = TypeFilter::" " THEN
                        //  ERROR('Please fill the Type Filter');
                        //IF CutoffDate = 0D THEN
                        //  ERROR('Please fill the Cuttoff Date');

                        CheckPmtReversal.RESET;
                        CheckPmtReversal.SETFILTER("Associate Code", VendNoFilter);
                        CheckPmtReversal.SETRANGE("Payment Reversed", TRUE);
                        CheckPmtReversal.SETRANGE("Reversal done in LLP Companies", FALSE);
                        CheckPmtReversal.SETFILTER("Amt applicable for Payment", '>%1', 1);
                        CheckPmtReversal.SETRANGE("Company Name", COMPANYNAME);
                        IF CheckPmtReversal.FINDFIRST THEN
                            ERROR('Please make reversal in ' + CheckPmtReversal."Company Name" + ' ' + 'for Associate Code' + ' '
                                                       + CheckPmtReversal."Associate Code" + 'with Document No.' + CheckPmtReversal."Document No.");

                        CheckPmtReversal.RESET;
                        CheckPmtReversal.SETFILTER("Associate Code", VendNoFilter);
                        CheckPmtReversal.SETRANGE(Post, FALSE);
                        CheckPmtReversal.SETRANGE(Type, CheckPmtReversal.Type::Incentive);
                        CheckPmtReversal.SETRANGE("Company Name", COMPANYNAME);
                        IF CheckPmtReversal.FINDFIRST THEN BEGIN
                            ERROR('Associate No.-' + ' ' + CheckPmtReversal."Associate Code" + ' ' + 'already used for Payment with Document No. -' +
                                 CheckPmtReversal."Document No." + ' ' + 'Please make payment first or Delete the entries');
                        END;

                        //AdjustOD_1.RESET;
                        //AdjustOD_1.SETFILTER("Associate Code",VendNoFilter);
                        //IF AdjustOD_1.FINDFIRST THEN BEGIN
                        //  IF (NOT AdjustOD_1."Posted in From Company Name") OR (NOT AdjustOD_1."Posted in To Company Name") THEN
                        //    ERROR('Associate No.-'+ ' '+AdjustOD_1."Associate Code"+' '+'Please run the OD Ajust batch in company'+
                        //        AdjustOD_1."From Company Name" +'OR'+AdjustOD_1."To Company Name");
                        //END;


                        //BBG1.00 220815
                        PostedDocNo := '';
                        USERSETUP.GET(USERID);
                        BondSetup.GET;
                        BondSetup.TESTFIELD("Voucher No. Series");
                        PostedDocNo := NoSeriesMgt.GetNextNo(BondSetup."Voucher No. Series", WORKDATE, TRUE);

                        TotalInvAmount_1 := 0;
                        CompanyWiseGL_2.RESET;
                        CompanyWiseGL_2.SETRANGE("Company Code", COMPANYNAME);
                        IF CompanyWiseGL_2.FINDSET THEN
                            REPEAT
                                VLEntry_2.RESET;
                                VLEntry_2.CHANGECOMPANY(CompanyWiseGL_2."Company Code");
                                VLEntry_2.SETCURRENTKEY("Vendor No.", "Posting Date");
                                VLEntry_2.SETFILTER("Vendor No.", VendNoFilter);
                                VLEntry_2.SETRANGE("Posting Date", DMY2DATE(28, 2, 2013), DMY2DATE(28, 2, 2013));
                                VLEntry_2.SETFILTER("Posting Type", '%1', VLEntry_2."Posting Type"::Incentive);
                                IF VLEntry_2.FINDSET THEN BEGIN
                                    REPEAT
                                        VLEntry_2.CALCFIELDS(VLEntry_2.Amount);
                                        TotalInvAmount_1 := TotalInvAmount_1 + VLEntry_2.Amount;
                                    UNTIL VLEntry_2.NEXT = 0;
                                    IF TotalInvAmount_1 > 0 THEN BEGIN
                                        TotalInvAmount_1 := TotalInvAmount_1 * 89 / 100;
                                    END;
                                END;

                                VLEntry_2.RESET;
                                VLEntry_2.CHANGECOMPANY(CompanyWiseGL_2."Company Code");
                                VLEntry_2.SETCURRENTKEY("Vendor No.", "Posting Date");
                                VLEntry_2.SETFILTER("Vendor No.", VendNoFilter);
                                VLEntry_2.SETRANGE("Posting Date", DMY2DATE(1, 3, 2013), TODAY);
                                VLEntry_2.SETFILTER("Posting Type", '%1', VLEntry_2."Posting Type"::Incentive);
                                IF VLEntry_2.FINDSET THEN
                                    REPEAT
                                        VLEntry_2.CALCFIELDS(VLEntry_2.Amount);
                                        TotalInvAmount_1 := TotalInvAmount_1 + VLEntry_2.Amount;
                                    UNTIL VLEntry_2.NEXT = 0;
                            UNTIL CompanyWiseGL_2.NEXT = 0;

                        IF TotalInvAmount_1 < 0 THEN BEGIN
                            CompanyWiseGL_1.RESET;
                            CompanyWiseGL_1.SETRANGE("Company Code", COMPANYNAME);
                            IF CompanyWiseGL_1.FINDSET THEN
                                REPEAT
                                    TotalInvAmount := 0;

                                    VLEntry_2.RESET;
                                    VLEntry_2.CHANGECOMPANY(CompanyWiseGL_1."Company Code");
                                    VLEntry_2.SETCURRENTKEY("Vendor No.", "Posting Date");
                                    VLEntry_2.SETFILTER("Vendor No.", VendNoFilter);
                                    VLEntry_2.SETRANGE("Posting Date", DMY2DATE(28, 2, 2013), DMY2DATE(28, 2, 2013));
                                    VLEntry_2.SETFILTER("Posting Type", '%1', VLEntry_2."Posting Type"::Incentive);
                                    IF VLEntry_2.FINDSET THEN BEGIN
                                        REPEAT
                                            VLEntry_2.CALCFIELDS(VLEntry_2.Amount);
                                            TotalInvAmount := TotalInvAmount + VLEntry_2.Amount;
                                        UNTIL VLEntry_2.NEXT = 0;
                                        IF TotalInvAmount > 0 THEN BEGIN
                                            TotalInvAmount := TotalInvAmount * 89 / 100;
                                        END;
                                    END;

                                    VLEntry_2.RESET;
                                    VLEntry_2.CHANGECOMPANY(CompanyWiseGL_1."Company Code");
                                    VLEntry_2.SETCURRENTKEY("Vendor No.", "Posting Date");
                                    VLEntry_2.SETFILTER("Vendor No.", VendNoFilter);
                                    VLEntry_2.SETRANGE("Posting Date", DMY2DATE(1, 3, 2013), TODAY);
                                    VLEntry_2.SETFILTER("Posting Type", '%1', VLEntry_2."Posting Type"::Incentive);
                                    IF VLEntry_2.FINDSET THEN
                                        REPEAT
                                            VLEntry_2.CALCFIELDS(VLEntry_2.Amount);
                                            TotalInvAmount := TotalInvAmount + VLEntry_2.Amount;
                                        UNTIL VLEntry_2.NEXT = 0;


                                    IF TotalInvAmount < 0 THEN BEGIN
                                        AssociatePaymentHdr.INIT;
                                        AssociatePaymentHdr."Document No." := PostedDocNo;
                                        AssociatePaymentHdr."Line No." := LineNo + 10000;
                                        AssociatePaymentHdr."Associate Code" := VendNoFilter;
                                        IF Vend.GET(VendNoFilter) THEN;
                                        AssociatePaymentHdr."Associate Name" := Vend.Name;
                                        AssociatePaymentHdr."Company Name" := COMPANYNAME;
                                        AssociatePaymentHdr.Type := AssociatePaymentHdr.Type::Incentive;
                                        AssociatePaymentHdr."Posting Type" := AssociatePaymentHdr."Posting Type"::Incentive;
                                        AssociatePaymentHdr."User ID" := USERID;
                                        AssociatePaymentHdr."User Branch Code" := USERSETUP."User Branch";
                                        AssociatePaymentHdr."Posting Date" := WORKDATE;
                                        AssociatePaymentHdr."Document Date" := WORKDATE;
                                        AssPmtHeader."Line Type" := AssPmtHeader."Line Type"::Header;
                                        AssociatePaymentHdr."Cut-off Date" := WORKDATE;
                                        AssociatePaymentHdr."Eligible Amount" := -1 * TotalInvAmount;
                                        AssociatePaymentHdr."Posted on LLP Company" := TRUE;
                                        AssociatePaymentHdr."Payable Amount" := -1 * TotalInvAmount;
                                        AssociatePaymentHdr."Net Payable (As per Actual)" := -1 * TotalInvAmount;
                                        AssociatePaymentHdr."Company Name" := CompanyWiseGL_1."Company Code";
                                        AssociatePaymentHdr."Sub Type" := AssociatePaymentHdr."Sub Type"::Regular;
                                        AssociatePaymentHdr."Line Type" := AssociatePaymentHdr."Line Type"::Header;
                                        AssociatePaymentHdr."From MS Company" := TRUE;
                                        IF TotalInvAmount < 0 THEN
                                            AssociatePaymentHdr."Amt applicable for Payment" := -1 * TotalInvAmount
                                        ELSE
                                            AssociatePaymentHdr."Amt applicable for Payment" := 0;
                                        AssociatePaymentHdr.INSERT;
                                        LineNo := AssociatePaymentHdr."Line No.";
                                    END;
                                UNTIL CompanyWiseGL_1.NEXT = 0;

                        END;


                        MESSAGE('Batch Run Successfully');
                    end;
                }
                action("Upload Vendor Payment")
                {
                    Caption = 'Upload Vendor Payment';
                    RunObject = XMLport "Vendor Payment Upload";
                }
                action("Post Payment")
                {
                    Caption = 'Post Payment';
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    var
                        PayAmt_1: Decimal;
                        InvAmt_1: Decimal;
                    begin
                        Rec.TESTFIELD("Rejected/Approved", Rec."Rejected/Approved"::Approved);
                        AssociatePaymentHdr1.RESET;
                        AssociatePaymentHdr1.SETCURRENTKEY("User ID", "Rejected/Approved", Post);
                        AssociatePaymentHdr1.SETRANGE("User ID", USERID);
                        AssociatePaymentHdr1.SETRANGE("Rejected/Approved", AssociatePaymentHdr."Rejected/Approved"::Approved);
                        AssociatePaymentHdr1.SETRANGE(Post, FALSE);
                        AssociatePaymentHdr1.SETRANGE("Not Refresh Amount", TRUE);
                        IF AssociatePaymentHdr1.FINDFIRST THEN
                            ERROR('Please Refresh the amount');

                        PayAmt_1 := 0;
                        InvAmt_1 := 0;
                        AssociatePaymentHdr1.RESET;
                        AssociatePaymentHdr1.SETCURRENTKEY("User ID", "Rejected/Approved", Post);
                        AssociatePaymentHdr1.SETRANGE("User ID", USERID);
                        AssociatePaymentHdr1.SETRANGE("Rejected/Approved", AssociatePaymentHdr."Rejected/Approved"::Approved);
                        AssociatePaymentHdr1.SETRANGE(Post, FALSE);
                        IF AssociatePaymentHdr1.FINDSET THEN
                            REPEAT
                                PayAmt_1 := PayAmt_1 + AssociatePaymentHdr1."Cheque Amount";
                                InvAmt_1 := InvAmt_1 + AssociatePaymentHdr1."Eligible Amount";
                            UNTIL AssociatePaymentHdr1.NEXT = 0;

                        IF PayAmt_1 > InvAmt_1 THEN
                            ERROR('Cheque amount can not be greater than Eligible Amount');


                        IF CONFIRM('Do you want to post the Entries?') THEN BEGIN
                            AssociateCode := '';
                            AssociatePaymentHdr.RESET;
                            AssociatePaymentHdr.SETCURRENTKEY("Associate Code", Post);
                            AssociatePaymentHdr.SETRANGE("User ID", USERID);
                            AssociatePaymentHdr.SETRANGE("Rejected/Approved", AssociatePaymentHdr."Rejected/Approved"::Approved);
                            AssociatePaymentHdr.SETRANGE(Post, FALSE);
                            IF AssociatePaymentHdr.FINDSET THEN BEGIN
                                REPEAT
                                    IF AssociateCode <> AssociatePaymentHdr."Associate Code" THEN BEGIN
                                        AssociateCode := AssociatePaymentHdr."Associate Code";
                                        Postpayment.PostAssociatePayment(AssociatePaymentHdr);
                                        //    AssociateSMS.SmsonCommissionRelease("Posted Document No.");
                                    END;
                                UNTIL AssociatePaymentHdr.NEXT = 0;
                            END;

                            MESSAGE('%1', 'Entries post successfully');
                            CLEAR(VendNoFilter);
                        END ELSE
                            MESSAGE('%1', 'Nothing to Post');

                        /* // 171016 Code comment
                          DocNo := '';
                          MailAssoPmt.RESET;
                          MailAssoPmt.SETRANGE("Sms Sent",FALSE);
                          MailAssoPmt.SETRANGE(Post,TRUE);
                          MailAssoPmt.SETRANGE("User ID",USERID);
                          IF MailAssoPmt.FINDSET THEN
                            REPEAT
                              IF DocNo <> MailAssoPmt."Document No." THEN BEGIN
                                DocNo := MailAssoPmt."Document No.";
                                AssociateSMS.SmsonCommissionReleaseMSC(MailAssoPmt."Document No.");
                              END;
                                MailAssoPmt."Sms Sent" := TRUE;
                                MailAssoPmt.MODIFY;
                            UNTIL MailAssoPmt.NEXT =0;
                        */ // 171016 Code comment

                    end;
                }
                action("Update Amount")
                {
                    Caption = 'Update Amount';
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    var
                        ChequeAmount: Decimal;
                        AssPmtHeader_1: Record "Associate Payment Hdr";
                        UpdateAssPmtHeader_1: Record "Associate Payment Hdr";
                        AdjAmt: Decimal;
                    begin

                        IF CONFIRM('Do you want to Refresh Amount?') THEN BEGIN
                            ChequeAmount := 0;
                            AssPmtHeader.RESET;
                            AssPmtHeader.SETRANGE("User ID", USERID);
                            AssPmtHeader.SETRANGE(Post, FALSE);
                            AssPmtHeader.SETFILTER("Cheque Amount", '<>%1', 0);
                            IF AssPmtHeader.FINDSET THEN
                                REPEAT
                                    ChequeAmount := AssPmtHeader."Cheque Amount";
                                    UpdateAssPmtHeader.RESET;
                                    UpdateAssPmtHeader.SETRANGE("Associate Code", AssPmtHeader."Associate Code");
                                    UpdateAssPmtHeader.SETRANGE("User ID", USERID);
                                    UpdateAssPmtHeader.SETRANGE(Post, FALSE);
                                    UpdateAssPmtHeader.SETFILTER("Eligible Amount", '>%1', 0);
                                    IF UpdateAssPmtHeader.FINDSET THEN BEGIN
                                        REPEAT
                                            IF ChequeAmount >= UpdateAssPmtHeader."Eligible Amount" THEN BEGIN
                                                UpdateAssPmtHeader."Amt applicable for Payment" := UpdateAssPmtHeader."Eligible Amount";
                                                ChequeAmount := ChequeAmount - UpdateAssPmtHeader."Eligible Amount";
                                            END ELSE BEGIN
                                                UpdateAssPmtHeader."Amt applicable for Payment" := ChequeAmount;
                                                ChequeAmount := 0;
                                            END;
                                            UpdateAssPmtHeader.MODIFY;
                                        UNTIL UpdateAssPmtHeader.NEXT = 0;
                                    END;

                                    AdjAmt := 0;
                                    AssPmtHeader_1.RESET;
                                    AssPmtHeader_1.SETRANGE("User ID", USERID);
                                    AssPmtHeader_1.SETRANGE(Post, FALSE);
                                    AssPmtHeader_1.SETFILTER("Eligible Amount", '<%1', 0);
                                    IF AssPmtHeader_1.FINDSET THEN
                                        REPEAT
                                            AdjAmt := AdjAmt + AssPmtHeader_1."Eligible Amount";
                                        UNTIL AssPmtHeader_1.NEXT = 0;

                                    AdjAmt := ABS(AdjAmt);

                                    UpdateAssPmtHeader_1.RESET;
                                    UpdateAssPmtHeader_1.SETRANGE("Associate Code", AssPmtHeader_1."Associate Code");
                                    UpdateAssPmtHeader_1.SETRANGE("User ID", USERID);
                                    UpdateAssPmtHeader_1.SETRANGE(Post, FALSE);
                                    UpdateAssPmtHeader_1.SETFILTER("Eligible Amount", '>%1', 0);
                                    IF UpdateAssPmtHeader_1.FINDSET THEN
                                        REPEAT
                                            IF UpdateAssPmtHeader_1."Eligible Amount" - UpdateAssPmtHeader_1."Amt applicable for Payment" > 0 THEN BEGIN
                                                IF AdjAmt >= (UpdateAssPmtHeader_1."Eligible Amount" - UpdateAssPmtHeader_1."Amt applicable for Payment") THEN BEGIN
                                                    UpdateAssPmtHeader_1."Adjust OD Amount" :=
                                                         (UpdateAssPmtHeader_1."Eligible Amount" - UpdateAssPmtHeader_1."Amt applicable for Payment");
                                                    AdjAmt := AdjAmt - (UpdateAssPmtHeader_1."Eligible Amount" - UpdateAssPmtHeader_1."Amt applicable for Payment");
                                                END ELSE BEGIN
                                                    UpdateAssPmtHeader_1."Adjust OD Amount" := AdjAmt;
                                                    AdjAmt := 0;
                                                END;
                                            END;
                                            UpdateAssPmtHeader_1.MODIFY;
                                        UNTIL UpdateAssPmtHeader_1.NEXT = 0;

                                    AssPmtHdr.RESET;
                                    AssPmtHdr.SETRANGE("Document No.", AssPmtHeader."Document No.");
                                    AssPmtHdr.SETRANGE("Line No.", AssPmtHeader."Line No.");
                                    IF AssPmtHdr.FINDFIRST THEN BEGIN
                                        AssPmtHdr."Not Refresh Amount" := FALSE;
                                        AssPmtHdr.MODIFY;
                                    END;
                                UNTIL AssPmtHeader.NEXT = 0;
                        END;
                    end;
                }
                action("Select All")
                {
                    Caption = 'Select All';

                    trigger OnAction()
                    var
                        UserSetup: Record "User Setup";
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Associate Payment Approval", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');



                        SelectAssHyd.RESET;
                        SelectAssHyd.SETRANGE(Post, FALSE);
                        //SelectAssHyd.SETRANGE("User ID",USERID);
                        IF SelectAssHyd.FINDSET THEN
                            REPEAT
                                SelectAssHyd."Rejected/Approved" := SelectAssHyd."Rejected/Approved"::Approved;
                                SelectAssHyd.MODIFY;
                            UNTIL SelectAssHyd.NEXT = 0;
                    end;
                }
                action("Un-Select All")
                {
                    Caption = 'Un-Select All';

                    trigger OnAction()
                    var
                        UserSetup: Record "User Setup";
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Associate Payment Approval", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');


                        SelectAssHyd.RESET;
                        SelectAssHyd.SETRANGE(Post, FALSE);
                        //SelectAssHyd.SETRANGE("User ID",USERID);
                        IF SelectAssHyd.FINDSET THEN
                            REPEAT
                                SelectAssHyd."Rejected/Approved" := SelectAssHyd."Rejected/Approved"::" ";
                                SelectAssHyd.MODIFY;
                            UNTIL SelectAssHyd.NEXT = 0;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETRANGE("User ID", USERID);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF (Rec."Document No." = '') AND (VendNoFilter <> '') THEN
            ERROR('Please get Lines');
    end;

    var
        Text001: Label 'Do you want to Insert the Lines?';
        VendNoFilter: Text[30];
        Stdate: Date;
        CompanyFilter: Code[30];
        Vend: Record Vendor;
        CustName: Text[60];
        CutoffDate: Date;
        Memberof: Record "Access Control";
        TypeFilter: Option " ",Incentive,Commission,TA,ComAndTA;
        TeamType: Option " ",WithTeam,WithoutTeam;
        //GenerateCommElg: Report 50099;
        Postpayment: Codeunit PostPayment;
        AssociatePaymentHdr: Record "Associate Payment Hdr";
        AssociateCode: Code[20];
        Amt: Decimal;
        UpdateAssPmtHeader: Record "Associate Payment Hdr";
        UnitSetup: Record "Unit Setup";
        "TDS%": Decimal;
        GrossAmt: Decimal;
        AssociateSMS: Codeunit "SMS Features";
        CommissionEntry: Record "Commission Entry";
        TravelPmtEntry: Record "Travel Payment Entry";
        AssPaymentHdr: Record "Associate Payment Hdr";
        RemAmount: Decimal;
        AssPmtHeader: Record "Associate Payment Hdr";
        CompanyWise: Record "Company wise G/L Account";
        DeleteEligiblePmtLine: Record "Associate Payment Hdr";
        OldTravelPmtEntry: Record "Travel Payment Entry";
        OldCommissionEntry: Record "Commission Entry";
        CheckPmtReversal: Record "Associate Payment Hdr";
        SelectAssHyd: Record "Associate Payment Hdr";
        TravelPaymentEntry: Record "Travel Payment Entry";
        IncentiveSummary: Record "Incentive Summary";
        CommissionEntry1: Record "Commission Entry";
        DocNo: Code[20];
        MailAssoPmt: Record "Associate Payment Hdr";
        AssPmtHdr: Record "Associate Payment Hdr";
        CKDelAssociatePaymentHdr: Record "Associate Payment Hdr";
        CKTravelPaymentEntry: Record "Travel Payment Entry";
        CKIncentiveSummary: Record "Incentive Summary";
        CKCommissionEntry: Record "Commission Entry";
        AssociatePaymentHdr1: Record "Associate Payment Hdr";
        CompwiseGLAccount: Record "Company wise G/L Account";
        TPEntry: Record "Travel Payment Entry";
        IncSummary: Record "Incentive Summary";
        CommEntry: Record "Commission Entry";
        CKAssPMTHdr: Record "Associate Payment Hdr";
        CKAssPMTHdr1: Record "Associate Payment Hdr";
        TotalPmt: Decimal;
        CompName: Text[30];
        CkVend: Record Vendor;
        LLPVend: Record Vendor;
        ReleaseUnitApp: Codeunit "Release Unit Application";


    procedure SetRecordFilters()
    begin
        IF VendNoFilter <> '' THEN
            Rec.SETFILTER("Associate Code", VendNoFilter)
        ELSE
            Rec.SETRANGE("Team Head");

        IF CompanyFilter <> '' THEN
            Rec.SETFILTER("Company Name", CompanyFilter)
        ELSE
            Rec.SETRANGE("Company Name");

        IF (CutoffDate <> 0D) THEN
            Rec.SETRANGE("Cut-off Date", CutoffDate)
        ELSE
            Rec.SETRANGE("Cut-off Date");

        IF (TypeFilter = TypeFilter::Commission) OR (TypeFilter = TypeFilter::TA) THEN
            Rec.SETRANGE(Type, TypeFilter)
        ELSE
            Rec.SETRANGE(Type);
    end;


    procedure PAGELookUpDimFilter(var Text: Text[1024]): Boolean
    var
        RecVendor: Record Vendor;
        DimValList: Page "Vendor List";
    begin
        DimValList.LOOKUPMODE(TRUE);
        RecVendor.RESET;
        RecVendor.SETRANGE(RecVendor."BBG Vendor Category", RecVendor."BBG Vendor Category"::"IBA(Associates)");
        RecVendor.SETRANGE(Blocked, RecVendor.Blocked::" ");
        DimValList.SETTABLEVIEW(RecVendor);
        IF DimValList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            DimValList.GETRECORD(RecVendor);
            Text := DimValList.GetSelectionFilter;
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE)
    end;

    local procedure CutoffDateOnAfterValidate()
    begin
        CurrPage.UPDATE(FALSE);
    end;

    local procedure TypeFilterOnAfterValidate()
    begin
        CurrPage.UPDATE(FALSE);
    end;
}

