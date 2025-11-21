table 50068 "De-Activate Vendors"
{
    Caption = 'De-Activate Vendors';
    DataCaptionFields = "No.", Name;
    DataPerCompany = false;
    DrillDownPageID = "Vendor List";
    LookupPageID = "Vendor List";
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

            trigger OnValidate()
            var
                v_RegionwiseVendor: Record "Region wise Vendor";
            begin
            end;
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
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
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
        }
        field(17; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
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
        field(29; "Purchaser Code"; Code[20])
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
                                                                           "Currency Code" = FIELD("Currency Filter")));
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
                                                                                   "Currency Code" = FIELD("Currency Filter")));
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
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
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
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
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
                VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
            begin
            end;
        }
        field(88; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(89; Picture; BLOB)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(90; GLN; Code[13])
        {
            Caption = 'GLN';
            Numeric = true;

            trigger OnValidate()
            var
                GLNCalculator: Codeunit "GLN Calculator";
            begin
            end;
        }
        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                v_PostCode: Record "Post Code";
            begin
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
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
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
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
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
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
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
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
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
        field(132; "Partner Type"; Option)
        {
            Caption = 'Partner Type';
            OptionCaption = ' ,Company,Person';
            OptionMembers = " ",Company,Person;
        }
        field(150; "Privacy Blocked"; Boolean)
        {
            Caption = 'Privacy Blocked';
        }
        field(170; "Creditor No."; Code[20])
        {
            Caption = 'Creditor No.';
        }
        field(288; "Preferred Bank Account"; Code[10])
        {
            Caption = 'Preferred Bank Account';
            TableRelation = "Vendor Bank Account".Code WHERE("Vendor No." = FIELD("No."));
        }
        field(840; "Cash Flow Payment Terms Code"; Code[10])
        {
            Caption = 'Cash Flow Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(5049; "Primary Contact No."; Code[20])
        {
            Caption = 'Primary Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
                TempVend: Record Vendor temporary;
            begin
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusRel: Record "Contact Business Relation";
            begin
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
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
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
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
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
            AccessByPermission = TableData "Return Shipment Header" = R;
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
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            CalcFormula = Count("Purchase Header" WHERE("Document Type" = CONST("Blanket Order"),
                                                         "Buy-from Vendor No." = FIELD("No.")));
            Caption = 'No. of Blanket Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7191; "No. of Orders"; Integer)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
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
            AccessByPermission = TableData "Return Shipment Header" = R;
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
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
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
        field(16473; "Service Entity Type"; Code[20])
        {
            Caption = 'Service Entity Type';
            TableRelation = "Service Entity Type";
        }
        field(16500; "P.A.N. Reference No."; Code[20])
        {
            Caption = 'P.A.N. Reference No.';
        }
        field(16501; "P.A.N. Status"; Option)
        {
            Caption = 'P.A.N. Status';
            OptionCaption = ' ,PANAPPLIED,PANINVALID,PANNOTAVBL';
            OptionMembers = " ",PANAPPLIED,PANINVALID,PANNOTAVBL;
        }
        field(16502; Composition; Boolean)
        {
            Caption = 'Composition';
        }
        field(16503; Transporter; Boolean)
        {
            Caption = 'Transporter';
        }
        field(16600; "GST Registration No."; Code[15])
        {
            Caption = 'GST Registration No.';
        }
        field(16609; "GST Vendor Type"; Option)
        {
            Caption = 'GST Vendor Type';
            OptionCaption = ' ,Registered,Composite,Unregistered,Import,Exempted,SEZ';
            OptionMembers = " ",Registered,Composite,Unregistered,Import,Exempted,SEZ;
        }
        field(16610; "Associated Enterprises"; Boolean)
        {
            Caption = 'Associated Enterprises';
        }
        field(16611; "Aggregate Turnover"; Option)
        {
            Caption = 'Aggregate Turnover';
            OptionCaption = 'More than 20 lakh,Less than 20 lakh';
            OptionMembers = "More than 20 lakh","Less than 20 lakh";
        }
        field(16612; "ARN No."; Code[15])
        {
            Caption = 'ARN No.';
        }
        field(50000; "Related Party"; Boolean)
        {
            DataClassification = ToBeClassified;
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
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50009; "Phone No. 2"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50010; "Mob. No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';

            trigger OnValidate()
            var
                OldVendor: Record Vendor;
            begin
            end;
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
            DataClassification = ToBeClassified;
            Description = '--JPL';
            OptionCaption = ' ,Supplier,Consultant,Sub-Contractor,Transporter,Other Vendor,IBA(Associates),Land Owners,Contractor,Land Vendor';
            OptionMembers = " ",Supplier,Consultant,"Sub-Contractor",Transporter,"Other Vendor","IBA(Associates)","Land Owners",Contractor,"Land Vendor";
        }
        field(50013; "MSMED Classification"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'added by DDS';
            OptionCaption = ' ,NONE,MICRO,SMALL,MEDIUM';
            OptionMembers = " ","NONE",MICRO,SMALL,MEDIUM;
        }
        field(50014; Select; Boolean)
        {
            DataClassification = ToBeClassified;
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
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 040712';
            Editable = false;
        }
        field(50019; "Verify P.A.N. No."; Boolean)
        {
            DataClassification = ToBeClassified;
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
            DataClassification = ToBeClassified;
            Description = 'ALLE BBG1.00';
        }
        field(50030; "TA Applicable on Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG1.2 201213';
        }
        field(50031; "Vendor Card Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(50049; "Associate Responcbility Center"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50051; "Web User_ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50071; "Associate Respcenter Code"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50081; "Land Master"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG2.0';
        }
        field(50100; "Black List"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Vendor_2: Record Vendor;
            begin
            end;
        }
        field(50101; "Print Associate Name/Mobile"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Vendor_1: Record Vendor;
            begin
            end;
        }
        field(50102; "Credit Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Cluster Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Hyderabad,Vizag,Vijaywada,Shadnagar,Yadagiri Gutta,Nellore,Srikakulam';
            OptionMembers = " ",Hyderabad,Vizag,Vijaywada,Shadnagar,"Yadagiri Gutta",Nellore,Srikakulam;
        }
        field(50104; "Alternate Name"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(50105; "Web Associate Payment Active"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50106; "Cluster Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Reporting Office Master";
        }
        field(50107; "Top Associate for Gamification"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50201; "Report 50011 Run for Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50202; "Report 50041 Run for Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50203; "Report 50082 Run for Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50204; "Report 57782 Run for Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '97782 Report';
        }
        field(50205; "Report 50096 Run for Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50206; "RERA No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                CharacterLength: Integer;
            begin
            end;
        }
        field(50207; "RERA Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Unregistered,Registered';
            OptionMembers = Unregistered,Registered;
        }
        field(50208; "206AB"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'TDS Related';
        }
        field(50302; "Address Proof Type"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50304; "Team Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Team Master";
        }
        field(50305; "Leader Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Leader Master";
        }
        field(50306; "Sub Team Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sub Team Master";
        }
        field(50307; Deactivate; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50308; "Rank Parents"; Code[20])
        {
            CalcFormula = Lookup("Region wise Vendor"."Parent Code" WHERE("Parent Code" = FIELD("No.")));
            FieldClass = FlowField;
        }
        //251124 New field added Start
        field(50310; "Associate Type"; Option)
        {
            Caption = 'Associate Type';
            OptionCaption = 'Temporary, Permanent';
            OptionMembers = Temporary,Permanent;

        }
        field(50311; "Presence on Social Media"; Text[60])
        {
            DataClassification = ToBeClassified;
        }
        field(50312; "Reporting Leader"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50313; "Reporting Leader Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50314; "Is Help Desk User"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50315; "Payable G/L Account No."; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup("Vendor Posting Group"."Payables Account" WHERE(Code = FIELD("Vendor Posting Group")));
            TableRelation = "G/L Account";
            Editable = false;
        }
        field(50316; "New Cluster Code"; Code[20])
        {
            TableRelation = "New Cluster Master";
            DataClassification = ToBeClassified;
        }
        field(50320; "INOPERATIVE PAN"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

        //251124 New field added END
        field(60001; "Area of Expertise"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 11-07-2007';
            TableRelation = "Bonus Entry Posted Adjustment"."Unit No." WHERE("Entry No." = FIELD("Vendor Category"));
        }
        field(60002; "Rank Parent exists"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60005; "Is Employee"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(60006; "Temp Address"; Text[50])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
            Description = 'BBG2.11 230714';
        }
        field(60007; "Temp Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
            Description = 'BBG2.11 230714';
        }
        field(60008; "Temp Address 3"; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG2.11 230714';
        }
        field(60009; "Temp Mob. No."; Text[30])
        {
            DataClassification = ToBeClassified;
            Description = 'BBG2.11 230714';
        }
        field(90016; "Vend. Posting Group-Advance"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL';
            TableRelation = "Vendor Posting Group";
        }
        field(90017; "Vend. Posting Group-Running"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL';
            TableRelation = "Vendor Posting Group";
        }
        field(90018; "Vend. Posting Group-Retention"; Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL';
            TableRelation = "Vendor Posting Group";
        }
        field(90019; BHEL; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(90020; ICB; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(90021; "WCT No"; Code[20])
        {
            DataClassification = ToBeClassified;
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
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionCaption = ' ,Payment,All';
            OptionMembers = " ",Payment,All;
        }
        field(90025; "Broker %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLRE';
        }
        field(90026; "Validity till date"; Date)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLERP KRN0014 19-08-2010:';
        }
        field(90027; "Authorized Agent of"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLE PS Added field for Agent';
            TableRelation = Vendor;
        }
        field(90028; "Parent Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            var
                recRank: Record "Job Master";
            begin
            end;
        }
        field(90029; "Rank Code"; Decimal)
        {
            DataClassification = ToBeClassified;
            TableRelation = Rank;

            trigger OnValidate()
            var
                Rank: Record Rank;
            begin
            end;
        }
        field(90030; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = ' ,Provisional,Active,Inactive';
            OptionMembers = " ",Provisional,Active,Inactive;
        }
        field(90031; "Guardian Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90032; "Date of Birth"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90033; "Date of Joining"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(90034; Sex; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(90035; "Marital Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Unmarried,Married,Divorced,Widow,Widower,Unknown';
            OptionMembers = " ",Unmarried,Married,Divorced,Widow,Widower,Unknown;
        }
        field(90036; "Present Occupation"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90037; Nationality; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90038; "Nominee Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90039; "Nominee Address"; Text[50])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
        }
        field(90040; "Nominee Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
        }
        field(90041; "Nominee District"; Text[30])
        {
            Caption = 'District';
            DataClassification = ToBeClassified;
        }
        field(90042; "Nominee Title"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Mr.,Mrs,Miss';
            OptionMembers = "Mr.",Mrs,Miss;
        }
        field(90043; "Nominee Pin"; Code[6])
        {
            DataClassification = ToBeClassified;
        }
        field(90044; "Nominee State"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90045; "Nominee Age"; Integer)
        {
            DataClassification = ToBeClassified;
            MaxValue = 99;
            MinValue = 1;
        }
        field(90046; Relation; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90047; "Nominee Sex"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Male,Female;
        }
        field(90048; Suspended; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90049; "Hold Payables"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90050; "No. of Joinings"; Integer)
        {
            CalcFormula = Count(Vendor WHERE("BBG Parent Code" = FIELD("No."),
                                              "BBG Date of Joining" = FIELD("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90051; "Self Business Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90052; "Commission Voucher Generated"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90053; "Bonus Not Allowed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90054; "Parent Rank"; Decimal)
        {
            DataClassification = ToBeClassified;
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
            DataClassification = ToBeClassified;
        }
        field(90056; "Eligibility Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90057; "Total Allocated"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90058; "Balance to Allocate"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90059; "Associate Level"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(90060; "Old No."; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(90061; "Associate Creation"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Existing,New';
            OptionMembers = " ",Existing,New;
        }
        field(90062; Introducer; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(90063; "Old Parent Code"; Code[10])
        {
            DataClassification = ToBeClassified;
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
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(90068; "Old Introducer"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(90069; Designation; Text[30])
        {
            CalcFormula = Lookup(Rank.Description WHERE(Code = FIELD("Rank Code")));
            Description = 'ALLECK 040413';
            FieldClass = FlowField;
        }
        field(90072; Version; Integer)
        {
            CalcFormula = Max("Archive Vendor".Version WHERE("No." = FIELD("No.")));
            Description = 'ALLECK 190413';
            FieldClass = FlowField;
        }
        field(90074; Archived; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'ALLECK 190413';
        }
        field(90075; Remarks; Text[60])
        {
            DataClassification = ToBeClassified;
            Description = 'ALLECK 200413';
        }
        field(90076; "Message for Ass. Creation"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG1.00 250613';
            Editable = false;
        }
        field(90077; GTA; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'test';
        }
        field(90078; "Old Nav Vend No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(90079; "Copy IBA in Company"; Text[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = Company;
        }
        field(90080; "vendor not find"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90081; "Rank lookup Mode"; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Region wise Vendor" WHERE("No." = FIELD("No."));
        }
        field(90082; "Comm Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90083; "RemComm Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90084; "TA Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90085; "RemTA Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90086; "Ass Invoice Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90087; "Check Record"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90088; "CommTA Eligible Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90089; "Blocked New"; Option)
        {
            Caption = 'Blocked New';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Payment,All';
            OptionMembers = " ",Payment,All;
        }
        field(90090; CommAmt; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90091; "TDS Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90092; "Club9 Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90093; "Payment Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90094; "CommTA Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90095; "Comm Associate"; Code[20])
        {
            CalcFormula = Lookup("Commission Entry"."Associate Code" WHERE("Associate Code" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(90096; "TA Associate"; Code[20])
        {
            CalcFormula = Lookup("Travel Payment Entry"."Sub Associate Code" WHERE("Sub Associate Code" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(90097; "Commission Report for Associat"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90098; "In-Active Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90099; "Data active for Associate"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90100; "Associate Password"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90101; "Ass.Block forteam Pos. Report"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Associate block for Team positive Report 97855';
        }
        field(90102; "Allow All Pmt. to Land Vend"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90103; "Allow First Pmt. to Land Vend"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //251124 New field added Start
        Field(90105; "Old P.A.N. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(90106; Age; Integer)
        {
            DataClassification = ToBeClassified;
        }
        Field(90107; "Father Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90108; "Create from Web/Mobile"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90109; "Send for Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90110; "Send for Aproval Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90111; "Approval Status"; Option)
        {

            Caption = 'Approval Status';
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;

            Editable = false;
        }
        field(90112; "Send for Approval BlackList"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90113; "Send for Aproval Date BList"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90114; "Approval Status BlackList"; Option)
        {
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;

            Editable = false;
        }
        field(90115; "Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90116; "Communication Address"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90117; "Communication Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90118; "CP Designation"; Option)
        {

            Caption = 'CP Designation';
            OptionCaption = ' ,Firm,Platinum,Gold,Silver';
            OptionMembers = " ",Firm,Platinum,Gold,Silver;

        }
        field(90119; "Date of Incorporation"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90120; "Website (for company)"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(90121; "Name (Point of Contact)"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90123; "Email (Point of Contact)"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90124; "Membership of association"; Option)
        {

            OptionCaption = ' ,CREDAI,TREDA,RERA,Other';
            OptionMembers = " ",CREDAI,TREDA,RERA,Other;

        }
        field(90125; "Membership Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90126; "Registration No"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90127; "Expiry date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90128; "ESI NO"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90129; "PF No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(90130; "Communication City"; Text[30])
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;
            TestTableRelation = false;
            DataClassification = ToBeClassified;

        }
        field(90131; "Communication State Code"; Code[10])
        {
            TableRelation = State;
            DataClassification = ToBeClassified;
        }

        field(90132; "Communication Post Code"; Code[20])
        {
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            ValidateTableRelation = false;
            TestTableRelation = false;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            VAR
                v_PostCode: Record "Post Code";
            BEGIN

            END;


        }

        Field(90152; "Entity Type"; Option)
        {
            Caption = 'Associate Type';
            OptionCaption = ' ,individual,sales propritorship,partenership firm,LLP,public limited,private Limited,other any';
            OptionMembers = " ",individual,"sales propritorship","partenership firm",LLP,"public limited","private Limited","other any";

        }
        field(90153; "CP Team Code"; Code[20])
        {
            TableRelation = "CP Team Master"."Team Code";
            DataClassification = ToBeClassified;
        }
        field(90154; "CP Leader Code"; Code[20])
        {
            TableRelation = "CP Leader Master"."Leader Code";
            DataClassification = ToBeClassified;
        }
        field(90155; "Last Previous Year"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90156; "Second Previous Year"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90157; "Third Previous Year"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(90158; "Aadhar No."; Code[15])
        {
            DataClassification = ToBeClassified;
        }


        //251124 New field added END
        field(90204; "Batch Run Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90205; "Batch Run Time"; Time)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90206; "Batch Run By"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
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
        key(Key11; "Post Code")
        {
        }
        key(Key12; "Phone No.")
        {
        }
        key(Key13; Contact)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name, City, "Post Code", "Phone No.", Contact)
        {
        }
        fieldgroup(Brick; "No.", Name, "Balance (LCY)", Contact, "Balance Due (LCY)")
        {
        }
    }

    trigger OnDelete()
    var
        ItemVendor: Record "Item Vendor";
        PurchPrice: Record "Purchase Price";
        PurchLineDiscount: Record "Purchase Line Discount";
        PurchPrepmtPct: Record "Purchase Prepayment %";
        //SocialListeningSearchTopic: Record 871;
        CustomReportSelection: Record "Custom Report Selection";
        CompanyInformation: Record "Company Information";
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
        usersetup: Record "User Setup";
    begin
    end;

    trigger OnModify()
    var
        V_Vendor: Record Vendor;
        Company: Record Company;
    begin
    end;
}

