page 97723 "Document Type Approval"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Document Type Approval";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."Document Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Sub Document Type"; Rec."Sub Document Type")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Document No"; Rec."Document No")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Initiator; Rec.Initiator)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Key Responsibility Center"; Rec."Key Responsibility Center")
                {
                }
                field("Line No"; Rec."Line No")
                {
                    Editable = false;
                }
                field("Approvar ID"; Rec."Approvar ID")
                {

                    trigger OnValidate()
                    begin
                        ApprovarName := '';
                        IF Rec."Approvar ID" <> '' THEN BEGIN
                            IF User.GET(Rec."Approvar ID") THEN
                                ApprovarName := User."User Name";
                        END;
                        ApprovarIDOnAfterValidate;
                    end;
                }
                field(ApprovarName; ApprovarName)
                {
                    Caption = 'Approvar Name';
                    Editable = false;
                }
                field("Approvar Responsibility Center"; Rec."Approvar Responsibility Center")
                {
                }
                field(ResCentName1; ResCentName1)
                {
                    Caption = 'Approvar Responsibility Center Name';
                    Editable = false;
                }
                field("Alternate Approvar ID"; Rec."Alternate Approvar ID")
                {

                    trigger OnValidate()
                    begin
                        AltApprovarName := '';
                        IF Rec."Alternate Approvar ID" <> '' THEN BEGIN
                            IF User.GET(Rec."Alternate Approvar ID") THEN
                                AltApprovarName := User."User Name";
                        END;
                        AlternateApprovarIDOnAfterVali;
                    end;
                }
                field(AltApprovarName; AltApprovarName)
                {
                    Caption = 'Alt. Approvar Name';
                    Editable = false;
                    //OptionCaption = 'Alt Approvar Name';
                }
                field("Alt. App Responsibility Center"; Rec."Alt. App Responsibility Center")
                {
                }
                field(ResCentName2; ResCentName2)
                {
                    Caption = 'Alternate Approvar Responsibility Center Name';
                    Editable = false;
                }
                field("Min Amount Limit"; Rec."Min Amount Limit")
                {
                }
                field("Max Amount Limit"; Rec."Max Amount Limit")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ApprovarName := '';
        AltApprovarName := '';
        ResCentName1 := '';
        ResCentName2 := '';
        IF Rec."Approvar ID" <> '' THEN BEGIN
            IF User.GET(Rec."Approvar ID") THEN
                ApprovarName := User."User Name";
        END;
        IF Rec."Alternate Approvar ID" <> '' THEN BEGIN
            IF User.GET(Rec."Alternate Approvar ID") THEN
                AltApprovarName := User."User Name";
        END;
        IF Rec."Approvar Responsibility Center" <> '' THEN BEGIN
            IF respCenter.GET(Rec."Approvar Responsibility Center") THEN
                ResCentName1 := respCenter.Name;
        END;
        IF Rec."Alt. App Responsibility Center" <> '' THEN BEGIN
            IF respCenter.GET(Rec."Alt. App Responsibility Center") THEN
                ResCentName2 := respCenter.Name;
        END;
    end;

    var
        ApprovarName: Text[200];
        AltApprovarName: Text[200];
        User: Record User;
        ResCentName1: Text[200];
        ResCentName2: Text[200];
        respCenter: Record "Responsibility Center 1";

    local procedure ApprovarIDOnAfterValidate()
    begin
        ResCentName1 := '';
        IF respCenter.GET(Rec."Approvar Responsibility Center") THEN
            ResCentName1 := respCenter.Name;
    end;

    local procedure AlternateApprovarIDOnAfterVali()
    begin
        ResCentName2 := '';
        IF respCenter.GET(Rec."Alt. App Responsibility Center") THEN
            ResCentName2 := respCenter.Name;
    end;
}

