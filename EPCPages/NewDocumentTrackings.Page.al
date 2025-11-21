page 97764 "New Document Trackings"
{
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "New Document Tracking";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table ID"; Rec."Table ID")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Document Code"; Rec."Document Code")
                {
                }
                field("Document Description"; Rec."Document Description")
                {
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Purchase Doc No."; Rec."Purchase Doc No.")
                {
                }
                field("Sales Doc  No."; Rec."Sales Doc  No.")
                {
                }
                field(CC1; Rec.CC1)
                {
                }
                field("CC1 Designation"; Rec."CC1 Designation")
                {
                }
                field("Client Contact"; Rec."Client Contact")
                {
                }
                field("Client Contact Designation"; Rec."Client Contact Designation")
                {
                }
                field(Subject; Rec.Subject)
                {
                }
                field("CC1 Only Transmittal"; Rec."CC1 Only Transmittal")
                {
                }
                field("Transmittal Sender"; Rec."Transmittal Sender")
                {
                }
                field("Remarks : Enclosed"; Rec."Remarks : Enclosed")
                {
                }
                field("Remarks : Body"; Rec."Remarks : Body")
                {
                }
                field(Version; Rec.Version)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Attach Document")
                {
                    Caption = '&Attach Document';
                    RunObject = Page Documents;
                    RunPageLink = "Table No." = CONST(50031),
                                  "Reference No. 1" = FIELD("Job No."),
                                  "Reference No. 2" = FIELD("Document Code");
                }
                action("Change &Status")
                {
                    Caption = 'Change &Status';
                    Image = ChangeStatus;

                    trigger OnAction()
                    var
                        EntryNo: Integer;
                    begin
                        CLEAR(DocTrackStatusFrm);
                        DocTrackStatus.RESET;
                        DocTrackStatus.SETRANGE(DocTrackStatus."Table ID", DATABASE::Job);
                        DocTrackStatusFrm.SetDocTrack(Rec."Table ID", Rec."Document Type", Rec."Document No.", Rec."Line No.", Rec."Document Code");
                        DocTrackStatusFrm.SETTABLEVIEW(DocTrackStatus);
                        DocTrackStatusFrm.RUNMODAL;
                    end;
                }
                action("&Log")
                {
                    Caption = '&Log';
                    RunObject = Page "New Document Tracking log";
                    RunPageLink = "Table ID" = FIELD("Table ID"),
                                  "Document Type" = FIELD("Document Type"),
                                  "Line No." = FIELD("Line No."),
                                  "Document code" = FIELD("Document Code"),
                                  "Document No." = FIELD("Document No.");
                }
            }
        }
    }

    var
        Job: Record Job;
        DocTrackStatus: Record "Document Tracking status";
        DocTrackStatusFrm: Page "Tracking Status List";
}

