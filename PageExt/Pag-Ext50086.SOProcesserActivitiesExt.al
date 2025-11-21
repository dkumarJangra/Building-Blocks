pageextension 50086 "BBG SO Processer Activitie Ext" extends "SO Processor Activities"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sales Orders - Open")
        {
            cuegroup("Confirm Orders")
            {
                Caption = 'Confirm Orders';

                field("Total Confirm Orders"; Rec."Total Confirm Orders")
                {
                    ApplicationArea = All;

                }
                field("Open Confirm Order"; Rec."Open Confirm Order")
                {
                    ApplicationArea = All;
                }
                field("Registered Confirm Orders"; Rec."Registered Confirm Orders")
                {
                    ApplicationArea = All;
                }
                field("Vacated Confirm Orders"; Rec."Vacated Confirm Orders")
                {
                    ApplicationArea = All;
                }
                field("Cancelled Confirm Orders"; Rec."Cancelled Confirm Orders")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
            // cuegroup("Gold Coin")
            // {
            //     Caption = 'Gold Coin';
            //     field("Total Inventory"; Rec."Total Inventory")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field(Eligibility; Rec.Eligibility)
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Issued Gold_Silver"; Rec."Issued Gold_Silver")
            //     {
            //         ApplicationArea = All;
            //     }
            // }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}