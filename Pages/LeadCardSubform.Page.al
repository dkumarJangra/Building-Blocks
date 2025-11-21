page 60698 "Lead Card Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Customer Lead Prof. Answer";
    SourceTableView = SORTING("Contact No.", "Answer Priority", "Profile Questionnaire Priority")
                      ORDER(Descending);
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Answer Priority"; Rec."Answer Priority")
                {
                    Visible = false;
                }
                field("Profile Questionnaire Priority"; Rec."Profile Questionnaire Priority")
                {
                    Visible = false;
                }
                field(Question; Rec.Question)
                {
                    Caption = 'Question';
                }
                field(Answer; Rec.Answer)
                {
                    DrillDown = false;

                    trigger OnAssistEdit()
                    var
                        ContactProfileAnswer: Record "Contact Profile Answer";
                        Rating: Record Rating;
                        RatingTemp: Record Rating temporary;
                        ProfileQuestionnaireLine: Record "Profile Questionnaire Line";
                        Contact: Record "Customers Lead_2";
                        ProfileManagement: Codeunit ProfileManagement;
                        ProfileManagement1: Codeunit "BBG Codeunit Event Mgnt.";
                    begin
                        ProfileQuestionnaireLine.GET(Rec."Profile Questionnaire Code", Rec."Line No.");
                        ProfileQuestionnaireLine.GET(Rec."Profile Questionnaire Code", ProfileQuestionnaireLine.FindQuestionLine);
                        IF ProfileQuestionnaireLine."Auto Contact Classification" THEN BEGIN
                            IF ProfileQuestionnaireLine."Contact Class. Field" = ProfileQuestionnaireLine."Contact Class. Field"::Rating THEN BEGIN
                                Rating.SETRANGE("Profile Questionnaire Code", Rec."Profile Questionnaire Code");
                                Rating.SETRANGE("Profile Questionnaire Line No.", ProfileQuestionnaireLine."Line No.");
                                IF Rating.FIND('-') THEN
                                    REPEAT
                                        IF ContactProfileAnswer.GET(
                                             Rec."Contact No.", Rating."Rating Profile Quest. Code", Rating."Rating Profile Quest. Line No.")
                                        THEN BEGIN
                                            RatingTemp := Rating;
                                            RatingTemp.INSERT;
                                        END;
                                    UNTIL Rating.NEXT = 0;

                                IF NOT RatingTemp.ISEMPTY THEN
                                    PAGE.RUNMODAL(PAGE::"Answer Points List", RatingTemp)
                                ELSE
                                    MESSAGE(Text001);
                            END ELSE
                                MESSAGE(Text002, Rec."Last Date Updated");
                        END ELSE BEGIN
                            Contact.GET(Rec."Contact No.");
                            ProfileManagement1.ShowContactQuestionnaireCardCustomer(Contact, Rec."Profile Questionnaire Code", Rec."Line No.");
                            CurrPage.UPDATE(FALSE);
                        END;
                    end;
                }
                field("Questions Answered (%)"; Rec."Questions Answered (%)")
                {
                }
                field("Last Date Updated"; Rec."Last Date Updated")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        Text001: Label 'There are no answer values for this rating answer.';
        Text002: Label 'This answer reflects the state of the contact on %1 when the Update Contact Class. batch job was run.\To make the answer reflect the current state of the contact, run the batch job again.';
}

