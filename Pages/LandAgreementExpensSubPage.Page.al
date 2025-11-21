page 50163 "Land Agreement Expens SubPage"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Land Agreement Expense";
    SourceTableView = WHERE("JV Posted" = CONST(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field("Job Master Code"; Rec."Job Master Code")
                {

                    trigger OnValidate()
                    begin

                        ExistsOppDocument;
                    end;
                }
                field("Posting Date"; Rec."Posting Date")
                {

                    trigger OnValidate()
                    var
                        LandLeadOppHeader: Record "Land Lead/Opp Header";
                        LandAgreementHeader: Record "Land Agreement Header";
                    begin
                        CheckPostingDate;
                    end;
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field(Amount; Rec.Amount)
                {

                    trigger OnValidate()
                    begin
                        ExistsOppDocument;
                    end;
                }
                field("Account Type"; Rec."Account Type")
                {
                }
                field("Account No."; Rec."Account No.")
                {
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                }
                field("Bal. Account Name"; Rec."Bal. Account Name")
                {
                }
                field("TDS Nature of Deduction"; Rec."TDS Nature of Deduction")
                {
                }
                field("GST Group Code"; Rec."GST Group Code")
                {
                }
                field("GST Group Type"; Rec."GST Group Type")
                {
                }
                field("HSN/SAC Code"; Rec."HSN/SAC Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Land Document Dimension"; Rec."Land Document Dimension")
                {
                }
                field("Create Invoice"; Rec."Create Invoice")
                {
                    Visible = false;
                }
                field("Invoice No."; Rec."Invoice No.")
                {
                    Visible = false;
                }
                field("Invoice Created"; Rec."Invoice Created")
                {
                    Visible = false;
                }
                field("Invoice Created By"; Rec."Invoice Created By")
                {
                    Visible = false;
                }
                field("Invoice Creation Date"; Rec."Invoice Creation Date")
                {
                    Visible = false;
                }
                field("Amount Load on Inventory"; Rec."Amount Load on Inventory")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Item Revaluation")
            {
                Visible = false;

                trigger OnAction()
                var
                    TotalAmt: Decimal;
                begin
                    /*
                    IF CONFIRM('Do you want to Post Revaluation Journal Entry') THEN BEGIN
                      LandAgreementExpense.RESET;
                      LandAgreementExpense.SETRANGE("Document No.","Document No.");
                      LandAgreementExpense.SETRANGE("Create Invoice",TRUE);
                      LandAgreementExpense.SETRANGE("Amount Load on Inventory",FALSE);
                      LandAgreementExpense.SETRANGE("Amount Proces Load on Invt.",FALSE);
                      IF LandAgreementExpense.FINDFIRST THEN BEGIN
                        CLEAR(PurchPost);
                        PurchPost.PostRevaluationJournal("Document No.",TRUE,"Line No.");
                        COMMIT;
                        MESSAGE('Posting Done');
                      END ELSE
                        MESSAGE('Record not found');
                    END ELSE
                      MESSAGE('Nothing to Post');
                      */

                end;
            }
            action("Create / Post JV Entry")
            {

                trigger OnAction()
                var
                    LandAgreementExpense: Record "Land Agreement Expense";
                    GenJournalLine: Record "Gen. Journal Line" temporary;
                    GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
                    BBGSetups: Record "BBG Setups";
                    NoSeriesManagement: Codeunit NoSeriesManagement;
                    GenJournalBatch: Record "Gen. Journal Batch";
                    DocNo: Code[20];
                    DimensionSetEntry: Record "Dimension Set Entry" temporary;
                    GeneralLedgerSetup: Record "General Ledger Setup";
                    v_Dimension: Record Dimension;
                    DimMgt: Codeunit DimensionManagement;
                    LandLeadOppLine: Record "Land Lead/Opp Line";
                begin

                    IF CONFIRM('Do you want to create Entry') THEN BEGIN
                        CheckPostingDate;

                        BBGSetups.GET;
                        BBGSetups.TESTFIELD("Land Expense JV Temp Name");
                        BBGSetups.TESTFIELD("Land Expense JV Batch Name");
                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        Rec.TESTFIELD("Land Document Dimension");
                        GenJournalBatch.GET(BBGSetups."Land Expense JV Temp Name", BBGSetups."Land Expense JV Batch Name");
                        GenJournalBatch.TESTFIELD("No. Series");
                        LandAgreementExpense.RESET;
                        LandAgreementExpense.SETRANGE("Document Type", Rec."Document Type");
                        LandAgreementExpense.SETRANGE("Document No.", Rec."Document No.");
                        LandAgreementExpense.SETRANGE("Document Line No.", Rec."Document Line No.");
                        LandAgreementExpense.SETRANGE("JV Posted", FALSE);
                        IF LandAgreementExpense.FINDSET THEN
                            REPEAT
                                DocNo := NoSeriesManagement.GetNextNo(GenJournalBatch."No. Series", TODAY, TRUE);
                                GenJournalLine.RESET;
                                GenJournalLine.INIT;
                                GenJournalLine."Journal Template Name" := BBGSetups."Land Expense JV Temp Name";
                                GenJournalLine."Journal Batch Name" := BBGSetups."Land Expense JV Batch Name";
                                GenJournalLine."Document No." := DocNo;
                                GenJournalLine."Line No." := 10000;
                                GenJournalLine.INSERT;
                                GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Invoice);
                                GenJournalLine.VALIDATE("Posting Date", LandAgreementExpense."Posting Date");
                                GenJournalLine.VALIDATE("Document Date", LandAgreementExpense."Posting Date");
                                GenJournalLine.VALIDATE("Party Type", GenJournalLine."Party Type"::Vendor);
                                GenJournalLine.VALIDATE("Party Code", LandAgreementExpense."Account No.");
                                GenJournalLine.VALIDATE(Amount, -1 * LandAgreementExpense.Amount);
                                GenJournalLine.VALIDATE("Posting Type", GenJournalLine."Posting Type"::Running);
                                GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                                GenJournalLine.VALIDATE("Bal. Account No.", LandAgreementExpense."Bal. Account No.");
                                GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", LandAgreementExpense."Shortcut Dimension 1 Code");
                                GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", '100031');
                                GenJournalLine."Bill-to/Pay-to No." := LandAgreementExpense."Bal. Account No.";
                                GenJournalLine."Branch Code" := LandAgreementExpense."Shortcut Dimension 1 Code";
                                GenJournalLine."Created By" := USERID;
                                GenJournalLine."Sell-to/Buy-from No." := LandAgreementExpense."Bal. Account No.";
                                GenJournalLine."Source Code" := 'JOURNALV';
                                GenJournalLine."Source No." := LandAgreementExpense."Bal. Account No.";
                                GenJournalLine."Source Type" := GenJournalLine."Source Type"::Vendor;
                                GenJournalLine."Posting Type" := GenJournalLine."Posting Type"::Running;
                                GenJournalLine."External Document No." := DocNo;
                                GenJournalLine.VALIDATE("TDS Section Code", LandAgreementExpense."TDS Nature of Deduction");
                                GeneralLedgerSetup.RESET;
                                GeneralLedgerSetup.GET(GeneralLedgerSetup."Shortcut Dimension 5 Code");
                                IF GeneralLedgerSetup."Shortcut Dimension 5 Code" <> '' THEN
                                    IF v_Dimension.GET(GeneralLedgerSetup."Shortcut Dimension 5 Code") THEN;

                                DimensionValue.GET(GeneralLedgerSetup."Shortcut Dimension 1 Code", LandAgreementExpense."Shortcut Dimension 1 Code");
                                DimensionSetEntry.RESET;
                                DimensionSetEntry."Dimension Set ID" := 0;
                                DimensionSetEntry."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 1 Code";
                                DimensionSetEntry."Dimension Value Code" := LandAgreementExpense."Shortcut Dimension 1 Code";
                                DimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                                DimensionSetEntry."Dimension Name" := v_Dimension.Name;
                                DimensionSetEntry.INSERT;

                                DimensionValue.GET(GeneralLedgerSetup."Shortcut Dimension 2 Code", '100031');
                                DimensionSetEntry."Dimension Set ID" := 0;
                                DimensionSetEntry."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 2 Code";
                                DimensionSetEntry."Dimension Value Code" := '100031';
                                DimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                                DimensionSetEntry."Dimension Name" := v_Dimension.Name;
                                DimensionSetEntry.INSERT;


                                DimensionValue.GET(GeneralLedgerSetup."Shortcut Dimension 5 Code", LandAgreementExpense."Land Document Dimension");
                                DimensionSetEntry."Dimension Set ID" := 0;
                                DimensionSetEntry."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 5 Code";
                                DimensionSetEntry."Dimension Value Code" := LandAgreementExpense."Land Document Dimension";
                                DimensionSetEntry."Dimension Value ID" := DimensionValue."Dimension Value ID";
                                DimensionSetEntry."Dimension Name" := v_Dimension.Name;
                                DimensionSetEntry.INSERT;

                                GenJournalLine."Dimension Set ID" := DimMgt.GetDimensionSetID(DimensionSetEntry);
                                GenJournalLine.MODIFY;
                                GenJnlPostLine.RunWithCheck(GenJournalLine);
                                LandAgreementExpense."JV Posted" := TRUE;
                                LandAgreementExpense."Posted JV Document No." := DocNo;
                                LandAgreementExpense."Posting Date" := TODAY;
                                LandAgreementExpense.MODIFY;

                                IF LandAgreementExpense."JV Posted" THEN BEGIN
                                    LandLeadOppLine.RESET;
                                    LandLeadOppLine.SETRANGE("Document Type", Rec."Document Type");
                                    LandLeadOppLine.SETRANGE("Document No.", Rec."Document No.");
                                    LandLeadOppLine.SETRANGE("Line No.", Rec."Document Line No.");
                                    IF LandLeadOppLine.FINDFIRST THEN BEGIN
                                        LandLeadOppLine."Expense Posted" := TRUE;
                                        LandLeadOppLine.MODIFY;
                                    END;

                                END;

                                GenJournalLine.DELETE;
                            UNTIL LandAgreementExpense.NEXT = 0;
                        MESSAGE('Entry Posted');
                    END ELSE
                        MESSAGE('Nothing to Post');
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::JV;
    end;

    var
        PurchPost: Codeunit "Purch.-Post";
        PurchaseHeader: Record "Purchase Header";
        LandAgreementExpense: Record "Land Agreement Expense";
        OpportunityData: Boolean;
        DimensionValue: Record "Dimension Value";
        LandLeadLine: Record "Land Lead/Opp Line";
        LandLeadOppLine: Record "Land Lead/Opp Line";
        LandAgreementLine: Record "Land Agreement Line";
        LandLeadOppHeader: Record "Land Lead/Opp Header";
        LandAgreementHeader: Record "Land Agreement Header";
        UserSetup: Record "User Setup";

    local procedure ExistsOppDocument()
    begin
        IF Rec."Document Type" = Rec."Document Type"::Lead THEN BEGIN

            LandLeadLine.RESET;
            LandLeadLine.SETRANGE("Document Type", Rec."Document Type");
            LandLeadLine.SETRANGE("Document No.", Rec."Document No.");
            LandLeadLine.SETRANGE("Line No.", Rec."Document Line No.");
            LandLeadLine.SETFILTER("Vendor Code", '<>%1', '');
            IF LandLeadLine.FINDFIRST THEN BEGIN
                LandLeadOppHeader.RESET;
                LandLeadOppHeader.SETCURRENTKEY("Lead Document No.");
                LandLeadOppHeader.SETRANGE("Lead Document No.", LandLeadLine."Document No.");
                IF LandLeadOppHeader.FINDFIRST THEN BEGIN
                    LandLeadOppLine.RESET;
                    LandLeadOppLine.SETRANGE("Document Type", LandLeadOppLine."Document Type"::Opportunity);
                    LandLeadOppLine.SETRANGE("Document No.", LandLeadOppHeader."Document No.");
                    LandLeadOppLine.SETRANGE("Line No.", LandLeadLine."Line No.");
                    IF LandLeadOppLine.FINDFIRST THEN
                        ERROR('Opportunity Document already created');
                END;
            END;
        END ELSE
            IF Rec."Document Type" = Rec."Document Type"::Opportunity THEN BEGIN
                LandLeadLine.RESET;
                LandLeadLine.SETRANGE("Document Type", Rec."Document Type");
                LandLeadLine.SETRANGE("Document No.", Rec."Document No.");
                LandLeadLine.SETRANGE("Line No.", Rec."Document Line No.");
                LandLeadLine.SETFILTER("Vendor Code", '<>%1', '');
                IF LandLeadLine.FINDFIRST THEN BEGIN
                    LandAgreementHeader.RESET;
                    LandAgreementHeader.SETCURRENTKEY("Opportunity Document No.");
                    LandAgreementHeader.SETRANGE("Opportunity Document No.", LandLeadLine."Document No.");
                    IF LandAgreementHeader.FINDFIRST THEN BEGIN
                        LandAgreementLine.RESET;
                        LandAgreementLine.SETRANGE("Document No.", LandAgreementHeader."Document No.");
                        LandAgreementLine.SETRANGE("Line No.", LandLeadLine."Line No.");
                        IF LandAgreementLine.FINDFIRST THEN
                            ERROR('Agreement Document already created');
                    END;
                END;
            END;
    end;

    local procedure CheckPostingDate()
    begin

        UserSetup.RESET;
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."Allow Back Date Posting" THEN BEGIN
                IF Rec."Posting Date" > TODAY THEN
                    ERROR('Posting Date can not be greater than =' + FORMAT(TODAY));
            END ELSE
                IF Rec."Posting Date" <> TODAY THEN
                    ERROR('Posting Date can not be differ from Today Date =' + FORMAT(TODAY));
        END;


        IF Rec."Document Type" = Rec."Document Type"::Lead THEN BEGIN
            LandLeadOppHeader.RESET;
            LandLeadOppHeader.SETRANGE("Document Type", LandLeadOppHeader."Document Type"::Lead);
            LandLeadOppHeader.SETRANGE("Document No.", Rec."Document No.");
            IF LandLeadOppHeader.FINDFIRST THEN BEGIN
                IF Rec."Posting Date" < LandLeadOppHeader."Creation Date" THEN
                    ERROR('Posting date can not be less than = ' + FORMAT(LandLeadOppHeader."Creation Date"));
                IF Rec."Posting Date" > TODAY THEN
                    ERROR('Posting data can not be greater than = ' + FORMAT(TODAY));
            END;

        END ELSE
            IF Rec."Document Type" = Rec."Document Type"::Opportunity THEN BEGIN
                LandLeadOppHeader.RESET;
                LandLeadOppHeader.SETRANGE("Document Type", LandLeadOppHeader."Document Type"::Opportunity);
                LandLeadOppHeader.SETRANGE("Document No.", Rec."Document No.");
                IF LandLeadOppHeader.FINDFIRST THEN BEGIN
                    IF Rec."Posting Date" < LandLeadOppHeader."Creation Date" THEN
                        ERROR('Posting date can not be less than = ' + FORMAT(LandLeadOppHeader."Creation Date"));
                    IF Rec."Posting Date" > TODAY THEN
                        ERROR('Posting data can not be greater than = ' + FORMAT(TODAY));
                END;
            END ELSE
                IF Rec."Document Type" = Rec."Document Type"::Agreement THEN BEGIN
                    LandAgreementHeader.RESET;
                    LandAgreementHeader.SETRANGE("Document No.", Rec."Document No.");
                    IF LandAgreementHeader.FINDFIRST THEN BEGIN
                        IF Rec."Posting Date" < LandAgreementHeader."Creation Date" THEN
                            ERROR('Posting date can not be less than = ' + FORMAT(LandAgreementHeader."Creation Date"));
                        IF Rec."Posting Date" > TODAY THEN
                            ERROR('Posting data can not be greater than = ' + FORMAT(TODAY));
                    END;
                END;
    end;
}

