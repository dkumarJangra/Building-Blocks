page 97755 "Posted Sales Invoice cb"
{
    Caption = 'Posted Sales Invoice';
    InsertAllowed = false;
    PageType = Card;
    Permissions = TableData "Sales Invoice Header" = rm;
    RefreshOnActivate = true;
    SourceTable = "Sales Invoice Header";
    SourceTableView = WHERE("Invoice Type1" = FILTER(RA));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    Editable = false;
                }
                field("Sell-to Contact No."; Rec."Sell-to Contact No.")
                {
                    Editable = false;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    Editable = false;
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    Editable = false;
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    Editable = false;
                }
                field("Sell-to Post Code"; Rec."Sell-to Post Code")
                {
                    Caption = 'Sell-to Post Code/City';
                    Editable = false;
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    Editable = false;
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    Editable = false;
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = false;
                }
                field("Order No."; Rec."Order No.")
                {
                    Editable = false;
                }
                field("Pre-Assigned No."; Rec."Pre-Assigned No.")
                {
                    Editable = false;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Editable = false;
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    Editable = false;
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    Editable = false;
                }
                // field(Structure; Structure)
                // {
                //     Editable = false;
                // }
                // field("Free Supply"; Rec."Free Supply")
                // {
                // }
            }
            part(SalesInvLines; "Posted Sales Invoice Subf cb")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    Editable = false;
                }
                field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                {
                    Editable = false;
                }
                field("Bill-to Name"; Rec."Bill-to Name")
                {
                    Editable = false;
                }
                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    Editable = false;
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    Editable = false;
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    Caption = 'Bill-to Post Code/City';
                    Editable = false;
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    Editable = false;
                }
                field("Bill-to Contact"; Rec."Bill-to Contact")
                {
                    Editable = false;
                }
                // field("Form Code"; "Form Code")
                // {
                //     Editable = false;
                // }
                // field("Form No."; "Form No.")
                // {
                // }
                // field("Calc. Inv. Discount (%)"; "Calc. Inv. Discount (%)")
                // {
                // }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    Editable = false;
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                    Editable = false;
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    Editable = false;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    Editable = false;
                }
                // field("LC No."; "LC No.")
                // {
                //     Editable = false;
                // }
                // field("Export or Deemed Export"; "Export or Deemed Export")
                // {
                //     Editable = false;
                // }
                // field("VAT Exempted"; "VAT Exempted")
                // {
                //     Editable = false;
                // }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    Editable = false;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    Editable = false;
                }
                field("Ship-to Address"; Rec."Ship-to Address")
                {
                    Editable = false;
                }
                field("Ship-to Address 2"; Rec."Ship-to Address 2")
                {
                    Editable = false;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code/City';
                    Editable = false;
                }
                field("Ship-to City"; Rec."Ship-to City")
                {
                    Editable = false;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Editable = false;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    Editable = false;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    Editable = false;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code"; Rec."Currency Code")
                {

                    trigger OnAssistEdit()
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        ChangeExchangeRate.EDITABLE(FALSE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            Rec."Currency Factor" := ChangeExchangeRate.GetParameter;
                            Rec.MODIFY;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                    Editable = false;
                }
            }
            group(BizTalk)
            {
                Caption = 'BizTalk';
                field("BizTalk Sales Invoice"; Rec."BizTalk Sales Invoice")
                {
                    Editable = false;
                }
                field("Date Sent"; Rec."Date Sent")
                {
                    Editable = false;
                }
                field("Time Sent"; Rec."Time Sent")
                {
                    Editable = false;
                }
                field("Customer Order No."; Rec."Customer Order No.")
                {
                    Editable = false;
                }
            }
            group(Others)
            {
                Caption = 'Others';
                field("Time of Removal"; Rec."Time of Removal")
                {
                    Editable = false;
                }
                field("Mode of Transport"; Rec."Mode of Transport")
                {
                    Editable = false;
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    Editable = false;
                }
                field("LR/RR No."; Rec."LR/RR No.")
                {
                    Editable = false;
                }
                field("LR/RR Date"; Rec."LR/RR Date")
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
            group("&Invoice")
            {
                Caption = '&Invoice';
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Invoice Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Posted Invoice"),
                                  "No." = FIELD("No.");
                }
                action("St&ructure")
                {
                    Caption = 'St&ructure';
                    // RunObject = Page "Posted Structure Order Details";// 16308;
                    // RunPageLink = Type = CONST(Sale),
                    //               "No." = FIELD("No."),
                    //               "Structure Code" = FIELD(Structure);
                }
                action("Third Party Invoices")
                {
                    Caption = 'Third Party Invoices';
                    // RunObject = Page "Third Party Invoices";// 16307;
                    // RunPageLink = Type = CONST(Sale),
                    //               "Invoice No." = FIELD("No.");
                }
            }
            group("&Line")
            {
                Caption = '&Line';
                action(Structure)
                {
                    Caption = 'Structure';

                    trigger OnAction()
                    var
                        //PostedStructureOrderDetail: Record "Posted Structure Order Details";// 13760;
                        SalesInvLine2: Record "Sales Invoice Line";
                    begin
                        CLEAR(SalesInvLine2);
                        CurrPage.SalesInvLines.PAGE.GETRECORD(SalesInvLine2);
                        // PostedStructureOrderDetail.RESET;
                        // PostedStructureOrderDetail.SETRANGE(Type, PostedStructureOrderDetail.Type::Sale);
                        // PostedStructureOrderDetail.SETRANGE("Document Type", PostedStructureOrderDetail."Document Type"::Invoice);
                        // PostedStructureOrderDetail.SETRANGE(Rec."No.", Rec."No.");
                        // PostedStructureOrderDetail.SETRANGE("Document Line No.", SalesInvLine2."Line No.");
                        // PostedStructureOrderDetail.SETRANGE("Price Inclusive of Tax", TRUE);
                        // PAGE.RUNMODAL(PAGE::"Posted Structure Order Details", PostedStructureOrderDetail);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
            }
            group("&Print")
            {
                Caption = '&Print';
                action("Print Invoice")
                {
                    Caption = 'Print Invoice';

                    trigger OnAction()
                    begin
                        CurrPage.SETSELECTIONFILTER(SalesInvHeader);
                        SalesInvHeader.PrintRecords(TRUE);
                    end;
                }
                action("Print Tax Invoice")
                {
                    Caption = 'Print Tax Invoice';

                    trigger OnAction()
                    begin
                        SalesInvHeader.RESET;
                        SalesInvHeader.SETRANGE("No.", Rec."No.");
                        //REPORT.RUNMODAL(REPORT::"Tax Invoice", TRUE, TRUE, SalesInvHeader);
                    end;
                }
                action("Print Trading Invoice")
                {
                    Caption = 'Print Trading Invoice';

                    trigger OnAction()
                    var
                    //TradingInvoiceReport: Report 16555;
                    begin
                        //CLEAR(TradingInvoiceReport);
                        SalesInvHeader.RESET;
                        SalesInvHeader.SETRANGE("No.", Rec."No.");
                        SalesInvHeader.FINDFIRST;
                        // TradingInvoiceReport.SETTABLEVIEW(SalesInvHeader);
                        // TradingInvoiceReport.SetCustomerNo(SalesInvHeader."Sell-to Customer No.", SalesInvHeader."Ship-to Code");
                        // TradingInvoiceReport.RUNMODAL;
                    end;
                }
                action("Print Excise Invoice")
                {
                    Caption = 'Print Excise Invoice';

                    trigger OnAction()
                    var
                        //RepExciseInvoice: Report 16593;
                        Text001: Label 'Record not found.';
                    begin
                        //CLEAR(RepExciseInvoice);
                        SalesInvHeader.RESET;
                        SalesInvHeader.SETRANGE("No.", Rec."No.");
                        IF SalesInvHeader.FINDFIRST THEN BEGIN
                            // RepExciseInvoice.SETTABLEVIEW(SalesInvHeader);
                            // RepExciseInvoice.RUNMODAL;
                        END ELSE
                            ERROR(Text001);
                    end;
                }
                action("RA Bill")
                {
                    Caption = 'RA Bill';

                    trigger OnAction()
                    var
                        Text001: Label 'Record not found.';
                    begin
                        // ALLE MM Code Commented
                        /*
                        CLEAR(RABILL);
                        SalesInvHeader.RESET;
                        SalesInvHeader.SETRANGE("No.","No.");
                        IF SalesInvHeader.FINDFIRST THEN BEGIN
                          RABILL.SETTABLEVIEW(SalesInvHeader);
                          RABILL.RUNMODAL;
                        END ELSE
                         ERROR(Text001);
                        */
                        // ALLE MM Code Commented

                    end;
                }
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF UserMgt.GetSalesFilter() <> '' THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Responsibility Center", UserMgt.GetSalesFilter());
            Rec.FILTERGROUP(0);
        END;
    end;

    var
        SalesInvHeader: Record "Sales Invoice Header";
        ChangeExchangeRate: Page "Change Exchange Rate";
        UserMgt: Codeunit "User Setup Management";
}

