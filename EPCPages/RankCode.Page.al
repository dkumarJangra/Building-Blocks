page 50074 "Rank Code"
{
    CardPageID = "Rank Card";
    Editable = true;
    PageType = List;
    SourceTable = "Rank Code";
    UsageCategory = Lists;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Rank Batch Code"; Rec."Rank Batch Code")
                {
                }
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Rank Batch Description"; Rec."Rank Batch Description")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Category; Rec.Category)
                {
                }
                field("Display Rank Code"; Rec."Display Rank Code")  //Code added 01072025
                {

                }
                field("RECRUITMENTS Type"; Rec."RECRUITMENTS Type")
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
                        RankCode_1.RESET;
                        RankCode_1.SETRANGE(Status, RankCode_1.Status::Release);
                        IF RankCode_1.FINDSET THEN
                            REPEAT
                                RankCode_1.Status := RankCode_1.Status::Open;
                                RankCode_1.MODIFY;
                            UNTIL RankCode_1.NEXT = 0;
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

                        RankCode_1.RESET;
                        RankCode_1.SETRANGE(Status, RankCode_1.Status::Open);
                        IF RankCode_1.FINDSET THEN
                            REPEAT
                                RankCode_1.Status := RankCode_1.Status::Release;
                                RankCode_1.MODIFY;
                            UNTIL RankCode_1.NEXT = 0;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        IF NOT (USERID IN ['100254', '100245', '100017', '100244', '1005']) THEN
            CurrPage.EDITABLE(FALSE);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        RankCode.RESET;
        RankCode.SETRANGE(Code, 0);
        IF RankCode.FINDFIRST THEN
            ERROR('The value of code should not be blank');
    end;

    var
        RankCode: Record "Rank Code";
        UserSetup: Record "User Setup";
        RankCode_1: Record "Rank Code";
}

