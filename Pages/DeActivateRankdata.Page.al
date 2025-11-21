page 50169 "DeActivate Rank data"
{
    PageType = List;
    SourceTable = "Deactivate Region wise Vendor";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Region Code"; Rec."Region Code")
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Parent Code"; Rec."Parent Code")
                {
                }
                field("Rank Code"; Rec."Rank Code")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Parent Rank"; Rec."Parent Rank")
                {
                }
                field("Associate Level"; Rec."Associate Level")
                {
                }
                field("Old No."; Rec."Old No.")
                {
                }
                field("Old Parent Code"; Rec."Old Parent Code")
                {
                }
                field("Region Description"; Rec."Region Description")
                {
                }
                field("Vendor Check Status"; Rec."Vendor Check Status")
                {
                }
                field("Parent Description"; Rec."Parent Description")
                {
                }
                field("Rank Description"; Rec."Rank Description")
                {
                }
                field("Parent Name"; Rec."Parent Name")
                {
                }
                field(Priority; Rec.Priority)
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field("Associate DOJ"; Rec."Associate DOJ")
                {
                }
                field("Parent Associate DOJ"; Rec."Parent Associate DOJ")
                {
                }
                field("New Region Code"; Rec."New Region Code")
                {
                }
                field("Introducer Update on Vendor"; Rec."Introducer Update on Vendor")
                {
                }
                field("Team Head"; Rec."Team Head")
                {
                }
                field("Print Team Head"; Rec."Print Team Head")
                {
                }
                field("Deactivate Associate Code"; Rec."Deactivate Associate Code")
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
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Show Deactivate Associates", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Please contact Admin');
    end;

    var
        UserSetup: Record "User Setup";
}

