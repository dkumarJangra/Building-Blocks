page 97978 "Unit Type Card"
{
    // ALLECK 140513 : Code added for making the form Uneditable on Releasing

    PageType = Card;
    SourceTable = "Unit Type";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Code; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Bond Nos."; Rec."Bond Nos.")
                {
                    Caption = 'Unit No.';
                }
                field("Company Name"; Rec."Company Name")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("F&unction")
            {
                Caption = 'F&unction';
                action(Open)
                {
                    Caption = 'Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Return';

                    trigger OnAction()
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Setups Creation", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');


                        Rec.Status := Rec.Status::Open;
                        CurrPage.EDITABLE(TRUE);
                        Rec.MODIFY;
                    end;
                }
                action(Release)
                {
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Setups Approval", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');

                        Rec.Status := Rec.Status::Release;
                        CurrPage.EDITABLE(FALSE);
                        Rec.MODIFY;
                    end;
                }
            }
        }
    }

    var
        UserSetup: Record "User Setup";
}

