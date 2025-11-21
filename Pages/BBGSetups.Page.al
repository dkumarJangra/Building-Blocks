page 60686 "BBG Setups"
{
    // ALLESSS 19/02/24 : Fields Added "Project Approver 1", "Project Approver 2" to approve Project Card

    PageType = List;
    SourceTable = "BBG Setups";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Acres; Rec.Acres)
                {
                }
                field(Guntas; Rec.Guntas)
                {
                }
                field(Ankanan; Rec.Ankanan)
                {
                }
                field(Cents; Rec.Cents)
                {
                }
                field("Sq. Yard"; Rec."Sq. Yard")
                {
                }
                field("Jagrati Lable"; Rec."Jagrati Lable")
                {
                }
                field("Jagrati Link"; Rec."Jagrati Link")
                {
                }
                field("Project Doc Path Save in NAV"; Rec."Project Doc Path Save in NAV")
                {
                    Editable = false;
                }
                field("Project Doc Path for Mobile"; Rec."Project Doc Path for Mobile")
                {
                    Editable = false;
                }
                field("Gold/Silver New Setup StDt."; Rec."Gold/Silver New Setup StDt.")
                {
                }
                field("Gold/Silver New Setup EndDt."; Rec."Gold/Silver New Setup EndDt.")
                {
                }
                field("Coupon Date for R001"; Rec."Coupon Date for R001")
                {
                }
                field("Coupon Date for R002"; Rec."Coupon Date for R002")
                {
                }
                field("Upload Document Jagrati Path"; Rec."Upload Document Jagrati Path")
                {
                }
                field("No. of Days for Hot Lead"; Rec."No. of Days for Hot Lead")
                {
                }
                field("No. of Days for Cold Lead"; Rec."No. of Days for Cold Lead")
                {
                }
                field(SMS; Rec.SMS)
                {
                }
                field("Lead Approver 1"; Rec."Lead Approver 1")
                {
                }
                field("Lead Approver 2"; Rec."Lead Approver 2")
                {
                }
                field("Oppurtinity Approver 1"; Rec."Oppurtinity Approver 1")
                {
                }
                field("Oppurtinity Approver 2"; Rec."Oppurtinity Approver 2")
                {
                }
                field("Aggrement Approver 1"; Rec."Aggrement Approver 1")
                {
                }
                field("Aggrement Approver 2"; Rec."Aggrement Approver 2")
                {
                }
                field("Land Expense JV Temp Name"; Rec."Land Expense JV Temp Name")
                {
                }
                field("Land Expense JV Batch Name"; Rec."Land Expense JV Batch Name")
                {
                }
                field("Land Expense Dim. No.Series"; Rec."Land Expense Dim. No.Series")
                {
                }
                field("Old Image Path"; Rec."Old Image Path")
                {
                }
                field("New Associate Doc Attach Path"; Rec."New Associate Doc Attach Path")
                {
                }
                field("New Upload Doc. Jagrati Path"; Rec."New Upload Doc. Jagrati Path")
                {
                }
                field("Land Lead No. Series"; Rec."Land Lead No. Series")
                {
                }
                field("Land Opportunity No. Series"; Rec."Land Opportunity No. Series")
                {
                }
                field("Loan EMI No. Series"; Rec."Loan EMI No. Series")
                {
                }
                field("Loan Rate of Interest"; Rec."Loan Rate of Interest")
                {
                }
                field("Land Payment No. Series"; Rec."Land Payment No. Series")
                {
                }
                field("Land Bank Pmt. Template Name"; Rec."Land Bank Pmt. Template Name")
                {
                }
                field("Land Bank Pmt. Batch Name"; Rec."Land Bank Pmt. Batch Name")
                {
                }
                field("Associate Target Request No."; Rec."Associate Target Request No.")
                {
                }
                field("Project Approver 1"; Rec."Project Approver 1")
                {
                }
                field("Project Approver 2"; Rec."Project Approver 2")
                {
                }
                field("Event Image Path"; Rec."Event Image Path")
                {
                }
                field("Special Incentive Bonanza G/L"; Rec."Special Incentive Bonanza G/L")
                {
                }
                field("Special Inct. Bonanza Cash G/L"; Rec."Special Inct. Bonanza Cash G/L")
                {
                }
                //251124 Code added Start

                field("Land Vend Helpdesk Rcv Mail ID"; Rec."Land Vend Helpdesk Rcv Mail ID")
                {

                }
                field("New Land Request Rcv Mail ID"; Rec."New Land Request Rcv Mail ID")
                {

                }
                field("Land Vend Helpdesk Sender Mail"; Rec."Land Vend Helpdesk Sender Mail")
                {

                }
                field("New Land Request SenderMail ID"; Rec."New Land Request SenderMail ID")
                {

                }
                field("Land Vend Helpdesk Sender PWD"; Rec."Land Vend Helpdesk Sender PWD")
                {

                }
                field("New Land Request Sender PWD"; Rec."New Land Request Sender PWD")
                {

                }
                field("Upload Doc. Jagriti Path(BC)"; Rec."Upload Doc. Path(BC)")
                {

                }

                field("Download Doc. Jagriti Path(BC)"; Rec."Download Doc. Jagriti Path(BC)")
                {

                }
                Field("Project Doc Path Save in (BC)"; Rec."Project Doc Path Save in (BC)")
                {

                }
                field("Social Media Image Path"; Rec."Social Media Image Path")
                {

                }

                //251124 Code added END
            }
        }
    }

    actions
    {
    }
}

