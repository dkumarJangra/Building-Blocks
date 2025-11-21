page 97747 "Material Return Header"
{
    // //NDALLE 081205
    // //ALLE-PKS16 confirm box
    // //ALLEAB012 Testfield for qty & item line
    // //ALLE-PKS 34 for the names of dimensions
    // 
    // //dds - DOC NO-onassistedit - code below removed as end user was able to delete MIN no series
    // //PurAndPay.GET;
    // //PurAndPay.TESTFIELD("Material Return Note");
    // //IF NoSeriesMgt.SelectSeries(PurAndPay."Material Return Note","MRN No. Series","MRN No. Series") THEN BEGIN
    // //  PurAndPay.GET;
    // //  PurAndPay.TESTFIELD("Material Return Note");
    // //  NoSeriesMgt.SetSeries("Document No.");
    // //  CurrPAGE.UPDATE;
    // //END;
    // AlleDK 020909 modify form
    // //alle PS added code for Passing Applies

    Caption = 'Reverse Consumption';
    PageType = Card;
    SourceTable = "Gate Pass Header";
    SourceTableView = SORTING("Document Type", "Document No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER("Material Return"),
                            Status = FILTER(Open));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    Caption = 'WO No.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = ShortcutDimension1CodeEditable;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field(Short1name; Short1name)
                {
                    Editable = false;
                }
                field(Respname; Respname)
                {
                    Editable = false;
                }
                field(Locname; Locname)
                {
                    Editable = false;
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field("Job No."; Rec."Job No.")
                {
                    Editable = true;
                }
                field("Entered By"; Rec."Entered By")
                {
                }
                field("Entered By Name"; Rec."Entered By Name")
                {
                    Editable = false;
                }
                field("Issued By"; Rec."Issued By")
                {
                    Caption = 'Rceieved By -Stores';
                }
                field("Issued By Name"; Rec."Issued By Name")
                {
                    Editable = false;
                }
                field("Received By"; Rec."Received By")
                {
                    Caption = 'Returned By';
                }
                field("Received By Name"; Rec."Received By Name")
                {
                    Editable = false;
                }
                field("Receiver Name"; Rec."Receiver Name")
                {
                    Caption = 'Returned Through';
                }
                field(Status; Rec.Status)
                {
                }
                field("Total Value"; Rec."Total Value")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Reference No."; Rec."Reference No.")
                {
                }
            }
            part("Material Return Lines"; "Material Return Lines")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No.");
                SubPageView = SORTING("Document Type", "Document No.", "Line No.")
                              ORDER(Ascending);
            }
            group(Verification)
            {
                Caption = 'Verification';
                field("Sent for Verification"; Rec."Sent for Verification")
                {
                    Editable = false;
                }
                field("Sent for Verification Date"; Rec."Sent for Verification Date")
                {
                    Editable = false;
                }
                field("Sent For Verification Time"; Rec."Sent For Verification Time")
                {
                    Editable = false;
                }
                field(Verified; Rec.Verified)
                {
                }
                field("Verified Date"; Rec."Verified Date")
                {
                }
                field("Verified Time"; Rec."Verified Time")
                {
                }
                field(Returned; Rec.Returned)
                {
                    Editable = false;
                }
                field("Returned Date"; Rec."Returned Date")
                {
                    Editable = false;
                }
                field("Returned Time"; Rec."Returned Time")
                {
                    Editable = false;
                }
                field("Sent for Verification By"; Rec."Sent for Verification By")
                {
                }
                field("Verified By"; Rec."Verified By")
                {
                }
                field("Returned By"; Rec."Returned By")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&MRS")
            {
                Caption = '&MRS';
                action("&Sent For Verification")
                {
                    Caption = 'Sent For Verification';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Sent for Verification", FALSE);
                        //ALLEAB012
                        GatePassLines.RESET;
                        GatePassLines.SETRANGE("Document Type", Rec."Document Type");
                        GatePassLines.SETRANGE("Document No.", Rec."Document No.");
                        IF GatePassLines.FIND('-') THEN
                            REPEAT
                                GatePassLines.TESTFIELD(GatePassLines.Qty);
                                //AlleDK 020909
                                CompanyInfo.GET;
                                IF CompanyInfo."Job Madetory On MRN" THEN BEGIN
                                    GatePassLines.TESTFIELD("Job No.");
                                    GatePassLines.TESTFIELD("Job Task No.");
                                END;
                                IF Loc.GET(GatePassLines."Location Code") THEN
                                    IF Loc."Bin Mandatory" THEN
                                        GatePassLines.TESTFIELD("Bin Code");
                            //AlleDK 020909
                            UNTIL GatePassLines.NEXT = 0
                        ELSE
                            ERROR('Cannot send Blank MRN !');
                        //ALLEAB012

                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'MIN-SENT-FOR-VERIFY');
                        IF NOT MemberOf.FIND('-') THEN
                            ERROR('UnAuthorised User for sending for Verification');

                        //ALLE-PKS16
                        Accept := CONFIRM(Text007, TRUE, 'MRN', Rec."Document No.");
                        IF NOT Accept THEN EXIT;
                        //ALLE-PKS16

                        Rec."Sent for Verification" := TRUE;
                        Rec."Sent for Verification Date" := TODAY;
                        Rec."Sent For Verification Time" := TIME;
                        Rec."Sent for Verification By" := USERID;
                        Rec.MODIFY;
                    end;
                }
                action("Return MRS")
                {
                    Caption = 'Return MRS';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Verified, FALSE);
                        Rec.TESTFIELD("Sent for Verification", TRUE);
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'MIN-SUPER');
                        IF NOT MemberOf.FIND('-') THEN
                            ERROR('UnAuthorised User for removing Sent for Verification.');
                        //ALLE-PKS16
                        Returnmin := CONFIRM(Text009, TRUE, 'MRN', Rec."Document No.");
                        IF NOT Returnmin THEN EXIT;
                        //ALLE-PKS16

                        Rec."Sent for Verification" := FALSE;
                        Rec."Sent for Verification Date" := 0D;
                        Rec."Sent For Verification Time" := 0T;
                        Rec."Sent for Verification By" := '';
                        Rec.Returned := TRUE;
                        Rec."Returned Date" := TODAY;
                        Rec."Returned Time" := TIME;
                        Rec.MODIFY;
                    end;
                }
                action("Verify MRS")
                {
                    Caption = 'Verify MRS';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Sent for Verification", TRUE);
                        Rec.TESTFIELD(Verified, FALSE);
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'MIN-VERIFY');
                        IF NOT MemberOf.FIND('-') THEN
                            ERROR('UnAuthorised User for Verifying MIN');
                        //ALLE-PKS16
                        Verify := CONFIRM(Text008, TRUE, 'MRN', Rec."Document No.");
                        IF NOT Verify THEN EXIT;
                        //ALLE-PKS16

                        Rec.Verified := TRUE;
                        Rec."Verified Date" := TODAY;
                        Rec."Verified Time" := TIME;
                        Rec."Verified By" := USERID;
                        Rec.MODIFY;
                    end;
                }
                action("Return Verified MRS")
                {
                    Caption = 'Return Verified MRS';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Verified, TRUE);
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'MIN-SUPER');
                        IF NOT MemberOf.FIND('-') THEN
                            ERROR('UnAuthorised User for Removing Verified MIN');
                        //ALLE-PKS16
                        Returnvermin := CONFIRM(Text010, TRUE, 'MRN', Rec."Document No.");
                        IF NOT Returnvermin THEN EXIT;
                        //ALLE-PKS16

                        Rec.Verified := FALSE;
                        Rec."Verified Date" := 0D;
                        Rec."Verified Time" := 0T;
                        Rec."Verified By" := '';
                        Rec.MODIFY;
                    end;
                }
            }
            group("&Post")
            {
                Caption = '&Post';
                action("Post")
                {
                    Caption = '&Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        Rec.TESTFIELD(Verified, TRUE);
                        Rec.TESTFIELD("Sent for Verification", TRUE);
                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        //TESTFIELD("Shortcut Dimension 2 Code");

                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'MIN-POST');
                        IF NOT MemberOf.FIND('-') THEN
                            ERROR('UnAuthorised User for Posting MIN Return Document.');

                        IF CONFIRM(txtConfirm, TRUE) THEN BEGIN
                            //SC ->>
                            recGatePassLines.RESET;
                            recGatePassLines.SETRANGE(recGatePassLines."Document Type", recGatePassLines."Document Type"::"Material Return");
                            recGatePassLines.SETRANGE(recGatePassLines."Document No.", Rec."Document No.");
                            recGatePassLines.SETRANGE(recGatePassLines."Journal Line Created", FALSE);
                            IF recGatePassLines.FIND('-') THEN BEGIN
                                REPEAT
                                    //have to give a prompt msg dds -
                                    //dds-commented to remove for free //recGatePassLines.TESTFIELD(recGatePassLines."Applies-from Entry");
                                    IF recGatePassLines."Gen. Bus. Posting Group" = '' THEN
                                        recGatePassLines."Gen. Bus. Posting Group" := 'DOMESTIC';
                                    IF recGatePassLines."Shortcut Dimension 1 Code" = '' THEN
                                        ERROR('Enter Region Code');
                                    IF recGatePassLines."Shortcut Dimension 2 Code" = '' THEN
                                        ERROR('Enter Cost Centre Code');

                                UNTIL recGatePassLines.NEXT = 0;
                            END;
                            //SC <<-

                            /*  //AlleDK 020909
                              //NDALLE181207
                            IF "Job No." = '' THEN
                              postItemJnl
                            ELSE
                              postJobJnl;
                            //NDALLE181207
                          */

                            CompanyInfo.GET;
                            IF NOT CompanyInfo."Job Madetory On MRN" THEN BEGIN
                                postItemJnl;
                                postJobJnl;
                            END ELSE BEGIN
                                IF Rec."Job No." = '' THEN
                                    postItemJnl
                                ELSE BEGIN
                                    postJobJnl;
                                END;
                            END;
                            //AlleDK 020909


                            IF recGatePassLines.FIND('-') THEN
                                recGatePassLines.MODIFYALL("Journal Line Created", TRUE);

                            //ALLE-PKS13
                            recGatePassLines.RESET;
                            recGatePassLines.SETCURRENTKEY("Account No.");
                            recGatePassLines.SETRANGE(recGatePassLines."Document Type", recGatePassLines."Document Type"::"Material Return");
                            recGatePassLines.SETRANGE(recGatePassLines."Document No.", Rec."Document No.");
                            recGatePassLines.SETRANGE(recGatePassLines."Credit Note Created", FALSE);
                            recGatePassLines.SETFILTER(recGatePassLines."Min No.", '<>%1', '');
                            recGatePassLines.SETRANGE(recGatePassLines.Chargeable, TRUE);

                            IF recGatePassLines.FIND('-') THEN BEGIN
                                InsertGlLInes;
                                recGatePassLines.MODIFYALL("Credit Note Created", TRUE);
                            END;
                            //ALLE-PKS13

                            //"Issued By":=USERID;
                            Rec.VALIDATE(Status, Rec.Status::Close);
                            Rec.MODIFY;

                        END;
                        MESSAGE('Document Successfuly Posted')

                    end;
                }
            }
        }
        area(processing)
        {
            action("Change Posting Date ")
            {
                Caption = 'Change Posting Date ';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //IF (USERID =Initiator) or (USERID='100654') THEN
                    //BEGIN
                    Rec."Posting Date" := TODAY;
                    Rec.MODIFY;
                    // END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //ALLE-PKS 34
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            Locname := RecRespCenter."Location Name";
        END;
        //ALLE-PKS 34

        /*
        CurrPAGE."Shortcut Dimension 1 Code".EDITABLE:=TRUE;
        IF "Sent for Verification"=FALSE THEN BEGIN
          MemberOf.RESET;
          MemberOf.SETRANGE(MemberOf."User ID",USERID);
          MemberOf.SETRANGE(MemberOf."Role ID",'MIN-SENT-FOR-VERIFY');
          IF MemberOf.FIND('-') THEN
            CurrPAGE.EDITABLE:=TRUE
          ELSE
            CurrPAGE.EDITABLE:=FALSE;
        END
        ELSE BEGIN
          IF Verified = FALSE THEN BEGIN
            MemberOf.RESET;
            MemberOf.SETRANGE(MemberOf."User ID",USERID);
            MemberOf.SETRANGE(MemberOf."Role ID",'MIN-SENT-FOR-VERIFY');
            IF MemberOf.FIND('-') THEN BEGIN
              CurrPAGE.EDITABLE:=FALSE;
            END
            ELSE BEGIN
              MemberOf.RESET;
              MemberOf.SETRANGE(MemberOf."User ID",USERID);
              MemberOf.SETRANGE(MemberOf."Role ID",'MIN-VERIFY');
              IF MemberOf.FIND('-') THEN BEGIN
                CurrPAGE.EDITABLE:=TRUE;
              END
              ELSE BEGIN
                CurrPAGE.EDITABLE:=FALSE;
              END;
            END;
          END
          ELSE BEGIN {verified ok}
            ShortcutDimension1CodeEditable :=FALSE;
            MemberOf.RESET;
            MemberOf.SETRANGE(MemberOf."User ID",USERID);
            MemberOf.SETRANGE(MemberOf."Role ID",'MIN-SENT-FOR-VERIFY');
            IF MemberOf.FIND('-') THEN BEGIN
              CurrPage.EDITABLE:=TRUE;
              ShortcutDimension1CodeEditable :=FALSE;
            END
            ELSE BEGIN
              MemberOf.RESET;
              MemberOf.SETRANGE(MemberOf."User ID",USERID);
              MemberOf.SETRANGE(MemberOf."Role ID",'MIN-VERIFY');
              IF MemberOf.FIND('-') THEN BEGIN
                CurrPage.EDITABLE:=FALSE;
              END
              ELSE BEGIN
                CurrPage.EDITABLE:=TRUE;
                ShortcutDimension1CodeEditable :=FALSE;
              END;
            END;
        
          END;
        END;
        */

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Status := Rec.Status::Open;
        //ALLEND 191107
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            Locname := RecRespCenter."Location Name";
        END;
        //ALLE-SR-051107 >>
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        //ALLE-SR-051107 <<
    end;

    trigger OnOpenPage()
    begin

        IF Rec.Verified = TRUE THEN
            CurrPage.EDITABLE(FALSE);


        //ALLEND 191107
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            Locname := RecRespCenter."Location Name";
        END;

        //ALLE-SR-051107 >>
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FILTERGROUP(0);
        END;
        //ALLE-SR-051107 <<
    end;

    var
        txtConfirm: Label 'Are You sure about the details to be updated in Ledgers ?';
        Text001: Label 'Do you want to replace the existing picture of %1 %2?';
        Text002: Label 'Do you want to delete the picture of %1 %2?';
        GatePassLines: Record "Gate Pass Line";
        JobJnl: Record "Job Journal Line";
        ItemJnl: Record "Item Journal Line";
        ItemJournalTemplate: Record "Item Journal Template";
        numSeries: Code[10];
        NoSeries: Codeunit NoSeriesManagement;
        PictureExists: Boolean;
        DocNumber: Code[10];
        ItemJournal: Record "Item Journal Line";
        endLineNo: Integer;
        recGatePassLines: Record "Gate Pass Line";
        recEmployee: Record Employee;
        CodeUnitRun: Boolean;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurAndPay: Record "Purchases & Payables Setup";
        GenSetup: Record "General Ledger Setup";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        Navigate: Page Navigate;
        Short1name: Text[50];
        Respname: Text[50];
        Locname: Text[50];
        RecDimValue: Record "Dimension Value";
        RecLocation: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        RecUserSetup: Record "User Setup";
        UserMgt: Codeunit "User Setup Management";
        RecJobJnlLine: Record "Job Journal Line";
        JobJournal: Record "Job Journal Line";
        recGatePassLines2: Record "Gate Pass Line";
        JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        JobJnlPostLine1: Codeunit MyCodeunit;
        GenTemplateCode: Code[20];
        GenBatchCode: Code[20];
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GatePassHdr: Record "Gate Pass Header";
        GenJnlLine: Record "Gen. Journal Line";
        vLineNo: Integer;
        Tamt: Decimal;
        Amount: Decimal;
        GPassLine: Record "Gate Pass Line";
        GEnJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Accept: Boolean;
        Text007: Label 'Do you want to Send the %1 No.-%2 For Verification';
        Text009: Label 'Do you want to Return %1 No.-%2 ';
        Text010: Label 'Do you want to Return Verified %1 No.-%2';
        Returnmin: Boolean;
        Verify: Boolean;
        Text008: Label 'Do you want to Verify %1 No.-%2 ';
        Returnvermin: Boolean;
        inventorySetup: Record "Inventory Setup";
        CompanyInfo: Record "Company Information";
        WMSMgmt: Codeunit "WMS Management";
        WhseJnlLine: Record "Warehouse Journal Line";
        WhseJnlPostLine: Codeunit "Whse. Jnl.-Register Line";
        Loc: Record Location;
        GPHeader: Record "Gate Pass Header";

        ShortcutDimension1CodeEditable: Boolean;
        MemberOf: Record "Access Control";


    procedure postItemJnl()
    begin
        GetLines;
        recGatePassLines.RESET;
        recGatePassLines.SETRANGE(recGatePassLines."Document Type", recGatePassLines."Document Type"::"Material Return");
        recGatePassLines.SETRANGE(recGatePassLines."Document No.", Rec."Document No.");
        recGatePassLines.SETRANGE(recGatePassLines."Journal Line Created", FALSE);
        IF recGatePassLines.FIND('-') THEN
            REPEAT
                InsertItemJournals()
UNTIL recGatePassLines.NEXT = 0;
    end;


    procedure GetLines()
    begin

        GatePassLines.RESET;
        GatePassLines.SETRANGE("Document Type", Rec."Document Type");
        GatePassLines.SETRANGE("Document No.", Rec."Document No.");
        IF NOT GatePassLines.FIND('-') THEN
            ERROR('Nothing to Post');
    end;


    procedure InsertItemJournals()
    begin

        ItemJournal.RESET;
        ItemJournal.SETRANGE("Journal Template Name", 'MR');
        ItemJournal.SETRANGE("Journal Batch Name", 'MR');
        IF ItemJournal.FIND('+') THEN
            endLineNo := ItemJournal."Line No." + 10000
        ELSE
            endLineNo := 10000;

        ItemJnl.VALIDATE("Journal Template Name", 'MR');
        ItemJnl.VALIDATE("Journal Batch Name", 'MR');
        ItemJnl.VALIDATE("Document No.", Rec."Document No.");
        ItemJnl.VALIDATE("Line No.", endLineNo);
        ItemJnl.VALIDATE("Vendor No.", Rec."Vendor No.");
        ItemJnl.VALIDATE("PO No.", Rec."Purchase Order No.");
        //dds
        ItemJnl.VALIDATE("Item Shpt. Entry No.", 0);
        //dds

        ItemJnl.INSERT(TRUE);
        ItemJnl.VALIDATE("Posting Date", Rec."Posting Date");
        ItemJnl.VALIDATE("Entry Type", ItemJnl."Entry Type"::"Positive Adjmt.");
        ItemJnl.VALIDATE("Item No.", recGatePassLines."Item No.");
        ItemJnl.VALIDATE("Location Code", recGatePassLines."Location Code");
        ItemJnl.VALIDATE(Quantity, recGatePassLines.Qty);
        ItemJnl.Narration := recGatePassLines.Description + ' Qty:' + FORMAT(recGatePassLines.Qty); //GKG

        IF recGatePassLines."Gen. Bus. Posting Group" <> '' THEN
            ItemJnl.VALIDATE(ItemJnl."Gen. Bus. Posting Group", recGatePassLines."Gen. Bus. Posting Group");
        IF recGatePassLines."Gen. Prod. Posting Group" <> '' THEN
            ItemJnl.VALIDATE(ItemJnl."Gen. Prod. Posting Group", recGatePassLines."Gen. Prod. Posting Group");
        ItemJnl.VALIDATE(ItemJnl."Shortcut Dimension 1 Code", recGatePassLines."Shortcut Dimension 1 Code");
        ItemJnl.VALIDATE(ItemJnl."Shortcut Dimension 2 Code", recGatePassLines."Shortcut Dimension 2 Code");
        ItemJnl.VALIDATE(ItemJnl."Applies-from Entry", recGatePassLines."Applies-from Entry");
        ItemJnl.MODIFY(TRUE);
        //recGatePassLines."Journal Line No" := endLineNo;
        //recGatePassLines."Journal Line Created" := TRUE;
        recGatePassLines."Unit Cost" := ItemJnl."Unit Cost";

        recGatePassLines.MODIFY();
        // ALLE MM Code Commented
        /*
        TempJnlLineDim.DELETEALL;
        {
        TempDocDim.RESET;
        TempDocDim.SETRANGE("Table ID",DATABASE::"Purchase Line");
        TempDocDim.SETRANGE("Line No.","Line No.");
        DimMgt.CopyDocDimToJnlLineDim(TempDocDim,TempJnlLineDim);
        OriginalItemJnlLine := ItemJnlLine;
        }
        GenSetup.GET;
        TempJnlLineDim.INIT;
        TempJnlLineDim."Table ID":=83;
        TempJnlLineDim."Journal Template Name":='MR';
        TempJnlLineDim."Journal Batch Name":='MR';
        TempJnlLineDim."Journal Line No.":=ItemJnl."Line No.";
        TempJnlLineDim."Dimension Code" :=GenSetup."Global Dimension 1 Code";
        TempJnlLineDim."Dimension Value Code":= ItemJnl."Shortcut Dimension 1 Code";
        TempJnlLineDim.INSERT;

        TempJnlLineDim.INIT;
        TempJnlLineDim."Table ID":=83;
        TempJnlLineDim."Journal Template Name":='MR';
        TempJnlLineDim."Journal Batch Name":='MR';
        TempJnlLineDim."Journal Line No.":=ItemJnl."Line No.";
        TempJnlLineDim."Dimension Code" :=GenSetup."Global Dimension 2 Code";
        TempJnlLineDim."Dimension Value Code":= ItemJnl."Shortcut Dimension 2 Code";
        TempJnlLineDim.INSERT;

        TempJnlLineDim.INIT;
        TempJnlLineDim."Table ID":=83;
        TempJnlLineDim."Journal Template Name":='MR';
        TempJnlLineDim."Journal Batch Name":='MR';
        TempJnlLineDim."Journal Line No.":=ItemJnl."Line No.";
        TempJnlLineDim."Dimension Code" :=GenSetup."Shortcut Dimension 4 Code";
        TempJnlLineDim."Dimension Value Code":= "Shortcut Dimension 4 Code";
        IF "Shortcut Dimension 4 Code"<>'' THEN
          TempJnlLineDim.INSERT;

        TempJnlLineDim.INIT;
        TempJnlLineDim."Table ID":=83;
        TempJnlLineDim."Journal Template Name":='MR';
        TempJnlLineDim."Journal Batch Name":='MR';
        TempJnlLineDim."Journal Line No.":=ItemJnl."Line No.";
        TempJnlLineDim."Dimension Code" :=GenSetup."Shortcut Dimension 8 Code";
        TempJnlLineDim."Dimension Value Code":= recGatePassLines."Shortcut Dimension 8 Code";
        IF GatePassLines."Shortcut Dimension 8 Code"<>'' THEN
          TempJnlLineDim.INSERT;
        */
        // ALLE MM Code Commented
        //AlleDK 020909
        //    ItemJnlPostLine.RunWithCheck(ItemJnl,TempJnlLineDim);
        //    ItemJnl.DELETE(TRUE);

        ItemJnlPostLine.RunWithCheck(ItemJnl);
        IF recGatePassLines."Bin Code" <> '' THEN BEGIN
            IF WMSMgmt.CreateWhseJnlLine(ItemJnl, 0, WhseJnlLine, FALSE) THEN BEGIN
                WMSMgmt.CheckWhseJnlLine(WhseJnlLine, 1, 0, FALSE);
                WhseJnlPostLine.RUN(WhseJnlLine);
            END;
        END;
        ItemJnl.DELETE;
        //AlleDK 020909

    end;


    procedure InsertJobJournal()
    begin
        JobJournal.RESET;
        JobJournal.SETRANGE("Journal Template Name", 'MR');
        JobJournal.SETRANGE("Journal Batch Name", 'MR');
        IF JobJournal.FIND('+') THEN
            endLineNo := JobJournal."Line No." + 10000
        ELSE
            endLineNo := 10000;

        JobJnl.VALIDATE("Journal Template Name", 'MR');
        JobJnl.VALIDATE("Journal Batch Name", 'MR');
        JobJnl.VALIDATE("Document No.", Rec."Document No.");
        JobJnl.VALIDATE("Line No.", endLineNo);

        JobJnl.VALIDATE("Vendor No.", Rec."Vendor No.");
        JobJnl.VALIDATE("PO No.", Rec."Purchase Order No.");
        JobJnl.VALIDATE("Issue Type", Rec."Issue Type");
        JobJnl."Reference No." := Rec."Reference No.";
        JobJnl.Narration := recGatePassLines2.Description + ' Qty:' + FORMAT(recGatePassLines2.Qty);

        JobJnl.VALIDATE("Job No.", Rec."Job No.");
        JobJnl.VALIDATE("Job Task No.", recGatePassLines2."Job Task No.");//dds-upgrade 2009
        JobJnl.VALIDATE(Type, JobJnl.Type::Item);
        JobJnl.VALIDATE(JobJnl."No.", recGatePassLines2."Item No.");
        //AlleDK 260809
        JobJnl.VALIDATE("Location Code", Rec."Location Code");
        JobJnl.VALIDATE("Bin Code", recGatePassLines2."Bin Code");
        //AlleDK 260809
        JobJnl.INSERT(TRUE);
        JobJnl.VALIDATE("Posting Date", Rec."Posting Date");
        //JobJnl.VALIDATE("Entry Type",JobJnl."Entry Type"::);
        //JobJnl.VALIDATE("Location Code","Location Code");
        JobJnl.VALIDATE(Quantity, -recGatePassLines2.Qty);

        JobJnl."Fixed Asset No" := recGatePassLines2."Fixed Asset No";
        IF recGatePassLines2."Gen. Bus. Posting Group" <> '' THEN
            JobJnl.VALIDATE("Gen. Bus. Posting Group", recGatePassLines2."Gen. Bus. Posting Group");
        IF recGatePassLines2."Gen. Prod. Posting Group" <> '' THEN
            JobJnl.VALIDATE("Gen. Prod. Posting Group", recGatePassLines2."Gen. Prod. Posting Group");
        JobJnl.VALIDATE("Shortcut Dimension 1 Code", recGatePassLines2."Shortcut Dimension 1 Code");
        JobJnl.VALIDATE("Shortcut Dimension 2 Code", recGatePassLines2."Shortcut Dimension 2 Code");
        IF recGatePassLines2."Applies-to Entry" <> 0 THEN
            JobJnl.VALIDATE("Applies-to Entry", recGatePassLines2."Applies-to Entry");
        //alle PS added code for Passing Applies
        IF recGatePassLines2."Applies-from Entry" <> 0 THEN
            JobJnl.VALIDATE(JobJnl."Applies-from Entry", recGatePassLines."Applies-from Entry");
        JobJnl.MODIFY(TRUE);
        recGatePassLines2.MODIFY();
        // ALLE MM Code Commented
        /*
        TempJnlLineDim.DELETEALL;
        GenSetup.GET;
        TempJnlLineDim.INIT;
        TempJnlLineDim."Table ID":=210;
        TempJnlLineDim."Journal Template Name":='MR';
        TempJnlLineDim."Journal Batch Name":='MR';
        TempJnlLineDim."Journal Line No.":=JobJnl."Line No.";
        TempJnlLineDim."Dimension Code" :=GenSetup."Global Dimension 1 Code";
        TempJnlLineDim."Dimension Value Code":= JobJnl."Shortcut Dimension 1 Code";
        TempJnlLineDim.INSERT;

        TempJnlLineDim.INIT;
        TempJnlLineDim."Table ID":=210;
        TempJnlLineDim."Journal Template Name":='MR';
        TempJnlLineDim."Journal Batch Name":='MR';
        TempJnlLineDim."Journal Line No.":=JobJnl."Line No.";
        TempJnlLineDim."Dimension Code" :=GenSetup."Global Dimension 2 Code";
        TempJnlLineDim."Dimension Value Code":= JobJnl."Shortcut Dimension 2 Code";
        TempJnlLineDim.INSERT;

        TempJnlLineDim.INIT;
        TempJnlLineDim."Table ID":=210;
        TempJnlLineDim."Journal Template Name":='MR';
        TempJnlLineDim."Journal Batch Name":='MR';
        TempJnlLineDim."Journal Line No.":=JobJnl."Line No.";
        TempJnlLineDim."Dimension Code" :=GenSetup."Shortcut Dimension 8 Code";
        TempJnlLineDim."Dimension Value Code":= recGatePassLines2."Shortcut Dimension 8 Code";
        IF GatePassLines."Shortcut Dimension 8 Code"<>'' THEN
          TempJnlLineDim.INSERT;
        */
        // ALLE MM Code Commented
        //AlleDK 020909
        //    JobJnlPostLine.RunWithCheck(JobJnl,TempJnlLineDim);
        //  JobJnl.DELETE;
        IF NOT CompanyInfo."Job Madetory On MRN" THEN
            JobJnlPostLine1."Don'tPostILE"(TRUE)
        ELSE
            JobJnlPostLine1."Don'tPostILE"(FALSE);
        JobJnlPostLine.RunWithCheck(JobJnl);
        JobJnl.DELETE;
        //AlleDK 020909

        //CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post",JobJnl);

    end;


    procedure postJobJnl()
    var
        LineNo: Integer;
        AccNo: Code[20];
    begin
        GetLines;
        recGatePassLines2.RESET;
        recGatePassLines2.SETRANGE("Document Type", recGatePassLines2."Document Type"::"Material Return");
        recGatePassLines2.SETRANGE("Document No.", Rec."Document No.");
        recGatePassLines2.SETRANGE("Journal Line Created", FALSE);
        //recGatePassLines2.SETRANGE(recGatePassLines2.Chargeable,TRUE);//Pawan
        IF recGatePassLines2.FIND('-') THEN
            REPEAT
                InsertJobJournal()
UNTIL recGatePassLines2.NEXT = 0;
    end;


    procedure InsertGlLInes()
    var
        LineNo: Integer;
        AccNo: Code[20];
    begin
        GenTemplateCode := 'General';
        GenBatchCode := 'DEFAULT';

        GenJnlTemplate.GET(GenTemplateCode);
        GenJnlBatch.GET(GenTemplateCode, GenBatchCode);

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", GenTemplateCode);
        GenJnlLine.SETRANGE("Journal Batch Name", GenBatchCode);

        IF GenJnlLine.FIND('+') THEN
            vLineNo := GenJnlLine."Line No.";

        Tamt := 0;
        REPEAT
            Amount := 0;
            AccNo := recGatePassLines."Account No.";
            recGatePassLines.SETRANGE("Account No.", AccNo);
            GPassLine.RESET;
            GPassLine.SETRANGE("Document Type", recGatePassLines."Document Type");
            GPassLine.SETRANGE("Document No.", recGatePassLines."Document No.");
            GPassLine.SETRANGE("Account No.", recGatePassLines."Account No.");
            GPassLine.SETRANGE(GPassLine.Chargeable, TRUE);//AllE-PKS15
            IF GPassLine.FIND('-') THEN
                REPEAT
                    Amount := Amount + (GPassLine.Qty * GPassLine."Unit Cost");
                    Tamt := Tamt + (GPassLine.Qty * GPassLine."Unit Cost");
                //recGatePassLines."Debit Note Created" := TRUE;
                //MESSAGE('%1',GPassLine."Unit Cost");
                //recGatePassLines.MODIFY;
                UNTIL GPassLine.NEXT = 0;

            IF (Amount > 0) THEN BEGIN

                GenJnlLine.INIT;
                vLineNo := vLineNo + 10000;
                GenJnlLine."Journal Template Name" := GenTemplateCode;
                GenJnlLine."Journal Batch Name" := GenBatchCode;
                GenJnlLine."Line No." := vLineNo;
                GenJnlLine."Posting Date" := Rec."Posting Date";
                GenJnlLine."Document No." := Rec."Document No.";
                GenJnlLine.INSERT;
                GenJnlLine."Document Date" := Rec."Document Date";
                // GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
                GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
                GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                //dds
                GenJnlLine."System-Created Entry" := TRUE;
                //dds
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.VALIDATE("Account No.", recGatePassLines."Account No.");
                GenJnlLine.VALIDATE(Amount, +Amount);
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code", recGatePassLines."Shortcut Dimension 2 Code");
                GenJnlLine."Gen. Bus. Posting Group" := '';
                GenJnlLine."Gen. Prod. Posting Group" := '';
                GenJnlLine.MODIFY;
                // ALLE MM Code Commented
                /*
                TempJnlLineDim.DELETEALL;

                GenSetup.GET;
                TempJnlLineDim.INIT;
                TempJnlLineDim."Table ID":=81;
                TempJnlLineDim."Journal Template Name":=GenTemplateCode;
                TempJnlLineDim."Journal Batch Name":=GenBatchCode;
                TempJnlLineDim."Journal Line No.":=GenJnlLine."Line No.";
                TempJnlLineDim."Dimension Code" :=GenSetup."Global Dimension 1 Code";
                TempJnlLineDim."Dimension Value Code":= GenJnlLine."Shortcut Dimension 1 Code";
                TempJnlLineDim.INSERT;

                TempJnlLineDim.INIT;
                TempJnlLineDim."Table ID":=81;
                TempJnlLineDim."Journal Template Name":=GenTemplateCode;
                TempJnlLineDim."Journal Batch Name":=GenBatchCode;
                TempJnlLineDim."Journal Line No.":=GenJnlLine."Line No.";
                TempJnlLineDim."Dimension Code" :=GenSetup."Global Dimension 2 Code";
                TempJnlLineDim."Dimension Value Code":= GenJnlLine."Shortcut Dimension 2 Code";
                TempJnlLineDim.INSERT;

                TempJnlLineDim.INIT;
                TempJnlLineDim."Table ID":=81;
                TempJnlLineDim."Journal Template Name":=GenTemplateCode;
                TempJnlLineDim."Journal Batch Name":=GenBatchCode;
                TempJnlLineDim."Journal Line No.":=GenJnlLine."Line No.";
                TempJnlLineDim."Dimension Code" :=GenSetup."Shortcut Dimension 8 Code";
                TempJnlLineDim."Dimension Value Code":= recGatePassLines."Shortcut Dimension 8 Code";
                IF GatePassLines."Shortcut Dimension 8 Code"<>'' THEN
                  TempJnlLineDim.INSERT;
                  */
                // ALLE MM Code Commented
                GEnJnlPostLine.RunWithCheck(GenJnlLine);
                GenJnlLine.DELETE;//(TRUE);
            END;
            //MESSAGE('%1',Amount);
            recGatePassLines.FIND('+');
            recGatePassLines.SETRANGE("Account No.");
        UNTIL recGatePassLines.NEXT = 0;

        IF Tamt > 0 THEN BEGIN
            GenJnlLine.INIT;
            vLineNo := vLineNo + 10000;
            GenJnlLine."Journal Template Name" := GenTemplateCode;
            GenJnlLine."Journal Batch Name" := GenBatchCode;
            GenJnlLine."Line No." := vLineNo;
            GenJnlLine."Posting Date" := Rec."Posting Date";
            GenJnlLine."Document No." := Rec."Document No.";
            GenJnlLine."Posting Type" := GenJnlLine."Posting Type"::Running;
            GenJnlLine."External Document No." := Rec."Document No.";
            GenJnlLine.INSERT;
            GenJnlLine."Document Date" := Rec."Document Date";
            // GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
            GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
            GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
            GenJnlLine.VALIDATE("Account No.", Rec."Vendor No.");
            GenJnlLine.VALIDATE(Amount, -Tamt);
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code", recGatePassLines."Shortcut Dimension 2 Code");
            GenJnlLine."Gen. Bus. Posting Group" := '';
            GenJnlLine."Gen. Prod. Posting Group" := '';
            GenJnlLine.MODIFY;
            // ALLE MM Code Commented
            /*
            TempJnlLineDim.DELETEALL;
              GenSetup.GET;
              TempJnlLineDim.INIT;
              TempJnlLineDim."Table ID":=81;
              TempJnlLineDim."Journal Template Name":=GenTemplateCode;
              TempJnlLineDim."Journal Batch Name":=GenBatchCode;
              TempJnlLineDim."Journal Line No.":=GenJnlLine."Line No.";
              TempJnlLineDim."Dimension Code" :=GenSetup."Global Dimension 1 Code";
              TempJnlLineDim."Dimension Value Code":= GenJnlLine."Shortcut Dimension 1 Code";
              TempJnlLineDim.INSERT;

              TempJnlLineDim.INIT;
              TempJnlLineDim."Table ID":=81;
              TempJnlLineDim."Journal Template Name":=GenTemplateCode;
              TempJnlLineDim."Journal Batch Name":=GenBatchCode;
              TempJnlLineDim."Journal Line No.":=GenJnlLine."Line No.";
              TempJnlLineDim."Dimension Code" :=GenSetup."Global Dimension 2 Code";
              TempJnlLineDim."Dimension Value Code":= GenJnlLine."Shortcut Dimension 2 Code";
              TempJnlLineDim.INSERT;
             */
            // ALLE MM Code Commented
            GEnJnlPostLine.RunWithCheck(GenJnlLine);
            GenJnlLine.DELETE(TRUE);
            //MESSAGE('%1',Tamt);
        END;

    end;
}

