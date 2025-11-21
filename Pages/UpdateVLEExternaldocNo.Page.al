page 50321 "Update Vendor Ledg. Entries"
{
    Caption = 'Update VLEntry External Doc_No';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Vendor ledger Entry";
    Permissions = tabledata "Vendor Ledger Entry" = RM,
    tabledata "Purch. Inv. Header" = RM;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = False;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = False;


                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = True;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    Editable = False;

                }
                field("External Document No."; Rec."External Document No.")
                {
                    trigger OnValidate()
                    var
                        PIHeader: Record "Purch. Inv. Header";
                    begin

                        PIHeader.RESET;
                        IF PIHeader.GET(Rec."Document No.") then begin
                            PIHeader."Vendor Invoice No." := Rec."External Document No.";
                            PIHeader.Modify;
                        end;
                    end;


                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {

                trigger OnAction()
                begin

                end;
            }
        }
    }



    trigger OnOpenPage()

    begin

        If UserId <> 'BCUSER' then
            Error('Contact Admin');
    end;
}