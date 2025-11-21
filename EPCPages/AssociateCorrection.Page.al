page 97981 "Associate Correction"

{
    // Nature: This Form must be run prior Commission Generation. I.e. Associate Correction must be happen before generating commission.
    //         To be ran for a confirmed order.
    // //Added Role for Associate Correction
    // ALLECK 160313: Added role for Associate Correction

    PageType = List;
    Permissions = TableData "G/L Entry" = rimd,
                  TableData "Vendor Ledger Entry" = rimd,
                  TableData "Detailed Vendor Ledg. Entry" = rimd;
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Confirmed Order No."; BondNo)
                {
                    Caption = 'Confirmed Order No.';
                    TableRelation = "Confirmed Order";

                    trigger OnValidate()
                    begin
                        IF BondNo <> '' THEN BEGIN
                            ConfOrder.SETRANGE("No.", BondNo);
                            IF ConfOrder.FINDFIRST THEN BEGIN
                                IF Vend.GET(ConfOrder."Introducer Code") THEN;
                                IF ConfOrder.Status = ConfOrder.Status::Cancelled THEN
                                    ERROR('Status must not be Cancelled');
                            END;
                        END;
                        IF NOT ConfOrder.FINDSET THEN BEGIN
                            CLEAR(ConfOrder);
                            ERROR('Not found');
                        END;
                    end;
                }
                field("Existing Associate No."; ConfOrder."Introducer Code")
                {
                    Caption = 'Existing Associate No.';
                    Editable = false;
                }
                field("Existing Associate Name"; Vend.Name)
                {
                    Caption = 'Existing Associate Name';
                    Editable = false;
                }
                field("Associate Correction"; AssociateNoCorrection)
                {
                    Caption = 'Associate Correction';

                    trigger OnValidate()
                    begin
                        AssociateNoCorrectionOnPush;
                    end;
                }
                field("New Associate No."; CorrectAssociateNo)
                {
                    Caption = 'New Associate No.';
                    Enabled = CorrectChequeNoEnable;
                    TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)" | "CP(Channel Partner)"));

                    trigger OnValidate()
                    begin
                        CLEAR(ConfOrder1);
                        IF BondNo <> '' THEN
                            IF ConfOrder1.GET(BondNo) THEN;
                        VendName := '';
                        IF CorrectAssociateNo <> '' THEN
                            IF RecVend.GET(CorrectAssociateNo) THEN BEGIN
                                RecVend.TESTFIELD("BBG Black List", FALSE);
                                IF RecVend."BBG Date of Joining" > ConfOrder1."Posting Date" THEN
                                    ERROR('Application DOJ grater than Associate DOJ');
                                VendName := RecVend.Name
                            END ELSE
                                VendName := '';
                    end;
                }
                field("New Associate Name"; VendName)
                {
                    Caption = 'New Associate Name';
                    Editable = false;
                    Enabled = VendNameEnable;
                }
                field("Region Code"; NewRegionCode)
                {
                    Caption = 'Region Code';
                    TableRelation = "Rank Code Master";
                }
                field(Comment; CorrectionComment)
                {
                    Caption = 'Comment';
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
                action("Commission Generate for Opening")
                {
                    Caption = 'Commission Generate for Opening';

                    trigger OnAction()
                    begin
                        RecConfirmedORder.RESET;
                        RecConfirmedORder.SETRANGE("No.", BondNo);
                        RecConfirmedORder.SETRANGE("User Id", '1003');
                        IF RecConfirmedORder.FINDFIRST THEN
                            REPORT.RUNMODAL(50029, TRUE, FALSE, RecConfirmedORder);
                    end;
                }
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
                        CommisionGen: Codeunit "Unit and Comm. Creation Job";
                        FirstLineNo: Integer;
                        LastLineNo: Integer;
                        DataExit: Boolean;
                        Vendor: Record Vendor;
                        RankCode: Code[10];
                        APE: Record 97812;
                        RecAPE_1: Record 97812;
                        AppliPaymentAmount: Decimal;
                        TotalBondAmount: Decimal;
                        LineNo: integer;
                        BPayEntry: Record "Unit payment Entry";
                        TotalAmt: Decimal;

                        DifferenceAmount: Decimal;
                        PaymentTermLines: Record 97778;

                        LoopingDifferAmount: Decimal;
                        BondPayLineAmt: decimal;
                        Project_RankWisesetup: record "Project wise Appl. Setup";
                        ProjectwiseCommSetup: Record "Commission Structr Amount Base";
                        Projecttype: Code[20];
                        TAApplicable: Boolean;
                        RegBonusBSP2: boolean;
                        RankCodeMaster: Record "Rank Code Master";
                        CommStrAmtBase: Record "Commission Structr Amount Base";
                        UnitPostCu: Codeunit "Unit Post";   //Code added 06102025 
                        AssociateHierarcywithApp: Record "Associate Hierarcy with App.";  //Code added 06102025
                        UnitSetup: Record "unit setup";  //Code added 06102025

                    begin
                        IF NewRegionCode = '' then
                            Error('Please define the Region Code');


                        //ERROR('hi');
                        TotAppAmt := 0;
                        IF CorrectionComment = '' THEN
                            ERROR('You must enter Comment for Associate Change');
                        //------- check necessary values Start ------------------

                        RecConforder.RESET;
                        RecConforder.SETRANGE("No.", BondNo);
                        IF RecConforder.FINDFIRST THEN BEGIN

                            RankCodeMaster.RESET;
                            IF RankCodeMaster.GET(NewRegionCode) then begin
                                IF RankCodeMaster."Applicable New commission Str." then begin
                                    CommStrAmtBase.Reset;
                                    CommStrAmtBase.SetRange("Project Code", RecConforder."Shortcut Dimension 1 Code");
                                    CommStrAmtBase.SetFilter("Start Date", '<=%1', RecConforder."Posting Date");
                                    CommStrAmtBase.SetFilter("End Date", '>=%1', RecConforder."Posting Date");
                                    CommStrAmtBase.SetRange("Rank Code", NewRegionCode);
                                    IF NOT CommStrAmtBase.FindFirst() then
                                        Error('New Commission structure Amount Base not define');
                                end;
                            end;

                            //Code added start 01072025 
                            Projecttype := RecConforder."Project Type";
                            TAApplicable := RecConforder."Travel applicable";
                            RegBonusBSP2 := RecConforder."Registration Bouns (BSP2)";
                            Project_RankWisesetup.RESET;
                            Project_RankWisesetup.SetRange("Project Code", RecConforder."Shortcut Dimension 1 Code");
                            Project_RankWisesetup.SetFilter("Effective From Date", '<=%1', RecConforder."Posting Date");
                            Project_RankWisesetup.SetFilter("Effective To Date", '>=%1', RecConforder."Posting Date");
                            Project_RankWisesetup.SetRange("Project Rank Code", NewRegionCode);
                            //Project_RankWisesetup.SetFilter("Commission Structure Code", '<>%1', '');
                            IF Project_RankWisesetup.FindFirst() then begin

                                Projecttype := Project_RankWisesetup."Commission Structure Code";
                                TAApplicable := Project_RankWisesetup."Travel Applicable";
                                RegBonusBSP2 := Project_RankWisesetup."Registration Bonus (BSP2)";

                                ProjectwiseCommSetup.RESET;
                                ProjectwiseCommSetup.SetRange("Project Code", RecConforder."Shortcut Dimension 1 Code");
                                ProjectwiseCommSetup.SetFilter("Start Date", '<=%1', RecConforder."Posting Date");
                                ProjectwiseCommSetup.SetFilter("End Date", '>=%1', RecConforder."Posting Date");
                                ProjectwiseCommSetup.SetRange("Payment Plan Code", RecConforder."Unit Payment Plan");
                                ProjectwiseCommSetup.SetFilter("% Per Square", '<>%1', 0);
                                ProjectwiseCommSetup.SetRange("Rank Code", NewRegionCode);   //Code added 01072025
                                IF Not ProjectwiseCommSetup.FindFirst() then
                                    Error('Project wise commission structure not define.');
                            END;

                            //Code Added End 01072025
                            RecConforder.TESTFIELD("Application Closed", FALSE);
                            RecConforder.TESTFIELD("Registration Status", RecConforder."Registration Status"::" "); //090921
                            Job.RESET;
                            Job.SETRANGE("No.", RecConforder."Shortcut Dimension 1 Code");
                            IF Job.FINDFIRST THEN BEGIN
                                Job.TESTFIELD("Default Project Type");
                                Job.TESTFIELD("Region Code for Rank Hierarcy");
                                RankCode := '';
                                RankCode := Job."Region Code for Rank Hierarcy";
                                Vendor.RESET;
                                IF Vendor.GET(CorrectAssociateNo) THEN
                                    IF Vendor."BBG Vendor Category" = Vendor."BBG Vendor Category"::"CP(Channel Partner)" THEN
                                        RankCode := Vendor."Sub Vendor Category";

                                //RankCode := RecConforder."Region Code";  //Code Added 01072025  //11072025 code comment
                                RankCode := NewRegionCode;

                                // RankCode := 'R0003';  //02062025 Code commented

                                RegionwiseVendor.RESET;
                                RegionwiseVendor.SETRANGE("No.", CorrectAssociateNo);
                                RegionwiseVendor.SETRANGE("Region Code", NewRegionCode);
                                IF NOT RegionwiseVendor.FINDFIRST THEN
                                    ERROR('Please define the Rank Relation')
                                ELSE BEGIN
                                    RegionwiseVendor.TESTFIELD(RegionwiseVendor."Rank Code");

                                    //IF CorrectAssociateNo <> 'IBA9999999' THEN  //Code commented 01072025
                                    If RegionwiseVendor."Rank Code" < 13.00 then  //Code Added 01072025
                                        RegionwiseVendor.TESTFIELD(RegionwiseVendor."Parent Rank");
                                END;
                            END;

                            VendBuspost.RESET;
                            VendBuspost.SETRANGE("No.", CorrectAssociateNo);
                            IF VendBuspost.FINDFIRST THEN
                                VendBuspost.TESTFIELD("Gen. Bus. Posting Group");
                            IF CorrectAssociateNo <> 'IBA9999999' THEN BEGIN
                                /*
                                NODLine.RESET;
                                NODLine.SETRANGE(NODLine.Type, NODLine.Type::Vendor);
                                NODLine.SETRANGE("No.", CorrectAssociateNo);
                                IF NOT NODLine.FINDFIRST THEN
                                    ERROR('Create NOD/NOC lines with Associate Code ' + CorrectAssociateNo);
                                *///Need to check the code in UAT
                                AllowedSection.Reset();
                                AllowedSection.SetRange("Vendor No", CorrectAssociateNo);
                                IF not AllowedSection.FindFirst() then
                                    ERROR('Create Allowed Sections with Associate Code ' + CorrectAssociateNo);


                            END;
                        END;
                        //------- check necessary values End ------------------




                        ArchiveConfirmedOrder.RESET;
                        ArchiveConfirmedOrder.SETRANGE(ArchiveConfirmedOrder."No.", BondNo);
                        IF ArchiveConfirmedOrder.FINDLAST THEN
                            LastVersion := ArchiveConfirmedOrder."Version No."
                        ELSE
                            LastVersion := 0;

                        ConfOrder.CALCFIELDS("Amount Received");
                        ConfOrder.CALCFIELDS("Total Received Amount");
                        ConfOrder.CALCFIELDS("Amount Refunded");


                        ArchiveConfirmedOrder.INIT;
                        ArchiveConfirmedOrder.TRANSFERFIELDS(ConfOrder);
                        ArchiveConfirmedOrder."Version No." := LastVersion + 1;
                        ArchiveConfirmedOrder."Amount Received" := ConfOrder."Amount Received";
                        ArchiveConfirmedOrder."Archive Date" := TODAY;
                        ArchiveConfirmedOrder."Archive Time" := TIME;
                        ArchiveConfirmedOrder.INSERT;


                        RecConfirmedORder1.RESET;
                        RecConfirmedORder1.SETRANGE("No.", BondNo);
                        RecConfirmedORder1.SETRANGE("User Id", '1003');
                        IF RecConfirmedORder1.FINDFIRST THEN BEGIN
                            AppPaymentEntry.RESET;
                            AppPaymentEntry.SETRANGE("Document No.", BondNo);
                            AppPaymentEntry.SETRANGE("User ID", '1003');
                            IF AppPaymentEntry.FINDSET THEN
                                REPEAT
                                    TotAppAmt += AppPaymentEntry.Amount;
                                UNTIL AppPaymentEntry.NEXT = 0;
                            //IF TotAppAmt >= RecConfirmedORder1."Min. Allotment Amount" THEN BEGIN
                            IF TotAppAmt >= CommGen.CheckMinAmountOpng(RecConfirmedORder1) THEN BEGIN

                                RecConfirmedORder.RESET;
                                RecConfirmedORder.SETRANGE("No.", BondNo);
                                RecConfirmedORder.SETRANGE("User Id", '1003');
                                RecConfirmedORder.SETFILTER("Introducer Code", '<>%1', 'IBA9999999');
                                IF RecConfirmedORder.FINDFIRST THEN BEGIN
                                    CommissionEntry.RESET;
                                    CommissionEntry.SETRANGE("Application No.", RecConfirmedORder."No.");
                                    CommissionEntry.SETRANGE("Opening Entries", TRUE);
                                    CommissionEntry.SETFILTER("Commission Amount", '<>%1', 0);
                                    IF NOT CommissionEntry.FINDFIRST THEN
                                        ERROR('Please create Commission for opening Application');
                                END;
                            END;
                        END;
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        MemberOf.SETRANGE(MemberOf."User ID",USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID",'A_ASSCORRECTION');
                        IF NOT MemberOf.FINDFIRST THEN
                          ERROR('You do not have permission of role  :A_ASSCORRECTION');
                        //ALLECK 160313 End
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        IF CorrectAssociateNo <> '' THEN
                            Vend.GET(CorrectAssociateNo)
                        ELSE
                            ERROR('Please define the New Associate No.');


                        IF CONFIRM('Do you want to chang Associate Code') THEN BEGIN
                            IF ConfOrder.FINDFIRST THEN BEGIN
                                IDEntry.RESET;
                                IDEntry.SETRANGE("Application No.", BondNo);
                                IF IDEntry.FINDFIRST THEN BEGIN
                                    ERROR('Incentive already created');
                                END;

                                CommEntry.RESET;
                                CommEntry.SETRANGE("Application No.", BondNo);
                                CommEntry.SETRANGE("Opening Entries", TRUE);
                                IF CommEntry.FINDFIRST THEN BEGIN
                                    CommEntry."Associate Code" := CorrectAssociateNo;
                                    CommEntry.MODIFY;
                                END;

                                AppPayEntry.RESET;
                                AppPayEntry.SETRANGE("Application No.", BondNo);
                                IF AppPayEntry.FINDFIRST THEN
                                    REPEAT
                                        AppPayEntry."Introducer Code" := CorrectAssociateNo;
                                        AppPayEntry.MODIFY;
                                    UNTIL AppPayEntry.NEXT = 0;

                                CLEAR(PrevAssociateCode);
                                PrevAssociateCode := ConfOrder."Introducer Code";
                                ConfOrder."Introducer Code" := CorrectAssociateNo;
                                ConfOrder."Received From Code" := CorrectAssociateNo;//ALLECK 310313
                                ConfOrder."Region Code" := NewRegionCode; //Code added 01072025
                                ConfOrder."Project Type" := Projecttype;  //Code added 01072025
                                ConfOrder."Travel applicable" := TAApplicable;  //Code added 01072025
                                ConfOrder."Registration Bouns (BSP2)" := RegBonusBSP2;  //Code added 01072025

                                ConfOrder.MODIFY;
                                CLEAR(Newconforder);
                                IF Newconforder.GET(BondNo) THEN BEGIN
                                    Newconforder."Introducer Code" := CorrectAssociateNo;
                                    Newconforder."Received From Code" := CorrectAssociateNo;//ALLECK 310313
                                    Newconforder."Associate Correction Narration" := CorrectionComment;
                                    Newconforder."Region Code" := NewRegionCode; //Code added 01072025
                                    Newconforder."Project Type" := Projecttype;  //Code added 01072025
                                    Newconforder."Travel applicable" := TAApplicable;  //Code added 01072025
                                    Newconforder."Registration Bouns (BSP2)" := RegBonusBSP2;  //Code added 01072025
                                    Newconforder.MODIFY;
                                END;


                                CLEAR(CommLineNo);
                                CommLine.RESET;
                                CommLine.SETRANGE("No.", ConfOrder."No.");
                                IF CommLine.FINDLAST THEN
                                    CommLineNo := CommLine."Line No.";
                                CommLine.RESET;
                                CommLine.INIT;
                                CommLine."Table Name" := CommLine."Table Name"::"G/L Account";// Database::"G/L Account";// 15;
                                CommLine."No." := ConfOrder."No.";
                                CommLine."Line No." := CommLineNo + 10000;
                                CommLine.Date := WORKDATE;
                                CommLine.Comment := CorrectionComment;
                                CommLine."User ID" := USERID;
                                CommLine."Comment Type" := CommLine."Comment Type"::"Associate Change";
                                CommLine.INSERT;

                                CommissionEntry2.RESET;
                                IF CommissionEntry2.FINDLAST THEN
                                    LastentryNo := CommissionEntry2."Entry No."
                                ELSE
                                    LastentryNo := +1;

                                CommissionEntry.RESET;
                                CommissionEntry.SETRANGE("Application No.", BondNo);
                                CommissionEntry.SETRANGE(Reversal, FALSE);
                                IF CommissionEntry.FINDSET THEN
                                    REPEAT
                                        CommissionEntry2.COPY(CommissionEntry);
                                        CommissionEntry2."Entry No." := LastentryNo + 1;
                                        CommissionEntry2."Base Amount" := -CommissionEntry."Base Amount";
                                        CommissionEntry2."Commission Amount" := -CommissionEntry2."Commission Amount";
                                        CommissionEntry2."Voucher No." := '';
                                        CommissionEntry2.Reversal := TRUE;
                                        CommissionEntry2.Posted := FALSE;
                                        CommissionEntry2."Remaining Amount" := 0;
                                        CommissionEntry2."Posting Date" := WORKDATE;
                                        CommissionEntry2."Opening Entries" := FALSE;
                                        LastentryNo := LastentryNo + 1;
                                        CommissionEntry2.INSERT;
                                        CommEntry.GET(CommissionEntry."Entry No.");
                                        CommEntry.Reversal := TRUE;
                                        CommEntry.MODIFY;
                                    UNTIL CommissionEntry.NEXT = 0;


                                UnitCommBuff.RESET;
                                UnitCommBuff.SETRANGE("Unit No.", BondNo);
                                IF UnitCommBuff.FINDSET THEN
                                    REPEAT
                                        UnitCommBuff.DELETE;
                                    UNTIL UnitCommBuff.NEXT = 0;

                                DataExit := FALSE;

                                //010525 Code commented Start

                                // UnitPaymentEntry.RESET;
                                // UnitPaymentEntry.SETRANGE(UnitPaymentEntry."Document No.", BondNo);
                                // UnitPaymentEntry.SETRANGE("Commision Applicable", TRUE);
                                // UnitPaymentEntry.ASCENDING(FALSE);
                                // IF UnitPaymentEntry.FINDFIRST THEN Begin
                                //     LastLineNo := UnitPaymentEntry."Line No.";
                                //     REPEAT
                                //         IF UnitPaymentEntry.Amount > 0 THEN
                                //             FirstLineNo := UnitPaymentEntry."Line No.";
                                //         IF UnitPaymentEntry.Amount < 0 THEN
                                //             DataExit := TRUE;
                                //     UNTIL (UnitPaymentEntry.NEXT = 0) OR DataExit;
                                // END;


                                // UnitPaymentEntry.RESET;
                                // UnitPaymentEntry.SETRANGE(UnitPaymentEntry."Document No.", BondNo);
                                // UnitPaymentEntry.SETRANGE("Commision Applicable", TRUE);
                                // UnitPaymentEntry.SETRANGE("Line No.", FirstLineNo, LastLineNo);
                                // IF UnitPaymentEntry.FINDSET THEN
                                //     REPEAT
                                //         IF UnitCommBuff.GET(BondNo, (UnitPaymentEntry."Line No." / 10000) + 1, UnitPaymentEntry.Sequence) THEN
                                //             UnitCommBuff.DELETE;
                                //         PostPayment.CreateStagingTableAppBond(ConfOrder, UnitPaymentEntry."Line No." / 10000, 1, UnitPaymentEntry.Sequence,
                                //         UnitPaymentEntry."Cheque No./ Transaction No.", UnitPaymentEntry."Commision Applicable", UnitPaymentEntry."Direct Associate"
                                // ,
                                //         UnitPaymentEntry."Posting date", UnitPaymentEntry.Amount, UnitPaymentEntry, FALSE, ConfOrder."Old Process");
                                //     UNTIL UnitPaymentEntry.NEXT = 0;

                                // UnitPaymentEntry.RESET;
                                // UnitPaymentEntry.SETRANGE(UnitPaymentEntry."Document No.", BondNo);
                                // UnitPaymentEntry.SETRANGE("Direct Associate", TRUE);
                                // UnitPaymentEntry.SETRANGE("Line No.", FirstLineNo, LastLineNo);
                                // IF UnitPaymentEntry.FINDSET THEN
                                //     REPEAT
                                //         IF UnitCommBuff.GET(BondNo, (UnitPaymentEntry."Line No." / 10000) + 1, UnitPaymentEntry.Sequence) THEN
                                //             UnitCommBuff.DELETE;
                                //         PostPayment.CreateStagingTableAppBond(ConfOrder, UnitPaymentEntry."Line No." / 10000, 1, UnitPaymentEntry.Sequence,
                                //         UnitPaymentEntry."Cheque No./ Transaction No.", UnitPaymentEntry."Commision Applicable", UnitPaymentEntry."Direct Associate"
                                // ,
                                //         UnitPaymentEntry."Posting date", UnitPaymentEntry.Amount, UnitPaymentEntry, FALSE, ConfOrder."Old Process");
                                //     UNTIL UnitPaymentEntry.NEXT = 0;

                                //010525 Code comment END

                                //010525 new code added start

                                UnitPaymentEntry.RESET;
                                UnitPaymentEntry.SETRANGE(UnitPaymentEntry."Document No.", BondNo);
                                IF UnitPaymentEntry.Findset then
                                    UnitPaymentEntry.DeleteAll();

                                CLEAR(APE);
                                APE.RESET;
                                APE.SETRANGE("Document No.", BondNo);
                                APE.SETRANGE(Posted, TRUE);
                                //IF ROUND(JVAmt) =0 THEN
                                //  APE.SETFILTER("Payment Mode",'<>%1',APE."Payment Mode"::JV);
                                APE.SETRANGE("Cheque Status", APE."Cheque Status"::Cleared);
                                IF APE.FINDSET THEN
                                    REPEAT
                                        CLEAR(AppliPaymentAmount);
                                        CLEAR(TotalBondAmount);
                                        IF APE.Amount <> 0 THEN BEGIN
                                            LastLineNo := 0;
                                            BPayEntry.RESET;
                                            BPayEntry.SETRANGE("Document Type", BPayEntry."Document Type"::BOND);
                                            BPayEntry.SETFILTER(BPayEntry."Document No.", BondNo);
                                            IF BPayEntry.FINDLAST THEN
                                                LastLineNo := BPayEntry."Line No." + 10000
                                            ELSE
                                                LastLineNo := 10000;



                                            TotalAmt := TotalAmt + APE.Amount;
                                            TotalBondAmount := APE.Amount;
                                            AppliPaymentAmount := APE.Amount;



                                            // GetLastLineNo(APE);
                                            DifferenceAmount := 0;
                                            CLEAR(PaymentTermLines);
                                            PaymentTermLines.RESET;
                                            PaymentTermLines.SETRANGE("Document No.", BondNo);
                                            PaymentTermLines.SETRANGE("Payment Plan", ConfOrder."Payment Plan"); //ALLETDK280313
                                            IF PaymentTermLines.FINDSET THEN
                                                REPEAT
                                                    PaymentTermLines.CALCFIELDS("Received Amt");
                                                    DifferenceAmount := PaymentTermLines."Due Amount" - PaymentTermLines."Received Amt";
                                                    LoopingDifferAmount := 0;
                                                    REPEAT
                                                        IF DifferenceAmount < AppliPaymentAmount THEN BEGIN
                                                            IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                                                                BondPayLineAmt := AppliPaymentAmount;
                                                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                                            END ELSE BEGIN
                                                                BondPayLineAmt := DifferenceAmount;
                                                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                                            END;
                                                            TotalBondAmount := TotalBondAmount - BondPayLineAmt;//ALLE PS
                                                            LoopingDifferAmount := DifferenceAmount - BondPayLineAmt;
                                                        END ELSE
                                                            IF DifferenceAmount > AppliPaymentAmount THEN BEGIN
                                                                IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                                                                    BondPayLineAmt := AppliPaymentAmount;
                                                                    AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                                                END ELSE BEGIN
                                                                    BondPayLineAmt := AppliPaymentAmount - AppliPaymentAmount;
                                                                    AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                                                END;
                                                                TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                                                                DifferenceAmount := DifferenceAmount - BondPayLineAmt;
                                                                LoopingDifferAmount := DifferenceAmount - TotalBondAmount;
                                                            END ELSE
                                                                IF DifferenceAmount = AppliPaymentAmount THEN BEGIN
                                                                    BondPayLineAmt := AppliPaymentAmount;
                                                                    AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                                                    TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                                                                END;
                                                        IF BondPayLineAmt <> 0 THEN BEGIN
                                                            CreatePaymentEntryLine(BondPayLineAmt, APE, LastLineNo, PaymentTermLines); //ALLETDK
                                                        END;
                                                        IF AppliPaymentAmount = 0 THEN BEGIN
                                                            IF APE."Cheque Status" = APE."Cheque Status"::Cleared THEN BEGIN //ALLETDK070213
                                                                APE."Explode BOM" := TRUE;
                                                                APE.MODIFY;
                                                                AppliPaymentAmount := APE.Amount;
                                                            END;
                                                        END;
                                                    UNTIL (LoopingDifferAmount = 0) OR (TotalBondAmount = 0);
                                                UNTIL (PaymentTermLines.NEXT = 0) OR (TotalBondAmount = 0);
                                        END;
                                    UNTIL APE.NEXT = 0;


                                IF TotalAmt >= ConfOrder."Min. Allotment Amount" THEN
                                    NewUpdateStagingtable(ConfOrder."No.", ConfOrder."Commission Hold on Full Pmt", TotalAmt, ConfOrder."Min. Allotment Amount");  //Code added 13082025

                                //    PostPayment.UpdateStagingtable(ConfOrder."No."); //Code Commented 13082025


                                //010525 new code added END

                                UnitReversal.CheckandReverseTA(BondNo, TRUE);
                                UnitPost.NewUpdateTEAMHierarcy(ConfOrder, FALSE); //BBG1.00 050613
                                IF PrevAssociateCode <> 'IBA9999999' THEN BEGIN
                                    CLEAR(CommisionGen);
                                    CommisionGen.CreateBondandCommission(WORKDATE, CorrectAssociateNo, BondNo, '', '', TRUE);
                                END;

                                UnitReversal.CreateCommCreditMemo(BondNo, TRUE);
                                UnitReversal.CreateTACreditMemo(CorrectAssociateNo, 0, BondNo, FALSE);
                                //Code added start 06102025
                                UnitSetup.GET;
                                AssociateHierarcywithApp.RESET;
                                AssociateHierarcywithApp.SETCURRENTKEY("Rank Code", "Application Code");
                                AssociateHierarcywithApp.SETRANGE("Application Code", BondNo);
                                AssociateHierarcywithApp.SETRANGE(Status, AssociateHierarcywithApp.Status::Active);
                                IF AssociateHierarcywithApp.FINDSET THEN
                                    REPEAT
                                        IF AssociateHierarcywithApp."Rank Code" <= UnitSetup."Hierarchy Head" THEN BEGIN
                                            UnitPostCu.CalculateCommissionAmount(ConfOrder, AssociateHierarcywithApp, 0, False, False)
                                        END;
                                    Until AssociateHierarcywithApp.Next = 0;

                                //Code added END 06102025

                                IF CorrectAssociateNo <> 'IBA9999999' THEN
                                    SendSMS;

                                MESSAGE('%1', 'Associate Code changed successfully');
                            END;
                            CLEARALL;
                        END;

                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        VendNameEnable := TRUE;
        CorrectChequeNoEnable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        CurrPAGEUpdateControl;
    end;

    var
        AssociateNoCorrection: Boolean;
        CorrectAssociateNo: Text[20];
        BondNo: Code[20];
        ApplicationPaymentEntry: Record "Application Payment Entry";
        UnitPaymentEntry: Record "Unit Payment Entry";
        PostDocNo: Code[20];
        ConfOrder: Record "Confirmed Order";
        AssociateCode: Code[20];
        RecVend: Record Vendor;
        Vend: Record Vendor;
        CommEntry: Record "Commission Entry";
        UnitCommCreationBuffer: Record "Unit & Comm. Creation Buffer";
        UnitPayEntry: Record "Unit Payment Entry";
        AppPayEntry: Record "Application Payment Entry";
        AppNo: Code[20];
        TPDetails: Record "Travel Payment Details";
        IDEntry: Record "Incentive Detail Entry";
        VendName: Text[80];
        CommissionEntry2: Record "Commission Entry";
        CommissionEntry: Record "Commission Entry";
        LastentryNo: Integer;
        UnitCommBuff: Record "Unit & Comm. Creation Buffer";
        UnitReversal: Codeunit "Unit Reversal";
        RecConfirmedORder: Record "Confirmed Order";
        TotAppAmt: Decimal;
        AppPaymentEntry: Record "Application Payment Entry";
        RecConfirmedORder1: Record "Confirmed Order";
        UnitPost: Codeunit "Unit Post";
        ConfOrder1: Record "Confirmed Order";
        CommGen: Codeunit "Unit and Comm. Creation Job";
        ArchiveConfirmedOrder: Record "Archive Confirmed Order";
        LastVersion: Integer;
        PrevAssociateCode: Code[20];
        CorrectionComment: Text[70];
        CommLine: Record "Comment Line";
        CommLineNo: Integer;
        Newconforder: Record "New Confirmed Order";
        CompanyWise: Record "Company wise G/L Account";
        PostPayment: Codeunit PostPayment;
        RecConforder: Record "Confirmed Order";
        RegionwiseVendor: Record "Region wise Vendor";
        Job: Record Job;
        VendBuspost: Record Vendor;
        //NODLine: Record 13785;//Need to check the code in UAT
        AllowedSection: Record "Allowed Sections";

        CorrectChequeNoEnable: Boolean;
        BondpaymentEntry: Record 97794;
        BPayEntry: Record 97794;

        VendNameEnable: Boolean;
        Text19000941: Label 'Associate change in respective Co. / LLP.';
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
        GetDescription: Codeunit GetDescription;
        LastLineNo: Integer;
        NewRegionCode: Code[10];
        OldConfOrder: Record "Confirmed Order";



    procedure CurrPAGEUpdateControl()
    begin

        CorrectChequeNoEnable := AssociateNoCorrection;
        VendNameEnable := AssociateNoCorrection;
    end;


    procedure CreateStagingTableAppBond(Application: Record "Confirmed Order"; InstallmentNo: Integer; YearCode: Integer; MilestoneCode: Code[10]; ChequeNo: Code[20]; CommTree: Boolean; DirectAss: Boolean; PostDate: Date; BaseAmount: Decimal; ChequeDate: Date)
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        Bond: Record "Confirmed Order";
        CommEntry: Record "Commission Entry";
        AmountRecd: Decimal;
    begin
        //CreateStagingTableApplication
        Bond.GET(Application."No.");                                                              //ALLETDK
        AmountRecd := Bond.AmountRecdAppl(Application."No.");             //ALLETDK
        InitialStagingTab.INIT;
        InitialStagingTab."Unit No." := Application."No.";           //ALLETDk
        InitialStagingTab."Installment No." := InstallmentNo + 1;
        InitialStagingTab."Posting Date" := PostDate; //ALLEDK 130113
        InitialStagingTab.VALIDATE("Introducer Code", Application."Introducer Code");  //ALLETDK
        //InitialStagingTab."Base Amount" := BondInvestmentAmt;      //ALLETDK //ALLETDK180213
        InitialStagingTab."Base Amount" := BaseAmount;      //ALLETDK
        InitialStagingTab.VALIDATE("Project Type", Application."Project Type");
        InitialStagingTab.Duration := Application.Duration;
        InitialStagingTab."Year Code" := YearCode;
        InitialStagingTab.VALIDATE("Investment Type", Application."Investment Type");
        InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
        InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
        InitialStagingTab."Application No." := Application."No."; //ALLETDK
        InitialStagingTab."Paid by cheque" := (ChequeNo <> '');                   //ALLETDK
        InitialStagingTab."Cheque No." := ChequeNo;
        InitialStagingTab."Cheque Cleared Date" := ChequeDate;
        InitialStagingTab."Milestone Code" := MilestoneCode;
        InitialStagingTab."Bond Created" := TRUE;
        IF AmountRecd < Bond."Min. Allotment Amount" THEN
            InitialStagingTab."Min. Allotment Amount Not Paid" := TRUE;

        IF (CommTree = FALSE) AND (DirectAss = FALSE) THEN
            InitialStagingTab."Commission Created" := TRUE;

        //IF InitialStagingTab."Paid by cheque" THEN BEGIN
        //InitialStagingTab."Cheque not Cleared" := TRUE;
        //END;

        IF MilestoneCode = '001' THEN BEGIN
            InitialStagingTab."Min. Allotment Amount Not Paid" := FALSE;
            InitialStagingTab."Cheque not Cleared" := FALSE;
        END;

        InitialStagingTab."Direct Associate" := DirectAss;
        InitialStagingTab.INSERT;
    end;

    local procedure AssociateNoCorrectionOnPush()
    begin
        CurrPAGEUpdateControl;
    end;

    local procedure SendSMS()
    var
        ComInfo: Record "Company Information";
        Vendor: Record Vendor;
        CustMobileNo: Text;
        CustSMSText: Text;
        PostPayment: Codeunit PostPayment;
    begin
        IF ComInfo."Send SMS" THEN BEGIN
            IF Vendor.GET(CorrectAssociateNo) THEN
                IF Vendor."BBG Mob. No." <> '' THEN BEGIN
                    CustMobileNo := Vendor."BBG Mob. No.";
                    CustSMSText :=

                   'Dear Mr/Ms:' + Vendor.Name + '' + 'Appl No:' + BondNo + 'Sale ID has been changed as' + CorrectAssociateNo + 'Dt:' + FORMAT(TODAY)
                  + 'Thank and Assure you of our Best Support in Transforming Your Dreams into Reality. Good Luck and God Bless..Team BBG.';
                    MESSAGE('%1', CustSMSText);
                    CLEAR(PostPayment);
                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                    //ALLEDK15112022 Start
                    CLEAR(SMSLogDetails);
                    SmsMessage := '';
                    SmsMessage1 := '';
                    SmsMessage := COPYSTR(CustSMSText, 1, 250);
                    SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                    SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, 'Associate Change', RecConforder."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(RecConforder."Shortcut Dimension 1 Code", 1), RecConforder."No.");
                    //ALLEDK15112022 END
                END;
        END;
    end;

    procedure CreatePaymentEntryLine(Amt: Decimal; BondPaymentEntryRec: Record 97812; RecLineNo: Integer; RecPaymentTermLines: Record 97778)
    var
        UserSetup: Record 91;
        LBondPaymentEntry: Record 97794;
    begin
        BPayEntry.RESET;
        BPayEntry.SETRANGE("Document Type", BPayEntry."Document Type"::BOND);
        BPayEntry.SETFILTER(BPayEntry."Document No.", BondNo);
        IF BPayEntry.FINDLAST THEN
            LastLineNo := BPayEntry."Line No." + 10000
        ELSE
            LastLineNo := 10000;


        BondpaymentEntry.INIT;
        BondpaymentEntry."Document Type" := BondPaymentEntryRec."Document Type";
        BondpaymentEntry."Document No." := BondPaymentEntryRec."Document No.";
        BondpaymentEntry."Line No." := LastLineNo; //RecLineNo;
        //LastLineNo += 10000;
        BondpaymentEntry.VALIDATE("Unit Code", BondPaymentEntryRec."Unit Code"); //ALLETDK141112
        BondpaymentEntry.VALIDATE("Payment Mode", BondPaymentEntryRec."Payment Mode");
        BondpaymentEntry."Application No." := BondPaymentEntryRec."Document No.";
        BondpaymentEntry."Document Date" := BondPaymentEntryRec."Document Date";
        BondpaymentEntry."Posting date" := BondPaymentEntryRec."Posting date";
        BondpaymentEntry.Type := BondPaymentEntryRec.Type;
        BondpaymentEntry.Sequence := RecPaymentTermLines.Sequence; //ALLETDK221112
        BondpaymentEntry."Charge Code" := RecPaymentTermLines."Charge Code"; //ALLETDK081112
        BondpaymentEntry."Actual Milestone" := RecPaymentTermLines."Actual Milestone"; //ALLETDK221112
        BondpaymentEntry."Commision Applicable" := RecPaymentTermLines."Commision Applicable";
        BondpaymentEntry."Direct Associate" := RecPaymentTermLines."Direct Associate";
        BondpaymentEntry."Priority Payment" := BondPaymentEntryRec."Priority Payment";
        IF ((BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::Bank)
            OR (BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.C./C.C./Net Banking")) THEN BEGIN
            BondpaymentEntry.VALIDATE("Cheque No./ Transaction No.", BondPaymentEntryRec."Cheque No./ Transaction No.");
            BondpaymentEntry.VALIDATE("Cheque Date", BondPaymentEntryRec."Cheque Date");
            BondpaymentEntry.VALIDATE("Cheque Bank and Branch", BondPaymentEntryRec."Cheque Bank and Branch");
            BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");
            BondpaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.", BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
            BondpaymentEntry."Deposit/Paid Bank" := BondPaymentEntryRec."Deposit/Paid Bank";
        END;

        IF BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.D." THEN BEGIN
            BondpaymentEntry.VALIDATE("Cheque No./ Transaction No.", BondPaymentEntryRec."Cheque No./ Transaction No.");
            BondpaymentEntry.VALIDATE("Cheque Date", BondPaymentEntryRec."Cheque Date");
            BondpaymentEntry.VALIDATE("Cheque Bank and Branch", BondPaymentEntryRec."Cheque Bank and Branch");
            BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");
            BondpaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.", BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
            BondpaymentEntry."Deposit/Paid Bank" := BondPaymentEntryRec."Deposit/Paid Bank";
        END;
        BondpaymentEntry.Amount := Amt;
        BondpaymentEntry."Shortcut Dimension 1 Code" := BondPaymentEntryRec."Shortcut Dimension 1 Code";

        BondpaymentEntry."Shortcut Dimension 2 Code" := BondPaymentEntryRec."Shortcut Dimension 2 Code";
        BondpaymentEntry."Explode BOM" := TRUE;
        BondpaymentEntry."Branch Code" := BondPaymentEntryRec."User Branch Code"; //ALLETDK141112
        BondpaymentEntry."User ID" := BondPaymentEntryRec."User ID"; //ALLEDK271212
        BondpaymentEntry."App. Pay. Entry Line No." := BondPaymentEntryRec."Line No."; //ALLETDK141112
        BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");//ALLETDK040213
        BondpaymentEntry."Posted Document No." := BondPaymentEntryRec."Posted Document No.";
        BondpaymentEntry."Installment No." := 1;
        BondpaymentEntry.Posted := TRUE;
        BondpaymentEntry.INSERT;

        CreateStagingTableAppBond_2(ConfOrder, BondpaymentEntry."Line No." / 10000, 1, BondpaymentEntry.Sequence,
         BondpaymentEntry."Cheque No./ Transaction No.", BondpaymentEntry."Commision Applicable", BondpaymentEntry."Direct Associate",
         BondpaymentEntry."Posting date", BondpaymentEntry.Amount, BondpaymentEntry."Chq. Cl / Bounce Dt.");
    end;

    procedure CreateStagingTableAppBond_2(Application: Record 97793; InstallmentNo: Integer; YearCode: Integer; MilestoneCode: Code[10]; ChequeNo: Code[20]; CommTree: Boolean; DirectAss: Boolean; PostDate: Date; BaseAmount: Decimal; ChequeDate: Date)
    var
        InitialStagingTab: Record 97816;
        Bond: Record 97793;
        CommEntry: Record 97805;
        AmountRecd: Decimal;
        FullAmountRcvd: boolean;
        AppPaymentEntry1: Record 97812;
        RespCenter: Record "Responsibility Center 1";
        MilestoneProcess: Boolean;
    begin
        Bond.GET(Application."No.");                                                              //ALLETDK
        AmountRecd := Bond.AmountRecdAppl(Application."No.");
        FullAmountRcvd := FALSE;
        AppPaymentEntry1.RESET;
        AppPaymentEntry1.SETCURRENTKEY(AppPaymentEntry1."Document No.", AppPaymentEntry1."Cheque Status");
        AppPaymentEntry1.SETRANGE("Document No.", Bond."No.");
        AppPaymentEntry1.SETRANGE("Cheque Status", AppPaymentEntry1."Cheque Status"::Cleared);
        IF AppPaymentEntry1.FINDSET THEN BEGIN
            AppPaymentEntry1.CALCSUMS(AppPaymentEntry1.Amount);
            IF AppPaymentEntry1.Amount >= AmountRecd THEN
                FullAmountRcvd := TRUE;
        END;

        //Code addded start 13082025
        IF RespCenter.GET(Bond."Shortcut Dimension 1 Code") THEN
            IF RespCenter."Milestone Enabled" THEN
                MilestoneProcess := TRUE;

        //IF NOT FullAmountRcvd THEN  //Code commented 13082025
        //  BaseAmount := PostPayment.UpdateUnit_ComBufferAmt(BondpaymentEntry, FALSE);  //Code commented 13082025

        IF MilestoneProcess THEN BEGIN    //230120
            BaseAmount := PostPayment.UpdateUnit_ComBufferAmt(BondPaymentEntry, TRUE);
        END ELSE
            IF Bond."Commission Hold on Full Pmt" THEN
                BaseAmount := PostPayment.NewUpdateUnit_ComBufferAmt(BondPaymentEntry, TRUE)
            ELSE BEGIN
                IF (BondPaymentEntry."Commision Applicable") THEN
                    BaseAmount := BondPaymentEntry.Amount;
                IF (BondPaymentEntry."Direct Associate") THEN    //120219
                    BaseAmount := BondPaymentEntry.Amount;
            END;
        //Code Added END 13082025

        IF BaseAmount <> 0 THEN BEGIN             //ALLETDK
            InitialStagingTab.INIT;
            InitialStagingTab."Unit No." := Application."No.";           //ALLETDk
            InitialStagingTab."Installment No." := InstallmentNo + 1;
            InitialStagingTab."Posting Date" := PostDate; //ALLEDK 130113
            InitialStagingTab.VALIDATE("Introducer Code", Application."Introducer Code");  //ALLETDK
            InitialStagingTab."Base Amount" := BaseAmount;      //ALLETDK
            InitialStagingTab.VALIDATE("Project Type", Application."Project Type");
            InitialStagingTab.Duration := Application.Duration;
            InitialStagingTab."Year Code" := YearCode;
            InitialStagingTab.VALIDATE("Investment Type", Application."Investment Type");
            InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
            InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
            InitialStagingTab."Application No." := Application."No."; //ALLETDK
            InitialStagingTab."Paid by cheque" := (ChequeNo <> '');                   //ALLETDK
            InitialStagingTab."Cheque No." := ChequeNo;
            InitialStagingTab."Cheque Cleared Date" := ChequeDate;
            InitialStagingTab."Milestone Code" := MilestoneCode;
            InitialStagingTab."Bond Created" := TRUE;
            IF AmountRecd < Bond."Min. Allotment Amount" THEN
                InitialStagingTab."Min. Allotment Amount Not Paid" := TRUE;
            InitialStagingTab."Charge Code" := BondpaymentEntry."Charge Code";
            IF (CommTree = FALSE) AND (DirectAss = FALSE) THEN
                InitialStagingTab."Commission Created" := TRUE;
            IF MilestoneCode = '001' THEN BEGIN
                InitialStagingTab."Min. Allotment Amount Not Paid" := FALSE;
                InitialStagingTab."Cheque not Cleared" := FALSE;
            END;

            InitialStagingTab."Direct Associate" := DirectAss;
            InitialStagingTab.INSERT;
        END;
    end;

    procedure NewUpdateStagingtable(ApplicationNo: Code[20]; Commhold: boolean; TotalRcvdAmt: Decimal; MinAmount: Decimal)
    var
        CommCreateBuffer: Record "Unit & Comm. Creation Buffer";
        TotalCommAmt: Decimal;
        FindlastEntry: Boolean;
    begin
        TotalCommAmt := 0;
        IF Commhold THEN begin
            FindlastEntry := False;
            CommCreateBuffer.RESET;
            CommCreateBuffer.SETRANGE(CommCreateBuffer."Unit No.", ApplicationNo);
            IF CommCreateBuffer.FINDSET THEN
                REPEAT
                    TotalCommAmt := TotalCommAmt + CommCreateBuffer."Base Amount";
                    IF MinAmount >= TotalCommAmt then
                        CommCreateBuffer."Min. Allotment Amount Not Paid" := FALSE
                    ELSE begin
                        IF NOT FindlastEntry THEN BEGIN
                            CommCreateBuffer."Base Amount" := MinAmount - (TotalCommAmt - CommCreateBuffer."Base Amount");
                            CommCreateBuffer."Min. Allotment Amount Not Paid" := FALSE;
                            FindlastEntry := True;
                        END ELSE
                            CommCreateBuffer."Min. Allotment Amount Not Paid" := True;

                    end;
                    CommCreateBuffer.MODIFY;
                UNTIL CommCreateBuffer.NEXT = 0;

        end ELSE BEGIN
            CommCreateBuffer.RESET;
            CommCreateBuffer.SETRANGE(CommCreateBuffer."Unit No.", ApplicationNo);
            CommCreateBuffer.SETRANGE(CommCreateBuffer."Min. Allotment Amount Not Paid", TRUE);
            CommCreateBuffer.SETRANGE(CommCreateBuffer."Cheque not Cleared", FALSE);
            IF CommCreateBuffer.FINDSET THEN
                REPEAT
                    CommCreateBuffer."Min. Allotment Amount Not Paid" := FALSE;
                    CommCreateBuffer.MODIFY;
                UNTIL CommCreateBuffer.NEXT = 0;
        END;
    end;


}

