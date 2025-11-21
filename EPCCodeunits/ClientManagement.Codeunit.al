codeunit 97758 "Client Management"
{
    Permissions = TableData "G/L Entry" = rm,
                  TableData "Cust. Ledger Entry" = rm,
                  TableData "Vendor Ledger Entry" = rm,
                  TableData "Bank Account Ledger Entry" = rm,
                  TableData "Detailed Cust. Ledg. Entry" = rm;

    trigger OnRun()
    begin
        PAGE.RUNMODAL(0, TempGLEntry);
    end;

    var
        Text001: Label 'You cannot  delete a default Customer Template %1';
        Text002: Label 'There is not enough space to insert correction lines.';
        Text003: Label 'Being revenue booked towards %1 for the Client %2 Contract No. %3 Dated %4.';
        Text003A: Label 'Being reimbursement booked towards %1 for the Client %2 Contract No. %3 Dated %4.';
        Text004: Label 'Being deffered revenue booked towards %1 for the Client %2 Contract No. %3 Dated %4.';
        Text005: Label 'Being %1 proceesed for the Client %2 Contract No. %3 Dated %4.';
        Text006: Label 'You must import a Mail Template for %1 %2 %3.';
        CompanyInfo: Record "Company Information";
        HasGotCompanyInfo: Boolean;
        //SMTPSetup: Record 409;
        HasGotSMTPSetup: Boolean;
        UserSetup: Record "User Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        InvtSetup: Record "Inventory Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        GLSetupRead: Boolean;
        InvtSetupRead: Boolean;
        PurchSetupRead: Boolean;
        Text007: Label 'You have %1 No. of  Credit Card(s), which are going to expire within 30 days, %2 within 60 Days , %3 within 90 Days. Do you want to open list?';
        Text008: Label 'You have not received %1 No. of  Bounce Cheques(s) from %2 to %3. Do you want to open list?';
        Text009: Label 'You have marked as Skip  %1 No. of Instruments (s) from %2 to %3. You can block records so that list will not appear further. Do you want to open list?';
        Text010: Label '%1 No. of Items are near reorder point. Do you want to open list?';
        Text011: Label 'Item %1 is not sufficient in Location %2 as on %3';
        Text100: Label 'This is computer generated document and no signature is required.';
        TempGLEntry: Record "G/L Entry" temporary;
        Text022: Label 'You have %1 BG(s)which is going to expiry with in 30 days. Do you want to open %2?';
        DefaultDim: Record "Default Dimension";
        DimMgt: Codeunit DimensionManagement;
        GenJnlBatch: Record "Gen. Journal Batch";


    procedure GetUserName(pUserID: Code[50]): Text
    var
        User: Record User;
    begin
        User.SETRANGE("User Name", pUserID);
        IF User.FINDSET THEN
            EXIT(User."Full Name");
    end;


    procedure GetCompInfo()
    begin
        IF HasGotCompanyInfo THEN
            EXIT;
        CompanyInfo.GET;
        HasGotCompanyInfo := TRUE;
    end;

    local procedure GetGLSetup()
    begin
        IF NOT GLSetupRead THEN
            GLSetup.GET;
        GLSetupRead := TRUE;
    end;

    local procedure GetPurchSetup()
    begin
        IF NOT PurchSetupRead THEN
            PurchSetup.GET;
        PurchSetupRead := TRUE;
    end;


    procedure GetSalesSetup()
    begin
        SalesSetup.GET;
    end;

    local procedure GetInvtSetup()
    begin
        IF NOT InvtSetupRead THEN
            InvtSetup.GET;
        InvtSetupRead := TRUE;
    end;


    procedure GetSMTPSetup()
    begin
        IF HasGotSMTPSetup THEN
            EXIT;
        // SMTPSetup.GET;
        // SMTPSetup.TESTFIELD("User ID");
        HasGotSMTPSetup := TRUE;
    end;


    procedure GetFinancialYear(): Text[30]
    begin
        IF DATE2DMY(WORKDATE, 2) > 3 THEN
            EXIT(FORMAT(DMY2DATE(1, 4, DATE2DMY(WORKDATE, 3)), 0, 4) + '..' + FORMAT(DMY2DATE(31, 3, DATE2DMY(WORKDATE, 3) + 1), 0, 4));
        EXIT(FORMAT(DMY2DATE(1, 4, DATE2DMY(WORKDATE, 3) - 1), 0, 4) + '..' + FORMAT(DMY2DATE(31, 3, DATE2DMY(WORKDATE, 3)), 0, 4));
    end;


    procedure GetDDMM(pDate: Date): Code[4]
    var
        DD: Integer;
        MM: Integer;
        DDT: Code[2];
        MMT: Code[2];
    begin
        IF pDate = 0D THEN
            EXIT;

        DD := DATE2DMY(pDate, 1);
        MM := DATE2DMY(pDate, 2);

        IF DD <= 9 THEN
            DDT := '0' + FORMAT(DD)
        ELSE
            DDT := FORMAT(DD);
        IF MM <= 9 THEN
            MMT := '0' + FORMAT(MM)
        ELSE
            MMT := FORMAT(MM);
        EXIT(DDT + MMT)
    end;


    procedure GetDDMMYYYY(pDate: Date): Code[6]
    var
        DD: Integer;
        MM: Integer;
        YY: Integer;
        DDT: Code[2];
        MMT: Code[2];
        YYT: Code[2];
    begin
        IF pDate = 0D THEN
            EXIT;

        DD := DATE2DMY(pDate, 1);
        MM := DATE2DMY(pDate, 2);
        YY := DATE2DMY(pDate, 3);

        IF DD <= 9 THEN
            DDT := '0' + FORMAT(DD)
        ELSE
            DDT := FORMAT(DD);
        IF MM <= 9 THEN
            MMT := '0' + FORMAT(MM)
        ELSE
            MMT := FORMAT(MM);
        YYT := COPYSTR(FORMAT(YY), 3, 4);
        EXIT(DDT + MMT + YYT)
    end;


    procedure GetYYMM(pDate: Date): Code[6]
    var
        DD: Integer;
        MM: Integer;
        YY: Integer;
        DDT: Code[2];
        MMT: Code[2];
        YYT: Code[2];
    begin
        IF pDate = 0D THEN
            EXIT;
        MM := DATE2DMY(pDate, 2);
        YY := DATE2DMY(pDate, 3);
        IF MM <= 9 THEN
            MMT := '0' + FORMAT(MM)
        ELSE
            MMT := FORMAT(MM);
        YYT := COPYSTR(FORMAT(YY), 3, 4);
        EXIT(YYT + MMT)
    end;


    procedure "-Template-"()
    begin
    end;


    procedure JournalApprovalRequired(pTemplateName: Code[20]; pBatchName: Code[20]): Boolean
    begin
        //GenJnlBatch.GET(pTemplateName,pBatchName);
        //EXIT(GenJnlBatch."Approval Required")
    end;


    procedure ChequeLength(pPaymentMethoCode: Code[10]; pCode: Code[6]) ChequeNo: Code[6]
    begin
        IF STRLEN(pCode) IN [0, 6] THEN
            ChequeNo := pCode
        ELSE
            IF STRLEN(pCode) = 5 THEN
                ChequeNo := '0' + pCode
            ELSE
                IF STRLEN(pCode) = 4 THEN
                    ChequeNo := '00' + pCode
                ELSE
                    IF STRLEN(pCode) = 3 THEN
                        ChequeNo := '000' + pCode
                    ELSE
                        IF STRLEN(pCode) = 2 THEN
                            ChequeNo := '0000' + pCode
                        ELSE
                            IF STRLEN(pCode) = 1 THEN
                                ChequeNo := '00000' + pCode;
        EXIT(ChequeNo);
    end;


    procedure "--Narration--"()
    begin
    end;


    procedure InsertGenJournalNarrationBuffer(pTableId: Integer; pJournalTemplateName: Code[20]; pJournalBatchName: Code[20]; pDocumentNo: Code[20]; pLineNo: Integer; pNarration: Text[250])
    var
        TempGenJournalNarrBuff: Record "Reapproved Commission Voucher" temporary;
        GenJournalNarrBuff: Record "Reapproved Commission Voucher";
        Position: Integer;
        SubRemarks: Text[50];
        Line: Integer;
    begin
        /*
        TempGenJournalNarrBuff.RESET;
        TempGenJournalNarrBuff.DELETEALL;
        
        WHILE STRLEN(pNarration) > 0 DO BEGIN
          Position := STRPOS(pNarration,' ');
          IF Position <> 0 THEN BEGIN
            SubRemarks := COPYSTR(pNarration,1,Position);
            pNarration := COPYSTR(pNarration,(Position+1),STRLEN(pNarration));
          END ELSE BEGIN
            SubRemarks := pNarration;
            pNarration := '';
          END;
        
          TempGenJournalNarrBuff.INIT;
          TempGenJournalNarrBuff."Table ID" :=pTableId;
          TempGenJournalNarrBuff."Journal Template Name" := pJournalTemplateName;
          TempGenJournalNarrBuff."Journal Batch Name" := pJournalBatchName;
          TempGenJournalNarrBuff."Document No." := pDocumentNo;
          TempGenJournalNarrBuff."Source Journal Line No." := pLineNo;
          TempGenJournalNarrBuff."Line No." += 1000;
          TempGenJournalNarrBuff.Narration := SubRemarks;
          TempGenJournalNarrBuff.INSERT;
        END;
        
        SubRemarks := '';
        TempGenJournalNarrBuff.RESET;
        TempGenJournalNarrBuff.SETRANGE("Table ID" ,pTableId);
        TempGenJournalNarrBuff.SETRANGE("Journal Template Name" , pJournalTemplateName);
        TempGenJournalNarrBuff.SETRANGE("Journal Batch Name" ,pJournalBatchName);
        TempGenJournalNarrBuff.SETRANGE("Document No." ,pDocumentNo);
        TempGenJournalNarrBuff.SETRANGE("Source Journal Line No." ,pLineNo);
        IF TempGenJournalNarrBuff.FINDSET THEN
          REPEAT
            IF (STRLEN(SubRemarks) + STRLEN(TempGenJournalNarrBuff.Narration)) < 50 THEN
              SubRemarks += TempGenJournalNarrBuff.Narration
            ELSE BEGIN
              Line += 1000;
              GenJournalNarrBuff.INIT;
              GenJournalNarrBuff."Table ID" :=pTableId;
              GenJournalNarrBuff."Journal Template Name" := pJournalTemplateName;
              GenJournalNarrBuff."Journal Batch Name" := pJournalBatchName;
              GenJournalNarrBuff."Document No." := pDocumentNo;
              GenJournalNarrBuff."Source Journal Line No." := pLineNo;
              GenJournalNarrBuff.Narration := SubRemarks;
              GenJournalNarrBuff."Line No." := Line;
              GenJournalNarrBuff.Narration := SubRemarks;
              GenJournalNarrBuff.INSERT;
              SubRemarks := '';
              SubRemarks += TempGenJournalNarrBuff.Narration;
            END;
          UNTIL TempGenJournalNarrBuff.NEXT = 0;
        
        IF STRLEN(SubRemarks) > 0 THEN BEGIN
          Line += 1000;
          GenJournalNarrBuff.INIT;
          GenJournalNarrBuff."Journal Template Name" := pJournalTemplateName;
          GenJournalNarrBuff."Journal Batch Name" := pJournalBatchName;
          GenJournalNarrBuff."Document No." := pDocumentNo;
          GenJournalNarrBuff."Source Journal Line No." := pLineNo;
          GenJournalNarrBuff.Narration := SubRemarks;
          GenJournalNarrBuff."Line No." := Line;
          GenJournalNarrBuff.Narration := SubRemarks;
          GenJournalNarrBuff.INSERT;
        END;
        */

    end;


    procedure CopytoGenJournalNarrationBuffer(pTableId: Integer; pJournalTemplateName: Code[10]; pJournalBatchName: Code[10]; pDocumentNo: Code[20]; pJournalLineNoFrom: Integer; pJournalLineNoTo: Integer)
    var
        GenJournalNarrBuff: Record "Reapproved Commission Voucher";
        GenJournalNarrBuff2: Record "Reapproved Commission Voucher";
    begin
        /*
        GenJournalNarrBuff.RESET;
        GenJournalNarrBuff.SETRANGE("Table ID",pTableId);
        GenJournalNarrBuff.SETRANGE("Journal Template Name",pJournalTemplateName);
        GenJournalNarrBuff.SETRANGE("Journal Batch Name",pJournalBatchName);
        GenJournalNarrBuff.SETRANGE("Document No.",pDocumentNo);
        GenJournalNarrBuff.SETRANGE("Source Journal Line No.",pJournalLineNoFrom);
        IF GenJournalNarrBuff.FINDSET THEN
        REPEAT
          GenJournalNarrBuff2.INIT;
          GenJournalNarrBuff2.TRANSFERFIELDS(GenJournalNarrBuff);
          GenJournalNarrBuff2."Source Journal Line No." := pJournalLineNoTo;
          GenJournalNarrBuff2.INSERT;
        UNTIL GenJournalNarrBuff.NEXT = 0;
        */

    end;


    procedure CopytoGenJournalNarrationLine(var pGenJnlLine: Record "Gen. Journal Line"; TableID: Integer)
    var
        GenJournalNarrBuff: Record "Reapproved Commission Voucher";
        GenJournalNarration: Record "Gen. Journal Narration"; //"Gen. Journal Narration";
    begin
        /*
        GenJournalNarrBuff.RESET;
        GenJournalNarrBuff.SETRANGE("Table ID",TableID);
        GenJournalNarrBuff.SETRANGE("Journal Template Name",pGenJnlLine."Journal Template Name");
        GenJournalNarrBuff.SETRANGE("Journal Batch Name",pGenJnlLine."Journal Batch Name");
        GenJournalNarrBuff.SETRANGE("Document No.",pGenJnlLine."Shortcut Dimension 2 Code");
        //IF TableID = DATABASE::"Instrument Register" THEN
        //  GenJournalNarrBuff.SETRANGE("Source Journal Line No.",pGenJnlLine."Instrument Line No.")
        //ELSE IF TableID = DATABASE::"Revenue Register" THEN
        //   GenJournalNarrBuff.SETRANGE("Source Journal Line No.",pGenJnlLine."Revenue Line No.")
        //ELSE
        //IF TableID = DATABASE::"Gen. Journal Line Buffer" THEN
        //  GenJournalNarrBuff.SETRANGE("Source Journal Line No.",pGenJnlLine."Source Line No.");
        IF GenJournalNarrBuff.FINDSET THEN
        REPEAT
          GenJournalNarration.INIT;
          GenJournalNarration.TRANSFERFIELDS(GenJournalNarrBuff);
          GenJournalNarration."Document No." :=pGenJnlLine."Document No.";
          GenJournalNarration."Gen. Journal Line No." :=pGenJnlLine."Line No.";
          GenJournalNarration.INSERT(TRUE);
        UNTIL GenJournalNarrBuff.NEXT = 0;
        */

    end;


    procedure CopytoGenJournalNarrationVch(var pGenJnlLine: Record "Gen. Journal Line"; TableID: Integer)
    var
        GenJournalNarrBuff: Record "Reapproved Commission Voucher";
        GenJournalNarration: Record "Gen. Journal Narration";
    begin
        /*
        GenJournalNarrBuff.RESET;
        GenJournalNarrBuff.SETRANGE("Table ID",TableID);
        GenJournalNarrBuff.SETRANGE("Journal Template Name",pGenJnlLine."Journal Template Name");
        GenJournalNarrBuff.SETRANGE("Journal Batch Name",pGenJnlLine."Journal Batch Name");
        GenJournalNarrBuff.SETRANGE("Document No.",pGenJnlLine."Shortcut Dimension 2 Code");
        //IF TableID = DATABASE::"Instrument Register" THEN
        //  GenJournalNarrBuff.SETRANGE("Source Journal Line No.",pGenJnlLine."Instrument Line No.")
        //ELSE IF TableID = DATABASE::"Revenue Register" THEN
        //   GenJournalNarrBuff.SETRANGE("Source Journal Line No.",pGenJnlLine."Revenue Line No.")
        //ELSE IF TableID = DATABASE::"Gen. Journal Line Buffer" THEN
        //  GenJournalNarrBuff.SETRANGE("Source Journal Line No.",pGenJnlLine."Source Line No.");
        IF GenJournalNarrBuff.FINDSET THEN
        REPEAT
          GenJournalNarration.INIT;
          GenJournalNarration.TRANSFERFIELDS(GenJournalNarrBuff);
          GenJournalNarration."Document No." :=pGenJnlLine."Document No.";
          GenJournalNarration."Gen. Journal Line No." :=0;
          GenJournalNarration.INSERT(TRUE);
        UNTIL GenJournalNarrBuff.NEXT = 0;
        */

    end;


    procedure GetDimensionSetID(ShortcutDimension1Code: Code[20]; ShortcutDimension2Code: Code[20]; ShortcutDimension3Code: Code[20]; ShortcutDimension4Code: Code[20]; ShortcutDimension5Code: Code[20]; ShortcutDimension6Code: Code[20]; ShortcutDimension7Code: Code[20]; ShortcutDimension8Code: Code[20]): Integer
    var
        TempGenJournalLine: Record "Gen. Journal Line" temporary;
    begin
        TempGenJournalLine.INIT;
        IF ShortcutDimension1Code <> '' THEN
            TempGenJournalLine.VALIDATE("Shortcut Dimension 1 Code", ShortcutDimension1Code);
        IF ShortcutDimension2Code <> '' THEN
            TempGenJournalLine.VALIDATE("Shortcut Dimension 2 Code", ShortcutDimension2Code);
        /*
        //IF ShortcutDimension3Code<>'' THEN
         // TempGenJournalLine.VALIDATE("Shortcut Dimension 3 Code",ShortcutDimension3Code);
        //IF ShortcutDimension4Code<>'' THEN
          //TempGenJournalLine.VALIDATE("Shortcut Dimension 4 Code",ShortcutDimension4Code);
        IF ShortcutDimension5Code<>'' THEN
          TempGenJournalLine.VALIDATE("Shortcut Dimension 5 Code",ShortcutDimension5Code);
        IF ShortcutDimension6Code<>'' THEN
          TempGenJournalLine.VALIDATE("Shortcut Dimension 6 Code",ShortcutDimension6Code);
        IF ShortcutDimension7Code<>'' THEN
          TempGenJournalLine.VALIDATE("Shortcut Dimension 7 Code",ShortcutDimension7Code);
        IF ShortcutDimension8Code<>'' THEN
          TempGenJournalLine.VALIDATE("Shortcut Dimension 8 Code",ShortcutDimension8Code);
          */
        TempGenJournalLine.INSERT;

        EXIT(TempGenJournalLine."Dimension Set ID");

    end;


    procedure "--Get--"()
    begin
    end;


    procedure Dimension2CodeMandatory(): Boolean
    begin
        //GetGLSetup;
        //EXIT(GLSetup."Dimension 2 Code Mandatory")
    end;


    procedure GetShortcutDimension2Code(pType: Option " ","G/L Account",Item,,"Fixed Asset","Charge (Item)"; pCode: Code[20]): Code[20]
    begin
        GetGLSetup;
        // IF DefaultDim.GET(DimMgt.TypeToTableID3(pType), pCode, GLSetup."Shortcut Dimension 2 Code") THEN
        //     EXIT(DefaultDim."Dimension Value Code");
    end;


    procedure GerEntryType(pEntryType: Option Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output"): Text
    var
        EntryType: Option Purchase,Sale,Positive,Issue,Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
    begin
        EntryType := pEntryType;
        EXIT(FORMAT(EntryType));
    end;


    procedure GetDimensionName(pDimensionNo: Integer; pCode: Code[20]): Text[50]
    var
        DimensionValue: Record "Dimension Value";
    begin
        IF pCode = '' THEN
            EXIT;
        GetGLSetup;
        CASE pDimensionNo OF
            1:
                DimensionValue.GET(GLSetup."Global Dimension 1 Code", pCode);
            2:
                DimensionValue.GET(GLSetup."Global Dimension 2 Code", pCode);
            3:
                DimensionValue.GET(GLSetup."Shortcut Dimension 3 Code", pCode);
            4:
                DimensionValue.GET(GLSetup."Shortcut Dimension 4 Code", pCode);
            5:
                DimensionValue.GET(GLSetup."Shortcut Dimension 5 Code", pCode);
            6:
                DimensionValue.GET(GLSetup."Shortcut Dimension 6 Code", pCode);
            7:
                DimensionValue.GET(GLSetup."Shortcut Dimension 7 Code", pCode);
            8:
                DimensionValue.GET(GLSetup."Shortcut Dimension 8 Code", pCode);
        END;
        EXIT(DimensionValue.Name)
    end;


    procedure GetAccountName(AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[20]): Text[50]
    var
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
    begin
        IF AccountNo = '' THEN
            EXIT;

        CASE AccountType OF
            AccountType::"G/L Account":
                BEGIN
                    IF GLAccount.GET(AccountNo) THEN
                        EXIT(GLAccount.Name)
                END;
            AccountType::Customer:
                BEGIN
                    IF Customer.GET(AccountNo) THEN
                        EXIT(Customer.Name)
                END;
            AccountType::Vendor:
                BEGIN
                    IF Vendor.GET(AccountNo) THEN
                        EXIT(Vendor.Name)
                END;
            AccountType::"Bank Account":
                BEGIN
                    IF BankAccount.GET(AccountNo) THEN
                        EXIT(BankAccount.Name)
                END;
            AccountType::"Fixed Asset":
                BEGIN
                    IF FixedAsset.GET(AccountNo) THEN
                        EXIT(FixedAsset.Description)
                END;
            AccountType::"IC Partner":
                BEGIN
                    IF ICPartner.GET(AccountNo) THEN
                        EXIT(ICPartner.Name)
                END;
        END;
    end;


    procedure GetSalePersonName(pCode: Code[10]): Text
    var
        SalesPerson: Record "Salesperson/Purchaser";
    begin
        IF SalesPerson.GET(pCode) THEN
            EXIT(SalesPerson.Name)
    end;


    procedure GetInventoryPostingGrp(pCode: Code[10]): Text
    var
        PostingGroup: Record "Inventory Posting Group";
    begin
        IF PostingGroup.GET(pCode) THEN
            EXIT(PostingGroup.Description)
    end;


    procedure GetGenProdPostingGrp(pCode: Code[10]): Text
    var
        PostingGroup: Record "Gen. Product Posting Group";
    begin
        IF PostingGroup.GET(pCode) THEN
            EXIT(PostingGroup.Description)
    end;


    procedure GetVendorPostingGrpName(pCode: Code[10]): Text
    var
        PostingGroup: Record "Vendor Posting Group";
    begin
        IF PostingGroup.GET(pCode) THEN;
        //  EXIT(PostingGroup.Description)
    end;


    procedure GetPostingGrp(pBankAccountLedgerEntry: Record "Bank Account Ledger Entry"): Text
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        GLAcc: Record "G/L Account";
    begin
        IF pBankAccountLedgerEntry."Bal. Account Type" = pBankAccountLedgerEntry."Bal. Account Type"::Vendor THEN BEGIN
            IF Vendor.GET(pBankAccountLedgerEntry."Bal. Account No.") THEN
                EXIT(GetVendorPostingGrpName(Vendor."Vendor Posting Group"))
        END ELSE
            IF pBankAccountLedgerEntry."Bal. Account Type" = pBankAccountLedgerEntry."Bal. Account Type"::Customer THEN BEGIN
                IF Customer.GET(pBankAccountLedgerEntry."Bal. Account No.") THEN
                    EXIT(Customer."Customer Posting Group")
            END ELSE
                IF pBankAccountLedgerEntry."Bal. Account Type" = pBankAccountLedgerEntry."Bal. Account Type"::"G/L Account" THEN BEGIN
                    IF GLAcc.GET(pBankAccountLedgerEntry."Bal. Account No.") THEN
                        EXIT(GLAcc.Name)
                    ELSE
                        EXIT(pBankAccountLedgerEntry."Source Code")
                END ELSE
                    EXIT(pBankAccountLedgerEntry."Source Code")
    end;


    procedure GetItemDescription(pCode: Code[20]): Text[100]
    var
        Item: Record Item;
    begin
        IF pCode = '' THEN
            EXIT;
        Item.GET(pCode);
        //IF NOT Item."Product Line" THEN
        EXIT(Item.Description + ' ' + Item."Description 2");
        //EXIT(Item.Description)
    end;


    procedure GetSampleStored(pCode: Code[20]): Text[100]
    var
        Item: Record Item;
    begin
        IF pCode = '' THEN
            EXIT;
        Item.GET(pCode);
        //IF Item."Product Line" THEN
        //  EXIT(Item."Gen. Prod. Posting Group");
    end;


    procedure GetItemUOM(pCode: Code[20]): Code[10]
    var
        Item: Record Item;
    begin
        IF pCode = '' THEN
            EXIT;
        Item.GET(pCode);
        EXIT(Item."Base Unit of Measure")
    end;


    procedure GetLocationName(pCode: Code[20]): Text
    var
        Location: Record Location;
    begin
        IF pCode = '' THEN
            EXIT;
        Location.GET(pCode);
        EXIT(Location.Code)
    end;


    procedure GetSourceName(pCode: Code[20]): Text[50]
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        DimValue: Record "Dimension Value";
        FixedAsset: Record "Fixed Asset";
        Bank: Record "Bank Account";
    begin
        IF pCode = '' THEN
            EXIT;

        GetGLSetup;
        IF Vendor.GET(pCode) THEN
            EXIT(Vendor.Name)
        ELSE
            IF Customer.GET(pCode) THEN
                EXIT(Customer.Name)
            ELSE
                IF DimValue.GET(GLSetup."Shortcut Dimension 5 Code", pCode) THEN
                    EXIT(DimValue.Name)
                ELSE
                    IF FixedAsset.GET(pCode) THEN
                        EXIT(FixedAsset.Description)
                    ELSE
                        IF Bank.GET(pCode) THEN
                            EXIT(Bank."No.")
    end;


    procedure GetTDSPartyAccountNo(pCode: Code[20]): Code[20]
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        Bank: Record "Bank Account";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
    begin
        IF pCode = '' THEN
            EXIT;

        GetGLSetup;
        IF Vendor.GET(pCode) THEN
            EXIT(Vendor."Vendor Posting Group")
        ELSE
            IF Customer.GET(pCode) THEN
                EXIT(Customer."Customer Posting Group")
            ELSE
                IF Bank.GET(pCode) THEN BEGIN
                    BankAccountPostingGroup.GET(Bank."Bank Acc. Posting Group");
                    EXIT('');//BankAccountPostingGroup."G/L Bank Account No."
                END ELSE
                    EXIT(pCode);
    end;


    procedure GetCustBankAccountName(pCustomerCode: Code[20]; pCustomerBankAccountCode: Code[10]; pPaymentMethodCode: Code[10]; pCustomerBankCode: Code[10]): Text[80]
    var
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        IF CustomerBankAccount.GET(pCustomerCode, pCustomerBankAccountCode, pPaymentMethodCode, pCustomerBankCode) THEN
            EXIT(CustomerBankAccount.Name);
    end;


    procedure GetCustBankAccountNo(pCustomerCode: Code[20]; pCustomerBankAccountCode: Code[10]; pPaymentMethodCode: Code[10]; pCustomerBankCode: Code[10]): Text[80]
    var
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        IF CustomerBankAccount.GET(pCustomerCode, pCustomerBankAccountCode, pPaymentMethodCode, pCustomerBankCode) THEN
            EXIT(CustomerBankAccount."Bank Account No.");
    end;


    procedure GetCustBankAccHolderName(pCustomerCode: Code[20]; pCustomerBankAccountCode: Code[10]; pPaymentMethodCode: Code[10]; pCustomerBankCode: Code[10]): Text[80]
    var
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        //IF CustomerBankAccount.GET(pCustomerCode,pCustomerBankAccountCode,pPaymentMethodCode,pCustomerBankCode) THEN
        //  EXIT(CustomerBankAccount."Account Holder Name");
    end;


    procedure GetMonthName(pMonth: Integer): Text[10]
    var
        Month: Option January,February,March,April,May,June,July,August,September,October,November,December;
    begin
        IF pMonth = 0 THEN
            EXIT;
        Month := pMonth - 1;
        EXIT(FORMAT(Month));
    end;


    procedure GetGLEParticulars(pEntry: Record "G/L Entry") Particluars: Text
    var
        DimValue: Record "Dimension Value";
    begin
        GetGLSetup;
        Particluars := '';
        IF DimValue.GET(GLSetup."Global Dimension 1 Code", pEntry."Global Dimension 1 Code") THEN
            Particluars := 'CostCentre' + ' : ' + DimValue.Name + ' , ';
        IF DimValue.GET(GLSetup."Global Dimension 2 Code", pEntry."Global Dimension 2 Code") THEN
            Particluars += ' Contract' + ' : ' + DimValue.Code + ' , ';

        //IF pEntry."KIT No." <>'' THEN
        //  Particluars += ' KIT' +' : ' + pEntry."KIT No."+ ' , ';

        //IF pEntry."Lab. Unique Identification No." <> '' THEN
        //  Particluars += ' UIN' +' : ' +pEntry."Lab. Unique Identification No." + ' , ';

        //IF pEntry."Shortcut Dimension 4 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 4 Code",pEntry."Shortcut Dimension 4 Code") THEN
        //    Particluars += ' DEPT' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 5 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 5 Code",pEntry."Shortcut Dimension 5 Code") THEN
        //    Particluars += ' EMP' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 6 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 6 Code",pEntry."Shortcut Dimension 6 Code") THEN
        //    Particluars += ' FIN' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 7 Code" <>'' THEN
        // IF DimValue.GET(GLSetup."Shortcut Dimension 7 Code",pEntry."Shortcut Dimension 7 Code") THEN
        //    Particluars += ' PLN' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 8 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 8 Code",pEntry."Shortcut Dimension 8 Code") THEN
        //     Particluars += ' VND' + ' : '+DimValue.Name+ ' , ';

        IF pEntry."BBG Cheque No." <> '' THEN
            Particluars += pEntry.FIELDCAPTION("BBG Cheque No.") + ' : ' + pEntry."BBG Cheque No." + ' , ';

        IF pEntry."BBG Cheque Date" <> 0D THEN
            Particluars += pEntry.FIELDCAPTION("BBG Cheque Date") + ' : ' + FORMAT(pEntry."BBG Cheque Date") + ' , ';

        Particluars := DELCHR(Particluars, '>', ' , ');
    end;


    procedure GetCLEParticulars(pEntry: Record "Cust. Ledger Entry") Particluars: Text
    var
        DimValue: Record "Dimension Value";
    begin
        GetGLSetup;
        Particluars := '';
        IF DimValue.GET(GLSetup."Global Dimension 1 Code", pEntry."Global Dimension 1 Code") THEN
            Particluars := 'CostCentre' + ' : ' + DimValue.Name + ' , ';
        IF DimValue.GET(GLSetup."Global Dimension 2 Code", pEntry."Global Dimension 2 Code") THEN
            Particluars += ' Contract' + ' : ' + DimValue.Code + ' , ';

        //IF pEntry."KIT No." <>'' THEN
        //  Particluars += ' KIT' +' : ' + pEntry."KIT No."+ ' , ';

        //IF pEntry."Lab. Unique Identification No." <> '' THEN
        //  Particluars += ' UIN' +' : ' +pEntry."Lab. Unique Identification No." + ' , ';

        //IF pEntry."Shortcut Dimension 4 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 4 Code",pEntry."Shortcut Dimension 4 Code") THEN
        //    Particluars += ' DEPT' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 5 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 5 Code",pEntry."Shortcut Dimension 5 Code") THEN
        //    Particluars += ' EMP' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 6 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 6 Code",pEntry."Shortcut Dimension 6 Code") THEN
        //    Particluars += ' FIN' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 7 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 7 Code",pEntry."Shortcut Dimension 7 Code") THEN
        //    Particluars += ' PLN' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 8 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 8 Code",pEntry."Shortcut Dimension 8 Code") THEN
        //    Particluars += ' VND' + ' : '+DimValue.Name+ ' , ';

        IF pEntry."BBG Cheque No." <> '' THEN
            Particluars += pEntry.FIELDCAPTION("BBG Cheque No.") + ' : ' + pEntry."BBG Cheque No." + ' , ';

        IF pEntry."BBG Cheque Date" <> 0D THEN
            Particluars += pEntry.FIELDCAPTION("BBG Cheque Date") + ' : ' + FORMAT(pEntry."BBG Cheque Date") + ' , ';

        Particluars := DELCHR(Particluars, '>', ' , ');
    end;


    procedure GetVLEParticulars(pEntry: Record "Vendor Ledger Entry") Particluars: Text
    var
        DimValue: Record "Dimension Value";
    begin
        GetGLSetup;
        Particluars := '';
        IF DimValue.GET(GLSetup."Global Dimension 1 Code", pEntry."Global Dimension 1 Code") THEN
            Particluars := 'CostCentre' + ' : ' + DimValue.Name + ' , ';
        IF DimValue.GET(GLSetup."Global Dimension 2 Code", pEntry."Global Dimension 2 Code") THEN
            Particluars += ' Contract' + ' : ' + DimValue.Code + ' , ';

        //IF pEntry."Shortcut Dimension 4 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 4 Code",pEntry."Shortcut Dimension 4 Code") THEN
        //    Particluars += ' DEPT' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 5 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 5 Code",pEntry."Shortcut Dimension 5 Code") THEN
        //    Particluars += ' EMP' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 6 Code" <>'' THEN
        // IF DimValue.GET(GLSetup."Shortcut Dimension 6 Code",pEntry."Shortcut Dimension 6 Code") THEN
        //    Particluars += ' FIN' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 7 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 7 Code",pEntry."Shortcut Dimension 7 Code") THEN
        //    Particluars += ' PLN' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 8 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 8 Code",pEntry."Shortcut Dimension 8 Code") THEN
        //     Particluars += ' VND' + ' : '+DimValue.Name+ ' , ';

        IF pEntry."Cheque No." <> '' THEN
            Particluars += pEntry.FIELDCAPTION("Cheque No.") + ' : ' + pEntry."Cheque No." + ' , ';

        IF pEntry."Cheque Date" <> 0D THEN
            Particluars += pEntry.FIELDCAPTION("Cheque Date") + ' : ' + FORMAT(pEntry."Cheque Date") + ' , ';

        Particluars := DELCHR(Particluars, '>', ' , ');
    end;


    procedure GetBLEParticulars(pEntry: Record "Bank Account Ledger Entry") Particluars: Text
    var
        DimValue: Record "Dimension Value";
    begin
        GetGLSetup;
        Particluars := '';
        IF DimValue.GET(GLSetup."Global Dimension 1 Code", pEntry."Global Dimension 1 Code") THEN
            Particluars := 'CostCentre' + ' : ' + DimValue.Name + ' , ';
        IF DimValue.GET(GLSetup."Global Dimension 2 Code", pEntry."Global Dimension 2 Code") THEN
            Particluars += ' Contract' + ' : ' + DimValue.Code + ' , ';


        //IF pEntry."Shortcut Dimension 4 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 4 Code",pEntry."Shortcut Dimension 4 Code") THEN
        //    Particluars += ' DEPT' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 5 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 5 Code",pEntry."Shortcut Dimension 5 Code") THEN
        //    Particluars += ' EMP' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 6 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 6 Code",pEntry."Shortcut Dimension 6 Code") THEN
        //    Particluars += ' FIN' + ' : '+DimValue.Name+ ' , ';

        //IF pEntry."Shortcut Dimension 7 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 7 Code",pEntry."Shortcut Dimension 7 Code") THEN
        //    Particluars += ' PLN' + ' : '+DimValue.Name+ ' , ';
        //
        //IF pEntry."Shortcut Dimension 8 Code" <>'' THEN
        //  IF DimValue.GET(GLSetup."Shortcut Dimension 8 Code",pEntry."Shortcut Dimension 8 Code") THEN
        //     Particluars += ' VND' + ' : '+DimValue.Name+ ' , ';

        IF pEntry."Cheque No." <> '' THEN
            Particluars += pEntry.FIELDCAPTION("Cheque No.") + ' : ' + pEntry."Cheque No." + ' , ';

        IF pEntry."Cheque Date" <> 0D THEN
            Particluars += pEntry.FIELDCAPTION("Cheque Date") + ' : ' + FORMAT(pEntry."Cheque Date") + ' , ';

        Particluars := DELCHR(Particluars, '>', ' , ');
    end;


    procedure GetPartyName(pCode: Code[20]): Text[50]
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        Party: Record Party;// "13730";
    begin
        IF Vendor.GET(pCode) THEN
            EXIT(Vendor.Name);
        IF Customer.GET(pCode) THEN
            EXIT(Customer.Name);
        IF Party.GET(pCode) THEN
            EXIT(Party.Name);
    end;


    procedure GetPAN(pCode: Code[20]): Code[20]
    var
        Vendor: Record Vendor;
        Customer: Record Customer;
        Party: Record Party;//"13730";
    begin
        IF Vendor.GET(pCode) THEN
            EXIT(Vendor."P.A.N. No.");
        IF Customer.GET(pCode) THEN
            EXIT(Customer."P.A.N. No.");
        IF Party.GET(pCode) THEN
            EXIT(Party."P.A.N. No.");
    end;


    procedure GetReasonDescription(pCode: Code[10]): Text[100]
    var
        ReasonCode: Record "Reason Code";
    begin
        IF ReasonCode.GET(pCode) THEN
            EXIT(LOWERCASE(ReasonCode.Description))
    end;


    procedure "-Inventory-"()
    begin
    end;


    procedure PreventNegInventory(pItemJnlLine: Record "Item Journal Line")
    var
        Item2: Record Item;
        ILE: Record "Item Ledger Entry";
        NetChange: Decimal;
    begin
        GetInvtSetup;
        //IF NOT InvtSetup."Allow Negative Inventory" THEN
        // EXIT;
        IF pItemJnlLine."Entry Type" IN [pItemJnlLine."Entry Type"::"Negative Adjmt.", pItemJnlLine."Entry Type"::Consumption, pItemJnlLine."Entry Type"::Sale, pItemJnlLine."Entry Type"::"Assembly Consumption"] THEN BEGIN
            Item2.GET(pItemJnlLine."Item No.");
            ILE.RESET;
            NetChange := 0;
            ILE.SETCURRENTKEY("Item No.", "Entry Type", "Posting Date", "Location Code");
            ILE.SETRANGE("Item No.", pItemJnlLine."Item No.");
            ILE.SETRANGE("Location Code", pItemJnlLine."Location Code");
            ILE.SETFILTER("Posting Date", '%1..%2', 0D, pItemJnlLine."Posting Date");
            IF ILE.FINDSET THEN
                REPEAT
                    NetChange += ILE.Quantity;
                UNTIL ILE.NEXT = 0;
            IF NetChange < pItemJnlLine.Quantity THEN
                ERROR(Text011, pItemJnlLine."Item No.", pItemJnlLine."Location Code", pItemJnlLine."Posting Date");

            ILE.RESET;
            NetChange := 0;
            ILE.SETCURRENTKEY("Item No.", "Entry Type", "Posting Date", "Location Code");
            ILE.SETRANGE("Item No.", pItemJnlLine."Item No.");
            ILE.SETRANGE("Location Code", pItemJnlLine."Location Code");
            ILE.SETFILTER("Posting Date", '%1..%2', 0D, pItemJnlLine."Posting Date");
            IF ILE.FINDSET THEN
                REPEAT
                    NetChange += ILE.Quantity;
                UNTIL ILE.NEXT = 0;
            IF NetChange < pItemJnlLine.Quantity THEN
                ERROR(Text011, pItemJnlLine."Item No.", pItemJnlLine."Location Code", WORKDATE);
        END;
    end;


    procedure InventoryValueZero(pCode: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        GetInvtSetup;
        IF Item.GET(pCode) AND Item."Inventory Value Zero" THEN
            EXIT(TRUE);
        EXIT(FALSE);
    end;


    procedure IsProductLine(pCode: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        IF pCode = '' THEN
            EXIT(FALSE);
        IF Item.GET(pCode) THEN
            EXIT(NOT Item.Blocked);

        EXIT(FALSE);
    end;


    procedure IsChargeableMetascreen(pCode: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        IF pCode = '' THEN
            EXIT(FALSE);
        IF Item.GET(pCode) AND (NOT Item.Blocked) THEN
            EXIT(TRUE);
        EXIT(FALSE);
    end;


    procedure Signature(): Text
    begin
        EXIT(Text100);
    end;


    procedure SrvTxStucture(pCode: Code[10]): Boolean
    var
    //StructureDetails: Record 13793;
    begin
        // StructureDetails.RESET;
        // StructureDetails.SETRANGE(Code, pCode);
        // StructureDetails.SETRANGE(Type, StructureDetails.Type::"Service Tax");
        // IF StructureDetails.FINDSET THEN
        //     EXIT(TRUE);
        // EXIT(FALSE)
    end;


    procedure ApprovalRequiredItemJournal(pItemJournalTemplate: Code[10]; pItemJournalBatch: Code[10]): Boolean
    var
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournalbatch: Record "Item Journal Batch";
    begin

        //IF (ItemJournalTemplate.GET(pItemJournalTemplate) AND ItemJournalbatch.GET(pItemJournalTemplate,pItemJournalBatch)) THEN
        //EXIT(ItemJournalbatch."Approval Required")
    end;


    procedure InsertTempGLEntry(GLEntry: Record "G/L Entry")
    begin
        //IF StoreToTemp THEN BEGIN
        TempGLEntry := GLEntry;
        IF NOT TempGLEntry.INSERT THEN BEGIN
            TempGLEntry.DELETEALL;
            TempGLEntry.INSERT;
        END;
        //END;
    end;


    procedure GetWindowID(): Guid
    var
        User: Record User;
    begin
        User.RESET;
        User.SETRANGE("User Name", USERID);
        IF User.FINDFIRST THEN
            EXIT(User."User Security ID");
    end;

    // [EventSubscriber(ObjectType::Codeunit, 1, 'OnAfterCompanyOpen', '', false, false)]
    // local procedure UserRespCenterSelection()
    // var
    //     UserSetup: Record 91;
    // begin
    //     IF NOT GUIALLOWED THEN
    //         EXIT;

    //     CODEUNIT.RUN(CODEUNIT::"Users - Create Super User");
    //     IF NOT UserSetup.GET(USERID) THEN BEGIN
    //         UserSetup.INIT;
    //         UserSetup."User ID" := USERID;
    //         UserSetup.INSERT;
    //     END;

    //     COMMIT;

    //     IF PAGE.RUNMODAL(PAGE::"User Resp. Center Selection") = ACTION::OK THEN;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 1, 'OnAfterCompanyOpen', '', false, false)]
    // local procedure GetLCBGToExpireList()
    // var
    //     DateCalc: Date;
    //     LCDetail: Record 16300;
    //     UserSetup: Record 91;
    // begin
    //     IF NOT GUIALLOWED THEN
    //         EXIT;

    //     DateCalc := CALCDATE('+30D', WORKDATE);
    //     LCDetail.RESET;
    //     IF UserSetup.GET(USERID) THEN BEGIN
    //         IF UserSetup."Flash LC/BG Message" THEN BEGIN
    //             LCDetail.SETFILTER("Expiry Date", '>%1&<=%2', TODAY, DateCalc);
    //             IF LCDetail.FIND('-') THEN
    //                 IF CONFIRM(Text022, TRUE, LCDetail.COUNT) THEN
    //                     PAGE.RUN(0, LCDetail);
    //         END;
    //     END;
    // end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertBank(RunTrigger: Boolean; var Rec: Record "Bank Account")
    begin
        //GetGLSetup;
        //Bank."Stale Cheque Stipulated Period" := GLSetup."Stale Cheque Stipulated Period";
    end;


    procedure IsSuperUser(UserName: Code[50]): Boolean
    var
        AccessControl: Record "Access Control";
    begin
        AccessControl.RESET;
        AccessControl.SETRANGE("User Security ID", USERSECURITYID);
        AccessControl.SETRANGE("Role ID", 'SUPER');
        AccessControl.SETFILTER("Company Name", '');
        EXIT(NOT AccessControl.ISEMPTY);
    end;
}

