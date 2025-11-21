page 97806 "FA Purchase Request List"
{
    CardPageID = "FA Purchase Request Header";
    Editable = false;
    PageType = List;
    SourceTable = "Purchase Request Header";
    SourceTableView = WHERE("Workflow Sub Document Type" = FILTER(FA),
                            "Indent Status" = CONST(Open));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Workflow Sub Document Type"; Rec."Workflow Sub Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Initiator User ID"; Rec."Initiator User ID")
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
                field(Requirement; Rec.Requirement)
                {
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                }
                field(Approved; Rec.Approved)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Notes; Notes)
            {
            }
            systempart(Links; Links)
            {
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("New Indent")
            {
                Caption = 'New Indent';
                Image = NewDocument;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    DeptDocMgt.CreatePurchaseIndentFA(TRUE, IndentHeader);
                end;
            }
        }
        area(navigation)
        {
            group("&Indent")
            {
                Caption = '&Indent';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
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

                    trigger OnAction()
                    begin
                        IndentHeader.RESET;
                        IndentHeader.SETRANGE("Document No.", Rec."Document No.");
                        IF IndentHeader.FIND('-') THEN;
                        //REPORT.RUN(REPORT::"Purchase Indent", TRUE, FALSE, IndentHeader);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        //SetSecurityFilterOnRespCenter;
    end;

    var
        UserMgt: Codeunit "User Setup Management";
        DeptDocMgt: Codeunit "Document Managment";
        IndentHeader: Record "Purchase Request Header";
}

