page 60706 "Cust Contact Profile Answers"
{
    AutoSplitKey = true;
    Caption = 'Cust Contact Profile Answers';
    DataCaptionExpression = CaptionStr;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Profile Questionnaire Line";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            field(CurrentQuestionsChecklistCode; CurrentQuestionsChecklistCode)
            {
                Caption = 'Profile Questionnaire Code';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SAVERECORD;
                    ProfileManagement1.LookupNameCustomer(CurrentQuestionsChecklistCode, Rec, Cont);
                    CurrPage.UPDATE(FALSE);
                end;

                trigger OnValidate()
                begin
                    ProfileManagement1.CheckNameCustomer(CurrentQuestionsChecklistCode, Cont);
                    CurrentQuestionsChecklistCodeO;
                end;
            }
            repeater(Group)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                field(Type; Rec.Type)
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                }
                field("No. of Contacts"; Rec."No. of Contacts")
                {
                    Visible = false;
                }
                field(Set; Set)
                {
                    Caption = 'Set';

                    trigger OnValidate()
                    begin
                        UpdateProfileAnswer;
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Set := ContProfileAnswer.GET(Cont."No.", Rec."Profile Questionnaire Code", Rec."Line No.");

        StyleIsStrong := Rec.Type = Rec.Type::Question;
        IF Rec.Type <> Rec.Type::Question THEN
            DescriptionIndent := 1
        ELSE
            DescriptionIndent := 0;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        ProfileQuestionnaireLine2.COPY(Rec);

        IF NOT ProfileQuestionnaireLine2.FIND(Which) THEN
            EXIT(FALSE);

        ProfileQuestLineQuestion := ProfileQuestionnaireLine2;
        IF ProfileQuestionnaireLine2.Type = Rec.Type::Answer THEN
            ProfileQuestLineQuestion.GET(ProfileQuestionnaireLine2."Profile Questionnaire Code", ProfileQuestLineQuestion.FindQuestionLine);

        OK := TRUE;
        IF ProfileQuestLineQuestion."Auto Contact Classification" THEN BEGIN
            OK := FALSE;
            REPEAT
                IF Which = '+' THEN
                    GoNext := ProfileQuestionnaireLine2.NEXT(-1) <> 0
                ELSE
                    GoNext := ProfileQuestionnaireLine2.NEXT(1) <> 0;
                IF GoNext THEN BEGIN
                    ProfileQuestLineQuestion := ProfileQuestionnaireLine2;
                    IF ProfileQuestionnaireLine2.Type = Rec.Type::Answer THEN
                        ProfileQuestLineQuestion.GET(
                          ProfileQuestionnaireLine2."Profile Questionnaire Code", ProfileQuestLineQuestion.FindQuestionLine);
                    OK := NOT ProfileQuestLineQuestion."Auto Contact Classification";
                END;
            UNTIL (NOT GoNext) OR OK;
        END;

        IF NOT OK THEN
            EXIT(FALSE);

        Rec := ProfileQuestionnaireLine2;
        EXIT(TRUE);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        ActualSteps: Integer;
        Step: Integer;
        NoOneFound: Boolean;
    begin
        ProfileQuestionnaireLine2.COPY(Rec);

        IF Steps > 0 THEN
            Step := 1
        ELSE
            Step := -1;

        REPEAT
            IF ProfileQuestionnaireLine2.NEXT(Step) <> 0 THEN BEGIN
                IF ProfileQuestionnaireLine2.Type = Rec.Type::Answer THEN
                    ProfileQuestLineQuestion.GET(
                      ProfileQuestionnaireLine2."Profile Questionnaire Code", ProfileQuestionnaireLine2.FindQuestionLine);
                IF ((NOT ProfileQuestLineQuestion."Auto Contact Classification") AND
                    (ProfileQuestionnaireLine2.Type = Rec.Type::Answer)) OR
                   ((ProfileQuestionnaireLine2.Type = Rec.Type::Question) AND (NOT ProfileQuestionnaireLine2."Auto Contact Classification"))
                THEN BEGIN
                    ActualSteps := ActualSteps + Step;
                    IF Steps <> 0 THEN
                        Rec := ProfileQuestionnaireLine2;
                END;
            END ELSE
                NoOneFound := TRUE
        UNTIL (ActualSteps = Steps) OR NoOneFound;

        EXIT(ActualSteps);
    end;

    trigger OnOpenPage()
    begin
        IF ContactProfileAnswerCode = '' THEN
            CurrentQuestionsChecklistCode :=
              ProfileManagement1.ProfileQuestionnaireAllowedCustomer(Cont, CurrentQuestionsChecklistCode)
        ELSE
            CurrentQuestionsChecklistCode := ContactProfileAnswerCode;

        ProfileManagement.SetName(CurrentQuestionsChecklistCode, Rec, ContactProfileAnswerLine);

        IF (Cont."Company No." <> '') AND (Cont."No." <> Cont."Company No.") THEN BEGIN
            CaptionStr := COPYSTR(Cont."Company No." + ' ' + Cont."Company Name", 1, MAXSTRLEN(CaptionStr));
            CaptionStr := COPYSTR(CaptionStr + ' ' + Cont."No." + ' ' + Cont.Name, 1, MAXSTRLEN(CaptionStr));
        END ELSE
            CaptionStr := COPYSTR(Cont."No." + ' ' + Cont.Name, 1, MAXSTRLEN(CaptionStr));
    end;

    var
        Cont: Record "Customers Lead_2";
        ContProfileAnswer: Record "Contact Profile Answer";
        ProfileQuestionnaireLine2: Record "Profile Questionnaire Line";
        ProfileQuestLineQuestion: Record "Profile Questionnaire Line";
        ProfileManagement: Codeunit ProfileManagement;
        ProfileManagement1: Codeunit "BBG Codeunit Event Mgnt.";
        CurrentQuestionsChecklistCode: Code[10];
        ContactProfileAnswerCode: Code[10];
        ContactProfileAnswerLine: Integer;
        Set: Boolean;
        GoNext: Boolean;
        OK: Boolean;
        CaptionStr: Text[260];
        RunFormCode: Boolean;

        StyleIsStrong: Boolean;

        DescriptionIndent: Integer;
        CustomerContactProfAnswer: Record "Customer Lead Prof. Answer";


    procedure SetParameters(var SetCont: Record "Customers Lead_2"; SetProfileQuestionnaireCode: Code[10]; SetContProfileAnswerCode: Code[10]; SetContProfileAnswerLine: Integer)
    begin
        Cont := SetCont;
        CurrentQuestionsChecklistCode := SetProfileQuestionnaireCode;
        ContactProfileAnswerCode := SetContProfileAnswerCode;
        ContactProfileAnswerLine := SetContProfileAnswerLine;
    end;


    procedure UpdateProfileAnswer()
    begin
        IF NOT RunFormCode AND Set THEN
            Rec.TESTFIELD(Type, Rec.Type::Answer);

        IF Set THEN BEGIN
            CustomerContactProfAnswer.INIT;
            CustomerContactProfAnswer."Contact No." := Cont."No.";
            CustomerContactProfAnswer."Contact Company No." := Cont."Company No.";
            CustomerContactProfAnswer.VALIDATE("Profile Questionnaire Code", CurrentQuestionsChecklistCode);
            CustomerContactProfAnswer.VALIDATE("Line No.", Rec."Line No.");
            CustomerContactProfAnswer."Last Date Updated" := TODAY;
            CustomerContactProfAnswer.INSERT(TRUE);
        END ELSE
            IF ContProfileAnswer.GET(Cont."No.", CurrentQuestionsChecklistCode, Rec."Line No.") THEN
                ContProfileAnswer.DELETE(TRUE);
    end;


    procedure SetRunFromForm(var ProfileQuestionnaireLine: Record "Profile Questionnaire Line"; ContactFrom: Record "Customers Lead_2"; CurrQuestionsChecklistCodeFrom: Code[10])
    begin
        Set := TRUE;
        RunFormCode := TRUE;
        Cont := ContactFrom;
        CurrentQuestionsChecklistCode := CurrQuestionsChecklistCodeFrom;
        Rec := ProfileQuestionnaireLine;
    end;

    local procedure CurrentQuestionsChecklistCodeO()
    begin
        CurrPage.SAVERECORD;
        ProfileManagement.SetName(CurrentQuestionsChecklistCode, Rec, 0);
        CurrPage.UPDATE(FALSE);
    end;
}

