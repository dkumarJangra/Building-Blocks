page 97763 "Product Vendors"
{
    // ALLERP KRN0004 17-08-2010: New Form created
    // ALLERP BugFix  24-11-2010: Commented Code Removed

    PageType = Card;
    SourceTable = "Product Vendor";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field("No."; Rec."No.")
                {
                    Editable = true;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                }
                field("Vendor Item No."; Rec."Vendor Item No.")
                {
                }
                field("Variant Code"; Rec."Variant Code")
                {
                }
                field(Category; Rec.Category)
                {
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                }
                field(Selected; Rec.Selected)
                {
                    Visible = SelectedVisible;

                    trigger OnValidate()
                    begin
                        IF Rec.Selected = TRUE THEN BEGIN
                            PRHeader.GET(PRHeader."Document Type"::Indent, PRRequestDocNo);
                            //IF NOT TestEnquiry THEN   // ALLEPG 131211
                            AppendEnquiry;
                        END;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        IF NotCallFrmMaster THEN BEGIN
            SelectedVisible := TRUE;
            OKVisible := TRUE;
            CancelVisible := TRUE;
        END ELSE BEGIN
            SelectedVisible := FALSE;
            OKVisible := FALSE;
            CancelVisible := FALSE;
        END;
    end;

    trigger OnInit()
    begin
        CancelVisible := TRUE;
        OKVisible := TRUE;
        SelectedVisible := TRUE;
    end;

    trigger OnOpenPage()
    begin
        IF NotCallFrmMaster THEN BEGIN
            SelectedVisible := TRUE;
            OKVisible := TRUE;
            CancelVisible := TRUE;
        END ELSE BEGIN
            SelectedVisible := FALSE;
            OKVisible := FALSE;
            CancelVisible := FALSE;
        END;
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
        Text50001: Label 'You have already created an Enquiry for this Vendor and Item against this Purchase Request';
        NotCallFrmMaster: Boolean;
        Text50002: Label 'For This Indent and Vendor, There is an open enquiry.Do you want to append it?';
        EnquiryGenerated: Boolean;
        PRRequestLineNo: Integer;
        RecUserSetup: Record "User Setup";
        RecRespCenter: Record "Responsibility Center 1";

        SelectedVisible: Boolean;

        OKVisible: Boolean;

        CancelVisible: Boolean;

    local procedure GetCaptionClass(): Text[80]
    begin
    end;


    procedure GenerateEnquiry()
    var
        VendorEnquiryHeader: Record "Vendor Enquiry Details";
        VendorEnquiryLine: Record "Enquiry Line";
    begin
        PurchSetup.GET;
        //ALLEDK 231211
        IF RecUserSetup.GET(USERID) THEN
            //IF RecRespCenter.GET(RecUserSetup."Purchase Resp. Ctr. Filter") THEN
            //  IF RecRespCenter."FBW Responsibility Center" THEN BEGIN
            //    EnquiryNo := NoSeriesMgt.GetNextNo(PurchSetup."FBW Enquiry No. Series",TODAY,TRUE);
            //  END ELSE BEGIN
            //ALLEDK 231211
            EnquiryNo := NoSeriesMgt.GetNextNo(PurchSetup."Enquiry No. Series", TODAY, TRUE);
        // END;
        VendorEnquiryHeader.INIT;
        VendorEnquiryHeader."Enquiry no." := EnquiryNo;
        VendorEnquiryHeader."Indent No." := PRHeader."Document No.";
        VendorEnquiryHeader.VALIDATE("Vendor No.", Rec."Vendor No.");
        VendorEnquiryHeader."Document Date" := TODAY;
        VendorEnquiryHeader.VALIDATE("Job Code", PRHeader."Job Code"); //ALLERP
        //VendorEnquiryHeader.VALIDATE("Job Task",PRHeader."Indent No. Series"); //Alle Ven
        VendorEnquiryHeader."Pr Type" := PRHeader."Indent Type";
        VendorEnquiryHeader."Date of Floating enquiry" := TODAY;
        VendorEnquiryHeader.VALIDATE(VendorEnquiryHeader.Location, PRHeader."Location code");
        VendorEnquiryHeader.Location := PRHeader."Location code";
        IF VendorEnquiryHeader.INSERT(TRUE) THEN;
        VendorEnquiryHeader.VALIDATE("Project Code", PRHeader."Shortcut Dimension 1 Code");
        VendorEnquiryHeader.MODIFY;
        PRLIne.RESET;
        PRLIne.SETRANGE("Document Type", PRHeader."Document Type");
        PRLIne.SETRANGE("Document No.", PRHeader."Document No.");
        //PRLIne.SETRANGE(Type,Type);
        //PRLIne.SETRANGE("No.","No.");
        PRLIne.SETRANGE(PRLIne."Line No.", PRRequestLineNo);
        //PRLIne.SETRANGE(PRLIne."Send for Enquiry",TRUE);
        IF PRLIne.FIND('-') THEN BEGIN
            VendorEnquiryLine.INIT;
            VendorEnquiryLine."Enquiry No." := VendorEnquiryHeader."Enquiry no.";
            VendorEnquiryLine."Line No." := PRLIne."Line No.";
            VendorEnquiryLine.Type := PRLIne.Type;
            VendorEnquiryLine."No." := PRLIne."No.";
            VendorEnquiryLine.Description := PRLIne.Description;
            VendorEnquiryLine.Description2 := PRLIne."Description 2";
            VendorEnquiryLine."Global Dimension 1 Code" := PRLIne."Shortcut Dimension 1 Code";
            VendorEnquiryLine."Global Dimension 2 Code" := PRLIne."Shortcut Dimension 2 Code";
            VendorEnquiryLine."Unit cost" := PRLIne."Direct Unit Cost";
            //  VendorEnquiryLine.VALIDATE(Quantity,PRLIne."Indented Quantity");
            VendorEnquiryLine.VALIDATE(Quantity, PRLIne."Approved Qty");
            VendorEnquiryLine.VALIDATE("Location Code", PRLIne."Location code");
            VendorEnquiryLine."Uint of Measure" := PRLIne."Indent UOM";
            VendorEnquiryLine."PR No." := PRLIne."Document No.";
            VendorEnquiryLine."PR Line No." := PRLIne."Line No.";
            //ALLEDK 090610 For flow of job no. from indent line
            VendorEnquiryLine."Job No." := PRLIne."Job No.";
            VendorEnquiryLine."Job Task No." := PRLIne."Job Task No.";
            VendorEnquiryLine."Delivery Date" := PRLIne."Delivery Date";
            VendorEnquiryLine."Inspection by" := PRLIne."Inspection by";
            VendorEnquiryLine.Source := PRLIne.Source;
            //ALLE PS Added code to Flow Job Code Fron Indent LIne
            VendorEnquiryLine."Job Master Code" := PRLIne."Job Master Code";

            //ALLEDK 090610 For flow of job no. from indent line
            VendorEnquiryLine.INSERT;
        END;
    end;


    procedure SetPrHeader(PRHeaderDocType: Option Indent; PRHeaderDocNo: Code[20]; PRHeaderLineNo: Integer)
    begin
        PRRequestDoctype := PRHeaderDocType;
        PRRequestDocNo := PRHeaderDocNo;
        PRRequestLineNo := PRHeaderLineNo
    end;


    procedure TestEnquiry(): Boolean
    var
        VendorEnquiryHeader: Record "Vendor Enquiry Details";
        VendorEnquiryLine: Record "Enquiry Line";
    begin
        VendorEnquiryHeader.RESET;
        VendorEnquiryHeader.SETRANGE("Vendor No.", Rec."Vendor No.");
        VendorEnquiryHeader.SETRANGE("Indent No.", PRHeader."Document No.");
        VendorEnquiryHeader.SETFILTER(Status, '<>%1', VendorEnquiryHeader.Status::Cancel);  // RIL1.06 090911
        IF VendorEnquiryHeader.FIND('-') THEN BEGIN
            VendorEnquiryLine.RESET;
            VendorEnquiryLine.SETRANGE("PR No.", PRHeader."Document No.");
            VendorEnquiryLine.SETRANGE(VendorEnquiryLine."Enquiry No.", VendorEnquiryHeader."Enquiry no.");
            //VendorEnquiryLine.SETRANGE(Type,Type);
            //VendorEnquiryLine.SETRANGE("No.","No.");
            VendorEnquiryLine.SETRANGE("PR Line No.", PRRequestLineNo);
            IF VendorEnquiryLine.FINDFIRST THEN BEGIN
                ERROR(Text50001);
                EXIT(TRUE);
            END ELSE
                EXIT(FALSE);
        END ELSE
            EXIT(FALSE)
    end;


    procedure CallFromMaster()
    begin
        NotCallFrmMaster := TRUE;
    end;


    procedure AppendEnquiry(): Boolean
    var
        VendorEnquiryHeader: Record "Vendor Enquiry Details";
        VendorEnquiryLine: Record "Enquiry Line";
        EnqDialog: Dialog;
    begin
        VendorEnquiryHeader.RESET;
        VendorEnquiryHeader.SETRANGE("Vendor No.", Rec."Vendor No.");
        VendorEnquiryHeader.SETRANGE("Indent No.", PRHeader."Document No.");
        VendorEnquiryHeader.SETRANGE(Status, VendorEnquiryHeader.Status::Open);
        IF VendorEnquiryHeader.FIND('-') THEN BEGIN
            //IF CONFIRM(Text50002,FALSE) THEN
            //  Append := TRUE;
            // ALLEPG 131211 Start
            IF CONFIRM(Text50002, FALSE) THEN
                Rec.Append := TRUE
            ELSE
                Rec.Append := FALSE;
            // ALLEPG 131211 End
            EXIT(TRUE);
        END ELSE
            EXIT(FALSE)
    end;


    procedure GenerateExistEnquiry()
    var
        VendorEnquiryHeader: Record "Vendor Enquiry Details";
        VendorEnquiryLine: Record "Enquiry Line";
    begin
        VendorEnquiryHeader.RESET;
        VendorEnquiryHeader.SETRANGE("Vendor No.", Rec."Vendor No.");
        VendorEnquiryHeader.SETRANGE("Indent No.", PRHeader."Document No.");
        VendorEnquiryHeader.SETRANGE(Status, VendorEnquiryHeader.Status::Open);
        IF VendorEnquiryHeader.FIND('-') THEN BEGIN
            PRLIne.RESET;
            PRLIne.SETRANGE("Document Type", PRHeader."Document Type");
            PRLIne.SETRANGE("Document No.", PRHeader."Document No.");
            //PRLIne.SETRANGE(Type,Type);
            //PRLIne.SETRANGE("No.","No.");
            PRLIne.SETRANGE(PRLIne."Line No.", PRRequestLineNo);
            //PRLIne.SETRANGE(PRLIne."Send for Enquiry",TRUE);
            IF PRLIne.FIND('-') THEN BEGIN
                VendorEnquiryLine.INIT;
                VendorEnquiryLine."Enquiry No." := VendorEnquiryHeader."Enquiry no.";
                VendorEnquiryLine."Line No." := PRLIne."Line No.";
                VendorEnquiryLine.Type := PRLIne.Type;
                VendorEnquiryLine."No." := PRLIne."No.";
                VendorEnquiryLine.Description := PRLIne.Description;
                VendorEnquiryLine.Description2 := PRLIne."Description 2";
                VendorEnquiryLine."Global Dimension 1 Code" := PRLIne."Shortcut Dimension 1 Code";
                VendorEnquiryLine."Global Dimension 2 Code" := PRLIne."Shortcut Dimension 2 Code";
                VendorEnquiryLine."Unit cost" := PRLIne."Direct Unit Cost";
                //VendorEnquiryLine.VALIDATE(Quantity,PRLIne."Indented Quantity");
                VendorEnquiryLine.VALIDATE(Quantity, PRLIne."Approved Qty");
                VendorEnquiryLine.VALIDATE("Location Code", PRLIne."Location code");
                VendorEnquiryLine."Uint of Measure" := PRLIne."Indent UOM";
                VendorEnquiryLine."PR No." := PRLIne."Document No.";
                VendorEnquiryLine."PR Line No." := PRLIne."Line No.";
                //ALLEDK 090610 For flow of job no. from indent line
                VendorEnquiryLine."Job No." := PRLIne."Job No.";
                VendorEnquiryLine."Job Task No." := PRLIne."Job Task No.";
                //ALLEDK 090610 For flow of job no. from indent line
                //ALLE PS Added code to Flow Job Code Fron Indent LIne
                VendorEnquiryLine."Job Master Code" := PRLIne."Job Master Code";
                VendorEnquiryLine.INSERT;
            END;
        END;
    end;

    local procedure OKOnPush()
    begin
        EnquiryGenerated := FALSE;
        PRHeader.GET(PRHeader."Document Type"::Indent, PRRequestDocNo);
        Rec.RESET;
        Rec.SETRANGE(Selected, TRUE);
        IF Rec.FINDSET THEN
            REPEAT
                IF NOT Rec.Append THEN BEGIN
                    GenerateEnquiry();
                    Rec.Selected := FALSE;
                    Rec.MODIFY;
                    EnquiryGenerated := TRUE;
                END ELSE BEGIN
                    GenerateExistEnquiry();
                    Rec.Selected := FALSE;
                    Rec.Append := FALSE;
                    Rec.MODIFY;
                    EnquiryGenerated := TRUE;
                END
            UNTIL Rec.NEXT = 0;

        IF EnquiryGenerated THEN
            MESSAGE('Enquiry Created');
        CurrPage.CLOSE;
    end;
}

