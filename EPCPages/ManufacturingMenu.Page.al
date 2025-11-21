page 97758 "Manufacturing Menu"
{
    Caption = 'Manufacturing Menu';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            label("1")
            {
                CaptionClass = Text19005062;
                Style = Strong;
                StyleExpr = TRUE;
            }
            label("2")
            {
                CaptionClass = Text19017069;
                Style = Strong;
                StyleExpr = TRUE;
            }
            label("3")
            {
                CaptionClass = Text19020942;
                Style = Strong;
                StyleExpr = TRUE;
            }
            label("4")
            {
                CaptionClass = Text19072489;
                Style = Attention;
                StyleExpr = TRUE;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Reports)
            {
                Caption = 'Reports';
                action("Production Order Status Report")
                {
                    Caption = 'Production Order Status Report';
                    RunObject = Report "Prod. Order Comp. and Routing";
                }
                action("&Production Schedule")
                {
                    Caption = 'Production Schedule';
                    RunObject = Page "Aged AP Entity";
                    Visible = false;
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                action("Manufacturing Setup")
                {
                    Caption = 'Manufacturing Setup';
                    RunObject = Page "Manufacturing Setup";
                }
                action("Production Schedule")
                {
                    Caption = 'Production Schedule';
                    RunObject = Page "Aged AP Entity";
                }
            }
        }
        area(processing)
        {
            action("Released Prod. Order")
            {
                Caption = 'Released Prod. Order';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Released Production Order";
            }
            action("Output Journal")
            {
                Caption = 'Output Journal';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Output Journal";
            }
            action("Consumption Journal")
            {
                Caption = 'Consumption Journal';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Consumption Journal";
            }
            action(Items)
            {
                Caption = 'Items';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Card";
                RunPageView = WHERE("Property Unit" = CONST(false));
            }
            action("Items List")
            {
                Caption = 'Items List';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item List";
                RunPageView = WHERE("Property Unit" = CONST(false));
            }
            action(BOM)
            {
                Caption = 'BOM';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Production BOM";
            }
            action(Routing)
            {
                Caption = 'Routing';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page Routing;
            }
            action("Finished Prod. Order")
            {
                Caption = 'Finished Prod. Order';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Finished Production Order";
            }
            action(Registers)
            {
                Caption = 'Registers';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Registers";
            }
            action(Navigate)
            {
                Caption = 'Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page Navigate;
            }
            action("Production Order Status")
            {
                Caption = 'Production Order Status';
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Prod. Order Comp. and Routing";
                Visible = false;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //ALLEAB
        RecuserSetup.RESET;
        RecuserSetup.SETRANGE("User ID", USERID);
        RecuserSetup.SETFILTER(RecuserSetup."Purchase Resp. Ctr. Filter", '<>%1', '');
        IF RecuserSetup.FIND('-') THEN BEGIN
            IF RecResponsibilityCenter.GET(RecuserSetup."Purchase Resp. Ctr. Filter") THEN
                CurrPage.CAPTION := RecResponsibilityCenter.Code + '  ' + RecResponsibilityCenter.Name;
        END ELSE
            ERROR('Sorry, You have not selected Proper Responsibility Center, Please LOGIN again with proper Responsibility Center');
        //ALLEAB
    end;

    var
        ItemJnlManagement: Codeunit ItemJnlManagement;
        GRNHeader: Record "GRN Header";
        RecuserSetup: Record "User Setup";
        TransHead: Record "Transfer Header";
        IndHdr: Record "Purchase Request Header";
        RecResponsibilityCenter: Record "Responsibility Center 1";
        DocApproval: Record "Document Type Approval";
        PoHdr2: Record "Purchase Request Header";
        PoLn2: Record "Purchase Request Line";
        RecuserSetup2: Record "User Setup";
        RecResponsibilityCenter2: Record "Responsibility Center 1";
        RespCode: Code[20];
        GRNHeader2: Record "GRN Header";
        GRNLine2: Record "GRN Line";
        Text19072489: Label 'Manufacturing';
        Text19020942: Label 'Planning & Execution';
        Text19017069: Label 'Masters';
        Text19005062: Label 'Posted Documents';
}

