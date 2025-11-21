page 50201 "Customer Coupon Details"
{
    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Customer Coupon Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Booking Coupon"; Rec."Booking Coupon")
                {
                    Editable = EditBooking;

                    trigger OnValidate()
                    begin
                        NewConfirmedOrder.RESET;
                        NewConfirmedOrder.GET(Rec."No.");

                        Job.RESET;
                        RankCodeMaster.RESET;
                        IF Job.GET(NewConfirmedOrder."Shortcut Dimension 1 Code") THEN;
                        IF RankCodeMaster.GET(Job."Region Code for Rank Hierarcy") THEN;

                        IF RankCodeMaster.Code = 'R0001' THEN BEGIN
                            IF NewConfirmedOrder."Posting Date" < BBGSETUP."Coupon Date for R001" THEN      //150423D
                                ERROR('You can not enter booking coupon because Posting date %1 is older than the allowed date', NewConfirmedOrder."Posting Date");
                        END;

                        IF RankCodeMaster.Code = 'R0002' THEN BEGIN
                            IF NewConfirmedOrder."Posting Date" < BBGSETUP."Coupon Date for R002" THEN      //060223D
                                ERROR('You can not enter booking coupon because Posting date %1 is older than the allowed date', NewConfirmedOrder."Posting Date");
                        END;
                    end;
                }
                field("Allotment Coupon"; Rec."Allotment Coupon")
                {
                    Editable = EditAllot;
                }
                field("Registration Coupon"; Rec."Registration Coupon")
                {
                    Editable = EditRegistration;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Creation Time"; Rec."Creation Time")
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Report Customer Coupon Details")
            {
                Image = "Report";

                trigger OnAction()
                begin
                    CustomerCouponDetails.RESET;
                    CustomerCouponDetails.SETRANGE("No.", Rec."No.");
                    IF CustomerCouponDetails.FIND('-') THEN;
                    REPORT.RUN(50111, TRUE, FALSE, CustomerCouponDetails);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IF Rec."Booking Coupon" <> '' THEN
            EditBooking := FALSE
        ELSE
            EditBooking := TRUE;

        IF Rec."Allotment Coupon" <> '' THEN
            EditAllot := FALSE
        ELSE
            EditAllot := TRUE;

        IF Rec."Registration Coupon" <> '' THEN
            EditRegistration := FALSE
        ELSE
            EditRegistration := TRUE;

        UserSetup.GET(USERID);
        IF UserSetup."Update Customer Coupon" THEN BEGIN
            EditAllot := TRUE;
            EditBooking := TRUE;
            EditRegistration := TRUE;
        END;
    end;

    trigger OnAfterGetRecord()
    begin
        IF Rec."No." <> '' THEN
            IF NewConfirmedOrder.GET(Rec."No.") THEN BEGIN
                Rec."Customer No." := NewConfirmedOrder."Customer No.";
                Rec."Introducer Code" := NewConfirmedOrder."Introducer Code";
                Rec."Shortcut Dimension 1 Code" := NewConfirmedOrder."Shortcut Dimension 1 Code";
                Rec.Status := NewConfirmedOrder.Status;
                Rec.Amount := NewConfirmedOrder.Amount;
                Rec."Posting Date" := NewConfirmedOrder."Posting Date";
                Rec."Document Date" := NewConfirmedOrder."Document Date";
            END;
    end;

    var
        NewConfirmedOrder: Record "New Confirmed Order";
        CustomerCouponDetails: Record "Customer Coupon Details";
        EditBooking: Boolean;
        EditAllot: Boolean;
        EditRegistration: Boolean;
        UserSetup: Record "User Setup";
        RankCodeMaster: Record "Rank Code Master";
        Job: Record Job;
        BBGSETUP: Record "BBG Setups";
}

