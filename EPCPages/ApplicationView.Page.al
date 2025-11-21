page 98009 "Application (View)"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = Application;
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group("Bond Application")
            {
                Caption = 'Bond Application';
                field("Application No."; Rec."Application No.")
                {
                    Editable = "Application No.Editable";
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Unit No."; Rec."Unit No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Editable = "Customer NameEditable";
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Editable = "Customer No.Editable";
                }
            }
            group("&General")
            {
                Caption = '&General';
                field("Project Type"; Rec."Project Type")
                {
                    Editable = "Project TypeEditable";

                    trigger OnValidate()
                    begin
                        SchemeDescription := GetDescription.GetSchemeDesc(Rec."Scheme Code", Rec."Scheme Version No.");
                        InvestmentFrequency := 0;
                        ReturnFrequency := 0;
                        UpdateControls;
                    end;
                }
                field("Investment Type"; Rec."Investment Type")
                {
                    Editable = "Investment TypeEditable";

                    trigger OnValidate()
                    begin
                        SchemeDescription := GetDescription.GetSchemeDesc(Rec."Scheme Code", Rec."Scheme Version No.");
                        UpdateControls;
                        InvestmentFrequency := 0;
                        ReturnFrequency := 0;
                    end;
                }
                field(BondDuration; BondDuration)
                {
                    Caption = 'Duration';
                    Editable = BondDurationEditable;

                    trigger OnValidate()
                    begin
                        //If BondDuration <> BondDuration::"" Then Begin
                        Rec.VALIDATE(Duration, GetDescription.GetDuration(BondDuration));
                        SchemeDescription := GetDescription.GetSchemeDesc(Rec."Scheme Code", Rec."Scheme Version No.");
                        UpdateControls;
                        InvestmentFrequency := 0;
                        ReturnFrequency := 0;
                        //End;
                    end;
                }
                label("1")
                {
                    CaptionClass = FORMAT(SchemeDescription);
                    //DrillDown = false;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Duration; FORMAT(Rec.Duration))
                {
                    Caption = 'Duration';

                    trigger OnValidate()
                    begin
                        SchemeDescription := GetDescription.GetSchemeDesc(Rec."Scheme Code", Rec."Scheme Version No.");
                        UpdateControls;
                        InvestmentFrequency := 0;
                        ReturnFrequency := 0;
                    end;
                }
                field("Scheme Code"; Rec."Scheme Code")
                {

                    trigger OnValidate()
                    begin
                        SchemeCodeOnAfterValidate;
                    end;
                }
                field("Scheme Version No."; Rec."Scheme Version No.")
                {
                    Editable = false;
                    Lookup = false;
                }
                field("Associate Code"; Rec."Associate Code")
                {
                    Editable = "Associate CodeEditable";

                    trigger OnValidate()
                    begin
                        MMName := GetDescription.GetVendorName(Rec."Associate Code");
                        InvestmentFrequency := 0;
                        ReturnFrequency := 0;
                    end;
                }
                field(MMName; MMName)
                {
                    Caption = 'MM Name';
                    DrillDown = false;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(InvFreq; InvestmentFrequency)
                {
                    Caption = 'Investment Frequency';
                    Editable = InvFreqEditable;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        CASE InvestmentFrequency OF
                            0:
                                Rec.VALIDATE("Investment Frequency", Rec."Investment Frequency"::" ");
                            1:
                                Rec.VALIDATE("Investment Frequency", Rec."Investment Frequency"::Monthly);
                            3:
                                Rec.VALIDATE("Investment Frequency", Rec."Investment Frequency"::Quarterly);
                            6:
                                Rec.VALIDATE("Investment Frequency", Rec."Investment Frequency"::"Half Yearly");
                            12:
                                Rec.VALIDATE("Investment Frequency", Rec."Investment Frequency"::Annually);
                        END;
                        Rec.MODIFY;
                    end;
                }
                field("Investment Frequency"; FORMAT(Rec."Investment Frequency"))
                {
                    Caption = 'Investment Frequency';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Investment Amount"; Rec."Investment Amount")
                {
                    Editable = "Investment AmountEditable";
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        InvestmentAmountOnAfterValidat;
                    end;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                }
                field("Service Charge Amount"; Rec."Service Charge Amount")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Return Payment Mode"; Rec."Return Payment Mode")
                {
                    Editable = "Return Payment ModeEditable";

                    trigger OnValidate()
                    begin
                        ReturnPaymentModeOnAfterValida
                    end;
                }
                field(RetFreq; ReturnFrequency)
                {
                    Editable = RetFreqEditable;

                    trigger OnValidate()
                    begin
                        CASE ReturnFrequency OF
                            0:
                                Rec.VALIDATE("Return Frequency", Rec."Return Frequency"::" ");
                            1:
                                Rec.VALIDATE("Return Frequency", Rec."Return Frequency"::Monthly);
                            3:
                                Rec.VALIDATE("Return Frequency", Rec."Return Frequency"::Quarterly);
                            6:
                                Rec.VALIDATE("Return Frequency", Rec."Return Frequency"::"Half Yearly");
                            12:
                                Rec.VALIDATE("Return Frequency", Rec."Return Frequency"::Annually);
                        END;
                        Rec.MODIFY;
                    end;
                }
                field("Return Frequency"; FORMAT(Rec."Return Frequency"))
                {
                    Caption = 'Return Frequency';
                }
                field("Return Amount"; Rec."Return Amount")
                {
                    Caption = 'Return Interest Amount';
                    Editable = "Return AmountEditable";
                }
                field("Received From Code"; Rec."Received From Code")
                {
                    Editable = "Received From CodeEditable";

                    trigger OnValidate()
                    begin
                        ReceivedFromName := GetDescription.GetVendorName(Rec."Received From Code");
                    end;
                }
                field("GetDescription.GetVendorName(Received From Code)";
                GetDescription.GetVendorName(Rec."Received From Code"))
                {
                    Caption = 'Received From Name';
                    DrillDown = false;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                }
                field("Maturity Amount"; Rec."Maturity Amount")
                {
                }
                field("Bond Posting Group"; Rec."Bond Posting Group")
                {
                }
                field("Maturity Bonus Amount"; Rec."Maturity Bonus Amount")
                {
                }
            }
            group("Pa&yments")
            {
                Caption = 'Pa&yments';
                part(PaymentsSubform; "Application Payments Subform")
                {
                    Editable = PaymentsSubPAGEEditable;
                    SubPageLink = "Document Type" = FILTER(Application),
                                  "Document No." = FIELD("Application No."),
                                  "Application No." = FIELD("Application No."),
                                  Type = CONST(Received);
                }
            }
            group("Application Information")
            {
                Caption = 'Application Information';
                field(Status; Rec.Status)
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("GetDescription.GetDimensionName(Shortcut Dimension 2 Code,2)";
                GetDescription.GetDimensionName(Rec."Shortcut Dimension 2 Code", 2))
                {
                    DrillDown = false;
                    Editable = false;
                }
                field("Posted Doc No."; Rec."Posted Doc No.")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
            }
            group("&History")
            {
                Caption = '&History';
                part("2"; "Application History Subform")
                {
                    Editable = false;
                    SubPageLink = "Unit No." = FIELD("Unit No.");
                }
            }
            group("&Comments")
            {
                Caption = '&Comments';
                part("3"; "Unit Comment Sheet")
                {
                    SubPageLink = "Table Name" = FILTER("Activity Master"),
                                  "No." = FIELD("Application No.");
                }
            }
            group("P&rint Log")
            {
                Caption = 'P&rint Log';
                part("4"; "Unit Print Log Subform")
                {
                    SubPageLink = "Unit No." = FIELD("Unit No.");
                }
            }
            group("&Bank Information")
            {
                Caption = '&Bank Information';
                field("Bank Account No."; Rec."Bank Account No.")
                {
                    Editable = "Bank Account No.Editable";
                }
                field("Branch Name"; Rec."Branch Name")
                {
                    Editable = "Branch NameEditable";
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Application")
            {
                Caption = '&Application';
                action("Bank Details")
                {
                    Caption = 'Bank Details';

                    trigger OnAction()
                    begin
                        BankDetail;
                    end;
                }
                group("Bonus Entry")
                {
                    Caption = 'Bonus Entry';
                    action(UnPosted)
                    {
                        Caption = 'UnPosted';

                        trigger OnAction()
                        var
                            BonusEntry: Page "Bonus Entry";
                        begin
                            BonusEntry.SETRECORD(Rec);
                            BonusEntry.RUNMODAL;
                        end;
                    }
                    action(Posted)
                    {
                        Caption = 'Posted';

                        trigger OnAction()
                        var
                            BonusEntryPosted: Page "Bonus Entry Posted";
                        begin
                            BonusEntryPosted.SETRECORD(Rec);
                            BonusEntryPosted.RUNMODAL;
                        end;
                    }
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Re&lease")
                {
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'F9';
                    Visible = false;

                    trigger OnAction()
                    var
                        InvestmentType: Integer;
                    begin
                        IF (Rec."Customer Name" = '') AND (Rec."Customer No." = '') THEN BEGIN
                            ERROR(Text001, Rec.FIELDCAPTION("Customer Name"), Rec.FIELDCAPTION("Customer No."));
                        END;

                        Rec.TESTFIELD(Status, Rec.Status::Open);

                        IF CONFIRM(STRSUBSTNO(Text002, Rec.FIELDCAPTION("Application No."), Rec."Application No.", Rec."Associate Code", MMName, Rec."Scheme Code",
                          SchemeDescription, (Rec.TotalApplicationAmount - Rec."Service Charge Amount"), Rec."Posting Date")) THEN BEGIN
                            ReleaseBondApplication.ReleaseApplication(Rec, TRUE);

                            MESSAGE(Text003, Rec.FIELDCAPTION("Application No."), Rec."Application No.", Rec.FIELDCAPTION("Unit No."), Rec."Unit No.");
                        END;
                    end;
                }
                action("&Create Bond")
                {
                    Caption = '&Create Bond';
                    ShortCutKey = 'Ctrl+F10';
                    Visible = false;

                    trigger OnAction()
                    var
                        Bond: Record "Confirmed Order";
                        BondCommCreationBuffer: Record "Unit & Comm. Creation Buffer";
                        BondCommCreation: Codeunit "Unit and Comm. Creation Job";
                    begin
                        Rec.TESTFIELD("Investment Type", Rec."Investment Type"::RD);
                        IF CONFIRM(Text004, FALSE, Rec.FIELDCAPTION("Unit No."), Rec."Unit No.") THEN BEGIN
                            Rec.TESTFIELD(Status, Rec.Status::Printed);
                            Rec.TESTFIELD("Unit No.");
                            Rec.TESTFIELD("With Cheque", FALSE);
                            IF Bond.GET(Rec."Unit No.") THEN
                                ERROR(Text005, Rec.FIELDCAPTION("Unit No."), Rec."Unit No.");
                            //IF ("With Cheque") THEN
                            //  MESSAGE('Bond cannot be manually created if paid by cheque');
                            BondCommCreationBuffer.GET(Rec."Unit No.", 1);
                            IF (NOT Rec."With Cheque") THEN BEGIN
                                BondCommCreation.CreateBond(Rec, BondCommCreationBuffer, FALSE);
                                COMMIT;
                                MESSAGE(Text006, Rec.FIELDCAPTION("Unit No."), Rec."Unit No.");
                            END;
                        END;
                    end;
                }
                action(Reverse)
                {
                    Caption = 'Reverse';
                    Visible = false;

                    trigger OnAction()
                    var
                        ApplicationReverse: Codeunit "Application Reverse";
                    begin
                        IF NOT CONFIRM(Text008, FALSE) THEN
                            EXIT;
                        IF Rec.Status = Rec.Status::Open THEN
                            ERROR(Text007);
                        ApplicationReverse.ApplicationReverse(Rec."Application No.");
                    end;
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                action("&Acknowledgement")
                {
                    Caption = '&Acknowledgement';
                    ShortCutKey = 'Shift+F11';
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF Rec.Status <> Rec.Status::Open THEN BEGIN
                            Application := Rec;
                            Application.SETRECFILTER;
                            //REPORT.RUNMODAL(REPORT::"New Purchase Order", FALSE, TRUE, Application);
                            Rec := Application;
                            CurrPage.UPDATE(TRUE);
                        END;
                    end;
                }
                action("Ack. P&rivew")
                {
                    Caption = 'Ack. P&rivew';
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        Application := Rec;
                        Application.SETRECFILTER;
                        //REPORT.RUNMODAL(REPORT::"Update Ledger_", TRUE, FALSE, Application);
                        Application.RESET;
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
                begin
                    Navigate;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Rec.Duration <> 0 THEN
            BondDuration := GetDescription.GetBondDuration(Rec.Duration)
        ELSE
            BondDuration := 0;

        SchemeDescription := GetDescription.GetSchemeDesc(Rec."Scheme Code", Rec."Scheme Version No.");
        MMName := GetDescription.GetVendorName(Rec."Associate Code");
        ReceivedFromName := GetDescription.GetVendorName(Rec."Received From Code");
        Rec.SETRANGE("Application No.");
        InvestmentFrequency := 0;
        CASE Rec."Investment Frequency" OF
            Rec."Investment Frequency"::Monthly:
                InvestmentFrequency := 1;
            Rec."Investment Frequency"::Quarterly:
                InvestmentFrequency := 3;
            Rec."Investment Frequency"::"Half Yearly":
                InvestmentFrequency := 6;
            Rec."Investment Frequency"::Annually:
                InvestmentFrequency := 12;
        END;

        ReturnFrequency := 0;
        CASE Rec."Return Frequency" OF
            Rec."Return Frequency"::Monthly:
                ReturnFrequency := 1;
            Rec."Return Frequency"::Quarterly:
                ReturnFrequency := 3;
            Rec."Return Frequency"::"Half Yearly":
                ReturnFrequency := 6;
            Rec."Return Frequency"::Annually:
                ReturnFrequency := 12;
        END;
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Branch NameEditable" := TRUE;
        "Bank Account No.Editable" := TRUE;
        "Customer No.Editable" := TRUE;
        "Customer NameEditable" := TRUE;
        "Application No.Editable" := TRUE;
        "Investment TypeEditable" := TRUE;
        BondDurationEditable := TRUE;
        "Received From CodeEditable" := TRUE;
        "Associate CodeEditable" := TRUE;
        "Project TypeEditable" := TRUE;
        PaymentsSubPAGEEditable := TRUE;
        InvFreqEditable := TRUE;
        "Return Payment ModeEditable" := TRUE;
        "Return AmountEditable" := TRUE;
        RetFreqEditable := TRUE;
        "Investment AmountEditable" := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CLEAR(Rec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SchemeDescription := '';
        MMName := '';
        ReturnFrequency := 0;
        InvestmentFrequency := 0;
        BBGOnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    var
        GetDescription: Codeunit GetDescription;
    begin
        UserSetup.GET(USERID);
        //GetDescription.ValidateCounter(UserSetup."Shortcut Dimension 2 Code");
        Rec.FILTERGROUP(10);
        //IF NOT  ChequeClearring THEN
        //  IF UserSetup."Shortcut Dimension 2 Code" <> '' THEN
        //    SETRANGE("Shortcut Dimension 2 Code",UserSetup."Shortcut Dimension 2 Code");
        Rec.FILTERGROUP(0);
    end;

    var
        Application: Record Application;
        ReleaseBondApplication: Codeunit "Release Unit Application";
        DueAmount: Decimal;
        UserSetup: Record "User Setup";
        SchemeDescription: Text[50];
        MMName: Text[50];
        GetDescription: Codeunit GetDescription;
        Text001: Label '%1 or %2 must be entered.';
        PostPayment: Codeunit PostPayment;
        Mode: Boolean;
        CallForChqClear: Boolean;
        ChequeClearring: Boolean;
        BondPost: Codeunit "Unit Post";
        CashDispute: Boolean;
        Text002: Label 'Do you want to release the %1 %2 ?\MM Code     : %3 %4 \Scheme       : %5-%6 \Amount       : %7 \App. Date   : %8.';
        InvestmentFrequency: Option " ","1",,"3",,,"6",,,,,,"12";
        ReturnFrequency: Option " ","1",,"3",,,"6",,,,,,"12";
        BondDuration: Option " ","36","60","72","75","84","120","300";
        ReceivedFromName: Text[50];
        CounterName: Text[50];
        Text003: Label '%1 %2 has been released.\%3 %4 has been assigned.';
        Text004: Label 'Do you want to manually create the %1 %2 ?';
        Text005: Label '%1 %2 already exists.';
        Text006: Label '%1 %2 has been created.';
        Text007: Label 'The status of the bond is Open.';
        Text008: Label 'Are you sure want to reverse Application %1 ?';

        "Investment AmountEditable": Boolean;

        RetFreqEditable: Boolean;

        "Return AmountEditable": Boolean;

        "Return Payment ModeEditable": Boolean;

        InvFreqEditable: Boolean;

        PaymentsSubPAGEEditable: Boolean;

        "Project TypeEditable": Boolean;

        "Associate CodeEditable": Boolean;

        "Received From CodeEditable": Boolean;

        BondDurationEditable: Boolean;

        "Investment TypeEditable": Boolean;

        "Application No.Editable": Boolean;

        "Customer NameEditable": Boolean;

        "Customer No.Editable": Boolean;

        "Bank Account No.Editable": Boolean;

        "Branch NameEditable": Boolean;

    local procedure UpdateApplicationInfo()
    begin
        Rec.CALCFIELDS("Amount Received");
        DueAmount := Rec.TotalApplicationAmount - Rec."Amount Received";
    end;

    local procedure UpdateControls()
    begin
        IF Rec."Investment Amount" <> 0 THEN
            PaymentsSubPAGEEditable := TRUE
        ELSE
            PaymentsSubPAGEEditable := FALSE;

        UpdateApplicationInfo;
        IF Rec.Status = Rec.Status::Open THEN
            Mode := TRUE
        ELSE
            Mode := FALSE;

        IF ChequeClearring THEN
            Mode := FALSE;

        CurrPage.PaymentsSubform.PAGE.ChangeEditMode(Mode, ChequeClearring);
        "Project TypeEditable" := Mode;
        "Associate CodeEditable" := Mode;
        "Received From CodeEditable" := Mode;
        InvFreqEditable := Mode;
        "Investment AmountEditable" := Mode;
        "Return Payment ModeEditable" := Mode;
        RetFreqEditable := Mode;
        "Return AmountEditable" := Mode;
        BondDurationEditable := Mode;
        "Investment TypeEditable" := Mode;
        "Application No.Editable" := Mode;
        "Customer NameEditable" := Mode;
        "Customer No.Editable" := Mode;
        "Bank Account No.Editable" := Mode;
        "Branch NameEditable" := Mode;

        IF Rec.Status = Rec.Status::Open THEN BEGIN
            IF Rec."Investment Type" = Rec."Investment Type"::" " THEN BEGIN
                "Investment AmountEditable" := FALSE;
                RetFreqEditable := FALSE;
                "Return AmountEditable" := FALSE;
                "Return Payment ModeEditable" := FALSE;
                InvFreqEditable := FALSE;
                Rec.VALIDATE("Investment Amount", 0);
                Rec."Return Amount" := 0;
                Rec."Investment Frequency" := Rec."Investment Frequency"::" ";
                Rec."Return Payment Mode" := Rec."Return Payment Mode"::" ";
                Rec."Return Frequency" := Rec."Return Frequency"::" ";
                Rec."Return Amount" := 0;
            END ELSE IF Rec."Investment Type" = Rec."Investment Type"::RD THEN BEGIN
                InvFreqEditable := TRUE;
                "Investment AmountEditable" := TRUE;
                RetFreqEditable := FALSE;
                "Return AmountEditable" := FALSE;
                "Return Payment ModeEditable" := FALSE;
                Rec."Return Payment Mode" := Rec."Return Payment Mode"::" ";
                Rec."Return Frequency" := Rec."Return Frequency"::" ";
                Rec."Return Amount" := 0;
            END ELSE IF Rec."Investment Type" = Rec."Investment Type"::FD THEN BEGIN
                IF Rec."Return Payment Mode" = Rec."Return Payment Mode"::" " THEN
                    Rec."Return Payment Mode" := Rec."Return Payment Mode"::Cash;
                InvFreqEditable := FALSE;
                Rec."Investment Frequency" := Rec."Investment Frequency"::" ";
                "Investment AmountEditable" := TRUE;
                RetFreqEditable := FALSE;
                "Return Payment ModeEditable" := TRUE;
                "Return AmountEditable" := FALSE;
            END ELSE IF Rec."Investment Type" = Rec."Investment Type"::MIS THEN BEGIN
                "Investment AmountEditable" := TRUE;
                "Return Payment ModeEditable" := TRUE;
                InvFreqEditable := FALSE;
                Rec."Investment Frequency" := Rec."Investment Frequency"::" ";
                RetFreqEditable := TRUE;
                "Return AmountEditable" := FALSE;
                IF Rec."Return Payment Mode" = Rec."Return Payment Mode"::" " THEN
                    Rec."Return Payment Mode" := Rec."Return Payment Mode"::Cash;
            END;
        END;

        IF Rec.Duration <> 0 THEN
            BondDuration := GetDescription.GetBondDuration(Rec.Duration)
        ELSE
            BondDuration := 0;

        CurrPage.PaymentsSubform.PAGE.UpdatePAGE;
        //CurrPage.PaymentsSubform.PAGE.UPDATECONTROLS; // ALLE MM Code Commented as UPDATECONTROLS Has been removed in NAv 2016
    end;


    procedure InsertRec()
    var
    //WScript: Automation;
    begin
        //UpdateControls;
        // ALLE MM Code Commented
        /*
        CREATE(WScript);
        WScript.SendKeys('{F3}');
        */
        // ALLE MM Code Commented

    end;


    procedure ForChequeClearance(ApplicationNo: Code[20])
    begin
        ChequeClearring := TRUE;
        Rec.FILTERGROUP(10);
        Rec.SETRANGE("Application No.", ApplicationNo);
        Rec.FILTERGROUP(0);
    end;


    procedure ForCashDispute(ApplicationNo: Code[20])
    begin
        CashDispute := TRUE;
        Rec.FILTERGROUP(10);
        Rec.SETRANGE("Application No.", ApplicationNo);
        Rec.FILTERGROUP(0);
    end;


    procedure BankDetail()
    var
        CustomerBankAccount: Record "Customer Bank Account";
        //CustomerBankInformation: Page 82;
        BankCode: Code[20];
    begin
        //CLEAR(CustomerBankInformation);
        CustomerBankAccount.RESET;
        CustomerBankAccount.SETRANGE("Customer No.", Rec."Customer No.");
        CustomerBankAccount.SETRANGE(Code, Rec."Application No.");
        //CustomerBankInformation.SETTABLEVIEW(CustomerBankAccount);
        //CustomerBankInformation.RUNMODAL;
    end;


    procedure Navigate()
    begin
        //Cashier.Navigate("Posted Doc No.");
    end;

    local procedure SchemeCodeOnAfterValidate()
    begin
        UpdateControls;
    end;

    local procedure InvestmentAmountOnAfterValidat()
    begin
        UpdateControls;
    end;

    local procedure ReturnPaymentModeOnAfterValida()
    begin
        UpdateControls;
        ReturnFrequency := 0;
    end;

    local procedure BBGOnAfterGetCurrRecord()
    begin
        xRec := Rec;
        UpdateControls;
    end;

    local procedure InvestmentAmountOnDeactivate()
    begin
        CurrPage.UPDATE(TRUE);
        UpdateControls;
        ReturnFrequency := 0;
    end;
}

