table 97858 "Application-Dataport"
{
    Caption = 'Application-Dataport';
    DrillDownPageID = "Application List";
    LookupPageID = "Application List";

    fields
    {
        field(1; "Application No."; Code[20])
        {
            Caption = 'Application No.';
            Editable = true;
        }
        field(2; "Project Type"; Code[20])
        {
            Caption = 'Project Type';
            Editable = false;
        }
        field(3; "Scheme Code"; Code[20])
        {
            Caption = 'Scheme Code';
            Editable = false;
        }
        field(4; "Scheme Version No."; Integer)
        {
            BlankZero = true;
            Caption = 'Scheme Version No.';
            Editable = false;
        }
        field(5; "Scheme Sub Version No."; Integer)
        {
            BlankZero = true;
            Caption = 'Scheme Sub Version No.';
            Editable = false;
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            Editable = true;
        }
        field(7; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = true;
        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Description = '1';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(10; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
        }
        field(12; "Associate Code"; Code[20])
        {
            Caption = 'Associate Code';
            TableRelation = Vendor."No." WHERE("BBG Status" = FILTER(Provisional | Active),
                                              "BBG Vendor Category" = FILTER("IBA(Associates)"));
        }
        field(13; "User Id"; Code[20])
        {
            Editable = false;
            TableRelation = User;
        }
        field(15; "Investment Type"; Option)
        {
            Caption = 'Investment Type';
            OptionCaption = ' ,RD,FD,MIS';
            OptionMembers = " ",RD,FD,MIS;
        }
        field(17; "Investment Frequency"; Option)
        {
            Caption = 'Investment Frequency';
            OptionCaption = ' ,Monthly,Quarterly,Half Yearly,Annually';
            OptionMembers = " ",Monthly,Quarterly,"Half Yearly",Annually;
        }
        field(18; "Investment Amount"; Decimal)
        {
            Caption = 'Investment Amount';
            Editable = true;
            MinValue = 0;

            trigger OnValidate()
            var
                DiscountPercent: Decimal;
                InvestmentMultiple: Decimal;
                DiscountAmount: Decimal;
                Division: Decimal;
                InvInclDisc: Decimal;
                Amt: Decimal;
            begin
            end;
        }
        field(19; "Discount Amount"; Decimal)
        {
            Caption = 'Discount Amount';
            Editable = false;
        }
        field(21; "Return Payment Mode"; Option)
        {
            Caption = 'Return Payment Mode';
            OptionCaption = ' ,Cash,Cheque,D.D.,Banker''s Cheque,P.O.,Cheque by Post,NEFT';
            OptionMembers = " ",Cash,Cheque,"D.D.","Banker's Cheque","P.O.","Cheque by Post",NEFT;
        }
        field(22; "Return Frequency"; Option)
        {
            OptionCaption = ' ,Monthly,Quarterly,Half Yearly,Annually';
            OptionMembers = " ",Monthly,Quarterly,"Half Yearly",Annually;

            trigger OnValidate()
            var
                InterestAmt: Decimal;
            begin
            end;
        }
        field(23; "Return Amount"; Decimal)
        {
            BlankZero = true;
            Caption = 'Return Amount';
        }
        field(26; "Maturity Date"; Date)
        {
            Caption = 'Maturity Date';
            Editable = false;
        }
        field(27; "Maturity Amount"; Decimal)
        {
            Caption = 'Maturity Amount';
            Editable = false;
        }
        field(28; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Printed,Converted,Cancelled';
            OptionMembers = Open,Released,Printed,Converted,Cancelled;
        }
        field(30; "Service Charge Amount"; Decimal)
        {
            Caption = 'Service Charge Amount';
            Editable = false;
        }
        field(31; Duration; Integer)
        {
            BlankZero = true;
            Caption = 'Duration';
        }
        field(32; "Unit No."; Code[20])
        {
            Caption = 'Order No.';
            TableRelation = "Confirmed Order";
        }
        field(34; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(37; "Amount Received"; Decimal)
        {
            CalcFormula = Sum("Unit Payment Entry".Amount WHERE("Document Type" = FILTER(Application),
                                                                 "Document No." = FIELD("Application No.")));
            Caption = 'Amount Received';
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Posted Doc No."; Code[20])
        {
            Editable = false;
        }
        field(39; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(40; Category; Option)
        {
            Caption = 'Category';
            OptionCaption = 'A,B';
            OptionMembers = A,B;
        }
        field(41; "Maturity Bonus Amount"; Decimal)
        {
            Editable = false;
        }
        field(42; "Bond Posting Group"; Code[20])
        {
            Editable = false;
            TableRelation = "ID 2 Group"."Item Category Code";
        }
        field(43; "Cheque Cleared"; Boolean)
        {
        }
        field(44; "With Cheque"; Boolean)
        {
        }
        field(45; "Bank Account No."; Text[30])
        {
            Description = 'Bank Account No  in Customer Bank Account';
        }
        field(46; "Branch Name"; Text[50])
        {
            Description = 'Name 2 in Customer Bank Account';
        }
        field(50000; "Sub Document Type"; Option)
        {
            Description = 'DDS added to sales and lease documents ALLRE';
            Editable = false;
            OptionCaption = ' ,,,,,,,,,,,,,,Sales,Lease,,,Sale Property,Sale Normal,Lease Property';
            OptionMembers = " ","WO-Project","WO-Normal","Regular PO-Project","Regular PO Normal","Property PO","Direct PO-Normal","GRN for PO","GRN for Aerens","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice",Sales,Lease,"Project Indent","Non-Project Indent","Sale Property","Sale Normal","Lease Property";
        }
        field(50001; "Unit Code"; Code[20])
        {
            Description = '3';
            TableRelation = "Unit Master"."No." WHERE("Project Code" = FIELD("Shortcut Dimension 1 Code"),
                                                     Status = CONST(Open),
                                                     Freeze = CONST(false),
                                                     "Unit Category" = FIELD(Type));
        }
        field(50002; "Total Received Amount"; Decimal)
        {
            Editable = false;
        }
        field(50003; "Father / Husband Name"; Text[50])
        {
        }
        field(50004; "Member's D.O.B"; Date)
        {
        }
        field(50005; "Mobile No."; Text[10])
        {
        }
        field(50008; "E-mail"; Text[80])
        {
        }
        field(60010; "Payment Plan"; Code[20])
        {
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Payment Plan"),
                                                          "Project Code" = FIELD("Shortcut Dimension 1 Code"));
        }
        field(60011; "Amount Refunded"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(60012; "Min. Allotment Amount"; Decimal)
        {
            Editable = true;
        }
        field(60013; "Saleable Area"; Decimal)
        {
            Description = '4';
        }
        field(60014; "Unit Non Usable"; Boolean)
        {
        }
        field(60015; Type; Option)
        {
            OptionCaption = ' ,Normal,Priority';
            OptionMembers = " ",Normal,Priority;
        }
        field(60016; "Branch Code"; Code[10])
        {
            TableRelation = Location.Code WHERE("BBG Branch" = CONST(true));
        }
        field(60017; "Creation Date"; Date)
        {
            Description = 'ALLETDK';
        }
        field(60018; "Creation Time"; Time)
        {
            Description = 'ALLETDK';
        }
        field(60019; "Pass Book No."; Code[20])
        {
            Description = '2';
        }
        field(60020; "Old Pass Book No."; Code[20])
        {
        }
        field(60021; "Check Error"; Boolean)
        {
        }
        field(60022; "Application Created"; Boolean)
        {
            Editable = true;
        }
        field(60023; "Received Amount"; Decimal)
        {
        }
        field(60024; "Old Associate Code"; Code[20])
        {
        }
        field(60025; "Balance from BBG"; Decimal)
        {
        }
        field(60026; "Sale Total"; Decimal)
        {
        }
        field(60027; "Total Balance from BBG"; Decimal)
        {
        }
        field(60028; DOJ; Date)
        {
        }
        field(60029; "E-M.Fee"; Decimal)
        {
        }
        field(60030; "E-BSP1"; Decimal)
        {
        }
        field(60031; "E-BSP2"; Decimal)
        {
        }
        field(60032; "E-BSP3"; Decimal)
        {
        }
        field(60033; "E-BSP4"; Decimal)
        {
        }
        field(60034; "E-BSP6"; Decimal)
        {
        }
        field(60035; "E-C.FUND"; Decimal)
        {
        }
        field(60036; "E-Oth"; Decimal)
        {
        }
        field(60037; Discount; Decimal)
        {
        }
        field(60038; LDP; Date)
        {
        }
        field(60039; "R-Total"; Decimal)
        {
        }
        field(60040; "R-M.Fee"; Decimal)
        {
        }
        field(60041; "R-BSP1"; Decimal)
        {
        }
        field(60042; "R-BSP2"; Decimal)
        {
        }
        field(60043; "R-BSP3"; Decimal)
        {
        }
        field(60044; "R-BSP4"; Decimal)
        {
        }
        field(60045; "R-BSP6"; Decimal)
        {
        }
        field(60046; "R-C.Fund"; Decimal)
        {
        }
        field(60047; "R-Oth"; Decimal)
        {
        }
        field(60048; Refund; Decimal)
        {
        }
        field(60049; Balance; Decimal)
        {
        }
        field(60050; "Asc ID"; Decimal)
        {
        }
        field(60051; "Asc Name"; Text[60])
        {
        }
        field(60052; "Regi No"; Code[20])
        {
        }
        field(60053; "Regi Dt"; Date)
        {
        }
        field(60054; CustMobile; Text[30])
        {
        }
        field(60055; "Cust Phone"; Text[30])
        {
        }
        field(60056; City; Text[30])
        {
        }
        field(60057; "Asso Mobile"; Text[30])
        {
        }
        field(60058; "Comm %"; Decimal)
        {
        }
        field(60059; "Booking Type"; Option)
        {
            OptionCaption = ' ,Normal,Priority';
            OptionMembers = " ",Normal,Priority;
        }
        field(60060; "Old Unit No."; Code[10])
        {
        }
        field(60061; "DE-M.Fee"; Decimal)
        {
        }
        field(60062; "DE-BSP1"; Decimal)
        {
        }
        field(60063; "DE-BSP2"; Decimal)
        {
        }
        field(60064; "DE-BSP3"; Decimal)
        {
        }
        field(60065; "DE-BSP4"; Decimal)
        {
        }
        field(60066; "DE-BSP6"; Decimal)
        {
        }
        field(60067; "DE-C.FUND"; Decimal)
        {
        }
        field(60068; "DE-Oth"; Decimal)
        {
        }
        field(60069; DTotal; Decimal)
        {
        }
        field(60070; "E-BSP5"; Decimal)
        {
        }
        field(60071; "R-BSP5"; Decimal)
        {
        }
        field(60072; "D-BSP5"; Decimal)
        {
        }
        field(60073; "Aready Exists on ConORder"; Boolean)
        {
        }
        field(60074; "Before Update Unit Code"; Code[20])
        {
            Description = 'BBG1.00 050513';
        }
    }

    keys
    {
        key(Key1; "Application No.")
        {
            Clustered = true;
        }
        key(Key2; "Old Unit No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        BondPaymentEntry: Record "Unit Payment Entry";
        PaymentMethod: Record "Payment Method";
        GetDescription: Codeunit GetDescription;
    begin
    end;

    var
        Text001: Label '%1 already exists.';
        Text002: Label 'You cannot rename a %1.';
        Text003: Label 'Please select correct Investment Amount.';
        Text004: Label 'Invalid setup for Commission and Bonus for %1 %2, %3 %4, %5 %6.';
        Text005: Label 'No return amount found in the scheme.';
        Text006: Label 'No scheme exist for bond type %1, Investment type %2, and Duration %3.';
        Text007: Label 'RECEIVED FROM CODE %1 and ASSOCIATE CODE %2 are not from the same chain or RECEIVED FROM CODE is junior than ASSOCIATE CODE!';
        Text008: Label '%1 must be %2 for %3 %4, %5 %6, %7 %8, %9 %10.';
        Text50000: Label 'Associate %1  PAN No. not verified';


    procedure AssistEdit(OldAppl: Record Application): Boolean
    var
        Appl: Record Application;
    begin
    end;


    procedure TotalApplicationAmount(): Decimal
    begin
    end;


    procedure CreateCustomer(BondHolderName: Text[50]): Code[20]
    var
        Customer: Record Customer;
        Template: Record "Config. Template Header";
        TemplateMgt: Codeunit "Config. Template Management";
        RecRef: RecordRef;
    begin
    end;


    procedure SelectScheme()
    var
        BondPostingGroup: Record "ID 2 Group";
    begin
    end;


    procedure CalculateMatuirityAmt(): Decimal
    var
        PmtPerPeriod: Decimal;
        Result: Decimal;
        BonusAmt: Decimal;
        NoOfYear: Integer;
        PaymentPerYear: Decimal;
        Interest: Decimal;
        MatuirityDate: Date;
        IntAmt: Decimal;
        SchemeLine: Record "Document Type Approval";
    begin
    end;


    procedure DeletePaymentLine(DocumentNo: Code[20])
    var
        BondPaymentEntry: Record "Unit Payment Entry";
    begin
    end;


    procedure CreateCustomerBankAccount(ApplicationNo: Code[20]; CustomerNo: Code[20]; BankAccountNo: Text[30]; BranchName: Text[50])
    var
        CustomerBankAccount: Record "Customer Bank Account";
    begin
    end;


    procedure RefreshMilestoneAmount()
    begin
    end;


    procedure UpdateProjectType()
    begin
    end;


    procedure InsertMilestone()
    begin
    end;


    procedure CreatePaymentTermsLine(MilestoneCode: Code[10]; MilestoneDescription: Text[50]; MilestoneDueDate: Date; Milestoneamt: Decimal; ChargeCode: Code[10]; CommisionApplicable: Boolean; DirectAssociate: Boolean)
    begin
    end;


    procedure CalculateMinAllotAmt(Unit: Record "Unit Master"): Decimal
    var
        MembershipFee: Decimal;
    begin
    end;


    procedure CalculateMemberFee(Unit: Record "Unit Master"): Decimal
    var
        TotalCost: Decimal;
    begin
    end;


    procedure AmountRecdAppl(ApplicationNo: Code[20]): Decimal
    var
        RecdAmount: Decimal;
        ApplicationRec: Record Application;
    begin
    end;
}

