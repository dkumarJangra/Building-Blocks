page 97917 "Unit Verification"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Confirmed Order";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(Bond)
            {
                Caption = 'Bond';
                field("No."; Rec."No.")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field(BondHolderName; BondHolderName)
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("User Id"; Rec."User Id")
                {
                }
            }
            group("&General")
            {
                Caption = '&General';
                field("Scheme Code"; Rec."Scheme Code")
                {
                }
                field("Project Type"; Rec."Project Type")
                {
                    Editable = false;
                }
                field("Investment Type"; Rec."Investment Type")
                {
                }
                field(Duration; Rec.Duration)
                {
                    Editable = false;
                }
                label("1")
                {
                    CaptionClass = FORMAT(SchemeHeader."CC Mail - User Code");
                    //DrillDown = false;
                    Editable = false;
                }
                field("Version No."; Rec."Version No.")
                {
                    Editable = false;
                }
                label("2")
                {
                    CaptionClass = FORMAT(Vendor.Name);
                    //DrillDown = false;
                    Editable = false;
                }
                field("Received From"; Rec."Received From")
                {
                    Editable = false;
                }
                field("Received From Code"; Rec."Received From Code")
                {
                    Editable = false;
                }
                field("Service Charge Amount"; Rec."Service Charge Amount")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Investment Frequency"; Rec."Investment Frequency")
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                }
                field("Amount -Discount Amount"; Rec.Amount - Rec."Discount Amount")
                {
                    Caption = 'Net Amount';
                    Editable = false;
                }
                field("Return Frequency"; Rec."Return Frequency")
                {
                    Editable = false;
                }
                field("Return Amount"; Rec."Return Amount")
                {
                }
                field("Return Payment Mode"; Rec."Return Payment Mode")
                {
                    Editable = false;
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                    Editable = false;
                }
                field("Maturity Amount"; Rec."Maturity Amount")
                {
                    Editable = false;
                }
                field("Maturity Bonus Amount"; Rec."Maturity Bonus Amount")
                {
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                part(PaymentLines; "Unit Payments Subform")
                {
                    SubPageLink = "Document Type" = CONST(BOND),
                                  "Unit Code" = FIELD("No.");
                }
            }
            group("Bond Information")
            {
                Caption = 'Bond Information';
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Posted Doc No."; Rec."Posted Doc No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                }
            }
            group(History)
            {
                Caption = 'History';
                part("3"; "Unit History Subform")
                {
                    SubPageLink = "Unit No." = FIELD("No.");
                }
            }
            group(Comments)
            {
                Caption = 'Comments';
                part("4"; "Unit Comment Sheet")
                {
                    SubPageLink = "Table Name" = FILTER('Confirmed order'),
                                  "No." = FIELD("No.");
                }
            }
            group("Print Log")
            {
                Caption = 'Print Log';
                part("5"; "Unit Print Log Subform")
                {
                    SubPageLink = "Unit No." = FIELD("No.");
                }
            }
            group("B&ond Holder")
            {
                Caption = 'B&ond Holder';
                label("6")
                {
                    CaptionClass = FORMAT(Dummy);
                    Editable = true;
                    Enabled = false;
                }
                label("7")
                {
                    CaptionClass = Text19041874;
                }
                field("GetDescription.GetCustBankBranchName(Customer No.Application No.)";
                GetDescription.GetCustBankBranchName(Rec."Customer No.", Rec."Application No."))
                {
                    Caption = 'Customer Bank Branch';
                }
                field("GetDescription.GetCustBankAccountNo(Customer No.Application No.)";
                GetDescription.GetCustBankAccountNo(Rec."Customer No.", Rec."Application No."))
                {
                    Caption = 'Customer Bank Account No.';
                }
                label("8")
                {
                    CaptionClass = Text19047410;
                }
                label("9")
                {
                    CaptionClass = FORMAT(Dummy);
                    Editable = true;
                    Enabled = false;
                }
                field("Post Code";
                Customer."Post Code")
                {
                    Caption = 'Post Code';
                    Editable = false;
                }
                field("Customer2 No.";
                Customer2."No.")
                {
                    Caption = 'No.';
                    Editable = false;
                }
                field("Customer2.Name";
                Customer2.Name)
                {
                    Caption = 'Name';
                    Editable = false;
                }
                field("Customer2.Posting Type Filter";
                Customer2."BBG Posting Type Filter")
                {
                    Caption = 'Father''s/Hus Name';
                    Editable = false;
                }
                field("Customer2.Contact";
                Customer2.Contact)
                {
                    Caption = 'Relation';
                    Editable = false;
                }
                field("Customer2.Address";
                Customer2.Address)
                {
                    Caption = 'Address';
                    Editable = false;
                }
                field("Customer2.Address 2";
                Customer2."Address 2")
                {
                    Caption = 'Address 2';
                    Editable = false;
                }
                field("Customer2.New Debit Amount (LCY)";
                Customer2."BBG New Debit Amount (LCY)")
                {
                    Caption = 'Age';
                    Editable = false;
                }
                field("Customer2.City";
                Customer2.City)
                {
                    Caption = 'City';
                    Editable = false;
                }
                field("Customer2.Post Code";
                Customer2."Post Code")
                {
                    Caption = 'Post Code';
                    Editable = false;
                }
                group("Bond Holder")
                {
                    Caption = 'Bond Holder';
                    field("Customer.Name";
                    Customer.Name)
                    {
                        Caption = 'Name';
                        Editable = false;
                    }
                    field("Customer.Posting Type Filter";
                    Customer."BBG Posting Type Filter")
                    {
                        Caption = 'Father''s/Hus Name';
                        Editable = false;
                    }
                    field("Customer.Contact";
                    Customer.Contact)
                    {
                        Caption = 'Relation';
                        Editable = false;
                    }
                    field("Customer.Address";
                    Customer.Address)
                    {
                        Caption = 'Address';
                        Editable = false;
                    }
                    field("Customer.Address 2";
                    Customer."Address 2")
                    {
                        Caption = 'Address 2';
                        Editable = false;
                    }
                    field("Customer.New Debit Amount (LCY)";
                    Customer."BBG New Debit Amount (LCY)")
                    {
                        Caption = 'Age';
                        Editable = false;
                    }
                    field("Customer.City";
                    Customer.City)
                    {
                        Caption = 'City';
                        Editable = false;
                    }
                }
            }
            group("Nomin&ee")
            {
                Caption = 'Nomin&ee';
                field("BondNominee.Title"; FORMAT(BondNominee.Title))
                {
                    Caption = 'Title';
                    Editable = false;
                }
                field("BondNominee.Name";
                BondNominee.Name)
                {
                    Caption = 'Name';
                    Editable = false;
                }
                field("BondNominee.Address";
                BondNominee.Address)
                {
                    Caption = 'Address';
                    Editable = false;
                }
                field("BondNominee.Address 2";
                BondNominee."Address 2")
                {
                    Caption = 'Address 2';
                    Editable = false;
                }
                field("BondNominee.City";
                BondNominee.City)
                {
                    Caption = 'City';
                    Editable = false;
                }
                field("BondNominee.Post Code";
                BondNominee."Post Code")
                {
                    Caption = 'Post Code';
                    Editable = false;
                }
                field("BondNominee.Age";
                BondNominee.Age)
                {
                    Caption = 'Age';
                    Editable = false;
                }
                field("BondNominee.Relation";
                BondNominee.Relation)
                {
                    Caption = 'Relation';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Bond")
            {
                Caption = '&Bond';
                action("Preview Certificate")
                {
                    Caption = 'Preview Certificate';

                    trigger OnAction()
                    var
                        Bond2: Record "Confirmed Order";
                    begin
                        Bond2.SETRANGE("No.", Rec."No.");
                        REPORT.RUNMODAL(97749, TRUE, FALSE, Bond2);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Mark Verified")
                {
                    Caption = 'Mark Verified';
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    begin
                        IF CONFIRM(Text0002) THEN BEGIN
                            Rec.Status := Rec.Status::Verified;
                            Rec.MODIFY;
                            ReleaseBondApplication.InsertBondHistory(Rec."No.", 'Bond Verified', 1, Rec."No.");
                            IF Rec.COUNT = 0 THEN
                                CurrPage.CLOSE;
                        END;
                    end;
                }
                action("Mark Dispute")
                {
                    Caption = 'Mark Dispute';
                    ShortCutKey = 'Ctrl+F12';

                    trigger OnAction()
                    var
                        Selection: Integer;
                        window: Dialog;
                        DisputeText: Text[50];
                        Documentation: Record Documentation;
                    begin
                        Selection := STRMENU(Text0001, 1);
                        IF Selection <> 0 THEN BEGIN
                            window.OPEN('Please enter Dispute Detail.(Max 50 Char) \#1###########################');
                            //window.INPUT(1, DisputeText);
                            window.CLOSE;
                            IF DisputeText <> '' THEN BEGIN
                                Rec."Dispute Remark" := DisputeText;
                                IF Selection = 1 THEN   //Cashier
                                    Rec.Status := Rec.Status::"Cash Dispute"
                                ELSE
                                    Rec.Status := Rec.Status::"Documentation Dispute";
                                Rec.MODIFY;
                                Documentation.UpdateDocumentation(Rec);
                                ReleaseBondApplication.InsertBondHistory(Rec."No.", FORMAT(Rec.Status) + ' in Bond', 1, Rec."No.");
                                IF Rec.COUNT = 0 THEN
                                    CurrPage.CLOSE;

                            END ELSE
                                MESSAGE('Please enter dispute reasion.');
                        END;
                    end;
                }
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page Navigate;

                trigger OnAction()
                var
                    Navigate: Page Navigate;
                begin
                    CLEAR(Navigate);
                    Navigate.SetDoc(Rec."Posting Date", Rec."Posted Doc No.");
                    Navigate.RUN;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        BondHolderName := '';
        IF Customer.GET(Rec."Customer No.") THEN
            BondHolderName := Customer.Name
        ELSE
            CLEAR(Customer);

        IF NOT Customer2.GET(Rec."Customer No. 2") THEN
            CLEAR(Customer2);

        IF NOT BondNominee.GET(Rec."No.") THEN
            CLEAR(BondNominee);

        IF NOT Vendor.GET(Rec."Introducer Code") THEN
            CLEAR(Vendor);

        IF NOT SchemeHeader.GET(Rec."Scheme Code", Rec."Version No.") THEN
            CLEAR(SchemeHeader);
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        OnActivatePAGE;
    end;

    var
        ReceivableAmount: Decimal;
        AmountReceived: Decimal;
        DueAmount: Decimal;
        ReleaseBondApplication: Codeunit "Release Unit Application";
        Text0001: Label 'Cashier,Documentaion';
        BondHolderName: Text[50];
        Text0002: Label 'Verification complete?';
        Dummy: Text[30];
        BondNominee: Record "Unit Nominee";
        Vendor: Record Vendor;
        SchemeHeader: Record "Document Type Initiator";
        Customer: Record Customer;
        Customer2: Record Customer;
        GetDescription: Codeunit GetDescription;
        Text19041874: Label 'Bond Holder Bank Detail';
        Text19047410: Label '2nd Applicant';

    local procedure UpdateApplicationInfo()
    begin
        //CALCFIELDS("Amount Received");
        ReceivableAmount := Rec.TotalApplicationAmount;
        AmountReceived := Rec.Amount;  //"Amount Received";
        DueAmount := ReceivableAmount - AmountReceived;
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateApplicationInfo;
    end;

    local procedure OnActivatePAGE()
    begin
        UpdateApplicationInfo;
    end;
}

