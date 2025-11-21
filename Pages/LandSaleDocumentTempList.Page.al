page 60789 "Land Sale Document Temp List"
{
    Editable = false;
    PageType = List;
    SourceTable = "Land Sales Document Temp";
    SourceTableView = WHERE("Sales Invoice Created" = CONST(false));
    UsageCategory = Lists;
    Caption = 'Land Sale Document Temp List';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; Rec."Application No.")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Sales Invoice Unit Price"; Rec."Sales Invoice Unit Price")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Ref. LLP Name"; Rec."Ref. LLP Name")
                {
                }
                field("Ref. LLP Item Project Code"; Rec."Ref. LLP Item Project Code")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Sales Invoice")
            {

                trigger OnAction()
                var
                    NoSeriesMgt: Codeunit NoSeriesManagement;
                    UnitSetup: Record "Unit Setup";
                    SalesHeader: Record "Sales Header";
                    SICustomer: Record Customer;
                    SalesLine: Record "Sales Line";
                begin
                    Rec.TESTFIELD("Sales Invoice Created", FALSE);
                    IF Rec."Ref. LLP Name" <> COMPANYNAME THEN
                        ERROR('Ref. LLP Name should be =' + COMPANYNAME);
                    IF CONFIRM('Do you want create Sales invoice') THEN BEGIN
                        CLEAR(NoSeriesMgt);
                        UnitSetup.GET;
                        UnitSetup.TESTFIELD("Application Sales No. Series");

                        SalesHeader.RESET;
                        SalesHeader.INIT;
                        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                        SalesHeader."No." := NoSeriesMgt.GetNextNo(UnitSetup."Application Sales No. Series", WORKDATE, TRUE);
                        SalesHeader.INSERT(TRUE);

                        SICustomer.RESET;
                        SICustomer.SETRANGE("BBG IC Partner Code", Rec."IC Partner Code");
                        IF SICustomer.FINDFIRST THEN
                            SalesHeader.VALIDATE("Sell-to Customer No.", SICustomer."No.")
                        ELSE
                            ERROR('Customer does not map for IC Partner Code', Rec."IC Partner Code");

                        SalesHeader.VALIDATE("Posting Date", Rec."Posting Date");
                        SalesHeader.VALIDATE("External Document No.", Rec."Application No.");



                        SalesHeader.VALIDATE("Location Code", Rec."Ref. LLP Item Project Code");
                        SalesHeader.VALIDATE("Shortcut Dimension 1 Code", Rec."Ref. LLP Item Project Code");
                        SalesHeader."Responsibility Center" := Rec."Ref. LLP Item Project Code";
                        SalesHeader."Assigned User ID" := USERID;
                        SalesHeader.MODIFY(TRUE);
                        //COMMIT;

                        //Create Sales Line
                        SalesLine.RESET;
                        SalesLine.INIT;
                        SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                        SalesLine."Document No." := SalesHeader."No.";
                        SalesLine."Line No." := 10000;
                        SalesLine.VALIDATE(Type, SalesLine.Type::Item);
                        SalesLine.VALIDATE("No.", Rec."Ref. LLP Item No.");
                        SalesLine.VALIDATE("Sell-to Customer No.", SalesHeader."Sell-to Customer No.");
                        SalesLine.VALIDATE("Location Code", SalesHeader."Location Code");
                        SalesLine.VALIDATE(Quantity, Rec.Quantity);
                        SalesLine.VALIDATE("Unit Price", Rec."Sales Invoice Unit Price");  //Code commented 300524
                        SalesLine.INSERT;

                        Rec."Sales Inv. Creation Date" := TODAY;
                        Rec."Sales Inv. Creation Time" := TIME;
                        Rec."Sales Invoice Created" := TRUE;
                        Rec.MODIFY;
                        MESSAGE('Document Created');
                    END ELSE
                        MESSAGE('Nothing Done');
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETFILTER("Ref. LLP Name", COMPANYNAME);
    end;
}

