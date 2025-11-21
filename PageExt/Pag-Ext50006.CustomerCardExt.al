pageextension 50006 "BBG Customer Card Ext" extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        modify(Name)
        {
            Enabled = NameVisible;
            Editable = NameVisible;
        }
        modify("Gen. Bus. Posting Group")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("Customer Posting Group")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify(Address)
        {
            Visible = AddVisible;
        }
        modify("Address 2")
        {
            Visible = AddVisible;
        }
        modify("Phone No.")
        {
            Visible = PhVisible;
        }
        modify("Primary Contact No.")
        {
            Visible = False;
        }
        modify("Tax Liable")
        {
            ShowMandatory = true;
        }
        modify("Aggregate Turnover")
        {
            ApplicationArea = all;
            Visible = true;
        }

        //AlleDG
        modify(MobilePhoneNo)
        {
            Visible = false;
        }
        modify("Bill-to Customer No.")
        {
            Caption = 'Bill-to Customer No.';
        }
        modify("VAT Bus. Posting Group")
        {
            ShowMandatory = true;
        }
        modify(BalanceAsVendor)
        {
            Visible = false;
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify(TotalSales2)
        {
            Visible = false;
        }
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        modify(AdjCustProfit)
        {
            Visible = false;
        }
        modify("CustSalesLCY - CustProfit - AdjmtCostLCY")
        {
            Visible = false;
        }
        modify(AdjProfitPct)
        {
            Visible = false;
        }
        modify("Disable Search by Name")
        {
            Visible = false;
        }
        modify("Format Region")
        {
            Visible = false;
        }
        modify(ContactName)
        {
            Visible = false;
        }
        modify("EORI Number")
        {
            Visible = false;
        }
        modify("Use GLN in Electronic Document")
        {
            Visible = false;
        }
        modify("Registration Number")
        {
            Visible = false;
        }
        modify("Intrastat Partner Type")
        {
            Visible = false;
        }
        modify("Exclude from Pmt. Practices")
        {
            Visible = false;
        }
        modify("Ship-to Code")
        {
            Visible = false;
        }
        modify("Shipment Method Code")
        {
            Caption = 'Shipment Method Code';
        }
        modify("Shipping Agent Code")
        {
            Caption = 'Shipping Agent Code';
        }
        modify("Shipping Agent Service Code")
        {
            Caption = 'Shipping Agent Service Code';
        }
        modify("Assessee Code")
        {
            Visible = false;
        }
        modify("Service Zone Code")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Address & Contact")
        {
            Caption = 'Communication';
        }
        //AlleDG


        // addlast(General)
        // {
        //     group("BBG Fields")
        //     {
        //         Caption = 'BBG Fields';

        //         field("BBG Address 3"; Rec."BBG Address 3")
        //         {
        //             ApplicationArea = all;
        //             Visible = AddVisible;
        //         }
        //         field(Contact; Rec.Contact)
        //         {
        //             ApplicationArea = all;
        //             Visible = ContactVisible;
        //         }
        //         field("BBG Mobile No."; Rec."BBG Mobile No.")
        //         {
        //             ApplicationArea = all;
        //             trigger OnValidate()
        //             var
        //                 ExitMessage: Boolean;
        //             begin
        //                 IF Rec."BBG Mobile No." <> '' THEN
        //                     ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Rec."BBG Mobile No.", TRUE);
        //             end;
        //         }

        //         // part("Lead Inducation Details"; "Lead Inducation Details")
        //         // {
        //         //     SubPageLink = "Document No." = FIELD("No."),
        //         //             "Document Type" = CONST(Customer);
        //         //     PagePartID =Page 60729;
        //         // }
        //         field("BBG Phone No. 2"; Rec."BBG Phone No. 2")
        //         {
        //             ApplicationArea = all;
        //             Visible = Ph2Visible;
        //         }

        //     }
        // }


        addafter(General)
        {
            group("BBG Document Approval Details")
            {
                Caption = 'Document Approval Details';
                part("Document Approval Details"; "Document Approval Details")
                {
                    SubPageLink = "Document No." = FIELD("No."),
                            "Document Type" = CONST(Vendor);
                    ApplicationArea = All;
                    // PagePartID =Page 60729;
                    // PartType =Page;
                }

            }
        }
        //AlleDG
        moveafter(Name; "Gen. Bus. Posting Group")
        moveafter("Gen. Bus. Posting Group"; "Customer Posting Group")
        moveafter("Customer Posting Group"; "Post Code")
        moveafter("Post Code"; City)
        moveafter(City; "Country/Region Code")
        moveafter("Country/Region Code"; "State Code")
        addafter("State Code")
        {
            field("District Code"; Rec."District Code")
            {
                ApplicationArea = All;

            }
            field("Mandal Code"; Rec."Mandal Code")
            {
                ApplicationArea = All;

            }
            field("Village Code"; Rec."Village Code")
            {
                ApplicationArea = All;
            }

        }

        moveafter("Village Code"; "Search Name")
        moveafter("Search Name"; "Balance (LCY)")
        moveafter("Balance (LCY)"; "Credit Limit (LCY)")
        addafter("Credit Limit (LCY)")
        {
            field("BBG Net Change - Advance (LCY)"; Rec."BBG Net Change - Advance (LCY)")
            {
                ApplicationArea = all;
            }
            field("BBG Net Change - Running (LCY)"; Rec."BBG Net Change - Running (LCY)")
            {
                ApplicationArea = all;
            }
            field("BBG Net Change - Retention (LCY)"; Rec."BBG Net Change - Retention (LCY)")
            {
                ApplicationArea = all;
            }
        }
        moveafter("BBG Net Change - Retention (LCY)"; "Salesperson Code")
        moveafter("Salesperson Code"; "Responsibility Center")
        moveafter("Responsibility Center"; "Service Zone Code")
        moveafter("Service Zone Code"; Blocked)
        moveafter(Blocked; "Last Date Modified")
        addafter("Last Date Modified")
        {
            field("BBG Old No."; Rec."BBG Old No.")
            {
                ApplicationArea = all;
            }
            field("BBG Date of Birth"; Rec."BBG Date of Birth")
            {
                ApplicationArea = all;
            }
            field("BBG Age"; Rec."BBG Age")
            {
                ApplicationArea = all;
            }
            field("BBG Sex"; Rec."BBG Sex")
            {
                ApplicationArea = all;
            }
            field("BBG Father's/Husband's Name"; Rec."BBG Father's/Husband's Name")
            {
                ApplicationArea = all;
            }
            field("BBG Mobile No."; Rec."BBG Mobile No.")
            {
                Visible = MobVisible;
                ApplicationArea = all;
                trigger OnValidate()
                var
                    ExitMessage: Boolean;
                begin
                    IF Rec."BBG Mobile No." <> '' THEN
                        ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Rec."BBG Mobile No.", TRUE);
                end;
            }
            field("BBG Date of Joining"; Rec."BBG Date of Joining")
            {
                ApplicationArea = all;
            }
            field("BBG Customer Copy in Company"; Rec."BBG Customer Copy in Company")
            {
                ApplicationArea = all;
            }
            field("BBG Occupation"; Rec."BBG Occupation")
            {
                ApplicationArea = all;
            }
            field("BBG Nominee"; Rec."BBG Nominee")
            {
                ApplicationArea = all;
            }
            field("BBG Nominee Relation"; Rec."BBG Nominee Relation")
            {
                ApplicationArea = all;
            }
            field("BBG Marriage Date"; Rec."BBG Marriage Date")
            {
                ApplicationArea = all;
            }
            field("BBG Name Modify By"; Rec."BBG Name Modify By")
            {
                ApplicationArea = all;
            }
            field("BBG Name Modify Date_Time"; Rec."BBG Name Modify Date_Time")
            {
                ApplicationArea = all;
            }
            field("BBG Aadhar No."; Rec."BBG Aadhar No.")
            {
                ApplicationArea = all;
            }
            field("BBG District"; Rec."BBG District")
            {
                ApplicationArea = all;
            }
            field("BBG Send for Approval"; Rec."BBG Send for Approval")
            {
                ApplicationArea = all;
            }
            field("BBG Send for Aproval Date"; Rec."BBG Send for Aproval Date")
            {
                ApplicationArea = all;
            }
            field("BBG Approval Status"; Rec."BBG Approval Status")
            {
                ApplicationArea = all;
            }
        }

        moveafter("Fax No."; "E-Mail")
        moveafter("E-Mail"; "Home Page")
        moveafter("Home Page"; "IC Partner Code")
        moveafter("IC Partner Code"; "Document Sending Profile")
        addafter("Document Sending Profile")
        {
            field("BBG Update Address"; Rec."BBG Update Address")
            {
                ApplicationArea = all;
            }
            field("BBG Update Address 2"; Rec."BBG Update Address 2")
            {
                ApplicationArea = all;
            }
            field("BBG Update Address 3"; Rec."BBG Update Address 3")
            {
                ApplicationArea = all;
            }
            field("BBG Update Mobile No."; Rec."BBG Update Mobile No.")
            {
                ApplicationArea = all;
            }
            field("BBG Customer Password"; Rec."BBG Customer Password")
            {
                ApplicationArea = all;
            }
        }

        moveafter("VAT Registration No."; GLN)
        addafter(GLN)
        {
            field("Invoice Copies"; Rec."Invoice Copies")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Invoice Copies"; "Invoice Disc. Code")
        moveafter("Invoice Disc. Code"; "Copy Sell-to Addr. to Qte From")
        moveafter("Copy Sell-to Addr. to Qte From"; "VAT Bus. Posting Group")
        moveafter("VAT Bus. Posting Group"; "Customer Price Group")
        moveafter("Customer Price Group"; "Customer Disc. Group")
        moveafter("Customer Disc. Group"; "Allow Line Disc.")
        moveafter("Allow Line Disc."; "Prices Including VAT")
        moveafter("Prices Including VAT"; "Prepayment %")


        addafter(Shipping)
        {
            group("BBG Foreign Trade")
            {
                Caption = 'Foreign Trade';
            }
        }
        movefirst("BBG Foreign Trade"; "Currency Code", "Language Code")

        moveafter("ARN No."; "Aggregate Turnover")
        addafter("Aggregate Turnover")
        {
            group(Credntials)
            {
                Caption = 'Credentials';
                Visible = true;
                field(Picture; Rec.Image)
                {
                    ApplicationArea = all;
                    Visible = true;
                }
            }
        }
        //AlleDG
    }

    actions
    {
        // Add changes to page actions here
        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        modify(CancelApprovalRequest)
        {
            Visible = false;
        }

        addbefore(Dimensions)
        {
            action(Confirm)
            {
                Caption = 'Confirm';
                Image = Approval;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //NDALLE 051107 Begin
                    IF NOT Rec.INSERT(TRUE) THEN
                        Rec.MODIFY(TRUE);
                    //NDALLE 051107 End
                end;
            }

        }
        addafter("Request Approval")
        {
            action("Send For Approval")
            {
                Caption = 'Send For Approval (For Customer)';
                Image = SendApprovalRequest;
                ApplicationArea = All;

                trigger OnAction()
                var
                    LineNo: Integer;
                begin
                    //Customer

                    IF CONFIRM('Do  you want to send Document Send for Approval') THEN BEGIN
                        Rec.TESTFIELD("BBG Send for Approval", FALSE);
                        LineNo := 0;
                        RequesttoApproveDocuments.RESET;
                        RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::Customer);
                        RequesttoApproveDocuments.SETRANGE("Document No.", Rec."No.");
                        IF RequesttoApproveDocuments.FINDLAST THEN
                            LineNo := RequesttoApproveDocuments."Line No.";

                        ApprovalWorkflowforAuditPr.RESET;
                        ApprovalWorkflowforAuditPr.SETRANGE("Document Type", ApprovalWorkflowforAuditPr."Document Type"::Customer);
                        ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", USERID);
                        IF ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
                            REPEAT
                                RequesttoApproveDocuments.RESET;
                                RequesttoApproveDocuments.INIT;
                                RequesttoApproveDocuments."Document Type" := RequesttoApproveDocuments."Document Type"::Customer;
                                RequesttoApproveDocuments."Document No." := Rec."No.";
                                //RequesttoApproveDocuments."Document Line No." := "Line No.";
                                RequesttoApproveDocuments."Line No." := LineNo + 10000;
                                //RequesttoApproveDocuments.Amount := Amount;
                                //RequesttoApproveDocuments."Posting Date" := "Posting Date";
                                RequesttoApproveDocuments."Requester ID" := USERID;
                                RequesttoApproveDocuments."Approver ID" := ApprovalWorkflowforAuditPr."Approver ID";
                                RequesttoApproveDocuments.Sequence := ApprovalWorkflowforAuditPr.Sequence;
                                RequesttoApproveDocuments."Requester DateTime" := CURRENTDATETIME;
                                RequesttoApproveDocuments.INSERT;
                                LineNo := RequesttoApproveDocuments."Line No."
                          UNTIL ApprovalWorkflowforAuditPr.NEXT = 0;
                            Rec."BBG Send for Approval" := TRUE;
                            Rec."BBG Send for Aproval Date" := TODAY;
                            Rec."BBG Approval Status" := Rec."BBG Approval Status"::" ";
                            Rec.Blocked := Rec.Blocked::All;
                            Rec.MODIFY;
                        END ELSE
                            ERROR('Approver not found against this Sender');
                    END ELSE
                        MESSAGE('Nothing Process');
                end;
            }
            action(Reopen)
            {
                Caption = 'Reopen (For Customer)';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("BBG Approval Status", "Approval Status"::Approved);
                    Rec."BBG Approval Status" := Rec."BBG Approval Status"::" ";
                    Rec."BBG Send for Approval" := FALSE;
                    Rec."BBG Send for Aproval Date" := 0D;
                    Rec.Blocked := Rec.Blocked::All;
                end;
            }
            action("&Attach Documents")
            {
                Caption = '&Attach Documents';
                Promoted = true;
                PromotedCategory = Process;

                RunObject = Page "Document file Upload";
                RunPageLink = "Table No." = CONST(18),
                                  "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
        addafter("F&unctions")
        {
            action("&Picture")
            {
                Caption = '&Picture';
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Customer  Picture";
                ApplicationArea = All;
            }
            action("Update Address")
            {
                Caption = 'Update Address';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //BBG2.01
                    IF Rec.Address = '' THEN BEGIN
                        IF Rec."BBG Update Address" <> '' THEN
                            Rec.Address := Rec."BBG Update Address";
                    END ELSE
                        MESSAGE('Address already Exists. Contact to Admin');

                    IF Rec."Address 2" = '' THEN BEGIN
                        IF Rec."BBG Update Address 2" <> '' THEN
                            Rec."Address 2" := Rec."BBG Update Address 2";
                    END ELSE
                        MESSAGE('Address already Exists. Contact to Admin');


                    IF Rec."BBG Address 3" = '' THEN BEGIN
                        IF Rec."BBG Update Address 3" <> '' THEN
                            Rec."BBG Address 3" := Rec."BBG Update Address 3";
                    END ELSE
                        MESSAGE('Address already Exists. Contact to Admin');

                    IF Rec."BBG Mobile No." = '' THEN BEGIN
                        IF Rec."BBG Update Mobile No." <> '' THEN
                            Rec."BBG Mobile No." := Rec."BBG Update Mobile No.";
                    END ELSE
                        MESSAGE('Mobile No. already Exists. Contact to Admin');

                    Rec."BBG Update Address" := '';
                    Rec."BBG Update Address 2" := '';
                    Rec."BBG Update Address 3" := '';
                    Rec."BBG Update Mobile No." := '';
                    Rec.MODIFY;
                    //BBG2.01
                end;
            }
            action("Copy Customer Master")
            {
                Caption = 'Copy Customer Master';
                Image = Copy;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Newcust.RESET;
                    Rec.TESTFIELD("BBG Customer Copy in Company");
                    Newcust.CHANGECOMPANY(Rec."BBG Customer Copy in Company");
                    Newcust.SETRANGE("No.", Rec."No.");
                    IF NOT Newcust.FINDFIRST THEN BEGIN
                        Newcust.INIT;
                        Newcust.TRANSFERFIELDS(Rec);
                        Newcust.INSERT;
                        MESSAGE('%1', 'This customer created in -' + Rec."BBG Customer Copy in Company");
                    END ELSE
                        MESSAGE('%1', 'This customer already Exist');
                end;
            }

        }

    }

    var
        myInt: Integer;
        masterFlds: Record "User Session";
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        Memberof: Record "Access Control";
        Newcust: Record Customer;
        CompanywiseGL: Record "Company wise G/L Account";
        MobVisible: Boolean;
        AddVisible: Boolean;
        Add2Visible: Boolean;
        Add3Visible: Boolean;
        PhVisible: Boolean;
        Ph2Visible: Boolean;
        ContactVisible: Boolean;
        Company: Record Company;
        V_Customer: Record Customer;
        NameVisible: Boolean;
        RequesttoApproveDocuments: Record "Request to Approve Documents";
        ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        CheckMobileNoforSMS: Codeunit "Check Mobile No for SMS";

    trigger OnOpenPage()
    begin
        //ALLECK 080313 START
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETRANGE("Role ID", 'A_CUSTMODIFY');
        IF Memberof.FINDFIRST THEN
            CurrPage.Editable(TRUE)
        ELSE BEGIN
            CurrPage.Editable(FALSE);
            MESSAGE('You do not have permission of role :A_CUSTMODIFY');
        END;
        //ALLECK 080313 END

        //BBG2.01 22/07/14
        CLEAR(Memberof);
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETRANGE("Role ID", 'CustInfoVisible');
        IF NOT Memberof.FINDFIRST THEN BEGIN
            MobVisible := FALSE;
            AddVisible := FALSE;
            Add2Visible := FALSE;
            Add3Visible := FALSE;
            PhVisible := FALSE;
            Ph2Visible := FALSE;
            ContactVisible := FALSE;
            NameVisible := FALSE;
        END ELSE BEGIN
            MobVisible := TRUE;
            AddVisible := TRUE;
            Add2Visible := TRUE;
            Add3Visible := TRUE;
            PhVisible := TRUE;
            Ph2Visible := TRUE;
            ContactVisible := TRUE;
            NameVisible := TRUE;
        END;
        //BBG2.01 22/07/14
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        //310821
        CLEAR(Memberof);
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETRANGE("Role ID", 'CustInfoVisible');
        IF Memberof.FINDFIRST THEN
            Rec.TESTFIELD(Name);
        //310821
    end;
}