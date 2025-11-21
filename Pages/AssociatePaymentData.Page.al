page 50118 "Associate Payment Data"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Associate Payment Data";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Payment Request No."; Rec."Payment Request No.")
                {
                }
                field("Payment Request Date"; Rec."Payment Request Date")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Pmt. Requested Amount"; Rec."Pmt. Requested Amount")
                {
                }
                field("Associate Payable Amount"; Rec."Associate Payable Amount")
                {
                }
                field("Payment Status"; Rec."Payment Status")
                {

                    trigger OnValidate()
                    begin
                        IF Rec."Payment Status" = Rec."Payment Status"::Reject THEN
                            Rec.TESTFIELD("Comment for Rejection");
                    end;
                }
                field("Associate ID"; Rec."Associate ID")
                {
                }
                field(User_ID; Rec.User_ID)
                {
                }
                field("Vendor Bank Account No."; Rec."Vendor Bank Account No.")
                {
                }
                field("Status update By"; Rec."Status update By")
                {
                }
                field("Status Update Date"; Rec."Status Update Date")
                {
                }
                field("Status Update Time"; Rec."Status Update Time")
                {
                }
                field("Comment for Rejection"; Rec."Comment for Rejection")
                {

                    trigger OnValidate()
                    begin
                        IF Rec."Payment Status" = Rec."Payment Status"::Reject THEN
                            Rec.TESTFIELD("Comment for Rejection");
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Payment Status")
            {
                RunObject = Report "Update Ass Pmt Status";
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow Associate Payment", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;
}

