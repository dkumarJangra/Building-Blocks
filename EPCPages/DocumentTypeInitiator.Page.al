page 97722 "Document Type Initiator"
{
    PageType = Card;
    SourceTable = "Document Type Initiator";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                }
                field("Sub Document Type"; Rec."Sub Document Type")
                {
                    Editable = false;
                }
                field("User Code"; Rec."User Code")
                {

                    trigger OnValidate()
                    begin
                        InitiatorName := '';
                        IF Rec."User Code" <> '' THEN BEGIN
                            IF user.GET(Rec."User Code") THEN
                                InitiatorName := user."User Name";
                        END;
                        UserCodeOnAfterValidate;
                    end;
                }
                field(InitiatorName; InitiatorName)
                {
                    Caption = 'Initiator Name';
                    Editable = false;
                    //OptionCaption = 'Initiator Name';
                }
                field("User Responsibility Center"; Rec."User Responsibility Center")
                {
                    Editable = false;
                }
                field(ResCentName1; ResCentName1)
                {
                    Caption = 'User Responsibility Center Name';
                    Editable = false;
                }
                field("Posting User Code"; Rec."Posting User Code")
                {

                    trigger OnValidate()
                    begin
                        PostingEmpName := '';
                        IF Rec."Posting User Code" <> '' THEN BEGIN
                            IF user.GET(Rec."Posting User Code") THEN
                                PostingEmpName := user."User Name";
                        END;
                        PostingUserCodeOnAfterValidate;
                    end;
                }
                field(PostingEmpName; PostingEmpName)
                {
                    Caption = 'Posting Employee Name';
                    Editable = false;
                    //OptionCaption = 'Posting Employee Name';
                }
                field("Key Responsibility Center"; Rec."Key Responsibility Center")
                {
                }
                field("PostUser Responsibility Center"; Rec."PostUser Responsibility Center")
                {
                }
                field(ResCentName2; ResCentName2)
                {
                    Caption = 'Posting User Responsibility Center Name';
                    Editable = false;
                }
                field("TO Receive USER Code"; Rec."TO Receive USER Code")
                {
                }
                field("TO Receive USER Name"; Rec."TO Receive USER Name")
                {
                }
                field("CC Mail - User Code"; Rec."CC Mail - User Code")
                {

                    trigger OnValidate()
                    begin
                        CCEmpName := '';
                        IF Rec."CC Mail - User Code" <> '' THEN BEGIN
                            IF user.GET(Rec."CC Mail - User Code") THEN
                                CCEmpName := user."User Name";
                        END;
                        CCMailUserCodeOnAfterValidate;
                    end;
                }
                field(CCEmpName; CCEmpName)
                {
                    Caption = 'CC to Emp Name';
                    Editable = false;
                    //OptionCaption = 'CC to Employee';
                }
                field("CC User Responsibility Center"; Rec."CC User Responsibility Center")
                {
                }
                field(ResCentName3; ResCentName3)
                {
                    Caption = 'CC Mail - User Responsibility Center Name';
                    Editable = false;
                }
            }
            part("1"; "Document Type Approval")
            {
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Sub Document Type" = FIELD("Sub Document Type"),
                              Initiator = FIELD("User Code"),
                              "Document No" = FILTER(''),
                              "Key Responsibility Center" = FIELD("Key Responsibility Center");
                SubPageView = SORTING("Document Type", "Sub Document Type", "Document No", Initiator, "Key Responsibility Center", "Line No")
                              ORDER(Ascending);
            }
            label("2")
            {
                CaptionClass = Text19006551;
                Style = Strong;
                StyleExpr = TRUE;
            }
            label("3")
            {
                CaptionClass = Text19029362;
                Style = Strong;
                StyleExpr = TRUE;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("Approvar Hierarchy")
                {
                    Caption = 'Approvar Hierarchy';
                    RunObject = Page "Document Type Approval";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "Sub Document Type" = FIELD("Sub Document Type"),
                                  Initiator = FIELD("User Code");
                    RunPageView = SORTING("Document Type", "Sub Document Type", "Document No", Initiator, "Line No")
                                  ORDER(Ascending)
                                  WHERE("Document No" = FILTER(''));
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        InitiatorName := '';
        PostingEmpName := '';
        CCEmpName := '';
        ResCentName1 := '';
        ResCentName2 := '';
        ResCentName3 := '';
        IF Rec."User Code" <> '' THEN BEGIN
            IF user.GET(Rec."User Code") THEN
                InitiatorName := user."User Name";
        END;
        IF Rec."Posting User Code" <> '' THEN BEGIN
            IF user.GET(Rec."Posting User Code") THEN
                PostingEmpName := user."User Name";
        END;
        IF Rec."CC Mail - User Code" <> '' THEN BEGIN
            IF user.GET(Rec."CC Mail - User Code") THEN
                CCEmpName := user."User Name";
        END;
        IF Rec."User Responsibility Center" <> '' THEN BEGIN
            IF respCenter.GET(Rec."User Responsibility Center") THEN
                ResCentName1 := respCenter.Name;
        END;
        IF Rec."PostUser Responsibility Center" <> '' THEN BEGIN
            IF respCenter.GET(Rec."PostUser Responsibility Center") THEN
                ResCentName2 := respCenter.Name;
        END;
        IF Rec."CC User Responsibility Center" <> '' THEN BEGIN
            IF respCenter.GET(Rec."CC User Responsibility Center") THEN
                ResCentName3 := respCenter.Name;
        END;
    end;

    var
        InitiatorName: Text[200];
        PostingEmpName: Text[200];
        CCEmpName: Text[200];
        user: Record User;
        ResCentName1: Text[200];
        ResCentName2: Text[200];
        ResCentName3: Text[200];
        respCenter: Record "Responsibility Center 1";
        Text19029362: Label 'Document Initiator''s';
        Text19006551: Label 'Document Approver''s';

    local procedure UserCodeOnAfterValidate()
    begin
        ResCentName1 := '';
        IF respCenter.GET(Rec."User Responsibility Center") THEN
            ResCentName1 := respCenter.Name;
    end;

    local procedure PostingUserCodeOnAfterValidate()
    begin
        ResCentName2 := '';
        IF respCenter.GET(Rec."PostUser Responsibility Center") THEN
            ResCentName2 := respCenter.Name;
    end;

    local procedure CCMailUserCodeOnAfterValidate()
    begin
        ResCentName3 := '';
        IF respCenter.GET(Rec."CC User Responsibility Center") THEN
            ResCentName3 := respCenter.Name;
    end;
}

