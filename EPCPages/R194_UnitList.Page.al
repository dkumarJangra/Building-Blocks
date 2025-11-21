page 50395 "R194 Unit List"
{
    Caption = 'R194 Unit List';

    Editable = false;
    PageType = List;
    SourceTable = "Confirmed Order";
    SourceTableView = WHERE("Application Transfered" = CONST(false));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Payment Plan"; Rec."Payment Plan")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field(Status; Rec.Status)
                {
                }

                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field(Amount; Rec.Amount)
                {
                }

                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("R194 Gift Issued"; Rec."R194 Gift Issued")
                {
                }

            }
        }
    }

    actions
    {
        // area(navigation)
        // {
        //     group("&Unit")
        //     {
        //         Caption = '&Unit';
        //         action(Card)
        //         {
        //             Caption = 'Card';
        //             Image = EditLines;
        //             RunObject = Page "Confirmed Order";
        //             RunPageLink = "No." = FIELD("No.");
        //             RunPageView = SORTING("No.");
        //             ShortCutKey = 'Shift+F7';
        //         }
        //     }
        // }
    }



    trigger OnOpenPage()
    var
        myInt: Integer;
        R194Giftsetup: Record "R194 Gift Setup";
    begin
        R194Giftsetup.RESET;
        IF R194Giftsetup.FindFirst THEN;
        Rec.SetRange("Introducer Code", AssociateCodeFilter);
        Rec.SetFilter("Posting Date", '>=%1', R194Giftsetup."Start Date");
        Rec.SetRange("App. applicable for issue R194", True);

    END;

    trigger OnAfterGetRecord()
    var
        R194Giftsetup: Record "R194 Gift Setup";
    begin
        Cust.RESET;
        IF Cust.GET(Rec."Customer No.") THEN;
        Rec.SetRange("Introducer Code", AssociateCodeFilter);
        R194Giftsetup.RESET;
        IF R194Giftsetup.FindFirst THEN;
        Rec.SetRange("Introducer Code", AssociateCodeFilter);
        Rec.SetFilter("Posting Date", '>=%1', R194Giftsetup."Start Date");
        //  Rec.SetRange("R194 Gift Issued", false);
        Rec.SetRange("App. applicable for issue R194", True);

    end;

    var
        GetDescription: Codeunit GetDescription;
        Cust: Record Customer;
        AssociateCodeFilter: Code[20];
        IssueDocumentNo: Code[20];

    procedure GetSelectionFilter(): Text
    var
        Conforders: Record "Confirmed Order";
        SelectionFilterManagement: Codeunit "BBG Codeunit Event Mgnt.";// SelectionFilterManagement;
    begin
        CurrPage.SETSELECTIONFILTER(Conforders);

        EXIT(SelectionFilterManagement.GetSelectionFilterForConforderField(Conforders));
    end;

    procedure SetAssociateValue(AssociateID: Code[20])
    Var
    BEGIN
        AssociateCodeFilter := AssociateID;
    END;

    //ertry

}

