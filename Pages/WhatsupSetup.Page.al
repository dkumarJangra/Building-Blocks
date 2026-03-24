page 50649 "Whatsup Setup"
{
    Caption = 'WhatsApp Setup';
    PageType = Card;
    SourceTable = 50575;
    UsageCategory = Tasks;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Primary Key"; Rec."Primary Key")
                {
                }
                field("User Name"; Rec."User Name")
                {
                }
                field(Password; Rec.Password)
                {
                }
                field(Mobile; Rec.Mobile)
                {
                }
                field("API Key"; Rec."API Key")
                {
                }
                field(Header; Rec.Header)
                {
                }
                field("Header 2"; Rec."Header 2")
                {
                }
                field("Header Value"; Rec."Header Value")
                {
                }
                field("Header Value 2"; Rec."Header Value 2")
                {
                }
                field("API URL"; Rec."API URL")
                {
                }
                field("API URL2"; Rec."API URL2")
                {
                }
                field("API URL Mobile Number"; Rec."API URL Mobile Number")
                {
                }
                field(Method; Rec.Method)
                {
                }
                field("File Path"; Rec."File Path")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.RESET();
        IF NOT Rec.GET() THEN BEGIN
            Rec.INIT();
            Rec.INSERT();
        END;
    end;
}

