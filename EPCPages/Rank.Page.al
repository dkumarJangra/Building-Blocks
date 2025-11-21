page 50054 Rank
{
    PageType = Card;
    SourceTable = Rank;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Status; Rec.Status)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unction")
            {
                Caption = 'F&unction';
                action("Re-Open")
                {
                    Caption = 'Re-Open';

                    trigger OnAction()
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Setups Creation", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');
                        RecRank.RESET;
                        RecRank.SETRANGE(Status, RecRank.Status::Release);
                        IF RecRank.FINDSET THEN
                            REPEAT
                                RecRank.Status := RecRank.Status::Open;
                                RecRank.MODIFY;
                            UNTIL RecRank.NEXT = 0;
                    end;
                }
                action(Release)
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;

                    trigger OnAction()
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Setups Approval", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');
                        RecRank.RESET;
                        RecRank.SETRANGE(Status, RecRank.Status::Open);
                        IF RecRank.FINDSET THEN
                            REPEAT
                                RecRank.Status := RecRank.Status::Release;
                                RecRank.MODIFY;
                            UNTIL RecRank.NEXT = 0;
                    end;
                }
            }
        }
    }

    var
        UserSetup: Record "User Setup";
        RecRank: Record Rank;
}

