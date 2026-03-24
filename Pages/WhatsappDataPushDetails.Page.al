page 60840 "WhatsApp data push"
{
    Editable = false;
    PageType = List;
    SourceTable = "WhatsApp Data Push Details";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No."; Rec."Application No.")
                {
                }
                field("Plot No."; Rec."Plot No.")
                {
                }
                field("No. of Days"; Rec."No. of Days")
                {
                }
                field("Start Date"; Rec."Start Date")
                {
                }
                field("End Date"; Rec."End Date")
                {
                }
                field("Total Amount"; Rec."Total Amount")
                {
                }
                field("Received Amount"; Rec."Received Amount")
                {
                }
                field("Min. allotment Amount"; Rec."Min. allotment Amount")
                {
                }
                field("Creation Date Time"; Rec."Creation Date Time")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Data")
            {
                RunObject = Codeunit 50048;
            }
            Action("Select All")
            {
                trigger OnAction()
                var
                    WhatsappDataPush: Record "WhatsApp Data Push Details";
                begin
                    WhatsappDataPush.RESET;
                    IF WhatsappDataPush.FindSet() then
                        repeat
                            WhatsappDataPush."Select for send Whatsapp" := True;
                            WhatsappDataPush.Modify;
                        Until WhatsappDataPush.Next = 0;

                    Message('All records has been selected for Send Whatsapp Message');

                end;

            }
            Action("Un-Select All")
            {
                trigger OnAction()
                var
                    WhatsappDataPush: Record "WhatsApp Data Push Details";
                begin
                    WhatsappDataPush.RESET;
                    IF WhatsappDataPush.FindSet() then
                        repeat
                            WhatsappDataPush."Select for send Whatsapp" := false;
                            WhatsappDataPush.Modify;
                        Until WhatsappDataPush.Next = 0;

                    Message('All records has been un-selected');
                end;
            }

            Action("Send Whatsapp Message")
            {
                trigger OnAction()
                var
                    WhatsappDataPush: Record "WhatsApp Data Push Details";
                begin
                    IF Confirm('Do you want to push the Whatsapp Message?') THEN begin
                        WhatsappDataPush.RESET;
                        WhatsappDataPush.SetRange("Select for send Whatsapp", True);
                        //WhatsappDataPush.SetRange("Sent Whatsapp Message", False);
                        IF WhatsappDataPush.FindSet() then BEGIN
                            repeat
                                WhatsappDataPush."Sent Whatsapp Message" := True;
                                WhatsappDataPush."Whatsapp Message DateTime" := CurrentDateTime;
                                WhatsappDataPush."Select for send Whatsapp" := False;
                                WhatsappDataPush.Modify;
                                Commit;
                            Until WhatsappDataPush.Next = 0;
                            Message('Messages has been sent to Customers');
                        end ELSE
                            Message('No record found');
                    END ELSE
                        Message('Nothing to Process');
                END;

            }

        }

    }

    var
        UnitPaymentDueDaysupdate: Codeunit 50048;
        //DataPushtoOnLineMaster: Codeunit 50062;
        NewUnitmasters: Record 97821;
        Updationofplotdetails: Record 60811;
}

