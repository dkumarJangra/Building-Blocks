page 50238 "Gold/Silver Voucher Direct"
{
    // // BBG1.01 ALLE_NB 16102012: New functionality created for Gold Consumption Note posting.
    // 251121 Code comment
    // 270923 Approval Workflow

    Caption = 'Gold/Silver Voucher Direct';
    PageType = Card;
    SourceTable = "Gate Pass Header";
    SourceTableView = SORTING("Document Type", "Document No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER(MIN),
                            Status = FILTER(Open),
                            Type = CONST(Direct));
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
                    Visible = false;

                    trigger OnValidate()
                    begin
                        IF Rec."Customer No." <> '' THEN
                            Rec.TESTFIELD("New Project Code");

                        Rec."Responsibility Center" := Rec."New Project Code";
                        Rec."Job No." := Rec."New Project Code";
                        Rec."Location Code" := Rec."New Project Code";
                        Rec.VALIDATE("Shortcut Dimension 1 Code", Rec."New Project Code");
                    end;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Caption = 'Customer No. ';

                    trigger OnValidate()
                    begin
                        IF Rec."New Project Code" = '' THEN
                            ERROR('First Select Project Code for Gold Coin');
                    end;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Editable = false;
                }
                field(Respname; Respname)
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        //RAHEE1.00
                        IF Loc.GET(Rec."Location Code") THEN
                            LocName := Loc.Name;
                        //RAHEE1.00
                    end;
                }
                field(LocName; LocName)
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field(Short1name; Short1name)
                {
                    Editable = false;
                }
                field(Remarks; Rec.Remarks)
                {
                    MultiLine = true;
                }
                field("Reference No."; Rec."Reference No.")
                {
                }
                field("Item Type"; Rec."Item Type")
                {
                    Editable = False;

                    trigger OnValidate()
                    var
                        Conforders: Record "Confirmed Order";
                    begin
                        Conforders.RESET;
                        Conforders.SETCURRENTKEY("Customer No.");
                        Conforders.SETRANGE("Customer No.", Rec."Customer No.");
                        Conforders.SETFILTER("Restrict Issue for Gold/Silver", '<>%1', Conforders."Restrict Issue for Gold/Silver"::" ");
                        IF Conforders.FINDFIRST THEN BEGIN
                            IF Conforders."Restrict Issue for Gold/Silver" = Conforders."Restrict Issue for Gold/Silver"::Both THEN
                                ERROR('You cant issue Gold or Silver');
                            IF Conforders."Restrict Issue for Gold/Silver" = Conforders."Restrict Issue for Gold/Silver"::Silver THEN BEGIN
                                IF Rec."Item Type" = Rec."Item Type"::Silver THEN
                                    ERROR('You cant issue Silver');
                            END;
                            IF Conforders."Restrict Issue for Gold/Silver" = Conforders."Restrict Issue for Gold/Silver"::Gold THEN BEGIN
                                IF Rec."Item Type" = Rec."Item Type"::Gold THEN
                                    ERROR('You cant issue Gold');
                            END;
                        END;
                    end;
                }
                field("Issue Type"; Rec."Issue Type")
                {
                    Editable = false;
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
                field("Receiver Type"; Rec."Receiver Type")
                {
                }
                field("Received By"; Rec."Received By")
                {
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
                field("Send for Approval"; Rec."Send for Approval")
                {
                }
                field("Send for Approval DT"; Rec."Send for Approval DT")
                {
                }
                field("Approval Status"; Rec."Approval Status")
                {
                }
                field("Total Value"; Rec."Total Value")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Type; Rec.Type)
                {
                }
            }
            part("MIN Lines"; "Gold_Silver Voucher Lines")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No.");
                SubPageView = SORTING("Document Type", "Document No.", "Line No.")
                              ORDER(Ascending);
            }
            part("Item jnl Lines"; "Gold/SL Voucher Item Journal")
            {
                SubPageLink = "Document No." = FIELD("Document No.");
                SubPageView = SORTING("Document No.", "Line No.")
                              ORDER(Ascending);
            }
            part("Document Approval Details"; "Document Approval Details")
            {
                SubPageLink = "Document Type" = CONST("Gold/Silver"),
                              "Document No." = FIELD("Document No.");
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
                field("Sent for Verification By"; Rec."Sent for Verification By")
                {
                }
                field("Verified By"; Rec."Verified By")
                {
                }
                field("Returned Time"; Rec."Returned Time")
                {
                    Editable = false;
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
            // group("&Line")
            // {
            //     Caption = '&Line';
            //     action("Item &Tracking Lines")
            //     {
            //         Caption = 'Item &Tracking Lines';
            //         Image = ItemTrackingLines;
            //         ShortCutKey = 'Shift+Ctrl+I';

            //         trigger OnAction()
            //         begin
            //             CurrPage."MIN Lines".PAGE.OpenFreeTrackingLines;
            //         end;
            //     }
            // }



            group("&GIN")
            {
                Caption = '&GIN';
                action("&Attach Documents")
                {
                    Caption = '&Attach Documents';
                    Promoted = true;
                    RunObject = Page "Documents";
                    RunPageLink = "Table No." = CONST(97733),
                                  "Document No." = FIELD("Document No.");
                }

                // action("Get Gold Coins Lines")
                // {
                //     Caption = 'Get Gold Coins Lines';
                //     Visible = false;

                //     trigger OnAction()
                //     begin
                //         // ALLEAT 16102012 START

                //         GatePassLines.RESET;
                //         GatePassLines.SETRANGE(GatePassLines."Document Type", Rec."Document Type");
                //         GatePassLines.SETRANGE(GatePassLines."Document No.", Rec."Document No.");
                //         IF GatePassLines.FINDFIRST THEN
                //             ERROR('Pleae delete the below Entries first');


                //         GoldCoinApproval.RESET;
                //         CLEAR(GoldCoinApprovalPage);
                //         GoldCoinApproval.SETRANGE("Customer No.", Rec."Customer No.");
                //         GoldCoinApproval.SETRANGE("Gold/Silver Issue Status", GoldCoinApproval."Gold/Silver Issue Status"::Partial);
                //         IF GoldCoinApproval.FINDFIRST THEN BEGIN
                //             GoldCoinApprovalPage.SETTABLEVIEW(GoldCoinApproval);
                //             GoldCoinApprovalPage.SetDocNo(Rec."Document No.");
                //             GoldCoinApprovalPage.RUNMODAL;
                //         END ELSE
                //             ERROR('No Record found');
                //         // ALLEAT 16102012 END
                //     end;
                // }


                action("Sent for Approval")
                {
                    Caption = 'Sent for Approval';
                    Image = process;
                    Promoted = true;

                    trigger OnAction()
                    var
                        LineNo: Integer;
                        v_RequesttoApproveDocuments_1: Record "Request to Approve Documents";
                        ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
                        v_GatePassLine: Record "Gate Pass Line";
                    begin
                        //270923 Approval Workflow

                        Rec.TESTFIELD("Send for Approval", FALSE);
                        IF Rec."Approval Status" = Rec."Approval Status"::Approved THEN
                            ERROR('Document Already Approved');

                        v_GatePassLine.RESET;
                        v_GatePassLine.SETRANGE("Document Type", Rec."Document Type");
                        v_GatePassLine.SETRANGE("Document No.", Rec."Document No.");
                        v_GatePassLine.SETFILTER("Required Qty", '>%1', 0);
                        IF NOT v_GatePassLine.FINDFIRST THEN
                            ERROR('Lines not found');

                        IF CONFIRM('Do you want to send Document Send for Approval') THEN BEGIN
                            LineNo := 0;
                            RequesttoApproveDocuments.RESET;
                            RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Gold/Silver");
                            RequesttoApproveDocuments.SETRANGE("Document No.", Rec."Document No.");
                            IF RequesttoApproveDocuments.FINDLAST THEN
                                LineNo := RequesttoApproveDocuments."Line No.";

                            ApprovalWorkflowforAuditPr.RESET;
                            ApprovalWorkflowforAuditPr.SETRANGE("Document Type", ApprovalWorkflowforAuditPr."Document Type"::"Gold/Silver");
                            ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", USERID);
                            IF ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
                                REPEAT
                                    RequesttoApproveDocuments.RESET;
                                    RequesttoApproveDocuments.INIT;
                                    RequesttoApproveDocuments."Document Type" := RequesttoApproveDocuments."Document Type"::"Gold/Silver";
                                    RequesttoApproveDocuments."Document No." := Rec."Document No.";
                                    RequesttoApproveDocuments."Line No." := LineNo + 10000;
                                    RequesttoApproveDocuments."Posting Date" := Rec."Posting Date";
                                    RequesttoApproveDocuments."Requester ID" := USERID;
                                    RequesttoApproveDocuments."Approver ID" := ApprovalWorkflowforAuditPr."Approver ID";
                                    RequesttoApproveDocuments."Requester DateTime" := CURRENTDATETIME;
                                    RequesttoApproveDocuments.INSERT;
                                    LineNo := RequesttoApproveDocuments."Line No."
                                UNTIL ApprovalWorkflowforAuditPr.NEXT = 0;
                                Rec."Send for Approval" := TRUE;
                                Rec."Send for Approval DT" := CURRENTDATETIME;
                                Rec."Approval Status" := Rec."Approval Status"::"Pending for Approval";
                                Rec.MODIFY;
                            END ELSE
                                ERROR('Approver not found against this Sender');
                        END ELSE
                            MESSAGE('Nothing Process');

                        //270923 Approval Workflow
                    end;
                }

                action("&Sent For Verification")
                {
                    Caption = 'Sent For Verification';
                    Visible = false;

                    trigger OnAction()
                    begin
                        // ALLENB 16102012 START
                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');

                        Rec.TESTFIELD("Sent for Verification", FALSE);
                        Rec.TESTFIELD(Remarks);

                        GatePassLines.RESET;
                        GatePassLines.SETRANGE("Document Type", Rec."Document Type");
                        GatePassLines.SETRANGE("Document No.", Rec."Document No.");
                        IF GatePassLines.FINDSET THEN
                            REPEAT
                                GatePassLines.TESTFIELD("Required Qty");
                                GatePassLines.TESTFIELD(Qty);
                                GatePassLines.TESTFIELD("Application No.");
                            UNTIL GatePassLines.NEXT = 0
                        ELSE
                            ERROR('Cannot send Blank MIN!');

                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        MemberOf.RESET;
                        MemberOf.SETRANGE("User ID",USERID);
                        MemberOf.SETRANGE("Role ID",'MIN-SENT-FOR-VERIFY');
                        IF NOT MemberOf.FIND('-') THEN
                          ERROR('UnAuthorised User for sending for Verification');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        SendVerify := CONFIRM(Text007, TRUE, 'MIN', Rec."Document No.");
                        IF NOT SendVerify THEN
                            EXIT;
                        Rec."Sent for Verification" := TRUE;
                        Rec."Sent for Verification Date" := TODAY;
                        Rec."Sent For Verification Time" := TIME;
                        Rec."Sent for Verification By" := USERID;
                        Rec.MODIFY;

                        // ALLENB 16102012 END

                    end;
                }
                action("Return Gold Coin")
                {
                    Caption = 'Return Gold Coin';

                    trigger OnAction()
                    begin
                        //TESTFIELD(Verified,FALSE);  270923 Approval Workflow
                        //TESTFIELD("Sent for Verification",TRUE);  270923 Approval Workflow

                        Rec.TESTFIELD("Send for Approval", TRUE);
                        IF Rec."Approval Status" = Rec."Approval Status"::Approved THEN
                            ERROR('Approval status must not be Approved');
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User ID",USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID",'MIN-SUPER');
                        IF NOT MemberOf.FIND('-') THEN
                          ERROR('UnAuthorised User for removing Sent for Verification.');
                        //ALLE-PKS16
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        Returnmin := CONFIRM(Text009, TRUE, 'MIN', Rec."Document No.");
                        IF NOT Returnmin THEN EXIT;

                        //270923 Approval Workflow code comment Start
                        /*
                        //ALLE-PKS16
                        "Sent for Verification" :=FALSE;
                        "Sent for Verification Date" :=0D;
                        "Sent For Verification Time" :=0T;
                        "Sent for Verification By"   :='';
                        */   //270923 Approval Workflow code comment END

                        Rec.Returned := TRUE;
                        Rec."Returned Date" := TODAY;
                        Rec."Returned Time" := TIME;
                        Rec."Returned By" := USERID;
                        Rec.MODIFY;

                    end;
                }
                action("Verify Gold Coin")
                {
                    Caption = 'Verify Gold Coin';
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');

                        Rec.TESTFIELD("Item Type");
                        //TESTFIELD("Sent for Verification",TRUE);
                        //TESTFIELD(Verified,FALSE);



                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User ID",USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID",'DIRGOLDAPP');
                        IF NOT MemberOf.FIND('-') THEN
                          ERROR('UnAuthorised User for Verifying MIN');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016

                        Rec.TESTFIELD("Shortcut Dimension 1 Code");
                        //TESTFIELD("Shortcut Dimension 2 Code");
                        //TESTFIELD("Gen. Business Posting Group");
                        //ALLE-PKS16
                        //Verify:=CONFIRM(Text008,TRUE,'MIN',"Document No.");  //270923 Approval Workflow
                        //IF NOT Verify THEN EXIT;  //270923 Approval Workflow
                        //ALLE-PKS16
                        Rec.Verified := TRUE;
                        Rec."Verified Date" := TODAY;
                        //"Posting Date":=TODAY;
                        Rec."Verified Time" := TIME;
                        Rec."Verified By" := USERID;//alle-pks10
                        Rec.MODIFY;

                        //may 1.1 END

                    end;
                }
                action("Return Verified Gold Coin")
                {
                    Caption = 'Return Verified Gold Coin';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD(Verified, TRUE);
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
                        /*
                        MemberOf.RESET;
                        MemberOf.SETRANGE(MemberOf."User ID",USERID);
                        MemberOf.SETRANGE(MemberOf."Role ID",'DIRGOLDAPP');
                        IF NOT MemberOf.FIND('-') THEN
                          ERROR('UnAuthorised User for Verifying MIN');
                        */
                        // ALLE MM Code Commented as Member of table has been remove in NAV 2016
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
                    Visible = false;

                    trigger OnAction()
                    begin
                        //TESTFIELD(Verified,TRUE);  //270923 Approval Workflow
                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::Approved);  //270923 Approval Workflow
                        IF CONFIRM(Text50000, TRUE, 'Create', '', Rec."Document No.") THEN;
                        /*
                        recGatePassLines.RESET;
                        recGatePassLines.SETRANGE(recGatePassLines."Document Type",recGatePassLines."Document Type"::MIN);
                        recGatePassLines.SETRANGE(recGatePassLines."Document No.","Document No.");
                        recGatePassLines.SETRANGE(recGatePassLines."Journal Line Created",FALSE);
                        IF recGatePassLines.FIND('-') THEN BEGIN
                          REPEAT
                             CreateJounalLines;
                          UNTIL recGatePassLines.NEXT = 0;
                        END
                        ELSE
                          ERROR('Journals Lines already created');
                        */

                    end;
                }
                action("Delete Journal Lines")
                {
                    Caption = 'Delete Journal Lines';
                    Visible = false;

                    trigger OnAction()
                    begin
                        //TESTFIELD(Verified,FALSE);  //270923 Approval Workflow
                        IF Rec."Approval Status" <> Rec."Approval Status"::Approved THEN BEGIN  //270923 Approval Workflow
                            IF CONFIRM(Text50000, FALSE, 'delete', '', Rec."Document No.") THEN
                                Rec.DeleteJournalLine;
                        END;   //270923 Approval Workflow
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
                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::Approved);  //270923 Approval Workflow
                        DocNo := '';
                        DocNo := Rec."Document No.";

                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR('Please check Region Dimension code is different from Responsibility Center code');
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        //TESTFIELD(Verified,TRUE);
                        //TESTFIELD("Sent for Verification",TRUE);
                        Rec.TESTFIELD("Item Type");
                        CLEAR(ItemJnlPostLine);
                        GatePassHdr.RESET;
                        GatePassHdr.SETRANGE(GatePassHdr."Document No.", Rec."Document No.");
                        GatePassHdr.FINDFIRST;
                        IF CONFIRM(txtConfirm, TRUE) THEN BEGIN
                            IF POHeader.GET(POHeader."Document Type"::Order, Rec."Purchase Order No.") THEN BEGIN
                                IF (POHeader."Ending Date" <> 0D) THEN BEGIN
                                    IF ((POHeader."Ending Date" + 10) > WORKDATE) THEN BEGIN
                                        IF NOT CONFIRM('The end date of this order is already exceed. Do you want to post it', TRUE) THEN
                                            ERROR('');
                                    END;
                                END;
                            END;
                            RecGatePassLines.RESET;
                            RecGatePassLines.SETRANGE("Document Type", RecGatePassLines."Document Type"::MIN);
                            RecGatePassLines.SETRANGE("Document No.", Rec."Document No.");
                            RecGatePassLines.SETRANGE("Journal Line Created", FALSE);
                            IF RecGatePassLines.FIND('-') THEN BEGIN
                                REPEAT
                                    RecGatePassLines.TESTFIELD("Item No.");
                                    RecGatePassLines.TESTFIELD("Shortcut Dimension 2 Code");
                                    Tqty := 0;
                                    APPNo := '';
                                    GPLines.RESET;
                                    GPLines.SETRANGE("Document Type", RecGatePassLines."Document Type"::MIN);
                                    GPLines.SETRANGE("Document No.", Rec."Document No.");
                                    GPLines.SETRANGE("Journal Line Created", FALSE);
                                    GPLines.SETRANGE("Location Code", RecGatePassLines."Location Code");
                                    GPLines.SETRANGE("Item No.", RecGatePassLines."Item No.");
                                    IF GPLines.FIND('-') THEN
                                        REPEAT
                                            Tqty := Tqty + GPLines.Qty;
                                            APPNo := GPLines."Application No.";
                                        /*
                                        ConfOrder.RESET;
                                        IF ConfOrder.GET(APPNo) THEN BEGIN
                                          IF ConfOrder."Shortcut Dimension 1 Code" <> GPLines."Location Code" THEN
                                            ERROR('Application No. having different Project Code'+ConfOrder."Shortcut Dimension 1 Code");
                                        END;
                                        */  //251121
                                        UNTIL GPLines.NEXT = 0;

                                    Item.RESET;
                                    Item.SETRANGE("No.", RecGatePassLines."Item No.");
                                    Item.SETRANGE("Location Filter", RecGatePassLines."Location Code");
                                    IF Item.FINDFIRST THEN BEGIN
                                        Item.CALCFIELDS(Inventory);
                                        IF (Item.Inventory < Tqty) THEN
                                            ERROR('Item = %1 is not in inventory', Item."No.");
                                        IF Rec."Item Type" = Rec."Item Type"::Gold THEN
                                            Item.TESTFIELD(Item."Type of Item", Item."Type of Item"::Gold);
                                        IF Rec."Item Type" = Rec."Item Type"::Silver THEN
                                            Item.TESTFIELD(Item."Type of Item", Item."Type of Item"::Silver);

                                    END;
                                UNTIL RecGatePassLines.NEXT = 0;
                            END;

                            PostDate := 0D;
                            PostDate := Rec."Posting Date";
                            PostItemJnl;
                            IF RecGatePassLines.FINDFIRST THEN
                                RecGatePassLines.MODIFYALL("Journal Line Created", TRUE);
                            Rec.VALIDATE(Status, Rec.Status::Close);
                            Rec.MODIFY;

                            GoldCoinApproval.RESET;
                            GoldCoinApproval.SETRANGE("Min Doc No.", Rec."Document No.");
                            IF GoldCoinApproval.FINDSET THEN
                                REPEAT
                                    GoldCoinApproval.CALCFIELDS("Issued Gold / Silver");
                                    IF GoldCoinApproval."Issued Gold / Silver" = GoldCoinApproval."Gold/Silver Voucher Elg." THEN BEGIN
                                        GoldCoinApproval."Issued to Customer" := TRUE;
                                        GoldCoinApproval."Issued Date" := PostDate;
                                        GoldCoinApproval."Gold/Silver Issue Status" := GoldCoinApproval."Gold/Silver Issue Status"::Full;
                                        GoldCoinApproval.MODIFY;
                                    END;
                                UNTIL GoldCoinApproval.NEXT = 0;

                            //UpdateGoldGenerate;  //150425
                            MESSAGE('Document Successfuly Posted');

                            //251124 Code commented  Start
                            // cominfo.GET;
                            // IF cominfo."Send SMS" THEN BEGIN

                            //     IF Customer.GET(Rec."Customer No.") THEN BEGIN
                            //         IF Customer."BBG Mobile No." <> '' THEN BEGIN
                            //             CustMobileNo := Customer."BBG Mobile No.";
                            //             IF (Tqty <> 0) THEN BEGIN
                            //                 CustSMSText := Rec.Remarks;
                            //                 //            'Mr/Mrs/Ms:' + Customer.Name+' ' +'Congratulations ! Towards ApplNo'+ APPNo +' '+
                            //                 //          ' '+'Project: '+GetDescription.GetDimensionName(ConfOrder."Shortcut Dimension 1 Code",1)+' '+
                            //                 //         FORMAT( "Item Type") +'Coin has been Issued.';
                            //                 MESSAGE('%1', CustSMSText);
                            //                 PostPayment.SendSMS(CustMobileNo, CustSMSText);
                            //                 //ALLEDK15112022 Start
                            //                 CLEAR(SMSLogDetails);
                            //                 SmsMessage := '';
                            //                 SmsMessage1 := '';
                            //                 SmsMessage := COPYSTR(CustSMSText, 1, 250);
                            //                 SmsMessage1 := COPYSTR(CustSMSText, 251, 250);
                            //                 SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Send SMS Generation of Challan', Rec."Shortcut Dimension 1 Code", GetDescription.GetDimensionName(Rec."Shortcut Dimension 1 Code", 1), APPNo);
                            //                 //ALLEDK15112022 END

                            //             END;
                            //         END
                            //         ELSE
                            //             MESSAGE('%1', 'Mobile No. not Found');
                            //     END;
                            // END;
                            //251124 Code commented END

                        END;
                        // BBG1.01 ALLENB 16102012 End

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
                    // BBG1.01 ALLE_NB 16102012 START
                    Rec."Posting Date" := WORKDATE;
                    Rec.MODIFY;
                    // BBG1.01 ALLE_NB 16102012 END
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // BBG1.01 ALLE_NB 16102012 START
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            IF Loc.GET(Rec."Location Code") THEN;
            LocName := Loc.Name;
            IF RecJob.GET(RecRespCenter."Job Code") THEN
                JobName := RecJob.Description;
        END;




        CLEAR(material);
        CLEAR(consumable);
        CLEAR(tools);
        /*
        IF "Purchase Order No." <>'' THEN BEGIN
          POHeader.RESET;
          POHeader.SETRANGE(POHeader."No.","Purchase Order No.");
          IF POHeader.FIND('-') THEN BEGIN
            material:=POHeader.Material;
            consumable:=POHeader.Consumables;
            tools:=POHeader."Tools and Tackles";
          END;
        END;
        */// BBG1.01 ALLE_NB 16102012 END

    end;

    trigger OnInit()
    begin
        "Posting DateEditable" := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Type := Rec.Type::Direct; //BBG1.00 170613
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // BBG1.01 ALLE_NB 16102012 START
        Rec.Status := Rec.Status::Open;
        Rec."Responsibility Center" := UserMgt.GetPurchasesFilter();
        Rec."Item Type" := Rec."Item Type"::Gold_SilverVoucher;  //09042025 Code added
        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            IF Loc.GET(Rec."Location Code") THEN;
            LocName := Loc.Name;
        END;
        // BBG1.01 ALLE_NB 16102012 END
    end;

    trigger OnOpenPage()
    begin
        // BBG1.01 ALLE_NB 16102012 START
        IF Rec.Verified = TRUE THEN BEGIN
            CurrPage.EDITABLE(FALSE);
            "Posting DateEditable" := TRUE;
        END;
        /*
        IF UserMgt.GetPurchasesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserMgt.GetPurchasesFilter());
          FILTERGROUP(0);
        END;
         */

        RecRespCenter.RESET;
        RecRespCenter.SETRANGE(Code, Rec."Responsibility Center");
        IF RecRespCenter.FIND('-') THEN BEGIN
            Respname := RecRespCenter.Name;
            Short1name := RecRespCenter."Region Name";
            IF Loc.GET(Rec."Location Code") THEN
                LocName := Loc.Name;
            IF RecJob.GET(RecRespCenter."Job Code") THEN
                JobName := RecJob.Description;
        END;
        // BBG1.01 ALLE_NB 16102012 END

    end;

    var
        GatePassLines: Record "Gate Pass Line";
        ItemJnl: Record "Item Journal Line";
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJournal: Record "Item Journal Line";
        RecGatePassLines: Record "Gate Pass Line";
        RecEmployee: Record Employee;
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
        Customer: Record Customer;
        JobJnlPostLine: Codeunit "Job Jnl.-Post Line";
        NoSeries: Codeunit NoSeriesManagement;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        GEnJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        UserMgt: Codeunit "User Setup Management";
        Navigate: Page Navigate;
        PictureExists: Boolean;
        CodeUnitRun: Boolean;
        NonEditable: Boolean;
        SendVerify: Boolean;
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
        LocName: Text[50];
        JobName: Text[50];
        EndLineNo: Integer;
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
        GoldCoinApproval: Record "Gold/Silver Voucher Eleg.";
        GoldCoinApprovalPage: Page "Gold Coin Approval";
        CustomerNo: Code[20];
        CustomerName: Text[50];
        CustomerNo1: Code[20];
        PostDate: Date;
        GatepassEntry: Record "Gate Pass Line";
        DocNo: Code[20];
        CustMobileNo: Text[30];
        CustSMSText: Text[500];
        APPNo: Code[20];
        ConfOrder: Record "Confirmed Order";
        Application: Record Application;
        ReleaseBondApplication: Codeunit "Release Unit Application";
        DueAmount: Decimal;
        GetDescription: Codeunit GetDescription;
        PostPayment: Codeunit PostPayment;
        cominfo: Record "Company Information";


        "Posting DateEditable": Boolean;
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
        RequesttoApproveDocuments: Record "Request to Approve Documents";


    procedure CreateJounalLines()
    var
        Tqty: Decimal;
    begin
        // BBG1.01 ALLE_NB 16102012 START
        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');
        Rec.TESTFIELD(Status, Rec.Status::Open);

        RecGatePassLines.RESET;
        RecGatePassLines.SETRANGE(RecGatePassLines."Document Type", RecGatePassLines."Document Type"::MIN);
        RecGatePassLines.SETRANGE(RecGatePassLines."Document No.", Rec."Document No.");
        IF RecGatePassLines.FIND('-') THEN
            REPEAT
                IF RecGatePassLines."Shortcut Dimension 2 Code" = '' THEN BEGIN
                    DefDimRec.RESET;
                    DefDimRec.GET(27, RecGatePassLines."Item No.", 'COSTHead');
                    RecGatePassLines."Shortcut Dimension 2 Code" := DefDimRec."Dimension Value Code";
                END;
                RecGatePassLines.MODIFY;
            UNTIL RecGatePassLines.NEXT = 0;

        CLEAR(ItemJnlPostLine);
        GatePassHdr.RESET;
        GatePassHdr.SETRANGE(GatePassHdr."Document No.", Rec."Document No.");
        GatePassHdr.FIND('-');
        IF POHeader.GET(POHeader."Document Type"::Order, Rec."Purchase Order No.") THEN BEGIN
            IF (POHeader."Ending Date" <> 0D) THEN BEGIN
                IF ((POHeader."Ending Date" + 10) > WORKDATE) THEN BEGIN
                    IF NOT CONFIRM('The end date of this order is already exceed. Do you want to create it', TRUE) THEN
                        ERROR('');
                END;
            END;
        END;

        RecGatePassLines.RESET;
        RecGatePassLines.SETRANGE(RecGatePassLines."Document Type", RecGatePassLines."Document Type"::MIN);
        RecGatePassLines.SETRANGE(RecGatePassLines."Document No.", Rec."Document No.");
        RecGatePassLines.SETRANGE(RecGatePassLines."Journal Line Created", FALSE);
        IF RecGatePassLines.FIND('-') THEN BEGIN
            REPEAT
                RecGatePassLines.TESTFIELD("Item No.");
                Tqty := 0;
                GPLines.RESET;
                GPLines.SETRANGE("Document Type", RecGatePassLines."Document Type"::MIN);
                GPLines.SETRANGE("Document No.", Rec."Document No.");
                GPLines.SETRANGE("Journal Line Created", FALSE);
                GPLines.SETRANGE("Location Code", RecGatePassLines."Location Code");
                GPLines.SETRANGE("Item No.", RecGatePassLines."Item No.");
                IF GPLines.FIND('-') THEN
                    REPEAT
                        Tqty := Tqty + GPLines.Qty;
                    UNTIL GPLines.NEXT = 0;

                Item.RESET;
                Item.SETRANGE("No.", RecGatePassLines."Item No.");
                Item.SETRANGE("Location Filter", RecGatePassLines."Location Code");
                IF Item.FIND('-') THEN BEGIN
                    Item.CALCFIELDS(Inventory);
                    IF (Item.Inventory < Tqty) THEN
                        ERROR('Item = %1 is not in inventory', Item."No.");
                END;
                RecGatePassLines.TESTFIELD("Shortcut Dimension 2 Code");
            UNTIL RecGatePassLines.NEXT = 0;
        END;

        IF RecGatePassLines.FIND('-') THEN
            RecGatePassLines.MODIFYALL("Journal Line Created", TRUE);
        Rec.VALIDATE("Journal Lines Created", TRUE);
        Rec.MODIFY;
        IF Rec."Journal Lines Created" THEN
            Rec.CreateServiceItem(Rec);
        MESSAGE('General lines Successfully Created')
        // BBG1.01 ALLE_NB 16102012 END
    end;


    procedure GetItemLines()
    begin
        // BBG1.01 ALLE_NB 16102012 START
        GatePassLines.RESET;
        GatePassLines.SETRANGE("Document Type", Rec."Document Type");
        GatePassLines.SETRANGE("Document No.", Rec."Document No.");
        IF NOT GatePassLines.FIND('-') THEN
            ERROR('Nothing to Post');
        // BBG1.01 ALLE_NB 16102012 END
    end;


    procedure InsertItemJournals()
    begin
        // BBG1.01 ALLE_NB 16102012 START

        ItemJournal.RESET;
        ItemJournal.SETRANGE("Journal Template Name", 'MIN');
        ItemJournal.SETRANGE("Journal Batch Name", 'MIN');
        IF ItemJournal.FINDLAST THEN
            EndLineNo := ItemJournal."Line No." + 10000
        ELSE
            EndLineNo := 10000;


        ItemJnl.VALIDATE("Journal Template Name", 'MIN');
        ItemJnl.VALIDATE("Journal Batch Name", 'MIN');
        ItemJnl.VALIDATE("Document No.", Rec."Document No.");
        ItemJnl.VALIDATE("Line No.", EndLineNo);
        ItemJnl.VALIDATE("Vendor No.", Rec."Vendor No.");
        ItemJnl.VALIDATE("PO No.", Rec."Purchase Order No.");
        ItemJnl.VALIDATE("Item Shpt. Entry No.", 0);
        ItemJnl.INSERT(TRUE);
        ItemJnl.VALIDATE("Posting Date", Rec."Posting Date");
        ItemJnl.VALIDATE("Entry Type", ItemJnl."Entry Type"::"Negative Adjmt.");
        ItemJnl.VALIDATE("Item No.", RecGatePassLines."Item No.");
        ItemJnl.VALIDATE("Location Code", RecGatePassLines."Location Code");
        ItemJnl.VALIDATE(Quantity, RecGatePassLines.Qty);
        IF RecGatePassLines."Gen. Bus. Posting Group" <> '' THEN
            ItemJnl.VALIDATE("Gen. Bus. Posting Group", RecGatePassLines."Gen. Bus. Posting Group");
        IF RecGatePassLines."Gen. Prod. Posting Group" <> '' THEN
            ItemJnl.VALIDATE("Gen. Prod. Posting Group", RecGatePassLines."Gen. Prod. Posting Group");
        ItemJnl.VALIDATE("Shortcut Dimension 1 Code", RecGatePassLines."Shortcut Dimension 1 Code");
        ItemJnl.VALIDATE("Shortcut Dimension 2 Code", RecGatePassLines."Shortcut Dimension 2 Code");
        IF RecGatePassLines."Applies-to Entry" <> 0 THEN
            ItemJnl.VALIDATE("Applies-to Entry", RecGatePassLines."Applies-to Entry");
        ItemJnl.VALIDATE("Issue Type", Rec."Issue Type");
        ItemJnl."Reference No." := Rec."Reference No.";
        ItemJnl."Application No." := RecGatePassLines."Application No.";
        ItemJnl."Application Line No." := RecGatePassLines."Application Line No.";
        ItemJnl."Item Type" := Rec."Item Type";

        ItemJnl.VALIDATE("Bin Code", RecGatePassLines."Bin Code");
        ItemJnl.Narration := RecGatePassLines.Description + ' Qty:' + FORMAT(RecGatePassLines.Qty);
        ItemJnl.MODIFY(TRUE);
        RecGatePassLines.MODIFY;

        // ALLE MM Code Commented as Table General Line Dimension(356) removed in NAV 2016
        ItemJnlPostLine.RunWithCheck(ItemJnl);
        IF RecGatePassLines."Bin Code" <> '' THEN BEGIN  //AlleDK 020909
            IF WMSMgmt.CreateWhseJnlLine(ItemJnl, 0, WhseJnlLine, FALSE) THEN BEGIN
                WMSMgmt.CheckWhseJnlLine(WhseJnlLine, 1, 0, FALSE);
                WhseJnlPostLine.RUN(WhseJnlLine);
            END;
        END;
        ItemJnl.DELETE;
        // BBG1.01 ALLE_NB 16102012 END
    end;


    procedure InsertGnLLines()
    var
        LineNo: Integer;
        AccNo: Code[20];
    begin
        // BBG1.01 ALLE_NB 16102012 START
        GenTemplateCode := 'General';
        GenBatchCode := 'DEFAULT';

        GenJnlTemplate.GET(GenTemplateCode);
        GenJnlBatch.GET(GenTemplateCode, GenBatchCode);

        GenJnlLine.RESET;
        GenJnlLine.SETRANGE("Journal Template Name", GenTemplateCode);
        GenJnlLine.SETRANGE("Journal Batch Name", GenBatchCode);
        IF GenJnlLine.FINDFIRST THEN
            vLineNo := GenJnlLine."Line No.";

        Tamt := 0;
        REPEAT
            Amount := 0;
            AccNo := RecGatePassLines."Account No.";
            RecGatePassLines.SETRANGE("Account No.", AccNo);
            GPassLine.RESET;
            GPassLine.SETRANGE("Document Type", RecGatePassLines."Document Type");
            GPassLine.SETRANGE("Document No.", RecGatePassLines."Document No.");
            GPassLine.SETRANGE("Account No.", RecGatePassLines."Account No.");
            IF GPassLine.FIND('-') THEN
                REPEAT
                    Amount := Amount + (GPassLine.Qty * GPassLine."Unit Cost");
                    Tamt := Tamt + (GPassLine.Qty * GPassLine."Unit Cost");
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
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                GenJnlLine.VALIDATE("Account No.", RecGatePassLines."Account No.");
                GenJnlLine.VALIDATE(Amount, -Amount);
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
                GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code", RecGatePassLines."Shortcut Dimension 2 Code");
                GenJnlLine."Gen. Bus. Posting Group" := '';
                GenJnlLine."Gen. Prod. Posting Group" := '';
                GenJnlLine.MODIFY;
                GEnJnlPostLine.RunWithCheck(GenJnlLine);
                GenJnlLine.DELETE;
            END;
            RecGatePassLines.FIND('+');
            RecGatePassLines.SETRANGE("Account No.");
        UNTIL RecGatePassLines.NEXT = 0;

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
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;
            GenJnlLine.VALIDATE("Account No.", Rec."Vendor No.");
            GenJnlLine.VALIDATE(Amount, Tamt);
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
            GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code", RecGatePassLines."Shortcut Dimension 2 Code");
            GenJnlLine."Gen. Bus. Posting Group" := '';
            GenJnlLine."Gen. Prod. Posting Group" := '';
            GenJnlLine.MODIFY;
            GEnJnlPostLine.RunWithCheck(GenJnlLine);
            GenJnlLine.DELETE(TRUE);
        END;
        // BBG1.01 ALLE_NB 16102012 END
    end;


    procedure PostItemJnl()
    var
        LineNo: Integer;
        AccNo: Code[20];
        ItemJnlLines: Record "Item Journal Line";
        UnitSetup: Record "Unit Setup";
    begin
        // BBG1.01 ALLE_NB 16102012 START
        GetItemLines;
        UnitSetup.GET;
        UnitSetup.TestField(UnitSetup."Gold/Silver Voucher Template");
        UnitSetup.TestField(UnitSetup."Gold/Silver Voucher Batch");
        ItemJnlLines.RESET;
        ItemJnlLines.SetRange("Journal Template Name", UnitSetup."Gold/Silver Voucher Template");
        ItemJnlLines.SetRange("Journal Batch Name", UnitSetup."Gold/Silver Voucher Batch");
        ItemJnlLines.SetRange("Document No.", Rec."Document No.");
        If ItemJnlLines.FindFirst() then
            CODEUNIT.Run(CODEUNIT::"Item Jnl.-Post", ItemJnlLines);


        // RecGatePassLines.RESET;
        // RecGatePassLines.SETRANGE("Document Type", RecGatePassLines."Document Type"::MIN);
        // RecGatePassLines.SETRANGE("Document No.", Rec."Document No.");
        // RecGatePassLines.SETRANGE("Journal Line Created", FALSE);
        // IF RecGatePassLines.FINDFIRST THEN
        //     REPEAT
        //         InsertItemJournals;
        //     UNTIL RecGatePassLines.NEXT = 0;
        // BBG1.01 ALLE_NB 16102012 End
    end;


    procedure UpdateGoldGenerate()
    var
        GoldCoinLine: Record "Gold Coin Line";
        ConfOrder: Record "Confirmed Order";
        GatePassLines: Record "Gate Pass Line";
        GoldCoinEligibility: Record "Gold Coin Eligibility";
    begin
        //Alle26/02/13
        GatePassLines.RESET;
        GatePassLines.SETRANGE("Document No.", DocNo);
        IF GatePassLines.FINDSET THEN
            REPEAT
                IF ConfOrder.GET(GatePassLines."Application No.") THEN BEGIN
                    GoldCoinLine.RESET;
                    GoldCoinLine.SETRANGE("Plot Size", ConfOrder."Saleable Area");
                    IF GoldCoinLine.FINDFIRST THEN BEGIN
                        GoldCoinEligibility.RESET;
                        GoldCoinEligibility.SETRANGE("Application No.", GatePassLines."Application No.");
                        IF GoldCoinEligibility.FINDFIRST THEN
                            GoldCoinEligibility.CALCFIELDS("Total No.of Gold/Silver Issued");
                        IF GoldCoinEligibility."Total No.of Gold/Silver Issued"
                           = GoldCoinLine."Min. No. of Gold Coins" + GoldCoinLine."No. of Gold Coins on Full Pmt." THEN BEGIN
                            ConfOrder."Gold Coin Generated" := TRUE;
                            ConfOrder.MODIFY;
                        END;
                    END;
                END;
            UNTIL GatePassLines.NEXT = 0;


        //Alle26/02/13
    end;

    local procedure StatusOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

