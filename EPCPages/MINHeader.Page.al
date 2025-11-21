page 97740 "MIN Header"
{
    // //MIN-SENT-FOR-VERIFY
    // //may 1.1 for checking necessary fields at the time of Verification of MIN
    // //May - Fields not to be modified at the time of verification should be dissabled
    // //May-Posting date is replaced with the current date at the time of verification
    // GKG01 : Remarks carried forward as Narration while posting
    // //NDALLE181207 Code added for Job ledger
    // //alle-pks10 to flow the value of returned by
    // //ALLE-PKS15 copied & then modified funtion for the credit note functionality
    // //ALLE-PKS16 confirm box
    // //ALLEAB011 for testfield in MIN
    // //ALLE-PKS 34 for the names of dimention
    // 
    // //DOC NO - onassitedit - below code removed as end user was able to delete MIN no series
    // //PurAndPay.GET;
    // //PurAndPay.TESTFIELD("Material Issue Note");
    // //IF NoSeriesMgt.SelectSeries(PurAndPay."Material Issue Note","MIN No. Series","MIN No. Series") THEN BEGIN
    // //  PurAndPay.GET;
    // //  PurAndPay.TESTFIELD("Material Issue Note");
    // //  NoSeriesMgt.SetSeries("Document No.");
    // //  CurrPAGE.UPDATE;
    // //END;
    // //RAHEE1.00 Check Location code in case of Work Order No. not blank.
    // ALLEPG RAHEE1.00 240212 : Added tracking line.
    // ALLEPG RAHEE1.00 020312 : Added Create journal line & delete journal line functionality

    Caption = 'Consumption Note';
    PageType = Card;
    SourceTable = "Gate Pass Header";
    SourceTableView = SORTING("Document Type", "Document No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER(MIN),
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
                    Editable = "Posting DateEditable";
                }
                field("New Project Code"; Rec."New Project Code")
                {

                    trigger OnValidate()
                    begin

                        Rec."Responsibility Center" := Rec."New Project Code";
                        Rec."Job No." := Rec."New Project Code";
                        Rec."Location Code" := Rec."New Project Code";
                        Rec.VALIDATE("Shortcut Dimension 1 Code", Rec."New Project Code");
                    end;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                }
                field(Respname; Respname)
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        //RAHEE1.00
                        IF Loc.GET(Rec."Location Code") THEN
                            Locname := Loc.Name;
                        //RAHEE1.00
                    end;
                }
                field(Locname; Locname)
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = ShortcutDimension1CodeEditable;
                }
                field(Remarks; Rec.Remarks)
                {
                    MultiLine = true;
                }
                field(Short1name; Short1name)
                {
                    Editable = false;
                }
                field("Issue Type"; Rec."Issue Type")
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
                }
                field("Issued By Name"; Rec."Issued By Name")
                {
                    Editable = false;
                }
                field("Received By"; Rec."Received By")
                {
                }
                field("Received By Name"; Rec."Received By Name")
                {
                    Editable = false;
                }
                field("Receiver Name"; Rec."Receiver Name")
                {
                }
                field(Status; Rec.Status)
                {

                    trigger OnValidate()
                    begin
                        StatusOnAfterValidate;
                    end;
                }
                field("Total Value"; Rec."Total Value")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Reference No."; Rec."Reference No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
            }
            part("MIN Lines"; "MIN Lines")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No.");
                SubPageView = SORTING("Document Type", "Document No.", "Line No.")
                              ORDER(Ascending);
            }
            group("Payment Conditions")
            {
                Caption = 'Payment Conditions';
                group("WO Mat. Issue Condition")
                {
                    Caption = 'WO Mat. Issue Condition';
                    field(material; material)
                    {
                        Caption = 'Material';
                        Editable = false;
                    }
                    field(consumable; consumable)
                    {
                        Caption = 'Consumable';
                        Editable = false;
                    }
                    field(tools; tools)
                    {
                        Caption = 'Tools tackles';
                        Editable = false;
                    }
                }
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
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                action("Item &Tracking Lines")
                {
                    Caption = 'Item &Tracking Lines';
                    Image = ItemTrackingLines;
                    ShortCutKey = 'Shift+Ctrl+I';

                    trigger OnAction()
                    begin
                        CurrPage."MIN Lines".PAGE.OpenFreeTrackingLines;   // RAHEE1.00 240212
                    end;
                }
            }
            group("&MIN")
            {
                Caption = '&MIN';

                action("&Sent For Verification")
                {
                    Caption = 'Sent For Verification';

                    trigger OnAction()
                    begin
                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');

                        //RAHEE1.00
                        IF Rec."Purchase Order No." <> '' THEN BEGIN
                            RespCenter.RESET;
                            IF RespCenter.GET(Rec."Shortcut Dimension 1 Code") THEN BEGIN
                                IF Rec."Location Code" <> RespCenter."Subcon/Site Location" THEN
                                    ERROR('Select Correct Location Code');
                            END;
                            GatePassLine.RESET;
                            GatePassLines.SETRANGE("Document Type", Rec."Document Type");
                            GatePassLines.SETRANGE("Document No.", Rec."Document No.");
                            IF GatePassLines.FINDSET THEN
                                REPEAT
                                    GatePassLines.TESTFIELD(GatePassLines."PO Line No.");
                                UNTIL GatePassLines.NEXT = 0;
                        END;
                        //RAHEE1.00



                        Rec.TESTFIELD("Sent for Verification", FALSE);
                        Rec.TESTFIELD(Remarks);
                        //ALLEAB011
                        GatePassLines.RESET;
                        GatePassLines.SETRANGE("Document Type", Rec."Document Type");
                        GatePassLines.SETRANGE("Document No.", Rec."Document No.");
                        IF GatePassLines.FIND('-') THEN
                            REPEAT
                                GatePassLines.TESTFIELD(GatePassLines."Required Qty");
                                GatePassLines.TESTFIELD(Qty);
                                // ALLEAA
                                //AlleDK 020909
                                CompanyInfo.GET;
                                IF CompanyInfo."Job Madetory On MRN" THEN BEGIN
                                    GatePassLines.TESTFIELD("Job No.");
                                    GatePassLines.TESTFIELD("Job Task No.");
                                END;
                                //AlleDK 020909
                                inventorySetup.GET;
                                IF inventorySetup."Work Center Mandatory in MIN" THEN
                                    GatePassLines.TESTFIELD("Shortcut Dimension 8 Code");
                                IF Loc.GET(GatePassLines."Location Code") THEN
                                    IF Loc."Bin Mandatory" THEN
                                        GatePassLines.TESTFIELD("Bin Code");
                            // ALLEAA
                            UNTIL GatePassLines.NEXT = 0
                        ELSE
                            ERROR('Cannot send Blank MIN!');
                        //ALLEAB011

                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'MIN-SENT-FOR-VERIFY');
                        IF NOT MemberOf.FIND('-') THEN
                            ERROR('UnAuthorised User for sending for Verification');
                        //ALLE-PKS16
                        sendverify := CONFIRM(Text007, TRUE, 'MIN', Rec."Document No.");
                        IF NOT sendverify THEN EXIT;
                        //ALLE-PKS16
                        Rec."Sent for Verification" := TRUE;
                        Rec."Sent for Verification Date" := TODAY;
                        Rec."Sent For Verification Time" := TIME;
                        Rec."Sent for Verification By" := USERID;
                        Rec.MODIFY;
                    end;
                }
                action("Return MIN")
                {
                    Caption = 'Return MIN';

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
                        Returnmin := CONFIRM(Text009, TRUE, 'MIN', Rec."Document No.");
                        IF NOT Returnmin THEN EXIT;
                        //ALLE-PKS16
                        Rec."Sent for Verification" := FALSE;
                        Rec."Sent for Verification Date" := 0D;
                        Rec."Sent For Verification Time" := 0T;
                        Rec."Sent for Verification By" := '';
                        Rec.Returned := TRUE;
                        Rec."Returned Date" := TODAY;
                        Rec."Returned Time" := TIME;
                        Rec."Returned By" := USERID;
                        Rec.MODIFY;
                    end;
                }
                action("Verify MIN")
                {
                    Caption = 'Verify MIN';

                    trigger OnAction()
                    begin
                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');


                        Rec.TESTFIELD("Sent for Verification", TRUE);
                        Rec.TESTFIELD(Verified, FALSE);
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'MIN-VERIFY');
                        IF NOT MemberOf.FIND('-') THEN
                            ERROR('UnAuthorised User for Verifying MIN');

                        //may 1.1 START

                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        //TESTFIELD("Shortcut Dimension 2 Code");
                        //TESTFIELD("Gen. Business Posting Group");
                        //ALLE-PKS16
                        Verify := CONFIRM(Text008, TRUE, 'MIN', Rec."Document No.");
                        IF NOT Verify THEN EXIT;
                        //ALLE-PKS16
                        Rec.Verified := TRUE;
                        Rec."Verified Date" := TODAY;
                        Rec."Posting Date" := TODAY;
                        Rec."Verified Time" := TIME;
                        Rec."Verified By" := USERID;//alle-pks10
                        Rec.MODIFY;

                        //may 1.1 END
                    end;
                }
                action("Return Verified MIN")
                {
                    Caption = 'Return Verified MIN';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Verified, TRUE);
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'MIN-SUPER');
                        IF NOT MemberOf.FIND('-') THEN
                            ERROR('UnAuthorised User for Removing Verified MIN');
                        //ALLE-PKS16
                        Returnvermin := CONFIRM(Text010, TRUE, 'MIN', Rec."Document No.");
                        IF NOT Returnvermin THEN EXIT;
                        //ALLE-PKS16
                        Rec.Verified := FALSE;
                        Rec."Verified Date" := 0D;
                        Rec."Verified Time" := 0T;
                        Rec."Verified By" := '';
                        Rec.MODIFY;
                    end;
                }
                action("Create Journal Lines")
                {
                    Caption = 'Create Journal Lines';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Verified, TRUE);
                        IF CONFIRM(Text50000, TRUE, 'Create', '', Rec."Document No.") THEN
                            recGatePassLines.RESET;
                        recGatePassLines.SETRANGE(recGatePassLines."Document Type", recGatePassLines."Document Type"::MIN);
                        recGatePassLines.SETRANGE(recGatePassLines."Document No.", Rec."Document No.");
                        recGatePassLines.SETRANGE(recGatePassLines."Journal Line Created", FALSE);
                        IF recGatePassLines.FIND('-') THEN BEGIN
                            REPEAT
                                CreateJounalLines;
                            UNTIL recGatePassLines.NEXT = 0;
                        END
                        ELSE
                            ERROR('Journals Lines already created');
                    end;
                }
                action("Delete Journal Lines")
                {
                    Caption = 'Delete Journal Lines';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Verified, FALSE);
                        IF CONFIRM(Text50000, FALSE, 'delete', '', Rec."Document No.") THEN
                            Rec.DeleteJournalLine;
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
                    var
                        Tqty: Decimal;
                    begin
                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        Rec.TESTFIELD(Verified, TRUE);
                        Rec.TESTFIELD("Sent for Verification", TRUE);
                        recGatePassLines.RESET;
                        recGatePassLines.SETRANGE(recGatePassLines."Document Type", recGatePassLines."Document Type"::MIN);
                        recGatePassLines.SETRANGE(recGatePassLines."Document No.", Rec."Document No.");
                        IF recGatePassLines.FIND('-') THEN
                            REPEAT
                                IF recGatePassLines."Gen. Bus. Posting Group" = '' THEN
                                    recGatePassLines."Gen. Bus. Posting Group" := 'DOMESTIC';
                                IF recGatePassLines."Shortcut Dimension 2 Code" = '' THEN BEGIN
                                    DefDimRec.RESET;
                                    DefDimRec.GET(27, recGatePassLines."Item No.", 'COSTHEAD');
                                    recGatePassLines."Shortcut Dimension 2 Code" := DefDimRec."Dimension Value Code";
                                END;
                                recGatePassLines.MODIFY;
                            UNTIL recGatePassLines.NEXT = 0;

                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User Name", USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID", 'MIN-POST');
                        IF NOT MemberOf.FIND('-') THEN
                            ERROR('UnAuthorised User for Posting MIN.');

                        CLEAR(ItemJnlPostLine);

                        GatePassHdr.RESET;
                        GatePassHdr.SETRANGE(GatePassHdr."Document No.", Rec."Document No.");
                        GatePassHdr.FIND('-');


                        IF CONFIRM(txtConfirm, TRUE) THEN BEGIN

                            //mayank
                            //SC ->>
                            //POHeader.RESET;
                            IF POHeader.GET(POHeader."Document Type"::Order, Rec."Purchase Order No.") THEN BEGIN
                                IF (POHeader."Ending Date" <> 0D) THEN BEGIN
                                    IF ((POHeader."Ending Date" + 10) > WORKDATE) THEN BEGIN
                                        IF NOT CONFIRM('The end date of this order is already exceed. Do you want to post it', TRUE) THEN
                                            ERROR('');
                                    END;
                                END;
                            END;
                            //SC <<-

                            //SC ->>
                            recGatePassLines.RESET;
                            recGatePassLines.SETRANGE(recGatePassLines."Document Type", recGatePassLines."Document Type"::MIN);
                            recGatePassLines.SETRANGE(recGatePassLines."Document No.", Rec."Document No.");
                            recGatePassLines.SETRANGE(recGatePassLines."Journal Line Created", FALSE);
                            IF recGatePassLines.FIND('-') THEN BEGIN
                                REPEAT
                                    recGatePassLines.TESTFIELD("Location Code");
                                    recGatePassLines.TESTFIELD("Item No.");

                                    Tqty := 0;
                                    GPLines.RESET;
                                    GPLines.SETRANGE("Document Type", recGatePassLines."Document Type"::MIN);
                                    GPLines.SETRANGE("Document No.", Rec."Document No.");
                                    GPLines.SETRANGE("Journal Line Created", FALSE);
                                    GPLines.SETRANGE("Location Code", recGatePassLines."Location Code");
                                    GPLines.SETRANGE("Item No.", recGatePassLines."Item No.");
                                    IF GPLines.FIND('-') THEN
                                        REPEAT
                                            Tqty := Tqty + GPLines.Qty;
                                        UNTIL GPLines.NEXT = 0;

                                    Item.RESET;
                                    Item.SETRANGE("No.", recGatePassLines."Item No.");
                                    Item.SETRANGE("Location Filter", recGatePassLines."Location Code");
                                    IF Item.FIND('-') THEN BEGIN
                                        Item.CALCFIELDS(Inventory);
                                        IF (Item.Inventory < Tqty) THEN
                                            ERROR('Item=%1 is not in inventory', Item."No.");
                                    END;

                                    IF recGatePassLines."Gen. Bus. Posting Group" = '' THEN
                                        ERROR('Enter %1', recGatePassLines.FIELDCAPTION("Gen. Bus. Posting Group"));

                                    //check if issue against wo then gen bus should not be of department type
                                    IF Rec."Purchase Order No." <> '' THEN BEGIN
                                        GenBusGrp.GET(recGatePassLines."Gen. Bus. Posting Group");
                                        IF GenBusGrp."Issue Agst WO Not Allowed" THEN
                                            ERROR('Material cannot be issued Against Work Order No %1, if Gen Business Group is %2',
                                                    Rec."Purchase Order No.", recGatePassLines."Gen. Bus. Posting Group");
                                    END;

                                    recGatePassLines.TESTFIELD("Shortcut Dimension 1 Code");
                                    recGatePassLines.TESTFIELD("Shortcut Dimension 2 Code");


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

                            IF Rec."Issue Type" = Rec."Issue Type"::Chargeable THEN BEGIN
                                Tamt := 0;
                                recGatePassLines.RESET;
                                recGatePassLines.SETCURRENTKEY("Account No.");
                                recGatePassLines.SETRANGE(recGatePassLines."Document Type", recGatePassLines."Document Type"::MIN);
                                recGatePassLines.SETRANGE(recGatePassLines."Document No.", Rec."Document No.");
                                recGatePassLines.SETRANGE(recGatePassLines."Debit Note Created", FALSE);

                                IF recGatePassLines.FIND('-') THEN
                                    InsertGlLInes;
                                IF recGatePassLines.FIND('-') THEN
                                    recGatePassLines.MODIFYALL("Debit Note Created", TRUE);
                            END;

                            Rec.VALIDATE(Status, Rec.Status::Close);
                            Rec.MODIFY;
                        END;
                        MESSAGE('Document Successfuly Posted')

                    end;
                }
                action("Print MIN")
                {
                    Caption = 'Print MIN';
                    Visible = false;

                    trigger OnAction()
                    begin
                        GatePassHdr.RESET;
                        GatePassHdr.SETRANGE(GatePassHdr."Document Type", Rec."Document Type");
                        GatePassHdr.SETRANGE(GatePassHdr."Document No.", Rec."Document No.");
                        IF GatePassHdr.FIND('-') THEN //BEGIN
                                                      //GatePassHdr."Document No." := "Document No.";
                            REPORT.RUN(97762, TRUE, FALSE, GatePassHdr);
                        //END;
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
                    Rec."Posting Date" := WORKDATE;
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
            //Locname := RecRespCenter."Location Name";
            IF Loc.GET(Rec."Location Code") THEN;
            Locname := Loc.Name;

            IF RecJob.GET(RecRespCenter."Job Code") THEN
                JobName := RecJob.Description;
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
            //GKG01 <<
            CurrPage.EDITABLE:=FALSE;
            MemberOf.RESET;
            MemberOf.SETRANGE(MemberOf."User ID",USERID);
            MemberOf.SETRANGE(MemberOf."Role ID",'MIN-SUPER');
            IF MemberOf.FIND('-') THEN BEGIN
              CurrPage.EDITABLE:=TRUE;
              ShortcutDimension1CodeEditable :=TRUE;
            END;
        
            {
            MemberOf.RESET;
            MemberOf.SETRANGE(MemberOf."User ID",USERID);
            MemberOf.SETRANGE(MemberOf."Role ID",'MIN-SENT-FOR-VERIFY');
            IF MemberOf.FIND('-') THEN BEGIN
             // CurrPAGE.EDITABLE:=TRUE;
                CurrPAGE.EDITABLE:=FALSE;
              CurrPAGE."Shortcut Dimension 1 Code".EDITABLE:=FALSE;
            END
            ELSE BEGIN
              MemberOf.RESET;
              MemberOf.SETRANGE(MemberOf."User ID",USERID);
              MemberOf.SETRANGE(MemberOf."Role ID",'MIN-VERIFY');
              IF MemberOf.FIND('-') THEN BEGIN
                CurrPAGE.EDITABLE:=FALSE;
              END
              ELSE BEGIN
                CurrPAGE.EDITABLE:=TRUE;
                CurrPAGE."Shortcut Dimension 1 Code".EDITABLE:=FALSE;
              END;
            END;
            } //GKG01 >>
          END;
        END;
        */

        //may 1.1 starts
        CLEAR(material);
        CLEAR(consumable);
        CLEAR(tools);
        IF Rec."Purchase Order No." <> '' THEN BEGIN
            POHeader.RESET;
            POHeader.SETRANGE(POHeader."No.", Rec."Purchase Order No.");
            IF POHeader.FIND('-') THEN BEGIN
                material := POHeader.Material;
                consumable := POHeader.Consumables;
            END;
        END;

    end;

    trigger OnInit()
    begin
        "Posting DateEditable" := TRUE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Status := Rec.Status::Open;
        //ALLE-SR-051107 >>
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        //ALLE-SR-051107 <<
        //ALLEND 191107
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            //Locname := RecRespCenter."Location Name";
            IF Loc.GET(Rec."Location Code") THEN;
            Locname := Loc.Name;

        END;
    end;

    trigger OnOpenPage()
    begin
        //IF NonEditable THEN                                                                        /
        //  CurrPAGE.EDITABLE:=FALSE;
        /*
        MemberOf.RESET;
        MemberOf.SETRANGE(MemberOf."User ID",USERID);
        MemberOf.SETRANGE(MemberOf."Role ID",'MIN-VERIFY');
        IF MemberOf.FIND('-') THEN BEGIN
          CurrPAGE."Purchase Order No.".EDITABLE(FALSE);
          CurrPAGE."Shortcut Dimension 2 Code".EDITABLE(FALSE);
          CurrPAGE."Shortcut Dimension 1 Code".EDITABLE(TRUE);
          CurrPAGE."Shortcut Dimension 1 Code".ENABLED(TRUE);
          CurrPAGE."Document Date".EDITABLE(FALSE);
          CurrPAGE."Posting Date".EDITABLE(FALSE);
          CurrPAGE."Vendor No.".EDITABLE(FALSE);
          CurrPAGE."Vendor Name".EDITABLE(FALSE);
          CurrPAGE."Issue Type".EDITABLE(FALSE);
          CurrPAGE."Entered By".EDITABLE(FALSE);
          CurrPAGE."Issued By".EDITABLE(FALSE);
          CurrPAGE."Received By".EDITABLE(FALSE);
          CurrPAGE.Status.EDITABLE(FALSE);
          CurrPAGE."Location Code".EDITABLE(FALSE);
          CurrPAGE."Receiver Name".EDITABLE(FALSE);
          CurrPAGE.Remarks.EDITABLE(TRUE);
          CurrPAGE."Reference No.".EDITABLE(FALSE);
          CurrPAGE."Issued By Name".EDITABLE(FALSE);
          CurrPAGE."Received By Name".EDITABLE(FALSE);
        END;
        */

        IF Rec.Verified = TRUE THEN
            CurrPage.EDITABLE(FALSE);

        "Posting DateEditable" := TRUE;

        //ALLE-SR-051107 >>
        IF UserMgt.GetPurchasesFilter() <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetPurchasesFilter());
            Rec.FILTERGROUP(0);
        END;
        //ALLE-SR-051107 <<

        //ALLEND 191107
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            //    Locname := RecRespCenter."Location Name";
            //RAHEE1.00
            IF Loc.GET(Rec."Location Code") THEN
                Locname := Loc.Name;
            //RAHEE1.00
            IF RecJob.GET(RecRespCenter."Job Code") THEN
                JobName := RecJob.Description;
        END;

    end;

    var
        GatePassLines: Record "Gate Pass Line";
        JobJnl: Record "Job Journal Line";
        ItemJnl: Record "Item Journal Line";
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournal: Record "Item Journal Line";
        recGatePassLines: Record "Gate Pass Line";
        recEmployee: Record Employee;
        PurAndPay: Record "Purchases & Payables Setup";
        GenPostSetup: Record "General Posting Setup";
        GPassLine: Record "Gate Pass Line";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GatePassHdr: Record "Gate Pass Header";
        GenSetup: Record "General Ledger Setup";
        Item: Record Item;
        GenBusGrp: Record "Gen. Business Posting Group";
        POHeader: Record "Purchase Header";
        RecDimValue: Record "Dimension Value";
        RecLocation: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        RecUserSetup: Record "User Setup";
        DefDimRec: Record "Default Dimension";
        GPLines: Record "Gate Pass Line";
        RecJob: Record Job;
        RecJobJnlLine: Record "Job Journal Line";
        JobJournal: Record "Job Journal Line";
        recGatePassLines2: Record "Gate Pass Line";
        JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        JobJnlPostLine1: Codeunit MyCodeunit;
        NoSeries: Codeunit NoSeriesManagement;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        GEnJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        UserMgt: Codeunit "User Setup Management";
        Navigate: Page Navigate;
        PictureExists: Boolean;
        CodeUnitRun: Boolean;
        NonEditable: Boolean;
        sendverify: Boolean;
        Verify: Boolean;
        Returnmin: Boolean;
        Returnvermin: Boolean;
        DocNumber: Code[10];
        numSeries: Code[10];
        GenTemplateCode: Code[20];
        GenBatchCode: Code[20];
        costcenter: Code[20];
        vendno: Code[20];
        Short1name: Text[50];
        Respname: Text[50];
        Locname: Text[50];
        JobName: Text[50];
        endLineNo: Integer;
        txtConfirm: Label 'Are You sure about the details to be updated in Ledgers ?';
        Text001: Label 'Do you want to replace the existing picture of %1 %2?';
        Text002: Label 'Do you want to delete the picture of %1 %2?';
        vLineNo: Integer;
        Tamt: Decimal;
        Amount: Decimal;
        Tst: Date;
        material: Option " ",Free,Chargeable,Contractor;
        consumable: Option " ",Free,Chargeable,Contractor;
        tools: Option " ",Free,Chargeable,Contractor;
        Text007: Label 'Do you want to Send the %1 No.-%2 For Verification';
        Text008: Label 'Do you want to Verify %1 No.-%2 ';
        Text009: Label 'Do you want to Return %1 No.-%2 ';
        Text010: Label 'Do you want to Return Verified %1 No.-%2';
        inventorySetup: Record "Inventory Setup";
        WMSMgmt: Codeunit "WMS Management";
        WhseJnlLine: Record "Warehouse Journal Line";
        WhseJnlPostLine: Codeunit "Whse. Jnl.-Register Line";
        Loc: Record Location;
        CompanyInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center 1";
        Text50000: Label 'Do you want to %1 %2 journal line for the Min no. %3.';
        GatePassLine: Record "Gate Pass Line";

        ShortcutDimension1CodeEditable: Boolean;

        "Posting DateEditable": Boolean;
        MemberOf: Record "Access Control";


    procedure postItemJnl()
    var
        LineNo: Integer;
        AccNo: Code[20];
    begin
        GetLines;
        recGatePassLines.RESET;
        recGatePassLines.SETRANGE(recGatePassLines."Document Type", recGatePassLines."Document Type"::MIN);
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
        ItemJournal.SETRANGE("Journal Template Name", 'MIN');
        ItemJournal.SETRANGE("Journal Batch Name", 'MIN');
        IF ItemJournal.FIND('+') THEN
            endLineNo := ItemJournal."Line No." + 10000
        ELSE
            endLineNo := 10000;

        ItemJnl.VALIDATE("Journal Template Name", 'MIN');
        ItemJnl.VALIDATE("Journal Batch Name", 'MIN');
        ItemJnl.VALIDATE("Document No.", Rec."Document No.");
        ItemJnl.VALIDATE("Line No.", endLineNo);
        ItemJnl.VALIDATE("Vendor No.", Rec."Vendor No.");
        ItemJnl.VALIDATE("PO No.", Rec."Purchase Order No.");
        //dds
        ItemJnl.VALIDATE("Item Shpt. Entry No.", 0);
        //dds
        ItemJnl.INSERT(TRUE);
        ItemJnl.VALIDATE("Posting Date", Rec."Posting Date");
        ItemJnl.VALIDATE("Entry Type", ItemJnl."Entry Type"::"Negative Adjmt.");
        ItemJnl.VALIDATE("Item No.", recGatePassLines."Item No.");
        ItemJnl.VALIDATE("Location Code", recGatePassLines."Location Code");
        //ItemJnl.VALIDATE("Unit Cost",    recGatePassLines."Unit Cost");
        ItemJnl.VALIDATE(Quantity, recGatePassLines.Qty);
        IF recGatePassLines."Gen. Bus. Posting Group" <> '' THEN
            ItemJnl.VALIDATE(ItemJnl."Gen. Bus. Posting Group", recGatePassLines."Gen. Bus. Posting Group");
        IF recGatePassLines."Gen. Prod. Posting Group" <> '' THEN
            ItemJnl.VALIDATE(ItemJnl."Gen. Prod. Posting Group", recGatePassLines."Gen. Prod. Posting Group");
        ItemJnl.VALIDATE(ItemJnl."Shortcut Dimension 1 Code", recGatePassLines."Shortcut Dimension 1 Code");
        ItemJnl.VALIDATE(ItemJnl."Shortcut Dimension 2 Code", recGatePassLines."Shortcut Dimension 2 Code");
        IF recGatePassLines."Applies-to Entry" <> 0 THEN
            ItemJnl.VALIDATE(ItemJnl."Applies-to Entry", recGatePassLines."Applies-to Entry");
        //SC -->>
        ItemJnl.VALIDATE(ItemJnl."Issue Type", Rec."Issue Type");
        //SC <<--
        ItemJnl."Reference No." := Rec."Reference No.";
        ItemJnl.VALIDATE("Bin Code", recGatePassLines."Bin Code"); //ALLEAA
        ItemJnl.Narration := recGatePassLines.Description + ' Qty:' + FORMAT(recGatePassLines.Qty); //GKG
        ItemJnl.MODIFY(TRUE);
        //recGatePassLines."Unit Cost":=ItemJnl."Unit Cost";//commented
        recGatePassLines.MODIFY();
        // ALLE MM Code Commented
        /*
         TempJnlLineDim.DELETEALL;
         GenSetup.GET;
         TempJnlLineDim.INIT;
         TempJnlLineDim."Table ID":=83;
         TempJnlLineDim."Journal Template Name":='MIN';
         TempJnlLineDim."Journal Batch Name":='MIN';
         TempJnlLineDim."Journal Line No.":=ItemJnl."Line No.";
         TempJnlLineDim."Dimension Code" :=GenSetup."Global Dimension 1 Code";
         TempJnlLineDim."Dimension Value Code":= ItemJnl."Shortcut Dimension 1 Code";
         TempJnlLineDim.INSERT;

         TempJnlLineDim.INIT;
         TempJnlLineDim."Table ID":=83;
         TempJnlLineDim."Journal Template Name":='MIN';
         TempJnlLineDim."Journal Batch Name":='MIN';
         TempJnlLineDim."Journal Line No.":=ItemJnl."Line No.";
         TempJnlLineDim."Dimension Code" :=GenSetup."Global Dimension 2 Code";
         TempJnlLineDim."Dimension Value Code":= ItemJnl."Shortcut Dimension 2 Code";
         TempJnlLineDim.INSERT;

         TempJnlLineDim.INIT;
         TempJnlLineDim."Table ID":=83;
         TempJnlLineDim."Journal Template Name":='MIN';
         TempJnlLineDim."Journal Batch Name":='MIN';
         TempJnlLineDim."Journal Line No.":=ItemJnl."Line No.";
         TempJnlLineDim."Dimension Code" :=GenSetup."Shortcut Dimension 4 Code";
         TempJnlLineDim."Dimension Value Code":= "Shortcut Dimension 4 Code";
         IF "Shortcut Dimension 4 Code"<>'' THEN
           TempJnlLineDim.INSERT;

         {TempJnlLineDim.INIT;
         TempJnlLineDim."Table ID":=83;
         TempJnlLineDim."Journal Template Name":='MIN';
         TempJnlLineDim."Journal Batch Name":='MIN';
         TempJnlLineDim."Journal Line No.":=ItemJnl."Line No.";
         TempJnlLineDim."Dimension Code" :=GenSetup."Shortcut Dimension 8 Code";
         TempJnlLineDim."Dimension Value Code":= recGatePassLines."Shortcut Dimension 8 Code";
         IF GatePassLines."Shortcut Dimension 8 Code"<>'' THEN
           TempJnlLineDim.INSERT;
          }
        */
        // ALLE MM Code Commented
        ItemJnlPostLine.RunWithCheck(ItemJnl);
        // ALLEAA
        IF recGatePassLines."Bin Code" <> '' THEN BEGIN  //AlleDK 020909
            IF WMSMgmt.CreateWhseJnlLine(ItemJnl, 0, WhseJnlLine, FALSE) THEN BEGIN
                WMSMgmt.CheckWhseJnlLine(WhseJnlLine, 1, 0, FALSE);
                WhseJnlPostLine.RUN(WhseJnlLine);
            END;
        END; //alleDK 020909
             // ALLEAA

        ItemJnl.DELETE;//(TRUE);

    end;


    procedure InsertGlLInes()
    var
        LineNo: Integer;
        AccNo: Code[20];
    begin
        //ALLE-PKS15
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
            IF GPassLine.FIND('-') THEN
                REPEAT

                    Amount := Amount + (GPassLine.Qty * GPassLine."Unit Cost");
                    Tamt := Tamt + (GPassLine.Qty * GPassLine."Unit Cost");
                //recGatePassLines."Debit Note Created" := TRUE;
                //recGatePassLines.MODIFY;
                UNTIL GPassLine.NEXT = 0;

            IF Amount > 0 THEN BEGIN
                GenJnlLine.INIT;
                vLineNo := vLineNo + 10000;
                GenJnlLine."Journal Template Name" := GenTemplateCode;
                GenJnlLine."Journal Batch Name" := GenBatchCode;
                GenJnlLine."Line No." := vLineNo;
                GenJnlLine."Posting Date" := Rec."Posting Date";
                GenJnlLine."Document No." := Rec."Document No.";
                GenJnlLine.INSERT;
                GenJnlLine."Document Date" := Rec."Document Date";
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
                GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
                GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                //dds
                GenJnlLine."System-Created Entry" := TRUE;
                //dds
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.VALIDATE("Account No.", recGatePassLines."Account No.");
                GenJnlLine.VALIDATE(Amount, -Amount);
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
                {
                TempJnlLineDim.INIT;
                TempJnlLineDim."Table ID":=81;
                TempJnlLineDim."Journal Template Name":=GenTemplateCode;
                TempJnlLineDim."Journal Batch Name":=GenBatchCode;
                TempJnlLineDim."Journal Line No.":=GenJnlLine."Line No.";
                TempJnlLineDim."Dimension Code" :=GenSetup."Shortcut Dimension 8 Code";
                TempJnlLineDim."Dimension Value Code":= recGatePassLines."Shortcut Dimension 8 Code";
                TempJnlLineDim.INSERT;

                 }

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
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
            GenJnlLine."Source Code" := GenJnlTemplate."Source Code";
            GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
            //dds
            GenJnlLine."System-Created Entry" := TRUE;
            //dds
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
            GenJnlLine.VALIDATE("Account No.", Rec."Vendor No.");
            GenJnlLine.VALIDATE(Amount, Tamt);
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
              {
              TempJnlLineDim.INIT;
              TempJnlLineDim."Table ID":=81;
              TempJnlLineDim."Journal Template Name":=GenTemplateCode;
              TempJnlLineDim."Journal Batch Name":=GenBatchCode;
              TempJnlLineDim."Journal Line No.":=GenJnlLine."Line No.";
              TempJnlLineDim."Dimension Code" :=GenSetup."Shortcut Dimension 8 Code";
              TempJnlLineDim."Dimension Value Code":= recGatePassLines."Shortcut Dimension 8 Code";
              IF GatePassLines."Shortcut Dimension 8 Code"<>'' THEN
                TempJnlLineDim.INSERT;
               }
          */
            // ALLE MM Code Commented
            GEnJnlPostLine.RunWithCheck(GenJnlLine);
            GenJnlLine.DELETE(TRUE);
            //MESSAGE('%1',Tamt);
        END;
        //ALLE-PKS15

    end;


    procedure SETTYPE(vNonEditable: Boolean)
    begin
        //NonEditable:=vNonEditable;
    end;


    procedure InsertJobJournal()
    begin
        JobJournal.RESET;
        JobJournal.SETRANGE("Journal Template Name", 'MIN');
        JobJournal.SETRANGE("Journal Batch Name", 'MIN');
        IF JobJournal.FIND('+') THEN
            endLineNo := JobJournal."Line No." + 10000
        ELSE
            endLineNo := 10000;

        JobJnl.VALIDATE("Journal Template Name", 'MIN');
        JobJnl.VALIDATE("Journal Batch Name", 'MIN');
        JobJnl.VALIDATE("Document No.", Rec."Document No.");
        JobJnl.VALIDATE("Line No.", endLineNo);

        JobJnl.VALIDATE("Vendor No.", Rec."Vendor No.");
        JobJnl.VALIDATE("PO No.", Rec."Purchase Order No.");

        JobJnl.VALIDATE("Job No.", Rec."Job No.");
        JobJnl.VALIDATE("Job Task No.", recGatePassLines2."Job Task No.");
        JobJnl.VALIDATE(Type, JobJnl.Type::Item);
        JobJnl.VALIDATE(JobJnl."No.", recGatePassLines2."Item No.");
        JobJnl.INSERT(TRUE);
        JobJnl.VALIDATE("Posting Date", Rec."Posting Date");
        JobJnl.VALIDATE("Issue Type", Rec."Issue Type");
        //JobJnl.VALIDATE("Entry Type",JobJnl."Entry Type"::);
        JobJnl.VALIDATE("Location Code", Rec."Location Code");
        IF recGatePassLines2."Bin Code" <> '' THEN
            JobJnl.VALIDATE("Bin Code", recGatePassLines2."Bin Code"); //ALLEAA
        JobJnl.VALIDATE(Quantity, recGatePassLines2.Qty);
        JobJnl."Fixed Asset No" := recGatePassLines2."Fixed Asset No";
        JobJnl."MIN Line No." := recGatePassLines2."Line No.";
        IF recGatePassLines2."Gen. Bus. Posting Group" <> '' THEN
            JobJnl.VALIDATE("Gen. Bus. Posting Group", recGatePassLines2."Gen. Bus. Posting Group");
        IF recGatePassLines2."Gen. Prod. Posting Group" <> '' THEN
            JobJnl.VALIDATE("Gen. Prod. Posting Group", recGatePassLines2."Gen. Prod. Posting Group");
        JobJnl.VALIDATE("Shortcut Dimension 1 Code", recGatePassLines2."Shortcut Dimension 1 Code");
        JobJnl.VALIDATE("Shortcut Dimension 2 Code", recGatePassLines2."Shortcut Dimension 2 Code");
        IF recGatePassLines2."Applies-to Entry" <> 0 THEN
            JobJnl.VALIDATE("Applies-to Entry", recGatePassLines2."Applies-to Entry");
        JobJnl."Reference No." := Rec."Reference No.";
        JobJnl.Narration := recGatePassLines2.Description + ' Qty:' + FORMAT(recGatePassLines2.Qty);

        JobJnl.MODIFY(TRUE);
        recGatePassLines2.MODIFY();
        // ALLE MM Code Commented
        /*
        TempJnlLineDim.DELETEALL;
        GenSetup.GET;
        TempJnlLineDim.INIT;
        TempJnlLineDim."Table ID":=210;
        TempJnlLineDim."Journal Template Name":='MIN';
        TempJnlLineDim."Journal Batch Name":='MIN';
        TempJnlLineDim."Journal Line No.":=JobJnl."Line No.";
        TempJnlLineDim."Dimension Code" :=GenSetup."Global Dimension 1 Code";
        TempJnlLineDim."Dimension Value Code":= JobJnl."Shortcut Dimension 1 Code";
        TempJnlLineDim.INSERT;

        TempJnlLineDim.INIT;
        TempJnlLineDim."Table ID":=210;
        TempJnlLineDim."Journal Template Name":='MIN';
        TempJnlLineDim."Journal Batch Name":='MIN';
        TempJnlLineDim."Journal Line No.":=JobJnl."Line No.";
        TempJnlLineDim."Dimension Code" :=GenSetup."Global Dimension 2 Code";
        TempJnlLineDim."Dimension Value Code":= JobJnl."Shortcut Dimension 2 Code";
        TempJnlLineDim.INSERT;

        TempJnlLineDim.INIT;
        TempJnlLineDim."Table ID":=210;
        TempJnlLineDim."Journal Template Name":='MIN';
        TempJnlLineDim."Journal Batch Name":='MIN';
        TempJnlLineDim."Journal Line No.":=JobJnl."Line No.";
        TempJnlLineDim."Dimension Code" :=GenSetup."Shortcut Dimension 8 Code";
        TempJnlLineDim."Dimension Value Code":= recGatePassLines2."Shortcut Dimension 8 Code";
        IF GatePassLines."Shortcut Dimension 8 Code"<>'' THEN
          TempJnlLineDim.INSERT;
        */
        // ALLE MM Code Commented
        // ALLEAA
        //    IF WMSMgmt.CreateWhseJnlLine(JobJnl,0,WhseJnlLine,FALSE,FALSE) THEN BEGIN
        //      WMSMgmt.CheckWhseJnlLine(WhseJnlLine,1,0,FALSE);
        //      WhseJnlPostLine.RUN(WhseJnlLine);
        //    END;
        // ALLEAA
        //{
        //AlleDK 020909
        IF NOT CompanyInfo."Job Madetory On MRN" THEN
            JobJnlPostLine1."Don'tPostILE"(TRUE)
        ELSE
            JobJnlPostLine1."Don'tPostILE"(FALSE);
        JobJnlPostLine.RunWithCheck(JobJnl);
        JobJnl.DELETE;
        //AlleDK 020909
        //}
        //CODEUNIT.RUN(CODEUNIT::"Job Jnl.-Post",JobJnl);

    end;


    procedure postJobJnl()
    var
        LineNo: Integer;
        AccNo: Code[20];
    begin
        GetLines;
        recGatePassLines2.RESET;
        recGatePassLines2.SETRANGE("Document Type", recGatePassLines2."Document Type"::MIN);
        recGatePassLines2.SETRANGE("Document No.", Rec."Document No.");
        recGatePassLines2.SETRANGE("Journal Line Created", FALSE);
        IF recGatePassLines2.FINDFIRST THEN
            REPEAT
                InsertJobJournal()
