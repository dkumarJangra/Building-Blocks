page 50459 "Village Details List"
{
    Caption = 'Village Details List';
    //CardPageId = "Village Details Card";
    PageType = List;
    SourceTable = "Village Details";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                }
                field("State Code"; Rec."State Code")
                {

                }
                field("State Name"; Rec."State Name")
                {
                    Editable = false;
                }

                field("District Code"; Rec."District Code")
                {

                }
                field("Mandal Code"; Rec."Mandal Code")
                {

                }


            }
        }
    }

    actions
    {
        //  area(creation)
        // {
        //     action(VillageDetailsCard)
        //     {
        //         Caption = 'Village Details Card';
        //         Image = NewReceipt;
        //         Promoted = true;
        //         PromotedIsBig = true;
        //         trigger OnAction()
        //         begin
        //             WorkFlowApprovalMgmt.CreateGRNRegular(TRUE, Rec);
        //         end;
        //     }

    }



}

