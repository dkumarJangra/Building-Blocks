page 50233 "Project Gold_SilverVoucher"
{
    PageType = List;
    Caption = 'Project wise Gold/Silver Voucher List';
    SourceTable = "Project Gold/Silver Voucher";
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
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        Rec.TestField(Status, REc.Status::Open);
                    end;
                }
                field("Project Name"; Rec."Project Name")
                {
                    Editable = false;
                }
                field("Effective Start Date"; Rec."Effective Start Date")
                {
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        Rec.TestField(Status, REc.Status::Open);
                    end;
                }
                field(Extent; Rec."Gold/Silver Voucher Pmt Plan")
                {
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        Rec.TestField(Status, REc.Status::Open);
                    end;
                }
                field("Gold Payment Plan"; Rec."Gold/Silver Voucher Elg. Amt")
                {
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        Rec.TestField(Status, REc.Status::Open);
                    end;
                }
                field("No. of Vouchers"; Rec."No. of Vouchers")
                {

                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        Rec.TestField(Status, REc.Status::Open);
                    end;
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
                    CustomerGiftsSetup: Record "Project Gold/Silver Voucher";
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
                    CustomerGiftsSetup: Record "Project Gold/Silver Voucher";
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

            action(Closed)
            {

                trigger OnAction()
                var
                    CustomerGiftsSetup: Record "Project Gold/Silver Voucher";
                begin
                    IF CONFIRM('Do you want to Close the Entries') THEN BEGIN
                        CustomerGiftsSetup.RESET;
                        CustomerGiftsSetup.SETRANGE(Status, CustomerGiftsSetup.Status::Release);
                        IF CustomerGiftsSetup.FINDSET THEN
                            REPEAT
                                CustomerGiftsSetup.Status := CustomerGiftsSetup.Status::Close;
                                CustomerGiftsSetup.MODIFY;
                            UNTIL CustomerGiftsSetup.NEXT = 0;
                        MESSAGE('Process Done');
                    END;
                end;
            }
        }
    }
}

