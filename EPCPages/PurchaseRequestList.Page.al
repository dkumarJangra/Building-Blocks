page 97729 "Purchase Request List"
{
    Caption = 'Purchase Request List';
    CardPageID = "Purchase Request";
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Purchase Request Header";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Workflow Approval Status"; Rec."Workflow Approval Status")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Indent Date"; Rec."Indent Date")
                {
                }
                field("Initiator User ID"; Rec."Initiator User ID")
                {
                }
                field("Indent Value"; Rec."Indent Value")
                {
                }
                field("Indent Type"; Rec."Indent Type")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Location code"; Rec."Location code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Indent Status"; Rec."Indent Status")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Indents")
            {
                Caption = '&Indents';
                action("Open Card")
                {
                    Caption = 'Open Card';
                    Image = Card;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        CASE Rec."Sub Document Type" OF
                            Rec."Sub Document Type"::" ":
                                BEGIN
                                    PAGE.RUN(PAGE::"Purchase Request", Rec);
                                END;
                            Rec."Sub Document Type"::FA:
                                BEGIN
                                    PAGE.RUN(PAGE::"FA Purchase Request Header", Rec);
                                END;
                        END;
                    end;
                }
                action("&Print")
                {
                    Caption = '&Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = false;

                    trigger OnAction()
                    begin
                        IndentHeader.RESET;
                        IndentHeader.SETRANGE("Document No.", Rec."Document No.");
                        IF IndentHeader.FIND('-') THEN;
                        //  REPORT.RUN(REPORT::"PR Report", TRUE, FALSE, IndentHeader);
                    end;
                }
            }
        }
    }

    var
        UserMgt: Codeunit "User Setup Management";
        DeptDocMgt: Codeunit "Document Managment";
        IndentHeader: Record "Purchase Request Header";
        PurchaseHeader: Record "Purchase Header";
}

