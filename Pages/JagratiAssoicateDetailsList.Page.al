page 50209 "Jagrati Assoicate Details List"
{
    CardPageID = "Jagrati Associate Req. Details";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Jagriti Assoicate Details";
    SourceTableView = WHERE("Special Request" = CONST(false));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Request No."; Rec."Request No.")
                {
                }
                field("Requester ID"; Rec."Requester ID")
                {
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                }
                field("P.A.N. No."; Rec."P.A.N. No.")
                {
                }
                field(Month; Rec.Month)
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                }
                field("Direct/Team Bonanza Selection"; Rec."Direct/Team Bonanza Selection")
                {
                }
                field("if Direct Applications"; Rec."if Direct Applications")
                {
                }
                field("Customer Application No."; Rec."Customer Application No.")
                {
                }
                field("Selection Type"; Rec."Selection Type")
                {
                }
                field("From Associate ID"; Rec."From Associate ID")
                {
                }
                field("To Associate ID"; Rec."To Associate ID")
                {
                }
                field("Upload Document"; Rec."Upload Document")
                {
                }
                field("Aadhar Card No."; Rec."Aadhar Card No.")
                {
                }
                field("Bank Name"; Rec."Bank Name")
                {
                }
                field("Bank Account No."; Rec."Bank Account No.")
                {
                }
                field("Bank IFSC Code"; Rec."Bank IFSC Code")
                {
                }
                field("Request Type"; Rec."Request Type")
                {
                }
                field("Reporting Leader"; Rec."Reporting Leader")
                {
                }
                field("Site Code"; Rec."Site Code")
                {
                }
                field("Request Date"; Rec."Request Date")
                {
                }
                field("Request Time"; Rec."Request Time")
                {
                }
                field("IBA ID"; Rec."IBA ID")
                {
                }
                field("IBA Name"; Rec."IBA Name")
                {
                }
                field("Associate Id to Activate"; Rec."Associate Id to Activate")
                {
                }
                field("Associate Id to Activate Name"; Rec."Associate Id to Activate Name")
                {
                }
                field("No. of Team Bonanza"; Rec."No. of Team Bonanza")
                {
                }
                field("Extent Value"; Rec."Extent Value")
                {
                }
                field("Request 1"; Rec."Request 1")
                {
                }
                field("Request 2"; Rec."Request 2")
                {
                }
                field("Request 3"; Rec."Request 3")
                {
                }
                field("Request 4"; Rec."Request 4")
                {
                }
                field("Request in blob"; Rec."Request in blob")
                {
                }
                field("Request 5"; Rec."Request 5")
                {
                }
                field("Request 6"; Rec."Request 6")
                {
                }
                field("Request 7"; Rec."Request 7")
                {
                }
                field("Team Code"; Rec."Team Code")
                {
                }
                field("Leader Code"; Rec."Leader Code")
                {
                }
                field("Sub Team Code"; Rec."Sub Team Code")
                {
                }
                field("Request Status"; Rec."Request Status")
                {
                }
                field("Request Pending From"; Rec."Request Pending From")
                {
                }
                field("Help desk Id"; Rec."Help desk Id")
                {
                }
                field("Last Approval / Reject Date"; Rec."Last Approval / Reject Date")
                {
                    Caption = 'Approval / Reject Date';
                }
                field("Last Approval / Reject Time"; Rec."Last Approval / Reject Time")
                {
                    Caption = 'Approval / Reject Time';
                }
            }
        }
    }

    actions
    {
    }
}

