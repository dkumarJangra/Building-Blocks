pageextension 50022 "BBG Purchase Invoice Ext" extends "Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        modify("Posting Description")
        {
            Visible = true;
        }
        modify("Buy-from Country/Region Code")
        {
            Visible = false;
        }
        modify(BuyFromContactPhoneNo)
        {
            Visible = false;
        }
        modify(BuyFromContactMobilePhoneNo)
        {
            Visible = false;
        }
        modify(BuyFromContactEmail)
        {
            Visible = false;
        }
        modify("Order Address Code")
        {
            Caption = 'Order Address Code';
            ApplicationArea = all;
        }
        modify("Include GST in TDS Base")
        {
            Visible = false;
        }
        modify("Job Queue Status")
        {
            Visible = true;
        }
        modify("Vendor Posting Group")
        {
            Visible = false;
        }
        modify(ShippingOptionWithLocation)
        {
            Visible = false;
        }
        modify(PayToOptions)
        {
            Visible = false;
        }
        modify("Ship-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Ship-to Phone No.")
        {
            Visible = false;
        }
        modify("Remit-to Code")
        {
            Visible = false;
        }




        moveafter("Buy-from Address 2"; "Buy-from Post Code")
        addbefore("Buy-from Contact")
        {
            field("Order Ref. No."; Rec."Order Ref. No.")
            {
                ApplicationArea = all;
            }
        }
        movebefore("Document Date"; "Posting Date")
        moveafter("Document Date"; "Vendor Invoice No.")
        addafter("Vendor Invoice No.")
        {
            field("Vendor Invoice Date"; Rec."Vendor Invoice Date")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Vendor Invoice Date"; "Invoice Received Date")
        moveafter("Invoice Received Date"; "Order Address Code")
        moveafter("Order Address Code"; "Purchaser Code")
        moveafter("Purchaser Code"; "Assigned User ID")
        moveafter("Assigned User ID"; Status)
        addafter(Status)
        {
            field("GST Reason Type"; Rec."GST Reason Type")
            {
                ApplicationArea = All;
            }
            field("Initiator of this document is"; Rec.Initiator)
            {
                ApplicationArea = All;
            }
            field("Default GL Account"; Rec."Default GL Account")
            {
                ApplicationArea = All;
            }
            field("G/L Account Name"; glacname)
            {
                ApplicationArea = All;
            }
            field("Received Invoice Amount"; Rec."Received Invoice Amount")
            {
                ApplicationArea = All;
            }
            field("User Branch"; Rec."User Branch")
            {
                ApplicationArea = All;
            }
        }
        moveafter("User Branch"; "Shortcut Dimension 1 Code")
        addafter("Shortcut Dimension 1 Code")
        {
            field("Job No."; Rec."Job No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
        moveafter("Job No."; "Responsibility Center")
        moveafter("Responsibility Center"; "Location Code")
        moveafter("Location Code"; "Posting Description")


        addfirst("Invoice Details")
        {
            field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Pay-to Vendor No."; "Pay-to Contact No.")
        moveafter("Pay-to Contact No."; "Buy-from Contact No.")
        moveafter("Buy-from Contact No."; "Pay-to Name")
        moveafter("Pay-to Name"; "Pay-to Address")
        moveafter("Pay-to Address"; "Pay-to Address 2")
        moveafter("Pay-to Address 2"; "Pay-to Post Code")
        moveafter("Pay-to Post Code"; "Pay-to City")
        moveafter("Pay-to City"; "Pay-to Contact")
        moveafter("Pay-to Contact"; "Shortcut Dimension 2 Code")
        moveafter("Shortcut Dimension 2 Code"; "Job Queue Status")
        moveafter("Job Queue Status"; "Campaign No.")
        moveafter("Campaign No."; "Payment Terms Code")
        moveafter("Payment Terms Code"; "Due Date")
        moveafter("Due Date"; "Payment Discount %")
        moveafter("Payment Discount %"; "Pmt. Discount Date")
        moveafter("Pmt. Discount Date"; "Payment Method Code")
        moveafter("Payment Method Code"; "Payment Reference")
        moveafter("Payment Reference"; "Creditor No.")
        moveafter("Creditor No."; "On Hold")
        moveafter("On Hold"; "Prices Including VAT")
        moveafter("Prices Including VAT"; "VAT Bus. Posting Group")


        moveafter("Ship-to Address 2"; "Ship-to Post Code")
        moveafter("Ship-to City"; "Ship-to Contact")
        moveafter(PayToOptions; "Shipment Method Code")
        moveafter("Shipment Method Code"; "Expected Receipt Date")
        moveafter("Expected Receipt Date"; "Bill to-Location(POS)")


        movefirst("Foreign Trade"; "Currency Code")
        moveafter("Transaction Type"; "Transaction Specification")



        addfirst("Tax Information")
        {
            field(Trading; Rec.Trading)
            {
                ApplicationArea = All;
            }
        }
        moveafter(Trading; "Location State Code")
        moveafter("Location State Code"; "Location GST Reg. No.")
        moveafter("Location GST Reg. No."; "GST Vendor Type")
        moveafter("GST Vendor Type"; "Invoice Type")
        addafter("Invoice Type")
        {
            field("GST Input Service Distribution"; Rec."GST Input Service Distribution")
            {
                ApplicationArea = All;
            }
        }
        moveafter("GST Input Service Distribution"; "Associated Enterprises")
        moveafter("Associated Enterprises"; "Without Bill Of Entry")
        moveafter("Without Bill Of Entry"; "Bill of Entry No.")
        moveafter("Bill of Entry No."; "Bill of Entry Date")
        moveafter("Bill of Entry Date"; "Bill of Entry Value")
        moveafter("Bill of Entry Value"; "GST Order Address State")
        moveafter("GST Order Address State"; "Order Address GST Reg. No.")
        moveafter("Order Address GST Reg. No."; "Vendor GST Reg. No.")
        moveafter("Vendor GST Reg. No."; "Vehicle No.")
        moveafter("Vehicle No."; "Vehicle Type")
        moveafter("Vehicle Type"; "Shipping Agent Code")
        addafter("Shipping Agent Code")
        {
            field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Shipping Agent Service Code"; "Distance (Km)")
        addafter("Distance (Km)")
        {
            field("Reference Invoice No."; Rec."Reference Invoice No.")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Reference Invoice No."; "Rate Change Applicable")
        moveafter("Rate Change Applicable"; "Supply Finish Date")
        addafter("Supply Finish Date")
        {
            field("Payment Date"; Rec."Payment Date")
            {
                ApplicationArea = All;
            }
        }



        addafter("Tax Information")
        {
            group("BBG Payment Condition")
            {
                Caption = 'Payment Condition';
                field("Last Stage Completed"; Rec."Last Stage Completed")
                {
                    ApplicationArea = All;
                }
                field("Completed All Stages"; Rec."Completed All Stages")
                {
                    ApplicationArea = All;
                }
                field("Active Stage"; Rec."Active Stage")
                {
                    ApplicationArea = All;
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ApplicationArea = All;
                }
                field("Sent for Approval Date"; Rec."Sent for Approval Date")
                {
                    ApplicationArea = All;
                }
                field("Sent for Approval Time"; Rec."Sent for Approval Time")
                {
                    ApplicationArea = All;
                }
                field("SubCont Start Date"; Rec."SubCont Start Date")
                {
                    ApplicationArea = All;
                }
                field("SubCont End Date"; Rec."SubCont End Date")
                {
                    ApplicationArea = All;
                }
                field("Block Name"; Rec."Block Name")
                {
                    ApplicationArea = All;
                }
                field("R.A. Bill No."; Rec."R.A. Bill No.")
                {
                    ApplicationArea = All;
                }
                field(Approved; Rec.Approved)
                {
                    ApplicationArea = All;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = All;
                }
                field("Approved Time"; Rec."Approved Time")
                {
                    ApplicationArea = All;
                }
                field("Approved Return"; Rec."Approved Return")
                {
                    ApplicationArea = All;
                }
                field(Initiator; Rec.Initiator)
                {
                    ApplicationArea = All;
                }

            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter(Post)
        {
            action(New)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF CONFIRM('Are you sure you want to create Invoice?', TRUE) THEN BEGIN
                        //JPL03 START
                        Phdr.INIT;
                        Phdr."Document Type" := Phdr."Document Type"::Invoice;
                        Phdr."No." := '';
                        Phdr.INSERT(TRUE);
                        Rec.GET(Phdr."Document Type", Phdr."No.");
                        //FORM.RUN(51,PHdr);
                    END;
                end;
            }
            action("Change Posting Date")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    IF (USERID = Rec.Initiator) OR (USERID = '100654') THEN BEGIN
                        Rec."Posting Date" := TODAY;
                        Rec.MODIFY;
                    END;
                end;
            }
        }
        addafter("Co&mments")
        {
            group("Approval Customized")
            {
                Caption = 'Approval Customized';
                action("Send for Approval")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        //JPL55 START
                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');

                        IF Rec.Initiator <> UPPERCASE(USERID) THEN
                            ERROR('Sorry,You are not Initiator of this document');



                        //NDALLE 240108
                        //IF "Document Type" = "Document Type"::Invoice THEN
                        //TESTFIELD("Received Invoice Amount");
                        //NDALLE 240108

                        //Rec.TESTFIELD(Structure);
                        //ALLE 291015
                        PurchLine2.RESET;
                        PurchLine2.SETRANGE("Document No.", Rec."No.");
                        PurchLine2.SETFILTER("No.", '<>%1', '');
                        PurchLine2.SETRANGE(Type, PurchLine2.Type::"Fixed Asset");
                        IF PurchLine2.FIND('-') THEN
                            REPEAT
                                PurchLine2."Job No." := '';
                                PurchLine2.MODIFY;
                            UNTIL PurchLine2.NEXT = 0;
                        //ALLE 291015

                        //NDALLE 300108
                        IF Rec."Document Type" = Rec."Document Type"::Invoice THEN BEGIN
                            IF Rec."Order Ref. No." <> '' THEN BEGIN
                                PurchLine2.RESET;
                                PurchLine2.SETRANGE("Document No.", Rec."No.");
                                PurchLine2.SETFILTER("No.", '<>%1', '');
                                PurchLine2.SETRANGE(Type, PurchLine2.Type::Item);
                                IF PurchLine2.FIND('-') THEN
                                    REPEAT
                                        IF PurchLine2."PO No." <> Rec."Order Ref. No." THEN
                                            ERROR('Order No. of Line is not matching with Order No. in Header in Line No. %1', PurchLine2."Line No.");
                                    UNTIL PurchLine2.NEXT = 0;
                            END;
                        END;

                        IF Rec."Document Type" = Rec."Document Type"::Invoice THEN BEGIN
                            IF Rec."Order Ref. No." <> '' THEN BEGIN
                                RecPurchLine.RESET;
                                RecPurchLine.SETRANGE("Document No.", Rec."No.");
                                RecPurchLine.SETFILTER("No.", '<>%1', '');
                                IF RecPurchLine.FINDFIRST THEN BEGIN
                                    REPEAT
                                        RecPurchLine2.RESET;
                                        RecPurchLine2.SETRANGE("Document No.", RecPurchLine."PO No.");
                                        RecPurchLine2.SETRANGE("No.", RecPurchLine."No.");
                                        RecPurchLine2.SETRANGE("Line No.", RecPurchLine."PO Line No.");
                                        IF RecPurchLine2.FIND('-') THEN
                                            IF RecPurchLine."Direct Unit Cost" > RecPurchLine2."Direct Unit Cost" THEN
                                                ERROR('Unit Cost in Line No. %1 must not be Greater than %2', RecPurchLine."Line No.", RecPurchLine2."Direct Unit Cost")
                                    ;
                                    //ALLERP 29-11-2010:Start:
                                    // IF RecPurchLine."Service Tax Group" <> '' THEN
                                    //     RecPurchLine.TESTFIELD("Service Tax Registration No.");
                                    //ALLERP 29-11-2010:End:
                                    UNTIL RecPurchLine.NEXT = 0;
                                END;
                            END;
                        END;
                        //NDALLE 300108

                        //May 1.0 temporary code to stop the missuse of DUMMY Cost center
                        //To check whether DUMMY Cost Centers have been used in line...
                        PurchLine.SETRANGE(PurchLine."Document No.", Rec."No.");
                        IF PurchLine.FIND('-') THEN
                            REPEAT
                                IF PurchLine."Shortcut Dimension 1 Code" = 'DUMMY' THEN
                                    ERROR('Can not be approved with DUMMY cost Center selected in Invoice lines...');
                            UNTIL PurchLine.NEXT = 0;

                        joballocation.RESET;
                        joballocation.SETRANGE(joballocation."Document No.", Rec."No.");
                        IF joballocation.FIND('-') THEN
                            REPEAT
                                IF joballocation."Shortcut Dimension 1 Code" = 'DUMMY' THEN
                                    ERROR('Can not be approved with DUMMY cost Center selected in Job allocation...');
                            UNTIL joballocation.NEXT = 0;

                        IF Rec."Sent for Approval" = FALSE THEN BEGIN
                            Rec.VALIDATE("Sent for Approval", TRUE);
                            //ALLE-PKS16
                            Accept := CONFIRM(Text007, TRUE, 'Invoice', Rec."No.");
                            IF NOT Accept THEN EXIT;
                            //ALLE-PKS16

                            Rec."Sent for Approval Date" := TODAY;
                            Rec."Sent for Approval Time" := TIME;
                            Rec.MODIFY;
                            UserTasksNew.AuthorizationPO(UserTasksNew."Transaction Type"::Purchase, UserTasksNew."Document Type"::Invoice,
                            UserTasksNew."Sub Document Type"::" ", Rec."No.");

                            CurrPage.UPDATE(TRUE);
                        END;

                        //JPL55

                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."No.");
                        //ND
                    end;
                }
                action("Approve Customized")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        //NDALLE 211205
                        IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                            ERROR(' Please check, Region Dimension code is different from Responsibility Center code');


                        Rec.TESTFIELD("Sent for Approval", TRUE);

                        //NDALLE 300108
                        IF Rec."Document Type" = Rec."Document Type"::Invoice THEN BEGIN
                            IF Rec."Order Ref. No." <> '' THEN BEGIN
                                RecPurchLine.RESET;
                                RecPurchLine.SETRANGE("Document No.", Rec."No.");
                                RecPurchLine.SETFILTER("No.", '<>%1', '');
                                IF RecPurchLine.FINDFIRST THEN BEGIN
                                    REPEAT
                                        RecPurchLine2.RESET;
                                        RecPurchLine2.SETRANGE("Document No.", RecPurchLine."PO No.");
                                        RecPurchLine2.SETRANGE("No.", RecPurchLine."No.");
                                        RecPurchLine2.SETRANGE("Line No.", RecPurchLine."PO Line No.");
                                        IF RecPurchLine2.FIND('-') THEN
                                            IF RecPurchLine."Direct Unit Cost" > RecPurchLine2."Direct Unit Cost" THEN
                                                ERROR('Unit Cost in Line No. %1 must not be Greater than %2', RecPurchLine."Line No.", RecPurchLine2."Direct Unit Cost")
                                    ;
                                    UNTIL RecPurchLine.NEXT = 0;
                                END;
                            END;
                        END;
                        //NDALLE 300108

                        //May 1.0 temporary code to stop the missuse of DUMMY Cost center
                        //To check whether DUMMY Cost Centers have been used in line...
                        PurchLine.SETRANGE(PurchLine."Document No.", Rec."No.");
                        IF PurchLine.FIND('-') THEN
                            REPEAT
                                IF PurchLine."Shortcut Dimension 1 Code" = 'DUMMY' THEN
                                    ERROR('Can not be approved with DUMMY cost Center selected in Invoice lines...');
                            UNTIL PurchLine.NEXT = 0;

                        joballocation.RESET;
                        joballocation.SETRANGE(joballocation."Document No.", Rec."No.");
                        IF joballocation.FIND('-') THEN
                            REPEAT
                                IF joballocation."Shortcut Dimension 1 Code" = 'DUMMY' THEN
                                    ERROR('Can not be approved with DUMMY cost Center selected in Job allocation...');
                            UNTIL joballocation.NEXT = 0;




                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::Invoice);
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);
                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::Invoice);
                            UserTasksNew.SETRANGE("Sub Document Type", UserTasksNew."Sub Document Type"::" ");
                            UserTasksNew.SETRANGE("Document No", Rec."No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ApprovePO(UserTasksNew);
                        END;

                        //NDALLE 211205


                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."No.");
                        //ND
                    end;
                }
                action(Return)
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        //NDALLE 211205
                        Rec.TESTFIELD("Sent for Approval", TRUE);
                        Rec.TESTFIELD(Approved, FALSE);//ALLECK 040613

                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::Invoice);
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                            "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::Invoice);
                            UserTasksNew.SETRANGE("Sub Document Type", UserTasksNew."Sub Document Type"::" ");
                            UserTasksNew.SETRANGE("Document No", Rec."No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                            IF UserTasksNew.FIND('-') THEN
                                UserTasksNew.ReturnPO(UserTasksNew);
                        END;
                        //NDALLE 211205

                        //ND
                        MESSAGE('Task Successfully Done for Document No. %1', Rec."No.");
                        //ND
                    end;
                }
                action("Return After Approval")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin

                        //ALLECK 040613 START
                        //ALLECK 070613 START
                        MemberOf.RESET;
                        MemberOf.SETRANGE("User Name", USERID);
                        MemberOf.SETRANGE("Role ID", 'A_APPROVALRETURN');
                        IF NOT MemberOf.FINDFIRST THEN
                            ERROR('You do not have permission of Role: A_APPROVALRETURN');
                        //ALLECK 070613 END;

                        Rec.TESTFIELD("Sent for Approval", TRUE);
                        Rec.TESTFIELD(Approved, TRUE);
                        UserTasksNew.RESET;
                        DocTypeApprovalRec.RESET;
                        DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                        DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::Invoice);
                        DocTypeApprovalRec.SETRANGE("Sub Document Type", DocTypeApprovalRec."Sub Document Type"::" ");
                        DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                        DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                        DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::Approved);
                        IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                            UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                                                        "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);
                            UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                            UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::Invoice);
                            UserTasksNew.SETRANGE("Sub Document Type", UserTasksNew."Sub Document Type"::" ");
                            UserTasksNew.SETRANGE("Document No", Rec."No.");
                            UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                            UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                            UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                            UserTasksNew.SETRANGE(Status, UserTasksNew.Status::Approved);
                            IF UserTasksNew.FIND('-') THEN BEGIN
                                UserTasksNew.ReturnPO(UserTasksNew);
                                MESSAGE('Task Successfully Done for Document No. %1', Rec."No.");
                            END;
                        END;
                        //ALLECK 040613 END
                        CurrPage.UPDATE;
                    end;
                }
            }
        }
        addafter(MoveNegativeLines)
        {
            action("Generate Job Allocation Lines")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    JobAllocation: Record "Job Allocation";
                    PLine: Record "Purchase Line";
                begin

                    GenSetup.GET;
                    Rec.TESTFIELD("Default GL Account");
                    JobAllocation.RESET;
                    JobAllocation.SETRANGE("Document Type", Rec."Document Type");
                    JobAllocation.SETRANGE("Document No.", Rec."No.");
                    IF JobAllocation.FIND('-') THEN
                        REPEAT
                            JobAllocation.DELETE;
                        UNTIL JobAllocation.NEXT = 0;


                    PLine.RESET;
                    PLine.SETRANGE("Document Type", Rec."Document Type");
                    PLine.SETRANGE("Document No.", Rec."No.");
                    PLine.SETFILTER(Type, '%1', PLine.Type::"G/L Account");
                    IF PLine.FIND('-') THEN
                        REPEAT
                            JobAllocation.INIT;
                            JobAllocation."Document Type" := Rec."Document Type".AsInteger();
                            JobAllocation."Document No." := Rec."No.";
                            JobAllocation."Line No." := PLine."Line No.";
                            JobAllocation."Allocation Line No." := PLine."Line No.";
                            JobAllocation."GL Account No." := Rec."Default GL Account";
                            JobAllocation.Amount := PLine."Line Amount";
                            JobAllocation."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                            JobAllocation."Shortcut Dimension 2 Code" := PLine."Shortcut Dimension 2 Code";
                            //JobAllocation."Shortcut Dimension 8 Code" := PLine"Shortcut Dimension 8 Code";
                            // ALLE MM Code Commented
                            /*
                            DocDim.RESET;
                            DocDim.SETRANGE(DocDim."Table ID",39  );
                            DocDim.SETRANGE("Document Type","Document Type");
                            DocDim.SETRANGE("Document No.","No.");
                            DocDim.SETRANGE("Line No.",PLine."Line No.");
                            DocDim.SETRANGE("Dimension Code",GenSetup."Shortcut Dimension 3 Code");
                            IF DocDim.FIND('-') THEN
                              JobAllocation."Shortcut Dimension 3 Code":=DocDim."Dimension Value Code";

                            DocDim.SETRANGE("Dimension Code",GenSetup."Shortcut Dimension 4 Code");
                            IF DocDim.FIND('-') THEN
                             JobAllocation."Shortcut Dimension 4 Code":=DocDim."Dimension Value Code";
                            DocDim.SETRANGE("Dimension Code",GenSetup."Shortcut Dimension 8 Code");
                            IF DocDim.FIND('-') THEN
                             JobAllocation."Shortcut Dimension 8 Code":=DocDim."Dimension Value Code";
                             */
                            // ALLE MM Code Commented
                            // ALLE MM Code Added
                            GLSetup.GET;
                            DimSetEntry.RESET;
                            DimSetEntry.SETRANGE("Dimension Set ID", Rec."Dimension Set ID");
                            DimSetEntry.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 3 Code");
                            IF DimSetEntry.FINDFIRST THEN
                                JobAllocation."Shortcut Dimension 3 Code" := DimSetEntry."Dimension Value Code";

                            DimSetEntry.RESET;
                            DimSetEntry.SETRANGE("Dimension Set ID", Rec."Dimension Set ID");
                            DimSetEntry.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 4 Code");
                            IF DimSetEntry.FINDFIRST THEN
                                JobAllocation."Shortcut Dimension 4 Code" := DimSetEntry."Dimension Value Code";

                            DimSetEntry.RESET;
                            DimSetEntry.SETRANGE("Dimension Set ID", Rec."Dimension Set ID");
                            DimSetEntry.SETRANGE("Dimension Code", GLSetup."Shortcut Dimension 8 Code");
                            IF DimSetEntry.FINDFIRST THEN
                                JobAllocation."Shortcut Dimension 4 Code" := DimSetEntry."Dimension Value Code";
                            // ALLE MM Code Added
                            JobAllocation.INSERT(TRUE);
                        UNTIL PLine.NEXT = 0;

                end;
            }
            action("Refresh Milestone Amt")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PaymentTermLine.RESET;
                    PaymentTermLine.SETRANGE("Document Type", Rec."Document Type");
                    PaymentTermLine.SETRANGE("Document No.", Rec."No.");
                    IF PaymentTermLine.FIND('-') THEN BEGIN
                        REPEAT
                            PaymentTermLine.CalculateCriteriaValue;
                            PaymentTermLine.MODIFY;
                        UNTIL PaymentTermLine.NEXT = 0;
                    END;
                end;
            }
        }
        addafter(PostBatch)
        {
            action("Print Sub Contract Bill")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    RecPL.RESET;
                    RecPL.SETRANGE("Document No.", Rec."Order Ref. No.");
                    IF RecPL.FIND('-') THEN
                        REPORT.RUN(97726, TRUE, FALSE, RecPL);
                end;
            }
        }
    }

    var
        myInt: Integer;
        AmountZero: Boolean;
        UserTasksNew: Record "User Tasks New";
        DocTypeApprovalRec: Record "Document Type Approval";
        MemberOf: Record "Access Control";
        DocApproval: Record "Document Type Approval";
        Phdr: Record "Purchase Header";
        vFlag: Boolean;
        DiscountAmt: Decimal;
        glac: Record "G/L Account";
        glacname: Text[30];
        DocInitiator: Record "Document Type Initiator";
        AppAmount: Decimal;
        VLE: Record "Vendor Ledger Entry";
        RetentionAmt: Decimal;
        PaymentTermLine: Record "Payment Terms Line";
        GenSetup: Record "General Ledger Setup";
        joballocation: Record "Job Allocation";
        dimvalue: Record "Dimension Value";
        RecRespCenter: Record "Responsibility Center 1";
        Short1name: Text[50];
        Short2name: Text[50];
        Respname: Text[50];
        Locname: Text[50];
        GLSetup: Record "General Ledger Setup";
        RecPurchRcptLine: Record "Purch. Rcpt. Line";
        RecPL: Record "Purchase Line";
        Accept: Boolean;
        PurchLine2: Record "Purchase Line";
        RecPurchLine: Record "Purchase Line";
        RecPurchLine2: Record "Purchase Line";
        PHead: Record "Purchase Header";
        poRec: Record "Purchase Header";
        PHeadRec: Record "Purchase Header";
        Text007: Label 'Do you want to Send the %1 No.-%2 For Approval';
        DimSetEntry: Record "Dimension Set Entry";
        PurchLine: Record "Purchase Line";

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        IF Rec."Initiator User ID" = '' then
            Rec."Initiator User ID" := UserId;

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Initiator User ID" := UserId;
        Rec."Assigned User ID" := UserId;
        Rec."User ID" := UserId;
        Rec.Initiator := UserId;
    end;
}