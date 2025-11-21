table 97792 Documentation
{

    fields
    {
        field(1; "Unit No."; Code[20])
        {
        }
        field(2; "Customer No.(1)"; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
            var
                Bond: Record "Confirmed Order";
                ReleaseBondApplication: Codeunit "Release Unit Application";
                Customer: Record Customer;
            begin
                ReleaseBondApplication.InsertBondHistory("Unit No.", '1st Bond holder(' + xRec."Customer No.(1)" + ') Changed.',
                                1, "Unit No.");

                Bond.GET("Unit No.");
                Bond."Customer No." := "Customer No.(1)";
                Bond.MODIFY;
                Customer.GET("Customer No.(1)");
                "Father's/Husband's Name(1)" := Customer."BBG Father's/Husband's Name";
                "Relation(1)" := Customer.Contact;
                "Address(1)" := Customer.Address;
                "Address 2(1)" := Customer."Address 2";
                "Age(1)" := Customer."BBG Age";
                "City(1)" := Customer.City;
                "Post Code(1)" := Customer."Post Code";
            end;
        }
        field(3; "Customer Name(1)"; Text[50])
        {

            trigger OnValidate()
            begin
                "Customer Name(1)" := UPPERCASE("Customer Name(1)");
            end;
        }
        field(4; "Father's/Husband's Name(1)"; Text[50])
        {

            trigger OnValidate()
            begin
                "Father's/Husband's Name(1)" := UPPERCASE("Father's/Husband's Name(1)");
            end;
        }
        field(5; "Relation(1)"; Text[50])
        {
            Caption = 'Relation';
            Description = 'Contact';

            trigger OnValidate()
            begin
                "Relation(1)" := UPPERCASE("Relation(1)");
                CASE "Relation(1)" OF
                    'F':
                        VALIDATE("Relation(1)", 'FATHER');
                    'M':
                        VALIDATE("Relation(1)", 'MOTHER');
                    'H':
                        VALIDATE("Relation(1)", 'HUSBAND');
                    'W':
                        VALIDATE("Relation(1)", 'WIFE');
                    'U':
                        VALIDATE("Relation(1)", 'UNCLE');
                    'A':
                        VALIDATE("Relation(1)", 'AUNT');
                    'B':
                        VALIDATE("Relation(1)", 'BROTHER');
                    'S':
                        VALIDATE("Relation(1)", 'SON');
                    'D':
                        VALIDATE("Relation(1)", 'DAUGHTER');
                    'SI':
                        VALIDATE("Relation(1)", 'SISTER');
                    'G':
                        VALIDATE("Relation(1)", 'GRANDSON');
                    'N':
                        VALIDATE("Relation(1)", 'NEPHEW');
                    'NI':
                        VALIDATE("Relation(1)", 'NIECE');
                    'O':
                        VALIDATE("Relation(1)", 'OTHER');
                END;
            end;
        }
        field(6; "Address(1)"; Text[100])
        {
            Caption = 'Address';

            trigger OnValidate()
            begin
                "Address(1)" := UPPERCASE("Address(1)");
            end;
        }
        field(7; "Address 2(1)"; Text[100])
        {
            Caption = 'Address 2';

            trigger OnValidate()
            begin
                "Address 2(1)" := UPPERCASE("Address 2(1)");
            end;
        }
        field(8; "Age(1)"; Decimal)
        {
            Editable = true;
        }
        field(9; "City(1)"; Text[65])
        {
            Caption = 'City';

            trigger OnLookup()
            begin
                PostCode.LookUpCity("City(1)", "Post Code(1)", TRUE);
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity("City(1)", "Post Code(1)", County, "Country Code", TRUE);
            end;
        }
        field(10; "Post Code(1)"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookUpPostCode("City(1)", "Post Code(1)", TRUE);
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode("City(1)", "Post Code(1)", County, "Country Code", TRUE);
            end;
        }
        field(11; "Customer No.(2)"; Code[20])
        {
            TableRelation = Customer;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                IF Customer.GET("Customer No.(2)") THEN BEGIN
                    "Customer Name(2)" := Customer.Name;
                    "Father's/Husband's Name(2)" := Customer."BBG Father's/Husband's Name";
                    "Relation(2)" := Customer.Contact;
                    "Address(2)" := Customer.Address;
                    "Address 2(2)" := Customer."Address 2";
                    "Age(2)" := Customer."BBG Age";
                    "City(2)" := Customer.City;
                    "Post Code(2)" := Customer."Post Code";
                END ELSE BEGIN
                    "Customer Name(2)" := '';
                    "Father's/Husband's Name(2)" := '';
                    "Relation(2)" := '';
                    "Address(2)" := '';
                    "Address 2(2)" := '';
                    "Age(2)" := 0;
                    "City(2)" := '';
                    "Post Code(2)" := '';
                END
            end;
        }
        field(12; "Customer Name(2)"; Text[50])
        {

            trigger OnValidate()
            begin
                "Customer Name(2)" := UPPERCASE("Customer Name(2)");
            end;
        }
        field(13; "Father's/Husband's Name(2)"; Text[50])
        {

            trigger OnValidate()
            begin
                "Father's/Husband's Name(2)" := UPPERCASE("Father's/Husband's Name(2)");
            end;
        }
        field(14; "Relation(2)"; Text[50])
        {
            Caption = 'Relation';
            Description = 'Contact';

            trigger OnValidate()
            begin
                "Relation(2)" := UPPERCASE("Relation(2)");
                CASE "Relation(2)" OF
                    'F':
                        VALIDATE("Relation(2)", 'FATHER');
                    'M':
                        VALIDATE("Relation(2)", 'MOTHER');
                    'H':
                        VALIDATE("Relation(2)", 'HUSBAND');
                    'W':
                        VALIDATE("Relation(2)", 'WIFE');
                    'U':
                        VALIDATE("Relation(2)", 'UNCLE');
                    'A':
                        VALIDATE("Relation(2)", 'AUNT');
                    'B':
                        VALIDATE("Relation(2)", 'BROTHER');
                    'S':
                        VALIDATE("Relation(2)", 'SON');
                    'D':
                        VALIDATE("Relation(2)", 'DAUGHTER');
                    'SI':
                        VALIDATE("Relation(2)", 'SISTER');
                    'G':
                        VALIDATE("Relation(2)", 'GRANDSON');
                    'N':
                        VALIDATE("Relation(2)", 'NEPHEW');
                    'NI':
                        VALIDATE("Relation(2)", 'NIECE');
                    'O':
                        VALIDATE("Relation(2)", 'OTHER');
                END;
            end;
        }
        field(15; "Address(2)"; Text[100])
        {
            Caption = 'Address';

            trigger OnValidate()
            begin
                "Address(2)" := UPPERCASE("Address(2)");
            end;
        }
        field(16; "Address 2(2)"; Text[100])
        {
            Caption = 'Address 2';

            trigger OnValidate()
            begin
                "Address 2(2)" := UPPERCASE("Address 2(2)");
            end;
        }
        field(17; "Age(2)"; Decimal)
        {
            Editable = true;
        }
        field(18; "City(2)"; Text[65])
        {
            Caption = 'City';

            trigger OnLookup()
            begin
                PostCode.LookUpCity("City(2)", "Post Code(2)", TRUE);
            end;

            trigger OnValidate()
            begin
                PostCode.ValidateCity("City(2)", "Post Code(2)", County, "Country Code", TRUE);
            end;
        }
        field(19; "Post Code(2)"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookUpPostCode("City(2)", "Post Code(2)", TRUE);
            end;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode("City(2)", "Post Code(2)", County, "Country Code", TRUE);
            end;
        }
        field(20; "No."; Integer)
        {
            Caption = 'No.';
            Editable = false;
        }
        field(21; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(22; "Nominee Name"; Text[50])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                "Nominee Name" := UPPERCASE("Nominee Name");
            end;
        }
        field(23; "Nominee Address"; Text[100])
        {
            Caption = 'Address';

            trigger OnValidate()
            begin
                "Nominee Address" := UPPERCASE("Nominee Address");
                IF "Nominee Address" = 'A' THEN
                    "Nominee Address" := 'AS ABOVE'
            end;
        }
        field(24; "Nominee Address 2"; Text[100])
        {
            Caption = 'Address 2';

            trigger OnValidate()
            begin
                "Nominee Address 2" := UPPERCASE("Nominee Address 2");
                IF "Nominee Address 2" = 'A' THEN
                    "Nominee Address 2" := 'AS ABOVE'
            end;
        }
        field(25; "Nominee City"; Text[100])
        {
            Caption = 'City';
        }
        field(26; "Nominee Post Code"; Code[20])
        {
            Caption = 'Post Code';
        }
        field(27; "Nominee Title"; Option)
        {
            Caption = 'Title';
            OptionCaption = 'Mr,Mrs,Miss';
            OptionMembers = Mr,Mrs,Miss;
        }
        field(28; "Nominee Age"; Decimal)
        {
            Caption = 'Age';
        }
        field(29; "Nominee Relation"; Text[50])
        {
            Caption = 'Relationship with First/Sole Applicant';

            trigger OnValidate()
            begin
                "Nominee Relation" := UPPERCASE("Nominee Relation");
                CASE "Nominee Relation" OF
                    'F':
                        VALIDATE("Nominee Relation", 'FATHER');
                    'M':
                        VALIDATE("Nominee Relation", 'MOTHER');
                    'H':
                        VALIDATE("Nominee Relation", 'HUSBAND');
                    'W':
                        VALIDATE("Nominee Relation", 'WIFE');
                    'U':
                        VALIDATE("Nominee Relation", 'UNCLE');
                    'A':
                        VALIDATE("Nominee Relation", 'AUNT');
                    'B':
                        VALIDATE("Nominee Relation", 'BROTHER');
                    'S':
                        VALIDATE("Nominee Relation", 'SON');
                    'D':
                        VALIDATE("Nominee Relation", 'DAUGHTER');
                    'SI':
                        VALIDATE("Nominee Relation", 'SISTER');
                    'G':
                        VALIDATE("Nominee Relation", 'GRANDSON');
                    'N':
                        VALIDATE("Nominee Relation", 'NEPHEW');
                    'NI':
                        VALIDATE("Nominee Relation", 'NIECE');
                    'O':
                        VALIDATE("Nominee Relation", 'OTHER');
                END;
            end;
        }
        field(30; "Nominee Gender"; Option)
        {
            Caption = 'Gender';
            OptionCaption = 'Male,Female';
            OptionMembers = Male,Female;
        }
        field(31; "Nominee Status"; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Active,Inactive';
            OptionMembers = Active,Inactive;
        }
        field(32; "Application No."; Code[20])
        {
            Editable = false;
        }
        field(33; Status; Option)
        {
            Editable = false;
            OptionCaption = ' ,Open,Documented';
            OptionMembers = " ",Open,Documented;
        }
        field(34; "Disputed Bond"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Unit No.")
        {
            Clustered = true;
        }
        key(Key2; "Customer No.(1)")
        {
        }
        key(Key3; "Customer No.(2)")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PostCode: Record "Post Code";
        Text001: Label 'Cheque/D.D. must be cleared before documentation for Application No. %1, Bond No. %2.';
        County: Text[30];
        "Country Code": Code[20];


    procedure UpdateMaster(var Documentation: Record Documentation)
    var
        BondNominee: Record "Unit Nominee";
        Customer: Record Customer;
        Application: Record Application;
        ReleaseBondApplication: Codeunit "Release Unit Application";
        Bond: Record "Confirmed Order";
        BondPaymentEntry: Record "Unit Payment Entry";
    begin
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETCURRENTKEY(Posted, "Payment Mode", "Cheque Status");
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::Application);
        BondPaymentEntry.SETRANGE("Document No.", Documentation."Application No.");
        BondPaymentEntry.SETRANGE(Posted, TRUE);
        BondPaymentEntry.SETFILTER("Payment Mode", '<>%1', BondPaymentEntry."Payment Mode"::Cash);
        BondPaymentEntry.SETRANGE("Cheque Status", BondPaymentEntry."Cheque Status"::" ");
        IF NOT BondPaymentEntry.ISEMPTY THEN
            ERROR(Text001, Documentation."Application No.", Documentation."No.");
        IF NOT Documentation.IsChequeCleared(Documentation."Application No.") THEN
            ERROR(Text001, Documentation."Application No.", Documentation."Unit No.");

        IF Documentation."Nominee Name" = '' THEN
            ERROR('Please enter Nominee Name');
        Customer.GET(Documentation."Customer No.(1)");
        Customer.Name := Documentation."Customer Name(1)";
        Customer."BBG Father's/Husband's Name" := Documentation."Father's/Husband's Name(1)";
        Customer.Contact := Documentation."Relation(1)";
        Customer.Address := Documentation."Address(1)";
        Customer."Address 2" := Documentation."Address 2(1)";
        Customer."BBG Age" := Documentation."Age(1)";
        Customer.City := Documentation."City(1)";
        Customer."Post Code" := Documentation."Post Code(1)";
        Customer.MODIFY;

        IF (Documentation."Customer No.(2)" = '') AND (Documentation."Customer Name(2)" <> '') THEN
            Documentation."Customer No.(2)" := Application.CreateCustomer(Documentation."Customer Name(2)");

        IF Documentation."Customer No.(2)" <> '' THEN BEGIN
            Customer.GET(Documentation."Customer No.(2)");
            Customer.Name := Documentation."Customer Name(2)";
            Customer."BBG Father's/Husband's Name" := Documentation."Father's/Husband's Name(1)";
            Customer.Contact := Documentation."Relation(2)";
            Customer.Address := Documentation."Address(2)";
            Customer."Address 2" := Documentation."Address 2(2)";
            Customer."BBG Age" := Documentation."Age(2)";
            Customer.City := Documentation."City(2)";
            Customer."Post Code" := Documentation."Post Code(2)";
            Customer.MODIFY;
        END;

        BondNominee.GET(Documentation."Unit No.");
        BondNominee."No." := Documentation."No.";
        BondNominee."Customer No." := Documentation."Customer No.";
        BondNominee.Name := Documentation."Nominee Name";
        BondNominee.Address := Documentation."Nominee Address";
        BondNominee."Address 2" := Documentation."Nominee Address 2";
        BondNominee.City := Documentation."Nominee City";
        BondNominee."Post Code" := Documentation."Nominee Post Code";
        BondNominee.Title := Documentation."Nominee Title";
        BondNominee.Age := Documentation."Nominee Age";
        BondNominee.Relation := Documentation."Nominee Relation";
        BondNominee.Gender := Documentation."Nominee Gender";
        BondNominee.Status := Documentation."Nominee Status";
        BondNominee.MODIFY;

        Documentation.Status := Documentation.Status::Documented;
        Documentation.MODIFY;

        Bond.GET(Documentation."Unit No.");
        Bond."Customer No. 2" := Documentation."Customer No.(2)";
        Bond.Status := Bond.Status::Documented;
        Bond.MODIFY;
        ReleaseBondApplication.InsertBondHistory(Documentation."Unit No.", 'Documentation Complete', 1, Documentation."Unit No.");
    end;


    procedure UpdateDocumentation(Bond: Record "Confirmed Order")
    var
        BondNominee: Record "Unit Nominee";
        Customer: Record Customer;
        Application: Record Application;
        ReleaseBondApplication: Codeunit "Release Unit Application";
        BondPaymentEntry: Record "Unit Payment Entry";
        Documentation: Record Documentation;
    begin
        Documentation.INIT;
        Documentation."Unit No." := Bond."No.";
        Customer.GET(Bond."Customer No.");
        Documentation."Customer No.(1)" := Bond."Customer No.";
        Documentation."Customer Name(1)" := Customer.Name;
        Documentation."Father's/Husband's Name(1)" := Customer."BBG Father's/Husband's Name";
        Documentation."Relation(1)" := Customer.Contact;
        Documentation."Address(1)" := Customer.Address;
        Documentation."Address 2(1)" := Customer."Address 2";
        Documentation."Age(1)" := Customer."BBG Age";
        Documentation."City(1)" := Customer.City;
        Documentation."Post Code(1)" := Customer."Post Code";

        IF Customer.GET(Bond."Customer No. 2") THEN BEGIN
            Documentation."Customer No.(2)" := Bond."Customer No. 2";
            Documentation."Customer Name(2)" := Customer.Name;
            Documentation."Father's/Husband's Name(2)" := Customer."BBG Father's/Husband's Name";
            Documentation."Relation(2)" := Customer.Contact;
            Documentation."Address(2)" := Customer.Address;
            Documentation."Address 2(2)" := Customer."Address 2";
            Documentation."Age(2)" := Customer."BBG Age";
            Documentation."City(2)" := Customer.City;
            Documentation."Post Code(2)" := Customer."Post Code";
        END;

        BondNominee.GET(Documentation."Unit No.");
        Documentation."Customer No." := Bond."Customer No.";
        Documentation."Nominee Name" := BondNominee.Name;
        Documentation."Nominee Address" := BondNominee.Address;
        Documentation."Nominee Address 2" := BondNominee."Address 2";
        Documentation."Nominee City" := BondNominee.City;
        Documentation."Nominee Post Code" := BondNominee."Post Code";
        Documentation."Nominee Title" := BondNominee.Title;
        Documentation."Nominee Age" := BondNominee.Age;
        Documentation."Nominee Relation" := BondNominee.Relation;
        Documentation."Nominee Gender" := BondNominee.Gender;

        Documentation."Application No." := Bond."Application No.";
        Documentation.Status := Documentation.Status::Open;

        //"Disputed Bond" := TRUE;

        IF NOT Documentation.INSERT THEN
            Documentation.MODIFY;
    end;


    procedure IsChequeCleared(ApplicationNo: Code[20]): Boolean
    var
        BondPaymentEntry: Record "Unit Payment Entry";
    begin
        BondPaymentEntry.RESET;
        BondPaymentEntry.SETCURRENTKEY(Posted, "Payment Mode", "Cheque Status");
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::Application);
        BondPaymentEntry.SETRANGE("Document No.", "Application No.");
        BondPaymentEntry.SETRANGE(Posted, TRUE);
        BondPaymentEntry.SETFILTER("Payment Mode", '<>%1', BondPaymentEntry."Payment Mode"::Cash);
        //BondPaymentEntry.SETRANGE("Cheque Status",BondPaymentEntry."Cheque Status"::" ");
        BondPaymentEntry.SETFILTER("Cheque Status", '%1|%2', BondPaymentEntry."Cheque Status"::" ", BondPaymentEntry."Cheque Status"::Bounced
        );
        EXIT(BondPaymentEntry.ISEMPTY);
    end;


    procedure UpdateDocumentationCorr(Bond: Record "Confirmed Order")
    var
        BondNominee: Record "Unit Nominee";
        Customer: Record Customer;
        Application: Record Application;
        ReleaseBondApplication: Codeunit "Release Unit Application";
        BondPaymentEntry: Record "Unit Payment Entry";
        Documentation: Record Documentation;
    begin
        Documentation.INIT;
        Documentation."Unit No." := Bond."No.";
        Customer.GET(Bond."Customer No.");
        Documentation."Customer No.(1)" := Bond."Customer No.";
        Documentation."Customer Name(1)" := Customer.Name;
        Documentation."Father's/Husband's Name(1)" := Customer."BBG Father's/Husband's Name";
        Documentation."Relation(1)" := Customer.Contact;
        Documentation."Address(1)" := Customer.Address;
        Documentation."Address 2(1)" := Customer."Address 2";
        Documentation."Age(1)" := Customer."BBG Age";
        Documentation."City(1)" := Customer.City;
        Documentation."Post Code(1)" := Customer."Post Code";

        IF Customer.GET(Bond."Customer No. 2") THEN BEGIN
            Documentation."Customer No.(2)" := Bond."Customer No. 2";
            Documentation."Customer Name(2)" := Customer.Name;
            Documentation."Father's/Husband's Name(2)" := Customer."BBG Father's/Husband's Name";
            Documentation."Relation(2)" := Customer.Contact;
            Documentation."Address(2)" := Customer.Address;
            Documentation."Address 2(2)" := Customer."Address 2";
            Documentation."Age(2)" := Customer."BBG Age";
            Documentation."City(2)" := Customer.City;
            Documentation."Post Code(2)" := Customer."Post Code";
        END;

        IF NOT BondNominee.GET(Documentation."Unit No.") THEN BEGIN
            BondNominee.INIT;
            BondNominee."Unit No." := Documentation."Unit No.";
            BondNominee.INSERT;
        END;
        Documentation."Customer No." := Bond."Customer No.";
        Documentation."Nominee Name" := BondNominee.Name;
        Documentation."Nominee Address" := BondNominee.Address;
        Documentation."Nominee Address 2" := BondNominee."Address 2";
        Documentation."Nominee City" := BondNominee.City;
        Documentation."Nominee Post Code" := BondNominee."Post Code";
        Documentation."Nominee Title" := BondNominee.Title;
        Documentation."Nominee Age" := BondNominee.Age;
        Documentation."Nominee Relation" := BondNominee.Relation;
        Documentation."Nominee Gender" := BondNominee.Gender;

        Documentation."Application No." := Bond."Application No.";
        Documentation.Status := Documentation.Status::Open;

        //"Disputed Bond" := TRUE;

        IF NOT Documentation.INSERT THEN
            Documentation.MODIFY;
    end;
}

