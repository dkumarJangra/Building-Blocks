page 50474 "R194 Eligibility Gift Details"
{
    Caption = '194R Eligibility Gift Details';

    Editable = false;
    PageType = List;
    SourceTable = "R194 Appl. wiseReport Data";
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTableView = where("Item Issued" = const(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; Rec."Application No.")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Description"; Rec."Item Description")
                {
                }
                field("Actual Extent"; Rec."Actual Extent")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }

                field("Associate No."; Rec."Associate No.")
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

    begin
        IF Companyfilters then
            Rec.SetRange("Company Name", Companyname);
        If AssociateCodeFilter <> '' then
            Rec.SetRange("Associate No.", AssociateCodeFilter);


    END;

    trigger OnAfterGetRecord()
    var
        R194Giftsetup: Record "R194 Gift Setup";
    begin

    end;

    var
        GetDescription: Codeunit GetDescription;
        Cust: Record Customer;
        AssociateCodeFilter: Code[20];
        IssueDocumentNo: Code[20];
        Companyfilters: Boolean;

    procedure GetSelectionFilter(): Text
    var
        R194ApplEleg: Record "R194 Appl. wiseReport Data";
        SelectionFilterManagement: Codeunit "BBG Codeunit Event Mgnt.";// SelectionFilterManagement;
    begin
        CurrPage.SETSELECTIONFILTER(R194ApplEleg);

        EXIT(SelectionFilterManagement.GetSelectionFilterFor194RElegField(R194ApplEleg));
    end;

    procedure SetAssociateValue(AssociateID: Code[20]; Companyfilter: Boolean)
    Var
    BEGIN
        AssociateCodeFilter := AssociateID;
        Companyfilters := Companyfilter;
    END;

    //ertry

}

