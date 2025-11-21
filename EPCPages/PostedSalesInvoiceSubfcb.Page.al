page 97756 "Posted Sales Invoice Subf cb"
{
    AutoSplitKey = true;
    Caption = 'Posted Sales Invoice Subform';
    Editable = false;
    PageType = Card;
    SourceTable = "Sales Invoice Line";
    SourceTableView = WHERE("Invoice Type1" = FILTER(RA));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("BOQ Code"; Rec."BOQ Code")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                // field("Free Supply"; "Free Supply")
                // {
                // }
                field(Description; Rec.Description)
                {
                }
                // field("Abatement %"; "Abatement %")
                // {
                //     Visible = false;
                // }
                field("Unit Price Incl. of Tax"; Rec."Unit Price Incl. of Tax")
                {
                    Visible = false;
                }
                field("Return Reason Code"; Rec."Return Reason Code")
                {
                    Visible = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    BlankZero = true;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    Visible = false;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    Visible = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    BlankZero = true;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    BlankZero = true;
                }
                field("Line Discount %"; Rec."Line Discount %")
                {
                    BlankZero = true;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    Visible = false;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                }
                field("Appl.-to Item Entry"; Rec."Appl.-to Item Entry")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
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
            group("&Line")
            {
                Caption = '&Line';
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97755. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesInvLines.PAGE.*/
                        _ShowDimensions;

                    end;
                }
                action("Item &Tracking Entries")
                {
                    Caption = 'Item &Tracking Entries';
                    Image = ItemTrackingLedger;

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97755. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesInvLines.PAGE.*/
                        _ShowItemTrackingLines;

                    end;
                }
                action("Str&ucture Details")
                {
                    Caption = 'Str&ucture Details';

                    trigger OnAction()
                    begin
                        //This functionality was copied from page #97755. Unsupported part was commented. Please check it.
                        /*CurrPage.SalesInvLines.PAGE.*/
                        ShowStrDetailsPAGE;

                    end;
                }
            }
        }
    }


    procedure _ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure ShowDimensions()
    begin
        Rec.ShowDimensions;
    end;


    procedure _ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;


    procedure ShowItemTrackingLines()
    begin
        Rec.ShowItemTrackingLines;
    end;


    procedure ShowStrDetailsPAGE()
    var
        SalesInvHeader: Record "Sales Invoice Header";
    //StrOrderLineDetails: Record "Posted Str Order Line Details";// 13798;
    //StrOrderLineDetailsPAGE: Page "Posted Str Order Line Details";// 16309;
    begin
        // StrOrderLineDetails.RESET;
        // SalesInvHeader.GET(Rec."Document No.");
        // StrOrderLineDetails.SETCURRENTKEY("Invoice No.", Rec.Type, "Item No.");
        // StrOrderLineDetails.SETRANGE("Invoice No.", SalesInvHeader."No.");
        // StrOrderLineDetails.SETRANGE(Rec.Type, StrOrderLineDetails.Type::Sale);
        // StrOrderLineDetails.SETRANGE("Item No.", Rec."No.");
        // StrOrderLineDetails.SETRANGE(Rec."Line No.", Rec."Line No.");
        // StrOrderLineDetailsPAGE.SETTABLEVIEW(StrOrderLineDetails);
        // StrOrderLineDetailsPAGE.RUNMODAL;
    end;
}

