page 97973 "Travel Generation For Approved"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Travel Header";
    SourceTableView = WHERE("Sent for Approval" = FILTER(true),
                            Approved = FILTER(false));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document No."; Rec."Document No.")
                {
                }
                field("Team Lead"; Rec."Team Lead")
                {
                }
                field(Month; Rec.Month)
                {
                }
                field(Year; Rec.Year)
                {
                }
            }
            part("1"; "Travel Payment Details")
            {
                SubPageLink = "Document No." = FIELD("Document No.");
                SubPageView = WHERE(Post = FILTER(false),
                                    Select = FILTER(true),
                                    "Sent for Approval" = FILTER(true),
                                    Approved = FILTER(false));
            }
            part("2"; "Travel Sent for Approval")
            {
                SubPageLink = "Document No." = FIELD("Document No.");
                SubPageView = WHERE("Sent for Approval" = FILTER(true),
                                    Approved = FILTER(false),
                                    "Post from Approval" = FILTER(false));
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Calculate Eligibility")
            {
                Caption = '&Approval';
                action(Approved)
                {
                    Caption = 'Approved';
                    Image = Approval;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        // BBG1.01 231012 START
                        IF NOT CONFIRM(Text50000, FALSE) THEN
                            EXIT;

                        TravelPaymentEntry.RESET;
                        TravelPaymentEntry.SETRANGE("Document No.", Rec."Document No.");
                        //TravelPaymentEntry.SETRANGE(Select,TRUE);
                        //TravelPaymentEntry.SETRANGE("User ID",USERID);
                        TravelPaymentEntry.SETRANGE("Sent for Approval", TRUE);
                        IF TravelPaymentEntry.FINDSET THEN
                            REPEAT
                                TravelPaymentEntry.VALIDATE(Approved, TRUE);
                                TravelPaymentEntry.VALIDATE(Status, TravelPaymentEntry.Status::Normal);
                                TravelPaymentEntry.MODIFY;
                            UNTIL TravelPaymentEntry.NEXT = 0;

                        APPTADetails.RESET;
                        APPTADetails.SETRANGE("Document No.", Rec."Document No.");
                        //APPTADetails.SETRANGE(Select,TRUE);
                        IF APPTADetails.FINDFIRST THEN
                            REPEAT
                                APPTADetails.Approved := TRUE;
                                APPTADetails.MODIFY;
                            UNTIL APPTADetails.NEXT = 0;

                        MESSAGE(Text50001);
                        Rec.MARKEDONLY(FALSE);
                        // BBG1.01 231012 END
                        AppTAEntryDet.RESET;
                        AppTAEntryDet.SETRANGE("Document No.", Rec."Document No.");
                        AppTAEntryDet.SETRANGE(Select, FALSE);
                        IF AppTAEntryDet.FINDFIRST THEN
                            REPEAT
                                ConfOrder.RESET;
                                ConfOrder.SETRANGE("No.", APPTADetails."Application No.");
                                IF ConfOrder.FINDFIRST THEN BEGIN
                                    ConfOrder."Travel Generate" := FALSE;
                                    ConfOrder.MODIFY;
                                END;
                                AppTAEntryDet.DELETE;
                            UNTIL AppTAEntryDet.NEXT = 0;



                        IF THeader.GET(Rec."Document No.") THEN BEGIN
                            THeader.Approved := TRUE;
                            THeader.MODIFY;
                        END;

                        LineNo := 0;
                        RecAPPTADetail.RESET;
                        RecAPPTADetail.SETRANGE("Document No.", Rec."Document No.");
                        RecAPPTADetail.SETRANGE(Select, TRUE);
                        RecAPPTADetail.SETRANGE(Approved, TRUE);
                        IF RecAPPTADetail.FINDSET THEN
                            REPEAT
                                RecTPayEntry.RESET;
                                RecTPayEntry.SETRANGE("Document No.", Rec."Document No.");
                                RecTPayEntry.SETFILTER("TA Rate", '<>%1', 0);
                                RecTPayEntry.SETRANGE("Application No.", RecAPPTADetail."Application No.");
                                IF RecTPayEntry.FINDSET THEN
                                    REPEAT
                                        TAAppwiseDet.INIT;
                                        TAAppwiseDet."Document No." := Rec."Document No.";
                                        TAAppwiseDet."Line No." := LineNo + 10000;
                                        TAAppwiseDet."TA Detail Line No." := RecAPPTADetail."Line no.";
                                        TAAppwiseDet."Application No." := RecAPPTADetail."Application No.";
                                        TAAppwiseDet."Application Date" := RecAPPTADetail."Posting Date";
                                        TAAppwiseDet."Introducer Code" := RecAPPTADetail."Associate Code";
                                        TAAppwiseDet."Introducer Name" := RecAPPTADetail."Associate Name";
                                        TAAppwiseDet."Associate UpLine Code" := RecTPayEntry."Sub Associate Code";
                                        TAAppwiseDet."Associate Name" := RecTPayEntry."Sub Associate Name";
                                        TAAppwiseDet."TA Rate" := RecTPayEntry."TA Rate";
                                        TAAppwiseDet."TA Generation Date" := TODAY;
                                        TAAppwiseDet."TA Amount" := RecTPayEntry."TA Rate" * RecAPPTADetail."Saleable Area";
                                        TAAppwiseDet."Saleable Area" := RecAPPTADetail."Saleable Area";
                                        LineNo := TAAppwiseDet."Line No.";
                                        TAAppwiseDet.INSERT;
                                    UNTIL RecTPayEntry.NEXT = 0;
                            UNTIL RecAPPTADetail.NEXT = 0;
                    end;
                }
                action(Returned)
                {
                    Caption = 'Returned';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        IF NOT CONFIRM(Text50002, FALSE) THEN
                            EXIT;

                        TravelPaymentEntry.RESET;
                        TravelPaymentEntry.SETRANGE("Document No.", Rec."Document No.");
                        TravelPaymentEntry.SETRANGE("Sent for Approval", TRUE);
                        IF TravelPaymentEntry.FINDSET THEN
                            REPEAT
                                TravelPaymentEntry.VALIDATE("Sent for Approval", FALSE);
                                TravelPaymentEntry.VALIDATE(Status, TravelPaymentEntry.Status::Return);
                                TravelPaymentEntry.MODIFY;
                            UNTIL TravelPaymentEntry.NEXT = 0;

                        APPTADetails.RESET;
                        APPTADetails.SETRANGE("Document No.", Rec."Document No.");
                        APPTADetails.SETRANGE(Select, TRUE);
                        IF APPTADetails.FINDFIRST THEN
                            REPEAT
                                APPTADetails."Sent for Approval" := FALSE;
                                APPTADetails.MODIFY;
                            UNTIL APPTADetails.NEXT = 0;


                        IF THeader.GET(Rec."Document No.") THEN BEGIN
                            THeader."Sent for Approval" := FALSE;
                            THeader.MODIFY;
                        END;

                        MESSAGE(Text50003);
                    end;
                }
            }
        }
    }

    var
        Text001: Label 'Do you want to Insert the Lines?';
        //GenerateTAEntry: Report 50067;
        //AssociatTAHierarchy: Report 50094;
        TravelPaymentEntry: Record "Travel Payment Entry";
        Text50000: Label 'Do you want to approve the lines?';
        Text50001: Label 'The Document has been approved.';
        Text50002: Label 'Do you want to return the Document?';
        Text50003: Label 'The Document has been returned.';
        Text50004: Label 'There is nothing to approve.';
        APPTADetails: Record "Travel Payment Details";
        AppTAEntryDet: Record "Travel Payment Details";
        THeader: Record "Travel Header";
        ConfOrder: Record "Confirmed Order";
        TAAppwiseDet: Record "TA Application wise Details";
        RecTPayEntry: Record "Travel Payment Entry";
        RecAPPTADetail: Record "Travel Payment Details";
        LineNo: Integer;
}

