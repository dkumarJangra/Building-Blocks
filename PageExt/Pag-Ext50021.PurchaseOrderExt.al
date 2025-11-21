pageextension 50021 "BBG Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
        modify("No.")
        {
            Visible = true;
            ApplicationArea = all;
            Editable = false;
        }
        modify("Buy-from Country/Region Code")
        {
            Visible = false;
        }
        modify("Ship-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Invoice Received Date")
        {
            Visible = false;
        }
        modify("Your Reference")
        {
            Visible = false;
        }
        modify("Quote No.")
        {
            Visible = false;
        }
        modify("Include GST in TDS Base")
        {
            Visible = false;
        }
        modify("Vendor Posting Group")
        {
            Visible = false;
        }
        modify("Remit-to Code")
        {
            Visible = false;
        }
        modify("Ship-to Phone No.")
        {
            Visible = false;
        }
        modify("GST Invoice")
        {
            Visible = false;
        }
        modify("POS Out Of India")
        {
            Visible = false;
        }
        modify("POS as Vendor State")
        {
            Visible = false;
        }
        modify("Nature of Supply")
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
            Visible = false;
        }
        addbefore("No.")
        {
            field("Workflow Sub Document Type"; Rec."Workflow Sub Document Type")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
        // addafter(General)
        // {
        //     group("BBG Fields")
        //     {

        //         field("Initiator User ID"; Rec."Initiator User ID")
        //         {
        //             ApplicationArea = all;
        //         }
        //         field("Vendor Quotation Date"; Rec."Vendor Quotation Date")
        //         {
        //             ApplicationArea = All;
        //         }
        //         field(Amended; Rec.Amended)
        //         {
        //             ApplicationArea = All;
        //         }
        //         field("Amendment Approved"; Rec."Amendment Approved")
        //         {
        //             ApplicationArea = All;
        //         }
        //         field("Amendment Approved Date"; Rec."Amendment Approved Date")
        //         {
        //             ApplicationArea = All;
        //         }
        //         field("Amendment Approved Time"; Rec."Amendment Approved Time")
        //         {
        //             ApplicationArea = All;
        //         }
        //         field("Amendment Initiator"; Rec."Amendment Initiator")
        //         {
        //             ApplicationArea = All;
        //         }
        //     }
        // }
        addafter(General)
        {
            group("Terms & Condition")
            {
                Visible = false;
                part("Sales Tax"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST("Sales Tax"),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Excise Duty"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST("Excise Duty"),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Temrs of Payment"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST(Payment),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Service Tax"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST("Service Tax"),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Transit Insurance"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST(Insurance),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Inspection Remarks"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST("Inspection Authority"),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Packaging && Forwarding"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST("Packaging & Forwarding"),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("F.O.R"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST("F.O.R"),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part(Delivery; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST(Delivery),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Price Basis"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST("Price Basis"),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Freight Terms"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST(Freight),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("DD Comm/Bank Charges"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST("DD Comm/Bank Charges"),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Warranty/Guarantee Terms"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST("Warranty/Guarantee Certificate"),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Entry Tax/Octroi Terms"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST("Entry Tax/Octroi Tax"),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Installation Terms"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST("Installation Terms"),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part("Service Tax-Installation"; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST("Service Tax-Installation"),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
                part(Instructions; "Terms list")
                {
                    SubPageLink = "Document Type" = FIELD("Document Type"),
                                      "Term Type" = CONST(Instructions),
                                      "Document No." = FIELD("No.");
                    ApplicationArea = All;
                }
            }
        }

        moveafter("Buy-from Address 2"; "Buy-from Post Code")
        addbefore("Document Date")
        {
            field("Starting Date"; Rec."Starting Date")
            {
                ApplicationArea = All;
            }
            field("Ending Date"; Rec."Ending Date")
            {
                ApplicationArea = All;
            }
        }
        movebefore("Starting Date"; "Order Date")
        movebefore("Order Date"; "Posting Date")
        movebefore("Posting Date"; "No. of Archived Versions")
        addafter("Document Date")
        {
            field("Order Status"; Rec."Order Status")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Order Status"; "Shortcut Dimension 1 Code")
        addafter("Shortcut Dimension 1 Code")
        {
            field("Job No."; Rec."Job No.")
            {
                Editable = true;
                ApplicationArea = All;
            }
        }
        moveafter("Job No."; "Responsibility Center")
        moveafter("Responsibility Center"; "Location Code")
        moveafter("Location Code"; "Shortcut Dimension 2 Code")
        moveafter("Shortcut Dimension 2 Code"; Status)
        addafter(Status)
        {
            field("GST Reason Type"; Rec."GST Reason Type")
            {
                ApplicationArea = All;
            }
        }
        addafter("GST Reason Type")
        {
            field("Initiator of this document is"; Rec.Initiator)
            {
                Editable = false;
                ApplicationArea = All;
            }
            field("Quantity for PO"; Rec."Quantity for PO")
            {
                ApplicationArea = All;
            }
        }



        addfirst("Invoice Details")
        {
            field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Pay-to Vendor No."; "Pay-to Contact No.")
        moveafter("Pay-to Contact No."; "Pay-to Name")
        moveafter("Pay-to Name"; "Pay-to Address")
        moveafter("Pay-to Address"; "Pay-to Address 2")
        moveafter("Pay-to Address 2"; "Pay-to Post Code")
        moveafter("Pay-to Post Code"; "Pay-to City")
        moveafter("Pay-to City"; "Pay-to Contact")
        moveafter("Pay-to Contact"; "Payment Terms Code")
        moveafter("Payment Terms Code"; "Due Date")
        moveafter("Due Date"; "Payment Discount %")
        moveafter("Payment Discount %"; "Pmt. Discount Date")
        moveafter("Pmt. Discount Date"; "Payment Method Code")
        moveafter("Payment Method Code"; "Payment Reference")
        moveafter("Payment Reference"; "Creditor No.")
        moveafter("Creditor No."; "On Hold")
        moveafter("On Hold"; "Prices Including VAT")
        moveafter("Prices Including VAT"; "VAT Bus. Posting Group")
        addafter("VAT Bus. Posting Group")
        {
            field("Billing Location"; Rec."Billing Location")
            {
                ApplicationArea = All;
            }
        }



        movebefore("Ship-to Name"; "Buy-from Contact")
        movebefore("Buy-from Contact"; "Buy-from Contact No.")
        moveafter("Ship-to Address 2"; "Ship-to Post Code")
        moveafter("Ship-to Post Code"; "Ship-to Contact")
        moveafter("Ship-to Contact"; "Ship-to City")
        addafter("Ship-to City")
        {
            field("Location Name"; Locname)
            {
                ApplicationArea = All;
            }
        }
        moveafter("Location Name"; "Inbound Whse. Handling Time")
        moveafter(PayToOptions; "Shipment Method Code")
        moveafter("Shipment Method Code"; "Lead Time Calculation")
        moveafter("Lead Time Calculation"; "Requested Receipt Date")
        moveafter("Requested Receipt Date"; "Promised Receipt Date")
        moveafter("Promised Receipt Date"; "Expected Receipt Date")
        moveafter("Expected Receipt Date"; "Sell-to Customer No.")
        moveafter("Sell-to Customer No."; "Ship-to Code")
        moveafter("Ship-to Code"; "Bill to-Location(POS)")



        movebefore("Transport Method"; "Transaction Specification")
        movebefore("Transaction Type"; "Currency Code")


        addfirst("Tax Information")
        {
            field(Trading; Rec.Trading)
            {
                ApplicationArea = all;
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
                ApplicationArea = all;
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
                ApplicationArea = all;
            }
        }
        moveafter("Shipping Agent Service Code"; "Distance (Km)")
        addafter("Distance (Km)")
        {
            field("Reference Invoice No."; Rec."Reference Invoice No.")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Reference Invoice No."; "Rate Change Applicable")
        moveafter("Rate Change Applicable"; "Supply Finish Date")
        moveafter("Supply Finish Date"; "Payment Date")
        addafter("Payment Date")
        {
            group(BBGApproval)
            {
                Caption = 'Approval';
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
            }
        }
        moveafter("Approved Time"; "Assigned User ID")
        addafter("Assigned User ID")
        {
            field(Initiator; Rec.Initiator)
            {
                ApplicationArea = All;
            }
            field("Purch. Req. No."; Rec."Indent No.")
            {
                ApplicationArea = All;
            }
            field("Enquiry No."; Rec."Enquiry No.")
            {
                ApplicationArea = All;
            }
            field("Award Note No."; Rec."Award Note No.")
            {
                ApplicationArea = All;
            }
            field("Store PO/WO No."; Rec."Store PO/WO No.")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Store PO/WO No."; "Quote No.")
        addafter("Quote No.")
        {
            field(Name; Short1name)
            {
                ApplicationArea = All;
            }
            field("Vendor Quote No."; Rec."Vendor Quote No.")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Vendor Quote No."; "Job Queue Status")
        addafter("Job Queue Status")
        {
            field(Remarks; Rec."Your Reference")
            {
                Caption = 'Remarks';
                ApplicationArea = All;
            }
        }
        moveafter(Remarks; "Vendor Order No.")
        moveafter("Vendor Order No."; "Vendor Shipment No.")
        moveafter("Vendor Shipment No."; "Vendor Invoice No.")
        addafter("Vendor Invoice No.")
        {
            field("Alternate Address"; Rec."Order Address Code")
            {
                Caption = 'Alternate Address';
                Visible = true;
                Importance = Additional;
                ApplicationArea = All;
            }
            field("Renposibility Center Name"; Respname)
            {
                ApplicationArea = All;
            }
        }
        moveafter("Renposibility Center Name"; "Purchaser Code")
    }

    actions
    {
        // Add changes to page actions here
        addafter("O&rder")
        {
            group(Document)
            {
                Caption = 'Document';
                action("Import File")
                {
                    ApplicationArea = All;
                }
                action("Open File")
                {
                    ApplicationArea = All;
                }
                action("Delete File")
                {
                    ApplicationArea = All;
                }
                action("Purchase Rate History")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        NewPurchLine.RESET;
                        NewPurchLine.SETCURRENTKEY("Document Type", "Document No.", "Location Code", "Shortcut Dimension 1 Code");
                        NewPurchLine.SETRANGE(NewPurchLine."Document No.", Rec."No.");
                        IF NewPurchLine.FINDFIRST THEN
                            REPORT.RUN(97818, TRUE, FALSE, NewPurchLine);
                    end;
                }
            }
        }
        addafter("Co&mments")
        {
            action("PO Terms and Conditions")
            {
                Caption = 'PO Terms and Conditions';
                RunObject = Page "PO Terms & Conditions";
                RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No.");
                ApplicationArea = All;
            }
        }


        addafter(Comment)
        {
            action("Send for Approval")
            {
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PurchLine: Record "Purchase Line";
                begin
                    IF Rec."Land Document No." <> '' THEN
                        CheckTotalPOLineQty; //ALLESSS 19/03/24
                                             //JPL START
                    IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                        ERROR(' Please check, Region Dimension code is different from Responsibility Center code');

                    IF Rec.Initiator <> UPPERCASE(USERID) THEN
                        ERROR('Un-Authorized Initiator');
                    Rec.TESTFIELD("Ending Date");
                    PurchLine.CheckPOSendForApprovalFields(Rec);        // ALLEPG 100409
                                                                        //May 1.0 Start
                                                                        //To restrict user not to alter the rate coming from the job master file...

                    PurchLine.RESET;
                    JobCdCheck := FALSE;
                    DesCheck := FALSE;
                    BudgetCheck := FALSE;
                    TdsCheck := FALSE;
                    AskTds := FALSE;
                    //ALLE PS Code commented for Direct PO
                    IF Rec."Sub Document Type" <> Rec."Sub Document Type"::"Direct PO" THEN BEGIN
                        PurchLine.SETRANGE(PurchLine."Document Type", PurchLine."Document Type"::Order);
                        PurchLine.SETRANGE(PurchLine."Document No.", Rec."No.");
                        PurchLine.SETRANGE(PurchLine.Type, PurchLine.Type::"G/L Account");
                        IF PurchLine.FIND('-') THEN
                            REPEAT
                                IF (PurchLine.Description <> '') AND (PurchLine."Job Code" = '') THEN
                                    JobCdCheck := TRUE;
                                IF (PurchLine.Description = '') AND (PurchLine."Job Code" <> '') THEN
                                    DesCheck := TRUE;
                                IF (PurchLine."Job Code" <> '') AND (PurchLine."TDS Section Code" = '') THEN
                                    TdsCheck := TRUE;

                                jobmaster.GET(PurchLine."Job Code");


                            UNTIL PurchLine.NEXT = 0;


                        IF JobCdCheck THEN
                            MESSAGE('Job Code should not be left blank incase of Non ICB WO ...');
                    END;
                    //ALLE PS Ends
                    IF DesCheck THEN
                        MESSAGE('Description can not be left blank in any line...');

                    IF BudgetCheck THEN
                        ERROR('Budget Line Can Not be left blank in any line...');

                    IF TdsCheck THEN
                        AskTds := CONFIRM('Send for Approval without mentioning TDS nature of Deduction ?')
                    ELSE
                        AskTds := TRUE;

                    IF NOT AskTds THEN
                        ERROR('Enter TDS Nature of Deduction...');


                    //May 1.0 END

                    //NDALLE191207 >>

                    PurchLine.RESET;
                    PurchLine.SETRANGE(PurchLine."Document Type", PurchLine."Document Type"::Order);
                    PurchLine.SETRANGE(PurchLine."Document No.", Rec."No.");
                    IF PurchLine.FINDFIRST THEN
                        REPEAT
                            PurchLine.TESTFIELD(Quantity);
                            PurchLine.TESTFIELD("Direct Unit Cost");
                            IF PurchLine.Type = PurchLine.Type::"Fixed Asset" THEN
                                PurchLine.TESTFIELD("Depreciation Book Code");
                        // ALLEPG 091211 Start
                        /*
                        //ALLETG RIL0011 22-06-2011: START>>
                        PurchDeliverySchedule.RESET;
                        PurchDeliverySchedule.SETRANGE("Document Type",PurchLine."Document Type");
                        PurchDeliverySchedule.SETRANGE("Document No.",PurchLine."Document No.");
                        PurchDeliverySchedule.SETRANGE("Document Line No.",PurchLine."Line No.");
                        IF PurchDeliverySchedule.FINDSET THEN
                          PurchDeliverySchedule.CALCSUMS("Schedule Quantity");
                        IF PurchLine.Quantity <> PurchDeliverySchedule."Schedule Quantity" THEN
                          ERROR('Purchase Line Quantity has to equal to its Delivery Schedule Quantity in Purchase Line No. %1',PurchLine."Line No.");
                        //ALLETG RIL0011 22-06-2011: END<<
                        */
                        // ALLEPG 091211 End
                        UNTIL PurchLine.NEXT = 0;
                    //NDALLE191207 <<

                    Rec.TESTFIELD("Sent for Approval", FALSE);
                    IF Rec."Sent for Approval" = FALSE THEN BEGIN
                        Rec.VALIDATE("Sent for Approval", TRUE);

                        //ALLE-PKS16
                        Accept := CONFIRM(Text007, TRUE, 'Purchase order', Rec."No.");
                        IF NOT Accept THEN EXIT;
                        //ALLE-PKS16

                        Rec."Sent for Approval Date" := TODAY;
                        Rec."Sent for Approval Time" := TIME;
                        Rec.MODIFY;
                        UserTasksNew.AuthorizationPO(UserTasksNew."Transaction Type"::Purchase, UserTasksNew."Document Type"::"Purchase Order",
                        Rec."Sub Document Type", Rec."No.");

                        //CurrForm.UPDATE(TRUE);
                    END;
                    //JPL STOP

                    //ND
                    MESSAGE('Task Successfully Done for Document No. %1', Rec."No.");
                    //ND

                end;
            }
            action("Approve (Customized)")
            {
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                var
                    PurchLine: Record "Purchase Line";
                begin

                    IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                        ERROR(' Please check, Region Dimension code is different from Responsibility Center code');

                    Rec.TESTFIELD("Sent for Approval", TRUE);
                    Rec.TESTFIELD(Approved, FALSE);

                    //ALLETG RIL0011 23-06-2011: START>>
                    PurchLine.RESET;
                    PurchLine.SETRANGE(PurchLine."Document Type", PurchLine."Document Type"::Order);
                    PurchLine.SETRANGE(PurchLine."Document No.", Rec."No.");
                    IF PurchLine.FINDFIRST THEN
                        REPEAT
                            PurchLine.TESTFIELD(Quantity);
                            PurchLine.TESTFIELD("Direct Unit Cost");
                            IF PurchLine.Type = PurchLine.Type::"Fixed Asset" THEN BEGIN
                                PurchLine.TESTFIELD("Depreciation Book Code");
                                PurchLine.TESTFIELD(PurchLine."Duplicate in Depreciation Book");
                            END;
                            // RIL1.06 080911 End
                            PurchLine.TESTFIELD("Shortcut Dimension 2 Code");
                        // ALLEPG 091211 Start
                        /*
                        PurchDeliverySchedule.RESET;
                        PurchDeliverySchedule.SETRANGE("Document Type",PurchLine."Document Type");
                        PurchDeliverySchedule.SETRANGE("Document No.",PurchLine."Document No.");
                        PurchDeliverySchedule.SETRANGE("Document Line No.",PurchLine."Line No.");
                        IF PurchDeliverySchedule.FINDSET THEN
                          PurchDeliverySchedule.CALCSUMS("Schedule Quantity");
                        IF PurchLine.Quantity <> PurchDeliverySchedule."Schedule Quantity" THEN
                          ERROR('Purchase Line Quantity has to equal to its Delivery Schedule Quantity in Purchase Line No. %1',PurchLine."Line No.");
                        */
                        // ALLEPG 091211 End
                        UNTIL PurchLine.NEXT = 0;
                    //ALLETG RIL0011 23-06-2011: END<<

                    UserTasksNew.RESET;
                    DocTypeApprovalRec.RESET;
                    DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                    DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Purchase Order");
                    DocTypeApprovalRec.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                    DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                    DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                    DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                    IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                        UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                        "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                        UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                        UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Purchase Order");
                        UserTasksNew.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        UserTasksNew.SETRANGE("Document No", Rec."No.");
                        UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                        UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                        UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                        UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                        IF UserTasksNew.FIND('-') THEN
                            UserTasksNew.ApprovePO(UserTasksNew);
                    END;
                    IF Rec.Approved = TRUE THEN
                        CurrPage.EDITABLE(FALSE);

                end;
            }
            action(Return)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                    Rec.TESTFIELD("Sent for Approval", TRUE);
                    Rec.TESTFIELD(Approved, FALSE);

                    UserTasksNew.RESET;
                    DocTypeApprovalRec.RESET;
                    DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                    DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Purchase Order");
                    DocTypeApprovalRec.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                    DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                    DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                    DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                    IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                        UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                        "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                        UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                        UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Purchase Order");
                        UserTasksNew.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        UserTasksNew.SETRANGE("Document No", Rec."No.");
                        UserTasksNew.SETRANGE(Initiator, Rec.Initiator);
                        UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                        UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                        UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                        IF UserTasksNew.FIND('-') THEN
                            UserTasksNew.ReturnPO(UserTasksNew);
                    END;
                end;
            }
            action("Amend PO")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    DocSetup: Record "Document Type Setup";
                    DocInitiator: Record "Document Type Initiator";
                    DocApproval: Record "Document Type Approval";
                    DocumentApproval: Record "Document Type Approval";
                begin

                    //AlleDK 180809
                    PurchCommentLine.RESET;
                    PurchCommentLine.SETRANGE("Document Type", Rec."Document Type");
                    PurchCommentLine.SETRANGE(PurchCommentLine."No.", Rec."No.");
                    PurchCommentLine.SETRANGE(Date, TODAY);
                    IF NOT PurchCommentLine.FINDFIRST THEN
                        ERROR(Text50003);

                    //AlleDK 180809



                    //JPL START
                    IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                        ERROR(' Please check, Region Dimension code is different from Responsibility Center code');


                    IF Rec."Document Type" = Rec."Document Type"::Order THEN BEGIN
                        Rec.TESTFIELD(Approved, TRUE);
                        IF Rec."Amendment Approved" = FALSE THEN BEGIN
                            Rec.TESTFIELD(Amended, FALSE);
                            //ALLE-PKS16
                            Ammend := CONFIRM(Text008, TRUE, 'Purchase order', Rec."No.");
                            IF NOT Ammend THEN EXIT;
                            //ALLE-PKS16

                            Rec.Amended := TRUE;
                            Rec."Amendment Initiator" := USERID;
                            Rec.MODIFY;

                            DocSetup.RESET;
                            DocSetup.SETRANGE("Document Type", DocSetup."Document Type"::"Purchase Order Amendment");
                            DocSetup.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                            DocSetup.SETRANGE("Approval Required", TRUE);
                            IF DocSetup.FIND('-') THEN BEGIN
                                DocInitiator.GET(DocSetup."Document Type"::"Purchase Order Amendment", Rec."Sub Document Type", Rec."Amendment Initiator");

                                DocApproval.RESET;
                                DocApproval.SETRANGE("Document Type", DocSetup."Document Type"::"Purchase Order Amendment");
                                DocApproval.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                                DocApproval.SETFILTER("Document No", '%1', '');
                                DocApproval.SETRANGE(Initiator, Rec."Amendment Initiator");
                                IF DocApproval.FIND('-') THEN
                                    REPEAT
                                        DocumentApproval.INIT;
                                        DocumentApproval.COPY(DocApproval);
                                        DocumentApproval."Document No" := Rec."No.";
                                        DocumentApproval.INSERT;
                                    UNTIL DocApproval.NEXT = 0;
                            END;

                            UserTasksNew.AuthorizationPO(UserTasksNew."Transaction Type"::Purchase,
                              UserTasksNew."Document Type"::"Purchase Order Amendment", Rec."Sub Document Type", Rec."No.");
                            //??
                            Memberof.RESET;
                            Memberof.SETRANGE("User Name", USERID);
                            Memberof.SETFILTER("Role ID", 'POARCHIVE');
                            IF Memberof.FIND('-') THEN
                                ArchiveManagement.ArchivePurchDocument(Rec)
                            ELSE BEGIN
                                CLEAR(ArchivePO);
                                ArchivePO.ArchivePurchDocument(Rec);
                            END;
                            //CurrForm.UPDATE(TRUE);
                        END;
                        IF Rec."Amendment Approved" = TRUE THEN BEGIN
                            Rec.Amended := TRUE;
                            Rec."Amendment Initiator" := USERID;
                            Rec."Amendment Approved" := FALSE;
                            Rec."Amendment Approved Date" := 0D;
                            Rec."Amendment Approved Time" := 0T;
                            Rec.MODIFY;

                            DocSetup.RESET;
                            DocSetup.SETRANGE("Document Type", DocSetup."Document Type"::"Purchase Order Amendment");
                            DocSetup.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                            DocSetup.SETRANGE("Approval Required", TRUE);
                            IF DocSetup.FIND('-') THEN BEGIN
                                DocInitiator.GET(DocSetup."Document Type"::"Purchase Order Amendment", Rec."Sub Document Type", Rec."Amendment Initiator");

                                DocApproval.RESET;
                                DocApproval.SETRANGE("Document Type", DocSetup."Document Type"::"Purchase Order Amendment");
                                DocApproval.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                                DocApproval.SETFILTER("Document No", '%1', Rec."No.");
                                DocApproval.SETRANGE(Initiator, Rec."Amendment Initiator");
                                IF DocApproval.FIND('-') THEN
                                    REPEAT
                                        DocApproval.DELETE;
                                    UNTIL DocApproval.NEXT = 0;

                                DocApproval.RESET;
                                DocApproval.SETRANGE("Document Type", DocSetup."Document Type"::"Purchase Order Amendment");
                                DocApproval.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                                DocApproval.SETFILTER("Document No", '%1', '');
                                DocApproval.SETRANGE(Initiator, Rec."Amendment Initiator");
                                IF DocApproval.FIND('-') THEN
                                    REPEAT
                                        DocumentApproval.INIT;
                                        DocumentApproval.COPY(DocApproval);
                                        DocumentApproval."Document No" := Rec."No.";
                                        DocumentApproval.INSERT;
                                    UNTIL DocApproval.NEXT = 0;
                            END;

                            UserTasksNew.AuthorizationPO(UserTasksNew."Transaction Type"::Purchase,
                              UserTasksNew."Document Type"::"Purchase Order Amendment", Rec."Sub Document Type", Rec."No.");

                            CLEAR(ArchivePO);
                            ArchivePO.ArchivePurchDocument(Rec);
                            //CurrForm.UPDATE(TRUE);
                        END;

                    END;
                    //JPL STOP
                end;
            }
            action("Approve Amended PO")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    PurchLine: Record "Purchase Line";
                begin

                    IF Rec."Shortcut Dimension 1 Code" <> Rec."Responsibility Center" THEN
                        ERROR(' Please check, Region Dimension code is different from Responsibility Center code');


                    Rec.TESTFIELD(Approved, TRUE);
                    Rec.TESTFIELD("Amendment Approved", FALSE);
                    Rec.TESTFIELD(Amended, TRUE);

                    //ALLETG RIL0011 23-06-2011: START>>
                    PurchLine.RESET;
                    PurchLine.SETRANGE(PurchLine."Document Type", PurchLine."Document Type"::Order);
                    PurchLine.SETRANGE(PurchLine."Document No.", Rec."No.");
                    IF PurchLine.FINDFIRST THEN
                        REPEAT
                            PurchLine.TESTFIELD(Quantity);
                            PurchLine.TESTFIELD("Direct Unit Cost");
                            IF PurchLine.Type = PurchLine.Type::"Fixed Asset" THEN
                                PurchLine.TESTFIELD("Depreciation Book Code");
                        // RIL1.16 080112 Start
                        /*
                        PurchDeliverySchedule.RESET;
                        PurchDeliverySchedule.SETRANGE("Document Type",PurchLine."Document Type");
                        PurchDeliverySchedule.SETRANGE("Document No.",PurchLine."Document No.");
                        PurchDeliverySchedule.SETRANGE("Document Line No.",PurchLine."Line No.");
                        IF PurchDeliverySchedule.FINDSET THEN
                          PurchDeliverySchedule.CALCSUMS("Schedule Quantity");
                        IF PurchLine.Quantity <> PurchDeliverySchedule."Schedule Quantity" THEN
                          ERROR('Purchase Line Quantity has to equal to its Delivery Schedule Quantity in Purchase Line No. %1',PurchLine."Line No.");
                        */
                        // RIL1.16 080112 End
                        UNTIL PurchLine.NEXT = 0;
                    //ALLETG RIL0011 23-06-2011: END<<

                    UserTasksNew.RESET;
                    DocTypeApprovalRec.RESET;
                    DocTypeApprovalRec.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, Status);
                    DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Purchase Order Amendment");
                    DocTypeApprovalRec.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                    DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                    //DocTypeApprovalRec.SETRANGE(Initiator,Initiator);
                    DocTypeApprovalRec.SETRANGE(Initiator, Rec."Amendment Initiator");
                    DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                    IF DocTypeApprovalRec.FIND('-') THEN BEGIN

                        UserTasksNew.SETCURRENTKEY("Transaction Type", "Document Type", "Sub Document Type", Initiator, "Document No",
                        "Document Approval Line No", "Approvar ID", "Alternate Approvar ID", Status);

                        UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                        UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Purchase Order Amendment");
                        UserTasksNew.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        UserTasksNew.SETRANGE("Document No", Rec."No.");
                        UserTasksNew.SETRANGE(Initiator, Rec."Amendment Initiator");
                        UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                        UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                        UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                        IF UserTasksNew.FIND('-') THEN
                            UserTasksNew.ApprovePO(UserTasksNew);
                    END;

                end;
            }
            action("Return Amended PO")
            {
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin

                    Rec.TESTFIELD(Approved, TRUE);
                    Rec.TESTFIELD("Amendment Approved", FALSE);
                    Rec.TESTFIELD(Amended, TRUE);

                    UserTasksNew.RESET;
                    DocTypeApprovalRec.RESET;
                    DocTypeApprovalRec.SETRANGE("Document Type", DocTypeApprovalRec."Document Type"::"Purchase Order Amendment");
                    DocTypeApprovalRec.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                    DocTypeApprovalRec.SETRANGE("Document No", Rec."No.");
                    DocTypeApprovalRec.SETRANGE(Initiator, Rec.Initiator);
                    DocTypeApprovalRec.SETRANGE(Status, DocTypeApprovalRec.Status::" ");
                    IF DocTypeApprovalRec.FIND('-') THEN BEGIN
                        UserTasksNew.SETRANGE("Transaction Type", UserTasksNew."Transaction Type"::Purchase);
                        UserTasksNew.SETRANGE("Document Type", UserTasksNew."Document Type"::"Purchase Order Amendment");
                        UserTasksNew.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                        UserTasksNew.SETRANGE("Document No", Rec."No.");
                        UserTasksNew.SETRANGE(Initiator, Rec."Amendment Initiator");
                        UserTasksNew.SETRANGE("Document Approval Line No", DocTypeApprovalRec."Line No");
                        UserTasksNew.SETRANGE("Approvar ID", DocTypeApprovalRec."Approvar ID");
                        UserTasksNew.SETRANGE(Status, UserTasksNew.Status::" ");
                        IF UserTasksNew.FIND('-') THEN
                            UserTasksNew.ReturnPO(UserTasksNew);
                    END;
                end;
            }

        }
    }

    var
        myInt: Integer;
        FormMilestone: Page "Update Milestone Code";
        optionTransactionType: Option Sale,Purchase;
        Selection: Integer;
        UserTasksNew: Record "User Tasks New";
        DocTypeApprovalRec: Record "Document Type Approval";
        GLBudgetName: Record "G/L Budget Name";
        PaymnetTermLine: Record "Payment Terms Line";
        PurchHeader1: Record "Purchase Header";
        PurchLine1: Record "Purchase Line";
        IndentLine: Record "Purchase Request Line";
        StdText: Record "Standard Text";
        StdTextF: Page "Standard Text Codes";
        ArchivePO: Report "Archive Purchase Document";
        ArchiveManagement: Codeunit ArchiveManagement;
        Memberof: Record "Access Control";
        DocApproval: Record "Document Type Approval";
        vFlag: Boolean;
        Phdr: Record "Purchase Header";
        DiscountAmt: Decimal;
        CostName: Text[120];
        Dept: Text[120];
        DimValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        POEmp: Record Employee;
        UsrEmp: Record Employee;
        JobCdCheck: Boolean;
        DesCheck: Boolean;
        BudgetCheck: Boolean;
        TdsCheck: Boolean;
        AskTds: Boolean;
        jobmaster: Record "Job Master";
        Short1name: Text[50];
        Respname: Text[50];
        Locname: Text[50];
        RecDimValue: Record "Dimension Value";
        RecLocation: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        RecUserSetup: Record "User Setup";
        PurchHdr: Record "Purchase Header";
        Accept: Boolean;
        Ammend: Boolean;
        NewPurchLine: Record "Purchase Line";
        PurchCommentLine: Record "Purch. Comment Line";
        TempPurchHeader: Record "Purchase Header";
        DlvrSchdQtyCheck: Boolean;
        PurchDeliverySchedule: Record "Purch. Delivery Schedule";
        Text007: Label 'Do you want to Send the %1 No.-%2 For Approval';
        Text008: Label 'Do you want to Send the %1 No.-%2 For Ammend';
        Text50003: Label 'You must specify Comment';
        Text50004: Label 'Cancel,Short Close';

    trigger OnAfterGetRecord()
    begin
        DiscountAmt := 0;

        //CurrPage.UPDATECONTROLS;
        //JPL55 STOP
        GLSetup.GET;
        //SC 130206
        CostName := '';
        Dept := '';
        Short1name := '';
        IF Rec."Shortcut Dimension 1 Code" <> '' THEN BEGIN
            IF DimValue.GET(GLSetup."Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code") THEN BEGIN
                Short1name := DimValue.Name;
                CostName := DimValue.Name;
            END;
        END;
        IF Rec."Shortcut Dimension 2 Code" <> '' THEN BEGIN
            IF DimValue.GET(GLSetup."Shortcut Dimension 2 Code", Rec."Shortcut Dimension 2 Code") THEN
                Dept := DimValue.Name;
        END;

        //SC
        //ALLEND 191107
        Respname := '';
        Locname := '';
        IF RecRespCenter.GET(Rec."Responsibility Center") THEN BEGIN
            Respname := RecRespCenter.Name;
            //Short1name := RecRespCenter."Region Name";
            Locname := RecRespCenter."Location Name";
        END;
        //CurrPage.UPDATECONTROLS; // ALLE MM Code Commented
        //ALLEND 191107
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //JPL55 START
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT Memberof.FIND('-') THEN BEGIN
            IF Rec.Amended = FALSE THEN BEGIN
                Rec.TESTFIELD(Approved, FALSE);
            END;
            IF Rec.Amended THEN BEGIN
                Rec.TESTFIELD(Approved, TRUE);
                Rec.TESTFIELD("Amendment Approved", FALSE);
            END;
        END;
        //JPL55 STOP
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        //JPL55 START
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETFILTER("Role ID", 'SUPERPO');
        IF NOT Memberof.FIND('-') THEN BEGIN
            IF Rec.Amended = FALSE THEN BEGIN
                Rec.TESTFIELD(Approved, FALSE);
            END;
            IF Rec.Amended THEN BEGIN
                Rec.TESTFIELD(Approved, TRUE);
                Rec.TESTFIELD("Amendment Approved", FALSE);
            END;
        END;
        //JPL55 STOP
    end;

    LOCAL PROCEDURE CheckTotalPOLineQty()
    VAR
        TotalPurchaseLine: Record "Purchase Line";
        TotalPurchLineQty: Decimal;
        QuantityEqualsErr: Label 'Total Quantity on Purchase Line should be equals to Quantity For PO %1  , current total line Quantity is %2.';
    BEGIN
        //ALLESSS 19/03/24---BEGIN
        CLEAR(TotalPurchLineQty);
        TotalPurchaseLine.RESET;
        TotalPurchaseLine.SETRANGE("Document Type", Rec."Document Type");
        TotalPurchaseLine.SETRANGE("Document No.", Rec."No.");
        TotalPurchaseLine.SETRANGE(Type, TotalPurchaseLine.Type::Item);
        IF TotalPurchaseLine.FINDSET THEN BEGIN
            TotalPurchaseLine.CALCSUMS(Quantity);
            TotalPurchLineQty := TotalPurchaseLine.Quantity;
        END;
        IF TotalPurchLineQty < Rec."Quantity for PO" THEN
            ERROR(QuantityEqualsErr, Rec."Quantity for PO", TotalPurchLineQty);
        //ALLESSS 19/03/24---END
    END;

}