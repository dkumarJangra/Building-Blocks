page 97931 "Vendor Card for others"
{
    // //JPL : Code from JPL
    // //NDALLE 051107 Commented
    // ALLERP AlleHF 07-09-2010: Applying HF1 to HF5
    // ALLEPG 270711 :   Added HotFix PS59643 for Service Tax.
    // ALLEPG 310812 : Added Fields.
    // 
    // //ALLEDK 030313 Code comment
    // //ALLECK 130313 Code commented for MM Chain Management
    // ALLECK 200413 : Added code for Release & ReOpen based on Role
    // BBG2.01 22/07/14 Addedd code for visibility false if user not have permission
    // //BBG2.10 Added code for address

    Caption = 'Vendor Card';
    DelayedInsert = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Vendor;
    SourceTableView = WHERE("BBG Vendor Category" = FILTER(<> "IBA(Associates)"));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Old Nav Vend No."; Rec."BBG Old Nav Vend No.")
                {
                    Caption = 'Old Vendor No.';
                }
                field("Vendor Category"; Rec."BBG Vendor Category")
                {
                    Style = Attention;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        IF Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)" THEN
                            ERROR('Vendor Category should not be IBA Associates');
                    end;
                }
                field(Name; Rec.Name)
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Mob. No."; Rec."BBG Mob. No.")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    Visible = "Mob. No.Visible";
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Tax Liable"; Rec."Tax Liable")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("State Code"; Rec."State Code")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Name 2"; Rec."Name 2")
                {
                }
                field(Address; Rec.Address)
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                    Visible = AddressVisible;
                }
                field("Address 2"; Rec."Address 2")
                {
                    Visible = "Address 2Visible";
                }
                field("Post Code"; Rec."Post Code")
                {
                    Caption = 'Post Code/City';
                }
                field(City; Rec.City)
                {
                }
                field(Contact; Rec.Contact)
                {
                    Editable = ContactEditable;
                    Visible = ContactVisible;

                    trigger OnValidate()
                    begin
                        ContactOnAfterValidate;
                    end;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field("P.A.N. Status"; Rec."P.A.N. Status")
                {
                }
                field("P.A.N. No."; Rec."P.A.N. No.")
                {
                    Editable = "P.A.N. No.Editable";
                }
                field("Creation Date"; Rec."BBG Creation Date")
                {
                }
                field("GetDescription.GetNODExist(No.)";
                GetDescription.GetNODExist(Rec."No."))
                {
                    Caption = 'NOD Exists';
                }
                field("Salary Applicable"; Rec."BBG Salary Applicable")
                {
                }
                field("Old No."; Rec."BBG Old No.")
                {
                    Editable = false;
                }
                field(Archived; Archived)
                {
                }
                field("Copy IBA in Company"; Rec."BBG Copy IBA in Company")
                {
                }
                field("Print Associate Name/Mobile"; Rec."BBG Print Associate Name/Mobile")
                {

                    trigger OnValidate()
                    begin
                        CLEAR(MemberOf);
                        MemberOf.RESET;
                        MemberOf.SETRANGE("User Name", USERID);
                        MemberOf.SETRANGE("Role ID", 'A_IBACREATION');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('Please contact Admin');
                    end;
                }
                field("Cluster Type"; Rec."BBG Cluster Type")
                {
                }
                label("1")
                {
                    CaptionClass = Text19060128;
                    Style = Unfavorable;
                    StyleExpr = TRUE;
                }
                field("In-Active Associate"; Rec."BBG In-Active Associate")
                {
                }
                field("Search Name"; Rec."Search Name")
                {
                }
                field("Balance at Date (LCY)"; Rec."BBG Balance at Date (LCY)")
                {

                    trigger OnDrillDown()
                    var
                        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
                        VendLedgEntry: Record "Vendor Ledger Entry";
                    begin

                        DtldVendLedgEntry.SETRANGE("Vendor No.", Rec."No.");
                        Rec.COPYFILTER("Global Dimension 1 Filter", DtldVendLedgEntry."Initial Entry Global Dim. 1");
                        Rec.COPYFILTER("Global Dimension 2 Filter", DtldVendLedgEntry."Initial Entry Global Dim. 2");
                        Rec.COPYFILTER("Currency Filter", DtldVendLedgEntry."Currency Code");
                        VendLedgEntry.DrillDownOnEntries(DtldVendLedgEntry);
                    end;
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                }
                field("Net Change - Advance (LCY)"; Rec."BBG Net Change - Advance (LCY)")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Net Change - Running (LCY)"; Rec."BBG Net Change - Running (LCY)")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Net Change - Retention (LCY)"; Rec."BBG Net Change - Retention (LCY)")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Net Change - Secured Adv (LCY)"; Rec."BBG Net Change - Secured Adv (LCY)")
                {
                    Editable = false;
                }
                field("Net Change - Adhoc Adv (LCY)"; Rec."Net Change - Adhoc Adv (LCY)")
                {
                    Editable = false;
                }
                field("Net Change - Provisional (LCY)"; Rec."BBG Net Change - Provisional (LCY)")
                {
                    Editable = false;
                }
                field("Net Change - LD (LCY)"; Rec."BBG Net Change - LD (LCY)")
                {
                    Editable = false;
                }
                field("Net Change - Commision"; Rec."BBG Net Change - Commision")
                {
                }
                field("Net Change - Travel Allow."; Rec."BBG Net Change - Travel Allow.")
                {
                }
                field("Net Change - Bonanza"; Rec."BBG Net Change - Bonanza")
                {
                }
                field("Net Change - Incentive"; Rec."BBG Net Change - Incentive")
                {
                }
                field("Net Change (LCY)"; Rec."Net Change (LCY)")
                {
                }
                field("Validity till date"; Rec."BBG Validity till date")
                {
                }
                field("Primary Contact No."; Rec."Primary Contact No.")
                {
                    Visible = true;
                }
                field(Introducer; Rec."BBG Introducer")
                {
                }
                field(Status; Rec."BBG Status")
                {
                }
                field(Suspended; Rec."BBG Suspended")
                {
                }
                field("Hold Payables"; Rec."BBG Hold Payables")
                {
                }
                field("No. of Joinings"; Rec."BBG No. of Joinings")
                {
                }
                field("Bonus Not Allowed"; Rec."BBG Bonus Not Allowed")
                {
                }
                field(Version; Rec."BBG Version")
                {
                }
                field(Remarks; Rec."BBG Remarks")
                {
                    Caption = 'Remarks';
                    MultiLine = true;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No."; Rec."Phone No.")
                {
                    Visible = "Phone No.Visible";
                }
                field("Phone No. 2"; Rec."BBG Phone No. 2")
                {
                    Visible = "Phone No. 2Visible";
                }
                field("Fax No."; Rec."Fax No.")
                {
                }
                field("Home Page"; Rec."Home Page")
                {
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {

                    trigger OnValidate()
                    begin
                        ICPartnerCodeOnAfterValidate;
                    end;
                }
                field("Temp Address"; Rec."BBG Temp Address")
                {
                    Caption = 'Update Address';
                }
                field("Temp Address 2"; Rec."BBG Temp Address 2")
                {
                    Caption = 'Update Address2';
                }
                field("Temp Address 3"; Rec."BBG Temp Address 3")
                {
                    Caption = 'Update Address 3';
                }
                field("Temp Mob. No."; Rec."BBG Temp Mob. No.")
                {
                    Caption = 'Update Mob. No.';
                }
                field("Black List"; Rec."BBG Black List")
                {
                }
                field("Alternate Name"; Rec."BBG Alternate Name")
                {
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                }
                field("Credit Limit"; Rec."BBG Credit Limit")
                {
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                }
                // field("Excise Bus. Posting Group"; Rec."Excise Bus. Posting Group")
                // {
                // }
                field("Invoice Disc. Code"; Rec."Invoice Disc. Code")
                {
                }
                field("Prices Including VAT"; Rec."Prices Including VAT")
                {
                }
                field("Prepayment %"; Rec."Prepayment %")
                {
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                field("Application Method"; Rec."Application Method")
                {
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                }
                field(Priority; Rec.Priority)
                {
                }
                field("Our Account No."; Rec."Our Account No.")
                {
                }
                field("Block Payment Tolerance"; Rec."Block Payment Tolerance")
                {

                    trigger OnValidate()
                    begin
                        IF Rec."Block Payment Tolerance" THEN BEGIN
                            IF CONFIRM(Text002, FALSE) THEN
                                PaymentToleranceMgt.DelTolVendLedgEntry(Rec);
                        END ELSE BEGIN
                            IF CONFIRM(Text001, FALSE) THEN
                                PaymentToleranceMgt.CalcTolVendLedgEntry(Rec);
                        END;
                    end;
                }
            }
            group(Receiving)
            {
                Caption = 'Receiving';
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                }
                field("Base Calendar Code"; Rec."Base Calendar Code")
                {
                    DrillDown = false;
                }
                // field("Customized Calendar"; CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."Source Type"::Vendor, Rec."No.", '', Rec."Base Calendar Code"))
                // {
                //     Caption = 'Customized Calendar';
                //     Editable = false;

                //     trigger OnDrillDown()
                //     begin
                //         CurrPage.SAVERECORD;
                //         Rec.TESTFIELD("Base Calendar Code");
                //         CalendarMgmt.ShowCustomizedCalendar(CustomizedCalEntry."Source Type"::Vendor, Rec."No.", '', Rec."Base Calendar Code");
                //     end;
                // }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("Language Code"; Rec."Language Code")
                {
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                }
            }
            group("Tax Information")
            {
                Caption = 'Tax Information';
                group(Tax)
                {
                    Caption = 'Tax';
                    // field("L.S.T. No."; Rec."L.S.T. No.")
                    // {
                    // }
                    // field("C.S.T. No."; Rec."C.S.T. No.")
                    // {
                    // }
                }
                group(Excise)
                {
                    Caption = 'Excise';
                    // field("E.C.C. No."; "E.C.C. No.")
                    // {
                    // }
                    // field(Range; Rec."BBG Range")
                    // {
                    // }
                    // field(Collectorate; Rec."BBG Collectorate")
                    // {
                    // }
                    // field("Vendor Type"; "Vendor Type")
                    // {
                    // }
                }
                group(VAT)
                {
                    Caption = 'VAT';
                    // field("T.I.N. No."; "T.I.N. No.")
                    // {
                    // }
                    field(Composition; Rec.Composition)
                    {
                    }
                }
                group("Income Tax")
                {
                    Caption = 'Income Tax';
                    field("P.A.N. Reference No."; Rec."P.A.N. Reference No.")
                    {
                    }
                }
                group("Service Tax")
                {
                    Caption = 'Service Tax';
                    // field("Service Entity Type"; "Service Entity Type")
                    // {
                    // }
                    // field("Service Tax Registration No."; "Service Tax Registration No.")
                    // {
                    // }
                }
                group("&Subcontractor")
                {
                    Caption = 'Subcontractor';
                    field(Subcontractor; Rec.Subcontractor)
                    {
                    }
                    field("Vendor Location"; Rec."Vendor Location")
                    {
                    }
                    field("Commissioner's Permission No."; Rec."Commissioner's Permission No.")
                    {
                    }
                }
            }
            group(Credentials)
            {
                Caption = 'Credentials';
                field(Picture; Rec.Image)
                {
                }
            }
            group("Associate Credentials")
            {
                Caption = 'Associate Credentials';
                field("Rank Code"; Rec."BBG Rank Code")
                {
                    Editable = false;
                }
                field("GetDescription.GetRankDesc(Rank Code)";
                GetDescription.GetRankDesc(Rec."BBG Rank Code"))
                {
                    Editable = false;
                }
                field("Date of Joining"; Rec."BBG Date of Joining")
                {
                }
                field("Parent Code"; Rec."BBG Parent Code")
                {
                    Editable = false;
                }
                field("GetDescription.GetRankDesc(Parent Rank)";
                GetDescription.GetRankDesc(Rec."BBG Parent Rank"))
                {
                    Editable = false;
                }
                field(Sex; Rec."BBG Sex")
                {
                }
                field("Date of Birth"; Rec."BBG Date of Birth")
                {
                }
                field("Marital Status"; Rec."BBG Marital Status")
                {
                }
                field(Nationality; Rec."BBG Nationality")
                {
                }
                field("Associate Creation"; Rec."BBG Associate Creation")
                {
                    Style = Attention;
                    StyleExpr = TRUE;
                }
                field("Web Associate Payment Active"; Rec."BBG Web Associate Payment Active")
                {
                    MultiLine = true;
                }
                field(BalAmount; BalAmount)
                {
                    Caption = 'Balance on Date';
                    Editable = false;
                }
                field("Commission Amount Qualified"; Rec."BBG Commission Amount Qualified")
                {
                    Editable = false;
                }
                field("Travel Amount Qualified"; Rec."BBG Travel Amount Qualified")
                {
                    Editable = false;
                }
                field("Incentive Amount Qualified"; Rec."BBG Incentive Amount Qualified")
                {
                    Editable = false;
                }
                field("Total Balance Amount"; Rec."BBG Total Balance Amount")
                {
                    Caption = 'Net Bal. incl. Elegilibility';
                    Editable = false;
                }
                field("TA Applicable on Associate"; Rec."BBG TA Applicable on Associate")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ven&dor")
            {
                Caption = 'Ven&dor';
                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Vendor Ledger Entries";
                    RunPageLink = "Vendor No." = FIELD("No.");
                    RunPageView = SORTING("Vendor No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                group("Purchase &History")
                {
                    Caption = 'Purchase &History';
                    action("Used as &Buy-from Vendor")
                    {
                        Caption = 'Used as &Buy-from Vendor';

                        trigger OnAction()
                        begin
                            //PurchInfoPaneMgt.LookupVendHistory(Rec."No.", FALSE);
                        end;
                    }
                    action("Used as &Pay-to Vendor")
                    {
                        Caption = 'Used as &Pay-to Vendor';

                        trigger OnAction()
                        begin
                            // PurchInfoPaneMgt.LookupVendHistory(Rec."No.", TRUE);
                        end;
                    }
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = CONST(Vendor),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(23),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("Bank Accounts")
                {
                    Caption = 'Bank Accounts';
                    RunObject = Page "Vendor Bank Account Card";
                    RunPageLink = "Vendor No." = FIELD("No.");
                }
                action("Alternate &Addresses")
                {
                    Caption = 'Alternate &Addresses';
                    RunObject = Page "Order Address";
                    RunPageLink = "Vendor No." = FIELD("No.");
                }
                action("C&ontact")
                {
                    Caption = 'C&ontact';

                    trigger OnAction()
                    begin
                        Rec.ShowContact;
                    end;
                }
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Vendor Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                }
                action("Entry Statistics")
                {
                    Caption = 'Entry Statistics';
                    RunObject = Page "Vendor Entry Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                }
                action(Purchases)
                {
                    Caption = 'Purchases';
                    RunObject = Page "Vendor Purchases";
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                }
                action("Cross References")
                {
                    Caption = 'Cross References';
                    // RunObject = Page 5723;
                    // RunPageLink = "Cross-Reference Type" = CONST(Vendor),
                    //               "Cross-Reference Type No." = FIELD("No.");
                    // RunPageView = SORTING("Cross-Reference Type", "Cross-Reference Type No.");
                }
                action("Online Map")
                {
                    Caption = 'Online Map';

                    trigger OnAction()
                    begin
                        Rec.DisplayMap;
                    end;
                }

                action(EDIT)
                {
                    Caption = 'EDIT';
                    Visible = false;

                    trigger OnAction()
                    begin

                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'DDS-PNP-VENDOR, EDIT');
                        IF MemberOf.FIND('-') THEN
                            CurrPage.EDITABLE := TRUE;

                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'SUPER');
                        IF MemberOf.FIND('-') THEN
                            CurrPage.EDITABLE := TRUE;
                    end;
                }
                action("&Documents")
                {
                    Caption = '&Documents';
                    RunObject = Page Documents;
                    RunPageLink = "Table No." = CONST(23),
                                  "Reference No. 1" = FIELD("No.");
                }
            }
            group("&Purchases")
            {
                Caption = '&Purchases';
                action(Items)
                {
                    Caption = 'Items';
                    RunObject = Page "Vendor Item Catalog";
                    RunPageLink = "Vendor No." = FIELD("No.");
                    RunPageView = SORTING("Vendor No.", "Item No.");
                }
                action("Invoice &Discounts")
                {
                    Caption = 'Invoice &Discounts';
                    RunObject = Page "Vend. Invoice Discounts";
                    RunPageLink = Code = FIELD("Invoice Disc. Code");
                }
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Purchase Prices";
                    RunPageLink = "Vendor No." = FIELD("No.");
                    RunPageView = SORTING("Vendor No.");
                }
                action("Line Discounts")
                {
                    Caption = 'Line Discounts';
                    RunObject = Page "Purchase Line Discounts";
                    RunPageLink = "Vendor No." = FIELD("No.");
                    RunPageView = SORTING("Vendor No.");
                }
                action("Prepa&yment Percentages")
                {
                    Caption = 'Prepa&yment Percentages';
                    RunObject = Page "Purchase Prepmt. Percentages";
                    RunPageLink = "Vendor No." = FIELD("No.");
                    RunPageView = SORTING("Vendor No.");
                }
                action("S&td. Vend. Purchase Codes")
                {
                    Caption = 'S&td. Vend. Purchase Codes';
                    RunObject = Page "Standard Vendor Purchase Codes";
                    RunPageLink = "Vendor No." = FIELD("No.");
                }
                action(Quotes)
                {
                    Caption = 'Quotes';
                    Image = Quote;
                    RunObject = Page "Purchase Quote";
                    RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Buy-from Vendor No.");
                }
                action("Blanket Orders")
                {
                    Caption = 'Blanket Orders';
                    Image = BlanketOrder;
                    RunObject = Page "Blanket Purchase Order";
                    RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Buy-from Vendor No.");
                }
                action(Orders)
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Purchase Order";
                    RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Buy-from Vendor No.", "No.");
                }
                action("Closed Orders")
                {
                    Caption = 'Closed Orders';
                    RunObject = Page "FA Purchase Request Header";
                }
                action("Return Orders")
                {
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Purchase Return Order";
                    RunPageLink = "Buy-from Vendor No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", "Buy-from Vendor No.", "No.");
                }
                action("Item &Tracking Entries")
                {
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    var
                        ItemTrackingMgt: Codeunit "Item Tracking Management";
                    begin
                        //ItemTrackingMgt.CallItemTrackingEntryForm(2, Rec."No.", '', '', '', '', '');
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Confirm")
            {
                Caption = '&Confirm';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", USERID);
                    UserSetup.SETRANGE("Non IBA Vendor Creation", TRUE);
                    IF NOT UserSetup.FINDFIRST THEN
                        ERROR('Please contact Admin');

                    //NDALLE 051107 Begin
                    IF NOT Rec.INSERT(TRUE) THEN
                        Rec.MODIFY(TRUE);
                    //NDALLE 051107 End
                end;
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Create NOD Lines for Commisison")
                {
                    Caption = 'Create NOD Lines for Commisison';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("BBG Archived", FALSE);//ALLECK 220413
                        IF CONFIRM(Text006, TRUE, Rec."No.") THEN
                            Rec.CreateNOD;
                    end;
                }
                group(Master)
                {
                    Caption = 'Master';
                    Visible = false;
                    action("Vendor Rank List")
                    {
                        Caption = 'Vendor Rank List';
                        RunObject = Page "Regin and Rank wise vendor";
                        Visible = false;
                    }
                    action("Vendor Tree")
                    {
                        Caption = 'Vendor Tree';
                        RunObject = Page "Vendor Tree";
                        RunPageLink = "Introducer Code" = FIELD("No.");
                        Visible = false;
                    }
                    action("Rank Relation")
                    {
                        Caption = 'Rank Relation';
                        RunObject = Page "Region and Rank wise Associate";
                        RunPageLink = "No." = FIELD("No.");
                        Visible = false;
                    }
                    action("Region/Rank Master")
                    {
                        Caption = 'Region/Rank Master';
                        RunObject = Page "Rank Code";
                        Visible = false;
                    }
                }
                action("Apply Template")
                {
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    Visible = false;

                    trigger OnAction()
                    var
                        TemplateMgt: Codeunit "Config. Template Management";
                        RecRef: RecordRef;
                    begin
                        Rec.TESTFIELD("BBG Archived", FALSE);//ALLECK 220413
                        RecRef.GETTABLE(Rec);
                        TemplateMgt.UpdateFromTemplateSelection(RecRef);
                    end;
                }
                action("Update NOD Lines in other company")
                {
                    Caption = 'Update NOD Lines in other company';
                    Visible = false;

                    trigger OnAction()
                    var
                        AllowedSection: Record "Allowed Sections";
                    begin
                        Comp.RESET;
                        Comp.SETFILTER(Comp.Name, '<>%1', COMPANYNAME);
                        IF Comp.FINDSET THEN BEGIN
                            REPEAT
                                BondSetup.CHANGECOMPANY(Comp.Name);
                                BondSetup.GET;
                                BondSetup.TESTFIELD("TDS Nature of Deduction");

                                AllowedSection.Reset();
                                AllowedSection.ChangeCompany(Comp.Name);
                                AllowedSection.SetRange("Vendor No", Rec."No.");
                                IF Not AllowedSection.FindFirst() then begin
                                    AllowedSection.Init();
                                    AllowedSection.Validate("Vendor No", Rec."No.");
                                    AllowedSection.Validate("TDS Section", BondSetup."TDS Nature of Deduction");
                                    AllowedSection.Validate("Threshold Overlook", TRUE);
                                    AllowedSection.Validate("Surcharge Overlook", TRUE);
                                    AllowedSection.Insert();
                                end;
                            /*
                            NODHeader.CHANGECOMPANY(Comp.Name);
                            IF NOT NODHeader.GET(NODHeader.Type::Vendor, Rec."No.") THEN BEGIN
                                NODHeader.INIT;
                                NODHeader.Type := NODHeader.Type::Vendor;
                                NODHeader."No." := Rec."No.";
                                NODHeader."Assesse Code" := 'IND';
                                NODHeader.INSERT;
                            END;
                            NODLine.CHANGECOMPANY(Comp.Name);
                            IF NOT NODLine.GET(NODLine.Type::Vendor, Rec."No.", BondSetup."TDS Nature of Deduction") THEN BEGIN
                                NODLine.Type := NODLine.Type::Vendor;
                                NODLine."No." := Rec."No.";
                                NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                                NODLine."Monthly Certificate" := TRUE;
                                NODLine."Threshold Overlook" := TRUE;
                                NODLine."Surcharge Overlook" := TRUE;
                                NODLine.INSERT;
                            END;
                            *///Need to check the code in UAT

                            UNTIL Comp.NEXT = 0;
                        END;
                        MESSAGE('%1', 'Update NOD Lines');
                    end;
                }
                action("Create NOD for Commission")
                {
                    Caption = 'Create NOD for Commission';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("BBG Archived", FALSE);//ALLECK 220413
                        IF CONFIRM(Text006, TRUE, Rec."No.") THEN
                            Rec.CreateNOD;
                    end;
                }
                action("Rank History")
                {
                    Caption = 'Rank History';
                    RunObject = Page "Change Rank History";
                    RunPageLink = MMCode = FIELD("No.");
                    Visible = false;
                }
                action(Tree)
                {
                    Caption = 'Tree';
                    RunObject = Page "Vendor Tree";
                    RunPageLink = "Introducer Code" = FIELD("No.");
                    Visible = false;
                }
                action("&Picture")
                {
                    Caption = '&Picture';
                    RunObject = Page "Vendor  Picture";
                }
                action("&Release")
                {
                    Caption = '&Release';
                    Image = ReleaseDoc;

                    trigger OnAction()
                    var
                        VendorBankAccount: Record "Vendor Bank Account";
                        RecVendorBankAccount: Record "Vendor Bank Account";
                        RegionwiseVendor: Record "Region wise Vendor";
                        RegionwiseVendor_1: Record "Region wise Vendor";
                        CompanyInfo: Record "Company Information";
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Non IBA Vendor Creation", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');


                        IF Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)" THEN
                            ERROR('Vendor Category should not be IBA Associates');


                        Rec.TESTFIELD("BBG Remarks");
                        Archived := TRUE;
                        Rec.MODIFY;
                        CurrPage.EDITABLE(FALSE);//ALLECK 200413
                    end;
                }
                action("Re&Open")
                {
                    Caption = 'Re&Open';

                    trigger OnAction()
                    var
                        companywisegl: Record "Company wise G/L Account";
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Non IBA Vendor Creation", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');

                        IF Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)" THEN
                            ERROR('Vendor Category should not be IBA Associates');

                        MemberOf.RESET;
                        MemberOf.SETRANGE("User Name", USERID);
                        MemberOf.SETRANGE("Role ID", 'A_OTHERVENDCREATION');
                        IF MemberOf.FINDFIRST THEN
                            CurrPage.EDITABLE(TRUE)
                        ELSE
                            CurrPage.EDITABLE(FALSE);
                    end;
                }
                action("Update Address")
                {
                    Caption = 'Update Address';
                    Visible = false;

                    trigger OnAction()
                    begin
                        //BBG2.10
                        IF Rec.Address = '' THEN BEGIN
                            IF Rec."BBG Temp Address" <> '' THEN
                                Rec.Address := Rec."BBG Temp Address";
                        END ELSE
                            MESSAGE('Address already Exists. Contact to Admin');

                        IF Rec."Address 2" = '' THEN BEGIN
                            IF Rec."BBG Temp Address 2" <> '' THEN
                                Rec."Address 2" := Rec."BBG Temp Address 2";
                        END ELSE
                            MESSAGE('Address already Exists. Contact to Admin');


                        IF Rec."BBG Address 3" = '' THEN BEGIN
                            IF Rec."BBG Temp Address 3" <> '' THEN
                                Rec."BBG Address 3" := Rec."BBG Temp Address 3";
                        END ELSE
                            MESSAGE('Address already Exists. Contact to Admin');

                        IF Rec."BBG Mob. No." = '' THEN BEGIN
                            IF Rec."BBG Temp Mob. No." <> '' THEN
                                Rec."BBG Mob. No." := Rec."BBG Temp Mob. No.";
                        END ELSE
                            MESSAGE('Mobile No. already Exists. Contact to Admin');


                        Rec."BBG Temp Address" := '';
                        Rec."BBG Temp Address 2" := '';
                        Rec."BBG Temp Address 3" := '';
                        Rec."BBG Temp Mob. No." := '';
                        Rec.MODIFY;
                        //BBG2.10
                    end;
                }
                action("Copy All IBA in Company")
                {
                    Caption = 'Copy All IBA in Company';
                    Visible = false;

                    trigger OnAction()
                    var
                        RecVendorBankAccount: Record "Vendor Bank Account";
                        VendorBankAccount: Record "Vendor Bank Account";
                        AllowedSection: Record "Allowed Sections";
                    begin
                        Rec.TESTFIELD("BBG Copy IBA in Company");
                        CopyVend.RESET;
                        CopyVend.SETRANGE("BBG Vendor Category", Rec."BBG Vendor Category"::"IBA(Associates)");
                        IF CopyVend.FINDFIRST THEN BEGIN
                            REPEAT
                                Vend.RESET;
                                //Vend.CHANGECOMPANY("Copy IBA in Company");
                                Vend.SETRANGE("No.", CopyVend."No.");
                                IF NOT Vend.FINDFIRST THEN BEGIN
                                    Vend.INIT;
                                    Vend.TRANSFERFIELDS(CopyVend);
                                    Vend.INSERT;
                                    //BondSetup.CHANGECOMPANY("Copy IBA in Company");
                                    BondSetup.GET;
                                    BondSetup.TESTFIELD("TDS Nature of Deduction");

                                    AllowedSection.Reset();
                                    AllowedSection.ChangeCompany(Rec."BBG Copy IBA in Company");
                                    AllowedSection.SetRange("Vendor No", Rec."No.");
                                    IF Not AllowedSection.FindFirst() then begin
                                        AllowedSection.Init();
                                        AllowedSection.Validate("Vendor No", Rec."No.");
                                        AllowedSection.Validate("TDS Section", BondSetup."TDS Nature of Deduction");
                                        AllowedSection.Validate("Threshold Overlook", TRUE);
                                        AllowedSection.Validate("Surcharge Overlook", TRUE);
                                        AllowedSection.Insert();
                                    end;
                                    /*
                                    NODHeader.CHANGECOMPANY("Copy IBA in Company");
                                    IF NOT NODHeader.GET(NODHeader.Type::Vendor, Vend."No.") THEN BEGIN
                                        NODHeader.INIT;
                                        NODHeader.Type := NODHeader.Type::Vendor;
                                        NODHeader."No." := Vend."No.";
                                        NODHeader."Assesse Code" := 'IND';
                                        NODHeader.INSERT;
                                    END;

                                    NODLine.CHANGECOMPANY("Copy IBA in Company");
                                    IF NOT NODLine.GET(NODLine.Type::Vendor, CopyVend."No.", BondSetup."TDS Nature of Deduction") THEN BEGIN
                                        NODLine.Type := NODLine.Type::Vendor;
                                        NODLine."No." := CopyVend."No.";
                                        NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                                        NODLine."Monthly Certificate" := TRUE;
                                        NODLine."Threshold Overlook" := TRUE;
                                        NODLine."Surcharge Overlook" := TRUE;
                                        NODLine.INSERT;
                                    END;
                                    *///Need to check the code in UAT

                                    RecVendorBankAccount.RESET;
                                    RecVendorBankAccount.SETRANGE("Vendor No.", CopyVend."No.");
                                    IF RecVendorBankAccount.FINDSET THEN
                                        REPEAT
                                            VendorBankAccount.RESET;
                                            //VendorBankAccount.CHANGECOMPANY("Copy IBA in Company");
                                            VendorBankAccount.INIT;
                                            VendorBankAccount := RecVendorBankAccount;
                                            VendorBankAccount.INSERT;
                                        UNTIL RecVendorBankAccount.NEXT = 0;
                                END;
                                CLEAR(Vend);
                                Vend.RESET;
                                //Vend.CHANGECOMPANY("Copy IBA in Company");
                                Vend.SETRANGE("No.", CopyVend."No.");
                                IF Vend.FINDFIRST THEN BEGIN
                                    Vend."Vendor Posting Group" := CopyVend."Vendor Posting Group";
                                    Vend."BBG Status" := CopyVend."BBG Status";
                                    Vend."BBG Date of Birth" := CopyVend."BBG Date of Birth";
                                    Vend."BBG Date of Joining" := CopyVend."BBG Date of Joining";
                                    Vend."BBG Sex" := CopyVend."BBG Sex";
                                    Vend."BBG Marital Status" := CopyVend."BBG Marital Status";
                                    Vend."BBG Nationality" := CopyVend."BBG Nationality";
                                    Vend."BBG Associate Creation" := CopyVend."BBG Associate Creation";
                                    Vend."Tax Liable" := CopyVend."Tax Liable";
                                    Vend.MODIFY;
                                END;
                            UNTIL CopyVend.NEXT = 0;
                            MESSAGE('%1', 'Copy all IBA in Give company');
                        END;
                    end;
                }
                action("Vendor Hierarchy")
                {
                    Caption = 'Vendor Hierarchy';
                    RunObject = Page "Regin and Rank wise vendor";
                    Visible = false;
                }
            }
            action(History)
            {
                Caption = 'History';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'History';

                trigger OnAction()
                begin
                    Rec.HistoryFunction(-26, '');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ActivateFields;

        BBGOnAfterGetCurrRecord;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        RecordFound: Boolean;
    begin
        RecordFound := Rec.FIND(Which);
        IF NOT RecordFound AND (Rec.GETFILTER("No.") <> '') THEN BEGIN
            MESSAGE(Text003, Rec.GETFILTER("No."));
            Rec.SETRANGE("No.");
            RecordFound := Rec.FIND(Which);
        END;
        EXIT(RecordFound);

        SetSecurity(FALSE);
        EXIT(Rec.FIND(Which));
    end;

    trigger OnInit()
    begin
        ContactEditable := TRUE;
        "P.A.N. No.Editable" := TRUE;
        ContactVisible := TRUE;
        "Phone No. 2Visible" := TRUE;
        "Phone No.Visible" := TRUE;
        "Address 2Visible" := TRUE;
        AddressVisible := TRUE;
        "Mob. No.Visible" := TRUE;
        MapPointVisible := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Non IBA Vendor Creation", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Please contact Admin');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Non IBA Vendor Creation", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Please contact Admin');
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
    begin
        //ALLECK 200413

        IF USERID <> '1005' THEN
            CurrPage.EDITABLE(FALSE);

        ActivateFields;
        IF NOT MapMgt.TestSetup THEN
            MapPointVisible := FALSE;

        SetSecurity(TRUE);

        //BBG2.01 22/07/14
        CLEAR(MemberOf);
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETRANGE("Role ID", 'VendInfoVisible');
        IF NOT MemberOf.FINDFIRST THEN BEGIN
            "Mob. No.Visible" := FALSE;
            AddressVisible := FALSE;
            "Address 2Visible" := FALSE;
            "Phone No.Visible" := FALSE;
            "Phone No. 2Visible" := FALSE;
            ContactVisible := FALSE;
        END ELSE BEGIN
            "Mob. No.Visible" := TRUE;
            AddressVisible := TRUE;
            "Address 2Visible" := TRUE;
            "Phone No.Visible" := TRUE;
            "Phone No. 2Visible" := TRUE;
            ContactVisible := TRUE;
        END;
        //BBG2.01 22/07/14
    end;

    var
        CalendarMgmt: Codeunit "Calendar Management";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        CustomizedCalEntry: Record "Customized Calendar Entry";
        CustomizedCalendar: Record "Customized Calendar Change";
        Text001: Label 'Do you want to allow payment tolerance for entries that are currently open?';
        Text002: Label 'Do you want to remove payment tolerance from entries that are currently open?';
        PurchInfoPaneMgt: Codeunit "Purchases Info-Pane Management";
        Text003: Label 'The vendor %1 does not exist.';
        Text006: Label 'Do you want to create NOD for Commission for the Marketing Member No. %1?';
        Text007: Label 'Do you want to suspend the Marketing Member No. %1?';
        Text008: Label 'Do you want to release suspension for the Marketing Member No. %1?';
        Text009: Label 'Do you want to hold the payables for the Marketing Member No. %1?';
        Text010: Label 'Do you want to unhold payables for the Marketing Member No. %1?';
        Text011: Label 'Do you want to change the Status of the Marketing Member No. %1?';
        Text012: Label 'Do you want to change chain for the Marketing Member No. %1?';
        Text013: Label 'Do you want to inactive the Marketing Member No. %1?';
        Text004: Label 'Invalid Permission.';
        Text005: Label 'Do you want to change the rank for the Marketing Member No. %1?';
        UserSetup: Record "User Setup";
        //SuspendHold: Report 50020;
        ParamType: Option Suspend,Release,Hold,Unhold;
        //InactiveMM: Report 50023;
        GetDescription: Codeunit GetDescription;
        Vendor: Record Vendor;
        Text014: Label 'Do you want to change the Parent for the Marketing Member No. %1?';
        BalAmount: Decimal;
        ArchiveVndr: Record "Archive Vendor";
        Vrsn: Integer;
        Archived: Boolean;
        CustMobileNo: Text[30];
        CustSMSText: Text[800];
        PostPayment: Codeunit PostPayment;
        Comp: Record Company;
        Vend: Record Vendor;
        BondSetup: Record "Unit Setup";
        //NODHeader: Record 13786;
        //NODLine: Record 13785;
        CompanywiseAccount: Record "Company wise G/L Account";
        CopyVend: Record Vendor;
        MSVendor: Record Vendor;

        MapPointVisible: Boolean;

        "Mob. No.Visible": Boolean;

        AddressVisible: Boolean;

        "Address 2Visible": Boolean;

        "Phone No.Visible": Boolean;

        "Phone No. 2Visible": Boolean;

        ContactVisible: Boolean;

        "P.A.N. No.Editable": Boolean;

        ContactEditable: Boolean;
        Text19060128: Label '* Fields Marked in Red Colour are Mandatory';
        MemberOf: Record "Access Control";


    procedure ActivateFields()
    begin
        //Archived := Archived :: "0"; //ALLECK 220413
        ContactEditable := Rec."Primary Contact No." = '';
        "P.A.N. No.Editable" := Rec."P.A.N. Status" = 0;
    end;

    local procedure SetSecurity(OpenPAGE: Boolean)
    begin
        //ALLEDK 030313
        /*
        IF OpenPAGE THEN BEGIN
          IF NOT TableSecurity.GetTableSecurity(PAGE::"Vendor Card") THEN
            EXIT;
        
          IF TableSecurity."Form General Permission" = TableSecurity."Form General Permission"::Visible THEN
            CurrPAGE.EDITABLE(FALSE);
        
          TableSecurity.SetFieldFilters(Rec);
        END ELSE
          IF TableSecurity."Security for Form No." = 0 THEN
            EXIT;
        
        IF CurrPAGE."No.".EDITABLE THEN
          CurrPAGE."No.".EDITABLE(TableSecurity."No." = 0);
        CurrPAGE."No.".VISIBLE(TableSecurity."No." IN [0,1,3,4]);
        IF TableSecurity."No." IN [2,5] THEN
          SETRANGE("No.");
        IF CurrPAGE.Name.EDITABLE THEN
          CurrPAGE.Name.EDITABLE(TableSecurity.Name = 0);
        CurrPAGE.Name.VISIBLE(TableSecurity.Name IN [0,1,3,4]);
        IF TableSecurity.Name IN [2,5] THEN
          SETRANGE(Name);
        IF CurrPAGE."Search Name".EDITABLE THEN
          CurrPAGE."Search Name".EDITABLE(TableSecurity."Search Name" = 0);
        CurrPAGE."Search Name".VISIBLE(TableSecurity."Search Name" IN [0,1,3,4]);
        IF TableSecurity."Search Name" IN [2,5] THEN
          SETRANGE("Search Name");
        //IF CurrPAGE."Name 2".EDITABLE THEN
        //  CurrPAGE."Name 2".EDITABLE(TableSecurity."Name 2" = 0);
        //CurrPAGE."Name 2".VISIBLE(TableSecurity."Name 2" IN [0,1,3,4]);
        //IF TableSecurity."Name 2" IN [2,5] THEN
        //  SETRANGE("Name 2");
        IF CurrPAGE.Address.EDITABLE THEN
          CurrPAGE.Address.EDITABLE(TableSecurity.Address = 0);
        CurrPAGE.Address.VISIBLE(TableSecurity.Address IN [0,1,3,4]);
        IF TableSecurity.Address IN [2,5] THEN
          SETRANGE(Address);
        IF CurrPAGE."Address 2".EDITABLE THEN
          CurrPAGE."Address 2".EDITABLE(TableSecurity."Address 2" = 0);
        CurrPAGE."Address 2".VISIBLE(TableSecurity."Address 2" IN [0,1,3,4]);
        IF TableSecurity."Address 2" IN [2,5] THEN
          SETRANGE("Address 2");
        IF CurrPAGE.City.EDITABLE THEN
          CurrPAGE.City.EDITABLE(TableSecurity.City = 0);
        CurrPAGE.City.VISIBLE(TableSecurity.City IN [0,1,3,4]);
        IF TableSecurity.City IN [2,5] THEN
          SETRANGE(City);
        IF CurrPAGE.Contact.EDITABLE THEN
          CurrPAGE.Contact.EDITABLE(TableSecurity.Contact = 0);
        CurrPAGE.Contact.VISIBLE(TableSecurity.Contact IN [0,1,3,4]);
        IF TableSecurity.Contact IN [2,5] THEN
          SETRANGE(Contact);
        IF CurrPAGE."Phone No.".EDITABLE THEN
          CurrPAGE."Phone No.".EDITABLE(TableSecurity."Phone No." = 0);
        CurrPAGE."Phone No.".VISIBLE(TableSecurity."Phone No." IN [0,1,3,4]);
        IF TableSecurity."Phone No." IN [2,5] THEN
          SETRANGE("Phone No.");
        IF CurrPAGE."Our Account No.".EDITABLE THEN
          CurrPAGE."Our Account No.".EDITABLE(TableSecurity."Our Account No." = 0);
        CurrPAGE."Our Account No.".VISIBLE(TableSecurity."Our Account No." IN [0,1,3,4]);
        IF TableSecurity."Our Account No." IN [2,5] THEN
          SETRANGE("Our Account No.");
        IF CurrPAGE."Vendor Posting Group".EDITABLE THEN
          CurrPAGE."Vendor Posting Group".EDITABLE(TableSecurity."Vendor Posting Group" = 0);
        CurrPAGE."Vendor Posting Group".VISIBLE(TableSecurity."Vendor Posting Group" IN [0,1,3,4]);
        IF TableSecurity."Vendor Posting Group" IN [2,5] THEN
          SETRANGE("Vendor Posting Group");
        IF CurrPAGE."Currency Code".EDITABLE THEN
          CurrPAGE."Currency Code".EDITABLE(TableSecurity."Currency Code" = 0);
        CurrPAGE."Currency Code".VISIBLE(TableSecurity."Currency Code" IN [0,1,3,4]);
        IF TableSecurity."Currency Code" IN [2,5] THEN
          SETRANGE("Currency Code");
        IF CurrPAGE."Language Code".EDITABLE THEN
          CurrPAGE."Language Code".EDITABLE(TableSecurity."Language Code" = 0);
        CurrPAGE."Language Code".VISIBLE(TableSecurity."Language Code" IN [0,1,3,4]);
        IF TableSecurity."Language Code" IN [2,5] THEN
          SETRANGE("Language Code");
        IF CurrPAGE."Payment Terms Code".EDITABLE THEN
          CurrPAGE."Payment Terms Code".EDITABLE(TableSecurity."Payment Terms Code" = 0);
        CurrPAGE."Payment Terms Code".VISIBLE(TableSecurity."Payment Terms Code" IN [0,1,3,4]);
        IF TableSecurity."Payment Terms Code" IN [2,5] THEN
          SETRANGE("Payment Terms Code");
        IF CurrPAGE."Shipment Method Code".EDITABLE THEN
          CurrPAGE."Shipment Method Code".EDITABLE(TableSecurity."Shipment Method Code" = 0);
        CurrPAGE."Shipment Method Code".VISIBLE(TableSecurity."Shipment Method Code" IN [0,1,3,4]);
        IF TableSecurity."Shipment Method Code" IN [2,5] THEN
          SETRANGE("Shipment Method Code");
        IF CurrPAGE."Invoice Disc. Code".EDITABLE THEN
          CurrPAGE."Invoice Disc. Code".EDITABLE(TableSecurity."Invoice Disc. Code" = 0);
        CurrPAGE."Invoice Disc. Code".VISIBLE(TableSecurity."Invoice Disc. Code" IN [0,1,3,4]);
        IF TableSecurity."Invoice Disc. Code" IN [2,5] THEN
          SETRANGE("Invoice Disc. Code");
        IF CurrPAGE.Blocked.EDITABLE THEN
          CurrPAGE.Blocked.EDITABLE(TableSecurity.Blocked = 0);
        CurrPAGE.Blocked.VISIBLE(TableSecurity.Blocked IN [0,1,3,4]);
        IF TableSecurity.Blocked IN [2,5] THEN
          SETRANGE(Blocked);
        IF CurrPAGE."Pay-to Vendor No.".EDITABLE THEN
          CurrPAGE."Pay-to Vendor No.".EDITABLE(TableSecurity."Pay-to Vendor No." = 0);
        CurrPAGE."Pay-to Vendor No.".VISIBLE(TableSecurity."Pay-to Vendor No." IN [0,1,3,4]);
        IF TableSecurity."Pay-to Vendor No." IN [2,5] THEN
          SETRANGE("Pay-to Vendor No.");
        IF CurrPAGE.Priority.EDITABLE THEN
          CurrPAGE.Priority.EDITABLE(TableSecurity.Priority = 0);
        CurrPAGE.Priority.VISIBLE(TableSecurity.Priority IN [0,1,3,4]);
        IF TableSecurity.Priority IN [2,5] THEN
          SETRANGE(Priority);
        IF CurrPAGE."Payment Method Code".EDITABLE THEN
          CurrPAGE."Payment Method Code".EDITABLE(TableSecurity."Payment Method Code" = 0);
        CurrPAGE."Payment Method Code".VISIBLE(TableSecurity."Payment Method Code" IN [0,1,3,4]);
        IF TableSecurity."Payment Method Code" IN [2,5] THEN
          SETRANGE("Payment Method Code");
        IF CurrPAGE."Last Date Modified".EDITABLE THEN
          CurrPAGE."Last Date Modified".EDITABLE(TableSecurity."Last Date Modified" = 0);
        CurrPAGE."Last Date Modified".VISIBLE(TableSecurity."Last Date Modified" IN [0,1,3,4]);
        IF TableSecurity."Last Date Modified" IN [2,5] THEN
          SETRANGE("Last Date Modified");
        IF CurrPAGE."Net Change (LCY)".EDITABLE THEN
          CurrPAGE."Net Change (LCY)".EDITABLE(TableSecurity."Net Change (LCY)" = 0);
        CurrPAGE."Net Change (LCY)".VISIBLE(TableSecurity."Net Change (LCY)" IN [0,1,3,4]);
        IF TableSecurity."Net Change (LCY)" IN [2,5] THEN
          SETRANGE("Net Change (LCY)");
        IF CurrPAGE."Application Method".EDITABLE THEN
          CurrPAGE."Application Method".EDITABLE(TableSecurity."Application Method" = 0);
        CurrPAGE."Application Method".VISIBLE(TableSecurity."Application Method" IN [0,1,3,4]);
        IF TableSecurity."Application Method" IN [2,5] THEN
          SETRANGE("Application Method");
        IF CurrPAGE."Prices Including VAT".EDITABLE THEN
          CurrPAGE."Prices Including VAT".EDITABLE(TableSecurity."Prices Including VAT" = 0);
        CurrPAGE."Prices Including VAT".VISIBLE(TableSecurity."Prices Including VAT" IN [0,1,3,4]);
        IF TableSecurity."Prices Including VAT" IN [2,5] THEN
          SETRANGE("Prices Including VAT");
        IF CurrPAGE."Fax No.".EDITABLE THEN
          CurrPAGE."Fax No.".EDITABLE(TableSecurity."Fax No." = 0);
        CurrPAGE."Fax No.".VISIBLE(TableSecurity."Fax No." IN [0,1,3,4]);
        IF TableSecurity."Fax No." IN [2,5] THEN
          SETRANGE("Fax No.");
        IF CurrPAGE."VAT Registration No.".EDITABLE THEN
          CurrPAGE."VAT Registration No.".EDITABLE(TableSecurity."VAT Registration No." = 0);
        CurrPAGE."VAT Registration No.".VISIBLE(TableSecurity."VAT Registration No." IN [0,1,3,4]);
        IF TableSecurity."VAT Registration No." IN [2,5] THEN
          SETRANGE("VAT Registration No.");
        IF CurrPAGE."Gen. Bus. Posting Group".EDITABLE THEN
          CurrPAGE."Gen. Bus. Posting Group".EDITABLE(TableSecurity."Gen. Bus. Posting Group" = 0);
        CurrPAGE."Gen. Bus. Posting Group".VISIBLE(TableSecurity."Gen. Bus. Posting Group" IN [0,1,3,4]);
        IF TableSecurity."Gen. Bus. Posting Group" IN [2,5] THEN
          SETRANGE("Gen. Bus. Posting Group");
        IF CurrPAGE."Post Code".EDITABLE THEN
          CurrPAGE."Post Code".EDITABLE(TableSecurity."Post Code" = 0);
        CurrPAGE."Post Code".VISIBLE(TableSecurity."Post Code" IN [0,1,3,4]);
        IF TableSecurity."Post Code" IN [2,5] THEN
          SETRANGE("Post Code");
        IF CurrPAGE."E-Mail".EDITABLE THEN
          CurrPAGE."E-Mail".EDITABLE(TableSecurity."E-Mail" = 0);
        CurrPAGE."E-Mail".VISIBLE(TableSecurity."E-Mail" IN [0,1,3,4]);
        IF TableSecurity."E-Mail" IN [2,5] THEN
          SETRANGE("E-Mail");
        IF CurrPAGE."Home Page".EDITABLE THEN
          CurrPAGE."Home Page".EDITABLE(TableSecurity."Home Page" = 0);
        CurrPAGE."Home Page".VISIBLE(TableSecurity."Home Page" IN [0,1,3,4]);
        IF TableSecurity."Home Page" IN [2,5] THEN
          SETRANGE("Home Page");
        IF CurrPAGE."Tax Liable".EDITABLE THEN
          CurrPAGE."Tax Liable".EDITABLE(TableSecurity."Tax Liable" = 0);
        CurrPAGE."Tax Liable".VISIBLE(TableSecurity."Tax Liable" IN [0,1,3,4]);
        IF TableSecurity."Tax Liable" IN [2,5] THEN
          SETRANGE("Tax Liable");
        IF CurrPAGE."VAT Bus. Posting Group".EDITABLE THEN
          CurrPAGE."VAT Bus. Posting Group".EDITABLE(TableSecurity."VAT Bus. Posting Group" = 0);
        CurrPAGE."VAT Bus. Posting Group".VISIBLE(TableSecurity."VAT Bus. Posting Group" IN [0,1,3,4]);
        IF TableSecurity."VAT Bus. Posting Group" IN [2,5] THEN
          SETRANGE("VAT Bus. Posting Group");
        IF CurrPAGE."Block Payment Tolerance".EDITABLE THEN
          CurrPAGE."Block Payment Tolerance".EDITABLE(TableSecurity."Block Payment Tolerance" = 0);
        CurrPAGE."Block Payment Tolerance".VISIBLE(TableSecurity."Block Payment Tolerance" IN [0,1,3,4]);
        IF TableSecurity."Block Payment Tolerance" IN [2,5] THEN
          SETRANGE("Block Payment Tolerance");
        IF CurrPAGE."IC Partner Code".EDITABLE THEN
          CurrPAGE."IC Partner Code".EDITABLE(TableSecurity."IC Partner Code" = 0);
        CurrPAGE."IC Partner Code".VISIBLE(TableSecurity."IC Partner Code" IN [0,1,3,4]);
        IF TableSecurity."IC Partner Code" IN [2,5] THEN
          SETRANGE("IC Partner Code");
        IF CurrPAGE."Prepayment %".EDITABLE THEN
          CurrPAGE."Prepayment %".EDITABLE(TableSecurity."Prepayment %" = 0);
        CurrPAGE."Prepayment %".VISIBLE(TableSecurity."Prepayment %" IN [0,1,3,4]);
        IF TableSecurity."Prepayment %" IN [2,5] THEN
          SETRANGE("Prepayment %");
        IF CurrPAGE."Primary Contact No.".EDITABLE THEN
          CurrPAGE."Primary Contact No.".EDITABLE(TableSecurity."Primary Contact No." = 0);
        CurrPAGE."Primary Contact No.".VISIBLE(TableSecurity."Primary Contact No." IN [0,1,3,4]);
        IF TableSecurity."Primary Contact No." IN [2,5] THEN
          SETRANGE("Primary Contact No.");
        IF CurrPAGE."Location Code".EDITABLE THEN
          CurrPAGE."Location Code".EDITABLE(TableSecurity."Location Code" = 0);
        CurrPAGE."Location Code".VISIBLE(TableSecurity."Location Code" IN [0,1,3,4]);
        IF TableSecurity."Location Code" IN [2,5] THEN
          SETRANGE("Location Code");
        IF CurrPAGE."Lead Time Calculation".EDITABLE THEN
          CurrPAGE."Lead Time Calculation".EDITABLE(TableSecurity."Lead Time Calculation" = 0);
        CurrPAGE."Lead Time Calculation".VISIBLE(TableSecurity."Lead Time Calculation" IN [0,1,3,4]);
        IF TableSecurity."Lead Time Calculation" IN [2,5] THEN
          SETRANGE("Lead Time Calculation");
        IF CurrPAGE."Base Calendar Code".EDITABLE THEN
          CurrPAGE."Base Calendar Code".EDITABLE(TableSecurity."Base Calendar Code" = 0);
        CurrPAGE."Base Calendar Code".VISIBLE(TableSecurity."Base Calendar Code" IN [0,1,3,4]);
        IF TableSecurity."Base Calendar Code" IN [2,5] THEN
          SETRANGE("Base Calendar Code");
        IF CurrPAGE."T.I.N. No.".EDITABLE THEN
          CurrPAGE."T.I.N. No.".EDITABLE(TableSecurity."T.I.N. No." = 0);
        CurrPAGE."T.I.N. No.".VISIBLE(TableSecurity."T.I.N. No." IN [0,1,3,4]);
        IF TableSecurity."T.I.N. No." IN [2,5] THEN
          SETRANGE("T.I.N. No.");
        IF CurrPAGE."L.S.T. No.".EDITABLE THEN
          CurrPAGE."L.S.T. No.".EDITABLE(TableSecurity."L.S.T. No." = 0);
        CurrPAGE."L.S.T. No.".VISIBLE(TableSecurity."L.S.T. No." IN [0,1,3,4]);
        IF TableSecurity."L.S.T. No." IN [2,5] THEN
          SETRANGE("L.S.T. No.");
        IF CurrPAGE."C.S.T. No.".EDITABLE THEN
          CurrPAGE."C.S.T. No.".EDITABLE(TableSecurity."C.S.T. No." = 0);
        CurrPAGE."C.S.T. No.".VISIBLE(TableSecurity."C.S.T. No." IN [0,1,3,4]);
        IF TableSecurity."C.S.T. No." IN [2,5] THEN
          SETRANGE("C.S.T. No.");
        IF CurrPAGE."P.A.N. No.".EDITABLE THEN
          CurrPAGE."P.A.N. No.".EDITABLE(TableSecurity."P.A.N. No." = 0);
        CurrPAGE."P.A.N. No.".VISIBLE(TableSecurity."P.A.N. No." IN [0,1,3,4]);
        IF TableSecurity."P.A.N. No." IN [2,5] THEN
          SETRANGE("P.A.N. No.");
        IF CurrPAGE."E.C.C. No.".EDITABLE THEN
          CurrPAGE."E.C.C. No.".EDITABLE(TableSecurity."E.C.C. No." = 0);
        CurrPAGE."E.C.C. No.".VISIBLE(TableSecurity."E.C.C. No." IN [0,1,3,4]);
        IF TableSecurity."E.C.C. No." IN [2,5] THEN
          SETRANGE("E.C.C. No.");
        IF CurrPAGE.Range.EDITABLE THEN
          CurrPAGE.Range.EDITABLE(TableSecurity.Range = 0);
        CurrPAGE.Range.VISIBLE(TableSecurity.Range IN [0,1,3,4]);
        IF TableSecurity.Range IN [2,5] THEN
          SETRANGE(Range);
        IF CurrPAGE.Collectorate.EDITABLE THEN
          CurrPAGE.Collectorate.EDITABLE(TableSecurity.Collectorate = 0);
        CurrPAGE.Collectorate.VISIBLE(TableSecurity.Collectorate IN [0,1,3,4]);
        IF TableSecurity.Collectorate IN [2,5] THEN
          SETRANGE(Collectorate);
        IF CurrPAGE."State Code".EDITABLE THEN
          CurrPAGE."State Code".EDITABLE(TableSecurity."State Code" = 0);
        CurrPAGE."State Code".VISIBLE(TableSecurity."State Code" IN [0,1,3,4]);
        IF TableSecurity."State Code" IN [2,5] THEN
          SETRANGE("State Code");
        IF CurrPAGE."Excise Bus. Posting Group".EDITABLE THEN
          CurrPAGE."Excise Bus. Posting Group".EDITABLE(TableSecurity."Excise Bus. Posting Group" = 0);
        CurrPAGE."Excise Bus. Posting Group".VISIBLE(TableSecurity."Excise Bus. Posting Group" IN [0,1,3,4]);
        IF TableSecurity."Excise Bus. Posting Group" IN [2,5] THEN
          SETRANGE("Excise Bus. Posting Group");
        IF CurrPAGE."Vendor Type".EDITABLE THEN
          CurrPAGE."Vendor Type".EDITABLE(TableSecurity."Vendor Type" = 0);
        CurrPAGE."Vendor Type".VISIBLE(TableSecurity."Vendor Type" IN [0,1,3,4]);
        IF TableSecurity."Vendor Type" IN [2,5] THEN
          SETRANGE("Vendor Type");
        IF CurrPAGE.Subcontractor.EDITABLE THEN
          CurrPAGE.Subcontractor.EDITABLE(TableSecurity.Subcontractor = 0);
        CurrPAGE.Subcontractor.VISIBLE(TableSecurity.Subcontractor IN [0,1,3,4]);
        IF TableSecurity.Subcontractor IN [2,5] THEN
          SETRANGE(Subcontractor);
        IF CurrPAGE."Vendor Location".EDITABLE THEN
          CurrPAGE."Vendor Location".EDITABLE(TableSecurity."Vendor Location" = 0);
        CurrPAGE."Vendor Location".VISIBLE(TableSecurity."Vendor Location" IN [0,1,3,4]);
        IF TableSecurity."Vendor Location" IN [2,5] THEN
          SETRANGE("Vendor Location");
        IF CurrPAGE."Commissioner's Permission No.".EDITABLE THEN
          CurrPAGE."Commissioner's Permission No.".EDITABLE(TableSecurity."Commissioner's Permission No." = 0);
        CurrPAGE."Commissioner's Permission No.".VISIBLE(TableSecurity."Commissioner's Permission No." IN [0,1,3,4]);
        IF TableSecurity."Commissioner's Permission No." IN [2,5] THEN
          SETRANGE("Commissioner's Permission No.");
        IF CurrPAGE."Service Tax Registration No.".EDITABLE THEN
          CurrPAGE."Service Tax Registration No.".EDITABLE(TableSecurity."Service Tax Registration No." = 0);
        CurrPAGE."Service Tax Registration No.".VISIBLE(TableSecurity."Service Tax Registration No." IN [0,1,3,4]);
        IF TableSecurity."Service Tax Registration No." IN [2,5] THEN
          SETRANGE("Service Tax Registration No.");
        IF CurrPAGE.GTA.EDITABLE THEN
          CurrPAGE.GTA.EDITABLE(TableSecurity.GTA = 0);
        CurrPAGE.GTA.VISIBLE(TableSecurity.GTA IN [0,1,3,4]);
        IF TableSecurity.GTA IN [2,5] THEN
          SETRANGE(GTA);
        IF CurrPAGE."P.A.N. Reference No.".EDITABLE THEN
          CurrPAGE."P.A.N. Reference No.".EDITABLE(TableSecurity."P.A.N. Reference No." = 0);
        CurrPAGE."P.A.N. Reference No.".VISIBLE(TableSecurity."P.A.N. Reference No." IN [0,1,3,4]);
        IF TableSecurity."P.A.N. Reference No." IN [2,5] THEN
          SETRANGE("P.A.N. Reference No.");
        IF CurrPAGE."P.A.N. Status".EDITABLE THEN
          CurrPAGE."P.A.N. Status".EDITABLE(TableSecurity."P.A.N. Status" = 0);
        CurrPAGE."P.A.N. Status".VISIBLE(TableSecurity."P.A.N. Status" IN [0,1,3,4]);
        IF TableSecurity."P.A.N. Status" IN [2,5] THEN
          SETRANGE("P.A.N. Status");
        IF CurrPAGE.Composition.EDITABLE THEN
          CurrPAGE.Composition.EDITABLE(TableSecurity.Composition = 0);
        CurrPAGE.Composition.VISIBLE(TableSecurity.Composition IN [0,1,3,4]);
        IF TableSecurity.Composition IN [2,5] THEN
          SETRANGE(Composition);
        IF CurrPAGE."Net Change - Advance (LCY)".EDITABLE THEN
          CurrPAGE."Net Change - Advance (LCY)".EDITABLE(TableSecurity."Net Change - Advance (LCY)" = 0);
        CurrPAGE."Net Change - Advance (LCY)".VISIBLE(TableSecurity."Net Change - Advance (LCY)" IN [0,1,3,4]);
        IF TableSecurity."Net Change - Advance (LCY)" IN [2,5] THEN
          SETRANGE("Net Change - Advance (LCY)");
        IF CurrPAGE."Net Change - Running (LCY)".EDITABLE THEN
          CurrPAGE."Net Change - Running (LCY)".EDITABLE(TableSecurity."Net Change - Running (LCY)" = 0);
        CurrPAGE."Net Change - Running (LCY)".VISIBLE(TableSecurity."Net Change - Running (LCY)" IN [0,1,3,4]);
        IF TableSecurity."Net Change - Running (LCY)" IN [2,5] THEN
          SETRANGE("Net Change - Running (LCY)");
        IF CurrPAGE."Net Change - Retention (LCY)".EDITABLE THEN
          CurrPAGE."Net Change - Retention (LCY)".EDITABLE(TableSecurity."Net Change - Retention (LCY)" = 0);
        CurrPAGE."Net Change - Retention (LCY)".VISIBLE(TableSecurity."Net Change - Retention (LCY)" IN [0,1,3,4]);
        IF TableSecurity."Net Change - Retention (LCY)" IN [2,5] THEN
          SETRANGE("Net Change - Retention (LCY)");
        IF CurrPAGE."Net Change - Secured Adv (LCY)".EDITABLE THEN
          CurrPAGE."Net Change - Secured Adv (LCY)".EDITABLE(TableSecurity."Net Change - Secured Adv (LCY)" = 0);
        CurrPAGE."Net Change - Secured Adv (LCY)".VISIBLE(TableSecurity."Net Change - Secured Adv (LCY)" IN [0,1,3,4]);
        IF TableSecurity."Net Change - Secured Adv (LCY)" IN [2,5] THEN
          SETRANGE("Net Change - Secured Adv (LCY)");
        IF CurrPAGE."Net Change - Adhoc Adv (LCY)".EDITABLE THEN
          CurrPAGE."Net Change - Adhoc Adv (LCY)".EDITABLE(TableSecurity."Net Change - Adhoc Adv (LCY)" = 0);
        CurrPAGE."Net Change - Adhoc Adv (LCY)".VISIBLE(TableSecurity."Net Change - Adhoc Adv (LCY)" IN [0,1,3,4]);
        IF TableSecurity."Net Change - Adhoc Adv (LCY)" IN [2,5] THEN
          SETRANGE("Net Change - Adhoc Adv (LCY)");
        IF CurrPAGE."Net Change - Provisional (LCY)".EDITABLE THEN
          CurrPAGE."Net Change - Provisional (LCY)".EDITABLE(TableSecurity."Net Change - Provisional (LCY)" = 0);
        CurrPAGE."Net Change - Provisional (LCY)".VISIBLE(TableSecurity."Net Change - Provisional (LCY)" IN [0,1,3,4]);
        IF TableSecurity."Net Change - Provisional (LCY)" IN [2,5] THEN
          SETRANGE("Net Change - Provisional (LCY)");
        IF CurrPAGE."Address 3".EDITABLE THEN
          CurrPAGE."Address 3".EDITABLE(TableSecurity."Address 3" = 0);
        CurrPAGE."Address 3".VISIBLE(TableSecurity."Address 3" IN [0,1,3,4]);
        IF TableSecurity."Address 3" IN [2,5] THEN
          SETRANGE("Address 3");
        IF CurrPAGE."Phone No. 2".EDITABLE THEN
          CurrPAGE."Phone No. 2".EDITABLE(TableSecurity."Phone No. 2" = 0);
        CurrPAGE."Phone No. 2".VISIBLE(TableSecurity."Phone No. 2" IN [0,1,3,4]);
        IF TableSecurity."Phone No. 2" IN [2,5] THEN
          SETRANGE("Phone No. 2");
        IF CurrPAGE."Mob. No.".EDITABLE THEN
          CurrPAGE."Mob. No.".EDITABLE(TableSecurity."Mob. No." = 0);
        CurrPAGE."Mob. No.".VISIBLE(TableSecurity."Mob. No." IN [0,1,3,4]);
        IF TableSecurity."Mob. No." IN [2,5] THEN
          SETRANGE("Mob. No.");
        IF CurrPAGE."Net Change - LD (LCY)".EDITABLE THEN
          CurrPAGE."Net Change - LD (LCY)".EDITABLE(TableSecurity."Net Change - LD (LCY)" = 0);
        CurrPAGE."Net Change - LD (LCY)".VISIBLE(TableSecurity."Net Change - LD (LCY)" IN [0,1,3,4]);
        IF TableSecurity."Net Change - LD (LCY)" IN [2,5] THEN
          SETRANGE("Net Change - LD (LCY)");
        IF CurrPAGE."Vendor Category".EDITABLE THEN
          CurrPAGE."Vendor Category".EDITABLE(TableSecurity."Vendor Category" = 0);
        CurrPAGE."Vendor Category".VISIBLE(TableSecurity."Vendor Category" IN [0,1,3,4]);
        IF TableSecurity."Vendor Category" IN [2,5] THEN
          SETRANGE("Vendor Category");
        //IF CurrPAGE."MSMED Classification".EDITABLE THEN
        //  CurrPAGE."MSMED Classification".EDITABLE(TableSecurity."MSMED Classification" = 0);
        //CurrPAGE."MSMED Classification".VISIBLE(TableSecurity."MSMED Classification" IN [0,1,3,4]);
        IF TableSecurity."MSMED Classification" IN [2,5] THEN
          SETRANGE("MSMED Classification");
        IF CurrPAGE."Balance at Date (LCY)".EDITABLE THEN
          CurrPAGE."Balance at Date (LCY)".EDITABLE(TableSecurity."Balance at Date (LCY)" = 0);
        CurrPAGE."Balance at Date (LCY)".VISIBLE(TableSecurity."Balance at Date (LCY)" IN [0,1,3,4]);
        IF TableSecurity."Balance at Date (LCY)" IN [2,5] THEN
          SETRANGE("Balance at Date (LCY)");
        IF CurrPAGE."Validity till date".EDITABLE THEN
          CurrPAGE."Validity till date".EDITABLE(TableSecurity."Validity till date" = 0);
        CurrPAGE."Validity till date".VISIBLE(TableSecurity."Validity till date" IN [0,1,3,4]);
        IF TableSecurity."Validity till date" IN [2,5] THEN
          SETRANGE("Validity till date");
        //IF CurrPAGE."Authorized Agent of".EDITABLE THEN
        //  CurrPAGE."Authorized Agent of".EDITABLE(TableSecurity."Authorized Agent of" = 0);
        //CurrPAGE."Authorized Agent of".VISIBLE(TableSecurity."Authorized Agent of" IN [0,1,3,4]);
        IF TableSecurity."Authorized Agent of" IN [2,5] THEN
          SETRANGE("Authorized Agent of");
        */
        //ALLEDK 030313

    end;

    local procedure ContactOnAfterValidate()
    begin
        ActivateFields;
    end;

    local procedure ICPartnerCodeOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;

    local procedure PANStatusC1500001OnAfterValida()
    begin
        ActivateFields();
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        ActivateFields;
    end;
}

