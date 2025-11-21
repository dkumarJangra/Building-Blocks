table 60667 "Land Lead/Opp Line"
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
        field(3; "Vendor Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor WHERE("BBG Land Master" = CONST(true));

            trigger OnValidate()
            var
                Vendor: Record Vendor;
                InventorySetup: Record "Inventory Setup";
            begin
                CheckStatus;
                "Creation Date" := TODAY;
                IF "Vendor Code" <> '' THEN BEGIN
                    IF Vendor.GET("Vendor Code") THEN
                        "Vendor Name" := Vendor.Name
                    ELSE
                        "Vendor Name" := '';

                    VendorBankAccount.RESET;
                    VendorBankAccount.SETRANGE(VendorBankAccount."Vendor No.", "Vendor Code");
                    IF VendorBankAccount.FINDFIRST THEN BEGIN
                        VendorBankAccount.TESTFIELD("Bank Account No.");
                        VendorBankAccount.TESTFIELD("Bank Branch No.");
                        VendorBankAccount.TESTFIELD(Name);
                    END ELSE
                        ERROR('Bank Account details not updated');

                    InventorySetup.GET;
                    InventorySetup.TESTFIELD("Global Dimension 1 Code");
                    "Shortcut Dimension 1 Code" := InventorySetup."Global Dimension 1 Code";
                    CreateDimensions;
                END;
            end;
        }
        field(4; "Vendor Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(5; "PO No."; Code[20])
        {
            CalcFormula = Lookup("Purchase Header"."No." WHERE("Document Type" = CONST(Order),
                                                              "Buy-from Vendor No." = FIELD("Vendor Code"),
                                                              "Land Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order),
                                                         "No." = FIELD("PO No."));
        }
        field(6; "PO Date"; Date)
        {
            CalcFormula = Lookup("Purchase Header"."Posting Date" WHERE("Document Type" = CONST(Order),
                                                                         "No." = FIELD("PO No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "PO Value"; Decimal)
        {
            CalcFormula = Sum("Purchase Line".Amount WHERE("Document Type" = CONST(Order),
                                                            "Document No." = FIELD("PO No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(9; "Payment Amount"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("Vendor Code")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(10; "Unit of Measure Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure".Code;

            trigger OnValidate()
            begin
                CheckStatus;
                UpdateValues;
            end;
        }
        field(11; "Land Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Agriculture,Non-Agriculture';
            OptionMembers = " ",Agriculture,"Non-Agriculture";

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(12; "Co-Ordinates"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(13; "Area"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Unit of Measure Code");
                CheckStatus;
                UpdateValues;
                "Land Value" := "Unit Price" * Area;
            end;
        }
        field(14; "Nature of Deed"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(15; "Transaction Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Outright Purchase';
            OptionMembers = " ","Outright Purchase";

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(16; "Sale Deed No."; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(18; "Inspected By"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(19; "Inspected Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(20; "Assigned To"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(21; "Considration Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(22; "Stamp Duty Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(23; "Registration Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(24; "Other Charges"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(25; "Amount Alloted to Agent"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(26; "Land Value"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(27; Note; Text[100])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(28; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Lead,Opportunity';
            OptionMembers = " ",Lead,Opportunity;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(50001; "Lead Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Cancelled,Completed,Under-Process';
            OptionMembers = " ",Cancelled,Completed,"Under-Process";
        }
        field(50002; "Line Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Forfeit';
            OptionMembers = Open,Forfeit;
        }
        field(50003; "Modify By"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Modify Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Area in Acres"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50006; "Area in Guntas"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50007; "Area in Ankanan"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50008; "Area in Cents"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50009; "Area in Sq. Yard"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Survey Nos."; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(50011; Mutation; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
            end;
        }
        field(50012; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStatus;
                "Land Value" := "Unit Price" * Area;
            end;
        }
        field(50013; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50014; "Land Document Dimension"; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
        field(50015; "Total Expense to Vendor"; Decimal)
        {
            CalcFormula = Sum("Land Agreement Expense".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                                     "Document No." = FIELD("Document No."),
                                                                     "Document Line No." = FIELD("Line No."),
                                                                     "JV Posted" = CONST(true),
                                                                     "JV Reversed" = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50016; "Lead Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50017; "Lead Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50018; "Date of Registration"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Pending From USER ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50040; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending For Approval,Approved,Rejected';
            OptionMembers = Open,"Pending For Approval",Approved,Rejected;
        }
        field(50041; "Quantity In SQYD"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50042; "Expense Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50043; "Quantity Transfered on Opp"; Decimal)
        {
            CalcFormula = Sum("Land Lead/Opp Line".Area WHERE("Document Type" = FILTER(Opportunity),
                                                               "Lead Document No." = FIELD("Document No."),
                                                               "Lead Document Line No." = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50044; "Quantity Transfered on Agremnt"; Decimal)
        {
            CalcFormula = Sum("Land Agreement Line".Area WHERE("Opportunity Document No." = FIELD("Document No."),
                                                                "Opportunity Document Line No." = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50045; "Total Payment to Vendor"; Decimal)
        {
            CalcFormula = Sum("Land Vendor Receipt Payment".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                                          "Document No." = FIELD("Document No."),
                                                                          "Document Line No." = FIELD("Line No."),
                                                                          Posted = CONST(true)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Land Value";
        }
        key(Key2; "Document No.", "Vendor Code", "Line No.")
        {
            SumIndexFields = "Land Value";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //TESTFIELD(Status,Status::Open);
        IF "Lead Status" <> "Lead Status"::" " THEN
            ERROR('Lead Status for line no. ' + FORMAT("Line No.") + ' should not be ' + FORMAT("Lead Status"));
        LandLeaseOppHeader.RESET;
        LandLeaseOppHeader.GET("Document Type", "Document No.");
        LandLeaseOppHeader.TESTFIELD("Approval Status", LandLeaseOppHeader."Approval Status"::Open);
    end;

    trigger OnModify()
    begin
        //TESTFIELD("Approval Status","Approval Status"::Open);

        "Modify By" := USERID;
        "Modify Date Time" := CURRENTDATETIME;
    end;

    var
        LandLeaseOppHeader: Record "Land Lead/Opp Header";
        BBGSetups: Record "BBG Setups";
        DivAcres: Decimal;
        DivGunta: Decimal;
        DivCent: Decimal;
        DivAnakanan: Decimal;
        ModAcres: Decimal;
        ModGunta: Decimal;
        ModCent: Decimal;
        ModAnakanan: Decimal;
        VendorBankAccount: Record "Vendor Bank Account";
        InventorySetup: Record "Inventory Setup";
        LandPPRDocumentList_1: Record "Land R-1 PPR Document Lis_1";
        v_LandPPRDocumentList_1: Record "Land R-1 PPR Document Lis_1";
        LandPPRDocumentList: Record "Land R-2 PPR  Document List";
        v_LandPPRDocumentList: Record "Land R-2 PPR  Document List";
        LandLeadOppHeader: Record "Land Lead/Opp Header";
        OldDocument: Record Document;
        RecDocument: Record Document;
        DocumentSetup: Record "Document Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        PostCode: Record "Post Code";
        LandOldDocument: Record "Land Document Attachment";
        LandDocument: Record "Land Document Attachment";
        LandVendorReceiptPayment: Record "Land Vendor Receipt Payment";
        OppLandVendorReceiptPayment: Record "Land Vendor Receipt Payment";

    local procedure UpdateValues()
    var
        LandLeadOppHeader: Record "Land Lead/Opp Header";
        StatewiseMeasurement: Record "State wise Measurement";
    begin
        BBGSetups.GET;
        LandLeadOppHeader.RESET;
        IF LandLeadOppHeader.GET("Document Type", "Document No.") THEN BEGIN
            StatewiseMeasurement.RESET;
            IF StatewiseMeasurement.GET(LandLeadOppHeader."State Code") THEN;
        END;

        IF "Unit of Measure Code" = 'ACRES' THEN BEGIN
            "Area in Acres" := Area;
            "Area in Guntas" := 0;
            "Area in Ankanan" := 0;
            "Area in Cents" := 0;
            "Area in Sq. Yard" := 0;
            "Quantity In SQYD" := 0;
            "Quantity In SQYD" := Area * StatewiseMeasurement.Acres;
        END ELSE IF "Unit of Measure Code" = 'GUNTAS' THEN BEGIN
            "Area in Acres" := Area DIV BBGSetups.Guntas;
            ModGunta := Area MOD BBGSetups.Guntas;
            "Area in Guntas" := ModGunta;
            "Area in Ankanan" := 0;
            "Area in Cents" := 0;
            "Area in Sq. Yard" := 0;
            "Quantity In SQYD" := 0;
            "Quantity In SQYD" := Area * StatewiseMeasurement.Guntas;
        END ELSE IF "Unit of Measure Code" = 'CENTS' THEN BEGIN
            "Area in Acres" := Area DIV BBGSetups.Cents;
            ModGunta := Area MOD BBGSetups.Cents;
            "Area in Guntas" := ModGunta DIV BBGSetups.Guntas;
            ModCent := ModGunta MOD BBGSetups.Guntas;
            "Area in Cents" := ModCent;
            "Area in Ankanan" := 0;
            "Area in Sq. Yard" := 0;
            "Quantity In SQYD" := 0;
            "Quantity In SQYD" := Area * StatewiseMeasurement.Cents;
        END ELSE IF "Unit of Measure Code" = 'ANKANAN' THEN BEGIN
            "Area in Acres" := Area DIV BBGSetups.Ankanan;
            ModGunta := Area DIV BBGSetups.Ankanan;
            "Area in Guntas" := ModGunta DIV BBGSetups.Guntas;
            ModCent := ModGunta MOD BBGSetups.Guntas;
            "Area in Ankanan" := 0;
            "Area in Cents" := ModCent;
            "Area in Sq. Yard" := 0;
            "Quantity In SQYD" := 0;
        END ELSE IF "Unit of Measure Code" = 'SQYD' THEN BEGIN
            "Area in Acres" := 0;//Area DIV BBGSetups."Sq. Yard";
                                 //ModGunta := Area MOD BBGSetups."Sq. Yard";
            IF Area <> 0 THEN
                "Area in Guntas" := (Area / 121);
            "Area in Ankanan" := 0;
            "Area in Cents" := 0;
            "Area in Sq. Yard" := 0;
            "Quantity In SQYD" := 0;
            "Quantity In SQYD" := Area;
        END;
    end;

    local procedure CreateDimensions()
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        BBGSetups.GET;
        GeneralLedgerSetup.GET;

        BBGSetups.TESTFIELD("Land Expense Dim. No.Series");
        IF "Land Document Dimension" = '' THEN
            "Land Document Dimension" := NoSeriesManagement.GetNextNo(BBGSetups."Land Expense Dim. No.Series", TODAY, TRUE);

        GeneralLedgerSetup.TESTFIELD("Shortcut Dimension 5 Code");

        DimensionValue.RESET;
        IF DimensionValue.GET(GeneralLedgerSetup."Shortcut Dimension 5 Code", "Land Document Dimension") THEN BEGIN
            DimensionValue.Name := FORMAT("Document No.") + ' ' + FORMAT("Line No.") + ' ' + "Vendor Code";
            DimensionValue.MODIFY;
        END ELSE BEGIN
            DimensionValue.RESET;
            DimensionValue.INIT;
            DimensionValue."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 5 Code";
            DimensionValue.Code := "Land Document Dimension";
            DimensionValue.Name := FORMAT("Document No.") + ' ' + FORMAT("Line No.") + ' ' + "Vendor Code";
            DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
            DimensionValue."Global Dimension No." := 5;
            DimensionValue.INSERT;
        END;
    end;

    local procedure CheckStatus()
    begin
        LandLeaseOppHeader.RESET;
        LandLeaseOppHeader.GET("Document Type", "Document No.");
        LandLeaseOppHeader.TESTFIELD("Approval Status", LandLeaseOppHeader."Approval Status"::Open);
    end;


    procedure TransferLeadToOpportunity(P_LandLeadOppLine: Record "Land Lead/Opp Line")
    var
        LandLeadOppHeader: Record "Land Lead/Opp Header";
        LandLeadOppLine: Record "Land Lead/Opp Line";
        LandOpprotunityHeader: Record "Land Lead/Opp Header";
        LandOpprotunityLine: Record "Land Lead/Opp Line";
        RecDocument: Record Document;
        NewDocument: Record Document;
        LandAgreementExpense: Record "Land Agreement Expense";
        OpportunityLandAgreementExpense: Record "Land Agreement Expense";
        LastLandOpprotunityLine: Record "Land Lead/Opp Line";
        LandOppFind: Boolean;
        LandOldDocument: Record "Land Document Attachment";
        LandDocument: Record "Land Document Attachment";
    begin
        IF CONFIRM('Do you want to Transfer the Line') THEN BEGIN
            LandLeadOppHeader.RESET;
            LandLeadOppHeader.SETRANGE("Document Type", LandLeadOppHeader."Document Type"::Opportunity);
            LandLeadOppHeader.SETRANGE("Lead Document No.", P_LandLeadOppLine."Document No.");
            IF LandLeadOppHeader.FINDFIRST THEN BEGIN
                LandLeadOppLine.RESET;
                LandLeadOppLine.SETRANGE("Document Type", P_LandLeadOppLine."Document Type");
                LandLeadOppLine.SETRANGE("Document No.", P_LandLeadOppLine."Document No.");
                LandLeadOppLine.SETRANGE("Line No.", P_LandLeadOppLine."Line No.");
                LandLeadOppLine.SETRANGE("Lead Status", LandLeadOppLine."Lead Status"::Completed);
                LandLeadOppLine.SETRANGE("Line Status", LandLeadOppLine."Line Status"::Open);
                LandLeadOppLine.SETRANGE("Approval Status", LandLeadOppLine."Approval Status"::Approved);
                IF LandLeadOppLine.FINDSET THEN
                    REPEAT
                        LandOpprotunityLine.RESET;
                        LandOpprotunityLine.SETRANGE("Document Type", LandOpprotunityLine."Document Type"::Opportunity);
                        LandOpprotunityLine.SETRANGE("Document No.", LandLeadOppHeader."Document No.");
                        LandOpprotunityLine.SETRANGE("Line No.", LandLeadOppLine."Line No.");
                        //LandOpprotunityLine.SETRANGE("Lead Document Line No.",LandLeadOppLine."Line No.");
                        IF NOT LandOpprotunityLine.FINDFIRST THEN BEGIN
                            LastLandOpprotunityLine.RESET;
                            LastLandOpprotunityLine.SETRANGE("Document Type", LastLandOpprotunityLine."Document Type"::Opportunity);
                            LastLandOpprotunityLine.SETRANGE("Document No.", LandLeadOppHeader."Document No.");
                            IF LastLandOpprotunityLine.FINDLAST THEN;
                            LandOpprotunityLine.INIT;
                            LandOpprotunityLine.TRANSFERFIELDS(LandLeadOppLine);
                            LandOpprotunityLine."Document Type" := LandLeadOppHeader."Document Type";
                            LandOpprotunityLine."Document No." := LandLeadOppHeader."Document No.";
                            //LandOpprotunityLine."Line No." := LastLandOpprotunityLine."Line No." + 10000;
                            LandOpprotunityLine."Lead Status" := LandOpprotunityLine."Lead Status"::" ";
                            LandOpprotunityLine."Line Status" := LandOpprotunityLine."Line Status"::Open;
                            LandOpprotunityLine."Lead Document No." := LandLeadOppLine."Document No.";
                            LandOpprotunityLine."Lead Document Line No." := LandLeadOppLine."Line No.";
                            LandOpprotunityLine."Approval Status" := LandOpprotunityLine."Approval Status"::Open;
                            LandOpprotunityLine.INSERT;

                            LandAgreementExpense.RESET;
                            LandAgreementExpense.SETRANGE("Document Type", LandAgreementExpense."Document Type"::Lead);
                            LandAgreementExpense.SETRANGE("Document No.", "Document No.");
                            LandAgreementExpense.SETRANGE("JV Posted", TRUE);
                            LandAgreementExpense.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                            IF LandAgreementExpense.FINDSET THEN
                                REPEAT
                                    OpportunityLandAgreementExpense.RESET;
                                    IF NOT OpportunityLandAgreementExpense.GET(OpportunityLandAgreementExpense."Document Type"::Opportunity, LandLeadOppHeader."Document No.", LandAgreementExpense."Document Line No.", LandAgreementExpense."Line No.") THEN BEGIN
                                        OpportunityLandAgreementExpense.INIT;
                                        OpportunityLandAgreementExpense.TRANSFERFIELDS(LandAgreementExpense);
                                        OpportunityLandAgreementExpense."Document Type" := OpportunityLandAgreementExpense."Document Type"::Opportunity;
                                        OpportunityLandAgreementExpense."Document No." := LandLeadOppHeader."Document No.";
                                        OpportunityLandAgreementExpense.INSERT;
                                    END;
                                UNTIL LandAgreementExpense.NEXT = 0;

                            //-----151123 Vendor Payment / Refund Start
                            LandVendorReceiptPayment.RESET;
                            LandVendorReceiptPayment.SETRANGE("Document Type", LandVendorReceiptPayment."Document Type"::Lead);
                            LandVendorReceiptPayment.SETRANGE("Document No.", "Document No.");
                            LandVendorReceiptPayment.SETRANGE(Posted, TRUE);
                            LandVendorReceiptPayment.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                            IF LandVendorReceiptPayment.FINDSET THEN
                                REPEAT
                                    OppLandVendorReceiptPayment.RESET;
                                    IF NOT OppLandVendorReceiptPayment.GET(OppLandVendorReceiptPayment."Document Type"::Opportunity, LandLeadOppHeader."Document No.", LandVendorReceiptPayment."Document Line No.", LandVendorReceiptPayment."Line No.") THEN BEGIN
                                        OppLandVendorReceiptPayment.INIT;
                                        OppLandVendorReceiptPayment.TRANSFERFIELDS(LandVendorReceiptPayment);
                                        OppLandVendorReceiptPayment."Document Type" := OppLandVendorReceiptPayment."Document Type"::Opportunity;
                                        OppLandVendorReceiptPayment."Document No." := LandLeadOppHeader."Document No.";
                                        OppLandVendorReceiptPayment.INSERT;
                                    END;
                                UNTIL LandVendorReceiptPayment.NEXT = 0;
                            //-----151123 Vendor Payment / Refund END





                            //-----------Insert R-1 Check list START
                            v_LandPPRDocumentList.RESET;
                            v_LandPPRDocumentList.SETRANGE("Document No.", LandLeadOppHeader."Document No.");
                            v_LandPPRDocumentList.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                            IF NOT v_LandPPRDocumentList.FINDFIRST THEN BEGIN
                                LandPPRDocumentList.RESET;
                                LandPPRDocumentList.SETRANGE("Document No.", P_LandLeadOppLine."Document No.");
                                LandPPRDocumentList.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                                IF LandPPRDocumentList.FINDSET THEN BEGIN
                                    v_LandPPRDocumentList.INIT;
                                    v_LandPPRDocumentList.TRANSFERFIELDS(LandPPRDocumentList);
                                    v_LandPPRDocumentList."Document No." := LandLeadOppHeader."Document No.";
                                    v_LandPPRDocumentList.INSERT;
                                END;
                            END;

                            //-----------Insert R-2 Check list END

                            //--------Insert R-1 Check list START
                            v_LandPPRDocumentList_1.RESET;
                            v_LandPPRDocumentList_1.SETRANGE("Document No.", LandLeadOppHeader."Document No.");
                            v_LandPPRDocumentList_1.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                            IF NOT v_LandPPRDocumentList_1.FINDFIRST THEN BEGIN
                                LandPPRDocumentList_1.RESET;
                                LandPPRDocumentList_1.SETRANGE("Document No.", "Document No.");
                                LandPPRDocumentList_1.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                                IF LandPPRDocumentList_1.FINDSET THEN BEGIN
                                    v_LandPPRDocumentList_1.INIT;
                                    v_LandPPRDocumentList_1.TRANSFERFIELDS(LandPPRDocumentList_1);
                                    v_LandPPRDocumentList_1."Document No." := LandLeadOppHeader."Document No.";
                                    v_LandPPRDocumentList_1.INSERT;
                                END;
                            END;
                            //--------Insert R-1 Check list END


                            DocumentSetup.GET;
                            LandOldDocument.RESET;
                            LandOldDocument.SETRANGE("Document No.", "Document No.");
                            LandOldDocument.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                            IF LandOldDocument.FINDSET THEN
                                REPEAT
                                    LandDocument.RESET;
                                    LandDocument.INIT;
                                    LandDocument."Document Type" := LandDocument."Document Type"::Document;
                                    LandDocument."No." := NoSeriesManagement.GetNextNo(DocumentSetup."Document Nos.", TODAY, TRUE);
                                    LandDocument."Document No." := LandLeadOppHeader."Document No.";
                                    LandDocument."Document Line No." := LandOldDocument."Document Line No.";
                                    LandDocument."Line No." := LandOldDocument."Line No.";
                                    LandDocument."Table No." := LandOldDocument."Table No.";
                                    LandDocument."Reference No. 1" := LandOldDocument."Reference No. 1";
                                    LandDocument."Reference No. 2" := LandOldDocument."Reference No. 2";
                                    LandDocument."Reference No. 3" := LandOldDocument."Reference No. 3";
                                    LandDocument."Template Name" := LandOldDocument."Template Name";
                                    LandDocument.Description := LandOldDocument.Description;
                                    LandDocument.Content := LandOldDocument.Content;
                                    LandDocument."File Extension" := LandOldDocument."File Extension";
                                    LandDocument."In Use By" := LandOldDocument."In Use By";
                                    LandDocument.Special := LandOldDocument.Special;
                                    LandDocument."Document Import Date" := LandOldDocument."Document Import Date";
                                    LandDocument.Category := LandOldDocument.Category;
                                    LandDocument.Indexed := LandOldDocument.Indexed;
                                    LandDocument.GUID := LandOldDocument.GUID;
                                    LandDocument."Line No." := LandOldDocument."Line No.";
                                    LandDocument."Import Path" := LandOldDocument."Import Path";
                                    LandDocument."Description 2" := LandOldDocument."Description 2";
                                    LandDocument."Document Import By" := LandOldDocument."Document Import By";
                                    LandDocument."Document Import Time" := LandOldDocument."Document Import Time";
                                    LandDocument."Table Name" := LandOldDocument."Table Name";

                                    LandDocument.INSERT;
                                UNTIL LandOldDocument.NEXT = 0;
                        END;
                    UNTIL LandLeadOppLine.NEXT = 0;
            END;
        END;
    end;


    procedure TransferOpportunityToAgreement(P_LandLeadOppLine: Record "Land Lead/Opp Line")
    var
        LandAgreementHeader: Record "Land Agreement Header";
        LandLeadOppLine: Record "Land Lead/Opp Line";
        LandOpprotunityHeader: Record "Land Lead/Opp Header";
        LandAgreementLine: Record "Land Agreement Line";
        RecDocument: Record Document;
        NewDocument: Record Document;
        LandAgreementExpense: Record "Land Agreement Expense";
        OpportunityLandAgreementExpense: Record "Land Agreement Expense";
        LastLandAgreementLine: Record "Land Agreement Line";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    begin
        IF CONFIRM('Do you want to Transfer Line') THEN BEGIN
            LandAgreementHeader.RESET;
            LandAgreementHeader.SETRANGE("Opportunity Document No.", P_LandLeadOppLine."Document No.");
            IF LandAgreementHeader.FINDFIRST THEN BEGIN
                LandLeadOppLine.RESET;
                LandLeadOppLine.SETRANGE("Document Type", P_LandLeadOppLine."Document Type");
                LandLeadOppLine.SETRANGE("Document No.", P_LandLeadOppLine."Document No.");
                LandLeadOppLine.SETRANGE("Line No.", P_LandLeadOppLine."Line No.");
                LandLeadOppLine.SETRANGE("Lead Status", LandLeadOppLine."Lead Status"::Completed);
                LandLeadOppLine.SETRANGE("Line Status", LandLeadOppLine."Line Status"::Open);
                LandLeadOppLine.SETRANGE("Approval Status", LandLeadOppLine."Approval Status"::Approved);
                IF LandLeadOppLine.FINDSET THEN
                    REPEAT
                        LandAgreementLine.RESET;
                        LandAgreementLine.SETRANGE("Document No.", LandAgreementHeader."Document No.");
                        LandAgreementLine.SETRANGE("Line No.", LandLeadOppLine."Line No.");
                        IF NOT LandAgreementLine.FINDFIRST THEN BEGIN
                            LandAgreementLine.INIT;
                            LandAgreementLine."Document No." := LandAgreementHeader."Document No.";
                            LandAgreementLine."Line No." := LandLeadOppLine."Line No.";   //LastLandAgreementLine."Line No." + 10000;
                            LandAgreementLine."Vendor Code" := LandLeadOppLine."Vendor Code";
                            LandAgreementLine."Vendor Name" := LandLeadOppLine."Vendor Name";
                            LandAgreementLine."Creation Date" := TODAY;
                            LandAgreementLine."Unit of Measure Code" := LandLeadOppLine."Unit of Measure Code";
                            LandAgreementLine."Land Type" := LandLeadOppLine."Land Type";
                            LandAgreementLine."Co-Ordinates" := LandLeadOppLine."Co-Ordinates";
                            LandAgreementLine.Area := LandLeadOppLine.Area;
                            LandAgreementLine."Nature of Deed" := LandLeadOppLine."Nature of Deed";
                            LandAgreementLine."Transaction Type" := LandLeadOppLine."Transaction Type";
                            LandAgreementLine."Sale Deed No." := LandLeadOppLine."Sale Deed No.";
                            LandAgreementLine."Land Value" := LandLeadOppLine."Land Value";
                            LandAgreementLine."Area in Acres" := LandLeadOppLine."Area in Acres";
                            LandAgreementLine."Area in Cents" := LandLeadOppLine."Area in Cents";
                            LandAgreementLine."Area in Ankanan" := LandLeadOppLine."Area in Ankanan";
                            LandAgreementLine."Area in Guntas" := LandLeadOppLine."Area in Guntas";
                            LandAgreementLine."Area in Sq. Yard" := LandLeadOppLine."Area in Sq. Yard";
                            LandAgreementLine."Opportunity Document No." := LandLeadOppLine."Document No.";
                            LandAgreementLine."Opportunity Document Line No." := LandLeadOppLine."Line No.";
                            LandAgreementLine."Quantity in SQYD" := LandLeadOppLine."Quantity In SQYD";
                            LandAgreementLine."Date of Registration" := LandLeadOppLine."Date of Registration";
                            LandAgreementLine."Approval Status" := LandAgreementLine."Approval Status"::Open;
                            LandAgreementLine."Land Document Dimension" := LandLeadOppLine."Land Document Dimension";
                            LandAgreementLine."Pending From USER ID" := '';
                            LandAgreementLine."Unit Price" := LandLeadOppLine."Unit Price";
                            LandAgreementLine.INSERT;

                            LandAgreementExpense.RESET;
                            LandAgreementExpense.SETRANGE("Document Type", LandAgreementExpense."Document Type"::Opportunity);
                            LandAgreementExpense.SETRANGE("Document No.", "Document No.");
                            LandAgreementExpense.SETRANGE("JV Posted", TRUE);
                            LandAgreementExpense.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                            IF LandAgreementExpense.FINDSET THEN
                                REPEAT
                                    OpportunityLandAgreementExpense.RESET;
                                    IF NOT OpportunityLandAgreementExpense.GET(OpportunityLandAgreementExpense."Document Type"::Agreement, LandAgreementHeader."Document No.", LandAgreementExpense."Document Line No.", LandAgreementExpense."Line No.") THEN BEGIN
                                        OpportunityLandAgreementExpense.INIT;
                                        OpportunityLandAgreementExpense.TRANSFERFIELDS(LandAgreementExpense);
                                        OpportunityLandAgreementExpense."Document Type" := OpportunityLandAgreementExpense."Document Type"::Agreement;
                                        OpportunityLandAgreementExpense."Document No." := LandAgreementHeader."Document No.";
                                        OpportunityLandAgreementExpense.INSERT;
                                    END;
                                UNTIL LandAgreementExpense.NEXT = 0;

                            //-----151123 Vendor Payment / Refund Start
                            LandVendorReceiptPayment.RESET;
                            LandVendorReceiptPayment.SETRANGE("Document Type", LandVendorReceiptPayment."Document Type"::Opportunity);
                            LandVendorReceiptPayment.SETRANGE("Document No.", "Document No.");
                            LandVendorReceiptPayment.SETRANGE(Posted, TRUE);
                            LandVendorReceiptPayment.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                            IF LandVendorReceiptPayment.FINDSET THEN
                                REPEAT
                                    OppLandVendorReceiptPayment.RESET;
                                    IF NOT OppLandVendorReceiptPayment.GET(OppLandVendorReceiptPayment."Document Type"::Agreement, LandAgreementHeader."Document No.", LandVendorReceiptPayment."Document Line No.", LandVendorReceiptPayment."Line No.") THEN BEGIN
                                        OppLandVendorReceiptPayment.INIT;
                                        OppLandVendorReceiptPayment.TRANSFERFIELDS(LandVendorReceiptPayment);
                                        OppLandVendorReceiptPayment."Document Type" := OppLandVendorReceiptPayment."Document Type"::Agreement;
                                        OppLandVendorReceiptPayment."Document No." := LandAgreementHeader."Document No.";
                                        OppLandVendorReceiptPayment.INSERT;
                                    END;
                                UNTIL LandVendorReceiptPayment.NEXT = 0;
                            //-----151123 Vendor Payment / Refund END




                            //-----------Insert R-1 Check list START
                            v_LandPPRDocumentList.RESET;
                            v_LandPPRDocumentList.SETRANGE("Document No.", LandAgreementHeader."Document No.");
                            v_LandPPRDocumentList.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                            IF NOT v_LandPPRDocumentList.FINDFIRST THEN BEGIN
                                LandPPRDocumentList.RESET;
                                LandPPRDocumentList.SETRANGE("Document No.", P_LandLeadOppLine."Document No.");
                                LandPPRDocumentList.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                                IF LandPPRDocumentList.FINDSET THEN BEGIN
                                    v_LandPPRDocumentList.INIT;
                                    v_LandPPRDocumentList.TRANSFERFIELDS(LandPPRDocumentList);
                                    v_LandPPRDocumentList."Document No." := LandAgreementHeader."Document No.";
                                    v_LandPPRDocumentList.INSERT;
                                END;
                            END;

                            //-----------Insert R-2 Check list END

                            //--------Insert R-1 Check list START
                            v_LandPPRDocumentList_1.RESET;
                            v_LandPPRDocumentList_1.SETRANGE("Document No.", LandAgreementHeader."Document No.");
                            v_LandPPRDocumentList_1.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                            IF NOT v_LandPPRDocumentList_1.FINDFIRST THEN BEGIN
                                LandPPRDocumentList_1.RESET;
                                LandPPRDocumentList_1.SETRANGE("Document No.", P_LandLeadOppLine."Document No.");
                                LandPPRDocumentList_1.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                                IF LandPPRDocumentList_1.FINDSET THEN BEGIN
                                    v_LandPPRDocumentList_1.INIT;
                                    v_LandPPRDocumentList_1.TRANSFERFIELDS(LandPPRDocumentList_1);
                                    v_LandPPRDocumentList_1."Document No." := LandAgreementHeader."Document No.";
                                    v_LandPPRDocumentList_1.INSERT;
                                END;
                            END;
                            //--------Insert R-1 Check list END

                            DocumentSetup.GET;
                            LandOldDocument.RESET;
                            LandOldDocument.SETRANGE("Document No.", "Document No.");
                            LandOldDocument.SETRANGE("Document Line No.", LandLeadOppLine."Line No.");
                            IF LandOldDocument.FINDSET THEN
                                REPEAT
                                    LandDocument.RESET;
                                    LandDocument.INIT;
                                    LandDocument."Document Type" := LandDocument."Document Type"::Document;
                                    LandDocument."No." := NoSeriesManagement.GetNextNo(DocumentSetup."Document Nos.", TODAY, TRUE);
                                    LandDocument."Table No." := LandOldDocument."Table No.";
                                    LandDocument."Reference No. 1" := LandOldDocument."Reference No. 1";
                                    LandDocument."Reference No. 2" := LandOldDocument."Reference No. 2";
                                    LandDocument."Reference No. 3" := LandOldDocument."Reference No. 3";
                                    LandDocument."Template Name" := LandOldDocument."Template Name";
                                    LandDocument.Description := LandOldDocument.Description;
                                    LandDocument.Content := LandOldDocument.Content;
                                    LandDocument."File Extension" := LandOldDocument."File Extension";
                                    LandDocument."In Use By" := LandOldDocument."In Use By";
                                    LandDocument.Special := LandOldDocument.Special;
                                    LandDocument."Document Import Date" := LandOldDocument."Document Import Date";
                                    LandDocument.Category := LandOldDocument.Category;
                                    LandDocument.Indexed := LandOldDocument.Indexed;
                                    LandDocument.GUID := LandOldDocument.GUID;
                                    LandDocument."Line No." := LandOldDocument."Line No.";
                                    LandDocument."Import Path" := LandOldDocument."Import Path";
                                    LandDocument."Description 2" := LandOldDocument."Description 2";
                                    LandDocument."Document Import By" := LandOldDocument."Document Import By";
                                    LandDocument."Document Import Time" := LandOldDocument."Document Import Time";
                                    LandDocument."Table Name" := LandOldDocument."Table Name";
                                    LandDocument."Document No." := LandAgreementHeader."Document No.";
                                    LandDocument."Document Line No." := LandOldDocument."Document Line No.";
                                    LandDocument."Line No." := LandOldDocument."Line No.";
                                    LandDocument.INSERT;
                                UNTIL LandOldDocument.NEXT = 0;

                        END;
                    UNTIL LandLeadOppLine.NEXT = 0;
            END;
        END;
    end;
}

