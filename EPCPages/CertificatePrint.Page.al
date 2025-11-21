page 97894 "Certificate Print"
{
    PageType = List;
    SourceTable = "Confirmed Order";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
            }
            field("Bond Type Filter"; BondTypeFilter)
            {
                TableRelation = "Unit Type".Code;
            }
            field("Introducer Code Filter"; IntroducerCodeFilter)
            {
            }
            field("Bond Filter"; BondNoFilter)
            {
            }
            field("Bonds in Filter"; Rec.COUNT)
            {
            }
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Scheme Code"; Rec."Scheme Code")
                {
                }
                field("Project Type"; Rec."Project Type")
                {
                }
                field(Duration; Rec.Duration)
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                }
                field("Maturity Amount"; Rec."Maturity Amount")
                {
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                }
                field("Application No."; Rec."Application No.")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("User Id"; Rec."User Id")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Investment Frequency"; Rec."Investment Frequency")
                {
                }
                field("Return Frequency"; Rec."Return Frequency")
                {
                }
                field("Service Charge Amount"; Rec."Service Charge Amount")
                {
                }
                field("Bond Category"; Rec."Bond Category")
                {
                }
                field("Posted Doc No."; Rec."Posted Doc No.")
                {
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                }
                field("Return Payment Mode"; Rec."Return Payment Mode")
                {
                }
                field("Received From"; Rec."Received From")
                {
                }
                field("Received From Code"; Rec."Received From Code")
                {
                }
                field("Version No."; Rec."Version No.")
                {
                }
                field("Maturity Bonus Amount"; Rec."Maturity Bonus Amount")
                {
                }
                field("Creation Time"; Rec."Creation Time")
                {
                }
                field("Customer No. 2"; Rec."Customer No. 2")
                {
                }
                field("Bond Posting Group"; Rec."Bond Posting Group")
                {
                }
                field("Investment Type"; Rec."Investment Type")
                {
                }
                field("Dispute Remark"; Rec."Dispute Remark")
                {
                }
                field("Return Bank Account Code"; Rec."Return Bank Account Code")
                {
                }
                field("Return Amount"; Rec."Return Amount")
                {
                }
                field("With Cheque"; Rec."With Cheque")
                {
                }
                field("Last Certificate Printed On"; Rec."Last Certificate Printed On")
                {
                }
                field("Amount Received"; Rec."Amount Received")
                {
                }
                field("Reg. Document Issue"; Rec."Reg. Document Issue")
                {
                }
                field("Issue Date"; Rec."Issue Date")
                {
                }
                field("Reg. Office"; Rec."Reg. Office")
                {
                }
                field("Registration In Favour Of"; Rec."Registration In Favour Of")
                {
                }
                field("Registered/Office Name"; Rec."Registered/Office Name")
                {
                }
                field("Reg. Address"; Rec."Reg. Address")
                {
                }
                field("Father/Husband Name"; Rec."Father/Husband Name")
                {
                }
                field("Branch Code"; Rec."Branch Code")
                {
                }
                field("Registered City"; Rec."Registered City")
                {
                }
                field("Zip Code"; Rec."Zip Code")
                {
                }
                field("Gold Coin Generated"; Rec."Gold Coin Generated")
                {
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                }
                field("Incl. Mem. Fee"; Rec."Incl. Mem. Fee")
                {
                }
                field("Incentive Calculate"; Rec."Incentive Calculate")
                {
                }
                field("Discount Payment Type"; Rec."Discount Payment Type")
                {
                }
                field("Forfeiture / Excess Amount"; Rec."Forfeiture / Excess Amount")
                {
                }
                field("Comm. Amt Adj. in case Forfeit"; Rec."Comm. Amt Adj. in case Forfeit")
                {
                }
                field("Travel Not Generate"; Rec."Travel Not Generate")
                {
                }
                field("Commission Hold on Full Pmt"; Rec."Commission Hold on Full Pmt")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Application Type"; Rec."Application Type")
                {
                }
                field("Application Transfered"; Rec."Application Transfered")
                {
                }
                field("Total Elegibility Amount"; Rec."Total Elegibility Amount")
                {
                }
                field("Filters on Team Head"; Rec."Filters on Team Head")
                {
                }
                field("Silver Coin Generated"; Rec."Silver Coin Generated")
                {
                }
                field("Silver Coin Eligible"; Rec."Silver Coin Eligible")
                {
                }
                field("Total Clear App. Amt"; Rec."Total Clear App. Amt")
                {
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                }
                field("New Unit Payment Plan"; Rec."New Unit Payment Plan")
                {
                }
                field("Unit Plan Name"; Rec."Unit Plan Name")
                {
                }
                field("Gold Coin Transfer in Trading"; Rec."Gold Coin Transfer in Trading")
                {
                }
                field("Silver Coin Issued"; Rec."Silver Coin Issued")
                {
                }
                field("Gold Coin Value"; Rec."Gold Coin Value")
                {
                }
                field("Silver Coin Value"; Rec."Silver Coin Value")
                {
                }
                field("Sales Invoice booked"; Rec."Sales Invoice booked")
                {
                }
                field("Posted Sales Inv. Doc. No."; Rec."Posted Sales Inv. Doc. No.")
                {
                }
                field("Method Applicable"; Rec."Method Applicable")
                {
                }
                field("Sales Invoice Applicable"; Rec."Sales Invoice Applicable")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Registration No."; Rec."Registration No.")
                {
                }
                field("Registration Date"; Rec."Registration Date")
                {
                }
                field("Commission Reversed"; Rec."Commission Reversed")
                {
                }
                field("Penalty Amount"; Rec."Penalty Amount")
                {
                }
                field("Travel Calculated"; Rec."Travel Calculated")
                {
                }
                field("Amount Refunded"; Rec."Amount Refunded")
                {
                }
                field("Penalty Document No."; Rec."Penalty Document No.")
                {
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                }
                field("Travel Entry No."; Rec."Travel Entry No.")
                {
                }
                field("Dummay Unit Code"; Rec."Dummay Unit Code")
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("New Unit No."; Rec."New Unit No.")
                {
                }
                field("Payment Plan"; Rec."Payment Plan")
                {
                }
                field("New Project"; Rec."New Project")
                {
                }
                field("New Member"; Rec."New Member")
                {
                }
                field("Commission Amt."; Rec."Commission Amt.")
                {
                }
                field("Commission Paid"; Rec."Commission Paid")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Commission Not Generate"; Rec."Commission Not Generate")
                {
                }
                field("Comm. Base Amt. to be Adj."; Rec."Comm. Base Amt. to be Adj.")
                {
                }
                field("Commission Base Amount"; Rec."Commission Base Amount")
                {
                }
                field("Direct Associate Amount"; Rec."Direct Associate Amount")
                {
                }
                field("Total Comm & Direct Assc. Amt."; Rec."Total Comm & Direct Assc. Amt.")
                {
                }
                field("Amount Adj. Associate"; Rec."Amount Adj. Associate")
                {
                }
                field("BBG Discount"; Rec."BBG Discount")
                {
                }
                field("Net Due Amount"; Rec."Net Due Amount")
                {
                }
                field("Commission Amount"; Rec."Commission Amount")
                {
                }
                field("Travel Generate"; Rec."Travel Generate")
                {
                }
                field("AJVM Associate Code"; Rec."AJVM Associate Code")
                {
                }
                field("Net Discount Amount"; Rec."Net Discount Amount")
                {
                }
                field("AJVM Associate Balance"; Rec."AJVM Associate Balance")
                {
                }
                field("Pass Book No."; Rec."Pass Book No.")
                {
                }
                field("Unit Vacate Date"; Rec."Unit Vacate Date")
                {
                }
                field("Expexted Discount by BBG"; Rec."Expexted Discount by BBG")
                {
                }
                field("Bill-to Customer Name"; Rec."Bill-to Customer Name")
                {
                }
                field("Unit Facing"; Rec."Unit Facing")
                {
                }
                field("Registration Bonus Hold(BSP2)"; Rec."Registration Bonus Hold(BSP2)")
                {
                }
                field(MinAmt; Rec.MinAmt)
                {
                }
                field("RB Amount"; Rec."RB Amount")
                {
                }
                field("Received RB Amount"; Rec."Received RB Amount")
                {
                }
                field("Commission RB Amount"; Rec."Commission RB Amount")
                {
                }
                field("Gold Coin Issued"; Rec."Gold Coin Issued")
                {
                }
                field("Registration SMS Sent"; Rec."Registration SMS Sent")
                {
                }
                field("Before Registration SMS Sent"; Rec."Before Registration SMS Sent")
                {
                }
                field("Sent SMS on Plot Cancellation"; Rec."Sent SMS on Plot Cancellation")
                {
                }
                field("Sent SMS on Full Amount"; Rec."Sent SMS on Full Amount")
                {
                }
                field("Sent SMS on Acknoledgement"; Rec."Sent SMS on Acknoledgement")
                {
                }
                field("Sent SMS on Full Pmt Gold Coin"; Rec."Sent SMS on Full Pmt Gold Coin")
                {
                }
                field("Sent SMS on Partial Gold Coin"; Rec."Sent SMS on Partial Gold Coin")
                {
                }
                field("App Consider on Comm Elg Repor"; Rec."App Consider on Comm Elg Repor")
                {
                }
                field("RB Release by User ID"; Rec."RB Release by User ID")
                {
                }
                field("Date/Time of RB Release"; Rec."Date/Time of RB Release")
                {
                }
                field("commission calculated"; Rec."commission calculated")
                {
                }
                field("Commission Base amt"; Rec."Commission Base amt")
                {
                }
                field("Commission applicable base amt"; Rec."Commission applicable base amt")
                {
                }
                field("Project Change"; Rec."Project Change")
                {
                }
                field("Project change Comment"; Rec."Project change Comment")
                {
                }
                field("Check RB Reg"; Rec."Check RB Reg")
                {
                }
                field("Vizag datA"; Rec."Vizag datA")
                {
                }
                field("For Checking Collection"; Rec."For Checking Collection")
                {
                }
                field("LLP Name"; Rec."LLP Name")
                {
                }
                field("Total Commission Amt."; Rec."Total Commission Amt.")
                {
                }
                field(Findentry; Rec.Findentry)
                {
                }
                field("App Transfer in LLPs"; Rec."App Transfer in LLPs")
                {
                }
                field("Amount Difference"; Rec."Amount Difference")
                {
                }
                field("Regi. Update Dt."; Rec."Regi. Update Dt.")
                {
                }
                field("Regi. Update Time"; Rec."Regi. Update Time")
                {
                }
                field("Regi. Update"; Rec."Regi. Update")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Bond)
            {
                Caption = 'Bond';
                action(Card)
                {
                    Image = "Page";
                    Promoted = true;
                    RunObject = Page "Unit Verification";
                }
                action("Preview Certificate")
                {

                    trigger OnAction()
                    var
                        Bond2: Record "Confirmed Order";
                    begin
                        Bond2.RESET;
                        CurrPage.SETSELECTIONFILTER(Bond2);
                        REPORT.RUNMODAL(97749, TRUE, FALSE, Bond2);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin

        Customer.GET(Rec."Customer No.");
        BondHolderName := Customer.Name;
        Vendor.GET(Rec."Introducer Code");
        IntroducerName := Vendor.Name;
    end;

    trigger OnOpenPage()
    begin

        SetRecordFilters;
    end;

    var
        //AppMgt: Codeunit 1;
        Vendor: Record Vendor;
        BondTypeFilter: Code[20];
        IntroducerCodeFilter: Text[250];
        BondNoFilter: Text[250];
        ShowCard: Integer;
        BondHolderName: Text[50];
        IntroducerName: Text[50];
        ReleaseBondApplication: Codeunit "Release Unit Application";
        Text0001: Label 'Cashier,Documentaion';

    local procedure SetRecordFilters()
    begin
        Rec.FILTERGROUP(10);
        IF IntroducerCodeFilter <> '' THEN BEGIN
            Rec.SETFILTER("Introducer Code", IntroducerCodeFilter);
            IntroducerCodeFilter := Rec.GETFILTER("Introducer Code");
        END ELSE
            Rec.SETRANGE("Introducer Code");


        IF BondNoFilter <> '' THEN BEGIN
            Rec.SETFILTER("No.", BondNoFilter);
            BondNoFilter := Rec.GETFILTER("No.");
        END ELSE
            Rec.SETRANGE("No.");

        IF BondTypeFilter <> '' THEN BEGIN
            Rec.SETFILTER("Project Type", BondTypeFilter);
            BondTypeFilter := Rec.GETFILTER("Project Type");
        END ELSE
            Rec.SETRANGE("Project Type");

        Rec.FILTERGROUP(0);
        CurrPage.UPDATE(FALSE);
    end;
}

