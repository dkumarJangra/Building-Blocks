page 97819 "Responsibility Center Card New"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Responsibility Center 1";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Rec.Code)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Cluster Code"; Rec."Cluster Code")
                {
                }
                field("Full Name"; Rec."Full Name")
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("Location Code"; Rec."Location Code")
                {
                }
                field("Job Code"; Rec."Job Code")
                {
                }
                field(Branch; Rec.Branch)
                {
                }
                field("Subcon/Site Location"; Rec."Subcon/Site Location")
                {
                }
                field(Published; Rec.Published)
                {
                }
                field("Sequence of Project"; Rec."Sequence of Project")
                {
                }
                field("Active Projects"; Rec."Active Projects")
                {
                }
                field("Print Image on Reciept"; Rec."Print Image on Reciept")
                {
                }
                field("Project Bank Account No."; Rec."Project Bank Account No.")
                {
                }
                field(Blocked; Rec.Blocked)
                {
                }
                field("Branch Name"; Rec."Branch Name")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Fields Not Show on Receipt"; Rec."Fields Not Show on Receipt")
                {
                }
                field("Project Bank IFSC Code"; Rec."Project Bank IFSC Code")
                {
                }
                field("Project Branch Name"; Rec."Project Branch Name")
                {
                }
                field("Milestone Enabled"; Rec."Milestone Enabled")
                {
                }
                field("Min. Allotment %"; Rec."Min. Allotment %")
                {
                }
                field("Loan Applicable"; Rec."Loan Applicable")
                {
                }
            }
            group(Image)
            {
                field(Picture; Rec.Picture)
                {
                }
            }
            group(Web)
            {
                field("Publish Plot Cost"; Rec."Publish Plot Cost")
                {
                    Caption = 'Publish Plot Cost on web';
                }
                field("Publish CustomerName on Rcpt"; Rec."Publish CustomerName on Rcpt")
                {
                    Caption = 'Show Customer Name on Receipt Level';
                }
                field("Publish CustomerName"; Rec."Publish CustomerName")
                {
                    Caption = 'Publish Customer Name & Reg. No. on Web';
                }
            }
            group("No. Series")
            {
                field("Goods Receipt Nos."; Rec."Goods Receipt Nos.")
                {
                }
                field("Material Issue Nos."; Rec."Material Issue Nos.")
                {
                }
                field("GRN No. Series Direct"; Rec."GRN No. Series Direct")
                {
                }
                field("SRN Nos."; Rec."SRN Nos.")
                {
                }
            }
            group("Plot Popup Setup")
            {
                field("Min. Amt. Single plot for Web"; Rec."Min. Amt. Single plot for Web")
                {
                }
                field("Min. Amt. Double plot for Web"; Rec."Min. Amt. Double plot for Web")
                {
                }
                field("Min. Amt. Days (First Day)"; Rec."Min. Amt. Days (First Day)")
                {
                }
                field("Min. Amt. Option Change Day"; Rec."Min. Amt. Option Change Day")
                {
                }
                field("Allotment Amt Days (First Day)"; Rec."Allotment Amt Days (First Day)")
                {
                }
                field("Allotment Amt. Change Days"; Rec."Allotment Amt. Change Days")
                {
                }
                field("Option A Days (First Days)"; Rec."Option A Days (First Days)")
                {
                }
                field("Option A Option Change Days"; Rec."Option A Option Change Days")
                {
                }
                field("Option B Days (First Days)"; Rec."Option B Days (First Days)")
                {
                }
                field("Option B Option Change Days"; Rec."Option B Option Change Days")
                {
                }
                field("Option C Days (First Days)"; Rec."Option C Days (First Days)")
                {
                }
                field("Option C Option Change Days"; Rec."Option C Option Change Days")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            // action(Import)
            // {

            //     trigger OnAction()
            //     begin

            //         // PictureExists := Picture.HASVALUE;
            //         // IF Picture.IMPORT('*.BMP', TRUE) = '' THEN
            //         //     EXIT;
            //         IF PictureExists THEN
            //             IF NOT CONFIRM(Text001, FALSE, Rec.TABLECAPTION, Rec.Code) THEN
            //                 EXIT;
            //         CurrPage.SAVERECORD;
            //     end;
            // }
            // action("E&xport")
            // {

            //     trigger OnAction()
            //     begin

            //         // IF Picture.HASVALUE THEN
            //         //     Picture.EXPORT('*.BMP', TRUE);
            //     end;
            // }
            // action(Delete)
            // {

            //     trigger OnAction()
            //     begin

            //         //IF Picture.HASVALUE THEN
            //         IF CONFIRM(Text002, FALSE, Rec.TABLECAPTION, Rec.Code) THEN BEGIN
            //             CLEAR(Rec.Picture);
            //             CurrPage.SAVERECORD;
            //         END;
            //     end;
            // }
            action("&Attach Documents")
            {
                Caption = '&Attach Documents';
                RunObject = Page Documents;
                RunPageLink = "Table No." = CONST(97761),
                "Document No." = FIELD(Code);
            }
        }
    }

    var
        Mail: Codeunit Mail;
        PictureExists: Boolean;
        Text001: Label 'Do you want to replace the existing picture of %1 %2?';
        Text002: Label 'Do you want to delete the picture of %1 %2?';
}

