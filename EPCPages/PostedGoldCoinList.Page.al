page 50111 "Posted Gold Coin List"
{

    CardPageID = "Posted Gold/Silver Coin";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Gate Pass Header";
    SourceTableView = SORTING("Document Type", "Document No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER(MIN | "Material Return"),
                            Status = FILTER(Close),
                            Type = FILTER(Regular | Direct),
                            "Item Type" = FILTER(<> R194_Gift));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("Item Type"; Rec."Item Type")
                {
                }
                field("No. Series"; Rec."No. Series")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field("Reference No."; Rec."Reference No.")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Receiver Name"; Rec."Receiver Name")
                {
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Issue Type"; Rec."Issue Type")
                {
                }
                field("Outward Gatepass Type"; Rec."Outward Gatepass Type")
                {
                }
                field("Entered By"; Rec."Entered By")
                {
                }
            }
        }
    }

    actions
    {
    }
}

