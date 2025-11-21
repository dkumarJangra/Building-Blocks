xmlport 50100 "Commission/Refund Pmt. Schd."
{
    Caption = 'Commission/Refund Payment Schedule';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Integer';
                textelement(Type)
                {
                }
                textelement(CreationDate)
                {
                }
                textelement(CreatedBy)
                {
                }
                textelement(ApplicationNo)
                {
                }
                textelement(AssociateID)
                {
                }
                textelement(AssociateName)
                {
                }
                textelement(TeamName)
                {
                }
                textelement(TeamHeadID)
                {
                }
                textelement(TeamHeadName)
                {
                }
                textelement(TotalAmount)
                {
                }
                textelement(ScheduledAmount)
                {
                }
                textelement(ScheduledDate)
                {
                }

                textelement(CompletedDate)
                {
                }
                textelement(Status)
                {
                }
                textelement(Comment)
                {
                }


                trigger OnAfterInsertRecord()
                begin
                    SNo := SNo + 1;
                    IF SNo > 1 THEN BEGIN

                        IF TotalAmount <> '' THEN
                            EVALUATE(Amt, TotalAmount);

                        IF ScheduledAmount <> '' THEN
                            EVALUATE(ScheduledAmount1, ScheduledAmount);



                        USERSETUP.GET(USERID);
                        USERSETUP.TestField("Modify Comm/Refund Schedule");
                        Comm_SchedulePmtSchedule.RESET;
                        IF Comm_SchedulePmtSchedule.FindLast() then
                            EntryNo := Comm_SchedulePmtSchedule."Entry No.";

                        Comm_SchedulePmtSchedule.Reset();
                        Comm_SchedulePmtSchedule.Init();
                        Comm_SchedulePmtSchedule."Entry No." := EntryNo + 1;
                        Comm_SchedulePmtSchedule."Application No." := ApplicationNo;

                        Comm_SchedulePmtSchedule."Associate ID" := AssociateID;
                        Comm_SchedulePmtSchedule."Associate Name" := AssociateName;
                        Comm_SchedulePmtSchedule.Comment := Comment;
                        Evaluate(Comm_SchedulePmtSchedule."Completed Date", CompletedDate);
                        Comm_SchedulePmtSchedule."Created By" := UserId;
                        Comm_SchedulePmtSchedule."Creation Date" := today;
                        Comm_SchedulePmtSchedule."Scheduled Amount" := ScheduledAmount1;
                        Evaluate(Comm_SchedulePmtSchedule."Scheduled Date", ScheduledDate);
                        Evaluate(Comm_SchedulePmtSchedule.Status, Status);
                        Comm_SchedulePmtSchedule."Team Head ID" := TeamHeadID;
                        Comm_SchedulePmtSchedule."Team Head Name" := TeamHeadName;
                        Comm_SchedulePmtSchedule."Team Name" := TeamName;
                        Comm_SchedulePmtSchedule."Total Amount" := Amt;
                        Evaluate(Comm_SchedulePmtSchedule.Type, Type);
                        Comm_SchedulePmtSchedule.Insert();
                    END;




                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin
        MESSAGE('%1', 'Process Done');
    end;

    var
        USERSETUP: Record "User Setup";
        Comm_SchedulePmtSchedule: Record "Commision/Refund Pmt Schedule";

        Amt: Decimal;
        SNo: Integer;
        EntryNo: integer;

        ScheduledAmount1: Decimal;
}

