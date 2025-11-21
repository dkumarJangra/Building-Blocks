table 97862 "Archive Vendor"
{
    // //NDALLE 051107
    // //Added new fields
    // ////NDALLE 051107 To Master validate
    // // ALLEAS02 >> >> To Flow Vendor Posting Group
    // ALLRE : New Field Added
    // //AlleBLK : New Field Added
    // ALLESP BCL0004 11-07-2007 : New Field Added
    // //AlleDK 130308 : using for Report
    // //added by DDS : New Field Added
    // --JPL : New Field Added
    // JPL0002 : indicator that party is related ie. group related--JPL
    // 
    // ALLERP KRN0014 19-08-2010: Field "Validity till date" added and code added for updating in product vendors
    // ALLERP AlleHF 07-09-2010: Applying HF1 to HF5
    // ALLEPG 270711 :   Added HotFix PS59643 for Service Tax.
    // ALLEPG 040712 : Added field.
    // ALLEPG 310812 : Added Fields.
    // ALLEPG 051012 : Created function CreateVendorFromWeb.
    // ALELDK 040313 Code commented

    Caption = 'Vendor';
    DataCaptionFields = "No.", Name;
    DataPerCompany = true;
    DrillDownPageID = "Archive Vendor List";
    LookupPageID = "Archive Vendor List";
    Permissions = TableData "Vendor Ledger Entry" = r;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
        }
        field(5; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(7; City; Text[30])
        {
            Caption = 'City';

            trigger OnLookup()
            begin
                PostCode.LookUpCity(City, "Post Code", TRUE);
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", TRUE);
            end;
        }
        field(8; Contact; Text[50])
        {
            Caption = 'Contact';
        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(10; "Telex No."; Text[20])
        {
            Caption = 'Telex No.';
        }
        field(14; "Our Account No."; Text[20])
        {
            Caption = 'Our Account No.';
        }
        field(15; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(16; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
                MODIFY;
            end;
        }
        field(17; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
                MODIFY;
            end;
        }
        field(19; "Budgeted Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Budgeted Amount';
        }
        field(21; "Vendor Posting Group"; Code[10])
        {
            Caption = 'Vendor Posting Group';
            TableRelation = "Vendor Posting Group";
        }
        field(22; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(24; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(26; "Statistics Group"; Integer)
        {
            Caption = 'Statistics Group';
        }
        field(27; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(28; "Fin. Charge Terms Code"; Code[10])
        {
            Caption = 'Fin. Charge Terms Code';
            TableRelation = "Finance Charge Terms";
        }
        field(29; "Purchaser Code"; Code[10])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(30; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(31; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(33; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(38; Comment; Boolean)
        {
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Vendor),
                                                      "No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; Blocked; Option)
        {
            Caption = 'Blocked';
            OptionCaption = ' ,Payment,All';
            OptionMembers = " ",Payment,All;
        }
        field(45; "Pay-to Vendor No."; Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            TableRelation = Vendor;
        }
        field(46; Priority; Integer)
        {
            Caption = 'Priority';
        }
        field(47; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(54; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(55; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(56; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(57; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(58; Balance; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Net Change"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter"),
                                                                           "Posting Type" = FIELD("Posting Type Filter")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Net Change (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter"),
                                                                                   "Posting Type" = FIELD("Posting Type Filter")));
            Caption = 'Net Change (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Purchases (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Vendor Ledger Entry"."Purchase (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                             "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                             "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                             "Posting Date" = FIELD("Date Filter"),
                                                                             "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Purchases (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(64; "Inv. Discounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Vendor Ledger Entry"."Inv. Discount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Inv. Discounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(65; "Pmt. Discounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Entry Type" = FILTER('Payment Discount' .. 'Payment Discount (VAT Adjustment)'),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Pmt. Discounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(66; "Balance Due"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("No."),
                                                                           "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                                           "Initial Entry Due Date" = FIELD("Date Filter"),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Balance Due';
            Editable = false;
            FieldClass = FlowField;
        }
        field(67; "Balance Due (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                   "Posting Date" = FIELD(UPPERLIMIT("Date Filter")),
                                                                                   "Initial Entry Due Date" = FIELD("Date Filter"),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Balance Due (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(69; Payments; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(Payment),
                                                                          "Entry Type" = CONST("Initial Entry"),
                                                                          "Vendor No." = FIELD("No."),
                                                                          "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                          "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Payments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Invoice Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(Invoice),
                                                                           "Entry Type" = CONST("Initial Entry"),
                                                                           "Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Invoice Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(71; "Cr. Memo Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST("Credit Memo"),
                                                                          "Entry Type" = CONST("Initial Entry"),
                                                                          "Vendor No." = FIELD("No."),
                                                                          "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                          "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                          "Posting Date" = FIELD("Date Filter"),
                                                                          "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Cr. Memo Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(72; "Finance Charge Memo Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST("Finance Charge Memo"),
                                                                           "Entry Type" = CONST("Initial Entry"),
                                                                           "Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Finance Charge Memo Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(74; "Payments (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(Payment),
                                                                                  "Entry Type" = CONST("Initial Entry"),
                                                                                  "Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Payments (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(75; "Inv. Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(Invoice),
                                                                                   "Entry Type" = CONST("Initial Entry"),
                                                                                   "Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Inv. Amounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(76; "Cr. Memo Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST("Credit Memo"),
                                                                                  "Entry Type" = CONST("Initial Entry"),
                                                                                  "Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Cr. Memo Amounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(77; "Fin. Charge Memo Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST("Finance Charge Memo"),
                                                                                   "Entry Type" = CONST("Initial Entry"),
                                                                                   "Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Fin. Charge Memo Amounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(78; "Outstanding Orders"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Outstanding Amount" WHERE("Document Type" = CONST(Order),
                                                                          "Pay-to Vendor No." = FIELD("No."),
                                                                          "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                          "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                          "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(79; "Amt. Rcd. Not Invoiced"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Amt. Rcd. Not Invoiced" WHERE("Document Type" = CONST(Order),
                                                                              "Pay-to Vendor No." = FIELD("No."),
                                                                              "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Amt. Rcd. Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Application Method"; Option)
        {
            Caption = 'Application Method';
            OptionCaption = 'Manual,Apply to Oldest';
            OptionMembers = Manual,"Apply to Oldest";
        }
        field(82; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                PurchPrice: Record "Purchase Price";
                Item: Record Item;
                VATPostingSetup: Record "VAT Posting Setup";
                Currency: Record Currency;
            begin
                PurchPrice.SETCURRENTKEY("Vendor No.");
                PurchPrice.SETRANGE("Vendor No.", "No.");
                IF PurchPrice.FIND('-') THEN BEGIN
                    IF VATPostingSetup.GET('', '') THEN;
                    IF CONFIRM(
                         STRSUBSTNO(
                           Text002,
                           FIELDCAPTION("Prices Including VAT"), "Prices Including VAT", PurchPrice.TABLECAPTION), TRUE)
                    THEN
                        REPEAT
                            IF PurchPrice."Item No." <> Item."No." THEN
                                Item.GET(PurchPrice."Item No.");
                            IF ("VAT Bus. Posting Group" <> VATPostingSetup."VAT Bus. Posting Group") OR
                               (Item."VAT Prod. Posting Group" <> VATPostingSetup."VAT Prod. Posting Group")
                            THEN
                                VATPostingSetup.GET("VAT Bus. Posting Group", Item."VAT Prod. Posting Group");
                            IF PurchPrice."Currency Code" = '' THEN
                                Currency.InitRoundingPrecision
                            ELSE
                                IF PurchPrice."Currency Code" <> Currency.Code THEN
                                    Currency.GET(PurchPrice."Currency Code");
                            IF VATPostingSetup."VAT %" <> 0 THEN BEGIN
                                IF "Prices Including VAT" THEN
                                    PurchPrice."Direct Unit Cost" :=
                                      ROUND(
                                        PurchPrice."Direct Unit Cost" * (1 + VATPostingSetup."VAT %" / 100),
                                        Currency."Unit-Amount Rounding Precision")
                                ELSE
                                    PurchPrice."Direct Unit Cost" :=
                                      ROUND(
                                        PurchPrice."Direct Unit Cost" / (1 + VATPostingSetup."VAT %" / 100),
                                        Currency."Unit-Amount Rounding Precision");
                                PurchPrice.MODIFY;
                            END;
                        UNTIL PurchPrice.NEXT = 0;
                END;
            end;
        }
        field(84; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(85; "Telex Answer Back"; Text[20])
        {
            Caption = 'Telex Answer Back';
        }
        field(86; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';

            trigger OnValidate()
            var
                VATRegNoFormat: Record "VAT Registration No. Format";
            begin
                VATRegNoFormat.Test("VAT Registration No.", "Country/Region Code", "No.", DATABASE::Vendor);
            end;
        }
        field(88; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin


                IF "Vendor Category" = "Vendor Category"::"IBA(Associates)" THEN BEGIN
                    MESSAGE('First fill the Associate Credentials');
                    IF ("Mob. No." = '') THEN
                        IF "E-Mail" = '' THEN
                            ERROR('Fill the Mobile No. OR E-Mail');

                    TESTFIELD("Date of Birth");
                    TESTFIELD("Rank Code");
                    TESTFIELD("Parent Rank");
                    TESTFIELD("Associate Creation");
                    IF "Associate Creation" = "Associate Creation"::" " THEN
                        TESTFIELD("Old No.");
                    IF "P.A.N. Status" = "P.A.N. Status"::" " THEN
                        TESTFIELD("P.A.N. No.");
                END;
                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                    IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") THEN
                        VALIDATE("VAT Bus. Posting Group", GenBusPostingGrp."Def. VAT Bus. Posting Group");
            end;
        }
        field(89; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookUpPostCode(City, "Post Code", TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(City,"Post Code"); // ALLE MM Code Commented
            end;
        }
        field(92; County; Text[30])
        {
            Caption = 'County';
        }
        field(97; "Debit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Debit Amount" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Entry Type" = FILTER(<> Application),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(98; "Credit Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Credit Amount" WHERE("Vendor No." = FIELD("No."),
                                                                                   "Entry Type" = FILTER(<> Application),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99; "Debit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                        "Entry Type" = FILTER(<> Application),
                                                                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                        "Posting Date" = FIELD("Date Filter"),
                                                                                        "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Debit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Credit Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Credit Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                         "Entry Type" = FILTER(<> Application),
                                                                                         "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                         "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                         "Posting Date" = FIELD("Date Filter"),
                                                                                         "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Credit Amount (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(103; "Home Page"; Text[80])
        {
            Caption = 'Home Page';
            ExtendedDatatype = URL;
        }
        field(104; "Reminder Amounts"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(Reminder),
                                                                           "Entry Type" = CONST("Initial Entry"),
                                                                           "Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Reminder Amounts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(105; "Reminder Amounts (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(Reminder),
                                                                                   "Entry Type" = CONST("Initial Entry"),
                                                                                   "Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Reminder Amounts (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(109; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(110; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(111; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(113; "Outstanding Orders (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Outstanding Amount (LCY)" WHERE("Document Type" = CONST(Order),
                                                                                "Pay-to Vendor No." = FIELD("No."),
                                                                                "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Orders (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(114; "Amt. Rcd. Not Invoiced (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Amt. Rcd. Not Invoiced (LCY)" WHERE("Document Type" = CONST(Order),
                                                                                    "Pay-to Vendor No." = FIELD("No."),
                                                                                    "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                    "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                    "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Amt. Rcd. Not Invoiced (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(116; "Block Payment Tolerance"; Boolean)
        {
            Caption = 'Block Payment Tolerance';
        }
        field(117; "Pmt. Disc. Tolerance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Entry Type" = FILTER('Payment Discount Tolerance' | 'Payment Discount Tolerance (VAT Adjustment)' | 'Payment Discount Tolerance (VAT Excl.)'),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Pmt. Disc. Tolerance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(118; "Pmt. Tolerance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Entry Type" = FILTER('Payment Tolerance' | 'Payment Tolerance (VAT Adjustment)' | 'Payment Tolerance (VAT Excl.)'),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Pmt. Tolerance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(119; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            TableRelation = "IC Partner";

            trigger OnValidate()
            var
                VendLedgEntry: Record "Vendor Ledger Entry";
                AccountingPeriod: Record "Accounting Period";
                ICPartner: Record "IC Partner";
            begin
                IF xRec."IC Partner Code" <> "IC Partner Code" THEN BEGIN
                    VendLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date");
                    VendLedgEntry.SETRANGE("Vendor No.", "No.");
                    AccountingPeriod.SETRANGE(Closed, FALSE);
                    IF AccountingPeriod.FIND('-') THEN
                        VendLedgEntry.SETFILTER("Posting Date", '>=%1', AccountingPeriod."Starting Date");
                    IF VendLedgEntry.FIND('-') THEN
                        IF NOT CONFIRM(Text009, FALSE, TABLECAPTION) THEN
                            "IC Partner Code" := xRec."IC Partner Code";

                    VendLedgEntry.RESET;
                    IF NOT VendLedgEntry.SETCURRENTKEY("Vendor No.", Open) THEN
                        VendLedgEntry.SETCURRENTKEY("Vendor No.");
                    VendLedgEntry.SETRANGE("Vendor No.", "No.");
                    VendLedgEntry.SETRANGE(Open, TRUE);
                    IF VendLedgEntry.FIND('+') THEN
                        ERROR(Text010, FIELDCAPTION("IC Partner Code"), TABLECAPTION);
                END;

                IF "IC Partner Code" <> '' THEN BEGIN
                    ICPartner.GET("IC Partner Code");
                    IF (ICPartner."Vendor No." <> '') AND (ICPartner."Vendor No." <> "No.") THEN
                        ERROR(Text008, FIELDCAPTION("IC Partner Code"), "IC Partner Code", TABLECAPTION, ICPartner."Vendor No.");
                    ICPartner."Vendor No." := "No.";
                    ICPartner.MODIFY;
                END;

                IF (xRec."IC Partner Code" <> "IC Partner Code") AND ICPartner.GET(xRec."IC Partner Code") THEN BEGIN
                    ICPartner."Vendor No." := '';
                    ICPartner.MODIFY;
                END;
            end;
        }
        field(120; Refunds; Decimal)
        {
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(Refund),
                                                                           "Entry Type" = CONST("Initial Entry"),
                                                                           "Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Refunds';
            FieldClass = FlowField;
        }
        field(121; "Refunds (LCY)"; Decimal)
        {
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(Refund),
                                                                                   "Entry Type" = CONST("Initial Entry"),
                                                                                   "Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Refunds (LCY)';
            FieldClass = FlowField;
        }
        field(122; "Other Amounts"; Decimal)
        {
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry".Amount WHERE("Initial Document Type" = CONST(" "),
                                                                           "Entry Type" = CONST("Initial Entry"),
                                                                           "Vendor No." = FIELD("No."),
                                                                           "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                           "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                           "Posting Date" = FIELD("Date Filter"),
                                                                           "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Other Amounts';
            FieldClass = FlowField;
        }
        field(123; "Other Amounts (LCY)"; Decimal)
        {
            CalcFormula = - Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Initial Document Type" = CONST(" "),
                                                                                   "Entry Type" = CONST("Initial Entry"),
                                                                                   "Vendor No." = FIELD("No."),
                                                                                   "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                   "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                   "Posting Date" = FIELD("Date Filter"),
                                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Other Amounts (LCY)';
            FieldClass = FlowField;
        }
        field(124; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(125; "Outstanding Invoices"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Outstanding Amount" WHERE("Document Type" = CONST(Invoice),
                                                                          "Pay-to Vendor No." = FIELD("No."),
                                                                          "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                          "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                          "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(126; "Outstanding Invoices (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Outstanding Amount (LCY)" WHERE("Document Type" = CONST(Invoice),
                                                                                "Pay-to Vendor No." = FIELD("No."),
                                                                                "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Outstanding Invoices (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(130; "Pay-to No. Of Archived Doc."; Integer)
        {
            CalcFormula = Count("Purchase Header Archive" WHERE("Document Type" = CONST(Order),
                                                                 "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. Of Archived Doc.';
            FieldClass = FlowField;
        }
        field(131; "Buy-from No. Of Archived Doc."; Integer)
        {
            CalcFormula = Count("Purchase Header Archive" WHERE("Document Type" = CONST(Order),
                                                                 "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'Buy-from No. Of Archived Doc.';
            FieldClass = FlowField;
        }
        field(5049; "Primary Contact No."; Code[20])
        {
            Caption = 'Primary Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Vendor);
                ContBusRel.SETRANGE("No.", "No.");
                IF ContBusRel.FINDFIRST THEN
                    Cont.SETRANGE("Company No.", ContBusRel."Contact No.")
                ELSE
                    Cont.SETRANGE("No.", '');

                IF "Primary Contact No." <> '' THEN
                    IF Cont.GET("Primary Contact No.") THEN;
                IF PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK THEN
                    VALIDATE("Primary Contact No.", Cont."No.");
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
                Contact := '';
                IF "Primary Contact No." <> '' THEN BEGIN
                    Cont.GET("Primary Contact No.");

                    ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                    ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Vendor);
                    ContBusRel.SETRANGE("No.", "No.");
                    ContBusRel.FIND('-');

                    IF Cont."Company No." <> ContBusRel."Contact No." THEN
                        ERROR(Text004, Cont."No.", Cont.Name, "No.", Name);

                    IF Cont.Type = Cont.Type::Person THEN
                        Contact := Cont.Name
                END;
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center 1";
        }
        field(5701; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(5790; "Lead Time Calculation"; DateFormula)
        {
            Caption = 'Lead Time Calculation';
        }
        field(7177; "No. of Pstd. Receipts"; Integer)
        {
            CalcFormula = Count("Purch. Rcpt. Header" WHERE("Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Pstd. Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7178; "No. of Pstd. Invoices"; Integer)
        {
            CalcFormula = Count("Purch. Inv. Header" WHERE("Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Pstd. Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7179; "No. of Pstd. Return Shipments"; Integer)
        {
            CalcFormula = Count("Return Shipment Header" WHERE("Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Pstd. Return Shipments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7180; "No. of Pstd. Credit Memos"; Integer)
        {
            CalcFormula = Count("Purch. Cr. Memo Hdr." WHERE("Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Pstd. Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7181; "Pay-to No. of Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Order),
                                                         "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7182; "Pay-to No. of Invoices"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Invoice),
                                                         "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7183; "Pay-to No. of Return Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Return Order"),
                                                         "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Return Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7184; "Pay-to No. of Credit Memos"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Credit Memo"),
                                                         "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7185; "Pay-to No. of Pstd. Receipts"; Integer)
        {
            CalcFormula = Count("Purch. Rcpt. Header" WHERE("Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Pstd. Receipts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7186; "Pay-to No. of Pstd. Invoices"; Integer)
        {
            CalcFormula = Count("Purch. Inv. Header" WHERE("Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Pstd. Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7187; "Pay-to No. of Pstd. Return S."; Integer)
        {
            CalcFormula = Count("Return Shipment Header" WHERE("Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Pstd. Return S.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7188; "Pay-to No. of Pstd. Cr. Memos"; Integer)
        {
            CalcFormula = Count("Purch. Cr. Memo Hdr." WHERE("Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Pstd. Cr. Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7189; "No. of Quotes"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Quote),
                                                         "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7190; "No. of Blanket Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Blanket Order"),
                                                         "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Blanket Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7191; "No. of Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Order),
                                                         "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Orders';
            FieldClass = FlowField;
        }
        field(7192; "No. of Invoices"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Invoice),
                                                         "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Invoices';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7193; "No. of Return Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Return Order"),
                                                         "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Return Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7194; "No. of Credit Memos"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Credit Memo"),
                                                         "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Credit Memos';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7195; "No. of Order Addresses"; Integer)
        {
            CalcFormula = Count("Order Address" WHERE("Vendor No." = FIELD("No.")));
            Caption = 'No. of Order Addresses';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7196; "Pay-to No. of Quotes"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST(Quote),
                                                         "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7197; "Pay-to No. of Blanket Orders"; Integer)
        {
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Blanket Order"),
                                                         "Pay-to Vendor No." = FIELD("No.")));
            Caption = 'Pay-to No. of Blanket Orders';
            FieldClass = FlowField;
        }
        field(7600; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar";
        }
        field(13706; "T.I.N. No."; Code[11])
        {
            Caption = 'T.I.N. No.';

            trigger OnValidate()
            begin
                IF (STRLEN("T.I.N. No.") < 11) AND ("T.I.N. No." <> '') THEN
                    ERROR(Text16501);

                IF State.GET("State Code") THEN BEGIN
                    //IF (COPYSTR((State."State Code for TIN"), 1, 2) <> COPYSTR(("T.I.N. No."), 1, 2)) AND ("T.I.N. No." <> '') THEN
                    //  ERROR('The T.I.N. no. for the state %1 should be start with %2', "State Code", COPYSTR((State."State Code for TIN"), 1, 2));
                END;
            end;
        }
        field(13710; "L.S.T. No."; Code[20])
        {
            Caption = 'L.S.T. No.';
        }
        field(13711; "C.S.T. No."; Code[20])
        {
            Caption = 'C.S.T. No.';
        }
        field(13712; "P.A.N. No."; Code[20])
        {
            Caption = 'P.A.N. No.';

            trigger OnValidate()
            begin
                IF "P.A.N. No." <> xRec."P.A.N. No." THEN
                    UpdateDedPAN;

                //ALLEDK 111012

                IF "P.A.N. No." <> '' THEN BEGIN
                    StartNo := COPYSTR("P.A.N. No.", 1, 1);
                    IF EVALUATE(VarInteger, StartNo) THEN
                        ERROR('Please define the right PAN No.');
                    StartNo := COPYSTR("P.A.N. No.", 2, 1);
                    IF EVALUATE(VarInteger, StartNo) THEN
                        ERROR('Please define the right PAN No.');
                    StartNo := COPYSTR("P.A.N. No.", 3, 1);
                    IF EVALUATE(VarInteger, StartNo) THEN
                        ERROR('Please define the right PAN No.');
                    StartNo := COPYSTR("P.A.N. No.", 4, 1);
                    IF EVALUATE(VarInteger, StartNo) THEN
                        ERROR('Please define the right PAN No.');
                    StartNo := COPYSTR("P.A.N. No.", 5, 1);
                    IF EVALUATE(VarInteger, StartNo) THEN
                        ERROR('Please define the right PAN No.');
                    StartNo := COPYSTR("P.A.N. No.", 6, 1);
                    IF NOT EVALUATE(VarInteger, StartNo) THEN
                        ERROR('Please define the right PAN No.');
                    StartNo := COPYSTR("P.A.N. No.", 7, 1);
                    IF NOT EVALUATE(VarInteger, StartNo) THEN
                        ERROR('Please define the right PAN No.');
                    StartNo := COPYSTR("P.A.N. No.", 8, 1);
                    IF NOT EVALUATE(VarInteger, StartNo) THEN
                        ERROR('Please define the right PAN No.');
                    StartNo := COPYSTR("P.A.N. No.", 9, 1);
                    IF NOT EVALUATE(VarInteger, StartNo) THEN
                        ERROR('Please define the right PAN No.');
                    StartNo := COPYSTR("P.A.N. No.", 10, 1);
                    IF EVALUATE(VarInteger, StartNo) THEN
                        ERROR('Please define the right PAN No.');
                END;
                //ALLEDK 111012
            end;
        }
        field(13713; "E.C.C. No."; Code[20])
        {
            Caption = 'E.C.C. No.';
        }
        field(13714; Range; Code[20])
        {
            Caption = 'Range';
        }
        field(13715; Collectorate; Code[20])
        {
            Caption = 'Collectorate';
        }
        field(13717; "State Code"; Code[10])
        {
            Caption = 'State Code';
            TableRelation = State;
        }
        field(13718; "Excise Bus. Posting Group"; Code[10])
        {
            Caption = 'Excise Bus. Posting Group';
            //TableRelation = "Excise Bus. Posting Group";
        }
        field(13725; SSI; Boolean)
        {
            Caption = 'SSI';
        }
        field(13726; "SSI Validity Date"; Date)
        {
            Caption = 'SSI Validity Date';
        }
        field(13728; Structure; Code[10])
        {
            Caption = 'Structure';
            //TableRelation = "Structure Header".Code;
        }
        field(13730; "Vendor Type"; Option)
        {
            Caption = 'Vendor Type';
            Description = 'ALLRE';
            OptionCaption = ' ,Manufacturer,First Stage Dealer,Second Stage Dealer,Importer,Broker,Consultant,Supplier,Transporter,Customer(ROI),Contractor';
            OptionMembers = " ",Manufacturer,"First Stage Dealer","Second Stage Dealer",Importer,Broker,Consultant,Supplier,Transporter,"Customer(ROI)",Contractor;
        }
        field(16360; Subcontractor; Boolean)
        {
            Caption = 'Subcontractor';
        }
        field(16361; "Vendor Location"; Code[20])
        {
            Caption = 'Vendor Location';
            Editable = true;
            TableRelation = Location WHERE("Subcontracting Location" = CONST(true));

            trigger OnValidate()
            var
                Location: Record Location;
            begin
                IF xRec."Vendor Location" <> Rec."Vendor Location" THEN
                    IF ("Vendor Location" <> '') THEN BEGIN
                        Location.GET("Vendor Location");
                        IF Location."Subcontractor No." = '' THEN
                            Location."Subcontractor No." := "No."
                        ELSE
                            ERROR('Location is alredy being assigned');
                    END ELSE BEGIN
                        Location.GET(xRec."Vendor Location");
                        Location."Subcontractor No." := '';
                    END;
                Location.MODIFY;
            end;
        }
        field(16362; "Commissioner's Permission No."; Text[50])
        {
            Caption = 'Commissioner''s Permission No.';
        }
        field(16471; "Service Tax Registration No."; Code[20])
        {
            Caption = 'Service Tax Registration No.';
        }
        field(16472; GTA; Boolean)
        {
            Caption = 'GTA';
        }
        field(16500; "P.A.N. Reference No."; Code[20])
        {
            Caption = 'P.A.N. Reference No.';

            trigger OnValidate()
            begin
                IF ("P.A.N. Reference No." <> xRec."P.A.N. Reference No.") THEN
                    UpdateDedPANRefNo;
            end;
        }
        field(16501; "P.A.N. Status"; Option)
        {
            Caption = 'P.A.N. Status';
            OptionCaption = ' ,PANAPPLIED,PANINVALID,PANNOTAVBL';
            OptionMembers = " ",PANAPPLIED,PANINVALID,PANNOTAVBL;

            trigger OnValidate()
            begin
                "P.A.N. No." := FORMAT("P.A.N. Status");
            end;
        }
        field(16502; Composition; Boolean)
        {
            Caption = 'Composition';
        }
        field(16503; Transporter; Boolean)
        {
            Caption = 'Transporter';
        }
        field(50000; "Related Party"; Boolean)
        {
            Description = 'JPL0002 : indicator that party is related ie. group related--JPL';
        }
        field(50001; "Net Change - Advance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Advance)));
            Caption = 'Net Change - Advance (LCY)';
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "Net Change - Running (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Running)));
            Caption = 'Net Change - Running (LCY)';
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "Net Change - Retention (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Retention)));
            Caption = 'Net Change - Retention (LCY)';
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "Net Change - Secured Adv (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER("Secured Advance")));
            Caption = 'Net Change - Secured Adv (LCY)';
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Net Change - Adhoc Adv (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER("Adhoc Advance")));
            Caption = 'Net Change - Adhoc Adv (LCY)';
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "Net Change - Provisional (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Provisional)));
            Caption = 'Net Change - Provisional (LCY)';
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50007; "Address 3"; Text[30])
        {
            Description = '--JPL';
        }
        field(50009; "Phone No. 2"; Text[30])
        {
            Description = '--JPL';
        }
        field(50010; "Mob. No."; Text[30])
        {
            Description = '--JPL';
        }
        field(50011; "Net Change - LD (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(LD)));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50012; "Vendor Category"; Option)
        {
            Description = '--JPL';
            OptionCaption = ' ,Supplier,Consultant,Sub-Contractor,Transporter,Other Vendor,IBA(Associates),Land Owners,Contractor';
            OptionMembers = " ",Supplier,Consultant,"Sub-Contractor",Transporter,"Other Vendor","IBA(Associates)","Land Owners",Contractor;
        }
        field(50013; "MSMED Classification"; Option)
        {
            Description = 'added by DDS';
            OptionCaption = ' ,NONE,MICRO,SMALL,MEDIUM';
            OptionMembers = " ","NONE",MICRO,SMALL,MEDIUM;
        }
        field(50014; Select; Boolean)
        {
            Description = 'AlleDK NTPC';
        }
        field(50015; "New Debit Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Debit Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                        "Entry Type" = FILTER(<> Application),
                                                                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                        "Posting Date" = FIELD("Date Filter"),
                                                                                        "Currency Code" = FIELD("Currency Filter"),
                                                                                        "Posting Type" = FIELD("Posting Type Filter")));
            Description = 'AlleDK 130308 using for Report';
            FieldClass = FlowField;
        }
        field(50016; "New Credit Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Credit Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                         "Entry Type" = FILTER(<> Application),
                                                                                         "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                         "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                         "Posting Date" = FIELD("Date Filter"),
                                                                                         "Currency Code" = FIELD("Currency Filter"),
                                                                                         "Posting Type" = FIELD("Posting Type Filter")));
            Description = 'AlleDK 130308 using for Report';
            FieldClass = FlowField;
        }
        field(50017; "Balance at Date (LCY)"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Description = 'dds-added as Balance LCY fld is in reverse sign';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50018; "Creation Date"; Date)
        {
            Description = 'ALLEPG 040712';
            Editable = false;
        }
        field(50019; "Verify P.A.N. No."; Boolean)
        {
            Description = 'ALLEPG 230812';
        }
        field(50020; "Net Change - Commision"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Commission)));
            Description = 'ALLEPG 310812';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50021; "Net Change - Travel Allow."; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER("Travel Allowance")));
            Description = 'ALLEPG 310812';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50023; "Net Change - Bonanza"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Bonanza)));
            Description = 'ALLEPG 310812';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50024; "Net Change - Incentive"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Incentive)));
            Description = 'ALLEPG 191012';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50026; "Salary Applicable"; Boolean)
        {
            Description = 'ALLE BBG1.00';
        }
        field(60001; "Area of Expertise"; Code[20])
        {
            Description = 'ALLESP BCL0004 11-07-2007';
            TableRelation = "Bonus Entry Posted Adjustment"."Unit No." WHERE("Entry No." = FIELD("Vendor Category"));
        }
        field(60005; "Is Employee"; Boolean)
        {
            Description = 'AlleBLK';
        }
        field(90016; "Vend. Posting Group-Advance"; Code[10])
        {
            Description = 'ALLEAS02--JPL';
            TableRelation = "Vendor Posting Group";
        }
        field(90017; "Vend. Posting Group-Running"; Code[10])
        {
            Description = 'ALLEAS02--JPL';
            TableRelation = "Vendor Posting Group";

            trigger OnValidate()
            begin
                // ALLEAS02 << <<
                "Vendor Posting Group" := "Vend. Posting Group-Running";
                // ALLEAS02 >> >>
            end;
        }
        field(90018; "Vend. Posting Group-Retention"; Code[10])
        {
            Description = 'ALLEAS02--JPL';
            TableRelation = "Vendor Posting Group";
        }
        field(90019; BHEL; Boolean)
        {
            Description = '--JPL';
        }
        field(90020; ICB; Boolean)
        {
            Description = '--JPL';
        }
        field(90021; "WCT No"; Code[20])
        {
            Description = '--JPL';
        }
        field(90022; "Order Value"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Line Amount" WHERE("Document Type" = CONST(Order),
                                                                   "Pay-to Vendor No." = FIELD("No."),
                                                                   "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                   "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                   "Currency Code" = FIELD("Currency Filter")));
            Caption = 'Order Value';
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90023; "Posting Type Filter"; Option)
        {
            Description = 'ALLEAS02--JPL';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD,Mobilization Advance,Equipment Advance';
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance";
        }
        field(90024; TempBlocked; Option)
        {
            Caption = 'TempBlocked';
            Description = 'AlleBLK';
            OptionCaption = ' ,Payment,All';
            OptionMembers = " ",Payment,All;
        }
        field(90025; "Broker %"; Decimal)
        {
            Description = 'ALLRE';
        }
        field(90026; "Validity till date"; Date)
        {
            Description = 'ALLERP KRN0014 19-08-2010:';

            trigger OnValidate()
            begin
                //ALLERP KRN0014 Start:
                ProductVendor.RESET;
                ProductVendor.SETRANGE("Vendor No.", "No.");
                IF ProductVendor.FINDSET(TRUE, FALSE) THEN
                    REPEAT
                        ProductVendor."Expiry Date" := "Validity till date";
                        ProductVendor.MODIFY;
                    UNTIL ProductVendor.NEXT = 0;
                //ALLERP KRN0014 End:
            end;
        }
        field(90027; "Authorized Agent of"; Code[20])
        {
            Description = 'ALLE PS Added field for Agent';
            TableRelation = Vendor;
        }
        field(90028; "Parent Code"; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate()
            var
                recRank: Record "Job Master";
            begin
                TESTFIELD("Rank Code");
                IF "Parent Code" = "No." THEN
                    ERROR(Text012);
                IF "Parent Code" <> '' THEN
                    IF Vendor.GET("Parent Code") THEN BEGIN
                        IF Vendor."BBG Status" = Vendor."BBG Status"::Inactive THEN
                            ERROR(Text013, Vendor."No.");
                        Vendor.TESTFIELD("BBG Rank Code");
                        IF "Rank Code" >= Vendor."BBG Rank Code" THEN
                            ERROR(Text014);
                        "Parent Rank" := Vendor."BBG Rank Code";
                        IF Introducer = '' THEN
                            Introducer := "Parent Code";  //ALLEDK 040113
                        "Old Parent Code" := Vendor."BBG Old No.";
                    END;



                IF "Parent Code" = '' THEN
                    "Parent Rank" := 0;
            end;
        }
        field(90029; "Rank Code"; Decimal)
        {
            TableRelation = Rank;

            trigger OnValidate()
            var
                Rank: Record Rank;
            begin
                IF Status IN [1, 2] THEN
                    IF Rank.GET("Rank Code") THEN
                        Rank.TESTFIELD("Direct Entry", TRUE);

                IF "Parent Code" = "No." THEN
                    ERROR(Text015);
                IF "Parent Code" <> '' THEN
                    IF Vendor.GET("Parent Code") THEN BEGIN
                        Vendor.TESTFIELD("BBG Rank Code");
                        IF Rec."Rank Code" >= Vendor."BBG Rank Code" THEN
                            ERROR('Rank cannot be greater or equal with parent.');
                    END;
            end;
        }
        field(90030; Status; Option)
        {
            Editable = true;
            OptionCaption = ' ,Provisional,Active,Inactive';
            OptionMembers = " ",Provisional,Active,Inactive;
        }
        field(90031; "Guardian Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "Guardian Name" := UPPERCASE("Guardian Name");
            end;
        }
        field(90032; "Date of Birth"; Date)
        {

            trigger OnValidate()
            begin
                /*IF "Date of Birth" = 0D THEN
                 Age := 0
                ELSE
                 BEGIN
                  Age :=ROUND(((TODAY-"Date of Birth")/365),1) ;
                  MODIFY;
                 END;
                */

            end;
        }
        field(90033; "Date of Joining"; Date)
        {
            Editable = true;

            trigger OnValidate()
            begin
                IF xRec."Date of Joining" <> 0D THEN BEGIN
                    Memberof.RESET;
                    Memberof.SETRANGE("User Name", USERID);
                    Memberof.SETRANGE("Role ID", 'JOINDATE');
                    IF NOT Memberof.FINDFIRST THEN
                        ERROR('You are not authorised to change the Date');
                END;
            end;
        }
        field(90034; Sex; Option)
        {
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(90035; "Marital Status"; Option)
        {
            OptionCaption = ' ,Unmarried,Married,Divorced,Widow,Widower,Unknown';
            OptionMembers = " ",Unmarried,Married,Divorced,Widow,Widower,Unknown;
        }
        field(90036; "Present Occupation"; Text[50])
        {

            trigger OnValidate()
            begin
                "Present Occupation" := UPPERCASE("Present Occupation");
                CASE "Present Occupation" OF
                    'B':
                        VALIDATE("Present Occupation", 'BUSINESS');
                    'S':
                        VALIDATE("Present Occupation", 'SERVICE');
                    'H':
                        VALIDATE("Present Occupation", 'HOUSEWIFE');
                    'C':
                        VALIDATE("Present Occupation", 'CULTIVATION');
                    'ST':
                        VALIDATE("Present Occupation", 'STUDENT');
                    'P':
                        VALIDATE("Present Occupation", 'PROFESSIONAL');
                    'N':
                        VALIDATE("Present Occupation", 'NIL');
                    'O':
                        VALIDATE("Present Occupation", 'OTHER');
                END;
                "Present Occupation" := UPPERCASE("Present Occupation");
            end;
        }
        field(90037; Nationality; Text[30])
        {

            trigger OnValidate()
            begin
                Nationality := UPPERCASE(Nationality);
            end;
        }
        field(90038; "Nominee Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "Nominee Name" := UPPERCASE("Nominee Name");
            end;
        }
        field(90039; "Nominee Address"; Text[50])
        {
            Caption = 'Address';

            trigger OnValidate()
            begin
                CASE "Nominee Address" OF
                    'A':
                        VALIDATE("Nominee Address", 'AS ABOVE');
                END;
                "Nominee Address" := UPPERCASE("Nominee Address");
            end;
        }
        field(90040; "Nominee Address 2"; Text[50])
        {
            Caption = 'Address 2';

            trigger OnValidate()
            begin
                "Nominee Address 2" := UPPERCASE("Nominee Address 2");
            end;
        }
        field(90041; "Nominee District"; Text[30])
        {
            Caption = 'District';

            trigger OnValidate()
            begin
                "Nominee District" := UPPERCASE("Nominee District");
            end;
        }
        field(90042; "Nominee Title"; Option)
        {
            OptionCaption = 'Mr.,Mrs,Miss';
            OptionMembers = "Mr.",Mrs,Miss;
        }
        field(90043; "Nominee Pin"; Code[6])
        {
        }
        field(90044; "Nominee State"; Code[20])
        {

            trigger OnValidate()
            begin
                "Nominee State" := UPPERCASE("Nominee State");
                CASE "Nominee State" OF
                    'W':
                        VALIDATE("Nominee State", 'WESTBENGAL');
                    'A':
                        VALIDATE("Nominee State", 'ASSAM');
                    'O':
                        VALIDATE("Nominee State", 'ORISSA');
                    'B':
                        VALIDATE("Nominee State", 'BIHAR');
                    'J':
                        VALIDATE("Nominee State", 'JHARKHAND');
                    'U':
                        VALIDATE("Nominee State", 'UTTARPRADESH');
                END;
                "Nominee State" := UPPERCASE("Nominee State");
            end;
        }
        field(90045; "Nominee Age"; Integer)
        {
            MaxValue = 99;
            MinValue = 1;
        }
        field(90046; Relation; Text[30])
        {

            trigger OnValidate()
            begin
                Relation := UPPERCASE(Relation);
                CASE Relation OF
                    'F':
                        VALIDATE(Relation, 'FATHER');
                    'M':
                        VALIDATE(Relation, 'MOTHER');
                    'H':
                        VALIDATE(Relation, 'HUSBAND');
                    'W':
                        VALIDATE(Relation, 'WIFE');
                    'U':
                        VALIDATE(Relation, 'UNCLE');
                    'A':
                        VALIDATE(Relation, 'AUNT');
                    'B':
                        VALIDATE(Relation, 'BROTHER');
                    'S':
                        VALIDATE(Relation, 'SON');
                    'D':
                        VALIDATE(Relation, 'DAUGHTER');
                    'SI':
                        VALIDATE(Relation, 'SISTER');
                    'G':
                        VALIDATE(Relation, 'GRANDSON');
                    'N':
                        VALIDATE(Relation, 'NEPHEW');
                    'NI':
                        VALIDATE(Relation, 'NIECE');
                    'O':
                        VALIDATE(Relation, 'OTHER');
                END;
                Relation := UPPERCASE(Relation);
            end;
        }
        field(90047; "Nominee Sex"; Option)
        {
            OptionMembers = Male,Female;
        }
        field(90048; Suspended; Boolean)
        {
            Editable = false;
        }
        field(90049; "Hold Payables"; Boolean)
        {
        }
        field(90050; "No. of Joinings"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count(Vendor WHERE("BBG Parent Code" = FIELD("No."),
                                              "BBG Date of Joining" = FIELD("Date Filter")));
            Editable = false;

        }
        field(90051; "Self Business Amount"; Decimal)
        {
            Editable = false;
        }
        field(90052; "Commission Voucher Generated"; Boolean)
        {
            Editable = false;
        }
        field(90053; "Bonus Not Allowed"; Boolean)
        {
        }
        field(90054; "Parent Rank"; Decimal)
        {
            Editable = false;
            TableRelation = Rank;

            trigger OnValidate()
            var
                recRank: Record "Job Master";
            begin
            end;
        }
        field(90055; "Eligibility Rate"; Decimal)
        {
        }
        field(90056; "Eligibility Amount"; Decimal)
        {
        }
        field(90057; "Total Allocated"; Decimal)
        {
        }
        field(90058; "Balance to Allocate"; Decimal)
        {
        }
        field(90059; "Associate Level"; Integer)
        {
        }
        field(90060; "Old No."; Code[10])
        {

            trigger OnValidate()
            begin
                IF "Old No." <> '' THEN BEGIN
                    RecVendor.RESET;
                    RecVendor.SETRANGE("BBG Old No.", "Old No.");
                    IF RecVendor.FINDFIRST THEN
                        ERROR('Vendor No. already Exists');
                END;
            end;
        }
        field(90061; "Associate Creation"; Option)
        {
            OptionCaption = ' ,Existing,New';
            OptionMembers = " ",Existing,New;
        }
        field(90062; Introducer; Code[20])
        {
            TableRelation = Vendor;
        }
        field(90063; "Old Parent Code"; Code[10])
        {
        }
        field(90064; "Commission Amount Qualified"; Decimal)
        {
            CalcFormula = Sum("Commission Entry"."Commission Amount" WHERE("Associate Code" = FIELD("No."),
                                                                            "Voucher No." = FILTER('')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90065; "Travel Amount Qualified"; Decimal)
        {
            CalcFormula = Sum("Travel Payment Entry"."Amount to Pay" WHERE("Sub Associate Code" = FIELD("No."),
                                                                            "Voucher No." = FILTER('')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90066; "Incentive Amount Qualified"; Decimal)
        {
            CalcFormula = Sum("Incentive Summary"."Payable Incentive Amount" WHERE("Associate Code" = FIELD("No."),
                                                                                    "Voucher No." = FILTER('')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90067; "Total Balance Amount"; Decimal)
        {
            Editable = false;
        }
        field(90068; "Old Introducer"; Code[10])
        {
        }
        field(90069; Designation; Text[30])
        {
            CalcFormula = Lookup(Rank.Description WHERE(Code = FIELD("Rank Code")));
            Description = 'ALLECK 040413';
            FieldClass = FlowField;
        }
        field(90070; "Archive Date"; Date)
        {
            Description = 'ALLECK 190413';
        }
        field(90071; "Archive Time"; Time)
        {
            Description = 'ALLECK 190413';
        }
        field(90072; Version; Integer)
        {
            Description = 'ALLECK 190413';
        }
        field(90073; "User Id"; Code[20])
        {
            Description = 'ALLECK 190413';
        }
        field(90074; Archived; Boolean)
        {
            Description = 'ALLECK 190413';
        }
        field(90075; Remarks; Text[60])
        {
            Description = 'ALLECK 200413';
        }
    }

    keys
    {
        key(Key1; "No.", Version)
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; "Vendor Posting Group")
        {
        }
        key(Key4; "Currency Code")
        {
        }
        key(Key5; Priority)
        {
        }
        key(Key6; "Country/Region Code")
        {
        }
        key(Key7; "Gen. Bus. Posting Group")
        {
        }
        key(Key8; "VAT Registration No.")
        {
        }
        key(Key9; Name)
        {
        }
        key(Key10; City)
        {
        }
        key(Key11; "P.A.N. No.")
        {
        }
        key(Key12; "Post Code")
        {
        }
        key(Key13; "Phone No.")
        {
        }
        key(Key14; Contact)
        {
        }
        key(Key15; "Rank Code")
        {
        }
        key(Key16; "Parent Code")
        {
        }
        key(Key17; "Global Dimension 1 Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, City, "Post Code", "Phone No.", Contact)
        {
        }
    }

    trigger OnDelete()
    var
        ItemVendor: Record "Item Vendor";
        PurchPrice: Record "Purchase Price";
        PurchLineDiscount: Record "Purchase Line Discount";
        PurchPrepmtPct: Record "Purchase Prepayment %";
    begin
    end;

    var
        Text000: Label 'You cannot delete %1 %2 because there is at least one outstanding Purchase %3 for this vendor.';
        Text002: Label 'You have set %1 to %2. Do you want to update the %3 price list accordingly?';
        Text003: Label 'Do you wish to create a contact for %1 %2?';
        PurchSetup: Record "Purchases & Payables Setup";
        CommentLine: Record "Comment Line";
        PurchOrderLine: Record "Purchase Line";
        PostCode: Record "Post Code";
        VendBankAcc: Record "Vendor Bank Account";
        OrderAddr: Record "Order Address";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        //ItemCrossReference: Record 5717;
        RMSetup: Record "Marketing Setup";
        ServiceItem: Record "Service Item";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        MoveEntries: Codeunit MoveEntries;
        UpdateContFromVend: Codeunit "VendCont-Update";
        DimMgt: Codeunit DimensionManagement;
        InsertFromContact: Boolean;
        Text004: Label 'Contact %1 %2 is not related to vendor %3 %4.';
        Text005: Label 'post';
        Text006: Label 'create';
        Text007: Label 'You cannot %1 this type of document when Vendor %2 is blocked with type %3';
        Text008: Label 'The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3.';
        Text009: Label 'Reconciling IC transactions may be difficult if you change IC Partner Code because this %1 has ledger entries in a fiscal year that has not yet been closed.\ Do you still want to change the IC Partner Code?';
        Text010: Label 'You cannot change the contents of the %1 field because this %2 has one or more open ledger entries.';
        Text011: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        Text16500: Label 'P.A.N. cannot be updated unless the P.A.N. status is blank.';
        State: Record State; //13762;
        Text16501: Label 'T.I.N. no. should not be less then 11 characters.';
        "---Alle()---": Integer;
        //MasterSetup: Record 97742;
        RecRef: RecordRef;
        VendCat: Text[9];
        LastVend: Text[9];
        ProductVendor: Record "Product Vendor";
        Text012: Label 'Parent code should not be same as Code.';
        Vendor: Record Vendor;
        Text013: Label 'MM %1 is Inactive.';
        Text014: Label 'Rank cannot be greater or equal with parent.';
        Text015: Label 'Parent code should not be same as Code.';
        Text016: Label 'Duplicate PAN No.';
        Text017: Label 'Duplicate Acknowledgement Receipt No.';
        Text018: Label 'P.A.N. No. should be of 10 digits.';
        StartNo: Text[10];
        VarInteger: Integer;
        RecVendor: Record Vendor;
        Vend: Record Vendor;
        Memberof: Record "Access Control";


    procedure AssistEdit(OldVend: Record Vendor): Boolean
    var
        Vend: Record Vendor;
    begin
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;


    procedure ShowContact()
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
    begin
    end;


    procedure SetInsertFromContact(FromContact: Boolean)
    begin
    end;


    procedure CheckBlockedVendOnDocs(Vend2: Record Vendor; Transaction: Boolean)
    begin
    end;


    procedure CheckBlockedVendOnJnls(Vend2: Record Vendor; DocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge",Reminder,Refund; Transaction: Boolean)
    begin
    end;


    procedure VendBlockedErrorMessage(Vend2: Record Vendor; Transaction: Boolean)
    var
        "Action": Text[30];
    begin
    end;


    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
    end;

    local procedure UpdateDedName()
    var
    // Form26Q27QEntry: Record 16505;
    begin
    end;

    local procedure UpdateDedPAN()
    var
    // Form26Q27QEntry: Record 16505;
    begin
    end;

    local procedure UpdateDedPANRefNo()
    var
    //Form26Q27QEntry: Record 16505;
    begin
    end;


    procedure HistoryFunction(FunctionNo: Integer; Comment: Text[30])
    begin
    end;


    procedure NODExists(): Boolean
    var
        BondSetup: Record "Unit Setup";
    //NODLine: Record 13785;
    begin
    end;


    procedure CreateNOD()
    var
        BondSetup: Record "Unit Setup";
    //NODHeader: Record 13786;
    //NODLine: Record 13785;
    begin
    end;


    procedure CreateVendorFromWeb(NewVendor: Record "Portal Login"; var VendorNo: Code[30]): Code[30]
    var
        Vendor1: Record Vendor;
    begin
    end;
}

