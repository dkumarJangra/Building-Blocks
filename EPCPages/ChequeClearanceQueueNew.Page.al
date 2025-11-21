page 97924 "Cheque Clearance Queue New"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Application Payment Entry";
    SourceTableView = SORTING(Posted, "Payment Mode", "Cheque Status", "Chq. Cl / Bounce Dt.", "Document Type", "Document No.", "Document Date", "Posting date")
                      WHERE(Posted = FILTER(true),
                            "Payment Mode" = FILTER(<> Cash),
                            "Cheque Status" = FILTER(' '),
                            "Document Type" = FILTER(Application | BOND | RD));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ChequeNoFilter; ChequeNoFilter)
                {
                    Caption = 'Cheque No. Filter';

                    trigger OnValidate()
                    begin
                        ChequeNoFilterOnAfterValidate;
                    end;
                }
                field(ChequeClearanceDate; ChequeClearanceDate)
                {
                    Caption = 'Cheque Clearance Date';

                    trigger OnValidate()
                    begin
                        ChequeClearanceDateOnAfterVali;
                    end;
                }
            }
            repeater(Group)
            {
                field(ShowCard; ShowCard)
                {
                    Caption = 'Show Card';
                    Editable = false;
                    //OptionCaption = 'Integer';

                    trigger OnValidate()
                    begin
                        ShowCardOnPush;
                    end;
                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    OptionCaption = 'Application,RD,FD,MIS,UNIT';
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    Editable = false;
                }
                field("Cheque No./ Transaction No."; Rec."Cheque No./ Transaction No.")
                {
                    Editable = false;
                }
                field("Cheque Date"; Rec."Cheque Date")
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Editable = false;
                }
                field(PostingDate; PostingDate)
                {
                    Caption = 'Posting Date';
                    Editable = false;
                }
                field("Chq. Cl / Bounce Dt."; Rec."Chq. Cl / Bounce Dt.")
                {
                    Editable = false;

                    trigger OnValidate()
                    var
                        Text0007: Label 'Please enter a valid cheque Clearance date.';
                        Application: Record Application;
                    begin
                        IF (Rec."Chq. Cl / Bounce Dt." <> 0D) AND (Rec."Document Type" = Rec."Document Type"::Application) THEN BEGIN
                            Application.GET(Rec."Application No.");
                            IF (Rec."Chq. Cl / Bounce Dt." < Application."Posting Date") OR (Rec."Chq. Cl / Bounce Dt." > WORKDATE) THEN
                                ERROR(Text0005);
                        END;
                    end;
                }
                field(DocumentDate; DocumentDate)
                {
                    Caption = 'Document Date';
                    Editable = false;
                }
                field("Cheque Bank and Branch"; Rec."Cheque Bank and Branch")
                {
                    Editable = false;
                }
                field(PostedDocumentNo; PostedDocumentNo)
                {
                    Caption = 'Posted Document No.';
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    Editable = false;
                }
                field("Deposit/Paid Bank"; Rec."Deposit/Paid Bank")
                {
                    Editable = true;
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
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    ShortCutKey = 'Shift+Ctrl+L';

                    trigger OnAction()
                    var
                        Application: Record Application;
                    begin
                        CLEAR(ApplicationPAGE);
                        IF Rec."Document Type" = Rec."Document Type"::Application THEN BEGIN
                            ApplicationPAGE.ForChequeClearance(Rec."Application No.");
                            ApplicationPAGE.RUNMODAL();
                        END;
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Visible = true;
                action("Cheque Cleared")
                {
                    Caption = 'Cheque Cleared';
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        IF ChequeClearanceDate = 0D THEN
                            ERROR('Please insert Cheque Clearance Date');
                        // ALLEPG 080812 Start
                        //CurrPAGE.SETSELECTIONFILTER(Rec);
                        Rec.MARKEDONLY(TRUE);
                        ChequeClearance(Rec);
                        Rec.MARKEDONLY(FALSE);
                        // ALLEPG 080812 End

                        //CLEAR(UnitCommissionCreationjob);
                        //UnitCommissionCreationjob.RUN;
                    end;
                }
                action("Cheque Bounce")
                {
                    Caption = 'Cheque Bounce';
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        // ALLEPG 080812 Start
                        //CurrPAGE.SETSELECTIONFILTER(Rec);
                        Rec.MARKEDONLY(TRUE);
                        ChequeBounce(Rec);
                        Rec.MARKEDONLY(FALSE);
                        // ALLEPG 080812 End
                    end;
                }
            }
        }
    }

    var
        ChequeNoFilter: Text[50];
        ShowCard: Integer;
        ApplicationPAGE: Page Application;
        PostPayment: Codeunit PostPayment;
        Text0001: Label 'There is no cheque to clear';
        Text0002: Label 'Cheque cleared successfully.';
        //AppMgt: Codeunit 1;
        Text0003: Label 'There is no cheque to bounce';
        Text0004: Label 'Please Mark only one record';
        Text0005: Label 'Please enter a valid cheque Clearance date.';
        PostedDocumentNo: Code[20];
        PostingDate: Date;
        DocumentDate: Date;
        ChequeClearanceDate: Date;
        Text0006: Label 'Do you want to bounce the Marked Cheques?';
        Text0007: Label 'Please select 1 record.';
        AppPaymentEntry: Record "Application Payment Entry";
        UnitCommissionCreationjob: Codeunit "Unit and Comm. Creation Job";


    procedure InitVar()
    begin
        ChequeNoFilter := '';
        ChequeClearanceDate := 0D;
    end;

    local procedure SetRecordFilters()
    begin
        //FILTERGROUP(10);
        IF ChequeNoFilter <> '' THEN
            Rec.SETFILTER("Cheque No./ Transaction No.", ChequeNoFilter)
        ELSE
            Rec.SETRANGE("Cheque No./ Transaction No.");
        CurrPage.UPDATE(FALSE);
    end;


    procedure ChequeClearance(var AppPayEntry: Record "Application Payment Entry")
    var
        BondPaymentEntry: Record "Unit Payment Entry";
    begin
        IF CONFIRM('Do you want to clear the Marked Cheques?') THEN BEGIN
            REPEAT
                IF ChequeClearanceDate = 0D THEN
                    ERROR('Please enter Cheque clearance date');
                AppPaymentEntry.SETCURRENTKEY(Posted, "Payment Mode", "Cheque Status", "Chq. Cl / Bounce Dt.", "Document Type", "Document No.",
                                            "Document Date", "Posting date");
                IF AppPaymentEntry.ISEMPTY THEN
                    ERROR(Text0001);
                BondPaymentEntry.RESET;
                BondPaymentEntry.SETRANGE("Document No.", AppPayEntry."Application No.");
                BondPaymentEntry.SETRANGE("Cheque No./ Transaction No.", AppPayEntry."Cheque No./ Transaction No.");
                IF BondPaymentEntry.FINDFIRST THEN
                    REPEAT
                        PostPayment.CreateGenJnlLinesForClChq(BondPaymentEntry, 'Cheque Cleared', 1, ChequeClearanceDate);
                    UNTIL BondPaymentEntry.NEXT = 0;
            UNTIL AppPayEntry.NEXT = 0;
            InitVar;
        END;
    end;


    procedure ChequeBounce(var AppPayEntry: Record "Application Payment Entry")
    var
        BondPaymentEntry: Record "Unit Payment Entry";
    begin
        /*
        IF CONFIRM(Text0006) THEN BEGIN
          BondPaymentEntry.SETCURRENTKEY(Posted,"Payment Mode","Cheque Status","Cheque Clearance Date","Document Type","Document No.",
                                      "Document Date","Posting date");
        
          MARKEDONLY(TRUE);
          IF BondPaymentEntry.ISEMPTY THEN
            ERROR(Text0001);
          BondPaymentEntry.COPY(Rec);
          MARKEDONLY(FALSE);
          PostPayment.ChequeBounce(BondPaymentEntry);
          InitVar;
        END;
        */

        IF CONFIRM(Text0006) THEN BEGIN
            IF AppPayEntry.FINDFIRST THEN BEGIN
                REPEAT
                    AppPaymentEntry.SETCURRENTKEY(Posted, "Payment Mode", "Cheque Status", "Chq. Cl / Bounce Dt.", "Document Type", "Document No.",
                                                "Document Date", "Posting date");
                    IF AppPaymentEntry.ISEMPTY THEN
                        ERROR(Text0001);
                    BondPaymentEntry.RESET;
                    BondPaymentEntry.SETRANGE("Document No.", AppPayEntry."Application No.");
                    BondPaymentEntry.SETRANGE("Cheque No./ Transaction No.", AppPayEntry."Cheque No./ Transaction No.");
                    IF BondPaymentEntry.FINDFIRST THEN
                        REPEAT
                            PostPayment.ChequeBounce(BondPaymentEntry);
                        UNTIL BondPaymentEntry.NEXT = 0;
                UNTIL AppPayEntry.NEXT = 0;
            END;
            InitVar;
        END;

    end;

    local procedure ChequeNoFilterOnAfterValidate()
    begin
        SetRecordFilters;
    end;

    local procedure ChequeClearanceDateOnAfterVali()
    begin
        SetRecordFilters;
    end;

    local procedure ShowCardOnPush()
    var
        Application: Record Application;
    begin
        CLEAR(ApplicationPAGE);
        IF Rec."Document Type" = Rec."Document Type"::Application THEN BEGIN
            ApplicationPAGE.ForChequeClearance(Rec."Application No.");
            ApplicationPAGE.RUNMODAL();
        END;
    end;
}

