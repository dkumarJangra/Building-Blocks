page 50103 "Reporting Office Card"
{
    PageType = Card;
    SourceTable = "Reporting Office Master";
    ApplicationArea = All;
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Cluster Code"; Rec."Cluster Code")
                {
                }
                field(Description; Rec.Description)
                {

                    trigger OnValidate()
                    begin
                        Rec.TESTFIELD(Status, Rec.Status::Open);
                    end;
                }
                field(Status; Rec.Status)
                {
                }
                field(Sequence; Rec.Sequence)
                {
                }
                field("Mobile Cluster Name"; Rec."Mobile Cluster Name")
                {
                }
                field("Mobile State Name"; Rec."Mobile State Name")
                {
                    Editable = false;
                }
                field("Mobile Cluster Sequence"; Rec."Mobile Cluster Sequence")
                {
                }
                field("Mobile State Id"; Rec."Mobile State Id")
                {
                }
                field("Region Code"; Rec."Region Code")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Release)
            {

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Release;
                end;
            }
            action("Re-open")
            {

                trigger OnAction()
                begin
                    Rec.Status := Rec.Status::Open;
                end;
            }
        }
    }
}

