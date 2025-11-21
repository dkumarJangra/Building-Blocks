page 97881 "Vendor Enquiry Card"
{
    PageType = Document;
    SourceTable = "Vendor Enquiry Details";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Enquiry no."; Rec."Enquiry no.")
                {
                }
                field("Indent No."; Rec."Indent No.")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Job Code"; Rec."Job Code")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Package Name"; Rec."Package Name")
                {
                }
                field("Job Task"; Rec."Job Task")
                {
                }
                field("Job Task Name"; Rec."Job Task Name")
                {
                }
                field(Location; Rec.Location)
                {
                }
                field("Location Name"; Rec."Location Name")
                {
                }
                field(Remarks; Rec.Remarks)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Pr Type"; Rec."Pr Type")
                {
                }
                field(Initiator; Rec.Initiator)
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Vendor Address"; Rec."Vendor Address")
                {
                }
                field("Vendor City"; Rec."Vendor City")
                {
                }
                field("Tax Rate"; Rec."Tax Rate")
                {
                }
            }
            part(""; "Enquiry Subform")
            {
                SubPageLink = "Enquiry No." = FIELD("Enquiry no.");
            }
        }
    }

    actions
    {
        area(creation)
        {
            group("Function")
            {
                action("&Change Status")
                {

                    trigger OnAction()
                    begin

                        IF (Rec.Status = Rec.Status::Close) OR (Rec.Status = Rec.Status::Cancel) THEN
                            ERROR(Text50002, Rec.Status);
                        BEGIN
                            Selection := STRMENU(Text50001, 2);
                            IF Selection = 2 THEN BEGIN
                                IF Rec.Status = Rec.Status::Sent THEN
                                    ERROR(Text50002, 'Sent');
                                Rec.Status := Rec.Status::Close;
                            END ELSE
                                IF Selection = 3 THEN
                                    Rec.Status := Rec.Status::Cancel;
                            IF Selection = 4 THEN
                                Rec.Status := Rec.Status::Sent;
                            Rec.MODIFY;
                        END;
                    end;
                }
                action("&Attach Documents")
                {
                    RunObject = Page Documents;
                    RunPageLink = "Table No." = CONST(50021),
                                  "Reference No. 1" = CONST('1'),
                                  "Reference No. 2" = FIELD("Enquiry no.");
                }
            }
        }
    }

    var
        OfferDoc: Boolean;
        RecDocumentLine: Record "Purchase Request Line";
        VendorEnquiryDetails: Record "Vendor Enquiry Details";
        Selection: Integer;
        UserMgt: Codeunit "User Setup Management";
        //SMTPMail: Codeunit 400;
        Var1: Text[200];
        Var2: Decimal;
        Var3: Code[10];
        EnquiryLine: Record "Enquiry Line";
        //SMTPMailSetup: Record "SMTP Mail Setup";
        Vend: Record Vendor;
        ERR1: Label 'For selecting item you have to create Enquiry No.';
        Text50001: Label 'Open,Close,Cancel,Sent';
        Text50002: Label 'Status must not be %1.';
}

