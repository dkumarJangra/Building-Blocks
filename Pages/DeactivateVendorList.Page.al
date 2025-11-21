page 50168 "Deactivate Vendor List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "De-Activate Vendors";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Address; Rec.Address)
                {
                }
                field("Address 2"; Rec."Address 2")
                {
                }
                field(City; Rec.City)
                {
                }
                field("Phone No."; Rec."Phone No.")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field(Balance; Rec.Balance)
                {
                }
                field("Net Change"; Rec."Net Change")
                {
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                }
                field(Picture; Rec.Picture)
                {
                }
                field("Post Code"; Rec."Post Code")
                {
                }
                field(County; Rec.County)
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                }
                field("T.I.N. No."; Rec."T.I.N. No.")
                {
                }
                field("P.A.N. No."; Rec."P.A.N. No.")
                {
                }
                field("State Code"; Rec."State Code")
                {
                }
                field("P.A.N. Reference No."; Rec."P.A.N. Reference No.")
                {
                }
                field("P.A.N. Status"; Rec."P.A.N. Status")
                {
                }
                field("GST Registration No."; Rec."GST Registration No.")
                {
                }
                field("GST Vendor Type"; Rec."GST Vendor Type")
                {
                }
                field("Address 3"; Rec."Address 3")
                {
                }
                field("Phone No. 2"; Rec."Phone No. 2")
                {
                }
                field("Mob. No."; Rec."Mob. No.")
                {
                }
                field("Vendor Category"; Rec."Vendor Category")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Black List"; Rec."Black List")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                }
                field("Date of Joining"; Rec."Date of Joining")
                {
                }
                field(Introducer; Rec.Introducer)
                {
                }
                field("Rank Parent exists"; Rec."Rank Parent exists")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Replication in All Companies")
            {
                //RunObject = Report 50002;

                trigger OnAction()
                begin
                    UserSetup.RESET;
                    UserSetup.GET(USERID);
                    IF UserSetup.FINDFIRST THEN;
                end;
            }
        }
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

