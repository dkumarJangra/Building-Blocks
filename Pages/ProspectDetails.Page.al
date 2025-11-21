page 60700 "Prospect Details"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Customer Prospect Details";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contact No."; Rec."Contact No.")
                {
                    Caption = 'Contact No.';
                }
                field("Line No."; Rec."Line No.")
                {
                    Editable = false;
                }
                field("Project ID"; Rec."Project ID")
                {
                }
                field("Project Name"; Rec."Project Name")
                {
                }
                field("Unit ID"; Rec."Unit ID")
                {
                }
                field("Area"; Rec.Area)
                {
                }
                field(UOM; Rec.UOM)
                {
                }
                field("PPLan Code"; Rec."PPLan Code")
                {
                }
                field("PPLan Name"; Rec."PPLan Name")
                {
                }
                field("Plot Cost"; Rec."Plot Cost")
                {
                }
                field("Application Created"; Rec."Application Created")
                {
                }
                field("Application Creation Date"; Rec."Application Creation Date")
                {
                }
                field("Application Creation Time"; Rec."Application Creation Time")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                action("Create Interactions")
                {
                    RunObject = Page "Intraction Page";
                    RunPageLink = "Contact No." = FIELD("Contact No."),
                                  "Customer Prospect Line No." = FIELD("Line No.");

                    trigger OnAction()
                    var
                        CustomerIntractionDetails: Record "Customer Intraction Details";
                    begin
                    end;
                }
                action("Book Application")
                {

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Project ID");
                        Rec.TESTFIELD("Unit ID");
                        Rec.TESTFIELD("PPLan Code");
                        Rec.TESTFIELD("Application Created", FALSE);
                        IF CustomersContact.GET(Rec."Contact No.") THEN BEGIN
                            CustomersContact.TESTFIELD("Associate ID");

                            NewApplicationBooking.INIT;
                            NewApplicationBooking."Application Type" := NewApplicationBooking."Application Type"::"Non Trading";
                            NewApplicationBooking.Type := NewApplicationBooking.Type::Normal;
                            NewApplicationBooking."User Id" := USERID;
                            NewApplicationBooking.INSERT(TRUE);
                            NewApplicationBooking.VALIDATE("Shortcut Dimension 1 Code", Rec."Project ID");
                            NewApplicationBooking.VALIDATE("Bill-to Customer Name", 'Test');
                            //NewApplicationBooking.VALIDATE("Member's D.O.B","Payment transaction Details"."Date of Birth");
                            //NewApplicationBooking.VALIDATE("Mobile No.","Payment transaction Details"."Mobile No.");
                            NewApplicationBooking.VALIDATE("Associate Code", CustomersContact."Associate ID");
                            NewApplicationBooking.VALIDATE("Unit Payment Plan", Rec."PPLan Code");
                            NewApplicationBooking.VALIDATE("Unit Code", Rec."Unit ID"); //,UMaster."No.");
                            NewApplicationBooking.MODIFY;

                            IF NewApplicationBooking."Application No." <> '' THEN BEGIN
                                Rec."Application Created" := TRUE;
                                Rec."Application Creation Date" := TODAY;
                                Rec."Application Creation Time" := TIME;
                                Rec."Application No." := NewApplicationBooking."Application No.";

                                Rec.MODIFY;
                                MESSAGE('Application Created with Application No.-' + NewApplicationBooking."Application No.");
                            END;
                            CustomersContact."Lead Type" := CustomersContact."Lead Type"::Hot;
                            CustomersContact.Status := CustomersContact.Status::Close;
                            CustomersContact.MODIFY;
                        END;
                    end;
                }
            }
        }
    }

    var
        CustomerIntractionPage: Page "Intraction Page";
        CustomerIntractionSubPage: Page "Intraction Sub Page";
        CustomerIntractionDetails: Record "Customer Intraction Details";
        NewApplicationBooking: Record "New Application Booking";
        CustomersContact: Record "Customers Lead_2";
}

