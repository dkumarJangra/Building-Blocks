page 50231 "Customer Login Details"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Customer Login Details";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(USER_ID; Rec.USER_ID)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Name 2"; Rec."Name 2")
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
                field("Post Code"; Rec."Post Code")
                {
                }
                field(County; Rec.County)
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field("State Code"; Rec."State Code")
                {
                }
                field("District Code"; Rec."District Code")
                {

                }
                field("Mandal Code"; Rec."Mandal Code")
                {

                }
                field("Village Code"; Rec."Village Code")
                {

                }

                field("P.A.N. No."; Rec."P.A.N. No.")
                {
                }
                field("Mobile No."; Rec."Mobile No.")
                {
                }
                field(Occupation; Rec.Occupation)
                {
                }
                field("Aadhar Card No."; Rec."Aadhar Card No.")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field(Password; Rec.Password)
                {
                }
                field("Address 3"; Rec."Address 3")
                {
                }
                field("Date of Birth"; Rec."Date of Birth")
                {
                }
                field(Age; Rec.Age)
                {
                }
                field(Sex; Rec.Sex)
                {
                }
                field("Father's/Husband's Name"; Rec."Father's/Husband's Name")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }

            }

        }
    }

    actions
    {
        area(navigation)
        {
            action(CreateCustomer)
            {
                Caption = 'Create Customer';

                trigger OnAction()
                var
                    Customer: Record Customer;
                    BondSetup: Record "Unit Setup";
                    CustomerLoginDetails: Record "Customer Login Details";
                begin
                    BondSetup.GET;

                    CustomerLoginDetails.RESET;
                    CustomerLoginDetails.SETRANGE("NAV-Customer Created", FALSE);
                    CustomerLoginDetails.SETFILTER(Status, '<>%1', CustomerLoginDetails.Status::Reject);
                    IF CustomerLoginDetails.FINDSET THEN
                        REPEAT
                            Customer.INIT;
                            Customer.VALIDATE(Name, Rec.Name);
                            Customer."Customer Posting Group" := BondSetup."Customer Posting Group";
                            Customer."No. Series" := BondSetup."Customer No Series";
                            Customer."BBG Father's/Husband's Name" := CustomerLoginDetails."Father's/Husband's Name";
                            Customer."BBG Mobile No." := CustomerLoginDetails."Mobile No.";
                            Customer."BBG Date of Birth" := CustomerLoginDetails."Date of Birth";
                            Customer."E-Mail" := CustomerLoginDetails."E-Mail";
                            Customer."BBG Date of Joining" := CustomerLoginDetails."Creation Date";
                            Customer."State Code" := CustomerLoginDetails."State Code";
                            //Code added Start 23072025
                            Customer."District Code" := CustomerLoginDetails."District Code";
                            Customer."Mandal Code" := CustomerLoginDetails."Mandal Code";
                            Customer."Village Code" := CustomerLoginDetails."Village Code";
                            Customer."Country/Region Code" := 'IN'; //Code added 23072025
                            //Code added End 23072025
                            Customer.INSERT(TRUE);
                            CustomerLoginDetails."NAV-Customer Created" := TRUE;
                            CustomerLoginDetails."NAV-Customer Creation Date" := TODAY;
                            CustomerLoginDetails."Customer No." := Customer."No.";
                            CustomerLoginDetails.MODIFY;
                        UNTIL CustomerLoginDetails.NEXT = 0;
                end;
            }
            action(ChangeStatus)
            {

                trigger OnAction()
                var
                    Selection: Integer;
                begin
                    IF CONFIRM('Do you want to Change Status.') THEN BEGIN
                        Selection := STRMENU(Text002, 2);
                        IF Selection <> 0 THEN BEGIN
                            IF Selection = 1 THEN
                                Rec.Status := Rec.Status::"Under Process"
                            ELSE
                                Rec.Status := Rec.Status::Reject;
                            Rec."Mobile No." := 'R' + Rec."Mobile No.";
                            Rec.MODIFY;
                        END;
                        MESSAGE('Status Updated');
                    END ELSE
                        MESSAGE('Nothing Process');
                end;
            }
        }
    }

    var
        Text002: Label '&Under Process,&Reject';
}

