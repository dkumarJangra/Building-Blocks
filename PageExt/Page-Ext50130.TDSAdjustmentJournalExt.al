pageextension 50130 "TDS Adjustment JournalExt" extends "TDS Adjustment Journal"
{
    layout
    {
        modify("External Document No.")
        {
            Editable = True;
        }

        addafter("Document No.")
        {
            field("BBG Posting Type"; Rec."BBG Posting Type")
            {
                ApplicationArea = All;

            }
            field("Location Code"; Rec."Location Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        modify("P&ost")
        {
            Visible = False;
        }

        addlast(processing)
        {
            // action("Custom Action")
            // {
            action("NewP&ost")
            {
                Caption = 'Post';
                ApplicationArea = Basic, Suite;
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books. (F9)';
                Image = Post;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                //ShortCutKey = F9;
                trigger OnAction()
                var
                    TDSAdjPost: Codeunit "TDS Adjustment Post BBG";
                begin
                    TDSAdjPost.PostTaxJournal(Rec);
                    CurrentJnlBatchName := Rec.GetRangeMax("Journal Batch Name");
                    CurrPage.Update(false);
                end;
            }
            Action("Update Document No.")
            {
                Caption = 'Update Document No.';
                ApplicationArea = Basic, Suite;
                Image = Process;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    TDSEntry: Record "TDS Entry";
                    TDSjournal: Record "TDS Journal Line";
                begin
                    If Confirm('Do you want to update the Document No.') THEN BEGIN
                        TDSjournal.RESET;
                        TDSjournal.SetRange("Journal Template Name", Rec."Journal Template Name");
                        TDSjournal.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        IF TDSjournal.Findset then
                            repeat
                                TDSEntry.RESET;
                                IF TDSEntry.GET(TDSjournal."TDS Transaction No.") THEN BEGIN
                                    //     TDSjournal."Posting Date" := TDSEntry."Posting Date";
                                    TDSjournal."Document No." := TDSEntry."Document No.";
                                    TDSjournal.Modify;
                                END;
                            until TDSjournal.Next = 0;
                        Message('Process Done');
                    END ELSE
                        Message('Nothing to Process');
                end;

            }
        }
    }

    var
        CurrentJnlBatchName: code[10];

}