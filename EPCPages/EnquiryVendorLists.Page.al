page 97791 "Enquiry Vendor Lists"
{
    // //ALLEDK 090610 For flow of job no. from indent line

    PageType = Card;
    SourceTable = Vendor;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = "No.Editable";
                    Visible = "No.Visible";
                }
                field(Name; Rec.Name)
                {
                    Editable = NameEditable;
                    Visible = NameVisible;
                }
                field(Select; Rec."BBG Select")
                {
                    Editable = SelectEditable;
                    Visible = SelectVisible;

                    trigger OnValidate()
                    begin
                        IF Rec."BBG Select" = TRUE THEN BEGIN
                            PRHeader.GET(PRHeader."Document Type"::Indent, PRRequestDocNo);
                            TestEnquiry;
                        END;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(History)
            {
                Caption = 'History';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'History';

                trigger OnAction()
                begin
                    //HistoryFunction(-50074, '');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetSecurity(FALSE);
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        SetSecurity(FALSE);
        EXIT(Rec.FIND(Which));
    end;

    trigger OnInit()
    begin
        SelectEditable := TRUE;
        SelectVisible := TRUE;
        NameVisible := TRUE;
        "No.Visible" := TRUE;
    end;

    trigger OnOpenPage()
    begin
        SetSecurity(TRUE);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN
            OKOnPush;
    end;

    var
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        EnquiryNo: Code[20];
        PRHeader: Record "Purchase Request Header";
        PRRequestDoctype: Option Indent;
        PRRequestDocNo: Code[20];
        EnquiryCreated: Boolean;
        PRLIne: Record "Purchase Request Line";

        "No.Visible": Boolean;

        NameVisible: Boolean;

        SelectVisible: Boolean;

        "No.Editable": Boolean;

        NameEditable: Boolean;

        SelectEditable: Boolean;


    procedure GenerateEnquiry()
    var
        VendorEnquiryHeader: Record "Vendor Enquiry Details";
        VendorEnquiryLine: Record "Enquiry Line";
    begin
        PurchSetup.GET;
        EnquiryNo := NoSeriesMgt.GetNextNo(PurchSetup."Enquiry No. Series", TODAY, TRUE);
        VendorEnquiryHeader.INIT;
        VendorEnquiryHeader."Enquiry no." := EnquiryNo;
        VendorEnquiryHeader."Indent No." := PRHeader."Document No.";
        //VendorEnquiryHeader.VALIDATE("Project Code",PRHeader."Shortcut Dimension 1 Code");
        VendorEnquiryHeader.VALIDATE("Vendor No.", Rec."No.");
        VendorEnquiryHeader."Document Date" := TODAY;
        //VendorEnquiryHeader.VALIDATE("Job Code",PRHeader."Job Code"); //Alle Ven
        //VendorEnquiryHeader.VALIDATE("Job Task",PRHeader."Indent No. Series"); //Alle Ven
        VendorEnquiryHeader."Pr Type" := PRHeader."Indent Type";
        VendorEnquiryHeader."Date of Floating enquiry" := TODAY;
        VendorEnquiryHeader.VALIDATE(VendorEnquiryHeader.Location, PRHeader."Location code");
        VendorEnquiryHeader.Location := PRHeader."Location code";
        IF VendorEnquiryHeader.INSERT(TRUE) THEN;

        PRLIne.RESET;
        PRLIne.SETRANGE("Document Type", PRHeader."Document Type");
        PRLIne.SETRANGE("Document No.", PRHeader."Document No.");
        PRLIne.SETRANGE(PRLIne."Send for Enquiry", TRUE);
        IF PRLIne.FIND('-') THEN
            REPEAT
                VendorEnquiryLine.INIT;
                VendorEnquiryLine."Enquiry No." := VendorEnquiryHeader."Enquiry no.";
                VendorEnquiryLine."Line No." := PRLIne."Line No.";
                VendorEnquiryLine.Type := PRLIne.Type;
                VendorEnquiryLine."No." := PRLIne."No.";
                VendorEnquiryLine.Description := PRLIne.Description;
                VendorEnquiryLine.Description2 := PRLIne."Description 2";
                //  VendorEnquiryLine."Global Dimension 1 Code" := PRLIne."Shortcut Dimension 1 Code";
                VendorEnquiryLine."Unit cost" := PRLIne."Direct Unit Cost";
                VendorEnquiryLine.VALIDATE(VendorEnquiryLine.Quantity, PRLIne."Indented Quantity");
                VendorEnquiryLine.VALIDATE(VendorEnquiryLine."Location Code", PRLIne."Location code");
                VendorEnquiryLine."Uint of Measure" := PRLIne."Indent UOM";
                VendorEnquiryLine."PR No." := PRLIne."Document No.";
                VendorEnquiryLine."PR Line No." := PRLIne."Line No.";
                //ALLEDK 090610 For flow of job no. from indent line
                VendorEnquiryLine."Job No." := PRLIne."Job No.";
                VendorEnquiryLine."Job Task No." := PRLIne."Job Task No.";
                //ALLEDK 090610 For flow of job no. from indent line
                VendorEnquiryLine.INSERT;
            UNTIL PRLIne.NEXT = 0;
    end;


    procedure SetPrHeader(PRHeaderDocType: Option Indent; PRHeaderDocNo: Code[20])
    begin
        PRRequestDoctype := PRHeaderDocType;
        PRRequestDocNo := PRHeaderDocNo;
    end;


    procedure TestEnquiry(): Boolean
    var
        VendorEnquiryHeader: Record "Vendor Enquiry Details";
    begin
        VendorEnquiryHeader.RESET;
        VendorEnquiryHeader.SETRANGE(VendorEnquiryHeader."Vendor No.", Rec."No.");
        VendorEnquiryHeader.SETRANGE(VendorEnquiryHeader."Indent No.", PRHeader."Document No.");
        IF VendorEnquiryHeader.FIND('-') THEN BEGIN
            ERROR('You have already created and Enquiry for this vendor for this PR Request');
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE)
    end;

    local procedure SetSecurity(OpenPAGE: Boolean)
    begin
        // ALLE MM Code Commented as Table Security table is not existing in NAV
        /*
        IF OpenPAGE THEN BEGIN
          IF NOT TableSecurity.GetTableSecurity(PAGE::"Enquiry Vendor Lists") THEN
           EXIT;
        
          IF TableSecurity."Form General Permission" = TableSecurity."Form General Permission"::"1" THEN
            CurrPage.EDITABLE(FALSE);
        
          TableSecurity.SetFieldFilters(Rec);
        END ELSE
          IF TableSecurity."Security for Form No." = 0 THEN
            EXIT;
        
        IF "No.Editable" THEN
          "No.Editable" := TableSecurity."No." = 0;
        IF TableSecurity."No." IN [2,5] THEN BEGIN
          "No.Visible" := FALSE;
          SETRANGE("No.");
        END;
        IF NameEditable THEN
          NameEditable := TableSecurity.Name = 0;
        IF TableSecurity.Name IN [2,5] THEN BEGIN
          NameVisible := FALSE;
          SETRANGE(Name);
        END;
        IF SelectEditable THEN
          SelectEditable := TableSecurity.Select = 0;
        IF TableSecurity.Select IN [2,5] THEN BEGIN
          SelectVisible := FALSE;
          SETRANGE(Select);
        END;
        */
        // ALLE MM Code Commented as Table Security table is not existing in NAV

    end;

    local procedure OKOnPush()
    begin
        PRHeader.GET(PRHeader."Document Type"::Indent, PRRequestDocNo);
        Rec.RESET;
        Rec.SETRANGE("BBG Select", TRUE);
        IF Rec.FINDSET THEN
            REPEAT
                EnquiryCreated := TestEnquiry();
                GenerateEnquiry();
                Rec."BBG Select" := FALSE;
                Rec.MODIFY;
            UNTIL Rec.NEXT = 0;
        PRLIne.RESET;
        PRLIne.SETRANGE("Document Type", PRHeader."Document Type");
        PRLIne.SETRANGE("Document No.", PRHeader."Document No.");
        PRLIne.SETRANGE(PRLIne."Send for Enquiry", TRUE);
        IF PRLIne.FIND('-') THEN
            REPEAT
                PRLIne."Send for Enquiry" := FALSE;
                PRLIne.MODIFY;
            UNTIL PRLIne.NEXT = 0;

        MESSAGE('Enquiry Created');
        IF EnquiryCreated = FALSE THEN
            CurrPage.CLOSE;
    end;
}

