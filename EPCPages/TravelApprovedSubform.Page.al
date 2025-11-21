page 97807 "Travel Approved Subform"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Travel Payment Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Sub Associate Code"; Rec."Sub Associate Code")
                {
                }
                field("Sub Associate Name"; Rec."Sub Associate Name")
                {
                }
                field("TA Rate"; Rec."TA Rate")
                {
                }
                field("Total Area"; Rec."Total Area")
                {
                    Caption = 'Area';
                }
                field("Amount to Pay"; Rec."Amount to Pay")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field("TDS Amount"; Rec."TDS Amount")
                {
                }
                field("Sent for Approval"; Rec."Sent for Approval")
                {
                    Editable = false;
                }
                field("Approval Sender  Name"; Rec."Approval Sender  Name")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
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
                action("Travel Reversal")
                {

                    trigger OnAction()
                    begin
                        IF CONFIRM('Do you want to Reverse the Amount') THEN BEGIN
                            CLEAR(UnitReversal);
                            Rec.TESTFIELD(Reverse, FALSE);
                            IF Rec."Amount to Pay" <= 0 THEN
                                ERROR('Amount to Pay should not be less than or Equal to 0');
                            IF Rec."Application No." = '' THEN
                                ERROR('Application No. should not be blank');
                            TravelPaymentEntry.RESET;
                            TravelPaymentEntry.SETRANGE("Document No.", Rec."Document No.");
                            TravelPaymentEntry.SETRANGE("Application No.", Rec."Application No.");
                            TravelPaymentEntry.SETRANGE(Reverse, FALSE);
                            TravelPaymentEntry.SETFILTER("Amount to Pay", '<>%1', 0);
                            IF TravelPaymentEntry.FINDSET THEN BEGIN
                                REPEAT
                                    TotalTAAmt := 0;
                                    CheckTravelPaymentEntry.RESET;
                                    CheckTravelPaymentEntry.SETRANGE("Document No.", TravelPaymentEntry."Document No.");
                                    CheckTravelPaymentEntry.SETRANGE("Sub Associate Code", TravelPaymentEntry."Sub Associate Code");
                                    CheckTravelPaymentEntry.SETRANGE("Application No.", TravelPaymentEntry."Application No.");
                                    IF CheckTravelPaymentEntry.FINDSET THEN
                                        REPEAT
                                            TotalTAAmt := TotalTAAmt + CheckTravelPaymentEntry."Amount to Pay";
                                        UNTIL CheckTravelPaymentEntry.NEXT = 0;
                                    IF TotalTAAmt > 0 THEN BEGIN
                                        NewConfirmedOrder.RESET;
                                        IF NewConfirmedOrder.GET(TravelPaymentEntry."Application No.") THEN;
                                        UnitReversal.TA_ReversalWithTDSformTravelPage(TravelPaymentEntry."Sub Associate Code", TravelPaymentEntry."Amount to Pay",
                                        TravelPaymentEntry."Application No.", TODAY, NewConfirmedOrder."Shortcut Dimension 1 Code", TravelPaymentEntry);
                                        TravelPaymentEntry.Reverse := TRUE;
                                        TravelPaymentEntry.MODIFY;
                                    END;
                                UNTIL TravelPaymentEntry.NEXT = 0;
                            END;
                            MESSAGE('Process Done');
                        END
                        ELSE
                            MESSAGE('Nothing Process');
                    end;
                }
            }
        }
    }

    var
        UnitReversal: Codeunit "Unit Reversal";
        TravelPaymentEntry: Record "Travel Payment Entry";
        NewTravelPaymentEntry: Record "Travel Payment Entry";
        NewConfirmedOrder: Record "New Confirmed Order";
        v_ConfirmedOrder: Record "Confirmed Order";
        CheckTravelPaymentEntry: Record "Travel Payment Entry";
        TotalTAAmt: Decimal;
}

