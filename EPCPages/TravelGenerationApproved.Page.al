page 97972 "Travel Generation Approved"
{
    Editable = true;
    PageType = Card;
    SourceTable = "Travel Header";
    SourceTableView = WHERE(Approved = FILTER(true));
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
                field("Top Person"; Rec."Top Person")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                    Editable = true;
                }
                field("Project Rate"; Rec."Project Rate")
                {
                }
                field("ARM TA Code"; Rec."ARM TA Code")
                {
                }
                field(dimTACode; Rec.dimTACode)
                {
                    Caption = 'For Old TACode';
                    Editable = true;
                }
                field(Month; Rec.Month)
                {
                    Visible = false;
                }
                field(Year; Rec.Year)
                {
                    Visible = false;
                }
            }
            part("1"; "Travel Payment Details")
            {
                SubPageLink = "Document No." = FIELD("Document No.");
                SubPageView = WHERE(Select = FILTER(true),
                                    "Sent for Approval" = FILTER(true),
                                    Approved = FILTER(true));
            }
            part("2"; "Travel Approved Subform")
            {
                SubPageLink = "Document No." = FIELD("Document No.");
                SubPageView = WHERE("Sent for Approval" = FILTER(true),
                                    Approved = FILTER(true),
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
                Caption = '&Post';
                Visible = false;
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        AppTAEntry.RESET;
                        AppTAEntry.SETRANGE("Document No.", Rec."Document No.");
                        AppTAEntry.SETRANGE(Approved, TRUE);
                        IF AppTAEntry.FINDFIRST THEN
                            REPEAT
                                AppTAEntry."Post from Approval" := TRUE;
                                AppTAEntry.MODIFY;
                            UNTIL AppTAEntry.NEXT = 0;

                        AppTAEntryDet.RESET;
                        AppTAEntryDet.SETRANGE("Document No.", Rec."Document No.");
                        AppTAEntryDet.SETRANGE(Select, TRUE);
                        IF AppTAEntryDet.FINDFIRST THEN
                            REPEAT
                                AppTAEntryDet.Post := TRUE;
                                AppTAEntryDet.MODIFY;
                            UNTIL AppTAEntryDet.NEXT = 0;
                        AppTAEntryDet.SETRANGE(Select, FALSE);
                        IF AppTAEntryDet.FINDFIRST THEN
                            REPEAT
                                AppTAEntryDet.DELETE;
                            UNTIL AppTAEntryDet.NEXT = 0;
                    end;
                }
            }
            group("Calculate Eligibility1")
            {
                Caption = '&Return';
                action(Return)
                {
                    Caption = 'Return';

                    trigger OnAction()
                    begin
                        // BBG1.01 231012 START
                        IF NOT CONFIRM(Text50003, FALSE) THEN
                            EXIT;

                        //IF "Project Code" = '' THEN
                        //  ERROR(Text50002);

                        TravelPaymentEntry.RESET;
                        TravelPaymentEntry.SETRANGE("Document No.", Rec."Document No.");
                        TravelPaymentEntry.SETRANGE("Post Payment", TRUE);
                        IF TravelPaymentEntry.FINDSET THEN
                            ERROR('Posting already done');


                        RecAPPTADetail.RESET;
                        RecAPPTADetail.SETRANGE("Document No.", Rec."Document No.");
                        RecAPPTADetail.SETRANGE(Select, TRUE);
                        RecAPPTADetail.SETRANGE(Approved, TRUE);
                        IF RecAPPTADetail.FINDSET THEN
                            REPEAT
                                TAAppwiseDet.RESET;
                                TAAppwiseDet.SETRANGE("Document No.", Rec."Document No.");
                                TAAppwiseDet.SETRANGE("TA Detail Line No.", RecAPPTADetail."Line no.");
                                IF TAAppwiseDet.FINDSET THEN
                                    REPEAT
                                        TAAppwiseDet.DELETE;
                                    UNTIL TAAppwiseDet.NEXT = 0;
                            UNTIL RecAPPTADetail.NEXT = 0;



                        CLEAR(TravelPaymentEntry);

                        TravelPaymentEntry.RESET;
                        TravelPaymentEntry.SETRANGE("Document No.", Rec."Document No.");
                        IF TravelPaymentEntry.FINDSET THEN
                            REPEAT
                                TravelPaymentEntry.VALIDATE(Approved, FALSE);
                                TravelPaymentEntry.VALIDATE("Sent for Approval", FALSE);
                                TravelPaymentEntry.VALIDATE(Status, TravelPaymentEntry.Status::Return);
                                TravelPaymentEntry.MODIFY;
                            UNTIL TravelPaymentEntry.NEXT = 0;

                        APPTADetails.RESET;
                        APPTADetails.SETRANGE("Document No.", Rec."Document No.");
                        APPTADetails.SETRANGE(Select, TRUE);
                        IF APPTADetails.FINDFIRST THEN
                            REPEAT
                                APPTADetails.Approved := FALSE;
                                APPTADetails."Sent for Approval" := FALSE;
                                APPTADetails.MODIFY;
                            UNTIL APPTADetails.NEXT = 0;

                        CLEAR(THeader1);
                        IF THeader1.GET(Rec."Document No.") THEN BEGIN
                            THeader1."Sent for Approval" := FALSE;
                            THeader1.Approved := FALSE;
                            THeader1.MODIFY;
                        END;

                        MESSAGE(Text50003);
                        //MARKEDONLY(FALSE);
                    end;
                }
            }
        }
    }

    var
        //GenerateTAEntry: Report 50067;
        //AssociatTAHierarchy: Report 50094;
        TravelPaymentEntry: Record "Travel Payment Entry";
        APPTADetails: Record "Travel Payment Details";
        Text001: Label 'Do you want to Insert the Lines?';
        Text50002: Label 'Do you want to return this Document?';
        Text50003: Label 'The Document has been returned.';
        Text50004: Label 'There is nothing to approve.';
        AppTAEntry: Record "Travel Payment Entry";
        AppTAEntryDet: Record "Travel Payment Details";
        THeader: Record "Travel Header";
        THeader1: Record "Travel Header";
        RecAPPTADetail: Record "Travel Payment Details";
        TAAppwiseDet: Record "TA Application wise Details";
}

