page 97833 "Charge Type for Project"
{
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
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                field("Sale/Lease"; Rec."Sale/Lease")
                {
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
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
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        IF Rec."Sale/Lease" = Rec."Sale/Lease"::" " THEN
                            ERROR('Please select either Sale or Lease');
                    end;
                }
                field("App. Charge Code"; Rec."App. Charge Code")
                {

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                field("App. Charge Name"; Rec."App. Charge Name")
                {

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                field("Unit Code"; Rec."Unit Code")
                {

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                field(Description; Rec.Description)
                {
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                field(Sequence; Rec.Sequence)
                {
                    Caption = 'Payment Sequence';

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                field("Rate Not Allowed"; Rec."Rate Not Allowed")
                {
                    Visible = true;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                field("Commision Applicable"; Rec."Commision Applicable")
                {

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                field("Direct Associate"; Rec."Direct Associate")
                {

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                field("Rate/Sq. Yd"; Rec."Rate/Sq. Yd")
                {
                    BlankZero = true;
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
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
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        Rec.TESTFIELD("Rate Not Allowed", FALSE);
                        Rec.TESTFIELD("Rate/Sq. Yd", 0);
                    end;
                }
                field("BSP4 Plan wise Rate / Sq. Yd"; Rec."BSP4 Plan wise Rate / Sq. Yd")
                {

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                field("Project Price Dependency Code"; Rec."Project Price Dependency Code")
                {
                    Style = Strong;
                    StyleExpr = TRUE;

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
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
                field(Status; Rec.Status)
                {

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                field(Version; Rec.Version)
                {
                    DrillDownPageID = "Archive Doument List";
                    LookupPageID = "Archive Doument List";

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }

            }
            part("Approval Entries"; "Project Price Approval")
            {
                SubPageLink = "Ref. Document No." = FIELD("Project Code"),
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
                    "Document No." = FIELD("Project Code");
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
                        OldJagratiApprovalentry.SetRange("Document Type", OldJagratiApprovalentry."Document Type"::"Project Price Change");
                        OldJagratiApprovalentry.SetRange("Ref. Document No.", Rec."Project Code");
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
                        JagratiApprovalSetup.SetRange("Document Type", JagratiApprovalSetup."Document Type"::"Project Price Change");
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
                            JagratiApprovalentry."Document Type" := JagratiApprovalentry."Document Type"::"Project Price Change";
                            JagratiApprovalentry."Ref. Document No." := REc."Project Code";
                            JagratiApprovalentry."Project Id" := Rec."Project Code";
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
                            JagratiApprovalentry."Project Name" := OldJagratiApprovalentry."Project Name";
                            JagratiApprovalentry.Insert;

                            DocumentMaster.RESET;
                            DocumentMaster.SetRange("Document Type", DocumentMaster."Document Type"::Charge);
                            DocumentMaster.SetRange("Project Code", Rec."Project Code");
                            DocumentMaster.Setrange("Unit Code", '');
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

                // action("Approve / Release")
                // {
                //     Caption = 'Approve / Release';
                //     Image = Approval;
                //     Promoted = true;
                //     PromotedCategory = Process;

                //     trigger OnAction()
                //     begin
                //         UserSetup.RESET;
                //         UserSetup.SETRANGE("User ID", USERID);
                //         UserSetup.SETRANGE("Project Approve", TRUE);
                //         IF NOT UserSetup.FINDFIRST THEN
                //             ERROR('Please contact Admin Department');


                //         Rec.TESTFIELD(Status, Rec.Status::Open);
                //         DocumentMaster.RESET;
                //         DocumentMaster.SETRANGE("Project Code", Rec."Project Code");
                //         DocumentMaster.SETRANGE("Unit Code", Rec."Unit Code");
                //         IF DocumentMaster.FINDSET THEN
                //             REPEAT
                //                 DocumentMaster.Status := DocumentMaster.Status::Release;
                //                 DocumentMaster.MODIFY;
                //             UNTIL DocumentMaster.NEXT = 0;
                //         CurrPage.EDITABLE := FALSE;
                //         CurrPage.UPDATE;
                //     end;

                // }
                action(Reopen)
                {
                    Caption = 'Reopen';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecJob_1: Record Job;
                        JagratiApprovalEntries: Record "Jagriti Approval Entry";
                        JagratiApprovalSetup: Record "Jagriti Sitewise Approvalsetup";
                        JagratiApprovalentry: Record "Jagriti Approval Entry";
                        LastEntryNo: integer;
                        RespCenter: Record "Responsibility Center 1";
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Project Re-Open", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin Department');

                        //Rec.TESTFIELD(Status, Rec.Status::Release);
                        IF Rec.Status = Rec.Status::Open then
                            Error('Already Reopen');

                        RecJob_1.RESET;
                        RecJob_1.SETRANGE("No.", Rec."Project Code");
                        IF RecJob_1.FINDFIRST THEN
                            RecJob_1.TESTFIELD(Status, RecJob_1.Status::Planning);

                        ArchDocMaster.RESET;
                        ArchDocMaster.SETCURRENTKEY("Project Code", "Unit Code", Version);
                        ArchDocMaster.SETRANGE("Project Code", Rec."Project Code");
                        ArchDocMaster.SETRANGE("Unit Code", Rec."Unit Code");
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
                        DocumentMaster.SETRANGE("Project Code", Rec."Project Code");
                        DocumentMaster.SETRANGE("Unit Code", Rec."Unit Code");
                        IF DocumentMaster.FINDSET THEN
                            REPEAT
                                DocumentMaster.Status := DocumentMaster.Status::Open;
                                DocumentMaster.MODIFY;
                            UNTIL DocumentMaster.NEXT = 0;

                        JagratiApprovalEntries.RESET;
                        JagratiApprovalEntries.SetRange("Document Type", JagratiApprovalEntries."Document Type"::"Project Price Change");
                        JagratiApprovalEntries.SetRange("Ref. Document No.", Rec."Project Code");
                        IF JagratiApprovalEntries.FindSet() then
                            repeat
                                JagratiApprovalEntries."Re-Open Document" := True;
                                JagratiApprovalEntries."Re-Open Document DT." := CurrentDateTime;
                                JagratiApprovalEntries.Modify;
                            Until JagratiApprovalEntries.Next = 0;


                        JagratiApprovalSetup.RESET;
                        JagratiApprovalSetup.SetRange("Document Type", JagratiApprovalSetup."Document Type"::"Project Price Change");
                        JagratiApprovalSetup.SetRange("Initiator ID", USERID);
                        IF NOT JagratiApprovalSetup.FindFirst() then
                            Error('Initiator Setup does not exists against user id' + USERID);

                        JagratiApprovalentry.RESET;
                        IF JagratiApprovalentry.FindLast() then
                            LastEntryNo := JagratiApprovalentry."Entry No.";
                        JagratiApprovalentry.Init;
                        JagratiApprovalentry."Entry No." := LastEntryNo + 1;
                        JagratiApprovalentry."Document Type" := JagratiApprovalentry."Document Type"::"Project Price Change";
                        JagratiApprovalentry."Ref. Document No." := REc."Project Code";
                        JagratiApprovalentry."Project Id" := REc."Project Code";
                        JagratiApprovalentry."Approver ID" := UserId;
                        IF JagratiApprovalSetup."Initiator ID" <> '' then
                            JagratiApprovalSetup.CalcFields("Initiator ID Name");
                        JagratiApprovalentry."Approver Name" := JagratiApprovalSetup."Initiator ID Name";
                        JagratiApprovalentry.Status := JagratiApprovalentry.Status::Pending;
                        JagratiApprovalentry."Requester ID" := USERID;

                        RespCenter.RESET;
                        IF RespCenter.GET(REc."Project Code") then
                            JagratiApprovalentry."Project Name" := RespCenter.name;
                        JagratiApprovalentry.Insert;
                    end;

                }
                action("Rate and Seq. Update")
                {
                    Caption = 'Rate and Seq. Update';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        DocumentMaster_1: Record "Document Master";
                        DocumentMaster_2: Record "Document Master";
                        DocumentMaster_3: Record "Document Master";
                        Companywise: Record "Company wise G/L Account";
                        CompanyWise_1: Record "Company wise G/L Account";
                        FindCompany: Boolean;
                        ResponsibilityCenter_1: Record "Responsibility Center 1";
                        UnitMaster_1: Record "Unit Master";
                        UnitMaster_2: Record "Unit Master";
                        JobRec_1: Record Job;
                    begin
                        Rec.TestField(Status, Rec.Status::Release);

                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Project Approve", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin Department');

                        IF CONFIRM('Do you want to update Rate on Open Units', FALSE) THEN BEGIN
                            JobRec_1.RESET;
                            IF JobRec_1.GET(Rec."Project Code") THEN
                                JobRec_1.TESTFIELD(Status, JobRec_1.Status::Order);

                            MemberOf.RESET;
                            MemberOf.SETRANGE("User Name", USERID);
                            MemberOf.SETRANGE("Role ID", 'ProjectRateCh');
                            IF NOT MemberOf.FINDFIRST THEN
                                ERROR('You are not authorised person for change Project Rate');

                            RecUnitMaster.RESET;
                            RecUnitMaster.SETRANGE("Project Code", Rec."Project Code");
                            RecUnitMaster.SETRANGE(Status, RecUnitMaster.Status::Open);
                            IF RecUnitMaster.FINDSET THEN
                                REPEAT
                                    //.............Unit Charge Type Archive.............
                                    ArchDocMaster.RESET;
                                    ArchDocMaster.SETCURRENTKEY("Project Code", "Unit Code");
                                    ArchDocMaster.SETRANGE("Unit Code", RecUnitMaster."No.");
                                    ArchDocMaster.SETRANGE("Project Code", Rec."Project Code");
                                    ArchDocMaster.SETFILTER(Code, '<>%1', 'OTH');
                                    IF ArchDocMaster.FINDLAST THEN
                                        Versn := ArchDocMaster.Version
                                    ELSE
                                        Versn := 0;

                                    DocMaster.RESET;
                                    DocMaster.SETRANGE("Unit Code", RecUnitMaster."No.");
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

                                    //.............Unit Charge Type Archive.............



                                    ToDoctMaster1.RESET;
                                    ToDoctMaster1.SETRANGE("Document Type", ToDoctMaster1."Document Type"::Charge);
                                    ToDoctMaster1.SETRANGE("Project Code", Rec."Project Code");
                                    ToDoctMaster1.SETRANGE("Unit Code", RecUnitMaster."No.");
                                    ToDoctMaster1.SETFILTER(Code, '<>%1', 'BSP3');
                                    IF ToDoctMaster1.FINDSET THEN
                                        REPEAT
                                            ToDoctMaster1.DELETE;
                                        UNTIL ToDoctMaster1.NEXT = 0;


                                    FromDocMaster1.RESET;
                                    FromDocMaster1.SETRANGE("Document Type", FromDocMaster1."Document Type"::Charge);
                                    FromDocMaster1.SETRANGE("Project Code", Rec."Project Code");
                                    FromDocMaster1.SETRANGE("Unit Code", '');
                                    // FromDocMaster1.SETFILTER("Rate/Sq. Yd",'>%1',0);
                                    FromDocMaster1.SETRANGE("Sub Payment Plan", FALSE);
                                    IF FromDocMaster1.FINDFIRST THEN BEGIN
                                        REPEAT
                                            ToDoctMaster1.RESET;
                                            ToDoctMaster1.SETRANGE("Document Type", ToDoctMaster1."Document Type"::Charge);
                                            ToDoctMaster1.SETRANGE("Project Code", Rec."Project Code");
                                            ToDoctMaster1.SETRANGE("Unit Code", RecUnitMaster."No.");
                                            ToDoctMaster1.SETRANGE(Code, FromDocMaster1.Code);
                                            ToDoctMaster1.SETRANGE("App. Charge Code", FromDocMaster1."App. Charge Code");
                                            IF ToDoctMaster1.FINDFIRST THEN BEGIN
                                                ToDoctMaster1."Sale/Lease" := FromDocMaster1."Sale/Lease";
                                                ToDoctMaster1."Unit Code" := RecUnitMaster."No.";
                                                ToDoctMaster1.Description := FromDocMaster1.Description;
                                                IF FromDocMaster1."Rate/Sq. Yd" <> 0 THEN
                                                    ToDoctMaster1.VALIDATE("Rate/Sq. Yd", FromDocMaster1."Rate/Sq. Yd");
                                                IF FromDocMaster1."Rate/Sq. Yd" = 0 THEN
                                                    ToDoctMaster1.VALIDATE("Fixed Price", FromDocMaster1."Fixed Price");
                                                ToDoctMaster1."BP Dependency" := FromDocMaster1."BP Dependency";
                                                ToDoctMaster1."Rate Not Allowed" := FromDocMaster1."Rate Not Allowed";
                                                ToDoctMaster1."Project Price Dependency Code" := FromDocMaster1."Project Price Dependency Code";
                                                ToDoctMaster1."Payment Plan Type" := FromDocMaster1."Payment Plan Type";
                                                ToDoctMaster1."Commision Applicable" := FromDocMaster1."Commision Applicable";
                                                ToDoctMaster1."Direct Associate" := FromDocMaster1."Direct Associate";
                                                ToDoctMaster1.Sequence := FromDocMaster1.Sequence;
                                                ToDoctMaster1."App. Charge Code" := FromDocMaster1."App. Charge Code";
                                                ToDoctMaster1.MODIFY;
                                            END ELSE
                                                IF FromDocMaster1.Code <> 'BSP3' THEN BEGIN
                                                    ToDoctMaster.INIT;
                                                    ToDoctMaster."Document Type" := FromDocMaster1."Document Type";
                                                    ToDoctMaster."Project Code" := FromDocMaster1."Project Code";
                                                    ToDoctMaster.Code := FromDocMaster1.Code;
                                                    ToDoctMaster."Sale/Lease" := FromDocMaster1."Sale/Lease";
                                                    ToDoctMaster."Unit Code" := RecUnitMaster."No.";
                                                    ToDoctMaster.Description := FromDocMaster1.Description;
                                                    ToDoctMaster."Rate/Sq. Yd" := FromDocMaster1."Rate/Sq. Yd";
                                                    ToDoctMaster."Fixed Price" := FromDocMaster1."Fixed Price";
                                                    ToDoctMaster."BP Dependency" := FromDocMaster1."BP Dependency";
                                                    ToDoctMaster."Rate Not Allowed" := FromDocMaster1."Rate Not Allowed";
                                                    ToDoctMaster."Project Price Dependency Code" := FromDocMaster1."Project Price Dependency Code";
                                                    ToDoctMaster."App. Charge Code" := FromDocMaster1."App. Charge Code";
                                                    ToDoctMaster."Payment Plan Type" := FromDocMaster1."Payment Plan Type";
                                                    ToDoctMaster."Commision Applicable" := FromDocMaster1."Commision Applicable";
                                                    ToDoctMaster."Direct Associate" := FromDocMaster1."Direct Associate";
                                                    ToDoctMaster.Sequence := FromDocMaster1.Sequence;
                                                    IF FromDocMaster1."Fixed Price" = 0 THEN
                                                        ToDoctMaster."Total Charge Amount" := FromDocMaster1."Rate/Sq. Yd" * RecUnitMaster."Saleable Area"
                                                    ELSE
                                                        ToDoctMaster."Total Charge Amount" := FromDocMaster1."Fixed Price";
                                                    ToDoctMaster.Status := ToDoctMaster.Status::Release;
                                                    ToDoctMaster.INSERT(TRUE);
                                                END;

                                        UNTIL FromDocMaster1.NEXT = 0;

                                    END;

                                    FromDocMaster1.RESET;
                                    FromDocMaster1.SETRANGE("Document Type", FromDocMaster1."Document Type"::Charge);
                                    FromDocMaster1.SETRANGE("Project Code", Rec."Project Code");
                                    FromDocMaster1.SETRANGE("Unit Code", '');
                                    FromDocMaster1.SETFILTER("Rate/Sq. Yd", '>%1', 0);
                                    FromDocMaster1.SETRANGE("Sub Sub Payment Plan Code", '1008');
                                    IF FromDocMaster1.FINDFIRST THEN BEGIN
                                        ToDoctMaster.INIT;
                                        ToDoctMaster."Document Type" := FromDocMaster1."Document Type";
                                        ToDoctMaster."Project Code" := FromDocMaster1."Project Code";
                                        ToDoctMaster.Code := FromDocMaster1.Code;
                                        ToDoctMaster."Sale/Lease" := FromDocMaster1."Sale/Lease";
                                        ToDoctMaster."Unit Code" := RecUnitMaster."No.";
                                        ToDoctMaster.Description := FromDocMaster1.Description;
                                        ToDoctMaster."Rate/Sq. Yd" := FromDocMaster1."Rate/Sq. Yd";
                                        ToDoctMaster."Fixed Price" := FromDocMaster1."Fixed Price";
                                        ToDoctMaster."BP Dependency" := FromDocMaster1."BP Dependency";
                                        ToDoctMaster."Rate Not Allowed" := FromDocMaster1."Rate Not Allowed";
                                        ToDoctMaster."Project Price Dependency Code" := FromDocMaster1."Project Price Dependency Code";
                                        ToDoctMaster."App. Charge Code" := FromDocMaster1."App. Charge Code";
                                        ToDoctMaster."Payment Plan Type" := FromDocMaster1."Payment Plan Type";
                                        ToDoctMaster."Commision Applicable" := FromDocMaster1."Commision Applicable";
                                        ToDoctMaster."Direct Associate" := FromDocMaster1."Direct Associate";
                                        ToDoctMaster.Sequence := FromDocMaster1.Sequence;
                                        IF FromDocMaster1."Fixed Price" = 0 THEN
                                            ToDoctMaster."Total Charge Amount" := FromDocMaster1."Rate/Sq. Yd" * RecUnitMaster."Saleable Area"
                                        ELSE
                                            ToDoctMaster."Total Charge Amount" := FromDocMaster1."Fixed Price";
                                        ToDoctMaster.Status := ToDoctMaster.Status::Release;
                                        ToDoctMaster.INSERT(TRUE);
                                    END;

                                    UpdateRoundOFF(RecUnitMaster."Project Code", RecUnitMaster."No.");
                                    CreateUnitLifeCycle; //040919
                                UNTIL RecUnitMaster.NEXT = 0;

                            MESSAGE('Unit Charges update');
                            //ALLEDK 250113
                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Rec.Status = Rec.Status::Release THEN
            CurrPage.EDITABLE(FALSE)
        ELSE
            CurrPage.EDITABLE(TRUE);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IF (Rec.Status = Rec.Status::Release) OR (Rec.Status = Rec.Status::Rejected) then
            Error('Status must be OPEN or Pending for Approval');

        IF (Rec."Rate/Sq. Yd" > 0) OR (Rec."Fixed Price" > 0) THEN;

        // CalculateTotalUnitPrice;
    end;

    var
        DocMasRec: Record "Project Price Group Details";
        ApplicableCharges: Record "Applicable Charges";
        FromDocMaster: Record "Document Master";
        Text001: Label 'Delete existing applicable charges.';
        CalDocMaster: Record "Document Master";
        ToDoctMaster: Record "Document Master";
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
        UpdateDoctMaster: Record "Document Master";
        RecUnitMaster: Record "Unit Master";
        FromDocMaster1: Record "Document Master";
        ToDoctMaster1: Record "Document Master";
        MemberOf: Record "Access Control";
        ChargeTypePAGE: Page "Charge Type";
        TotalChAmt1: Decimal;
        RoundOffAmt: Decimal;
        ReviseValue: Decimal;
        DocumentMaster1: Record "Document Master";
        //Newunitmaster: Record 50019;
        ReleaseUnit: Codeunit "Release Unit Application";
        UserSetup: Record "User Setup";


    procedure UpdateRoundOFF(ProjectCode: Code[20]; UnitCode: Code[20])
    begin
        TotalChAmt1 := 0;
        RoundOffAmt := 0;
        ReviseValue := 0;
        DocumentMaster.RESET;
        DocumentMaster.SETRANGE("Document Type", DocumentMaster."Document Type"::Charge);
        DocumentMaster.SETRANGE("Project Code", ProjectCode);
        DocumentMaster.SETRANGE("Unit Code", UnitCode);
        DocumentMaster.SETFILTER(Code, '<>%1', 'OTH');
        IF DocumentMaster.FINDFIRST THEN BEGIN
            REPEAT
                TotalChAmt1 := TotalChAmt1 + DocumentMaster."Total Charge Amount";
            UNTIL DocumentMaster.NEXT = 0;
            ReviseValue := ROUND(TotalChAmt1, 1, '>');

            RoundOffAmt := ReviseValue - TotalChAmt1;
            IF RoundOffAmt < 0 THEN
                ERROR('The Unit Rate must be greater or Equal to Charge Rate');

            IF RoundOffAmt <> 0 THEN BEGIN
                DocumentMaster1.RESET;
                DocumentMaster1.SETRANGE("Document Type", DocumentMaster1."Document Type"::Charge);
                DocumentMaster1.SETRANGE("Project Code", ProjectCode);
                DocumentMaster1.SETRANGE("Unit Code", UnitCode);
                DocumentMaster1.SETRANGE(Code, 'OTH');
                IF DocumentMaster1.FINDFIRST THEN
                    DocumentMaster1.VALIDATE("Fixed Price", (RoundOffAmt));
                DocumentMaster1.MODIFY;
            END;
        END;
        IF UMaster.GET(UnitCode) THEN BEGIN
            UMaster."Total Value" := ROUND(ReviseValue, 1, '>');
            UMaster.Archived := UMaster.Archived::No;
            UMaster.MODIFY;
            //  ReleaseUnit.Updateunitmaster(UMaster);
        END;
        ReviseValue := 0;
    end;

    local procedure CreateUnitLifeCycle()
    var
        UnitLifeCycle: Record "Unit Life Cycle";
        OldUnitLifeCycle: Record "Unit Life Cycle";
        LineNo: Integer;
        ExistUnitLifeCycle: Record "Unit Life Cycle";
    begin
        LineNo := 0;
        OldUnitLifeCycle.RESET;
        OldUnitLifeCycle.SETRANGE("Unit Code", Rec."Unit Code");
        IF OldUnitLifeCycle.FINDLAST THEN
            LineNo := OldUnitLifeCycle."Line No.";

        UnitLifeCycle.INIT;
        UnitLifeCycle.TRANSFERFIELDS(OldUnitLifeCycle);
        UnitLifeCycle."Unit Code" := Rec."Unit Code";
        UnitLifeCycle."Line No." := LineNo + 1;
        UnitLifeCycle."Type of Transaction" := UnitLifeCycle."Type of Transaction"::"Unit modify";
        UnitLifeCycle."Unit Cost" := ROUND(ReviseValue, 1, '>');
        UnitLifeCycle.INSERT;
    end;
}

