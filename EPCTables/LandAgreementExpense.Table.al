table 50058 "Land Agreement Expense"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Type of Document"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Description; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Description 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; Amount; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                LandAgreementExpense: Record "Land Agreement Expense";
                LandLeadOppHeader: Record "Land Lead/Opp Header";
                LandAgreementLine: Record "Land Agreement Line";
            begin
                IF Type = Type::JV THEN BEGIN
                    IF "Document Type" = "Document Type"::Lead THEN BEGIN
                        LandLeadOppHeader.RESET;
                        LandLeadOppHeader.SETRANGE("Document Type", LandLeadOppHeader."Document Type"::Opportunity);
                        LandLeadOppHeader.SETRANGE("Lead Document No.", "Document No.");
                        IF LandLeadOppHeader.FINDFIRST THEN BEGIN
                            LandAgreementExpense.RESET;
                            LandAgreementExpense.SETRANGE("Document Type", LandAgreementExpense."Document Type"::Opportunity);
                            LandAgreementExpense.SETRANGE("Document No.", LandLeadOppHeader."Document No.");
                            LandAgreementExpense.SETRANGE("Document Line No.", "Document Line No.");
                            IF LandAgreementExpense.FINDFIRST THEN
                                ERROR('Opportunity line exists');
                        END;
                    END;


                    LandLeadOppLine.RESET;
                    LandLeadOppLine.SETRANGE("Document Type", "Document Type");
                    LandLeadOppLine.SETRANGE("Document No.", "Document No.");
                    LandLeadOppLine.SETRANGE("Line No.", "Document Line No.");
                    IF LandLeadOppLine.FINDFIRST THEN BEGIN
                        "Shortcut Dimension 1 Code" := LandLeadOppLine."Shortcut Dimension 1 Code";
                        "Land Document Dimension" := LandLeadOppLine."Land Document Dimension";
                        "Account Type" := "Bal. Account Type"::Vendor;
                        //    "Account No." := LandLeadOppLine."Vendor Code";   //ALLEDK110723
                        //"Vendor Name" := LandLeadOppLine."Vendor Name";
                    END;

                    LandAgreementLine.RESET;
                    LandAgreementLine.SETRANGE("Document No.", "Document No.");
                    LandAgreementLine.SETRANGE("Line No.", "Document Line No.");
                    IF LandAgreementLine.FINDFIRST THEN BEGIN
                        "Shortcut Dimension 1 Code" := LandAgreementLine."Shortcut Dimension 1 Code";
                        "Land Document Dimension" := LandAgreementLine."Land Document Dimension";
                        "Account Type" := "Bal. Account Type"::Vendor;
                    END;

                END;
            end;
        }
        field(7; "Create Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Invoice Created", FALSE);

                IF CONFIRM('Do you want to create Entry') THEN BEGIN
                    IF "Create Invoice" THEN
                        CreateInvoice(Rec);
                END ELSE
                    "Create Invoice" := FALSE;
            end;
        }
        field(8; "Invoice Created"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9; "Invoice Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10; "Invoice Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "Posted Invoice Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                      Blocked = CONST(false))
            ELSE IF ("Account Type" = CONST(Customer)) Customer
            ELSE IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF ("Account Type" = CONST("IC Partner")) "IC Partner";
        }
        field(13; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                           Blocked = CONST(false))
            ELSE IF ("Bal. Account Type" = CONST(Customer)) Customer
            ELSE IF ("Bal. Account Type" = CONST(Vendor)) Vendor
            ELSE IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE IF ("Bal. Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF ("Bal. Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate()
            var
                CompanyInfo: Record "Company Information";
                Location: Record Location;
                GLAcc: Record "G/L Account";
                BankAccount: Record "Bank Account";
                Vend: Record Vendor;
            begin
                "Bal. Account Name" := '';
                IF "Bal. Account Type" = "Bal. Account Type"::"G/L Account" THEN BEGIN
                    IF GLAcc.GET("Bal. Account No.") THEN
                        "Bal. Account Name" := GLAcc.Name
                END ELSE IF "Bal. Account Type" = "Bal. Account Type"::"Bank Account" THEN BEGIN
                    IF BankAccount.GET("Bal. Account No.") THEN
                        "Bal. Account Name" := BankAccount.Name
                END;
            end;
        }
        field(14; "Vendor Name"; Text[50])
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(15; "Bal. Account Name"; Text[50])
        {
            Editable = false;
        }
        field(16; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate()
            var
                GSTComponent: Record "GST Component Distribution";// 16405;
            begin
            end;
        }
        field(18; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Pre-Invoice,Post-Invoice,JV';
            OptionMembers = " ","Pre-Invoice","Post-Invoice",JV;
        }
        field(19; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            DataClassification = ToBeClassified;
            TableRelation = "Payment Method";
        }
        field(20; "TDS Nature of Deduction"; Code[10])
        {
            Caption = 'TDS Nature of Deduction';
            DataClassification = ToBeClassified;
            TableRelation = "TDS Section"; //"TDS Nature of Deduction";

            trigger OnValidate()
            var
                Vend: Record Vendor;
            begin
            end;
        }
        field(21; "GST Group Code"; Code[20])
        {
            Caption = 'GST Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "GST Group";
        }
        field(22; "GST Group Type"; Option)
        {
            Caption = 'GST Group Type';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Goods,Service';
            OptionMembers = Goods,Service;
        }
        field(23; "HSN/SAC Code"; Code[8])
        {
            Caption = 'HSN/SAC Code';
            DataClassification = ToBeClassified;
            TableRelation = "HSN/SAC".Code WHERE("GST Group Code" = FIELD("GST Group Code"));
        }
        field(24; "Account Type"; Option)
        {
            Caption = 'Account Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnValidate()
            var
            //GSTComponent: Record 16405;
            begin
            end;
        }
        field(25; "Job Master Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Master";

            trigger OnValidate()
            var
                LandLeadOppLine: Record "Land Lead/Opp Line";
            begin
                TESTFIELD(Type);
                JobMaster.GET("Job Master Code");
                Description := JobMaster.Description;
                "Description 2" := JobMaster."Description 2";

                "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
                "Bal. Account No." := JobMaster."G/L Code";
                VALIDATE("Bal. Account No.", JobMaster."G/L Code");
            end;
        }
        field(26; "Item Revaluation Processed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(27; "Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(28; "Amount Load on Inventory"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(29; "Amount Proces Load on Invt."; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(30; "JV Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Posted JV Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(32; "JV Reversed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(33; "Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(34; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Lead,Opportunity,Agreement';
            OptionMembers = " ",Lead,Opportunity,Agreement;
        }
        field(35; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(36; "Land Document Dimension"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
        field(37; "Entry for FG Item"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(38; "FG Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No." WHERE("Inventory Posting Group" = FIELD("Inventory Posting group"));
        }
        field(39; "Inventory Posting group"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Document Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD("JV Posted", FALSE);
    end;

    trigger OnInsert()
    begin
        "Posting Date" := TODAY;
    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalTemplate: Record "Gen. Journal Template";
        UnitSetup: Record "Unit Setup";
        GenJournalLine_1: Record "Gen. Journal Line";
        LineNo: Integer;
        DocNo: Code[20];
        NoSeriesManagement: Codeunit NoSeriesManagement;
        UserSetup: Record "User Setup";
        EntryExists: Boolean;
        JobMaster: Record "Job Master";
        LandLeadOppLine: Record "Land Lead/Opp Line";

    local procedure CreateInvoice(LandAgreementExpense: Record "Land Agreement Expense")
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        V_PurchaseLine: Record "Purchase Line";
        LandAgreementHeader: Record "Land Agreement Header";
    begin
        LandAgreementHeader.GET(LandAgreementExpense."Document No.");
        LandAgreementHeader.TESTFIELD("Shortcut Dimension 1 Code");
        PurchaseHeader.INIT;
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
        PurchaseHeader."Sub Document Type" := PurchaseHeader."Sub Document Type"::" ";
        PurchaseHeader."Workflow Sub Document Type" := PurchaseHeader."Workflow Sub Document Type"::" ";
        PurchaseHeader."No." := '';
        PurchaseHeader.INSERT(TRUE);
        PurchaseHeader.Initiator := USERID;
        PurchaseHeader."Initiator User ID" := USERID;
        PurchaseHeader."User ID" := USERID;
        //PurchaseHeader."Land Document No." := "Document No.";
        PurchaseHeader.VALIDATE("Buy-from Vendor No.", LandAgreementExpense."Account No.");
        PurchaseHeader.VALIDATE("Posting Date", TODAY);
        PurchaseHeader.VALIDATE("Location Code", LandAgreementHeader."Shortcut Dimension 1 Code");
        PurchaseHeader.VALIDATE("Shortcut Dimension 1 Code", LandAgreementHeader."Shortcut Dimension 1 Code");
        PurchaseHeader."Job No." := LandAgreementHeader."Shortcut Dimension 1 Code";
        PurchaseHeader."Responsibility Center" := LandAgreementHeader."Shortcut Dimension 1 Code";
        //PurchaseHeader."Land Expense Invoice" := TRUE;
        PurchaseHeader."Assigned User ID" := USERID;
        //PurchaseHeader."Order Ref. No." := LandAgreementHeader."Document No.";
        //PurchaseHeader."Land Document No." := LandAgreementHeader."Document No.";
        PurchaseHeader.VALIDATE("Payment Method Code", "Payment Method Code");
        //PurchaseHeader.ValidateShortcutDimCode(5,LandAgreementHeader."Document No.");
        PurchaseHeader.MODIFY;


        V_PurchaseLine.RESET;
        V_PurchaseLine.SETRANGE("Document Type", V_PurchaseLine."Document Type"::Invoice);
        V_PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        IF V_PurchaseLine.FINDFIRST THEN
            EntryExists := TRUE;

        IF NOT EntryExists THEN
            PurchaseLine.INIT;
        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Invoice;
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := 10000;
        IF NOT EntryExists THEN
            PurchaseLine.INSERT;
        PurchaseLine.VALIDATE(Type, PurchaseLine.Type::"G/L Account");
        PurchaseLine.VALIDATE("No.", "Bal. Account No.");
        PurchaseLine.VALIDATE(Quantity, 1);
        PurchaseLine.VALIDATE("Direct Unit Cost", Amount);
        //PurchaseLine."Land Agreement No." := LandAgreementHeader."Document No.";
        //PurchaseLine."Land Expense Invoice" := TRUE;
        PurchaseLine.MODIFY;

        "Invoice No." := PurchaseHeader."No.";
        "Invoice Created" := TRUE;
        "Invoice Created By" := USERID;
        "Invoice Creation Date" := TODAY;
        MODIFY;
        MESSAGE('%1', 'Purchase invoice Created with No. -' + FORMAT(PurchaseHeader."No."));
    end;
}

