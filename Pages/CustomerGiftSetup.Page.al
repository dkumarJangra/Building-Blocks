page 50129 "Customer Gift Setup"
{
    PageType = List;
    SourceTable = "Customer Gifts Setup";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Effective Date"; Rec."Effective Date")
                {
                }
                field("Eligible Amount"; Rec."Eligible Amount")
                {
                }
                field(Grams; Rec.Grams)
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
            action("Re-Open")
            {

                trigger OnAction()
                var
                    CustomerGiftsSetup: Record "Customer Gifts Setup";
                begin
                    IF CONFIRM('Do you want to reopen the Entries') THEN BEGIN
                        CustomerGiftsSetup.RESET;
                        CustomerGiftsSetup.SETRANGE(Status, CustomerGiftsSetup.Status::Release);
                        IF CustomerGiftsSetup.FINDSET THEN
                            REPEAT
                                CustomerGiftsSetup.Status := CustomerGiftsSetup.Status::Open;
                                CustomerGiftsSetup.MODIFY;
                            UNTIL CustomerGiftsSetup.NEXT = 0;

                        MESSAGE('Process Done');
                    END;
                end;
            }
            action(Release)
            {

                trigger OnAction()
                var
                    CustomerGiftsSetup: Record "Customer Gifts Setup";
                begin
                    IF CONFIRM('Do you want to Release the Entries') THEN BEGIN
                        CustomerGiftsSetup.RESET;
                        CustomerGiftsSetup.SETRANGE(Status, CustomerGiftsSetup.Status::Open);
                        IF CustomerGiftsSetup.FINDSET THEN
                            REPEAT
                                CustomerGiftsSetup.Status := CustomerGiftsSetup.Status::Release;
                                CustomerGiftsSetup.MODIFY;
                            UNTIL CustomerGiftsSetup.NEXT = 0;
                        MESSAGE('Process Done');
                    END;
                end;
            }
        }
    }
}

