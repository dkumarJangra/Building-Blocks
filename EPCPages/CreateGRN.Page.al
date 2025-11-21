page 97737 "Create GRN"
{
    DelayedInsert = true;
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "GRN Header";
    SourceTableView = SORTING("Document Type", "GRN No.")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER(GRN),
                          Status = FILTER(Open));
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Sub Document Type"; Rec."Sub Document Type")
                {
                }
                field("GRN No."; Rec."GRN No.")
                {
                    Editable = false;

                    trigger OnValidate()
                    begin
                        GRNNoOnAfterValidate;
                    end;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Initiator; Rec.Initiator)
                {
                    Editable = false;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    Caption = 'Creation Date &&Time';
                    Editable = false;
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    Editable = false;
                }
                field("Sent for Approval Date"; Rec."Sent for Approval Date")
                {
                    Editable = false;
                }
                field("Sent for Approval Time"; Rec."Sent for Approval Time")
                {
                    Editable = false;
                }
                field("Approved Date"; Rec."Approved Date")
                {
                    Caption = 'Approved Date &&Time';
                    Editable = false;
                }
                field("Approved Time"; Rec."Approved Time")
                {
                    Editable = false;
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                    Editable = false;
                }
                field(Approved; Rec.Approved)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Confirm)
            {
                Caption = 'Confirm';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    IF NOT GrnHdr.GET(Rec."Document Type", Rec."GRN No.") THEN BEGIN
                        IF Rec.INSERT(TRUE) THEN;
                    END;
                    PAGE.RUN(Page::"GRN Header", Rec);
                end;
            }
        }
    }

    var
        GrnHdr: Record "GRN Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurAndPay: Record "Purchases & Payables Setup";

    local procedure GRNNoOnAfterValidate()
    begin
        CurrPage.UPDATE;
    end;
}

