page 97751 "User Tasks Menu Form"
{
    // //for BLK : Code commented
    // //ALLEDDS001 - to run document report
    // 
    // //RAHEE1.00  040512  Added code for the Sales invoice show when click on document

    Caption = 'User Tasks';
    PageType = Card;
    SourceTable = "User Tasks New";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            field(vStatus; vStatus)
            {
                Caption = 'Status';

                trigger OnValidate()
                begin
                    vStatusOnAfterValidate;
                end;
            }
            field("vDocument Type"; "vDocument Type")
            {
                Caption = 'Document Type';

                trigger OnValidate()
                begin
                    vDocumentTypeOnAfterValidate;
                end;
            }
            field("vSub Document Type"; "vSub Document Type")
            {
                Caption = 'Sub Document Type';

                trigger OnValidate()
                begin
                    vSubDocumentTypeOnAfterValidat;
                end;
            }
            repeater(Group2)
            {
                Editable = false;
                field("Transaction Type"; Rec."Transaction Type")
                {
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Sub Document Type"; Rec."Sub Document Type")
                {
                }
                field("Responsibility Centre Name"; Rec."Responsibility Centre Name")
                {
                }
                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                }
                field("Document No"; Rec."Document No")
                {
                }
                field(Initiator; Rec.Initiator)
                {
                    Visible = false;
                }
                field(InitName; InitName)
                {
                    Caption = 'Initiator Name';
                }
                field("Document Approval Line No"; Rec."Document Approval Line No")
                {
                    Visible = false;
                }
                field("Approvar ID"; Rec."Approvar ID")
                {
                }
                field(ApprovarName; ApprovarName)
                {
                    Caption = 'Approvar Name';
                }
                field("Alternate Approvar ID"; Rec."Alternate Approvar ID")
                {
                    Visible = false;
                }
                field("Min Amount Limit"; Rec."Min Amount Limit")
                {
                    Visible = false;
                }
                field("Max Amount Limit"; Rec."Max Amount Limit")
                {
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                }
                field("Received From"; Rec."Received From")
                {
                }
                field(RecFrom; RecFrom)
                {
                    Caption = 'Received From Name';
                }
                field("Sent Date"; Rec."Sent Date")
                {
                }
                field("Sent Time"; Rec."Sent Time")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Authorised Date"; Rec."Authorised Date")
                {
                    Visible = false;
                }
                field("Authorised Time"; Rec."Authorised Time")
                {
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Tasks")
            {
                Caption = '&Tasks';
                action(Document)
                {
                    Caption = 'Document';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        SalesHeader: Record "Sales Header";
                        PurchaseOrder: Page "Purchase Order";
                        SalesOrder: Page "Sales Order";
                        PurchaseQuote: Page "Purchase Quote";
                        SalesQuote: Page "Sales Quote";
                        PurchaseInvoice: Page "Purchase Invoice";
                        SalesInvoice: Page "Sales Invoice";
                        GRNHeader: Record "GRN Header";
                        GRN: Page "GRN Header";
                        IndentHeader: Record "Purchase Request Header";
                        Indent: Page "Purchase Request";
                        CreditNote: Page "Purchase Credit Memo";
                        RASalesInvoice: Page "Sales Invoice CB";
                    begin

                        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
                            IF Rec."Document Type" = Rec."Document Type"::"Purchase Order" THEN BEGIN
                                PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                                PurchaseHeader.SETRANGE("No.", Rec."Document No");
                                IF PurchaseHeader.FIND('-') THEN BEGIN
                                    PurchaseOrder.SETTABLEVIEW(PurchaseHeader);
                                    PurchaseOrder.RUN;
                                END
                            END;

                            IF Rec."Document Type" = Rec."Document Type"::"Purchase Order Amendment" THEN BEGIN
                                PurchaseHeader.RESET;
                                PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                                PurchaseHeader.SETRANGE("No.", Rec."Document No");
                                IF PurchaseHeader.FIND('-') THEN BEGIN
                                    PurchaseOrder.SETTABLEVIEW(PurchaseHeader);
                                    PurchaseOrder.RUN;
                                END
                            END;

                            IF Rec."Document Type" = Rec."Document Type"::Invoice THEN BEGIN
                                PurchaseHeader.RESET;
                                PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Invoice);
                                PurchaseHeader.SETRANGE("No.", Rec."Document No");
                                IF PurchaseHeader.FIND('-') THEN BEGIN
                                    PurchaseInvoice.SETTABLEVIEW(PurchaseHeader);
                                    PurchaseInvoice.RUN;
                                END;
                            END;

                            //NDALLE
                            IF Rec."Document Type" = Rec."Document Type"::"Debit Note" THEN BEGIN
                                PurchaseHeader.RESET;
                                PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::"Credit Memo");
                                PurchaseHeader.SETRANGE("No.", Rec."Document No");
                                IF PurchaseHeader.FIND('-') THEN BEGIN
                                    CreditNote.SETTABLEVIEW(PurchaseHeader);
                                    CreditNote.RUN;
                                END;
                            END;
                            //NDALLE

                            IF Rec."Document Type" = Rec."Document Type"::GRN THEN BEGIN
                                GRNHeader.RESET;
                                GRNHeader.SETRANGE("Document Type", GRNHeader."Document Type"::GRN);
                                GRNHeader.SETRANGE("GRN No.", Rec."Document No");
                                IF GRNHeader.FIND('-') THEN BEGIN
                                    GRN.SETTABLEVIEW(GRNHeader);
                                    GRN.RUN;
                                END;
                            END;
                            IF (Rec."Document Type" = Rec."Document Type"::Indent) AND (Rec."Sub Document Type" = Rec."Sub Document Type"::" ") THEN BEGIN
                                IndentHeader.RESET;
                                IndentHeader.SETRANGE("Document Type", IndentHeader."Document Type"::Indent);
                                IndentHeader.SETRANGE("Document No.", Rec."Document No");
                                IF IndentHeader.FIND('-') THEN BEGIN
                                    Indent.SETTABLEVIEW(IndentHeader);
                                    Indent.RUN;
                                END;
                            END;


                            IF (Rec."Document Type" = Rec."Document Type"::Indent) AND (Rec."Sub Document Type" <> Rec."Sub Document Type"::" ") THEN BEGIN
                                IndentHeader.RESET;
                                IndentHeader.SETRANGE("Document Type", IndentHeader."Document Type"::Indent);
                                IndentHeader.SETRANGE("Sub Document Type", Rec."Sub Document Type");
                                IndentHeader.SETRANGE("Document No.", Rec."Document No");
                                IF IndentHeader.FIND('-') THEN BEGIN
                                    Requisition.SETTABLEVIEW(IndentHeader);
                                    Requisition.RUN;
                                END;
                            END;


                            IF Rec."Document Type" = Rec."Document Type"::"Transfer Order" THEN BEGIN
                                Transhead.RESET;
                                //Transhead.SETRANGE(transhead."Document Type",transHead."Document Type"::tr);
                                Transhead.SETRANGE("No.", Rec."Document No");
                                IF Transhead.FIND('-') THEN BEGIN
                                    Transfer.SETTABLEVIEW(Transhead);
                                    Transfer.RUN;
                                END
                            END;


                            //for BLK
                            /*
                            IF ("Document Type"= "Document Type"::Leave) THEN BEGIN
                                Leave.RESET;
                                Leave.SETRANGE("Document No","Document No");
                                Leave.SETRANGE("Document Type",Leave."Document Type"::"0");
                                  IF Leave.FIND('-') THEN BEGIN
                                      LeaveApp.SETTABLEVIEW(Leave);
                                      LeaveApp.RUN;
                                  END;
                            END;
                            IF ("Document Type"= "Document Type"::OD) THEN BEGIN
                                Leave.RESET;
                                Leave.SETRANGE("Document No","Document No");
                                Leave.SETRANGE("Document Type",Leave."Document Type"::"1");
                                  IF Leave.FIND('-') THEN BEGIN
                                      ODApp.SETTABLEVIEW(Leave);
                                      ODApp.RUN;
                                  END;
                            END;
                            */
                            //for BLK
                        END;


                        IF Rec."Transaction Type" = Rec."Transaction Type"::Sale THEN BEGIN
                            IF Rec."Document Type" = Rec."Document Type"::"Sale Order" THEN BEGIN
                                SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
                                SalesHeader.SETRANGE("No.", Rec."Document No");
                                IF SalesHeader.FIND('-') THEN BEGIN
                                    SalesOrder.SETTABLEVIEW(SalesHeader);
                                    SalesOrder.RUN;
                                END;
                                //RAHEE1.00  040512
                                SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Invoice);
                                SalesHeader.SETRANGE("No.", Rec."Document No");
                                IF SalesHeader.FIND('-') THEN BEGIN
                                    SalesInvoice.SETTABLEVIEW(SalesHeader);
                                    SalesInvoice.RUN;
                                    IF (SalesHeader."Invoice Type1" = SalesHeader."Invoice Type1"::RA) THEN BEGIN
                                        RASalesInvoice.SETTABLEVIEW(SalesHeader);
                                        RASalesInvoice.RUN;
                                    END;
                                END;
                                //RAHEE1.00  040512
                            END;
                        END;

                        /*
                        IF "Transaction Type" = "Transaction Type"::Sale THEN BEGIN
                          SalesHeader.SETRANGE("Document Type","Document Type");
                          SalesHeader.SETRANGE("No.","Document No");
                          IF SalesHeader.FIND('-') THEN BEGIN
                            IF SalesHeader."Document Type" = "Document Type"::Quote THEN BEGIN
                              SalesQuote.SETTABLEVIEW(SalesHeader);
                              SalesQuote.RUN;
                            END;
                            IF SalesHeader."Document Type" = SalesHeader."Document Type"::Order THEN BEGIN
                              SalesOrder.SETTABLEVIEW(SalesHeader);
                              SalesOrder.RUN;
                            END;
                            IF SalesHeader."Document Type" = "Document Type"::Invoice THEN BEGIN
                              SalesInvoice.SETTABLEVIEW(SalesHeader);
                              SalesInvoice.RUN;
                            END;
                          END;
                        END;
                         */

                    end;
                }
                action("Document-Report")
                {
                    Caption = 'Document-Report';

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        SalesHeader: Record "Sales Header";
                        GRNHeader: Record "GRN Header";
                        IndentHeader: Record "Purchase Request Header";
                    begin


                        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
                            IF Rec."Document Type" = Rec."Document Type"::"Purchase Order" THEN BEGIN
                                IF Rec."Sub Document Type" = Rec."Sub Document Type"::"Direct PO" THEN BEGIN
                                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                                    PurchaseHeader.SETRANGE("No.", Rec."Document No");
                                    IF PurchaseHeader.FIND('-') THEN BEGIN
                                        REPORT.RUN(97733, TRUE, FALSE, PurchaseHeader);
                                    END
                                END;
                            END;
                        END;

                        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
                            IF Rec."Document Type" = Rec."Document Type"::"Purchase Order" THEN BEGIN
                                IF Rec."Sub Document Type" = Rec."Sub Document Type"::"Regular PO" THEN BEGIN
                                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                                    PurchaseHeader.SETRANGE("No.", Rec."Document No");
                                    IF PurchaseHeader.FIND('-') THEN BEGIN
                                        REPORT.RUN(Report::"Unit Master Test Report", TRUE, FALSE, PurchaseHeader);
                                    END
                                END;
                            END;
                        END;

                        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
                            IF Rec."Document Type" = Rec."Document Type"::"Purchase Order" THEN BEGIN
                                IF Rec."Sub Document Type" = Rec."Sub Document Type"::"WO-NICB" THEN BEGIN
                                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                                    PurchaseHeader.SETRANGE("No.", Rec."Document No");
                                    IF PurchaseHeader.FIND('-') THEN BEGIN
                                        REPORT.RUN(Report::"User Setup Date Change", TRUE, FALSE, PurchaseHeader);
                                    END
                                END;
                            END;
                        END;

                        IF Rec."Document Type" = Rec."Document Type"::Indent THEN BEGIN
                            IndentHeader.RESET;
                            IndentHeader.SETRANGE("Document Type", IndentHeader."Document Type"::Indent);
                            IndentHeader.SETRANGE("Document No.", Rec."Document No");
                            IF IndentHeader.FIND('-') THEN BEGIN
                                REPORT.RUN(97735, TRUE, FALSE, IndentHeader);
                            END;
                        END;

                        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
                            IF Rec."Document Type" = Rec."Document Type"::"Purchase Order Amendment" THEN BEGIN
                                IF Rec."Sub Document Type" = Rec."Sub Document Type"::"Direct PO" THEN BEGIN
                                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                                    PurchaseHeader.SETRANGE("No.", Rec."Document No");
                                    IF PurchaseHeader.FIND('-') THEN BEGIN
                                        REPORT.RUN(97733, TRUE, FALSE, PurchaseHeader);
                                    END
                                END;
                            END;
                        END;

                        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
                            IF Rec."Document Type" = Rec."Document Type"::"Purchase Order Amendment" THEN BEGIN
                                IF Rec."Sub Document Type" = Rec."Sub Document Type"::"Regular PO" THEN BEGIN
                                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                                    PurchaseHeader.SETRANGE("No.", Rec."Document No");
                                    IF PurchaseHeader.FIND('-') THEN BEGIN
                                        REPORT.RUN(Report::"Unit Master Test Report", TRUE, FALSE, PurchaseHeader);
                                    END
                                END;
                            END;
                        END;

                        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN BEGIN
                            IF Rec."Document Type" = Rec."Document Type"::"Purchase Order Amendment" THEN BEGIN
                                IF Rec."Sub Document Type" = Rec."Sub Document Type"::"WO-NICB" THEN BEGIN
                                    PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Order);
                                    PurchaseHeader.SETRANGE("No.", Rec."Document No");
                                    IF PurchaseHeader.FIND('-') THEN BEGIN
                                        REPORT.RUN(Report::"User Setup Date Change", TRUE, FALSE, PurchaseHeader);
                                    END
                                END;
                            END;
                        END;

                        //dds
                        IF Rec."Document Type" = Rec."Document Type"::GRN THEN BEGIN
                            IF Rec."Sub Document Type" = Rec."Sub Document Type"::"JES for WO" THEN BEGIN
                                GRNHeader.RESET;
                                GRNHeader.SETRANGE("Document Type", GRNHeader."Document Type"::GRN);
                                GRNHeader.SETRANGE("GRN No.", Rec."Document No");
                                IF GRNHeader.FIND('-') THEN BEGIN
                                    REPORT.RUN(97792, TRUE, FALSE, GRNHeader);
                                END;
                            END;
                        END;

                        /*
                         IF ("Document Type"= "Document Type"::'JES FOR WO') THEN BEGIN
                             GRNHeader.RESET;
                             GRNHeader.SETRANGE("Document Type",GRNHeader."Document Type"::"JES FOR WO");
                             GRNHeader.SETRANGE("GRN No.","Document No");
                               IF GRNHeader.FIND('-') THEN BEGIN
                                   REPORT.RUN(97792,TRUE,FALSE,GRNHeader);
                               END;
                         END;




                         IF ("Document Type"= "Document Type"::Invoice) THEN BEGIN
                             PurchaseHeader.RESET;
                             PurchaseHeader.SETRANGE("Document Type",PurchaseHeader."Document Type"::Invoice);
                             PurchaseHeader.SETRANGE("No.","Document No");
                               IF PurchaseHeader.FIND('-') THEN BEGIN
                                  PurchaseInvoice.SETTABLEVIEW(PurchaseHeader);
                                  PurchaseInvoice.RUN;
                               END;
                         END;
                         END;
                         //NDALLE
                         IF ("Document Type"= "Document Type"::"Debit Note") THEN BEGIN
                             PurchaseHeader.RESET;
                             PurchaseHeader.SETRANGE("Document Type",PurchaseHeader."Document Type"::"Credit Memo");
                             PurchaseHeader.SETRANGE("No.","Document No");
                               IF PurchaseHeader.FIND('-') THEN BEGIN
                                  CreditNote.SETTABLEVIEW(PurchaseHeader);
                                  CreditNote.RUN;
                               END;
                         END;
                         //NDALLE
                        */

                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;

                    trigger OnAction()
                    begin
                        //MultilevelAuthorization.Approve(Rec);
                        //ApprovePO(Rec);
                        //CurrPAGE.UPDATE;

                        //AlleDK 250809
                        IF (Rec."Document Type" = Rec."Document Type"::"Purchase Order") OR (Rec."Document Type" = Rec."Document Type"::"Purchase Order Amendment") OR
                           (Rec."Document Type" = Rec."Document Type"::Indent) OR (Rec."Document Type" = Rec."Document Type"::GRN) OR
                           (Rec."Document Type" = Rec."Document Type"::Invoice) THEN
                            Rec.ApprovePO(Rec);
                        IF (Rec."Document Type" = Rec."Document Type"::"Sale Order") AND (Rec."Sub Document Type" = Rec."Sub Document Type"::Order) THEN
                            Rec.ApproveSO(Rec);
                        //AlleDK
                    end;
                }
                action(Return)
                {
                    Caption = 'Return';

                    trigger OnAction()
                    begin
                        //MultilevelAuthorization.Reject(Rec);


                        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN
                            Rec.ReturnPO(Rec);

                        IF Rec."Transaction Type" = Rec."Transaction Type"::Sale THEN
                            Rec.ReturnSO(Rec);
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //Reject will only be used for Leave and OD

                        IF Rec."Transaction Type" = Rec."Transaction Type"::Purchase THEN
                            Rec.ApprovePO(Rec);


                        IF Rec."Transaction Type" = Rec."Transaction Type"::Sale THEN
                            Rec.ApproveSO(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        //SC 10/02/06 ->>
        ApprovarName := '';
        RecFrom := '';
        InitName := '';
        IF Rec.Initiator <> '' THEN BEGIN
            IF Emp.GET(Rec.Initiator) THEN
                InitName := Emp.FullName;
        END;
        IF Rec."Approvar ID" <> '' THEN BEGIN
            IF Emp.GET(Rec."Approvar ID") THEN
                ApprovarName := Emp.FullName;
        END;

        IF Rec."Received From" <> '' THEN BEGIN
            IF Emp.GET(Rec."Received From") THEN
                RecFrom := Emp.FullName;
        END;
        //CurrPAGE.UPDATE(TRUE);
        //SC <<-
    end;

    trigger OnOpenPage()
    begin
        //FILTERGROUP:=1;
        Rec.SETRANGE("Approvar ID", USERID);
        //FILTERGROUP:=0;

        "vTransaction Type" := "vTransaction Type"::Purchase;
        vStatus := vStatus::" ";
        "vDocument Type" := "vDocument Type"::ALL;
        "vSub Document Type" := "vSub Document Type"::ALL;

        SetFilters;
        //SETRANGE(Status,Status::" ");
    end;

    var
        vStatus: Option " ",Approved,Returned,"Not Required";
        "vTransaction Type": Option Purchase,Sale,ALL;
        "vDocument Type": Option Indent,"Purchase Order","Purchase Order Amendment",GRN,Invoice,Leave,OD,ALL;
        "vSub Document Type": Option " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice",ALL;
        "vDocument No.": Code[20];
        ApprovarName: Text[120];
        RecFrom: Text[120];
        InitName: Text[120];
        Emp: Record Employee;
        Requisition: Page "Requisition Header";
        Transhead: Record "Transfer Header";
        Transfer: Page "Transfer Order";


    procedure SetFilters()
    begin
        Rec.SETCURRENTKEY("Document Type", "Sub Document Type", Status);
        Rec.SETRANGE(Status, vStatus);
        Rec.SETRANGE("Document Type");
        Rec.SETRANGE("Sub Document Type");

        IF "vDocument Type" = "vDocument Type"::ALL THEN
            Rec.SETRANGE("Document Type")
        ELSE
            Rec.SETRANGE("Document Type", "vDocument Type");

        IF "vSub Document Type" = "vSub Document Type"::ALL THEN
            Rec.SETRANGE("Sub Document Type")
        ELSE
            Rec.SETRANGE("Sub Document Type", "vSub Document Type");

        CurrPage.UPDATE(FALSE);
    end;

    local procedure vStatusOnAfterValidate()
    begin
        SetFilters;
    end;

    local procedure vDocumentTypeOnAfterValidate()
    begin
        SetFilters;
    end;

    local procedure vSubDocumentTypeOnAfterValidat()
    begin
        SetFilters;
    end;
}

