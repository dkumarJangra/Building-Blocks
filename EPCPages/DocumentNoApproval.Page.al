page 97725 "Document No Approval"
{
    AutoSplitKey = true;
    DeleteAllowed = false;
    InsertAllowed = false;
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
                field("Line No"; Rec."Line No")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Approvar ID"; Rec."Approvar ID")
                {
                    Editable = false;
                }
                field(ApprovarName; ApprovarName)
                {
                    Caption = 'Approvar Name';
                    Editable = false;
                    //OptionCaption = 'Approvar Name';
                }
                field("Alternate Approvar ID"; Rec."Alternate Approvar ID")
                {
                    AssistEdit = false;
                    DrillDown = false;
                    Editable = false;
                    Visible = true;
                }
                field(AltApprovarName; AltApprovarName)
                {
                    Caption = 'Alt Approvar Name';
                    Editable = false;
                    Visible = true;
                }
                field("Approval Remarks"; Rec."Approval Remarks")
                {

                    trigger OnValidate()
                    begin
                        IF NOT ((Rec."Approvar ID" = UPPERCASE(USERID)) OR (Rec."Alternate Approvar ID" = UPPERCASE(USERID))) THEN
                            ERROR('Un-Authorised User');
                    end;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Min Amount Limit"; Rec."Min Amount Limit")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Max Amount Limit"; Rec."Max Amount Limit")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Authorized ID"; Rec."Authorized ID")
                {
                    Editable = false;
                }
                field("Authorized Date"; Rec."Authorized Date")
                {
                    Editable = false;
                }
                field("Authorized Time"; Rec."Authorized Time")
                {
                    Editable = false;
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
        IF Rec."Approvar ID" <> '' THEN BEGIN
            IF Employee.GET(Rec."Approvar ID") THEN
                ApprovarName := Employee."User Name";
        END;
        IF Rec."Alternate Approvar ID" <> '' THEN BEGIN
            IF Employee.GET(Rec."Alternate Approvar ID") THEN
                AltApprovarName := Employee."User Name";
        END;
    end;

    var
        ApprovarName: Text[200];
        AltApprovarName: Text[200];
        Employee: Record User;
}