UNTIL recGatePassLines2.NEXT = 0;
    end;


    procedure CreateJounalLines()
    var
        Tqty: Decimal;
    begin
        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');
        Rec.TESTFIELD(Status, Rec.Status::Open);
        //TESTFIELD(Verified,TRUE);
        //TESTFIELD("Sent for Verification",TRUE);
        recGatePassLines.RESET;
        recGatePassLines.SETRANGE(recGatePassLines."Document Type", recGatePassLines."Document Type"::MIN);
        recGatePassLines.SETRANGE(recGatePassLines."Document No.", Rec."Document No.");
        IF recGatePassLines.FIND('-') THEN
            REPEAT
                //IF recGatePassLines."Gen. Bus. Posting Group"='' THEN
                //recGatePassLines."Gen. Bus. Posting Group":='DOMESTIC';
                IF recGatePassLines."Shortcut Dimension 2 Code" = '' THEN BEGIN
                    DefDimRec.RESET;
                    DefDimRec.GET(27, recGatePassLines."Item No.", 'COSTHead');
                    recGatePassLines."Shortcut Dimension 2 Code" := DefDimRec."Dimension Value Code";
                END;
                recGatePassLines.MODIFY;
            UNTIL recGatePassLines.NEXT = 0;

        MemberOf.RESET;
        MemberOf.SETRANGE(MemberOf."User Name", USERID);
        MemberOf.SETRANGE(MemberOf."Role ID", 'MIN-POST');
        IF NOT MemberOf.FIND('-') THEN
            ERROR('UnAuthorised User for Posting MIN.');

        CLEAR(ItemJnlPostLine);

        GatePassHdr.RESET;
        GatePassHdr.SETRANGE(GatePassHdr."Document No.", Rec."Document No.");
        GatePassHdr.FIND('-');



        //mayank
        //SC ->>
        //POHeader.RESET;
        IF POHeader.GET(POHeader."Document Type"::Order, Rec."Purchase Order No.") THEN BEGIN
            IF (POHeader."Ending Date" <> 0D) THEN BEGIN
                IF ((POHeader."Ending Date" + 10) > WORKDATE) THEN BEGIN
                    IF NOT CONFIRM('The end date of this order is already exceed. Do you want to create it', TRUE) THEN
                        ERROR('');
                END;
            END;
        END;
        //SC <<-

        //SC ->>
        recGatePassLines.RESET;
        recGatePassLines.SETRANGE(recGatePassLines."Document Type", recGatePassLines."Document Type"::MIN);
        recGatePassLines.SETRANGE(recGatePassLines."Document No.", Rec."Document No.");
        recGatePassLines.SETRANGE(recGatePassLines."Journal Line Created", FALSE);
        IF recGatePassLines.FIND('-') THEN BEGIN
            REPEAT
                recGatePassLines.TESTFIELD("Location Code");
                recGatePassLines.TESTFIELD("Item No.");

                Tqty := 0;
                GPLines.RESET;
                GPLines.SETRANGE("Document Type", recGatePassLines."Document Type"::MIN);
                GPLines.SETRANGE("Document No.", Rec."Document No.");
                GPLines.SETRANGE("Journal Line Created", FALSE);
                GPLines.SETRANGE("Location Code", recGatePassLines."Location Code");
                GPLines.SETRANGE("Item No.", recGatePassLines."Item No.");
                IF GPLines.FIND('-') THEN
                    REPEAT
                        Tqty := Tqty + GPLines.Qty;
                    UNTIL GPLines.NEXT = 0;

                Item.RESET;
                Item.SETRANGE("No.", recGatePassLines."Item No.");
                Item.SETRANGE("Location Filter", recGatePassLines."Location Code");
                IF Item.FIND('-') THEN BEGIN
                    Item.CALCFIELDS(Inventory);
                    IF (Item.Inventory < Tqty) THEN
                        ERROR('Item=%1 is not in inventory', Item."No.");
                END;

                // IF recGatePassLines."Gen. Bus. Posting Group" = '' THEN
                // ERROR('Enter %1', recGatePassLines.FIELDCAPTION("Gen. Bus. Posting Group"));

                //check if issue against wo then gen bus should not be of department type
                IF Rec."Purchase Order No." <> '' THEN BEGIN
                    IF GenBusGrp.GET(recGatePassLines."Gen. Bus. Posting Group") THEN
                        IF GenBusGrp."Issue Agst WO Not Allowed" THEN
                            ERROR('Material cannot be issued Against Work Order No %1, if Gen Business Group is %2',
                                    Rec."Purchase Order No.", recGatePassLines."Gen. Bus. Posting Group");
                END;

                recGatePassLines.TESTFIELD("Shortcut Dimension 1 Code");
                recGatePassLines.TESTFIELD("Shortcut Dimension 2 Code");


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

        /*  IF "Issue Type" = "Issue Type"::Chargeable THEN BEGIN
            Tamt:=0;
            recGatePassLines.RESET;
            recGatePassLines.SETCURRENTKEY("Account No.");
            recGatePassLines.SETRANGE(recGatePassLines."Document Type",recGatePassLines."Document Type"::MIN);
            recGatePassLines.SETRANGE(recGatePassLines."Document No.","Document No.");
            recGatePassLines.SETRANGE(recGatePassLines."Debit Note Created",FALSE);
        
            IF recGatePassLines.FIND('-') THEN
              InsertGlLInes;
            IF recGatePassLines.FIND('-') THEN
              recGatePassLines.MODIFYALL("Debit Note Created",TRUE);
          END;
         */
        //VALIDATE(Status, Status::Close);
        Rec.VALIDATE("Journal Lines Created", TRUE);
        Rec.MODIFY;
        // ALLEPG 020911 Start
        IF Rec."Journal Lines Created" THEN
            Rec.CreateServiceItem(Rec);
        // ALLEPG 020911 End
        MESSAGE('General lines Successfully Created')

    end;

    local procedure StatusOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

