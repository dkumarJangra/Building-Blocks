pageextension 50007 "BBG Customer List Ext" extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
        modify("Phone No.")
        {
            Visible = PhVisible;
        }
        modify("Post Code")
        {
            ApplicationArea = all;
            Visible = true;
        }
        addafter(Name)
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = all;
                Visible = AddVisible;
            }
            field(City; Rec.City)
            {
                ApplicationArea = all;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = all;
            }
            field("BBG Phone No. 2"; Rec."BBG Phone No. 2")
            {
                ApplicationArea = all;
                Visible = Ph2Visible;
            }
            field("BBG Mobile No."; Rec."BBG Mobile No.")
            {
                ApplicationArea = all;
                Visible = MobVisible;
            }
            field("BBG Date of Birth"; Rec."BBG Date of Birth")
            {
                ApplicationArea = all;
            }
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = all;
            }
            field("BBG Address 3"; Rec."BBG Address 3")
            {
                ApplicationArea = all;
            }

            field("State Code"; Rec."State Code")
            {
                ApplicationArea = all;
            }
            field("District Code"; Rec."District Code")
            {
                ApplicationArea = all;
            }
            field("Mandal Code"; Rec."Mandal Code")
            {
                ApplicationArea = all;
            }
            field("Village Code"; Rec."Village Code")
            {
                ApplicationArea = all;
            }
            field("BBG Aadhar No."; Rec."BBG Aadhar No.")
            {
                ApplicationArea = all;
            }
            field("BBG District"; Rec."BBG District")
            {
                ApplicationArea = all;
            }
            field("BBG Occupation"; Rec."BBG Occupation")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        modify(CancelApprovalRequest)
        {
            Visible = false;
        }
    }

    var
        myInt: Integer;
        Memberof: Record "Access Control";
        MobVisible: Boolean;
        AddVisible: Boolean;
        Add2Visible: Boolean;
        Add3Visible: Boolean;
        PhVisible: Boolean;
        Ph2Visible: Boolean;
        ContactVisible: Boolean;

    trigger OnOpenPage()
    begin
        Showfields;  //BBG2.01 010814
    end;

    trigger OnAfterGetRecord()
    begin
        Showfields;  //BBG2.01 010814
    end;

    PROCEDURE Showfields();
    BEGIN
        //BBG2.01 22/07/14
        CLEAR(Memberof);
        Memberof.RESET;
        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETRANGE("Role ID", 'CustListInfoVisible');
        IF NOT Memberof.FINDFIRST THEN BEGIN
            MobVisible := FALSE;
            AddVisible := FALSE;
            Add2Visible := FALSE;
            Add3Visible := FALSE;
            PhVisible := FALSE;
            Ph2Visible := FALSE;
            ContactVisible := FALSE;
        END ELSE BEGIN
            MobVisible := TRUE;
            AddVisible := TRUE;
            Add2Visible := TRUE;
            Add3Visible := TRUE;
            PhVisible := TRUE;
            Ph2Visible := TRUE;
            ContactVisible := TRUE;
        END;
        //BBG2.01 22/07/14
    END;
}