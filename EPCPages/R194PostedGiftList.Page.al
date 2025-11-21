page 50411 "R194 Posted Gift List"
{

    CardPageID = "R194 Posted Gift";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Gate Pass Header";
    SourceTableView = SORTING("Document Type", "Document No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER(MIN),
                            Status = FILTER(Close),
                            Type = FILTER(Direct),
                            "Item Type" = FILTER(R194_Gift));
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
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }

                field("Item Type"; Rec."Item Type")
                {
                }
                field("R194_Application No."; Rec."R194_Application No.")
                {

                }

                field(Remarks; Rec.Remarks)
                {
                }

                field("Posting Date"; Rec."Posting Date")
                {
                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }

                field(Status; Rec.Status)
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }

            }
        }
    }

    actions
    {
    }
}

