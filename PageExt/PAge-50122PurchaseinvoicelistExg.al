pageextension 50122 PurchaseInvoiceListExg extends "Purchase Invoices"
{
    layout
    {
        // addafter(General)
        // {
        // group("Custom Fields")
        // {
        //     field("Custom Field 1"; Rec."Custom Field 1")
        //     {
        //         ApplicationArea = All;
        //         ToolTip = 'Specifies the value of Custom Field 1.';
        //     }
        // }
        // }
    }

    actions
    {
        //     addafter(Post)
        //     {
        //         action("Custom Action")
        //         {
        //             ApplicationArea = All;
        //             Image = Action;
        //             Promoted = true;
        //             PromotedCategory = Process;
        //             ToolTip = 'Execute custom action.';

        //             trigger OnAction()
        //             begin
        //                 Message('Custom action executed for %1', Rec."No.");
        //             end;
        //         }
        //     }
    }
    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Rec.SetRange("Inter Purchase Document", false);
    end;

}