page 97843 "Project Details1"
{
    // BBG1.00/150712/AD:Formatting/Regrouping of Columns.
    // BBG1.1 181213 Added filter on Non Usable field
    // ALLE SSS 20/12/23 : Added fields "Ref. LLP Name", "Ref. LLP Item No."

    Editable = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Unit Master";
    SourceTableView = WHERE("Non Usable" = FILTER(false));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = true;
                }
                field("Unit Type"; Rec."Unit Type")
                {
                }
                field(NOC; Rec."No.")
                {
                    Caption = 'Unit No.';
                }
                field(Description; Rec.Description)
                {
                }
                field("No. of Plots for Incentive Cal"; Rec."No. of Plots for Incentive Cal")
                {
                    Visible = false;
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    Caption = 'Base UOM';
                    Editable = false;
                }
                field("Total Value"; Rec."Total Value")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field(Facing; Rec.Facing)
                {
                }
                field("Super Area"; Rec."Super Area")
                {
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                }
                field("Size-East"; Rec."Size-East")
                {
                }
                field("Size-West"; Rec."Size-West")
                {
                }
                field("Size-North"; Rec."Size-North")
                {
                }
                field("Size-South"; Rec."Size-South")
                {
                }
                field("60 feet Road"; Rec."60 feet Road")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                    Caption = 'Min. Allot. Amt.';
                    Visible = false;
                }
                field("Comment for Unit Block"; Rec."Comment for Unit Block")
                {
                    Visible = false;
                }
                field(CustomerName; CustomerName)
                {
                    Caption = 'Customer Name';
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field(BrokerName; BrokerName)
                {
                    Caption = 'Broker Name';
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field(Doj; Rec.Doj)
                {
                    Visible = false;
                }
                field(Ldp; Rec.Ldp)
                {
                    Visible = false;
                }
                field("Floor No."; Rec."Floor No.")
                {
                    Visible = false;
                }
                field("Payment plan Code"; Rec."Payment plan Code")
                {
                    Visible = false;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    Visible = false;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Unit Registered"; Rec."Unit Registered")
                {
                    Visible = false;
                }
                field("Regd Numbers"; Rec."Regd Numbers")
                {
                    Visible = false;
                }
                field("Regd date"; Rec."Regd date")
                {
                    Visible = false;
                }
                field("Sub Project Code"; Rec."Sub Project Code")
                {
                    Style = Strong;
                    StyleExpr = TRUE;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    Visible = false;
                }
                field("Ref. LLP Name"; Rec."Ref. LLP Name")
                {
                    Editable = false;
                }
                field("Ref. LLP Item No."; Rec."Ref. LLP Item No.")
                {
                    Editable = false;
                }
                field("IC Partner Code"; Rec."IC Partner Code")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CustomerName := '';
        BrokerName := '';

        //for getting customer & broker name for Sale
        ConfirmedOrder.RESET;
        //slinerec.SETRANGE("Document Type",slinerec."Document Type"::Order);
        ConfirmedOrder.SETFILTER("Unit Code", Rec."No.");
        ConfirmedOrder.SETFILTER(ConfirmedOrder.Status, '<>%1', ConfirmedOrder.Status::Cancelled);
        IF ConfirmedOrder.FINDFIRST THEN BEGIN
            IF CustRec.GET(ConfirmedOrder."Customer No.") THEN;
            CustomerName := CustRec.Name;

            IF ConfirmedOrder."Introducer Code" <> '' THEN BEGIN
                VendRec.GET(ConfirmedOrder."Introducer Code");
                BrokerName := VendRec.Name;
            END;
        END;
        //ALLE PS ADDED NEW CODE For getting customer & broker name for Sale
        SHeadRec.RESET;
        SHeadRec.SETRANGE("Document Type", SHeadRec."Document Type"::Order);
        SHeadRec.SETFILTER("Item Code", Rec."No.");
        //SHeadRec.SETFILTER("Project Code","Project Code");
        SHeadRec.SETFILTER("Order Status", '=%1', SHeadRec."Order Status"::Booked);
        IF SHeadRec.FINDFIRST THEN BEGIN
            IF CustRec.GET(SHeadRec."Sell-to Customer No.") THEN
                CustomerName := CustRec.Name;

            IF SHeadRec."Broker Code" <> '' THEN BEGIN
                VendRec.GET(SHeadRec."Broker Code");
                BrokerName := VendRec.Name;
            END;
        END;

        //for getting customer & broker name for lease
        SHeadRec.RESET;
        SHeadRec.SETFILTER("Item Code", Rec."No.");
        SHeadRec.SETRANGE("Sub Document Type", SHeadRec."Sub Document Type"::Lease);
        IF SHeadRec.FINDFIRST THEN BEGIN
            CustRec.RESET;
            CustRec.GET(SHeadRec."Sell-to Customer No.");
            CustomerName := CustRec.Name;
            IF SHeadRec."Broker Code" <> '' THEN BEGIN
                VendRec.RESET;
                VendRec.GET(SHeadRec."Broker Code");
                BrokerName := VendRec.Name;
            END;
        END;
    end;

    var
        ItemRec: Record "Unit Master";
        ConfirmedOrder: Record "Confirmed Order";
        CustomerName: Text[50];
        CustRec: Record Customer;
        BrokerName: Text[50];
        VendRec: Record Vendor;
        SHeadRec: Record "Sales Header";
        slinerec: Record "Sales Line";
        NOCEmphasize: Boolean;


    procedure UpdatePAGE(SetSaveRecord: Boolean)
    begin
        CurrPage.UPDATE(SetSaveRecord);
    end;


    procedure UPDATEF()
    begin
        CurrPage.UPDATE;
    end;


    procedure ShowUnitCard()
    begin
        Rec.ShowUnitCard;  //ALLEDK 180213
    end;
}

