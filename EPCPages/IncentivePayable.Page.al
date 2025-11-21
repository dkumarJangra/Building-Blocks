page 97991 "Incentive Payable"
{
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Incentive Summary  buffer";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(PaidTo; PaidTo)
                {
                    Caption = 'Paid To';
                    TableRelation = Vendor;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF Vendor.GET(PaidTo) THEN;
                        IF PAGE.RUNMODAL(Page::"Vendor List", Vendor) = ACTION::LookupOK THEN BEGIN
                            PaidTo := Vendor."No.";
                            IF Vendor."BBG Hold Payables" = TRUE THEN BEGIN
                                MESSAGE('Code - %1 %2 is on Hold', PaidTo, GetDescription.GetVendorName(PaidTo));
                                PaidTo := '';
                            END;
                        END;
                    end;

                    trigger OnValidate()
                    begin
                        IF PaidTo <> '' THEN BEGIN
                            Vendor.RESET;
                            Vendor.GET(PaidTo);
                            IF Vendor."BBG Hold Payables" = TRUE THEN BEGIN
                                MESSAGE('Code - %1 %2 is on Hold', PaidTo, GetDescription.GetVendorName(PaidTo));
                                PaidTo := '';
                            END;
                        END;
                    end;
                }
                field("Eligibility Period"; Month2)
                {
                    Caption = 'Eligibility Period';
                }
                field(Year2; Year2)
                {
                    Caption = 'Year2';
                }
                field("Payment Mode"; PayMode)
                {
                    Caption = 'Payment Mode';
                    OptionCaption = ' ,Cash,Cheque';
                }
                field("Bank / GL Code"; BankNo)
                {
                    Caption = 'Bank / GL Code';
                    TableRelation = "Bank Account";

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF PayMode = PayMode::Cash THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"G/L Account List", GLACC) = ACTION::LookupOK THEN BEGIN
                                BankNo := GLACC."No.";
                                BankName := GLACC.Name;
                            END;

                        END ELSE
                            IF PayMode = PayMode::Cheque THEN BEGIN
                                IF PAGE.RUNMODAL(Page::"Bank Account List", BankACC) = ACTION::LookupOK THEN BEGIN
                                    BankNo := BankACC."No.";
                                    BankName := BankACC.Name;
                                END;
                            END;
                    end;
                }
                field(Type; Type2)
                {
                    Caption = 'Type';
                }
                field("Cheque No."; ChequeNo)
                {
                    Caption = 'Cheque No.';
                }
                field("Cheque Date"; ChequeDate)
                {
                    Caption = 'Cheque Date';
                }
                field(Name; 'Name')
                {
                    Caption = 'Name';
                    TableRelation = "Bank Account";

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        IF PayMode = PayMode::Cash THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"G/L Account List", GLACC) = ACTION::LookupOK THEN BEGIN
                                BankNo := GLACC."No.";
                                BankName := GLACC.Name;
                            END;

                        END ELSE
                            IF PayMode = PayMode::Cheque THEN BEGIN
                                IF PAGE.RUNMODAL(Page::"Bank Account List", BankACC) = ACTION::LookupOK THEN BEGIN
                                    BankNo := BankACC."No.";
                                    BankName := BankACC.Name;
                                END;
                            END;
                    end;
                }
                field("Bank Code"; BankName)
                {
                    Caption = 'Bank Code';
                }
            }
            repeater(Group)
            {
                field("Incentive Application No."; Rec."Incentive Application No.")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field(Month; Rec.Month)
                {
                }
                field(Year; Rec.Year)
                {
                }
                field("Plot Incentive Amount"; Rec."Plot Incentive Amount")
                {
                }
                field("Plot Eligible Amount"; Rec."Plot Eligible Amount")
                {
                }
                field("Extent Incentive Amount"; Rec."Extent Incentive Amount")
                {
                }
                field("Extent Eligible Amount"; Rec."Extent Eligible Amount")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ShowButton)
            {
                Caption = '&Add';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Errortext: Text[1024];
                    Divider: Text[30];
                begin
                    IF PayMode = PayMode::" " THEN
                        ERROR('Please define first Payment Mode');
                    IF BankNo = '' THEN
                        ERROR('Please define the GL OR Bank Code');
                    AddVouchers;
                    //CurrPAGE.CashPayment.EDITABLE(FALSE);
                    //CurrPAGE.ChequePayment.EDITABLE(FALSE);
                    //CurrPAGE.PaidTo.EDITABLE(FALSE);
                    //ResetPane;
                    //CurrPAGE.Voucherfilter.ACTIVATE;
                end;
            }
            group("&Posting")
            {
                Caption = '&Posting';
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        //MARKEDONLY(TRUE);
                        PostIncentive(Rec);
                        //MARKEDONLY(FALSE);
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.UPDATE(TRUE);
    end;

    trigger OnOpenPage()
    begin
        UserSetup.GET(USERID);
        Rec.FILTERGROUP(2);
        Rec.SETRANGE(Status, Rec.Status::Open);
        Rec.FILTERGROUP(0);
    end;

    var
        PaidTo: Code[20];
        Year2: Integer;
        Vendor: Record Vendor;
        GetDescription: Codeunit GetDescription;
        PayMode: Option " ",Cash,Cheque;
        BankACC: Record "Bank Account";
        GLACC: Record "G/L Account";
        BankName: Text[60];
        BankNo: Code[20];
        ChequeNo: Code[10];
        ChequeDate: Date;
        Month2: Option " ",January,February,March,April,May,June,July,August,September,October,November,December;
        VoucherCount2: Integer;
        LineNo: Integer;
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        LineNo2: Integer;
        UserSetup: Record "User Setup";
        UnitSetup: Record "Unit Setup";
        IncentiveSummary: Record "Incentive Summary";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        IncentiveSummary2: Record "Incentive Summary";
        GLEntry: Record "G/L Entry";
        VendorPostingGroup: Record "Vendor Posting Group";
        //NODNOCLine: Record 13785;//Need to check the code in UAT
        AllowedSection: Record "Allowed Sections";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DocNo1: Code[20];
        Type2: Option " ",Direct,Team;

    local procedure AddVouchers()
    var
        ConsiderVoucher: Boolean;
        IncentiveSummaryBuffer: Record "Incentive Summary  buffer";
        IncentiveSummary: Record "Incentive Summary";
    begin
        IF PaidTo = '' THEN
            ERROR('Please enter Paid To');

        IncentiveSummaryBuffer.RESET;
        IF IncentiveSummaryBuffer.FINDLAST THEN BEGIN
            LineNo := IncentiveSummaryBuffer."Line No.";
        END;

        IncentiveSummary.RESET;
        IF PaidTo <> '' THEN
            IncentiveSummary.SETRANGE("Associate Code", PaidTo);
        IncentiveSummary.SETRANGE(Month, Month2);
        IncentiveSummary.SETRANGE(Year, Year2);
        IncentiveSummary.SETRANGE(Status, IncentiveSummary.Status::Open);
        IF Type2 <> 0 THEN
            IncentiveSummary.SETRANGE(Type, Type2);
        IF IncentiveSummary.FINDFIRST THEN
            REPEAT
                IncentiveSummaryBuffer.INIT;
                LineNo += 10000;
                IncentiveSummaryBuffer."Incentive Application No." := '';
                IncentiveSummaryBuffer."Line No." := LineNo;
                IncentiveSummaryBuffer.INSERT(TRUE);
                IncentiveSummaryBuffer."Associate Code" := IncentiveSummary."Associate Code";
                IncentiveSummaryBuffer."Detail Entry No." := IncentiveSummary."Detail Entry No.";
                IncentiveSummaryBuffer.Year := IncentiveSummary.Year;
                IncentiveSummaryBuffer.Month := IncentiveSummary.Month;
                IncentiveSummaryBuffer."Plot Incentive Amount" := IncentiveSummary."Plot Incentive Amount";
                IncentiveSummaryBuffer."Plot Eligible Amount" := IncentiveSummary."Plot Eligible Amount";
                IncentiveSummaryBuffer."Extent Incentive Amount" := IncentiveSummary."Extent Incentive Amount";
                IncentiveSummaryBuffer."Extent Eligible Amount" := IncentiveSummary."Extent Eligible Amount";
                //IncentiveSummaryBuffer.Type := IncentiveSummary.Status;
                IncentiveSummaryBuffer.MODIFY;
            UNTIL IncentiveSummary.NEXT = 0;
    end;


    procedure PostIncentive(var IncentiveSummaryBuffer: Record "Incentive Summary  buffer")
    begin
        IF CONFIRM('Do you want to Post Incentive?') THEN BEGIN
            //SETRANGE(Status,IncentiveSummaryBuffer.Status :: Open);
            //REPEAT
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", 'INCENPBL');
            GenJnlLine.SETRANGE(GenJnlLine."Journal Batch Name", 'INCENPBL');
            IF GenJnlLine.FINDLAST THEN BEGIN
                LineNo2 := GenJnlLine."Line No.";
            END;
            UnitSetup.GET;
            // ---------- For Liability Start----------
            GenJnlLine.INIT;
            LineNo2 += 10000;
            GenJnlLine."Journal Template Name" := 'INCENPBL';
            GenJnlLine."Journal Batch Name" := 'INCENPBL';
            GenJnlLine.VALIDATE("Document No.", IncentiveSummaryBuffer."Incentive Application No.");
            GenJnlLine."Line No." := LineNo2;
            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Invoice);
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Document Date", WORKDATE);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", IncentiveSummaryBuffer."Associate Code");
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine.VALIDATE("Party Type", GenJnlLine."Party Type"::Vendor);
            GenJnlLine.VALIDATE("Party Code", Rec."Associate Code");
            GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Bal. Account No.", UnitSetup."Incentive A/C");
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Sales Resp. Ctr. Filter");
            GenJnlLine."External Document No." := GenJnlLine."Document No.";
            //IF NODNOCLine.GET(NODNOCLine.Type::Vendor, IncentiveSummaryBuffer."Associate Code", 'INCT') THEN //Need to check the code in UAT
            IF AllowedSection.Get(IncentiveSummaryBuffer."Associate Code", 'INCT') then
                GenJnlLine.VALIDATE("TDS Section Code", UnitSetup."TDS Nature of Deduction INCT");//"TDS Nature of Deduction"
            GenJnlLine.VALIDATE("Source Code", UnitSetup."Incentive Voucher Source Code");
            GenJnlLine.VALIDATE("Credit Amount", IncentiveSummaryBuffer."Plot Incentive Amount" +
             IncentiveSummaryBuffer."Extent Incentive Amount" - GenJnlLine."GST TDS/TCS Amount (LCY)");
            GenJnlLine."System-Created Entry" := TRUE;
            //GenJnlLine.INSERT;
            GenJnlPostLine.RUN(GenJnlLine);
            IncentiveSummary2.RESET;
            IncentiveSummary2.SETRANGE("Detail Entry No.", IncentiveSummaryBuffer."Detail Entry No.");
            IF IncentiveSummary2.FINDFIRST THEN BEGIN
                GLEntry.RESET;
                GLEntry.SETRANGE("Document Type", GLEntry."Document Type"::Invoice);
                GLEntry.SETRANGE("Document No.", IncentiveSummaryBuffer."Incentive Application No.");
                GLEntry.SETRANGE("Source Code", 'INCTVOU');
                GLEntry.SETRANGE("Source No.", IncentiveSummary2."Associate Code");
                IF Vendor.GET(IncentiveSummary2."Associate Code") THEN BEGIN
                    IF VendorPostingGroup.GET(Vendor."Vendor Posting Group") THEN
                        GLEntry.SETRANGE("G/L Account No.", VendorPostingGroup."Payables Account");
                END;
                IF GLEntry.FINDFIRST THEN BEGIN
                    IncentiveSummary2."Amount Paid" := GLEntry.Amount;
                    IncentiveSummary2.MODIFY;
                END;
            END;
            // ---------- For Liability End----------


            // ---------- For Payment Start ---------
            DocNo1 := NoSeriesMgt.GetNextNo(UnitSetup."Incentive Summary Buffer No.", WORKDATE, TRUE);
            GenJnlLine.INIT;
            LineNo2 += 10000;
            GenJnlLine."Journal Template Name" := 'INCENPBL';
            GenJnlLine."Journal Batch Name" := 'INCENPBL';
            //GenJnlLine.VALIDATE("Document No.",IncentiveSummaryBuffer."Incentive Application No.");
            GenJnlLine.VALIDATE("Document No.", DocNo1);
            GenJnlLine."Line No." := LineNo2;
            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::Payment);
            GenJnlLine.VALIDATE("Posting Date", WORKDATE);
            GenJnlLine.VALIDATE("Document Date", WORKDATE);
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor);
            GenJnlLine.VALIDATE("Account No.", IncentiveSummaryBuffer."Associate Code");
            //GenJnlLine.VALIDATE(Amount,IncentiveSummaryBuffer."Plot Incentive Amount" +
            // IncentiveSummaryBuffer."Extent Incentive Amount");
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;

            IF PayMode = PayMode::Cash THEN BEGIN
                GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Bal. Account No.", BankNo);
            END ELSE
                IF PayMode = PayMode::Cheque THEN BEGIN
                    GenJnlLine.VALIDATE("Bal. Account Type", GenJnlLine."Bal. Account Type"::"Bank Account");
                    GenJnlLine.VALIDATE("Bal. Account No.", BankNo);
                    GenJnlLine.VALIDATE("Cheque No.", ChequeNo);
                    GenJnlLine.VALIDATE("Cheque Date", ChequeDate);
                END;

            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", UserSetup."Sales Resp. Ctr. Filter");
            GenJnlLine."External Document No." := GenJnlLine."Document No.";
            GenJnlLine.VALIDATE("Source Code", UnitSetup."Incentive Voucher Source Code");
            GenJnlLine.VALIDATE(Amount, (-1 * IncentiveSummary2."Amount Paid"));
            /*
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Document Type",VendorLedgerEntry."Document Type" :: Invoice);
            VendorLedgerEntry.SETRANGE("Document No.",GenJnlLine."Document No.");
            IF VendorLedgerEntry.FINDFIRST THEN BEGIN
              GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type" :: Invoice;
              GenJnlLine.VALIDATE("Applies-to Doc. No.",VendorLedgerEntry."Document No.");
              GenJnlLine.VALIDATE(Amount,VendorLedgerEntry."Amount to Apply");
            END;
            */
            GenJnlLine."System-Created Entry" := TRUE;
            //GenJnlLine.INSERT;
            GenJnlPostLine.RUN(GenJnlLine);

            // ---------- For Payment End -----------

            IncentiveSummaryBuffer.Status := IncentiveSummaryBuffer.Status::Posted;
            IncentiveSummaryBuffer.MODIFY;

            IncentiveSummary.RESET;
            IncentiveSummary.SETRANGE("Detail Entry No.", IncentiveSummaryBuffer."Detail Entry No.");
            IF IncentiveSummary.FINDFIRST THEN BEGIN
                IncentiveSummary.Status := IncentiveSummary.Status::Posted;
                IncentiveSummary.MODIFY;
            END;

            //UNTIL IncentiveSummaryBuffer.NEXT = 0;
            MESSAGE('Document Post successfully');
        END;

    end;
}

