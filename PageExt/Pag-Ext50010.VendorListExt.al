pageextension 50010 "BBG Vendor List Ext" extends "Vendor List"
{
    InsertAllowed = false;
    //SourceView = WHERE("BBG Black List" = CONST(false));
    layout
    {
        // Add changes to page layout here
        modify("Payment Terms Code")
        {
            Visible = false;
        }
        modify("IC Partner Code")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        addafter(Name)
        {
            field("Old No."; Rec."BBG Old No.")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Date of Joining"; Rec."BBG Date of Joining")
            {
                ApplicationArea = All;
            }
            field("Net Change (LCY)"; Rec."Net Change (LCY)")
            {
                ApplicationArea = All;
            }
            field(Address; Rec.Address)
            {
                Visible = AddVisible;
                ApplicationArea = All;
            }
            field(City; Rec.City)
            {
                ApplicationArea = All;
            }
            field("Mob. No."; Rec."BBG Mob. No.")
            {
                Visible = MobVisible;
                ApplicationArea = All;
            }
            field(Sex; Rec."BBG Sex")
            {
                Caption = 'Gender';
                ApplicationArea = All;
            }
            field("Reporting Office"; Rec."BBG Reporting Office")
            {
                ApplicationArea = All;
            }
            field("New Cluster Code"; Rec."BBG New Cluster Code")
            {
                Caption = 'Cluster Code';
                ApplicationArea = All;
            }
            field("Balance at Date (LCY)"; Rec."BBG Balance at Date (LCY)")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Payable G/L Account No."; Rec."BBG Payable G/L Account No.")
            {
                ApplicationArea = All;
            }
            field(Status; Rec."BBG Status")
            {
                ApplicationArea = All;
            }
            field("P.A.N. No."; Rec."P.A.N. No.")
            {
                ApplicationArea = All;
            }
            field("Vendor Category"; Rec."BBG Vendor Category")
            {
                ApplicationArea = All;
            }
            field("Creation Date"; Rec."BBG Creation Date")
            {
                ApplicationArea = All;
            }

            field("Black List"; Rec."BBG Black List")
            {
                ApplicationArea = All;
            }

            field("Ass.Block forteam Pos. Report"; Rec."BBG Ass.Block forteam Pos. Report")
            {
                Caption = 'Associate block for Team positive report';
                ApplicationArea = All;
            }
            field("Associate Responcbility Center"; Rec."BBG Associate Responcbility Center")
            {
                ApplicationArea = All;
            }
            field(Introducer; Rec."BBG Introducer")
            {
                ApplicationArea = All;
            }
            field("Associate Type"; Rec."BBG Associate Type")
            {
                ApplicationArea = All;
            }
            field("Team Code"; Rec."BBG Team Code")
            {
                Caption = 'Team Code';
                ApplicationArea = All;
            }
            field("Leader Code"; Rec."BBG Leader Code")
            {
                ApplicationArea = All;
            }
            field("Sub Team Code"; Rec."BBG Sub Team Code")
            {
                ApplicationArea = All;
            }
            field("State Code"; Rec."State Code")
            {
                ApplicationArea = All;
            }
            field("District Code"; Rec."District Code")
            {
                ApplicationArea = All;
            }
            field("Mandal Code"; Rec."Mandal Code")
            {
                ApplicationArea = All;
            }
            field("Village Code"; Rec."Village Code")
            {
                ApplicationArea = All;
            }
            field("Cluster Type"; Rec."BBG Cluster Type")
            {
                Editable = false;
                OptionCaption = ' ,South - HYD,West - HYD,East - HYD,North - Vizag,West - Vizag,South - Vizag,Kadthal,Rajamahendravaram,Nellore,Ongole';
                ApplicationArea = All;
            }
            field("Rank Code"; Rec."BBG Rank Code")
            {
                ApplicationArea = All;
            }
            field("Created By"; Rec."BBG Created By")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Ven&dor")
        {
            action("IBA New")
            {
                Image = NewOrder;
                Promoted = true;
                ApplicationArea = All;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    CompanywiseGLAccount: Record "Company wise G/L Account";
                    VendorTemplate: Record "Vendor Templ.";
                    NoSeriesMgmt: Codeunit NoSeriesManagement;
                    AllowedSection: Record "Allowed Sections";
                begin
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE(CompanywiseGLAccount."MSC Company", TRUE);
                    IF CompanywiseGLAccount.FINDFIRST THEN;
                    IF COMPANYNAME <> CompanywiseGLAccount."Company Code" THEN
                        ERROR('IBA Creation only from -' + CompanywiseGLAccount."Company Code");

                    IF CONFIRM(Text003) THEN BEGIN
                        VendorTemplate.Reset();
                        VendorTemplate.SetRange("BBG Vendor Category", VendorTemplate."BBG Vendor Category"::"IBA(Associates)");
                        if VendorTemplate.FindFirst() Then begin
                            RecVendor.INIT;
                            RecVendor."BBG Vendor Category" := RecVendor."BBG Vendor Category"::"IBA(Associates)";
                            RecVendor."No." := NoSeriesMgmt.GetNextNo(VendorTemplate."No. Series", Today, true);
                            RecVendor.Validate("Assessee Code", 'IND');
                            RecVendor."BBG Date of Joining" := TODAY;
                            RecVendor."BBG Date of Birth" := 19900101D;
                            RecVendor."BBG Sex" := RecVendor."BBG Sex"::Male;
                            RecVendor."BBG Marital Status" := RecVendor."BBG Marital Status"::Unmarried;
                            RecVendor."BBG Nationality" := 'INDIAN';
                            RecVendor."BBG Associate Creation" := RecVendor."BBG Associate Creation"::New;
                            RecVendor."Tax Liable" := TRUE;
                            RecVendor."BBG Creation Date" := WorkDate;//ALLECK 270313
                            RecVendor."BBG Print Associate Name/Mobile" := TRUE;
                            RecVendor."BBG Created By" := USERID; //220524
                            RecVendor.INSERT(TRUE);

                            //RecVendor.Modify();
                            AllowedSection.Init();
                            AllowedSection."Vendor No" := RecVendor."No.";
                            AllowedSection.Validate("TDS Section", '194H');
                            AllowedSection.Insert(true);
                            PAGE.RUN(PAGE::"Vendor Card", RecVendor);
                        END;
                    End;
                end;
            }
            action("Supplier New")
            {
                Image = NewOrder;
                Promoted = true;
                ApplicationArea = All;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    VendorTemplate: Record "Vendor Templ.";
                    NoSeriesMgmt: Codeunit NoSeriesManagement;
                begin
                    IF CONFIRM(Text002) THEN BEGIN
                        VendorTemplate.Reset();
                        VendorTemplate.SetRange("BBG Vendor Category", VendorTemplate."BBG Vendor Category"::Supplier);
                        if VendorTemplate.FindFirst() Then begin
                            RecVendor.INIT;
                            RecVendor."BBG Vendor Category" := RecVendor."BBG Vendor Category"::Supplier;
                            RecVendor."No." := NoSeriesMgmt.GetNextNo(VendorTemplate."No. Series", Today, true);
                            RecVendor.INSERT(TRUE);
                            PAGE.RUN(PAGE::"Vendor Card", RecVendor);
                        END;
                    End;
                end;
            }
            action("Contractor New")
            {
                Image = NewOrder;
                Promoted = true;
                ApplicationArea = All;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    VendorTemplate: Record "Vendor Templ.";
                    NoSeriesMgmt: Codeunit NoSeriesManagement;
                begin
                    IF CONFIRM(Text004) THEN BEGIN
                        VendorTemplate.Reset();
                        VendorTemplate.SetRange("BBG Vendor Category", VendorTemplate."BBG Vendor Category"::Contractor);
                        if VendorTemplate.FindFirst() Then begin
                            RecVendor.INIT;
                            RecVendor."BBG Vendor Category" := RecVendor."BBG Vendor Category"::Contractor;
                            RecVendor."No." := NoSeriesMgmt.GetNextNo(VendorTemplate."No. Series", Today, true);
                            RecVendor.INSERT(TRUE);
                            PAGE.RUN(PAGE::"Vendor Card", RecVendor);
                        END;
                    End;
                end;
            }
            action("CP(Channel Partner) New")
            {
                Image = NewOrder;
                Promoted = true;
                ApplicationArea = All;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CompanywiseGLAccount: Record "Company wise G/L Account";
                    VendorTemplate: Record "Vendor Templ.";
                    NoSeriesMgmt: Codeunit NoSeriesManagement;
                    AllowedSection: Record "Allowed Sections";
                begin
                    CompanywiseGLAccount.RESET;
                    CompanywiseGLAccount.SETRANGE(CompanywiseGLAccount."MSC Company", TRUE);
                    IF CompanywiseGLAccount.FINDFIRST THEN;
                    IF COMPANYNAME <> CompanywiseGLAccount."Company Code" THEN
                        ERROR('Channel Partner Creation only from -' + CompanywiseGLAccount."Company Code");

                    IF CONFIRM(Text005) THEN BEGIN
                        VendorTemplate.Reset();
                        VendorTemplate.SetRange("BBG Vendor Category", VendorTemplate."BBG Vendor Category"::"CP(Channel Partner)");
                        if VendorTemplate.FindFirst() Then begin
                            RecVendor.INIT;
                            RecVendor."BBG Vendor Category" := RecVendor."BBG Vendor Category"::"CP(Channel Partner)";
                            RecVendor."BBG CP Designation" := RecVendor."BBG CP Designation"::Firm;
                            RecVendor."No." := NoSeriesMgmt.GetNextNo(VendorTemplate."No. Series", Today, true);
                            RecVendor.Validate("Assessee Code", 'IND');
                            RecVendor."BBG Date of Joining" := TODAY;
                            RecVendor."BBG Date of Birth" := 19900101D;
                            RecVendor."BBG Sex" := RecVendor."BBG Sex"::Male;
                            RecVendor."BBG Marital Status" := RecVendor."BBG Marital Status"::Unmarried;
                            RecVendor."BBG Nationality" := 'INDIAN';
                            RecVendor."BBG Associate Creation" := RecVendor."BBG Associate Creation"::New;
                            RecVendor."Tax Liable" := TRUE;
                            RecVendor."BBG Creation Date" := WorkDate;//ALLECK 270313
                            RecVendor."BBG Print Associate Name/Mobile" := TRUE;
                            RecVendor."BBG Created By" := USERID; //220524
                            RecVendor.INSERT(TRUE);

                            //RecVendor.Modify();
                            AllowedSection.Init();
                            AllowedSection."Vendor No" := RecVendor."No.";
                            AllowedSection.Validate("TDS Section", '194H');
                            AllowedSection.Insert(true);
                            PAGE.RUN(PAGE::"Vendor Card", RecVendor);
                        END;
                    end;
                End;
            }

        }
    }

    var
        myInt: Integer;
        RunningAmount: Decimal;
        RetentionAmount: Decimal;
        AdvanceAmount: Decimal;
        memberof: Record "Access Control";
        MobVisible: Boolean;
        AddVisible: Boolean;
        Add2Visible: Boolean;
        Add3Visible: Boolean;
        PhVisible: Boolean;
        Ph2Visible: Boolean;
        ContactVisible: Boolean;
        RecVendor: Record Vendor;
        Text003: Label 'Are you sure you want to create New Associate?';
        Text004: Label 'Are you sure you want to create New Contractor?';
        Text002: Label 'Are you sure you want to create New Supplier?';
        Text005: Label 'Are you sure you want to create New Channel Partner?';

    trigger OnOpenPage()
    begin
        Showfields;  //BBG2.01 010814
        Rec.FilterGroup(10);
        Rec.SetRange("BBG Black List", false);
        Rec.FilterGroup(0);
    end;

    trigger OnAfterGetRecord()
    begin
        Showfields;
    end;


    PROCEDURE GetRunningAmount()
    VAR
        VendorLedgeEntry: Record "Vendor Ledger Entry";
    BEGIN
        RunningAmount := 0;
        VendorLedgeEntry.RESET;
        VendorLedgeEntry.SETCURRENTKEY("Vendor No.", "Posting Type");
        VendorLedgeEntry.SETRANGE(VendorLedgeEntry."Vendor No.", Rec."No.");
        VendorLedgeEntry.SETRANGE(VendorLedgeEntry."Posting Type", VendorLedgeEntry."Posting Type"::Running);
        VendorLedgeEntry.SETFILTER(VendorLedgeEntry."Global Dimension 1 Code", Rec."Global Dimension 1 Filter");
        IF VendorLedgeEntry.FIND('-') THEN
            REPEAT
                VendorLedgeEntry.CALCFIELDS(VendorLedgeEntry."Remaining Amt. (LCY)");
                RunningAmount := RunningAmount + VendorLedgeEntry."Remaining Amt. (LCY)";
            UNTIL VendorLedgeEntry.NEXT = 0;
    END;

    PROCEDURE GetRetentionAmount()
    VAR
        VendorLedgeEntry: Record "Vendor Ledger Entry";
    BEGIN
        RetentionAmount := 0;
        VendorLedgeEntry.RESET;
        VendorLedgeEntry.SETCURRENTKEY("Vendor No.", "Posting Type");
        VendorLedgeEntry.SETRANGE(VendorLedgeEntry."Vendor No.", Rec."No.");
        VendorLedgeEntry.SETRANGE(VendorLedgeEntry."Posting Type", VendorLedgeEntry."Posting Type"::Retention);
        VendorLedgeEntry.SETFILTER(VendorLedgeEntry."Global Dimension 1 Code", Rec."Global Dimension 1 Filter");
        IF VendorLedgeEntry.FIND('-') THEN
            REPEAT
                VendorLedgeEntry.CALCFIELDS(VendorLedgeEntry."Remaining Amt. (LCY)");
                RetentionAmount := RetentionAmount + VendorLedgeEntry."Remaining Amt. (LCY)";
            UNTIL VendorLedgeEntry.NEXT = 0;
    END;

    PROCEDURE GetAdvanceAmount()
    VAR
        VendorLedgeEntry: Record "Vendor Ledger Entry";
    BEGIN
        AdvanceAmount := 0;
        VendorLedgeEntry.RESET;
        VendorLedgeEntry.SETCURRENTKEY("Vendor No.", "Posting Type");
        VendorLedgeEntry.SETRANGE(VendorLedgeEntry."Vendor No.", Rec."No.");
        VendorLedgeEntry.SETRANGE(VendorLedgeEntry."Posting Type", VendorLedgeEntry."Posting Type"::Advance);
        VendorLedgeEntry.SETFILTER(VendorLedgeEntry."Global Dimension 1 Code", Rec."Global Dimension 1 Filter");
        IF VendorLedgeEntry.FIND('-') THEN
            REPEAT
                VendorLedgeEntry.CALCFIELDS(VendorLedgeEntry."Remaining Amt. (LCY)");
                AdvanceAmount := AdvanceAmount + VendorLedgeEntry."Remaining Amt. (LCY)";
            UNTIL VendorLedgeEntry.NEXT = 0;
    END;

    LOCAL PROCEDURE SetSecurity(OpenForm: Boolean);
    BEGIN
        //   //ALLEDK 030313
        //   IF OpenForm THEN BEGIN
        //     IF NOT Security.GetSecurity(FORM::"Vendor List") THEN
        //       EXIT;

        //     IF Security."Form General Permission" = Security."Form General Permission"::Visible THEN
        //       CurrForm.EDI(FALSE);

        //     Security.SetFieldFilters(Rec);
        //   END ELSE
        //     IF Security."Security for Form No." = 0 THEN
        //       EXIT;

        //   IF CurrForm."No.".EDI THEN
        //     CurrForm."No.".EDI(Security."No." = 0);
        //   IF Security."No." IN [2,5] THEN BEGIN
        //     CurrForm."No.".VISIBLE(FALSE);
        //     SETRANGE("No.");
        //   END;
        //   IF CurrForm.Name.EDI THEN
        //     CurrForm.Name.EDI(Security.Name = 0);
        //   IF Security.Name IN [2,5] THEN BEGIN
        //     CurrForm.Name.VISIBLE(FALSE);
        //     SETRANGE(Name);
        //   END;
        //   IF CurrForm."Search Name".EDI THEN
        //     CurrForm."Search Name".EDI(Security."Search Name" = 0);
        //   IF Security."Search Name" IN [2,5] THEN BEGIN
        //     CurrForm."Search Name".VISIBLE(FALSE);
        //     SETRANGE("Search Name");
        //   END;
        //   IF CurrForm."Name 2".EDI THEN
        //     CurrForm."Name 2".EDI(Security."Name 2" = 0);
        //   IF Security."Name 2" IN [2,5] THEN BEGIN
        //     CurrForm."Name 2".VISIBLE(FALSE);
        //     SETRANGE("Name 2");
        //   END;
        //   IF CurrForm.Address.EDI THEN
        //     CurrForm.Address.EDI(Security.Address = 0);
        //   IF Security.Address IN [2,5] THEN BEGIN
        //     CurrForm.Address.VISIBLE(FALSE);
        //     SETRANGE(Address);
        //   END;
        //   IF CurrForm."Address 2".EDI THEN
        //     CurrForm."Address 2".EDI(Security."Address 2" = 0);
        //   IF Security."Address 2" IN [2,5] THEN BEGIN
        //     CurrForm."Address 2".VISIBLE(FALSE);
        //     SETRANGE("Address 2");
        //   END;
        //   IF CurrForm.City.EDI THEN
        //     CurrForm.City.EDI(Security.City = 0);
        //   IF Security.City IN [2,5] THEN BEGIN
        //     CurrForm.City.VISIBLE(FALSE);
        //     SETRANGE(City);
        //   END;
        //   IF CurrForm.Contact.EDI THEN
        //     CurrForm.Contact.EDI(Security.Contact = 0);
        //   IF Security.Contact IN [2,5] THEN BEGIN
        //     CurrForm.Contact.VISIBLE(FALSE);
        //     SETRANGE(Contact);
        //   END;
        //   IF CurrForm."Phone No.".EDI THEN
        //     CurrForm."Phone No.".EDI(Security."Phone No." = 0);
        //   IF Security."Phone No." IN [2,5] THEN BEGIN
        //     CurrForm."Phone No.".VISIBLE(FALSE);
        //     SETRANGE("Phone No.");
        //   END;
        //   IF CurrForm."Vendor Posting Group".EDI THEN
        //     CurrForm."Vendor Posting Group".EDI(Security."Vendor Posting Group" = 0);
        //   IF Security."Vendor Posting Group" IN [2,5] THEN BEGIN
        //     CurrForm."Vendor Posting Group".VISIBLE(FALSE);
        //     SETRANGE("Vendor Posting Group");
        //   END;
        //   IF CurrForm."Payment Terms Code".EDI THEN
        //     CurrForm."Payment Terms Code".EDI(Security."Payment Terms Code" = 0);
        //   IF Security."Payment Terms Code" IN [2,5] THEN BEGIN
        //     CurrForm."Payment Terms Code".VISIBLE(FALSE);
        //     SETRANGE("Payment Terms Code");
        //   END;
        //   IF CurrForm."Fin. Charge Terms Code".EDI THEN
        //     CurrForm."Fin. Charge Terms Code".EDI(Security."Fin. Charge Terms Code" = 0);
        //   IF Security."Fin. Charge Terms Code" IN [2,5] THEN BEGIN
        //     CurrForm."Fin. Charge Terms Code".VISIBLE(FALSE);
        //     SETRANGE("Fin. Charge Terms Code");
        //   END;
        //   IF CurrForm."Purchaser Code".EDI THEN
        //     CurrForm."Purchaser Code".EDI(Security."Purchaser Code" = 0);
        //   IF Security."Purchaser Code" IN [2,5] THEN BEGIN
        //     CurrForm."Purchaser Code".VISIBLE(FALSE);
        //     SETRANGE("Purchaser Code");
        //   END;
        //   IF CurrForm."Country/Region Code".EDI THEN
        //     CurrForm."Country/Region Code".EDI(Security."Country/Region Code" = 0);
        //   IF Security."Country/Region Code" IN [2,5] THEN BEGIN
        //     CurrForm."Country/Region Code".VISIBLE(FALSE);
        //     SETRANGE("Country/Region Code");
        //   END;
        //   IF CurrForm.Blocked.EDI THEN
        //     CurrForm.Blocked.EDI(Security.Blocked = 0);
        //   IF Security.Blocked IN [2,5] THEN BEGIN
        //     CurrForm.Blocked.VISIBLE(FALSE);
        //     SETRANGE(Blocked);
        //   END;
        //   IF CurrForm."Pay-to Vendor No.".EDI THEN
        //     CurrForm."Pay-to Vendor No.".EDI(Security."Pay-to Vendor No." = 0);
        //   IF Security."Pay-to Vendor No." IN [2,5] THEN BEGIN
        //     CurrForm."Pay-to Vendor No.".VISIBLE(FALSE);
        //     SETRANGE("Pay-to Vendor No.");
        //   END;
        //   IF CurrForm."Balance (LCY)".EDI THEN
        //     CurrForm."Balance (LCY)".EDI(Security."Balance (LCY)" = 0);
        //   IF Security."Balance (LCY)" IN [2,5] THEN BEGIN
        //     CurrForm."Balance (LCY)".VISIBLE(FALSE);
        //     SETRANGE("Balance (LCY)");
        //   END;
        //   IF CurrForm."Fax No.".EDI THEN
        //     CurrForm."Fax No.".EDI(Security."Fax No." = 0);
        //   IF Security."Fax No." IN [2,5] THEN BEGIN
        //     CurrForm."Fax No.".VISIBLE(FALSE);
        //     SETRANGE("Fax No.");
        //   END;
        //   IF CurrForm."Gen. Bus. Posting Group".EDI THEN
        //     CurrForm."Gen. Bus. Posting Group".EDI(Security."Gen. Bus. Posting Group" = 0);
        //   IF Security."Gen. Bus. Posting Group" IN [2,5] THEN BEGIN
        //     CurrForm."Gen. Bus. Posting Group".VISIBLE(FALSE);
        //     SETRANGE("Gen. Bus. Posting Group");
        //   END;
        //   IF CurrForm."Post Code".EDI THEN
        //     CurrForm."Post Code".EDI(Security."Post Code" = 0);
        //   IF Security."Post Code" IN [2,5] THEN BEGIN
        //     CurrForm."Post Code".VISIBLE(FALSE);
        //     SETRANGE("Post Code");
        //   END;
        //   IF CurrForm."T.I.N. No.".EDI THEN
        //     CurrForm."T.I.N. No.".EDI(Security."T.I.N. No." = 0);
        //   IF Security."T.I.N. No." IN [2,5] THEN BEGIN
        //     CurrForm."T.I.N. No.".VISIBLE(FALSE);
        //     SETRANGE("T.I.N. No.");
        //   END;
        //   IF CurrForm."P.A.N. No.".EDI THEN
        //     CurrForm."P.A.N. No.".EDI(Security."P.A.N. No." = 0);
        //   IF Security."P.A.N. No." IN [2,5] THEN BEGIN
        //     CurrForm."P.A.N. No.".VISIBLE(FALSE);
        //     SETRANGE("P.A.N. No.");
        //   END;
        //   IF CurrForm."State Code".EDI THEN
        //     CurrForm."State Code".EDI(Security."State Code" = 0);
        //   IF Security."State Code" IN [2,5] THEN BEGIN
        //     CurrForm."State Code".VISIBLE(FALSE);
        //     SETRANGE("State Code");
        //   END;
        //   IF CurrForm."P.A.N. Reference No.".EDI THEN
        //     CurrForm."P.A.N. Reference No.".EDI(Security."P.A.N. Reference No." = 0);
        //   IF Security."P.A.N. Reference No." IN [2,5] THEN BEGIN
        //     CurrForm."P.A.N. Reference No.".VISIBLE(FALSE);
        //     SETRANGE("P.A.N. Reference No.");
        //   END;
        //   IF CurrForm."P.A.N. Status".EDI THEN
        //     CurrForm."P.A.N. Status".EDI(Security."P.A.N. Status" = 0);
        //   IF Security."P.A.N. Status" IN [2,5] THEN BEGIN
        //     CurrForm."P.A.N. Status".VISIBLE(FALSE);
        //     SETRANGE("P.A.N. Status");
        //   END;
        //   IF CurrForm."Net Change - Advance (LCY)".EDI THEN
        //     CurrForm."Net Change - Advance (LCY)".EDI(Security."Net Change - Advance (LCY)" = 0);
        //   IF Security."Net Change - Advance (LCY)" IN [2,5] THEN BEGIN
        //     CurrForm."Net Change - Advance (LCY)".VISIBLE(FALSE);
        //     SETRANGE("Net Change - Advance (LCY)");
        //   END;
        //   IF CurrForm."Net Change - Running (LCY)".EDI THEN
        //     CurrForm."Net Change - Running (LCY)".EDI(Security."Net Change - Running (LCY)" = 0);
        //   IF Security."Net Change - Running (LCY)" IN [2,5] THEN BEGIN
        //     CurrForm."Net Change - Running (LCY)".VISIBLE(FALSE);
        //     SETRANGE("Net Change - Running (LCY)");
        //   END;
        //   IF CurrForm."Net Change - Retention (LCY)".EDI THEN
        //     CurrForm."Net Change - Retention (LCY)".EDI(Security."Net Change - Retention (LCY)" = 0);
        //   IF Security."Net Change - Retention (LCY)" IN [2,5] THEN BEGIN
        //     CurrForm."Net Change - Retention (LCY)".VISIBLE(FALSE);
        //     SETRANGE("Net Change - Retention (LCY)");
        //   END;
        //   IF CurrForm."Vendor Category".EDI THEN
        //     CurrForm."Vendor Category".EDI(Security."Vendor Category" = 0);
        //   IF Security."Vendor Category" IN [2,5] THEN BEGIN
        //     CurrForm."Vendor Category".VISIBLE(FALSE);
        //     SETRANGE("Vendor Category");
        //   END;
        //   IF CurrForm."MSMED Classification".EDI THEN
        //     CurrForm."MSMED Classification".EDI(Security."MSMED Classification" = 0);
        //   IF Security."MSMED Classification" IN [2,5] THEN BEGIN
        //     CurrForm."MSMED Classification".VISIBLE(FALSE);
        //     SETRANGE("MSMED Classification");
        //   END;
        //   IF CurrForm."Balance at Date (LCY)".EDI THEN
        //     CurrForm."Balance at Date (LCY)".EDI(Security."Balance at Date (LCY)" = 0);
        //   IF Security."Balance at Date (LCY)" IN [2,5] THEN BEGIN
        //     CurrForm."Balance at Date (LCY)".VISIBLE(FALSE);
        //     SETRANGE("Balance at Date (LCY)");
        //   END;
        //   IF CurrForm."Vend. Posting Group-Advance".EDI THEN
        //     CurrForm."Vend. Posting Group-Advance".EDI(Security."Vend. Posting Group-Advance" = 0);
        //   IF Security."Vend. Posting Group-Advance" IN [2,5] THEN BEGIN
        //     CurrForm."Vend. Posting Group-Advance".VISIBLE(FALSE);
        //     SETRANGE("Vend. Posting Group-Advance");
        //   END;
        //   IF CurrForm."Vend. Posting Group-Running".EDI THEN
        //     CurrForm."Vend. Posting Group-Running".EDI(Security."Vend. Posting Group-Running" = 0);
        //   IF Security."Vend. Posting Group-Running" IN [2,5] THEN BEGIN
        //     CurrForm."Vend. Posting Group-Running".VISIBLE(FALSE);
        //     SETRANGE("Vend. Posting Group-Running");
        //   END;
        //   IF CurrForm."Vend. Posting Group-Retention".EDI THEN
        //     CurrForm."Vend. Posting Group-Retention".EDI(Security."Vend. Posting Group-Retention" = 0);
        //   IF Security."Vend. Posting Group-Retention" IN [2,5] THEN BEGIN
        //     CurrForm."Vend. Posting Group-Retention".VISIBLE(FALSE);
        //     SETRANGE("Vend. Posting Group-Retention");
        //   END;
        //   
        //ALLEDK 030313
    END;

    PROCEDURE Showfields();
    BEGIN
        //BBG2.01 22/07/14
        CLEAR(memberof);
        memberof.RESET;
        memberof.SETRANGE("User Name", USERID);
        memberof.SETRANGE("Role ID", 'VENDLISTINFOVISIBLE');
        IF NOT memberof.FINDFIRST THEN BEGIN
            MobVisible := FALSE;
            AddVisible := FALSE;
            Add2Visible := FALSE;
            Add3Visible := FALSE;
            PhVisible := FALSE;
            Ph2Visible := FALSE;
            ContactVisible := FALSE;
            // ALLE MM NAV 2009 Code Commented
            // {
            // CurrPage."Mobile No.".VISIBLE(FALSE);
            // CurrPage.Address.VISIBLE(FALSE);
            // CurrPage."Address 2".VISIBLE(FALSE);
            // CurrPage."Address 3".VISIBLE(FALSE);
            // CurrPage."Phone No.".VISIBLE(FALSE);
            // CurrPage."Phone No. 2".VISIBLE(FALSE);
            // CurrPage.Contact.VISIBLE(FALSE);
            // }
            // ALLE MM NAV 2009 Code Commented
        END ELSE BEGIN
            MobVisible := TRUE;
            AddVisible := TRUE;
            Add2Visible := TRUE;
            Add3Visible := TRUE;
            PhVisible := TRUE;
            Ph2Visible := TRUE;
            ContactVisible := TRUE;
            // ALLE MM NAV 2009 Code Commented
            // {
            // CurrPage."Mobile No.".VISIBLE(TRUE);
            // CurrPage.Address.VISIBLE(TRUE);
            // CurrPage."Address 2".VISIBLE(TRUE);
            // CurrPage."Address 3".VISIBLE(TRUE);
            // CurrPage."Phone No.".VISIBLE(TRUE);
            // CurrPage."Phone No. 2".VISIBLE(TRUE);
            // CurrPage.Contact.VISIBLE(TRUE);
            // }
            // ALLE MM NAV 2009 Code Commented
        END;
        //BBG2.01 22/07/14
    END;

}