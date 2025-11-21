table 60666 "Land Lead/Opp Header"
{
    // ALLESSS 21/02/24 : Adedd Field "Joint Venture" for Project Accounting Joint Venture Functionality.


    fields
    {
        field(1; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = true;

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
            OptionCaption = 'Open,Approved';
            OptionMembers = Open,Approved,Closed,Forfeit;
        }
        field(5; "Created By"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Creation Time"; Time)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Village Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Mandalam Name"; Text[50])
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

            trigger OnValidate()
            var
                pos: Integer;
                result: Text;
                IsNumeric: Boolean;
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
                //ALLEDK 100821
                IF City <> '' THEN BEGIN
                    pos := 1;
                    WHILE (pos <= STRLEN(City)) DO BEGIN
                        IsNumeric := City[pos] IN ['0' .. '9', ',', '.', '-', '+'];
                        IF IsNumeric THEN
                            ERROR('Number not allow')
                        ELSE
                            result := result + FORMAT(City[pos]);
                        pos += 1;
                    END;
                END;
                //ALLEDK 100821
            end;
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

            trigger OnValidate()
            var
                v_PostCode: Record "Post Code";
            begin
                IF STRLEN("Post Code") > 6 THEN  //ALLEDK 100821
                    ERROR('Post code can not be greater than 6 Digits');   //ALLEDK 100821

                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);

                v_PostCode.GET("Post Code", City);  //ALLEDK 100821
                "State Code" := v_PostCode."State Code";  //ALLEDK 100821
            end;
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
            CalcFormula = Sum("Land Lead/Opp Line".Area WHERE("Document Type" = FIELD("Document Type"),
                                                               "Document No." = FIELD("Document No."),
                                                               "Line Status" = FILTER(Open)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Total Value"; Decimal)
        {
            CalcFormula = Sum("Land Lead/Opp Line"."Land Value" WHERE("Document Type" = FIELD("Document Type"),
                                                                       "Document No." = FIELD("Document No."),
                                                                       "Line Status" = FILTER(Open)));
            Editable = false;
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

                    //  PurchaseLine.RESET;
                    //  PurchaseLine.SETRANGE("No.",xRec."Land Item No.");
                    //  IF PurchaseLine.FINDFIRST THEN
                    //    ERROR('PO already exist with No. - '+PurchaseLine."Document No.");
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
        field(28; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Lead,Opportunity';
            OptionMembers = " ",Lead,Opportunity;
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
            FieldClass = Normal;
        }
        field(31; "Total Refund Value"; Decimal)
        {
            FieldClass = Normal;
        }
        field(50000; "Lead Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Land Lead/Opp Header"."Document No." WHERE("Document Type" = CONST(Lead));

            trigger OnValidate()
            begin
                LandLeadOppHeader.RESET;
                LandLeadOppHeader.SETRANGE("Document Type", "Document Type");
                LandLeadOppHeader.SETFILTER("Document No.", '<>%1', "Document No.");
                LandLeadOppHeader.SETRANGE("Lead Document No.", "Lead Document No.");
                IF LandLeadOppHeader.FINDFIRST THEN
                    ERROR('Lead Document No. already used in Document No.-' + LandLeadOppHeader."Document No.");

                CreateOpportunityDocument;
            end;
        }
        field(50001; "Lead Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Cancelled,Completed,Under-Process';
            OptionMembers = " ",Cancelled,Completed,"Under-Process";
        }
        field(50005; "Area in Acres"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(50006; "Area in Guntas"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(50007; "Area in Ankanan"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(50008; "Area in Cents"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(50009; "Area in Sq. Yard"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(50010; "Total Land Area in Text"; Text[80])
        {
            DataClassification = ToBeClassified;
            Description = 'used in R-1 PRR List';
            Editable = false;
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
        field(50013; "Lead Document Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50014; "Opportunity Document No."; Code[20])
        {
            CalcFormula = Lookup("Land Lead/Opp Header"."Document No." WHERE("Lead Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50015; "Agreement Document No."; Code[20])
        {
            CalcFormula = Lookup("Land Agreement Header"."Document No." WHERE("Opportunity Document No." = FIELD("Document No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50016; "Joint Venture"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF xRec."Joint Venture" <> Rec."Joint Venture" THEN
                    TESTFIELD("Opportunity Document No.", '');
            end;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.")
        {
            Clustered = true;
        }
        key(Key2; "Lead Document No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD("Approval Status", "Approval Status"::Open);
    end;

    trigger OnInsert()
    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        UnitSetup: Record "Unit Setup";
    begin
        IF "Document No." = '' THEN BEGIN
            UnitSetup.GET;
            BBGSetups.GET;
            BBGSetups.TESTFIELD("Land Lead No. Series");
            BBGSetups.TESTFIELD("Land Opportunity No. Series");
            IF "Document Type" = "Document Type"::Lead THEN
                "Document No." := NoSeriesManagement.GetNextNo(BBGSetups."Land Lead No. Series", TODAY, TRUE)
            ELSE IF "Document Type" = "Document Type"::Opportunity THEN
                "Document No." := NoSeriesManagement.GetNextNo(BBGSetups."Land Opportunity No. Series", TODAY, TRUE);

            InventorySetup.RESET;
            InventorySetup.GET;
            InventorySetup.TESTFIELD("Global Dimension 1 Code");

            "Location Code" := InventorySetup."Global Dimension 1 Code";
            "Shortcut Dimension 1 Code" := InventorySetup."Global Dimension 1 Code";

            "Created By" := USERID;
            "Creation Time" := TIME;
            "Creation Date" := TODAY;
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
                DimensionValue.INSERT;
            END;

        END;
    end;

    var
        DimensionValue: Record "Dimension Value";
        GeneralLedgerSetup: Record "General Ledger Setup";
        LandPPRDocumentList: Record "Land R-2 PPR  Document List";
        //v_LandPPRDocumentList: Record 60668;
        LandLeadOppHeader: Record "Land Lead/Opp Header";
        OldDocument: Record "Land Document Attachment";
        //RecDocument: Record 60730;
        DocumentSetup: Record "Document Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        PostCode: Record "Post Code";
        InventorySetup: Record "Inventory Setup";
        LandPPRDocumentList_1: Record "Sub Team Master";
        v_LandPPRDocumentList_1: Record "Sub Team Master";
        UserSetup: Record "User Setup";
        BBGSetups: Record "BBG Setups";

    local procedure CreateOpportunityDocument()
    var
        LandLeadOppHeader: Record "Land Lead/Opp Header";
        LandLeadOppLine: Record "Land Lead/Opp Line";
        LandOpprotunityHeader: Record "Land Lead/Opp Header";
        LandOpprotunityLine: Record "Land Lead/Opp Line";
        RecDocument: Record "Land Document Attachment";
        NewDocument: Record "Land Document Attachment";
        LandAgreementExpense: Record "Land Agreement Expense";
        OpportunityLandAgreementExpense: Record "Land Agreement Expense";
    begin

        IF xRec."Lead Document No." <> "Lead Document No." THEN BEGIN
            LandLeadOppLine.RESET;
            LandLeadOppLine.SETRANGE("Document Type", "Document Type");
            LandLeadOppLine.SETRANGE("Document No.", "Document No.");
            IF LandLeadOppLine.FINDSET THEN
                LandLeadOppLine.DELETEALL;
            LandPPRDocumentList.RESET;
            LandPPRDocumentList.SETRANGE("Document No.", "Document No.");
            IF LandPPRDocumentList.FINDSET THEN
                LandPPRDocumentList.DELETEALL;
            OldDocument.RESET;
            OldDocument.SETRANGE("Document No.", "Document No.");
            IF OldDocument.FINDSET THEN
                OldDocument.DELETEALL;
            "Village Name" := '';
            Description := '';
            "Mandalam Name" := '';
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


            LandLeadOppHeader.RESET;
            LandLeadOppHeader.SETRANGE("Document Type", LandLeadOppHeader."Document Type"::Lead);
            LandLeadOppHeader.SETRANGE("Document No.", "Lead Document No.");
            //LandLeadOppHeader.SETRANGE("Lead Status",LandLeadOppHeader."Lead Status"::Completed);
            //LandLeadOppHeader.SETRANGE("Approval Status",LandLeadOppHeader."Approval Status"::Approved);
            IF LandLeadOppHeader.FINDFIRST THEN BEGIN
                //LandOpprotunityHeader.GET("Document Type","Document No.");
                "Village Name" := LandLeadOppHeader."Village Name";
                Description := LandLeadOppHeader.Description;
                "Mandalam Name" := LandLeadOppHeader."Mandalam Name";
                City := LandLeadOppHeader.City;
                "Post Code" := LandLeadOppHeader."Post Code";
                County := LandLeadOppHeader.County;
                "State Code" := LandLeadOppHeader."State Code";
                "Sale Deed No." := LandLeadOppHeader."Sale Deed No.";
                "Date of Registration" := LandLeadOppHeader."Date of Registration";
                "Country/Region Code" := LandLeadOppHeader."Country/Region Code";
                "Location Code" := LandLeadOppHeader."Location Code";
                "Shortcut Dimension 1 Code" := LandLeadOppHeader."Shortcut Dimension 1 Code";
                "Joint Venture" := LandLeadOppHeader."Joint Venture";     //ALLESSS 22/02/24
                MODIFY;

                //Code commented 120923 Start
                /*
                LandLeadOppLine.RESET;
                LandLeadOppLine.SETRANGE("Document Type",LandLeadOppHeader."Document Type");
                LandLeadOppLine.SETRANGE("Document No.",LandLeadOppHeader."Document No.");
                LandLeadOppLine.SETRANGE("Lead Status",LandLeadOppLine."Lead Status"::Completed);
                LandLeadOppLine.SETRANGE("Line Status",LandLeadOppLine."Line Status"::Open);
                LandLeadOppLine.SETRANGE("Approval Status",LandLeadOppLine."Approval Status"::Approved);
                IF LandLeadOppLine.FINDSET THEN
                  REPEAT
                      LandOpprotunityLine.INIT;
                      LandOpprotunityLine.TRANSFERFIELDS(LandLeadOppLine);
                      LandOpprotunityLine."Document Type" := "Document Type";
                      LandOpprotunityLine."Document No." := "Document No.";
                      LandOpprotunityLine."Lead Status" := LandOpprotunityLine."Lead Status"::" ";
                      LandOpprotunityLine."Line Status" := LandOpprotunityLine."Line Status"::Open;
                      LandOpprotunityLine."Lead Document No." := LandLeadOppLine."Document No.";
                      LandOpprotunityLine."Lead Document Line No." := LandLeadOppLine."Line No.";
                      LandOpprotunityLine."Approval Status" := LandOpprotunityLine."Approval Status"::Open;
                      LandOpprotunityLine.INSERT;

                      LandAgreementExpense.RESET;
                      LandAgreementExpense.SETRANGE("Document Type",LandAgreementExpense."Document Type"::Lead);
                      LandAgreementExpense.SETRANGE("Document No.","Lead Document No.");
                      LandAgreementExpense.SETRANGE("JV Posted",TRUE);
                      LandAgreementExpense.SETRANGE("Document Line No.",LandLeadOppLine."Line No.");
                      IF LandAgreementExpense.FINDSET THEN
                        REPEAT
                        OpportunityLandAgreementExpense.RESET;
                        IF NOT OpportunityLandAgreementExpense.GET("Document Type","Document No.",LandAgreementExpense."Document Line No.",LandAgreementExpense."Line No.") THEN BEGIN
                          OpportunityLandAgreementExpense.INIT;
                          OpportunityLandAgreementExpense.TRANSFERFIELDS(LandAgreementExpense);
                          OpportunityLandAgreementExpense."Document Type" := OpportunityLandAgreementExpense."Document Type"::Opportunity;
                          OpportunityLandAgreementExpense."Document No." := "Document No.";
                          OpportunityLandAgreementExpense.INSERT;
                        END;
                      UNTIL LandAgreementExpense.NEXT = 0;

                      //-----------Insert R-1 Check list START
                       v_LandPPRDocumentList.RESET;
                       v_LandPPRDocumentList.SETRANGE("Document No.","Document No.");
                       v_LandPPRDocumentList.SETRANGE("Document Line No.",LandLeadOppLine."Line No.");
                       IF NOT v_LandPPRDocumentList.FINDFIRST THEN BEGIN
                         LandPPRDocumentList.RESET;
                         LandPPRDocumentList.SETRANGE("Document No.","Lead Document No.");
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
                         LandPPRDocumentList_1.SETRANGE("Document No.","Lead Document No.");
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
                  OldDocument.RESET;
                  OldDocument.SETRANGE("Document No.","Lead Document No.");
                  OldDocument.SETRANGE("Document Line No.",LandLeadOppLine."Line No.");
                  IF OldDocument.FINDSET THEN REPEAT

                  RecDocument.RESET;
                  RecDocument.INIT;
                  RecDocument."Document Type" := OldDocument."Document Type";
                  RecDocument."No." := NoSeriesManagement.GetNextNo(DocumentSetup."Document Nos.",TODAY,TRUE);
                  RecDocument."Document No." := "Document No.";
                  RecDocument."Document Line No." := OldDocument."Document Line No.";
                  RecDocument."Line No." := OldDocument."Line No.";
                  RecDocument."Table No." := OldDocument."Table No.";
                  RecDocument."Reference No. 1" := OldDocument."Reference No. 1";
                  RecDocument."Reference No. 2" := OldDocument."Reference No. 2";
                  RecDocument."Reference No. 3" := OldDocument."Reference No. 3";
                  RecDocument."Template Name" := OldDocument."Template Name";
                  RecDocument.Description := OldDocument.Description;
                  RecDocument.Content := OldDocument.Content;
                  RecDocument."File Extension" := OldDocument."File Extension";
                  RecDocument."In Use By" := OldDocument."In Use By";
                  RecDocument.Special := OldDocument.Special;
                  RecDocument."Document Import Date" := OldDocument."Document Import Date";
                  RecDocument.Category := OldDocument.Category;
                  RecDocument.Indexed := OldDocument.Indexed;
                  RecDocument.GUID := OldDocument.GUID;
                  RecDocument."Import Path" := OldDocument."Import Path";
                  RecDocument."Description 2" := OldDocument."Description 2";
                  RecDocument."Document Import By" := OldDocument."Document Import By";
                  RecDocument."Document Import Time" := OldDocument."Document Import Time";
                  RecDocument."Table Name" := OldDocument."Table Name";

                  RecDocument."Attachment Type" := OldDocument."Attachment Type";
                  RecDocument.Applicable := OldDocument.Applicable;

                  RecDocument.INSERT;
               UNTIL OldDocument.NEXT = 0;

                  UNTIL LandLeadOppLine.NEXT = 0;
                  */

                //Code commented 120923  END




            END;
        END;

    end;


    procedure CalculatesArea(var P_LandLeadOppHeader: Record "Land Lead/Opp Header")
    var
        v_LandLeadOppLine: Record "Land Lead/Opp Line";
        TotalGuntas: Decimal;
        TotalAcres: Decimal;
        DivAcres: Decimal;
        ModAcres: Decimal;
        BBGSetups: Record "BBG Setups";
        TotalCents: Decimal;
        DivCEnt: Decimal;
        ModCents: Decimal;
        TotalSQYD: Decimal;
    begin

        BBGSetups.GET;

        v_LandLeadOppLine.RESET;
        v_LandLeadOppLine.SETRANGE("Document No.", P_LandLeadOppHeader."Document No.");
        v_LandLeadOppLine.SETRANGE("Line Status", v_LandLeadOppLine."Line Status"::Open);
        IF v_LandLeadOppLine.FINDSET THEN
            REPEAT
                IF v_LandLeadOppLine."Unit of Measure Code" = 'SQYD' THEN
                    TotalSQYD := TotalSQYD + v_LandLeadOppLine.Area
                ELSE BEGIN
                    TotalAcres := TotalAcres + v_LandLeadOppLine."Area in Acres";
                    TotalGuntas := TotalGuntas + v_LandLeadOppLine."Area in Guntas";
                    TotalCents := TotalCents + v_LandLeadOppLine."Area in Cents";
                END;
            UNTIL v_LandLeadOppLine.NEXT = 0;
        IF TotalGuntas >= BBGSetups.Guntas THEN BEGIN
            DivAcres := TotalGuntas DIV BBGSetups.Guntas;
            ModAcres := TotalGuntas MOD BBGSetups.Guntas;
        END ELSE
            ModAcres := TotalGuntas;
        IF TotalCents >= BBGSetups.Cents THEN BEGIN
            DivCEnt := TotalCents DIV BBGSetups.Cents;
            ModCents := TotalCents MOD BBGSetups.Cents;
        END ELSE
            ModCents := TotalCents;

        P_LandLeadOppHeader."Area in Acres" := TotalAcres + DivAcres;
        P_LandLeadOppHeader."Area in Guntas" := ModAcres;
        P_LandLeadOppHeader."Area in Cents" := ModCents;
        P_LandLeadOppHeader."Area in Sq. Yard" := TotalSQYD;
        P_LandLeadOppHeader.MODIFY;

        UpdateLandArea;
    end;


    procedure UpdateLandArea()
    begin
        LandLeadOppHeader.RESET;
        IF LandLeadOppHeader.GET("Document Type", "Document No.") THEN BEGIN
            IF LandLeadOppHeader."Area in Acres" <> 0 THEN
                "Total Land Area in Text" := FORMAT(LandLeadOppHeader."Area in Acres") + 'Acres';
            IF LandLeadOppHeader."Area in Guntas" <> 0 THEN
                "Total Land Area in Text" := "Total Land Area in Text" + ',' + FORMAT(LandLeadOppHeader."Area in Guntas") + 'Guntas';
            IF LandLeadOppHeader."Area in Cents" <> 0 THEN
                "Total Land Area in Text" := "Total Land Area in Text" + ',' + FORMAT(LandLeadOppHeader."Area in Cents") + 'Cents';
            IF LandLeadOppHeader."Area in Ankanan" <> 0 THEN
                "Total Land Area in Text" := "Total Land Area in Text" + ',' + FORMAT(LandLeadOppHeader."Area in Ankanan") + 'Ankanan';
            IF LandLeadOppHeader."Area in Sq. Yard" <> 0 THEN
                "Total Land Area in Text" := "Total Land Area in Text" + ',' + FORMAT(LandLeadOppHeader."Area in Sq. Yard") + 'Sq. Yard';
        END;
    end;
}

