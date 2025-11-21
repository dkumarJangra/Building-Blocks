table 50053 "Land Agreement Header"
{
    // ALLESSS 16/02/2024 : Field added "Joint Venture" for Project Accounting
    // ALLESSS 21/02/24 : Updated  "Joint Venture" from Land Lead Opportunity Document.


    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                UserSetup.RESET;
                IF UserSetup.GET(USERID) THEN BEGIN
                    IF UserSetup."Allow Back Date Posting" THEN BEGIN
                        IF "Creation Date" > TODAY THEN
                            ERROR('Creation Date can not be greater than =' + FORMAT(TODAY));
                    END ELSE
                        IF "Creation Date" <> TODAY THEN
                            ERROR('Creation Date can not be differ from Today Date =' + FORMAT(TODAY));
                END;
            end;
        }
        field(3; Description; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Approved,Rejeted,InProcess';
            OptionMembers = Open,Approved,Rejeted,InProcess;
        }
        field(5; "Created By"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(7; Address; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(9; City; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(10; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(11; County; Text[30])
        {
            Caption = 'County';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region".Code;
        }
        field(12; "State Code"; Code[10])
        {
            Caption = 'State Code';
            DataClassification = ToBeClassified;
            TableRelation = State;

            trigger OnValidate()
            var
                CompanywiseGLAccount: Record "Company wise G/L Account";
                v_Cust: Record Customer;
            begin
            end;
        }
        field(13; "Sale Deed No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Date of Registration"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Area"; Decimal)
        {
            CalcFormula = Sum("Land Agreement Line".Area WHERE("Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(16; "Total Value"; Decimal)
        {
            CalcFormula = Sum("Land Agreement Line"."Land Value" WHERE("Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(17; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = ToBeClassified;
            TableRelation = "Country/Region";
        }
        field(18; "Land Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item;

            trigger OnValidate()
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
                PurchaseLine: Record "Purchase Line";
            begin
                IF "Land Item No." <> xRec."Land Item No." THEN BEGIN
                    ItemLedgerEntry.RESET;
                    ItemLedgerEntry.SETCURRENTKEY("Item No.");
                    ItemLedgerEntry.SETRANGE("Item No.", xRec."Land Item No.");
                    IF ItemLedgerEntry.FINDFIRST THEN
                        ERROR('You can not change the Value');

                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE("No.", xRec."Land Item No.");
                    IF PurchaseLine.FINDFIRST THEN
                        ERROR('PO already exist with No. - ' + PurchaseLine."Document No.");

                END;
            end;
        }
        field(19; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;

            trigger OnValidate()
            begin
                IF "Shortcut Dimension 1 Code" = '' THEN
                    "Shortcut Dimension 1 Code" := "Location Code";
            end;
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));
        }
        field(30; "Total Expense Value"; Decimal)
        {
            CalcFormula = Sum("Land Agreement Expense".Amount WHERE("Document No." = FIELD("Document No."),
                                                                     "JV Posted" = CONST(true),
                                                                     "JV Reversed" = CONST(false)));
            FieldClass = FlowField;
        }
        field(31; "Total Refund Value"; Decimal)
        {
            CalcFormula = Sum("Land Vendor Receipt Payment".Amount WHERE("Document No." = FIELD("Document No.")));
            FieldClass = FlowField;
        }
        field(33; "Opportunity Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Land Lead/Opp Header"."Document No." WHERE("Document Type" = CONST(Opportunity));

            trigger OnValidate()
            begin
                LandAgreementHeader.RESET;
                LandAgreementHeader.SETFILTER("Document No.", '<>%1', "Document No.");
                LandAgreementHeader.SETRANGE("Opportunity Document No.", "Opportunity Document No.");
                IF LandAgreementHeader.FINDFIRST THEN
                    ERROR('This Opportunity already used in Document No.-' + LandAgreementHeader."Document No.");

                CreateLandAgreementDocument;
            end;
        }
        field(50005; "Area in Acres"; Decimal)
        {
            CalcFormula = Sum("Land Agreement Line"."Area in Acres" WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Area in Guntas"; Decimal)
        {
            CalcFormula = Sum("Land Agreement Line"."Area in Guntas" WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Area in Ankanan"; Decimal)
        {
            CalcFormula = Sum("Land Agreement Line"."Area in Ankanan" WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50008; "Area in Cents"; Decimal)
        {
            CalcFormula = Sum("Land Agreement Line"."Area in Cents" WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "Area in Sq. Yard"; Decimal)
        {
            CalcFormula = Sum("Land Agreement Line"."Area in Sq. Yard" WHERE("Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Pending For Approval,Approved,Rejected';
            OptionMembers = Open,"Pending For Approval",Approved,Rejected;
        }
        field(50012; "Pending From USER ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50013; "Joint Venture"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESSS';
            Editable = false;
        }
        field(50014; "FG Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50015; "Other Expense Amount"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Land Agreement No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50016; "Project related cost paid"; Decimal)
        {
            CalcFormula = Sum("Land Vendor Receipt Payment".Amount WHERE("Document No." = FIELD("Document No."),
                                                                          Posted = CONST(true),
                                                                          "Payment Transaction Type" = FILTER("Project Related Cost Paid")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        LandAgreementLine: Record "Land Agreement Line";
    begin
        TESTFIELD(Status, Status::Open);
        LandAgreementLine.RESET;
        LandAgreementLine.SETRANGE("Document No.", "Document No.");
        IF LandAgreementLine.FINDSET THEN
            REPEAT
                LandAgreementLine.TESTFIELD(LandAgreementLine."Approval Status", LandAgreementLine."Approval Status"::Open);
                LandAgreementLine.DELETEALL;
            UNTIL LandAgreementLine.NEXT = 0;
    end;

    trigger OnInsert()
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        UnitSetup: Record "Unit Setup";
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.GET;
        IF "Document No." = '' THEN BEGIN
            UnitSetup.GET;
            UnitSetup.TESTFIELD("Land Agreement No.Series");
            "Document No." := NoSeriesManagement.GetNextNo(UnitSetup."Land Agreement No.Series", TODAY, TRUE);
            "Created By" := USERID;
            "Creation Time" := TIME;
            "Creation Date" := TODAY;
            InventorySetup.TESTFIELD("Global Dimension 1 Code");
            "Location Code" := InventorySetup."Global Dimension 1 Code";

            "Shortcut Dimension 1 Code" := InventorySetup."Global Dimension 1 Code";
            ;
            GeneralLedgerSetup.GET;
            GeneralLedgerSetup.TESTFIELD("Shortcut Dimension 5 Code");
            DimensionValue.RESET;
            DimensionValue.SETRANGE("Dimension Code", GeneralLedgerSetup."Shortcut Dimension 5 Code");
            DimensionValue.SETRANGE(Code, "Document No.");
            IF NOT DimensionValue.FINDFIRST THEN BEGIN
                DimensionValue.INIT;
                DimensionValue."Dimension Code" := GeneralLedgerSetup."Shortcut Dimension 5 Code";
                DimensionValue.Code := "Document No.";
                DimensionValue."Dimension Value Type" := DimensionValue."Dimension Value Type"::Standard;
                DimensionValue."Global Dimension No." := 5;
                DimensionValue.INSERT;
            END;

        END;
    end;

    var
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
        LandOldDocument: Record "Land Document Attachment";
        LandDocument: Record "Land Document Attachment";
        LandAgreementHeader: Record "Land Agreement Header";
        UserSetup: Record "User Setup";

    local procedure CreateLandAgreementDocument()
    var
        LandLeadOppHeader: Record "Land Lead/Opp Header";
        LandLeadOppLine: Record "Land Lead/Opp Line";
        LandAgreementHeader: Record "Land Agreement Header";
        LandAgreementLine: Record "Land Agreement Line";
        LandVendorPaymentTermsLine: Record "Land Vendor Payment Terms Line";
        v_LandVendorPaymentTermsLine: Record "Land Vendor Payment Terms Line";
        LandAgreementExpense: Record "Land Agreement Expense";
        AgreementLandAgreementExpense: Record "Land Agreement Expense";
        LandPPRDocumentList: Record "Land R-2 PPR  Document List";
        v_LandPPRDocumentList: Record "Land R-2 PPR  Document List";
        LandPPRDocumentList_1: Record "Sub Team Master";
        v_LandPPRDocumentList_1: Record "Sub Team Master";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DocumentSetup: Record "Document Setup";
    begin
        IF xRec."Opportunity Document No." <> "Opportunity Document No." THEN BEGIN
            Address := '';
            Description := '';
            "Address 2" := '';
            City := '';
            "Post Code" := '';
            County := '';
            "State Code" := '';
            "Sale Deed No." := '';
            "Date of Registration" := 0D;
            "Country/Region Code" := '';
            "Location Code" := '';
            "Shortcut Dimension 1 Code" := '';
            MODIFY;
            COMMIT;
            LandAgreementLine.RESET;
            LandAgreementLine.SETRANGE("Document No.", "Document No.");
            IF LandAgreementLine.FINDSET THEN
                LandAgreementLine.DELETEALL;
            LandVendorPaymentTermsLine.RESET;
            LandVendorPaymentTermsLine.SETRANGE("Land Document No.", "Document No.");
            IF LandVendorPaymentTermsLine.FINDSET THEN
                LandVendorPaymentTermsLine.DELETEALL;
            LandOldDocument.RESET;
            LandOldDocument.SETRANGE("Document No.", "Document No.");
            IF LandOldDocument.FINDSET THEN
                LandOldDocument.DELETEALL;

            LandLeadOppHeader.RESET;
            LandLeadOppHeader.SETRANGE("Document Type", LandLeadOppHeader."Document Type"::Opportunity);
            LandLeadOppHeader.SETRANGE("Document No.", "Opportunity Document No.");
            // LandLeadOppHeader.SETRANGE("Lead Status",LandLeadOppHeader."Lead Status"::Completed);
            IF LandLeadOppHeader.FINDFIRST THEN BEGIN
                //GET("Document No.");
                Address := LandLeadOppHeader."Village Name";
                Description := LandLeadOppHeader.Description;
                "Address 2" := LandLeadOppHeader."Mandalam Name";
                City := LandLeadOppHeader.City;
                "Post Code" := LandLeadOppHeader."Post Code";
                County := LandLeadOppHeader.County;
                "State Code" := LandLeadOppHeader."State Code";
                "Sale Deed No." := LandLeadOppHeader."Sale Deed No.";
                "Date of Registration" := LandLeadOppHeader."Date of Registration";
                "Country/Region Code" := LandLeadOppHeader."Country/Region Code";
                "Location Code" := LandLeadOppHeader."Location Code";
                "Shortcut Dimension 1 Code" := LandLeadOppHeader."Shortcut Dimension 1 Code";
                "Created By" := USERID;
                "Joint Venture" := LandLeadOppHeader."Joint Venture";   //ALLESSS 21/02/24
                MODIFY;

                /* // CODE commented 120923
                      LandLeadOppLine.RESET;
                      LandLeadOppLine.SETRANGE("Document Type",LandLeadOppHeader."Document Type");
                      LandLeadOppLine.SETRANGE("Document No.",LandLeadOppHeader."Document No.");
                      LandLeadOppLine.SETRANGE("Lead Status",LandLeadOppLine."Lead Status"::Completed);
                      LandLeadOppLine.SETRANGE("Line Status",LandLeadOppLine."Line Status"::Open);
                      LandLeadOppLine.SETRANGE("Approval Status",LandLeadOppLine."Approval Status"::Approved);
                      IF LandLeadOppLine.FINDSET THEN
                        REPEAT
                          LandAgreementLine.INIT;
                          LandAgreementLine."Document No." := "Document No.";
                          LandAgreementLine."Line No." := LandLeadOppLine."Line No.";
                          LandAgreementLine."Vendor Code" := LandLeadOppLine."Vendor Code";
                          LandAgreementLine."Vendor Name" := LandLeadOppLine."Vendor Name";
                          LandAgreementLine."Creation Date" := TODAY;
                          LandAgreementLine."Unit of Measure Code" := LandLeadOppLine."Unit of Measure Code";
                          LandAgreementLine."Unit Price" := LandLeadOppLine."Unit Price";
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
                          LandAgreementLine."Shortcut Dimension 1 Code" := LandLeadOppLine."Shortcut Dimension 1 Code";
                          LandAgreementLine."Land Document Dimension" := LandLeadOppLine."Land Document Dimension";
                          LandAgreementLine."Date of Registration" := LandLeadOppLine."Date of Registration";
                          LandAgreementLine."Quantity in SQYD" := LandLeadOppLine."Quantity In SQYD";
                          LandAgreementLine."Approval Status" :=  LandAgreementLine."Approval Status"::Open;
                          LandAgreementLine."Pending From USER ID" := '';
                          LandAgreementLine.INSERT;
                          LandVendorPaymentTermsLine.RESET;
                          LandVendorPaymentTermsLine.SETRANGE("Land Document No.","Opportunity Document No.");
                          LandVendorPaymentTermsLine.SETRANGE("Land Document Line No.",LandLeadOppLine."Line No.");
                          IF LandVendorPaymentTermsLine.FINDSET THEN
                            REPEAT
                              v_LandVendorPaymentTermsLine.INIT;
                              v_LandVendorPaymentTermsLine."Land Document No." := "Document No.";
                              v_LandVendorPaymentTermsLine."Vendor No." := LandVendorPaymentTermsLine."Vendor No.";
                              v_LandVendorPaymentTermsLine."Land Document Line No." := LandVendorPaymentTermsLine."Land Document Line No.";
                              v_LandVendorPaymentTermsLine."Actual Milestone" := LandVendorPaymentTermsLine."Actual Milestone";
                              v_LandVendorPaymentTermsLine."Line No." := LandVendorPaymentTermsLine."Line No.";
                              v_LandVendorPaymentTermsLine."Payment Term Code" := LandVendorPaymentTermsLine."Payment Term Code";
                              v_LandVendorPaymentTermsLine."Base Amount" := LandVendorPaymentTermsLine."Base Amount";
                              v_LandVendorPaymentTermsLine."Calculation Type" := LandVendorPaymentTermsLine."Calculation Type";
                              v_LandVendorPaymentTermsLine."Calculation Value" := LandVendorPaymentTermsLine."Calculation Value";
                              v_LandVendorPaymentTermsLine.VALIDATE("Due Date Calculation",LandVendorPaymentTermsLine."Due Date Calculation");
                              v_LandVendorPaymentTermsLine."Due Amount" := LandVendorPaymentTermsLine."Due Amount";
                              v_LandVendorPaymentTermsLine.Description := LandVendorPaymentTermsLine.Description;
                              v_LandVendorPaymentTermsLine."Payment Type" := LandVendorPaymentTermsLine."Payment Type";
                              v_LandVendorPaymentTermsLine."Fixed Amount" := LandVendorPaymentTermsLine."Fixed Amount";
                              v_LandVendorPaymentTermsLine."Balance Amount" := LandVendorPaymentTermsLine."Balance Amount";
                              v_LandVendorPaymentTermsLine."Land Value" := LandVendorPaymentTermsLine."Land Value";
                              v_LandVendorPaymentTermsLine.INSERT;
                            UNTIL LandVendorPaymentTermsLine.NEXT = 0;

                            LandAgreementExpense.RESET;
                            LandAgreementExpense.SETRANGE("Document Type",LandAgreementExpense."Document Type"::Opportunity);
                            LandAgreementExpense.SETRANGE("Document No.","Opportunity Document No.");
                            LandAgreementExpense.SETRANGE("JV Posted",TRUE);
                            LandAgreementExpense.SETRANGE("Document Line No.",LandLeadOppLine."Line No.");
                            IF LandAgreementExpense.FINDSET THEN
                              REPEAT
                                AgreementLandAgreementExpense.RESET;
                                IF NOT AgreementLandAgreementExpense.GET(AgreementLandAgreementExpense."Document Type"::Agreement,"Document No.",LandAgreementExpense."Document Line No.",LandAgreementExpense."Line No.") THEN BEGIN
                                  AgreementLandAgreementExpense.INIT;
                                  AgreementLandAgreementExpense.TRANSFERFIELDS(LandAgreementExpense);
                                  AgreementLandAgreementExpense."Document Type" := AgreementLandAgreementExpense."Document Type"::Agreement;
                                  AgreementLandAgreementExpense."Document No." := "Document No.";
                                  AgreementLandAgreementExpense.INSERT;
                                END;
                              UNTIL LandAgreementExpense.NEXT = 0;

                        //-----------Insert R-1 Check list START
                           v_LandPPRDocumentList.RESET;
                           v_LandPPRDocumentList.SETRANGE("Document No.","Document No.");
                           v_LandPPRDocumentList.SETRANGE("Document Line No.",LandLeadOppLine."Line No.");
                           IF NOT v_LandPPRDocumentList.FINDFIRST THEN BEGIN
                             LandPPRDocumentList.RESET;
                             LandPPRDocumentList.SETRANGE("Document No.","Opportunity Document No.");
                             LandPPRDocumentList.SETRANGE("Document Line No.",LandLeadOppLine."Line No.");
                             IF LandPPRDocumentList.FINDSET THEN BEGIN
                                v_LandPPRDocumentList.INIT;
                                v_LandPPRDocumentList.TRANSFERFIELDS(LandPPRDocumentList);
                                v_LandPPRDocumentList."Document No." := "Document No.";
                                v_LandPPRDocumentList.INSERT;
                             END;
                           END;

                        //-----------Insert R-2 Check list END

                        //--------Insert R-1 Check list START
                           v_LandPPRDocumentList_1.RESET;
                           v_LandPPRDocumentList_1.SETRANGE("Document No.","Document No.");
                           v_LandPPRDocumentList_1.SETRANGE("Document Line No.",LandLeadOppLine."Line No.");
                           IF NOT v_LandPPRDocumentList_1.FINDFIRST THEN BEGIN
                             LandPPRDocumentList_1.RESET;
                             LandPPRDocumentList_1.SETRANGE("Document No.","Opportunity Document No.");
                             LandPPRDocumentList_1.SETRANGE("Document Line No.",LandLeadOppLine."Line No.");
                             IF LandPPRDocumentList_1.FINDSET THEN BEGIN
                                v_LandPPRDocumentList_1.INIT;
                                v_LandPPRDocumentList_1.TRANSFERFIELDS(LandPPRDocumentList_1);
                                v_LandPPRDocumentList_1."Document No." := "Document No.";
                                v_LandPPRDocumentList_1.INSERT;
                             END;
                           END;
                        //--------Insert R-1 Check list END
                        DocumentSetup.GET;
                       LandOldDocument.RESET;
                       LandOldDocument.SETRANGE("Document No.","Opportunity Document No.");
                       LandOldDocument.SETRANGE("Document Line No.",LandLeadOppLine."Line No.");
                       IF LandOldDocument.FINDSET THEN
                          REPEAT
                          LandDocument.RESET;
                          LandDocument.INIT;
                          LandDocument."Document Type" :=  LandDocument."Document Type"::Document;
                          LandDocument."No." := NoSeriesManagement.GetNextNo(DocumentSetup."Document Nos.",TODAY,TRUE);
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
                          LandDocument."Document No." := "Document No.";
                          LandDocument."Document Line No." := LandOldDocument."Document Line No.";
                          LandDocument."Line No." := LandOldDocument."Line No.";
                          LandDocument.INSERT;
                        UNTIL LandOldDocument.NEXT = 0;

                   UNTIL LandLeadOppLine.NEXT = 0;
                    */

                // CODE commented 120923 End


            END;

        END;

    end;
}

