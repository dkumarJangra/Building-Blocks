table 97790 Application
{
    // ALLEPG 310812 : Code added for freezing Unit Code.
    // ALLETDK081112--Changed "FlowField" of "Total Receivec Amount" field
    //     ALLETDK221112--Added code to update due date
    // 
    // ALLEDK 210921 - 21.09 modify for Min. Allotment amount
    // 221223 code added Unit payment plan

    Caption = 'Application';
    DrillDownPageID = "Application List";
    LookupPageID = "Application List";

    fields
    {
        field(1; "Application No."; Code[20])
        {
            Caption = 'Application No.';

            trigger OnValidate()
            begin
                IF "Application No." <> xRec."Application No." THEN BEGIN
                    BondSetup.GET;
                    NoSeriesMgt.TestManual(BondSetup."Application Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Project Type"; Code[20])
        {
            Caption = 'Project Type';
            Editable = false;

            trigger OnValidate()
            begin
                //IF "Project Type" <> xRec."Project Type" THEN
                //VALIDATE("Investment Type","Investment Type"::" ");

                IF ("Project Type" <> xRec."Project Type") AND (xRec."Project Type" <> '') THEN
                    DeletePaymentLine("Application No.");
            end;
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

            trigger OnValidate()
            begin
                IF ("Associate Code" <> '') AND (USERID <> '1003') THEN BEGIN
                    CLEAR(Vend);
                    IF Vend.GET("Associate Code") THEN
                        IF "Posting Date" < Vend."BBG Date of Joining" THEN
                            ERROR('Application DOJ greater than Associate DOJ');
                END;
            end;
        }
        field(7; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "IS Project" = CONST(true));

            trigger OnValidate()
            begin
                //ALLEDK 010113
                IF "Shortcut Dimension 1 Code" <> '' THEN BEGIN
                    IF Job.GET("Shortcut Dimension 1 Code") THEN BEGIN
                        Job.TESTFIELD(Job."Default Project Type");
                        "Project Type" := Job."Default Project Type";
                        Job.TESTFIELD(Job."Region Code for Rank Hierarcy");

                    END;
                    ProjectMilestoneLine.RESET;
                    ProjectMilestoneLine.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                    IF NOT ProjectMilestoneLine.FINDFIRST THEN
                        ERROR('Please create a project wise milestone setup for this project-' + "Shortcut Dimension 1 Code");


                END ELSE
                    "Project Type" := '';
                //ALLEDK 010113
            end;
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

            trigger OnValidate()
            begin
                "Customer Name" := UPPERCASE("Customer Name");
            end;
        }
        field(12; "Associate Code"; Code[20])
        {
            Caption = 'Associate Code';
            TableRelation = Vendor."No." WHERE("BBG Status" = FILTER(Provisional | Active),
                                              "BBG Vendor Category" = FILTER("IBA(Associates)" | "CP(Channel Partner)"));

            trigger OnValidate()
            begin
                /*
                // ALLEPG 230812 Start
                IF Vendor.GET("Associate Code") THEN BEGIN
                  IF NOT Vendor."Verify P.A.N. No." THEN
                    MESSAGE(Text50000,"Associate Code");
                END;
                // ALLEPG 230812 End
                */


                IF Job.GET("Shortcut Dimension 1 Code") THEN
                    Job.TESTFIELD(Job."Default Project Type");


                IF "Associate Code" <> xRec."Associate Code" THEN
                    "Received From Code" := '';
                VALIDATE("Received From Code", "Associate Code");

                IF "Associate Code" = '' THEN
                    EXIT;

                BondPost.CheckVendorChain("Associate Code", "Posting Date");

                CLEAR(Vend);
                IF (Vend.GET("Associate Code")) AND (USERID <> '1003') THEN BEGIN
                    IF "Posting Date" < Vend."BBG Date of Joining" THEN
                        ERROR('Application DOJ greater than Associate DOJ for -' + FORMAT("Application No.") + 'and IBA ID-' + "Associate Code");
                END;

            end;
        }
        field(13; "User ID"; Code[50])
        {
            Editable = false;
            TableRelation = User;
        }
        field(14; "Received From Code"; Code[20])
        {
            Caption = 'Received From Code';
            TableRelation = Vendor."No." WHERE("BBG Status" = FILTER(Provisional | Active),
                                              "BBG Vendor Category" = FILTER("IBA(Associates)" | "CP(Channel Partner)"));

            trigger OnValidate()
            var
                Vendor2: Record Vendor;
                Vendor3: Record Vendor;
            begin
                CLEAR(BondPost);
                IF ("Associate Code" <> '') AND ("Received From Code" <> '') AND ("Associate Code" <> "Received From Code") THEN BEGIN
                    IF NOT BondPost.CheckChain("Associate Code", "Received From Code", "Posting Date") THEN
                        ERROR(Text007, "Received From Code", "Associate Code");
                END;
                //IF ("MM Code" <> '') AND ("Received From Code" <> '') THEN BEGIN
                //  Vendor2.GET("MM Code");
                //  Vendor3.GET("Received From Code");
                //  IF Vendor3."Rank Code" > Vendor2."Rank Code" THEN BEGIN
                //    IF NOT BondPost.CheckChain("MM Code","Received From Code","Posting Date") THEN
                //      ERROR(Text007,"Received From Code","MM Code");
                //  END ELSE BEGIN
                //    IF NOT BondPost.CheckChain("Received From Code","MM Code","Posting Date") THEN
                //      ERROR(Text007,"Received From Code","MM Code");
                //  END;
                //END;
            end;
        }
        field(15; "Investment Type"; Option)
        {
            Caption = 'Investment Type';
            OptionCaption = ' ,RD,FD,MIS';
            OptionMembers = " ",RD,FD,MIS;

            trigger OnValidate()
            begin
                /*IF "Investment Type" <> xRec."Investment Type" THEN BEGIN
                  Duration := 0;
                  VALIDATE("Investment Amount",0);
                  "Associate Code" := '';
                  "Received From Code" := '';
                END;
                SelectScheme;
                 */

            end;
        }
        field(17; "Investment Frequency"; Option)
        {
            Caption = 'Investment Frequency';
            OptionCaption = ' ,Monthly,Quarterly,Half Yearly,Annually';
            OptionMembers = " ",Monthly,Quarterly,"Half Yearly",Annually;

            trigger OnValidate()
            begin
                VALIDATE("Investment Amount", 0);
                "Maturity Amount" := 0;
                "Discount Amount" := 0;
            end;
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
                "Discount Amount" := 0;
                /*SchemeHeader.RESET;
                SchemeHeader.SETCURRENTKEY("Posting User Code","TO Receive USER Name","TO Receive USER Code","User Responsibility Center");
                SchemeHeader.SETRANGE("Posting User Code","Bond Type");
                SchemeHeader.SETRANGE("TO Receive USER Name","Investment Type");
                SchemeHeader.SETRANGE("TO Receive USER Code",Duration);
                IF SchemeHeader.FINDLAST THEN BEGIN
                  IF "Investment Type" = "Investment Type"::RD THEN BEGIN
                    InvestmentMultiple := PostPayment.CalcForInvestmentFreq("Investment Frequency") * SchemeHeader."Investment Multiple";
                
                    DiscountPercent := PostPayment.CalcDiscount("Investment Frequency","Bond Type","Posting Date") *
                                       SchemeHeader."Investment Multiple" / 100;
                    DiscountAmount := InvestmentMultiple - DiscountPercent;
                    IF DiscountAmount <> 0 THEN
                      Division := "Investment Amount" / DiscountAmount;
                    InvInclDisc := Division * InvestmentMultiple;
                    "Discount Amount" := InvInclDisc - "Investment Amount";
                  END;
                  //Checking
                  IF "Investment Type" = "Investment Type"::RD THEN BEGIN
                    IF (SchemeHeader."CC User Responsibility Center" <> 0) AND (PostPayment.CalcForInvestmentFreq("Investment Frequency") > 0)
                       AND (("Investment Amount" + "Discount Amount") > 0) THEN
                      IF ("Investment Amount" + "Discount Amount") / PostPayment.CalcForInvestmentFreq("Investment Frequency")
                         < SchemeHeader."CC User Responsibility Center" THEN
                        //ERROR('Please insert proper Amount');
                        ERROR(Text008,SchemeHeader.FIELDCAPTION("CC User Responsibility Center"),SchemeHeader."CC User Responsibility Center",
                          FIELDCAPTION("Bond Type"),"Bond Type",FIELDCAPTION("Investment Type"),"Investment Type",
                          FIELDCAPTION("Scheme Code"),"Scheme Code",FIELDCAPTION("Scheme Version No."),"Scheme Version No.");
                
                    IF SchemeHeader."Investment Multiple" <> 0 THEN BEGIN
                      Amt := ("Investment Amount" + "Discount Amount") / SchemeHeader."Investment Multiple";
                      IF ROUND(Amt,1,'<') <> Amt THEN
                        //ERROR('Please insert proper Amount');
                        ERROR(Text008,SchemeHeader.FIELDCAPTION("Investment Multiple"),SchemeHeader."Investment Multiple",
                          FIELDCAPTION("Bond Type"),"Bond Type",FIELDCAPTION("Investment Type"),"Investment Type",
                          FIELDCAPTION("Scheme Code"),"Scheme Code",FIELDCAPTION("Scheme Version No."),"Scheme Version No.");
                    END;
                  END ELSE BEGIN  //IF "Investment Type" = "Investment Type"::MIS THEN
                    IF (SchemeHeader."CC User Responsibility Center" <> 0) AND ("Investment Amount" > 0) THEN
                      IF "Investment Amount" < SchemeHeader."CC User Responsibility Center" THEN
                        ERROR(Text008,SchemeHeader.FIELDCAPTION("CC User Responsibility Center"),SchemeHeader."CC User Responsibility Center",
                          FIELDCAPTION("Bond Type"),"Bond Type",FIELDCAPTION("Investment Type"),"Investment Type",
                          FIELDCAPTION("Scheme Code"),"Scheme Code",FIELDCAPTION("Scheme Version No."),"Scheme Version No.");
                
                    IF SchemeHeader."Investment Multiple" <> 0 THEN BEGIN
                      Amt := "Investment Amount" / SchemeHeader."Investment Multiple";
                      IF ROUND(Amt,1,'<') <> Amt THEN
                        ERROR(Text008,SchemeHeader.FIELDCAPTION("Investment Multiple"),SchemeHeader."Investment Multiple",
                          FIELDCAPTION("Bond Type"),"Bond Type",FIELDCAPTION("Investment Type"),"Investment Type",
                          FIELDCAPTION("Scheme Code"),"Scheme Code",FIELDCAPTION("Scheme Version No."),"Scheme Version No.");
                    END;
                  END;
                
                END;
                 */
                "Maturity Amount" := CalculateMatuirityAmt;

                "Return Frequency" := "Return Frequency"::" ";
                "Return Amount" := 0;

                IF ("Investment Amount" <> xRec."Investment Amount") AND (xRec."Investment Amount" <> 0) THEN
                    DeletePaymentLine("Application No.");

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
                /*IF "Investment Type" = "Investment Type"::MIS THEN BEGIN
                  SchemeHeader.RESET;
                  SchemeHeader.SETCURRENTKEY("Posting User Code","TO Receive USER Name","TO Receive USER Code","User Responsibility Center");
                  SchemeHeader.SETRANGE("Posting User Code","Bond Type");
                  SchemeHeader.SETRANGE("TO Receive USER Name","Investment Type");
                  SchemeHeader.SETRANGE("TO Receive USER Code",Duration);
                  IF SchemeHeader.FINDLAST THEN BEGIN
                    InterestAmt := "Investment Amount" * SchemeHeader."Interest %" * 0.01 * (Duration / 12);
                    "Return Amount" := ROUND((InterestAmt / (Duration/PostPayment.CalcForInvestmentFreq("Return Frequency"))),1,'<');
                  END ELSE
                    ERROR(Text005);
                END;
                 */

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
            Editable = true;
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

            trigger OnLookup()
            begin
                /*SchemeHeader.RESET;
                SchemeHeader.SETCURRENTKEY("Posting User Code","TO Receive USER Name","TO Receive USER Code","User Responsibility Center");
                SchemeHeader.SETRANGE("Posting User Code","Bond Type");
                SchemeHeader.SETRANGE("TO Receive USER Name","Investment Type");
                IF PAGE.RUNMODAL(PAGE::"Document Type Initiator",SchemeHeader) = ACTION::LookupOK THEN
                  VALIDATE(Duration,SchemeHeader."TO Receive USER Code");
                 */

            end;

            trigger OnValidate()
            begin
                SelectScheme;
                IF NOT BondPost.ValidCommStruc("Investment Type", Duration, "Project Type", "Posting Date", "Unit Payment Plan") THEN   //221223 code added
                    ERROR(Text004, FIELDCAPTION("Investment Type"), "Investment Type", FIELDCAPTION("Project Type")
                         , "Project Type", FIELDCAPTION(Duration), Duration);

                IF Duration <> xRec.Duration THEN BEGIN
                    VALIDATE("Investment Amount", 0);
                    "Associate Code" := '';
                    "Received From Code" := '';
                END;
                SelectScheme;
            end;
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

            trigger OnValidate()
            begin
                IF Customer.GET("Customer No.") THEN BEGIN
                    "Customer Name" := Customer.Name;
                    //ALLETDK >>
                    Customer.TESTFIELD("Customer Posting Group");
                    Customer.TESTFIELD("Gen. Bus. Posting Group");
                    Customer.TESTFIELD("BBG Date of Birth");
                    Customer.TESTFIELD("BBG Mobile No.");
                    "Member's D.O.B" := Customer."BBG Date of Birth";
                    "Mobile No." := Customer."BBG Mobile No.";
                    "Father / Husband Name" := Customer."BBG Father's/Husband's Name";
                    //Code added start 23072025
                    IF Customer."District Code" <> '' THEN begin
                        "Customer State Code" := Customer."State Code";
                        "District Code" := Customer."District Code";
                        "Mandal Code" := Customer."Mandal Code";
                        "Village Code" := Customer."Village Code";
                    END;
                    //Code added End 23072025
                    //ALLETDK <<
                    "Bond Posting Group" := Customer."Customer Posting Group";
                END;
            end;
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

            trigger OnValidate()
            begin
                "Bank Account No." := UPPERCASE("Bank Account No.");
            end;
        }
        field(46; "Branch Name"; Text[50])
        {
            Description = 'Name 2 in Customer Bank Account';

            trigger OnValidate()
            begin
                "Branch Name" := UPPERCASE("Branch Name");
            end;
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

            trigger OnValidate()
            var
                UnitSetup: Record "Unit Setup";
                RecJob: Record Job;
                Docmaster_3: Record "Document Master";
            begin
                TESTFIELD(Status, Status::Open);
                TESTFIELD("Shortcut Dimension 1 Code");
                TESTFIELD(Type);
                TESTFIELD("Posting Date");
                TESTFIELD("Document Date");
                IF ItemRec.GET("Unit Code") THEN BEGIN
                    IF "Application Type" = "Application Type"::"Non Trading" THEN
                        ItemRec.TESTFIELD(ItemRec.Status, ItemRec.Status::Open);
                    ItemRec.TESTFIELD(ItemRec."Min. Allotment Amount");
                    "Min. Allotment Amount" := ItemRec."Min. Allotment Amount";
                    IF Type <> ItemRec."Unit Category" THEN
                        ERROR('Please check the Unit is Priority OR Normal');

                END ELSE
                    "Min. Allotment Amount" := 0;

                IF UMaster.GET("Unit Code") THEN BEGIN
                    IF "Application Type" = "Application Type"::"Non Trading" THEN
                        UMaster.TESTFIELD(UMaster.Status, UMaster.Status::Open);
                    UMaster.TESTFIELD(UMaster."Min. Allotment Amount");
                    "Min. Allotment Amount" := UMaster."Min. Allotment Amount";
                    "Unit Non Usable" := UMaster."Non Usable";
                END ELSE BEGIN
                    "Min. Allotment Amount" := 0;
                    "Unit Non Usable" := FALSE;
                END;

                IF "Unit Code" <> xRec."Unit Code" THEN BEGIN
                    //ALLETDK081112..BEGIN
                    PaymentTermLines.RESET;
                    PaymentTermLines.SETCURRENTKEY("Document No.");
                    PaymentTermLines.SETRANGE("Document No.", "Application No.");
                    IF PaymentTermLines.FINDSET THEN
                        PaymentTermLines.DELETEALL;
                    //ALLETDK081112..END
                END;

                IF "Unit Code" <> '' THEN BEGIN
                    AppCharges.RESET;
                    AppCharges.SETCURRENTKEY("Document No.");
                    AppCharges.SETRANGE(AppCharges."Document No.", "Application No.");
                    IF AppCharges.FINDSET THEN
                        AppCharges.DELETEALL;

                    totalamount := 0;



                    Docmaster_3.RESET;
                    Docmaster_3.SETRANGE(Docmaster_3."Document Type", Docmaster_3."Document Type"::Charge);
                    Docmaster_3.SETFILTER(Docmaster_3."Project Code", "Shortcut Dimension 1 Code");
                    IF "Sub Document Type" = "Sub Document Type"::Lease THEN
                        Docmaster_3.SETRANGE(Docmaster_3."Sale/Lease", Docmaster_3."Sale/Lease"::Lease);
                    IF "Sub Document Type" = "Sub Document Type"::Sales THEN
                        Docmaster_3.SETRANGE(Docmaster_3."Sale/Lease", Docmaster_3."Sale/Lease"::Sale);
                    Docmaster_3.SETFILTER(Docmaster_3."Unit Code", "Unit Code");
                    Docmaster_3.SETFILTER(Code, 'BSP4');   //040424
                    IF Docmaster_3.FINDSET THEN BEGIN
                        Docmaster.RESET;
                        Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
                        Docmaster.SETFILTER(Docmaster."Project Code", "Shortcut Dimension 1 Code");
                        IF "Sub Document Type" = "Sub Document Type"::Lease THEN
                            Docmaster.SETRANGE(Docmaster."Sale/Lease", Docmaster."Sale/Lease"::Lease);
                        IF "Sub Document Type" = "Sub Document Type"::Sales THEN
                            Docmaster.SETRANGE(Docmaster."Sale/Lease", Docmaster."Sale/Lease"::Sale);
                        Docmaster.SETRANGE(Docmaster."Unit Code", '');
                        Docmaster.SETRANGE("App. Charge Code", "Unit Payment Plan");
                        Docmaster.SETFILTER("Rate/Sq. Yd", '<>%1', 0);
                        IF Docmaster.FINDFIRST THEN BEGIN
                            Job.RESET;
                            IF Job.GET("Shortcut Dimension 1 Code") THEN BEGIN
                                IF (Job."BSP4 Plan wise Applicable") AND ("Posting Date" >= Job."BSP4 Plan wise St. Date") THEN BEGIN
                                    Docmaster_3."Rate/Sq. Yd" := Docmaster."BSP4 Plan wise Rate / Sq. Yd";
                                    Docmaster_3."Total Charge Amount" := Docmaster."BSP4 Plan wise Rate / Sq. Yd" * UMaster."Saleable Area";
                                    Docmaster_3.MODIFY;
                                END ELSE BEGIN
                                    Docmaster.RESET;
                                    Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
                                    Docmaster.SETFILTER(Docmaster."Project Code", "Shortcut Dimension 1 Code");
                                    IF "Sub Document Type" = "Sub Document Type"::Lease THEN
                                        Docmaster.SETRANGE(Docmaster."Sale/Lease", Docmaster."Sale/Lease"::Lease);
                                    IF "Sub Document Type" = "Sub Document Type"::Sales THEN
                                        Docmaster.SETRANGE(Docmaster."Sale/Lease", Docmaster."Sale/Lease"::Sale);
                                    Docmaster.SETRANGE(Docmaster."Unit Code", '');
                                    Docmaster.SETRANGE(Code, 'BSP4');
                                    Docmaster.SETFILTER("Rate/Sq. Yd", '<>%1', 0);
                                    IF Docmaster.FINDFIRST THEN BEGIN
                                        Docmaster_3."Rate/Sq. Yd" := Docmaster."Rate/Sq. Yd";
                                        Docmaster_3."Total Charge Amount" := Docmaster."Rate/Sq. Yd" * UMaster."Saleable Area";
                                        Docmaster_3.MODIFY;
                                    END;
                                END;
                            END;
                        END;
                    END;



                    Docmaster.RESET;
                    Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
                    Docmaster.SETFILTER(Docmaster."Project Code", "Shortcut Dimension 1 Code");
                    IF "Sub Document Type" = "Sub Document Type"::Lease THEN
                        Docmaster.SETRANGE(Docmaster."Sale/Lease", Docmaster."Sale/Lease"::Lease);
                    IF "Sub Document Type" = "Sub Document Type"::Sales THEN
                        Docmaster.SETRANGE(Docmaster."Sale/Lease", Docmaster."Sale/Lease"::Sale);
                    Docmaster.SETFILTER(Docmaster."Unit Code", "Unit Code");
                    // IF NOT Rec."Registration Bouns (BSP2)" then   // Code added 01072025 10072025 code commented
                    //     Docmaster.SETFILTER(Code, '<>%1&<>%2&<>%3', 'PPLAN', 'PPLAN1', 'BSP2') // Code added 01072025  10072025 code commented
                    // Else                                                      // Code added 01072025  10072025 code commented                         
                    Docmaster.SETFILTER(Code, '<>%1&<>%2', 'PPLAN', 'PPLAN1');   //040424
                    IF Docmaster.FINDSET THEN
                        REPEAT
                            Docmaster.TESTFIELD(Status, Docmaster.Status::Release);  //250113
                            AppCharges.INIT;
                            AppCharges."Document Type" := Docmaster."Document Type"::Charge;
                            AppCharges.Code := Docmaster.Code;

                            AppCharges.Description := Docmaster.Description;
                            AppCharges."Document No." := "Application No.";
                            AppCharges."Item No." := "Unit Code";
                            AppCharges."Membership Fee" := Docmaster."Membership Fee";
                            IF Docmaster."Project Price Dependency Code" <> '' THEN BEGIN
                                PPGD.RESET;
                                PPGD.SETFILTER(PPGD."Project Code", "Shortcut Dimension 1 Code");
                                PPGD.SETRANGE(PPGD."Project Price Group", Docmaster."Project Price Dependency Code");
                                PPGD.SETFILTER(PPGD."Starting Date", '<=%1', "Document Date");
                                IF PPGD.FINDLAST THEN BEGIN
                                    IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Sale THEN
                                        AppCharges."Rate/UOM" := PPGD."Sales Rate (per sq ft)";
                                    IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Lease THEN
                                        AppCharges."Rate/UOM" := PPGD."Lease Rate (per sq ft)";
                                END;
                            END ELSE
                                AppCharges."Rate/UOM" := Docmaster."Rate/Sq. Yd";

                            AppCharges."Project Code" := Docmaster."Project Code";
                            AppCharges."Fixed Price" := Docmaster."Fixed Price";
                            AppCharges."BP Dependency" := Docmaster."BP Dependency";
                            AppCharges."Rate Not Allowed" := Docmaster."Rate Not Allowed";
                            AppCharges."Project Price Dependency Code" := Docmaster."Project Price Dependency Code";
                            IF AppCharges."Rate/UOM" <> 0 THEN BEGIN
                                ItemRec.GET("Unit Code");
                                //AppCharges."Net Amount" := ROUND(ItemRec."Saleable Area" * AppCharges."Rate/UOM",1);
                                AppCharges."Net Amount" := ItemRec."Saleable Area" * AppCharges."Rate/UOM"; //170113
                            END ELSE
                                AppCharges."Net Amount" := AppCharges."Fixed Price";
                            AppCharges.Sequence := Docmaster.Sequence;

                            IF AppCharges.Code = 'PLC' THEN BEGIN
                                Plcrec.SETFILTER("Item Code", "Unit Code");
                                Plcrec.SETFILTER("Job Code", "Shortcut Dimension 1 Code");
                                IF Plcrec.FINDFIRST THEN
                                    REPEAT
                                        AppCharges."Fixed Price" := AppCharges."Fixed Price" + Plcrec.Amount;
                                        AppCharges."Net Amount" := AppCharges."Fixed Price";
                                    UNTIL Plcrec.NEXT = 0;
                            END;
                            AppCharges."Commision Applicable" := Docmaster."Commision Applicable";
                            AppCharges."Direct Associate" := Docmaster."Direct Associate";
                            AppCharges.Applicable := TRUE;
                            totalamount := totalamount + AppCharges."Net Amount";
                            AppCharges.INSERT;

                        UNTIL Docmaster.NEXT = 0;

                    //------------------------------------------
                    Docmaster.RESET;
                    Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
                    Docmaster.SETFILTER(Docmaster."Project Code", "Shortcut Dimension 1 Code");
                    IF "Sub Document Type" = "Sub Document Type"::Lease THEN
                        Docmaster.SETRANGE(Docmaster."Sale/Lease", Docmaster."Sale/Lease"::Lease);
                    IF "Sub Document Type" = "Sub Document Type"::Sales THEN
                        Docmaster.SETRANGE(Docmaster."Sale/Lease", Docmaster."Sale/Lease"::Sale);
                    Docmaster.SETRANGE(Docmaster."Unit Code", '');
                    Docmaster.SETRANGE("App. Charge Code", "Unit Payment Plan");
                    Docmaster.SETFILTER("Rate/Sq. Yd", '<>%1', 0);
                    IF Docmaster.FINDFIRST THEN BEGIN
                        // AppCharges.RESET;
                        AppCharges.INIT;
                        AppCharges."Document Type" := Docmaster."Document Type"::Charge;
                        AppCharges.Code := Docmaster.Code;

                        AppCharges.Description := Docmaster.Description;
                        AppCharges."Document No." := "Application No.";
                        AppCharges."Item No." := "Unit Code";
                        AppCharges."Membership Fee" := Docmaster."Membership Fee";
                        IF Docmaster."Project Price Dependency Code" <> '' THEN BEGIN
                            PPGD.RESET;
                            PPGD.SETFILTER(PPGD."Project Code", "Shortcut Dimension 1 Code");
                            PPGD.SETRANGE(PPGD."Project Price Group", Docmaster."Project Price Dependency Code");
                            PPGD.SETFILTER(PPGD."Starting Date", '<=%1', "Document Date");
                            IF PPGD.FINDLAST THEN BEGIN
                                IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Sale THEN
                                    AppCharges."Rate/UOM" := PPGD."Sales Rate (per sq ft)";
                                IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Lease THEN
                                    AppCharges."Rate/UOM" := PPGD."Lease Rate (per sq ft)";
                            END;
                        END ELSE
                            AppCharges."Rate/UOM" := Docmaster."Rate/Sq. Yd";

                        AppCharges."Project Code" := Docmaster."Project Code";
                        AppCharges."Fixed Price" := Docmaster."Fixed Price";
                        AppCharges."BP Dependency" := Docmaster."BP Dependency";
                        AppCharges."Rate Not Allowed" := Docmaster."Rate Not Allowed";
                        AppCharges."Project Price Dependency Code" := Docmaster."Project Price Dependency Code";
                        IF AppCharges."Rate/UOM" <> 0 THEN BEGIN
                            ItemRec.GET("Unit Code");
                            //AppCharges."Net Amount" := ROUND(ItemRec."Saleable Area" * AppCharges."Rate/UOM",1);
                            AppCharges."Net Amount" := ItemRec."Saleable Area" * AppCharges."Rate/UOM"; //170113
                        END ELSE
                            AppCharges."Net Amount" := AppCharges."Fixed Price";
                        AppCharges.Sequence := Docmaster.Sequence;

                        AppCharges."Commision Applicable" := Docmaster."Commision Applicable";
                        AppCharges."Direct Associate" := Docmaster."Direct Associate";
                        AppCharges.Applicable := TRUE;
                        totalamount := totalamount + AppCharges."Net Amount";
                        AppCharges.INSERT;
                    END;

                    //------------------------- 030219

                    //Code commented 040424
                    /*
                      Docmaster.RESET;
                      Docmaster.SETRANGE(Docmaster."Document Type",Docmaster."Document Type"::Charge);
                      Docmaster.SETFILTER(Docmaster."Project Code","Shortcut Dimension 1 Code");
                      IF "Sub Document Type"="Sub Document Type"::Lease THEN
                        Docmaster.SETRANGE(Docmaster."Sale/Lease",Docmaster."Sale/Lease"::Lease);
                      IF "Sub Document Type"="Sub Document Type"::Sales THEN
                        Docmaster.SETRANGE(Docmaster."Sale/Lease",Docmaster."Sale/Lease"::Sale);
                      Docmaster.SETRANGE(Docmaster."Unit Code",'');
                      Docmaster.SETRANGE("Sub Sub Payment Plan Code","Unit Payment Plan");
                      Docmaster.SETFILTER("Rate/Sq. Yd",'<>%1',0);
                      IF Docmaster.FINDFIRST THEN BEGIN
                            AppCharges.INIT;
                            AppCharges."Document Type" :=Docmaster."Document Type"::Charge;
                            AppCharges.Code:=Docmaster.Code;

                            AppCharges.Description:=Docmaster.Description;
                            AppCharges."Document No." := "Application No.";
                            AppCharges."Item No." := "Unit Code";
                            AppCharges."Membership Fee" := Docmaster."Membership Fee";
                            IF Docmaster."Project Price Dependency Code" <> '' THEN BEGIN
                              PPGD.RESET;
                              PPGD.SETFILTER(PPGD."Project Code","Shortcut Dimension 1 Code");
                              PPGD.SETRANGE(PPGD."Project Price Group",Docmaster."Project Price Dependency Code");
                              PPGD.SETFILTER(PPGD."Starting Date",'<=%1',"Document Date");
                              IF PPGD.FINDLAST THEN BEGIN
                                IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Sale THEN
                                  AppCharges."Rate/UOM" := PPGD."Sales Rate (per sq ft)";
                                IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Lease THEN
                                  AppCharges."Rate/UOM" := PPGD."Lease Rate (per sq ft)";
                              END;
                            END ELSE
                              AppCharges."Rate/UOM" := Docmaster."Rate/Sq. Yd";

                            AppCharges."Project Code" := Docmaster."Project Code";
                            AppCharges."Fixed Price" := Docmaster."Fixed Price";
                            AppCharges."BP Dependency" := Docmaster."BP Dependency";
                            AppCharges."Rate Not Allowed" := Docmaster."Rate Not Allowed";
                            AppCharges."Project Price Dependency Code" := Docmaster."Project Price Dependency Code";
                            IF AppCharges."Rate/UOM" <> 0 THEN BEGIN
                              ItemRec.GET("Unit Code");
                              //AppCharges."Net Amount" := ROUND(ItemRec."Saleable Area" * AppCharges."Rate/UOM",1);
                              AppCharges."Net Amount" := ItemRec."Saleable Area" * AppCharges."Rate/UOM"; //170113
                            END ELSE
                              AppCharges."Net Amount" := AppCharges."Fixed Price";
                            AppCharges.Sequence := Docmaster.Sequence;

                            AppCharges."Commision Applicable" := Docmaster."Commision Applicable";
                            AppCharges."Direct Associate" := Docmaster."Direct Associate" ;
                            AppCharges.Applicable := TRUE;
                            totalamount := totalamount + AppCharges."Net Amount";
                            AppCharges.INSERT;
                          END;
                        */
                    //Code commented 040424
                    //--------------------------
                    //------------------------------------------

                    totalamount := ROUND(totalamount, 1, '=');
                    "Investment Amount" := totalamount;


                END ELSE BEGIN
                    AppCharges.RESET;
                    AppCharges.SETCURRENTKEY("Document No.");
                    AppCharges.SETRANGE(AppCharges."Document No.", "Application No.");
                    IF AppCharges.FINDFIRST THEN
                        AppCharges.DELETEALL;
                END;

                //ALLEDK 210921 Start
                CompanywiseGLAccount.RESET;
                CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
                IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                    v_ResponsibilityCenter.RESET;
                    v_ResponsibilityCenter.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                END;
                v_ResponsibilityCenter.GET("Shortcut Dimension 1 Code");
                IF v_ResponsibilityCenter."Min. Allotment %" <> 0 THEN
                    "Min. Allotment Amount" := ROUND((("Investment Amount" + "Development Charges") * v_ResponsibilityCenter."Min. Allotment %" / 100), 1, '=');

                //ALLEDK 210921 END
                IF ItemRec.GET("Unit Code") THEN
                    VALIDATE("Payment Plan", ItemRec."Payment Plan");

                // ALLEPG 310812 Start
                IF UnitMaster.GET("Unit Code") THEN BEGIN
                    UnitMaster.Freeze := TRUE;
                    UnitMaster.MODIFY;
                    "Saleable Area" := UnitMaster."Saleable Area";
                END;

                IF "Unit Code" <> xRec."Unit Code" THEN
                    IF UnitMaster.GET(xRec."Unit Code") THEN BEGIN
                        UnitMaster.Freeze := FALSE;
                        UnitMaster.MODIFY;
                    END;
                // ALLEPG 310812 End
                //ALLETDK >>
                IF "Unit Code" = '' THEN BEGIN
                    "Shortcut Dimension 1 Code" := '';
                    VALIDATE("Investment Amount", 0);
                END;
                //ALLETDK <<

            end;
        }
        field(50002; "Total Received Amount"; Decimal)
        {
            CalcFormula = Sum("Application Payment Entry".Amount WHERE("Document Type" = CONST(Application),
                                                                        "Document No." = FIELD("Application No."),
                                                                        Posted = CONST(true),
                                                                        "Cheque Status" = FILTER(<> Bounced)));
            Editable = false;
            FieldClass = FlowField;
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
        field(50010; "Company Name"; Text[50])
        {
        }
        field(50112; "Application Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Trading,Non Trading';
            OptionMembers = Trading,"Non Trading";
        }
        field(50201; "Unit Payment Plan"; Code[20])
        {
            TableRelation = "App. Charge Code".Code WHERE("Sub Payment Plan" = FILTER(true));
        }
        field(50202; "Unit Plan Name"; Text[50])
        {
            Editable = false;
        }
        field(50236; "Development Charges"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60010; "Payment Plan"; Code[20])
        {
            TableRelation = "Document Master".Code WHERE("Document Type" = FILTER("Payment Plan"),
                                                          "Project Code" = FIELD("Shortcut Dimension 1 Code"));

            trigger OnValidate()
            begin
                IF xRec."Payment Plan" = '' THEN BEGIN
                    PaymentPlanDetails.RESET;
                    PaymentPlanDetails.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                    PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Payment Plan Code", "Payment Plan");
                    PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Document No.", '');
                    PaymentPlanDetails.SETRANGE("Sub Payment Plan", "Unit Payment Plan");
                    IF PaymentPlanDetails.FINDSET THEN
                        REPEAT
                            PaymentPlanDetails1.INIT;
                            PaymentPlanDetails1.COPY(PaymentPlanDetails);
                            PaymentPlanDetails1."Document No." := "Application No.";
                            PaymentPlanDetails1."Project Milestone Due Date" :=
                            CALCDATE(PaymentPlanDetails1."Due Date Calculation", "Posting Date"); //ALLETDK221112
                            IF FORMAT(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat") <> '' THEN //ALLEDK 040821
                                PaymentPlanDetails1."Auto Plot Vacate Due Date" := CALCDATE(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat", PaymentPlanDetails1."Project Milestone Due Date") //ALLEDK 040821
                            ELSE
                                PaymentPlanDetails1."Auto Plot Vacate Due Date" := PaymentPlanDetails1."Project Milestone Due Date";

                            PaymentPlanDetails."Default Setup" := FALSE;
                            PaymentPlanDetails1.INSERT;
                        UNTIL PaymentPlanDetails.NEXT = 0;
                    //ALLERE
                END
                ELSE BEGIN
                    IF "Payment Plan" <> xRec."Payment Plan" THEN BEGIN
                        PaymentPlanDetails.RESET;
                        PaymentPlanDetails.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                        PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Payment Plan Code", xRec."Payment Plan");
                        PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Document No.", "Application No.");
                        IF PaymentPlanDetails.FINDFIRST THEN BEGIN
                            PaymentPlanDetails.DELETEALL;
                            PaymentPlanDetails.RESET;
                            PaymentPlanDetails.SETRANGE("Project Code", "Shortcut Dimension 1 Code");
                            PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Payment Plan Code", "Payment Plan");
                            PaymentPlanDetails.SETRANGE(PaymentPlanDetails."Document No.", '');
                            PaymentPlanDetails.SETRANGE("Sub Payment Plan", "Unit Payment Plan");
                            IF PaymentPlanDetails.FIND('-') THEN
                                REPEAT
                                    PaymentPlanDetails1.INIT;
                                    PaymentPlanDetails1.COPY(PaymentPlanDetails);
                                    PaymentPlanDetails1."Document No." := "Application No.";
                                    PaymentPlanDetails1."Project Milestone Due Date" :=
                                    CALCDATE(PaymentPlanDetails1."Due Date Calculation", "Posting Date"); //ALLETDK221112
                                    IF FORMAT(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat") <> '' THEN //ALLEDK 040821
                                        PaymentPlanDetails1."Auto Plot Vacate Due Date" := CALCDATE(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat", PaymentPlanDetails1."Project Milestone Due Date") //ALLEDK 040821
                                    ELSE
                                        PaymentPlanDetails1."Auto Plot Vacate Due Date" := PaymentPlanDetails1."Project Milestone Due Date";

                                    PaymentPlanDetails1."Default Setup" := FALSE;
                                    PaymentPlanDetails1.INSERT;
                                UNTIL PaymentPlanDetails.NEXT = 0;
                        END;
                    END;
                END;
                IF "Payment Plan" <> '' THEN BEGIN
                    RefreshMilestoneAmount;
                    InsertMilestone;
                END
            end;
        }
        field(60011; "Amount Refunded"; Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(60012; "Min. Allotment Amount"; Decimal)
        {
            Editable = false;
        }
        field(60013; "Saleable Area"; Decimal)
        {
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
            Description = 'ALLETDK';
        }
        field(90035; "Expexted Discount by BBG"; Decimal)
        {
            Description = 'ALLEDK  150313';
        }
        field(90036; "Bill-to Customer Name"; Text[60])
        {
            Description = 'BBG1.00 300313';

            trigger OnValidate()
            begin
                IF "Bill-to Customer Name" <> '' THEN
                    "Customer Name" := "Bill-to Customer Name";
            end;
        }
        field(90037; "Registration Bonus Hold(BSP2)"; Boolean)
        {
            Description = 'BBG1.00 010413';
        }
        field(90120; "Loan File"; Boolean)    //251124 new field
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60045; "New Loan File"; Option)     //251124 New field
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Yes,No;
            OptionCaption = ' ,Yes,No';
        }
        field(50011; "Rank Code"; Code[10])   // Code added 01072025
        {
            Editable = false;
        }
        field(90121; "Travel applicable"; Boolean)  //New field added 01072025
        {
            Editable = False;

        }
        field(90122; "Registration Bouns (BSP2)"; Boolean)    //New field added 01072025
        {
            Editable = False;

        }
        field(90060; "Customer State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;
        }
        field(60040; "District Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'District Code';
            DataClassification = ToBeClassified;
            TableRelation = "District Details".Code where("State Code" = field("Customer State Code"));
        }
        field(60041; "Mandal Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Mandal Code';
            DataClassification = ToBeClassified;
            TableRelation = "Mandal Details".Code where("State Code" = field("Customer State Code"), "District Code" = field("District Code"));
        }
        field(60042; "Village Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Village Code';
            DataClassification = ToBeClassified;
            TableRelation = "Village Details".Code where("State Code" = field("Customer State Code"), "District Code" = field("District Code"), "Mandal Code" = field("Mandal Code"));
        }

    }

    keys
    {
        key(Key1; "Application No.")
        {
            Clustered = true;
        }
        key(Key2; Status, "Shortcut Dimension 2 Code", "Application No.", "With Cheque", "Cheque Cleared")
        {
        }
        key(Key3; Status, "Shortcut Dimension 2 Code", "Posting Date", "Received From Code")
        {
        }
        key(Key4; Status, "Shortcut Dimension 2 Code", "Received From Code")
        {
        }
        key(Key5; "Unit No.")
        {
        }
        key(Key6; "Project Type", "Posting Date", Duration, Category, "Unit No.", Status)
        {
        }
        key(Key7; "Unit Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Findconforder.RESET;
        Findconforder.SETRANGE("No.", "Application No.");
        IF Findconforder.FINDFIRST THEN BEGIN

        END ELSE BEGIN
            TESTFIELD(Status, Status::Open);
            BondPmtLine.SETRANGE("Document Type", BondPmtLine."Document Type"::Application);
            BondPmtLine.SETRANGE("Document No.", "Application No.");
            BondPmtLine.DELETEALL;

            ApplicationPayEntry.SETRANGE("Document Type", BondPmtLine."Document Type"::Application);
            ApplicationPayEntry.SETRANGE("Document No.", "Application No.");
            ApplicationPayEntry.DELETEALL;

            AppCommentLine.SETRANGE("Table Name", DATABASE::Application);
            AppCommentLine.SETRANGE("No.", "Application No.");
            AppCommentLine.DELETEALL;
        END;

        //{
        //IF "Unit Code" <> xRec."Unit Code" THEN BEGIN
        IF UnitMaster.GET("Unit Code") THEN BEGIN
            UnitMaster.Freeze := FALSE;
            UnitMaster.MODIFY;
        END;
        //END;
        //}
    end;

    trigger OnInsert()
    var
        BondPaymentEntry: Record "Unit Payment Entry";
        PaymentMethod: Record "Payment Method";
        GetDescription: Codeunit GetDescription;
    begin
        //ALLECK 080313 START
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETRANGE("Role ID", 'A_APPCREATION');
        IF NOT MemberOf.FINDFIRST THEN
            ERROR('You do not have permission of role  :A_APPCREATION');
        //ALLECK 080313 End
        IF "Application No." = '' THEN BEGIN
            BondSetup.GET;
            BondSetup.TESTFIELD("Application Nos.");
            //ALLEDK 301112 For Check empty Application
            RecordNotFound := FALSE;
            RecApp.RESET;
            RecApp.SETRANGE("User ID", USERID);
            IF RecApp.FINDSET THEN BEGIN
                REPEAT
                    IF RecApp."Unit Code" = '' THEN
                        RecordNotFound := TRUE;
                    IF RecApp."Associate Code" = '' THEN
                        RecordNotFound := TRUE;
                    IF RecApp."Customer No." = '' THEN
                        RecordNotFound := TRUE;
                    IF RecApp."Project Type" = '' THEN
                        RecordNotFound := TRUE;
                UNTIL RecApp.NEXT = 0;

                IF RecordNotFound THEN
                    ERROR('You have already created Application No.-' + RecApp."Application No." + ' ' + 'kindly use it');
            END;
            IF NOT RecordNotFound THEN BEGIN
                NoSeriesMgt.InitSeries(BondSetup."Application Nos.", xRec."No. Series", 0D, "Application No.", "No. Series");
                "Posting Date" := WORKDATE;
                "Document Date" := WORKDATE;
                // "Document Date" := GetDescription.GetDocomentDate;
                "User ID" := USERID;
                "Creation Date" := TODAY; //ALLETDK
                "Creation Time" := TIME; //ALLETDK

                UserSetup.GET(USERID);
                UserSetup.TESTFIELD("Responsibility Center");
                //UserSetup.TESTFIELD("Shortcut Dimension 2 Code");
                // "Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
                //"Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
                "Branch Code" := UserSetup."User Branch";
                UpdateProjectType;
                BondSetup.GET;
                //"Service Charge Amount" := BondSetup."Service Charge Amount";
                "Investment Type" := "Investment Type"::FD;
                //ALLEDK 010113
                //ALLEDK 010113
            END;
            "Registration Bonus Hold(BSP2)" := TRUE;  //BBG1.00 180413

        END;

        "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
    end;

    trigger OnModify()
    begin
        TESTFIELD(Status, Status::Open);
    end;

    trigger OnRename()
    begin
        ERROR(Text001, TABLECAPTION);
    end;

    var
        Text001: Label '%1 already exists.';
        Text002: Label 'You cannot rename a %1.';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        BondSetup: Record "Unit Setup";
        UserSetup: Record "User Setup";
        Customer: Record Customer;
        Text003: Label 'Please select correct Investment Amount.';
        Project: Record Job;
        BondPost: Codeunit "Unit Post";
        Text004: Label 'Invalid setup for Commission and Bonus for %1 %2, %3 %4, %5 %6.';
        Text005: Label 'No return amount found in the scheme.';
        Text006: Label 'No scheme exist for bond type %1, Investment type %2, and Duration %3.';
        PostPayment: Codeunit PostPayment;
        BondPmtLine: Record "Unit Payment Entry";
        BondHistory: Record "Unit History";
        AppCommentLine: Record "Comment Line";
        Text007: Label 'RECEIVED FROM CODE %1 and ASSOCIATE CODE %2 are not from the same chain or RECEIVED FROM CODE is junior than ASSOCIATE CODE!';
        Text008: Label '%1 must be %2 for %3 %4, %5 %6, %7 %8, %9 %10.';
        GetDescription: Codeunit GetDescription;
        Docmaster: Record "Document Master";
        AppCharges: Record "Applicable Charges";
        PPGD: Record "Project Price Group Details";
        ItemRec: Record "Unit Master";
        Plcrec: Record "PLC Details";
        totalamount: Decimal;
        PaymentDetails: Record "Payment Plan Details";
        PaymentPlanDetails: Record "Payment Plan Details";
        PaymentPlanDetails1: Record "Payment Plan Details";
        LoopingAmount: Decimal;
        OldMileStone: Code[10];
        RemainingAmt: Decimal;
        RemainingBrokerageAmt: Decimal;
        Sno: Code[20];
        RecApp: Record Application;
        Applicablecharge: Record "Applicable Charges";
        PaymentPlanDetails2: Record "Payment Plan Details" temporary;
        CNT: Integer;
        MilestoneCodeG: Code[10];
        InLoop: Boolean;
        PaymentTermLine: Record "Payment Terms Line Sale";
        PaymentTermLines: Record "Payment Terms Line Sale";
        ApplicationPayEntry: Record "Application Payment Entry";
        Vendor: Record Vendor;
        Text50000: Label 'Associate %1  PAN No. not verified';
        Application: Record Application;
        UnitMaster: Record "Unit Master";
        UMaster: Record "Unit Master";
        RecordNotFound: Boolean;
        ApplicationPaymentEntry: Record "Application Payment Entry";
        OldCust: Record Customer;
        Job: Record Job;
        Vend: Record Vendor;
        ProjectMilestoneLine: Record "Project Milestone Line";
        PLDetails: Record "Payment Plan Details";
        PTSLine: Record "Payment Terms Line Sale";
        AmountToWords: Codeunit "Amount To Words";
        AmountText1: array[2] of Text[300];
        CreatUPEntryfromApplication: Codeunit "Creat UPEry from ConfOrder/APP";
        ReleaseBondApplication: Codeunit "Release Unit Application";
        ExcessAmount: Decimal;
        UnitandCommCreationJob: Codeunit "Unit and Comm. Creation Job";
        AppLication2: Record Application;
        CreateConfirmedOrder: Codeunit "Unit and Comm. Creation Job";
        unitpost: Codeunit "Unit Post";
        Findconforder: Record "Confirmed Order";
        MemberOf: Record "Access Control";
        CompanywiseGLAccount: Record "Company wise G/L Account";
        v_ResponsibilityCenter: Record "Responsibility Center 1";


    procedure AssistEdit(OldAppl: Record Application): Boolean
    var
        Appl: Record Application;
    begin
        Appl := Rec;
        BondSetup.GET;
        BondSetup.TESTFIELD("Application Nos.");
        IF NoSeriesMgt.SelectSeries(BondSetup."Application Nos.", OldAppl."No. Series", Appl."No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries(Appl."Application No.");
            Rec := Appl;
            EXIT(TRUE);
        END;
    end;


    procedure TotalApplicationAmount(): Decimal
    begin
        EXIT("Investment Amount" + "Service Charge Amount");
    end;


    procedure CreateCustomer(BondHolderName: Text[50]): Code[20]
    var
        Customer: Record Customer;
        Template: Record "Config. Template Header";
        TemplateMgt: Codeunit "Config. Template Management";
        RecRef: RecordRef;
    begin
        BondSetup.GET;
        BondSetup.TESTFIELD("Customer Template Code");

        Template.GET(BondSetup."Customer Template Code");
        /*
        OldCust.RESET;
        //OldCust.SETRANGE(Name,"Customer Name");                  //ALLETDK
        //OldCust.SETRANGE(OldCust."Father's/Husband's Name","Father / Husband Name"); //ALLETDK
        OldCust.SETRANGE(OldCust."Date of Birth","Member's D.O.B");                   //ALLETDK
        //OldCust.SETRANGE("Mobile No.","Mobile No.");
        IF OldCust.FINDFIRST THEN
          EXIT(OldCust."No."); //ALLETDK
        */

        //BBG1.00 041013

        Customer.INIT;
        Customer.VALIDATE(Name, BondHolderName);
        Customer."Customer Posting Group" := BondSetup."Customer Posting Group";
        Customer."No. Series" := BondSetup."Customer No Series";
        Customer."BBG Father's/Husband's Name" := "Father / Husband Name";
        Customer."BBG Mobile No." := "Mobile No.";
        Customer."BBG Date of Birth" := "Member's D.O.B";
        Customer."E-Mail" := "E-mail";
        Customer."Country/Region Code" := 'IN'; //Code added 23072025
        Customer.INSERT(TRUE);

        RecRef.GETTABLE(Customer);
        TemplateMgt.UpdateRecord(Template, RecRef);

        EXIT(Customer."No.");

    end;


    procedure SelectScheme()
    var
    //BondPostingGroup: Record 97747;
    begin
        /*SchemeHeader.RESET;
        SchemeHeader.SETCURRENTKEY("Posting User Code","TO Receive USER Name","TO Receive USER Code","User Responsibility Center");
        SchemeHeader.SETRANGE("Posting User Code","Bond Type");
        SchemeHeader.SETRANGE("TO Receive USER Name","Investment Type");
        SchemeHeader.SETRANGE("TO Receive USER Code",Duration);
        SchemeHeader.SETRANGE("Don't Show",FALSE);
        IF SchemeHeader.FINDLAST THEN BEGIN
          "Scheme Code" := SchemeHeader."Document Type";
          "Scheme Version No." := SchemeHeader."Sub Document Type";
          "Scheme Sub Version No." := "Scheme Sub Version No.";
          "Maturity Date" := CALCDATE(FORMAT(Duration)+'M',WORKDATE);
          BondPostingGroup.RESET;
          BondPostingGroup.SETRANGE("ID 1 Group Code","Bond Type");
          BondPostingGroup.SETRANGE("ID 2 Group Code",Duration);
          IF BondPostingGroup.FINDFIRST THEN
            "Bond Posting Group" := BondPostingGroup."Item Category Code"   //;  //BondPostingGroup."G/L Account No."
          ELSE
            "Bond Posting Group" := '';
          //"Maturity Amount" := CalculateAmt;
        END ELSE BEGIN
          "Scheme Code" := '';
          "Scheme Version No." := 0;
          "Scheme Sub Version No." := 0;
          "Maturity Date" := 0D;
          "Maturity Amount" := 0;
          "Bond Posting Group" := '';
          IF ("Bond Type" <> '') AND ("Investment Type" <> "Investment Type"::" ") AND (Duration <> 0) THEN
            ERROR(Text006,"Bond Type","Investment Type",Duration);
        END;
         */

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
        //Ayan
        "Maturity Bonus Amount" := 0;
        IF "Investment Frequency" = "Investment Frequency"::" " THEN
            PaymentPerYear := "Investment Amount" + "Discount Amount"
        ELSE IF "Investment Frequency" = "Investment Frequency"::Monthly THEN
            PaymentPerYear := ("Investment Amount" + "Discount Amount") * 12
        ELSE IF "Investment Frequency" = "Investment Frequency"::Quarterly THEN
            PaymentPerYear := ("Investment Amount" + "Discount Amount") * 4
        ELSE IF "Investment Frequency" = "Investment Frequency"::"Half Yearly" THEN
            PaymentPerYear := ("Investment Amount" + "Discount Amount") * 2
        ELSE IF "Investment Frequency" = "Investment Frequency"::Annually THEN
            PaymentPerYear := ("Investment Amount" + "Discount Amount");

        NoOfYear := Duration DIV 12;
        //IF NOT SchemeHeader.GET("Scheme Code","Scheme Version No.") THEN
        //EXIT(0);
        //Interest := SchemeHeader."Interest %";

        IF ((PaymentPerYear > 0) OR ("Investment Amount" > 0)) AND (NoOfYear > 0) AND (Interest > 0) THEN BEGIN
            IF "Investment Type" = "Investment Type"::RD THEN
                Result := PaymentPerYear * (1 + Interest * 0.01) * ((POWER((1 + (Interest * 0.01)), NoOfYear)) - 1) / (Interest * 0.01);


            IF ("Investment Type" = "Investment Type"::FD) //AND (SchemeHeader."Interest Type"=SchemeHeader."Interest Type"::"1")
            THEN BEGIN
                Result := (("Investment Amount" + "Discount Amount") * POWER(1 + (Interest * 0.01), NoOfYear));
                IF ("Project Type" = 'ORCHARD') AND (Duration = 75) THEN
                    IF ("Scheme Version No." = 10) OR ("Scheme Version No." = 12) THEN
                        Result := (("Investment Amount" + "Discount Amount") * 2);
            END;

            IF ("Investment Type" = "Investment Type"::MIS)
            //AND (SchemeHeader."Interest Type"=SchemeHeader."Interest Type"::"0")
            THEN BEGIN
                Result := "Investment Amount" + "Discount Amount";
                IntAmt := 0;
                IntAmt := (("Investment Amount" + "Discount Amount") * (Interest * 0.01) * NoOfYear);
                //IF SchemeHeader."Bonus Per" > 0 THEN
                //"Maturity Bonus Amount" := ROUND(((SchemeHeader."Bonus Amount"/SchemeHeader."Bonus Per") * Result),1);
            END;

            IF ("Investment Type" = "Investment Type"::FD)
            // AND (SchemeHeader."Interest Type"=SchemeHeader."Interest Type"::"0")
            THEN BEGIN
                "Maturity Date" := CALCDATE('-1D', "Maturity Date");
                Result := (("Investment Amount" + "Discount Amount") + (("Investment Amount" + "Discount Amount") * Interest * 0.01 * NoOfYear)
            );
                /*
                SchemeLine.SETRANGE("Document Type","Scheme Code");
                SchemeLine.SETRANGE("Sub Document Type","Scheme Version No.");
                SchemeLine.SETRANGE("Line No","Investment Amount" + "Discount Amount");
                IF SchemeLine.FINDFIRST THEN
                  IF SchemeLine."Authorized Time" > 0 THEN BEGIN
                    "Maturity Bonus Amount" := SchemeLine."Authorized Time";
                    Result := Result;
                END;
                */
            END;
            Result := ROUND(Result, 1);

        END;
        /*
        IF ((PaymentPerYear> 0) OR (("Investment Amount" + "Discount Amount") > 0 )) AND (NoOfYear > 0)  AND (Interest = 0) THEN BEGIN
          IF ("Investment Type" = "Investment Type"::RD) THEN BEGIN
            SchemeLine.RESET;
            SchemeLine.SETRANGE(SchemeLine."Document Type","Scheme Code");
            SchemeLine.SETRANGE(SchemeLine."Sub Document Type","Scheme Version No.");
            IF "Investment Frequency" = "Investment Frequency"::Monthly THEN
              SchemeLine.SETRANGE(SchemeLine."Alternate Approvar ID","Investment Amount" + "Discount Amount");
            IF "Investment Frequency" = "Investment Frequency"::Quarterly THEN
              SchemeLine.SETRANGE(SchemeLine."Min Amount Limit","Investment Amount" + "Discount Amount");
            IF "Investment Frequency" = "Investment Frequency"::"Half Yearly" THEN
              SchemeLine.SETRANGE(SchemeLine."Max Amount Limit","Investment Amount" + "Discount Amount");
            IF "Investment Frequency" = "Investment Frequency"::Annually THEN
              SchemeLine.SETRANGE(SchemeLine."Document No","Investment Amount" + "Discount Amount");
            IF SchemeLine.FINDFIRST THEN BEGIN
              "Return Amount" := SchemeLine."Authorized Date";
              "Maturity Bonus Amount" := SchemeLine."Authorized Time";
              Result:="Return Amount" + "Maturity Bonus Amount";
            END ELSE
              ERROR('Maturity Amount Not Available');
          END;
        
          IF "Investment Type" = "Investment Type"::MIS THEN BEGIN
            IntAmt := 0;
            SchemeLine.RESET;
            SchemeLine.SETRANGE(SchemeLine."Document Type","Scheme Code");
            SchemeLine.SETRANGE(SchemeLine."Sub Document Type","Scheme Version No.");
            SchemeLine.SETRANGE(SchemeLine."Line No","Investment Amount" + "Discount Amount");
            IF SchemeLine.FINDFIRST THEN BEGIN
              IF "Return Frequency" = "Investment Frequency"::Monthly THEN
                IntAmt := SchemeLine."Alternate Approvar ID";
              IF "Return Frequency" = "Investment Frequency"::Quarterly THEN
                IntAmt := SchemeLine."Min Amount Limit";
              IF "Return Frequency" = "Investment Frequency"::"Half Yearly" THEN
                IntAmt := SchemeLine."Max Amount Limit";
              IF "Return Frequency" = "Investment Frequency"::Annually THEN
                IntAmt := SchemeLine."Document No";
              "Return Amount" := SchemeLine."Authorized Date";
              "Maturity Bonus Amount" := SchemeLine."Authorized Time";
               Result:="Return Amount";
            END ELSE
              ERROR('Maturity Amount Not Available');
          END;
        
          IF "Investment Type" = "Investment Type"::FD THEN BEGIN
            SchemeLine.RESET;
            SchemeLine.SETRANGE(SchemeLine."Document Type","Scheme Code");
            SchemeLine.SETRANGE(SchemeLine."Sub Document Type","Scheme Version No.");
            SchemeLine.SETRANGE(SchemeLine."Line No","Investment Amount" + "Discount Amount");
            IF SchemeLine.FINDFIRST THEN BEGIN
              "Return Amount" := SchemeLine."Authorized Date";
              "Maturity Bonus Amount" := SchemeLine."Authorized Time";
              Result:="Return Amount";
            END ELSE
              ERROR('Maturity Amount Not Available');
            IF ("Bond Type" = 'TEAK')THEN BEGIN
              SchemeLine.RESET;
              SchemeLine.SETRANGE(SchemeLine."Document Type","Scheme Code");
              SchemeLine.SETRANGE(SchemeLine."Sub Document Type","Scheme Version No.");
              SchemeLine.SETRANGE(SchemeLine."Line No","Investment Amount" + "Discount Amount");
              SchemeLine.SETRANGE(SchemeLine.Status,(Duration DIV 12));
              IF SchemeLine.FINDFIRST THEN BEGIN
                "Return Amount" := 0;
                "Maturity Bonus Amount" := SchemeLine."Authorized Time";
                Result := SchemeLine."Authorized Date";
              END ELSE
                ERROR('Bonus Amount and Return Amount not available');
            END;
          END;
          Result:=ROUND(Result,1);
        END;
        EXIT(Result);
         */

    end;


    procedure DeletePaymentLine(DocumentNo: Code[20])
    var
        BondPaymentEntry: Record "Unit Payment Entry";
    begin
        BondPaymentEntry.SETRANGE("Document Type", BondPaymentEntry."Document Type"::Application);
        BondPaymentEntry.SETRANGE("Document No.", DocumentNo);
        BondPaymentEntry.SETFILTER("Line No.", '<>%1', 10000);
        IF NOT BondPaymentEntry.ISEMPTY THEN
            IF CONFIRM('Do you want to delete payment lines') THEN
                BondPaymentEntry.DELETEALL;
    end;


    procedure CreateCustomerBankAccount(ApplicationNo: Code[20]; CustomerNo: Code[20]; BankAccountNo: Text[30]; BranchName: Text[50])
    var
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        CustomerBankAccount.INIT;
        IF NOT CustomerBankAccount.GET(CustomerNo, ApplicationNo) THEN BEGIN
            CustomerBankAccount."Customer No." := CustomerNo;
            CustomerBankAccount.Code := ApplicationNo;
            CustomerBankAccount.INSERT;
        END;
        CustomerBankAccount."Name 2" := BranchName;
        CustomerBankAccount."Bank Account No." := BankAccountNo;
        CustomerBankAccount.MODIFY;
    end;


    procedure RefreshMilestoneAmount()
    begin
        totalamount := 0;
        PaymentDetails.RESET;
        PaymentDetails.SETFILTER("Project Code", "Shortcut Dimension 1 Code");
        PaymentDetails.SETFILTER("Document No.", "Application No.");
        //SETFILTER("Charge Code",Code);
        IF PaymentDetails.FINDFIRST THEN
            REPEAT
                IF PaymentDetails."Percentage Cum" > 0 THEN BEGIN
                    IF PaymentDetails."Percentage Cum" = 100 THEN
                        PaymentDetails."Total Charge Amount" := ("Investment Amount" - totalamount)
                    ELSE
                        PaymentDetails."Total Charge Amount" := ("Investment Amount" * PaymentDetails."Percentage Cum" / 100) - totalamount;
                END;
                IF PaymentDetails."Fixed Amount" <> 0 THEN BEGIN
                    PaymentDetails."Total Charge Amount" := PaymentDetails."Fixed Amount";
                END;

                totalamount := PaymentDetails."Total Charge Amount" + totalamount;
                //"Total Charge Amount" := AppCharRec."Net Amount";
                PaymentDetails.VALIDATE("Total Charge Amount");
                PaymentDetails.MODIFY;
            UNTIL PaymentDetails.NEXT = 0;
    end;


    procedure UpdateProjectType()
    begin
        Project.RESET;
        Project.SETCURRENTKEY("Global Dimension 1 Code");
        Project.SETRANGE("Responsibility Center", "Shortcut Dimension 1 Code");
        IF Project.FINDFIRST THEN
            VALIDATE("Project Type", Project."Default Project Type");
    end;


    procedure InsertMilestone()
    begin
        totalamount := 0;
        OldMileStone := '';
        PaymentTermLines.RESET;
        PaymentTermLines.SETRANGE("Document No.", "Application No.");
        IF PaymentTermLines.FIND('-') THEN
            //IF CONFIRM('Overwrite Milestones?') THEN
            //  PaymentTermLines.DELETEALL
            //ELSE
            //  EXIT;
            ERROR('Please delete the existing Milestone');
        Sno := '001';
        PaymentPlanDetails2.RESET;
        PaymentPlanDetails2.DELETEALL;
        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Payment Plan Code", "Payment Plan");
        PaymentPlanDetails.SETRANGE("Document No.", "Application No.");
        IF PaymentPlanDetails.FINDSET THEN
            REPEAT
                PaymentPlanDetails2.COPY(PaymentPlanDetails);
                totalamount := totalamount + PaymentPlanDetails2."Milestone Charge Amount";
                PaymentPlanDetails2.INSERT;
            UNTIL PaymentPlanDetails.NEXT = 0;

        Applicablecharge.RESET;
        Applicablecharge.SETCURRENTKEY("Document No.", Applicablecharge.Sequence);
        Applicablecharge.SETRANGE("Document No.", "Application No.");
        Applicablecharge.SETRANGE(Applicable, TRUE);
        Applicablecharge.SETFILTER("Net Amount", '<>%1', 0); //ALLEDK 070317
        IF Applicablecharge.FINDSET THEN BEGIN
            MilestoneCodeG := '1';
            PaymentPlanDetails2.RESET;
            PaymentPlanDetails2.SETRANGE("Payment Plan Code", "Payment Plan");
            PaymentPlanDetails2.SETRANGE("Document No.", "Application No.");
            PaymentPlanDetails2.SETRANGE(Checked, FALSE);
            IF PaymentPlanDetails2.FINDSET THEN
                REPEAT
                    IF Type = Type::Normal THEN BEGIN //ALLEDK 241212
                        LoopingAmount := 0;
                        REPEAT
                            IF Applicablecharge."Net Amount" = PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                                CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                                PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                                Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate", PaymentPlanDetails2."Buffer Days for AutoPlot Vacat", PaymentPlanDetails2."Auto Plot Vacate Due Date");  //ALLEDK 040821
                                PaymentPlanDetails2.Checked := TRUE;
                                PaymentPlanDetails2.MODIFY;
                                //Applicablecharge.NEXT;
                                //PaymentPlanDetails2.NEXT;
                                totalamount := totalamount - PaymentPlanDetails2."Milestone Charge Amount";
                                Applicablecharge."Net Amount" := 0;
                                InLoop := TRUE;
                            END;
                            IF Applicablecharge."Net Amount" > PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                                CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                                PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                                Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate", PaymentPlanDetails2."Buffer Days for AutoPlot Vacat", PaymentPlanDetails2."Auto Plot Vacate Due Date");  //ALLEDK 040821);
                                PaymentPlanDetails2.Checked := TRUE;
                                PaymentPlanDetails2.MODIFY;

                                totalamount := totalamount - PaymentPlanDetails2."Milestone Charge Amount";//ALLE PS
                                LoopingAmount := 0;

                                Applicablecharge."Net Amount" := Applicablecharge."Net Amount" -
                                  PaymentPlanDetails2."Milestone Charge Amount";

                                //PaymentPlanDetails2.NEXT;
                                InLoop := TRUE;
                            END ELSE
                                IF (Applicablecharge."Net Amount" < PaymentPlanDetails2."Milestone Charge Amount") AND
                                  (Applicablecharge."Net Amount" <> 0) THEN BEGIN
                                    CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                                    PaymentPlanDetails2."Project Milestone Due Date", Applicablecharge."Net Amount",
                                    Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate", PaymentPlanDetails2."Buffer Days for AutoPlot Vacat", PaymentPlanDetails2."Auto Plot Vacate Due Date");  //ALLEDK 040821);
                                                                                                                                                                                                                                                  //PaymentPlanDetails2.Checked := TRUE;

                                    totalamount := totalamount - Applicablecharge."Net Amount";//ALLE PS
                                    LoopingAmount := PaymentPlanDetails2."Milestone Charge Amount" - Applicablecharge."Net Amount";

                                    PaymentPlanDetails2."Milestone Charge Amount" := PaymentPlanDetails2."Milestone Charge Amount" -
                                    Applicablecharge."Net Amount";
                                    PaymentPlanDetails2.MODIFY;
                                    //Applicablecharge.NEXT;
                                    Applicablecharge."Net Amount" := 0;
                                    //PaymentPlanDetails2.NEXT(-1);

                                    InLoop := TRUE;
                                END;
                            IF Applicablecharge."Net Amount" = 0 THEN BEGIN
                                Applicablecharge.NEXT;
                            END;

                            IF totalamount < 1 THEN
                                totalamount := 0;

                        UNTIL (LoopingAmount = 0) OR (totalamount = 0);
                        //ALLEDK 241212
                    END ELSE BEGIN
                        CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                        PaymentPlanDetails2."Project Milestone Due Date", Applicablecharge."Net Amount",
                        Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate", PaymentPlanDetails2."Buffer Days for AutoPlot Vacat", PaymentPlanDetails2."Auto Plot Vacate Due Date");  //ALLEDK 040821);
                    END;
                    IF totalamount < 1 THEN
                        totalamount := 0;

                //ALLEDK 241212
                UNTIL (PaymentPlanDetails2.NEXT = 0) OR (totalamount = 0);
        END;
    end;


    procedure CreatePaymentTermsLine(MilestoneCode: Code[10]; MilestoneDescription: Text[50]; MilestoneDueDate: Date; Milestoneamt: Decimal; ChargeCode: Code[10]; CommisionApplicable: Boolean; DirectAssociate: Boolean; BufferDaysAutoPlotVacate: DateFormula; AutoPlotVacateDueDate: Date)
    begin
        PaymentTermLines.INIT;
        //PaymentTermLines.COPY(Rec);
        PaymentTermLines."Document No." := "Application No.";
        PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
        PaymentTermLines.Sequence := Sno;
        Sno := INCSTR(Sno);
        PaymentTermLines."Actual Milestone" := MilestoneCode;
        PaymentTermLines."Payment Plan" := PaymentPlanDetails."Payment Plan Code";
        //PaymentTermLines."Due Amount" :=PaymentPlanDetails."Milestone Charge Amount";
        //PaymentTermLine."Broker No." :=SalesHeader."Broker Code";
        //PaymentTermLine."Customer No." :=SalesHeader."Sell-to Customer No.";
        //PaymentTermLine."Salesperson Code" :=SalesHeader."Salesperson Code";
        //Customer.GET(SalesHeader."Customer No.");
        //PaymentTermLine."Related Vendor No." :=Customer."Related Vendor No.";
        PaymentTermLines.Description := MilestoneDescription;
        PaymentTermLines."Due Date" := MilestoneDueDate;
        PaymentTermLines."Project Code" := "Shortcut Dimension 1 Code";
        PaymentTermLines."Calculation Type" := PaymentTermLines."Calculation Type"::"% age";
        PaymentTermLines."Criteria Value / Base Amount" := Milestoneamt;
        PaymentTermLines."Calculation Value" := 100;
        PaymentTermLines."Due Amount" := ROUND(Milestoneamt, 0.01, '=');
        PaymentTermLines."Charge Code" := ChargeCode;
        PaymentTermLines."Commision Applicable" := CommisionApplicable;
        PaymentTermLines."Direct Associate" := DirectAssociate;
        PaymentTermLines."Buffer Days for AutoPlot Vacat" := BufferDaysAutoPlotVacate; //ALLEDK 040821
        PaymentTermLines."Auto Plot Vacate Due Date" := AutoPlotVacateDueDate; //ALLEDK 040821
        PaymentTermLines.INSERT(TRUE);
    end;


    procedure CalculateMinAllotAmt(Unit: Record "Unit Master"): Decimal
    var
        MembershipFee: Decimal;
    begin
        MembershipFee := 0;
        Project.GET("Shortcut Dimension 1 Code");
        Project.TESTFIELD(Project."Min. Allotment Amount");
        Project.TESTFIELD(Project."Min. Allotment Area");
        Unit.TESTFIELD("Saleable Area");
        IF Unit."Saleable Area" < Project."Min. Allotment Area" THEN
            EXIT(Project."Min. Allotment Amount")
        ELSE BEGIN
            MembershipFee := CalculateMemberFee(Unit);
            EXIT((Project."Min. Allotment Amount" - MembershipFee) / Project."Min. Allotment Area" * Unit."Saleable Area");
        END;
    end;


    procedure CalculateMemberFee(Unit: Record "Unit Master"): Decimal
    var
        TotalCost: Decimal;
    begin
        TotalCost := 0;
        AppCharges.RESET;
        AppCharges.SETCURRENTKEY("Document No.", Applicable, "Membership Fee");
        AppCharges.SETRANGE("Document No.", "Application No.");
        AppCharges.SETRANGE(AppCharges.Applicable, TRUE);
        AppCharges.SETRANGE(AppCharges."Membership Fee", TRUE);
        IF AppCharges.FINDSET THEN BEGIN
            AppCharges.CALCSUMS(AppCharges."Net Amount");
            TotalCost := AppCharges."Net Amount";
        END;
        EXIT(TotalCost);
    end;


    procedure AmountRecdAppl(ApplicationNo: Code[20]): Decimal
    var
        RecdAmount: Decimal;
        ApplicationRec: Record Application;
    begin
        ApplicationRec.GET("Application No.");
        BondPmtLine.RESET;
        BondPmtLine.SETRANGE(BondPmtLine."Document No.", ApplicationRec."Application No.");
        IF BondPmtLine.FINDSET THEN
            REPEAT
                IF BondPmtLine."Payment Mode" = BondPmtLine."Payment Mode"::Cash THEN
                    RecdAmount := RecdAmount + BondPmtLine.Amount;

                IF BondPmtLine."Payment Mode" = BondPmtLine."Payment Mode"::AJVM THEN
                    RecdAmount := RecdAmount + BondPmtLine.Amount;


                IF BondPmtLine."Payment Mode" = BondPmtLine."Payment Mode"::"Refund Cash" THEN
                    RecdAmount := RecdAmount + BondPmtLine.Amount;

                IF ((BondPmtLine."Payment Mode" = BondPmtLine."Payment Mode"::Bank) AND
                   (BondPmtLine."Cheque Status" = BondPmtLine."Cheque Status"::Cleared)) THEN
                    RecdAmount := RecdAmount + BondPmtLine.Amount;
                IF (BondPmtLine."Payment Mode" = BondPmtLine."Payment Mode"::"D.D.") THEN
                    RecdAmount := RecdAmount + BondPmtLine.Amount;
            UNTIL BondPmtLine.NEXT = 0;
        EXIT(RecdAmount);
    end;


    procedure "-------new functions..."()
    begin
    end;


    procedure ReleaseRcpt(var RecApplication: Record Application)
    var
        AppPayEntry: Record "Application Payment Entry";
    begin
        PLDetails.RESET;
        PLDetails.SETRANGE("Document No.", RecApplication."Application No.");
        IF NOT PLDetails.FINDFIRST THEN
            ERROR('Please define the Payment Plan Detail for Project' + RecApplication."Shortcut Dimension 1 Code");
        PTSLine.RESET;
        PTSLine.SETRANGE("Document No.", RecApplication."Application No.");
        IF NOT PTSLine.FINDFIRST THEN
            ERROR('Please define the Payment Milestone');

        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document No.", RecApplication."Application No.");
        AppPayEntry.SETRANGE(Posted, FALSE);
        AppPayEntry.SETRANGE(Amount, 0);
        IF AppPayEntry.FINDFIRST THEN
            AppPayEntry.DELETE;

        RecApplication.TESTFIELD(Status, RecApplication.Status::Open);
        BondSetup.GET;
        RecApplication.TESTFIELD(RecApplication."Payment Plan");
        IF RecApplication."Customer No." = '' THEN
            RecApplication.VALIDATE("Customer No.", CreateCustomer("Customer Name"));
        IF CheckExcessAmount1(RecApplication) THEN BEGIN
            CreateExcessPaymentTermsLine1(RecApplication);
        END;

        CreatUPEntryfromApplication.CreateUPEntryfromApplication(RecApplication); //200113
        ReleaseBondApplication.ReleaseApplication(RecApplication, TRUE);
    end;


    procedure CreateExcessPaymentTermsLine1(NewRecApplication: Record Application)
    var
        PaymentTermLines: Record "Payment Terms Line Sale";
        PaymentTermLines1: Record "Payment Terms Line Sale";
        UnitCharge: Record "Unit Charge & Payment Pl. Code";
        ExcessCode: Code[10];
    begin
        UnitCharge.RESET;
        UnitCharge.SETRANGE(ExcessCode, TRUE);
        IF UnitCharge.FINDFIRST THEN
            ExcessCode := UnitCharge.Code
        ELSE
            ERROR('Excess Code setup does not exist');
        PaymentTermLines1.RESET;
        PaymentTermLines1.SETRANGE("Document No.", NewRecApplication."Application No.");
        IF PaymentTermLines1.FINDLAST THEN BEGIN
            IF PaymentTermLines1."Charge Code" <> ExcessCode THEN BEGIN
                PaymentTermLines.INIT;
                PaymentTermLines."Document Type" := PaymentTermLines1."Document Type";
                PaymentTermLines."Document No." := NewRecApplication."Application No.";
                PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
                PaymentTermLines.Sequence := INCSTR(PaymentTermLines1.Sequence); //ALLETDK231112
                PaymentTermLines."Actual Milestone" := PaymentTermLines1."Actual Milestone";
                PaymentTermLines."Payment Plan" := PaymentTermLines1."Payment Plan";
                PaymentTermLines.Description := 'Excess Payment';
                PaymentTermLines."Due Date" := PaymentTermLines1."Due Date";
                PaymentTermLines."Project Code" := NewRecApplication."Shortcut Dimension 1 Code";
                PaymentTermLines."Calculation Type" := PaymentTermLines."Calculation Type"::"% age";
                PaymentTermLines."Criteria Value / Base Amount" := ExcessAmount;
                PaymentTermLines."Calculation Value" := 100;
                PaymentTermLines."Due Amount" := ROUND(ExcessAmount, 0.01, '=');
                PaymentTermLines."Charge Code" := ExcessCode;
                PaymentTermLines."Commision Applicable" := FALSE;
                PaymentTermLines."Direct Associate" := FALSE;
                PaymentTermLines.INSERT(TRUE);
            END;
        END;
    end;


    procedure CreateConOrder(RecApplication: Record Application)
    var
        RespCenter: Record "Responsibility Center";
        Region_RankwiseVendor: Record "Region wise Vendor";
        Bond: Record "Confirmed Order";
        PaymentLine: Record "Unit Payment Entry";
        BondCreationBuffer: Record "Unit & Comm. Creation Buffer";
        ConfOrder: Record "Confirmed Order";
        RecJob: Record Job;
        AssHierwithApp_1: Record "Associate Hierarcy with App.";
        Vendor_3: Record Vendor;
        UnitPostCu: Codeunit "Unit Post";   //Code added 06102025 
        AssociateHierarcywithApp: Record "Associate Hierarcy with App.";
        UnitSetup: Record "unit setup";

    begin
        //RecApplication.TESTFIELD(Status,RecApplication.Status::Released);

        IF NOT Bond.GET(RecApplication."Application No.") THEN BEGIN
            IF RecApplication.Type = RecApplication.Type::Normal THEN BEGIN  //230213
                UnitandCommCreationJob.UpdateMilestonePercentage(RecApplication."Application No.", TRUE);
                CreatUPEntryfromApplication.CreateUPEntryfromApplicationCash(RecApplication); //220920
                PaymentLine.RESET;
                PaymentLine.SETRANGE("Application No.", RecApplication."Application No.");
                PaymentLine.SETRANGE("Commision Applicable", TRUE);
                IF PaymentLine.FINDSET THEN
                    REPEAT
                        IF NOT BondCreationBuffer.GET(RecApplication."Application No.", (PaymentLine."Line No." / 10000), PaymentLine.Sequence) THEN
                            PostPayment.CreateStagingTableBondPayEntry(PaymentLine, (PaymentLine."Line No." / 10000), 1, PaymentLine.Sequence,
                            PaymentLine."Commision Applicable", PaymentLine."Direct Associate", FALSE);
                    UNTIL PaymentLine.NEXT = 0;
                PaymentLine.RESET;
                PaymentLine.SETRANGE("Application No.", RecApplication."Application No.");
                PaymentLine.SETRANGE("Direct Associate", TRUE);
                IF PaymentLine.FINDSET THEN
                    REPEAT
                        IF NOT BondCreationBuffer.GET(RecApplication."Application No.", (PaymentLine."Line No." / 10000), PaymentLine.Sequence) THEN
                            PostPayment.CreateStagingTableBondPayEntry(PaymentLine, (PaymentLine."Line No." / 10000), 1, PaymentLine.Sequence,
                            PaymentLine."Commision Applicable", PaymentLine."Direct Associate", FALSE);
                    UNTIL PaymentLine.NEXT = 0;


            END;
            //230213
            AppLication2 := RecApplication;
            CreateConfirmedOrder.CreateBondfromApplication(RecApplication);
            IF ConfOrder.GET(AppLication2."Application No.") THEN BEGIN

                IF RecJob.GET(ConfOrder."Shortcut Dimension 1 Code") THEN BEGIN
                    Region_RankwiseVendor.RESET;
                    Vendor_3.RESET;
                    IF Vendor_3.GET(ConfOrder."Introducer Code") THEN
                        IF Vendor_3."BBG Vendor Category" = Vendor_3."BBG Vendor Category"::"CP(Channel Partner)" THEN
                            Region_RankwiseVendor.SETRANGE("Region Code", Vendor_3."Sub Vendor Category")  //02062025 Code added
                                                                                                           //Region_RankwiseVendor.SETRANGE("Region Code", 'R0003')  //02062025 Code Commented
                        ELSE
                            Region_RankwiseVendor.SETRANGE("Region Code", ConfOrder."Region Code"); //Code added 01072025
                                                                                                    //Region_RankwiseVendor.SETRANGE("Region Code", RecJob."Region Code for Rank Hierarcy");  //need to update code 050924   //Code commented 01072025
                    Region_RankwiseVendor.SETRANGE("No.", ConfOrder."Introducer Code");
                    IF Region_RankwiseVendor.FINDFIRST THEN BEGIN
                        AssHierwithApp_1.RESET;
                        AssHierwithApp_1.SETRANGE("Application Code", AppLication2."Application No.");
                        IF AssHierwithApp_1.FINDSET THEN
                            REPEAT
                                AssHierwithApp_1.Status := AssHierwithApp_1.Status::"In-Active";
                                AssHierwithApp_1.MODIFY;
                            UNTIL AssHierwithApp_1.NEXT = 0;

                        //Code added start 06102025 

                        //unitpost.NewInsertTeamHierarcy(ConfOrder, Region_RankwiseVendor."Region Code", FALSE, FALSE);  //271114 DK01  //06102025 code comment 
                        IF ConfOrder."Region Code" <> '' then
                            unitpost.NewInsertTeamHierarcy(ConfOrder, ConfOrder."Region Code", FALSE, FALSE)
                        else
                            unitpost.NewInsertTeamHierarcy(ConfOrder, Region_RankwiseVendor."Region Code", FALSE, FALSE);

                        UnitSetup.GET;
                        AssociateHierarcywithApp.RESET;
                        AssociateHierarcywithApp.SETCURRENTKEY("Rank Code", "Application Code");
                        AssociateHierarcywithApp.SETRANGE("Application Code", ConfOrder."No.");
                        AssociateHierarcywithApp.SETRANGE(Status, AssociateHierarcywithApp.Status::Active);
                        IF AssociateHierarcywithApp.FINDSET THEN
                            REPEAT
                                IF AssociateHierarcywithApp."Rank Code" <= UnitSetup."Hierarchy Head" THEN BEGIN
                                    UnitPostCu.CalculateCommissionAmount(ConfOrder, AssociateHierarcywithApp, 0, False, False)
                                END;
                            Until AssociateHierarcywithApp.Next = 0;

                        //Code added END 06102025 

                    END;
                END;
                //      RecApplication.DELETE;
            END;
        END;
    end;


    procedure CheckExcessAmount1(ApplicationOrder: Record Application): Boolean
    var
        RecDueAmount: Decimal;
        ApplPayEntry: Record "Application Payment Entry";
        CurrPayAmount: Decimal;
    begin
        CLEAR(RecDueAmount);
        CLEAR(ExcessAmount);
        CLEAR(CurrPayAmount);
        RecDueAmount := ApplicationOrder."Investment Amount" + ApplicationOrder."Service Charge Amount" -
        ApplicationOrder."Discount Amount" - ApplicationOrder."Total Received Amount";
        IF RecDueAmount > 0 THEN BEGIN
            ApplPayEntry.RESET;
            ApplPayEntry.SETRANGE("Document Type", ApplPayEntry."Document Type"::Application);
            ApplPayEntry.SETRANGE("Document No.", ApplicationOrder."Application No.");
            ApplPayEntry.SETRANGE("Explode BOM", FALSE);
            IF ApplPayEntry.FINDSET THEN
                REPEAT
                    CurrPayAmount += ApplPayEntry.Amount;
                UNTIL ApplPayEntry.NEXT = 0;
            IF RecDueAmount < CurrPayAmount THEN
                ExcessAmount := CurrPayAmount - RecDueAmount;
            IF ExcessAmount > 0 THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END;
    end;
}

