page 50394 "Comm/Refund Pmt. Schedule List"
{
    Caption = 'Commission/Refund Payment Schedule List';
    PageType = List;
    SourceTable = "Commision/Refund Pmt Schedule";
    UsageCategory = Lists;
    ApplicationArea = All;
    AutoSplitKey = True;
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {

                }
                field("Type"; Rec."Type")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Created By"; Rec."Created By")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Team Name"; Rec."Team Name")
                {
                }
                field("Team Head ID"; Rec."Team Head ID")
                {
                }
                field("Team Head Name"; Rec."Team Head Name")
                {
                }
                field("Total Amount"; Rec."Total Amount")
                {
                }
                field("Scheduled Amount"; Rec."Scheduled Amount")
                {
                }
                field("Scheduled Date"; Rec."Scheduled Date")
                {
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        checkpermission;

                    end;
                }
                field("Completed Date"; Rec."Completed Date")
                {
                }
                field("Status"; Rec."Status")
                {
                }
                field(Comment; Rec.Comment)
                {
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        checkpermission;

                    end;

                }
                field("Last modify By"; Rec."Last modify By")
                {

                }
                field("Last modify DateTime"; Rec."Last modify DateTime")
                {

                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Import)
            {
                Caption = 'Import Payment Schedule Lines';
                RunObject = xmlport "Commission/Refund Pmt. Schd.";

            }
            group(Function)
            {
                Caption = 'Change Status';
                action(Complated)
                {
                    Caption = 'Completed';
                    trigger OnAction()
                    var
                        myInt: Integer;
                        Comm_RefundPmtSchedule: Record "Commision/Refund Pmt Schedule";

                    begin
                        IF Confirm('Do you want to change the status for selected lines as Completed') then begin
                            CurrPage.SETSELECTIONFILTER(Comm_RefundPmtSchedule);
                            Comm_RefundPmtSchedule.SetRange(Status, Comm_RefundPmtSchedule.Status::Pending);
                            If Comm_RefundPmtSchedule.FindSet() then
                                repeat
                                    Comm_RefundPmtSchedule.Status := Comm_RefundPmtSchedule.Status::Completed;
                                    Comm_RefundPmtSchedule."Last modify By" := USERID;
                                    Comm_RefundPmtSchedule."Last modify DateTime" := CurrentDateTime;
                                    Comm_RefundPmtSchedule.Modify;
                                Until Comm_RefundPmtSchedule.Next = 0;
                            Message('Status has been changed');

                        end;

                    end;
                }

                action(Rejected)
                {
                    Caption = 'Rejected';
                    trigger OnAction()
                    var
                        myInt: Integer;
                        Comm_RefundPmtSchedule: Record "Commision/Refund Pmt Schedule";

                    begin
                        IF Confirm('Do you want to change the status for selected lines as Rejected') then begin
                            CurrPage.SETSELECTIONFILTER(Comm_RefundPmtSchedule);
                            Comm_RefundPmtSchedule.SetRange(Status, Comm_RefundPmtSchedule.Status::Pending);
                            If Comm_RefundPmtSchedule.FindSet() then
                                repeat
                                    Comm_RefundPmtSchedule.Status := Comm_RefundPmtSchedule.Status::Rejected;
                                    Comm_RefundPmtSchedule."Last modify By" := USERID;
                                    Comm_RefundPmtSchedule."Last modify DateTime" := CurrentDateTime;
                                    Comm_RefundPmtSchedule.Modify;
                                Until Comm_RefundPmtSchedule.Next = 0;
                            Message('Status has been changed');

                        end;

                    end;
                }
            }
        }

    }

    var
        usersetup: Record "User Setup";

    local procedure checkpermission()
    begin
        usersetup.RESET;
        usersetup.SetRange("User ID", USERID);
        usersetup.SetRange("Modify Comm/Refund Schedule", false);
        If usersetup.FindFirst() then
            Error('You have not permission to modify the value');

    end;


}

