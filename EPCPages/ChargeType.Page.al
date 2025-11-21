page 97822 "Charge Type"
{
    // //AD BBG1.00 110213: CAPTION CHANGED TOTAL CHARGE VALUE AND TOTAL REV PRICE

    DataCaptionExpression = FORMAT(Rec."Document Type") + ' ' + Rec.Code;
    PageType = Card;
    SourceTable = "Document Master";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field(Version; Rec.Version)
                {
                    DrillDownPageID = "Archive Doument List";
                    LookupPageID = "Archive Doument List";

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field(Status; Rec.Status)
                {
                }
                field("Sale/Lease"; Rec."Sale/Lease")
                {
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field(Code; Rec.Code)
                {
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        // ALLEPG 231012 Start
                        UnitChargePayPlan.RESET;
                        UnitChargePayPlan.SETRANGE(Type, UnitChargePayPlan.Type::"Charge Type");
                        IF UnitChargePayPlan.FINDFIRST THEN BEGIN
                            IF PAGE.RUNMODAL(Page::"BSP Charge List", UnitChargePayPlan) = ACTION::LookupOK THEN
                                Rec.Code := UnitChargePayPlan.Code;
                        END;
                        // ALLEPG 231012 End
                    end;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                        IF Rec."Sale/Lease" = Rec."Sale/Lease"::" " THEN
                            ERROR('Please select either Sale or Lease');
                    end;
                }
                field("App. Charge Code"; Rec."App. Charge Code")
                {

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("App. Charge Name"; Rec."App. Charge Name")
                {

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Unit Code"; Rec."Unit Code")
                {

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field(Description; Rec.Description)
                {
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field(Sequence; Rec.Sequence)
                {
                    Caption = 'Payment Sequence';

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Rate Not Allowed"; Rec."Rate Not Allowed")
                {
                    Visible = true;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Commision Applicable"; Rec."Commision Applicable")
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Direct Associate"; Rec."Direct Associate")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Rate/Sq. Yd"; Rec."Rate/Sq. Yd")
                {
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                        Rec.TESTFIELD("Rate Not Allowed", FALSE);
                        Rec.TESTFIELD("Fixed Price", 0);
                    end;
                }
                field("Fixed Price"; Rec."Fixed Price")
                {
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                        Rec.TESTFIELD("Rate Not Allowed", FALSE);
                        Rec.TESTFIELD("Rate/Sq. Yd", 0);
                    end;
                }
                field("Total Charge Amount"; Rec."Total Charge Amount")
                {

                    trigger OnValidate()
                    begin
                        CheckStatus;
                    end;
                }
                field("Project Price Dependency Code"; Rec."Project Price Dependency Code")
                {
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        CheckStatus;
                        Rec.TESTFIELD("Rate Not Allowed", TRUE);
                        DocMasRec.RESET;

                        DocMasRec.SETFILTER("Project Price Group", Rec."Project Price Dependency Code");
                        DocMasRec.SETFILTER("Project Code", Rec."Project Code");
                        IF DocMasRec.FINDLAST THEN BEGIN
                            IF Rec."Sale/Lease" = Rec."Sale/Lease"::Sale THEN
                                Rec."Rate/Sq. Yd" := DocMasRec."Sales Rate (per sq ft)";
                            IF Rec."Sale/Lease" = Rec."Sale/Lease"::Lease THEN
                                Rec."Rate/Sq. Yd" := DocMasRec."Lease Rate (per sq ft)";
                            Rec.MODIFY;
                        END;
                    end;
                }
            }
            field(TotalChValue; TotalChValue)
            {
                Caption = 'Total Sales Value';
                Editable = false;

                trigger OnValidate()
                begin
                    CheckStatus;
                end;
            }
            field(ReviseValue; ReviseValue)
            {
                Caption = 'Revise Sales Value';

                trigger OnValidate()
                begin
                    CheckStatus;
                end;
            }
            part("Approval Entries"; "Unit Price Approval")
            {
                SubPageLink = "Ref. Document No." = FIELD("Unit Code"),
                  "Re-Open Document" = const(false);

            }
        }

    }

    actions
    {
        area(navigation)
        {
            group("&Function")
            {
                Caption = '&Function';
                action("&Attach Documents")
                {
                    Caption = '&Attach Documents';
                    RunObject = Page 50418;
                    RunPageLink = "Table No." = CONST(97798),
                    "Document No." = FIELD("Unit Code");
                }
                action("Send for Approval")
                {
                    Caption = 'Send for Approval';
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        JagratiApprovalentry: Record "Jagriti Approval Entry";
                        JagratiApprovalSetup: Record "Jagriti Sitewise Approvalsetup";
                        LastEntryNo: Integer;
                        DocumentMaster: Record "Document Master";
                        OldJagratiApprovalentry: Record "Jagriti Approval Entry";
                    begin

                        Rec.TestField(Status, Rec.Status::Open);

                        OldJagratiApprovalentry.RESET;
                        OldJagratiApprovalentry.SetRange("Document Type", OldJagratiApprovalentry."Document Type"::"Unit Price Change");
                        OldJagratiApprovalentry.SetRange("Ref. Document No.", Rec."Unit Code");
                        OldJagratiApprovalentry.SetRange("Re-Open Document", false);
                        OldJagratiApprovalentry.SetRange("Approver ID", USERID);
                        IF OldJagratiApprovalentry.FindFirst() then BEGIN
                            //OldJagratiApprovalentry.TestField("Status Comment");
                            OldJagratiApprovalentry.Status := OldJagratiApprovalentry.Status::Approved;
                            OldJagratiApprovalentry."Approved / Rejected Date" := Today;
                            OldJagratiApprovalentry."Approved / Rejected time" := Time;
                            OldJagratiApprovalentry.Modify();
                        END;


                        JagratiApprovalSetup.RESET;
                        JagratiApprovalSetup.SetRange("Document Type", JagratiApprovalSetup."Document Type"::"Unit Price Change");
                        JagratiApprovalSetup.SetRange("Initiator ID", USERID);
                        IF JagratiApprovalSetup.FindFirst() then begin
                            JagratiApprovalSetup.TestField("Approver ID");
                            IF (JagratiApprovalSetup."Checker Approval ID" = '') AND (JagratiApprovalSetup."Checker Approval ID 2" = '') AND (JagratiApprovalSetup."Checker Approval ID 3" = '') then
                                Error('Checker Setup does not exists against user id' + Rec."Created By");

                            JagratiApprovalentry.RESET;
                            IF JagratiApprovalentry.FindLast() then
                                LastEntryNo := JagratiApprovalentry."Entry No.";
                            JagratiApprovalentry.Init;
                            JagratiApprovalentry."Entry No." := LastEntryNo + 1;
                            JagratiApprovalentry."Document Type" := JagratiApprovalentry."Document Type"::"Unit Price Change";
                            JagratiApprovalentry."Ref. Document No." := REc."Unit Code";
                            IF JagratiApprovalSetup."Checker Approval ID" <> '' then BEGIN
                                JagratiApprovalSetup.CalcFields("Checker Approval Name");
                                JagratiApprovalentry."Approver ID" := JagratiApprovalSetup."Checker Approval ID";
                                JagratiApprovalentry."Approver Name" := JagratiApprovalSetup."Checker Approval Name";
                            END;
                            IF JagratiApprovalentry."Approver ID" = '' then begin
                                JagratiApprovalSetup.CalcFields("Checker Approval Name 2");
                                JagratiApprovalentry."Approver ID" := JagratiApprovalSetup."Checker Approval ID 2";
                                JagratiApprovalentry."Approver Name" := JagratiApprovalSetup."Checker Approval Name 2";
                            END;
                            IF JagratiApprovalentry."Approver ID" = '' then begin
                                JagratiApprovalSetup.CalcFields("Checker Approval Name 3");
                                JagratiApprovalentry."Approver ID" := JagratiApprovalSetup."Checker Approval ID 3";
                                JagratiApprovalentry."Approver Name" := JagratiApprovalSetup."Checker Approval Name 3";
                            END;

                            JagratiApprovalentry."Date Sent for Approval" := Today;
                            JagratiApprovalentry."Time Sent for Approval" := Time;
                            JagratiApprovalentry.Status := JagratiApprovalentry.Status::Pending;
                            JagratiApprovalentry."Requester ID" := USERID;
                            JagratiApprovalentry."Status Comment 2" := OldJagratiApprovalentry."Status Comment";
                            JagratiApprovalentry."Project Id" := OldJagratiApprovalentry."Project Id";
                            JagratiApprovalentry."Project Name" := OldJagratiApprovalentry."Project Name";
                            JagratiApprovalentry.Insert;

                            DocumentMaster.RESET;
                            DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);
                            DocumentMaster.SetRange("Project Code", Rec."Project Code");
                            DocumentMaster.SetFilter("Unit Code", Rec."Unit Code");
                            IF DocumentMaster.FindSet() then
                                repeat
                                    DocumentMaster.Status := DocumentMaster.Status::"Pending for Approval";
                                    DocumentMaster.Modify;

                                Until DocumentMaster.Next = 0;
                            Message('Document has been sent for approval');
                        end ELSE
                            Error('Approval setup not define');

                    end;

                }


                action("Release/Update Price")
                {
                    Caption = 'Release/Update Price';

                    trigger OnAction()
                    begin
                        IF UMaster.GET(Rec."Unit Code") THEN
                            UMaster.TESTFIELD(UMaster.Status, UMaster.Status::Open);


                        Rec.TESTFIELD(Status, Rec.Status::Release);  //Open to Release
                        //ALLEDK 240113

                        IF CONFIRM('Do you want to Change or Release Charges?', TRUE) THEN BEGIN
                            IF ReviseValue <> 0 THEN BEGIN
                                TotalChAmt1 := 0;
                                RoundOffAmt := 0;
                                DocumentMaster.RESET;
                                DocumentMaster.SETRANGE("Document Type", DocumentMaster."Document Type"::Charge);
                                DocumentMaster.SETRANGE("Project Code", Rec."Project Code");
                                DocumentMaster.SETRANGE("Unit Code", Rec."Unit Code");
                                DocumentMaster.SETFILTER(Code, '<>%1', 'OTH');
                                IF DocumentMaster.FINDFIRST THEN BEGIN
                                    REPEAT
                                        TotalChAmt1 := TotalChAmt1 + DocumentMaster."Total Charge Amount";
                                    UNTIL DocumentMaster.NEXT = 0;

                                    RoundOffAmt := ReviseValue - TotalChAmt1;
                                    // IF RoundOffAmt < 0 THEN
                                    //  ERROR('The Unit Rate must be greater or Equal to Charge Rate');

                                    IF RoundOffAmt <> 0 THEN BEGIN
                                        DocumentMaster1.RESET;
                                        DocumentMaster1.SETRANGE("Document Type", DocumentMaster1."Document Type"::Charge);
                                        DocumentMaster1.SETRANGE("Project Code", Rec."Project Code");
                                        DocumentMaster1.SETRANGE("Unit Code", Rec."Unit Code");
                                        DocumentMaster1.SETRANGE(Code, 'OTH');
                                        IF DocumentMaster1.FINDFIRST THEN
                                            DocumentMaster1.VALIDATE("Fixed Price", (RoundOffAmt));
                                        DocumentMaster1.MODIFY;
                                    END;
                                END;
                                IF UMaster.GET(Rec."Unit Code") THEN BEGIN
                                    UMaster."Total Value" := ROUND(ReviseValue, 1, '>');
                                    UMaster.MODIFY;
                                END;
                                ReviseValue := 0;
                            END;

                            //100625 Code commented Start

                            // DocumentMaster.RESET;
                            // DocumentMaster.SETRANGE("Unit Code", Rec."Unit Code");
                            // IF DocumentMaster.FINDSET THEN
                            //     REPEAT
                            //         IF (DocumentMaster."Rate/Sq. Yd" = 0) AND (DocumentMaster."Fixed Price" = 0) THEN
                            //             ERROR('Please define Price or Delete Line');
                            //         DocumentMaster.Status := DocumentMaster.Status::Release;
                            //         DocumentMaster.MODIFY;
                            //     UNTIL DocumentMaster.NEXT = 0;
                            //100625 Code commented END

                            CurrPage.EDITABLE := FALSE;
                            CurrPage.UPDATE;
                            MESSAGE('Record Updated');
                        END;//ALLEDK 240113
                    end;
                }
                action(Reopen)
                {
                    Caption = 'Reopen';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        JagratiApprovalEntries: Record "Jagriti Approval Entry";

                        JagratiApprovalSetup: Record "Jagriti Sitewise Approvalsetup";
                        JagratiApprovalentry: Record "Jagriti Approval Entry";
                        LastEntryNo: integer;
                        RespCenter: Record "Responsibility Center 1";

                    begin
                        //ALLECK 060313 START
                        Memberof.RESET;
                        Memberof.SETRANGE(Memberof."User Name", USERID);
                        Memberof.SETRANGE(Memberof."Role ID", 'A_CHARGETYPE');
                        IF NOT Memberof.FINDFIRST THEN
                            ERROR('You do not have permission of role : A_CHARGETYPE');
                        //ALLECK 060313 End

                        IF UMaster.GET(Rec."Unit Code") THEN
                            UMaster.TESTFIELD(UMaster.Status, UMaster.Status::Open);


                        IF Rec.Status = Rec.Status::Open then
                            Error('Already Reopen');
                        ArchDocMaster.RESET;
                        ArchDocMaster.SETCURRENTKEY("Project Code", "Unit Code", Version);//ALLECK 190313
                        ArchDocMaster.SETRANGE("Unit Code", Rec."Unit Code");
                        ArchDocMaster.SETRANGE("Project Code", Rec."Project Code");
                        IF ArchDocMaster.FINDLAST THEN
                            Versn := ArchDocMaster.Version
                        ELSE
                            Versn := 0;

                        DocMaster.RESET;
                        DocMaster.SETRANGE("Unit Code", Rec."Unit Code");
                        DocMaster.SETRANGE("Project Code", Rec."Project Code");
                        IF DocMaster.FINDSET THEN
                            REPEAT
                                DocumentMaster.RESET;
                                DocumentMaster.SETRANGE("Document Type", DocMaster."Document Type");
                                DocumentMaster.SETRANGE("Project Code", DocMaster."Project Code");
                                DocumentMaster.SETRANGE(Code, DocMaster.Code);
                                DocumentMaster.SETRANGE("Sale/Lease", DocMaster."Sale/Lease");
                                DocumentMaster.SETRANGE("Unit Code", DocMaster."Unit Code");
                                DocumentMaster.SETRANGE("App. Charge Code", DocMaster."App. Charge Code");
                                IF DocumentMaster.FINDSET THEN BEGIN
                                    ArchDocMaster.INIT;
                                    ArchDocMaster.TRANSFERFIELDS(DocumentMaster);
                                    ArchDocMaster.Version := Versn + 1;
                                    ArchDocMaster."User ID" := USERID;
                                    ArchDocMaster."Archive Date" := TODAY;
                                    ArchDocMaster.INSERT;
                                END;
                            UNTIL DocMaster.NEXT = 0;


                        DocumentMaster.RESET;
                        DocumentMaster.SETRANGE("Unit Code", Rec."Unit Code");
                        IF DocumentMaster.FINDSET THEN
                            REPEAT
                                DocumentMaster.Status := DocumentMaster.Status::Open;
                                DocumentMaster.MODIFY;
                            UNTIL DocumentMaster.NEXT = 0;
                        //100625 Code Added start
                        JagratiApprovalEntries.RESET;
                        JagratiApprovalEntries.SetRange("Document Type", JagratiApprovalEntries."Document Type"::"Unit Price Change");
                        JagratiApprovalEntries.SetRange("Ref. Document No.", Rec."Unit Code");
                        IF JagratiApprovalEntries.FindSet() then
                            repeat
                                JagratiApprovalEntries."Re-Open Document" := True;
                                JagratiApprovalEntries."Re-Open Document DT." := CurrentDateTime;
                                JagratiApprovalEntries.Modify;
                            Until JagratiApprovalEntries.Next = 0;
                        //100625 Code Added END

                        JagratiApprovalSetup.RESET;
                        JagratiApprovalSetup.SetRange("Document Type", JagratiApprovalSetup."Document Type"::"Unit Price Change");
                        JagratiApprovalSetup.SetRange("Initiator ID", USERID);
                        IF NOT JagratiApprovalSetup.FindFirst() then
                            Error('Initiator Setup does not exists against user id' + USERID);

                        JagratiApprovalentry.RESET;
                        IF JagratiApprovalentry.FindLast() then
                            LastEntryNo := JagratiApprovalentry."Entry No.";
                        JagratiApprovalentry.Init;
                        JagratiApprovalentry."Entry No." := LastEntryNo + 1;
                        JagratiApprovalentry."Document Type" := JagratiApprovalentry."Document Type"::"Unit Price Change";
                        JagratiApprovalentry."Ref. Document No." := REc."Unit Code";
                        JagratiApprovalentry."Approver ID" := UserId;
                        IF JagratiApprovalSetup."Initiator ID" <> '' then
                            JagratiApprovalSetup.CalcFields("Initiator ID Name");
                        JagratiApprovalentry."Approver Name" := JagratiApprovalSetup."Initiator ID Name";
                        JagratiApprovalentry.Status := JagratiApprovalentry.Status::Pending;
                        JagratiApprovalentry."Requester ID" := USERID;
                        JagratiApprovalentry."Project Id" := Rec."Project Code";
                        RespCenter.RESET;
                        IF RespCenter.GET(REc."Project Code") then
                            JagratiApprovalentry."Project Name" := RespCenter.name;
                        JagratiApprovalentry.Insert;




                        CurrPage.UPDATE;

                        IF (Rec.Status = Rec.Status::Release) OR (Rec.Status = Rec.Status::Rejected) THEN
                            CurrPage.EDITABLE(FALSE)
                        ELSE
                            CurrPage.EDITABLE(TRUE);
                    end;
                }
                action("Archive Applicable Charges")
                {
                    Caption = 'Archive Applicable Charges';
                    RunObject = Page "Archive Applicable Charges";
                    RunPageLink = "Unit Code" = FIELD("Unit Code");
                }
            }
        }
        area(processing)
        {
            action("Insert Applicable Charges")
            {
                Caption = 'Ins&ert Applicable Charges';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page Navigate;

                trigger OnAction()
                begin

                    FromDocMaster.RESET;
                    FromDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code");
                    FromDocMaster.SETRANGE("Project Code", Rec."Project Code");
                    FromDocMaster.SETRANGE("Document Type", Rec."Document Type"::Charge);
                    FromDocMaster.SETRANGE("Unit Code", Rec."Unit Code");
                    // FromDocMaster.SETRANGE("App. Charge Code","App. Charge Code");
                    IF FromDocMaster.FINDFIRST THEN
                        ERROR(Text001);

                    FromDocMaster.RESET;
                    FromDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
                    FromDocMaster.SETRANGE("Project Code", Rec."Project Code");
                    FromDocMaster.SETRANGE("Document Type", FromDocMaster."Document Type"::Charge);
                    // FromDocMaster.SETRANGE("App. Charge Code","App. Charge Code");
                    FromDocMaster.SETRANGE("Unit Code", '');
                    IF FromDocMaster.FINDSET THEN
                        REPEAT
                            //If NOT(("Payment Plan tYPE" = 'DPP BBG') AND (FromDocMaster.Code = 'ADMIN2')) THEN
                            InsertApplicationCharges;
                        UNTIL FromDocMaster.NEXT = 0;

                    CalculateTotalUnitPrice;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF UMaster.GET(Rec."Unit Code") THEN BEGIN
            IF (UMaster.Status = UMaster.Status::Booked) OR (Rec.Status = Rec.Status::Release) THEN
                CurrPage.EDITABLE := FALSE
            ELSE
                CurrPage.EDITABLE := TRUE;
        END;
        UpdateAmount;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CalculateTotalUnitPrice;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TESTFIELD(Status, Rec.Status::Open); //170220
        CalculateTotalUnitPrice;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateAmount;
    end;

    trigger OnOpenPage()
    begin
        IF CurrPage.LOOKUPMODE THEN
            CurrPage.EDITABLE := FALSE;
        UpdateAmount;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        // IF (Rec."Project Code" <> '') AND (Rec."Unit Code" <> '') THEN BEGIN
        //     DocumentMaster.RESET;
        //     DocumentMaster.SETRANGE("Project Code", Rec."Project Code");
        //     DocumentMaster.SETFILTER("Unit Code", Rec."Unit Code");
        //     IF DocumentMaster.FINDFIRST THEN
        //         Rec.TESTFIELD(Status, Rec.Status::Release); //ALLEDK 030313
        // END;
    end;

    var
        DocMasRec: Record "Project Price Group Details";
        ApplicableCharges: Record "Applicable Charges";
        FromDocMaster: Record "Document Master";
        ToDoctMaster: Record "Document Master";
        Text001: Label 'Delete existing applicable charges.';
        CalDocMaster: Record "Document Master";
        UnitMaster: Record "Unit Master";
        TotalValue: Decimal;
        TotalFixed: Decimal;
        FixedValue: Decimal;
        UMaster: Record "Unit Master";
        UnitChargePayPlan: Record "Unit Charge & Payment Pl. Code";
        DocumentMaster: Record "Document Master";
        DocMaster: Record "Document Master";
        ArchDocMaster: Record "Archive Document Master";
        Versn: Integer;
        TotalAmt: Decimal;
        TotalChValue: Decimal;
        ReviseValue: Decimal;
        TotalChAmt1: Decimal;
        RoundOffAmt: Decimal;
        DocumentMaster1: Record "Document Master";
        Memberof: Record "Access Control";


    procedure InsertApplicationCharges()
    begin
        ToDoctMaster.INIT;
        ToDoctMaster."Document Type" := FromDocMaster."Document Type";
        ToDoctMaster."Project Code" := FromDocMaster."Project Code";
        ToDoctMaster.Code := FromDocMaster.Code;
        ToDoctMaster."Sale/Lease" := FromDocMaster."Sale/Lease";
        ToDoctMaster."Unit Code" := Rec."Unit Code";
        ToDoctMaster.Description := FromDocMaster.Description;
        IF FromDocMaster."Rate/Sq. Yd" <> 0 THEN
            ToDoctMaster.VALIDATE("Rate/Sq. Yd", FromDocMaster."Rate/Sq. Yd");
        IF FromDocMaster."Fixed Price" <> 0 THEN
            ToDoctMaster.VALIDATE("Fixed Price", FromDocMaster."Fixed Price");
        ToDoctMaster."BP Dependency" := FromDocMaster."BP Dependency";
        ToDoctMaster."Rate Not Allowed" := FromDocMaster."Rate Not Allowed";
        ToDoctMaster."Project Price Dependency Code" := FromDocMaster."Project Price Dependency Code";
        ToDoctMaster."Payment Plan Type" := FromDocMaster."Payment Plan Type";
        ToDoctMaster."Commision Applicable" := FromDocMaster."Commision Applicable";
        ToDoctMaster."Direct Associate" := FromDocMaster."Direct Associate";
        ToDoctMaster.Sequence := FromDocMaster.Sequence;
        ToDoctMaster.VALIDATE("App. Charge Code", FromDocMaster."App. Charge Code");
        ToDoctMaster."BSP4 Plan wise Rate / Sq. Yd" := FromDocMaster."BSP4 Plan wise Rate / Sq. Yd";  //040424 Added
        ToDoctMaster.INSERT(TRUE);
    end;


    procedure CalculateTotalUnitPrice()
    begin
        TotalValue := 0;
        TotalFixed := 0;
        CalDocMaster.RESET;
        CalDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
        CalDocMaster.SETRANGE("Project Code", Rec."Project Code");
        CalDocMaster.SETRANGE("Unit Code", Rec."Unit Code");
        IF CalDocMaster.FINDFIRST THEN
            REPEAT
                TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
                TotalFixed := TotalFixed + CalDocMaster."Fixed Price";
            UNTIL CalDocMaster.NEXT = 0;

        UnitMaster.RESET;
        UnitMaster.SETRANGE("No.", Rec."Unit Code");
        UnitMaster.SETRANGE("Project Code", Rec."Project Code");
        IF UnitMaster.FINDFIRST THEN BEGIN
            UnitMaster."Total Value" := TotalFixed + (TotalValue * UnitMaster."Saleable Area");
            UnitMaster.MODIFY;
        END;
    end;


    procedure UpdateAmount()
    begin
        TotalChValue := 0;
        DocMaster.RESET;
        DocMaster.SETCURRENTKEY("Document Type", "Project Code", "Unit Code");
        DocMaster.SETRANGE("Unit Code", Rec."Unit Code");
        DocMaster.SETRANGE("Project Code", Rec."Project Code");
        IF DocMaster.FINDFIRST THEN BEGIN
            DocMaster.CALCSUMS(DocMaster."Total Charge Amount");
            TotalChValue := DocMaster."Total Charge Amount";
        END;
    end;


    procedure UpdateRoundOFF(ProjectCode: Code[20]; UnitCode: Code[20])
    begin
        IF ReviseValue <> 0 THEN BEGIN
            TotalChAmt1 := 0;
            RoundOffAmt := 0;
            DocumentMaster.RESET;
            DocumentMaster.SETRANGE("Document Type", DocumentMaster."Document Type"::Charge);
            DocumentMaster.SETRANGE("Project Code", Rec."Project Code");
            DocumentMaster.SETRANGE("Unit Code", Rec."Unit Code");
            DocumentMaster.SETFILTER(Code, '<>%1', 'OTH');
            IF DocumentMaster.FINDFIRST THEN BEGIN
                REPEAT
                    TotalChAmt1 := TotalChAmt1 + DocumentMaster."Total Charge Amount";
                UNTIL DocumentMaster.NEXT = 0;

                RoundOffAmt := ReviseValue - TotalChAmt1;
                //IF RoundOffAmt < 0 THEN
                //  ERROR('The Unit Rate must be greater or Equal to Charge Rate');

                IF RoundOffAmt <> 0 THEN BEGIN
                    DocumentMaster1.RESET;
                    DocumentMaster1.SETRANGE("Document Type", DocumentMaster1."Document Type"::Charge);
                    DocumentMaster1.SETRANGE("Project Code", Rec."Project Code");
                    DocumentMaster1.SETRANGE("Unit Code", Rec."Unit Code");
                    DocumentMaster1.SETRANGE(Code, 'OTH');
                    IF DocumentMaster1.FINDFIRST THEN
                        DocumentMaster1.VALIDATE("Fixed Price", (RoundOffAmt));
                    DocumentMaster1.MODIFY;
                END;
            END;
            IF UMaster.GET(Rec."Unit Code") THEN BEGIN
                UMaster."Total Value" := ROUND(ReviseValue, 1, '>');
                UMaster.MODIFY;
            END;
            ReviseValue := 0;
        END;
    end;

    local procedure CheckStatus()
    begin
        Rec.TESTFIELD(Status, Rec.Status::Open);
    end;
}

