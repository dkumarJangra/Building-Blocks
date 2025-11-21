page 97938 "Report Sign. Selection Card"
{
    Caption = 'Report Signature Selection Card';
    PageType = Card;
    SourceTable = "Report Signature Selections";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Report ID"; Rec."Report ID")
                {
                }
                field("Report Name"; Rec."Report Name")
                {
                }
                field(Signature; Rec.Signature)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Signature")
            {
                Caption = '&Signature';
                action(Import)
                {
                    Caption = 'Import';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        // PictureExists := Signature.HASVALUE;
                        // IF Signature.IMPORT('*.BMP', TRUE) = '' THEN
                        //     EXIT;
                        IF PictureExists THEN
                            IF NOT CONFIRM(Text001, FALSE) THEN
                                EXIT;
                        CurrPage.SAVERECORD;
                    end;
                }
                action("E&xport")
                {
                    Caption = 'E&xport';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        // IF Signature.HASVALUE THEN
                        //     Signature.EXPORT('*.BMP', TRUE);
                    end;
                }
                action(Delete)
                {
                    Caption = 'Delete';

                    trigger OnAction()
                    begin
                        //IF Signature.HASVALUE THEN
                        IF CONFIRM(Text002, FALSE) THEN BEGIN
                            CLEAR(Rec.Signature);
                            CurrPage.SAVERECORD;
                        END;
                    end;
                }
            }
        }
    }

    var
        PictureExists: Boolean;
        Text001: Label 'Do you want to replace the existing picture?';
        Text002: Label 'Do you want to delete the picture?';
}

