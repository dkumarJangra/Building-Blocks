tableextension 97000 "EPC Vendor Ext" extends Vendor
{
    fields
    {
        // Add changes to table fields here
        field(90033; "BBG Date of Joining"; Date)
        {
            Caption = 'Date of Joining';
            DataClassification = ToBeClassified;
            Editable = true;

            trigger OnValidate()
            begin
                /*
                IF xRec."Date of Joining" <> 0D THEN BEGIN
                  Memberof.RESET;
                  Memberof.SETRANGE("User ID",USERID);
                  Memberof.SETRANGE("Role ID",'JOINDATE');
                  IF NOT Memberof.FINDFIRST THEN
                    ERROR('You are not authorised to change the Date');
                END;
                */

            end;
        }
        field(50107; "BBG Top Associate for Gamification"; Boolean)
        {
            Caption = 'Top Associate for Gamification';
            DataClassification = ToBeClassified;
        }
        field(50018; "BBG Creation Date"; Date)
        {
            Caption = 'Creation Date';
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 040712';
            Editable = false;
        }
        field(50026; "BBG Salary Applicable"; Boolean)
        {
            Caption = 'Salary Applicable';
            DataClassification = ToBeClassified;
            Description = 'ALLE BBG1.00';
        }
        field(50101; "BBG Print Associate Name/Mobile"; Boolean)
        {
            Caption = 'Print Associate Name/Mobile';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Vendor_1: Record Vendor;
            begin
                RecCompwiseAcc.RESET;
                RecCompwiseAcc.SETRANGE("MSC Company", TRUE);
                IF RecCompwiseAcc.FINDFIRST THEN BEGIN
                    IF RecCompwiseAcc."Company Code" <> COMPANYNAME THEN
                        ERROR('This process will be done from MSC');
                END;
            end;
        }
        field(50103; "BBG Cluster Type"; Option)
        {
            Caption = 'Cluster Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Hyderabad,Vizag,Vijaywada,Shadnagar,Yadagiri Gutta,Nellore,Srikakulam';
            OptionMembers = " ",Hyderabad,Vizag,Vijaywada,Shadnagar,"Yadagiri Gutta",Nellore,Srikakulam;
        }
        field(50001; "BBG Net Change - Advance (LCY)"; Decimal)
        {
            Caption = 'Net Change - Advance (LCY)';
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Advance)));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; "BBG Net Change - Running (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Running)));
            Caption = 'Net Change - Running (LCY)';
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50003; "BBG Net Change - Retention (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Retention)));
            Caption = 'Net Change - Retention (LCY)';
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004; "BBG Net Change - Secured Adv (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER("Secured Advance")));
            Caption = 'Net Change - Secured Adv (LCY)';
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50005; "Net Change - Adhoc Adv (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER("Adhoc Advance")));
            Caption = 'Net Change - Adhoc Adv (LCY)';
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50006; "BBG Net Change - Provisional (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Provisional)));
            Caption = 'Net Change - Provisional (LCY)';
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50011; "BBG Net Change - LD (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Net Change - LD (LCY)';
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(LD)));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50020; "BBG Net Change - Commision"; Decimal)
        {
            Caption = 'Net Change - Commision';
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Commission)));
            Description = 'ALLEPG 310812';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50021; "BBG Net Change - Travel Allow."; Decimal)
        {
            Caption = 'Net Change - Travel Allow.';
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER("Travel Allowance")));
            Description = 'ALLEPG 310812';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50023; "BBG Net Change - Bonanza"; Decimal)
        {
            Caption = 'Net Change - Bonanza';
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Bonanza)));
            Description = 'ALLEPG 310812';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50024; "BBG Net Change - Incentive"; Decimal)
        {
            Caption = 'Net Change - Incentive';
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Posting Date" = FIELD("Date Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter"),
                                                                                  "Posting Type" = FILTER(Incentive)));
            Description = 'ALLEPG 191012';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50009; "BBG Phone No. 2"; Text[30])
        {
            Caption = 'Phone No. 2';
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(60006; "BBG Temp Address"; Text[50])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;
            Description = 'BBG2.11 230714';
        }
        field(60007; "BBG Temp Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;
            Description = 'BBG2.11 230714';
        }
        field(60008; "BBG Temp Address 3"; Text[30])
        {
            Caption = 'Temp Address 3';
            DataClassification = ToBeClassified;
            Description = 'BBG2.11 230714';
        }
        field(60009; "BBG Temp Mob. No."; Text[30])
        {
            Caption = 'Temp Mob. No.';
            DataClassification = ToBeClassified;
            Description = 'BBG2.11 230714';
        }
        field(50104; "BBG Alternate Name"; Text[60])
        {
            Caption = 'Alternate Name';
            DataClassification = ToBeClassified;
        }
        field(50102; "BBG Credit Limit"; Decimal)
        {
            Caption = 'Credit Limit';
            DataClassification = ToBeClassified;
        }
        field(50105; "BBG Web Associate Payment Active"; Boolean)
        {
            Caption = 'Web Associate Payment Active';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                Memberof.RESET;
                Memberof.SETRANGE("User Name", USERID);
                Memberof.SETRANGE(Memberof."Role ID", 'WebVenPayment');
                IF NOT Memberof.FINDFIRST THEN
                    ERROR('Please contact admin');
            end;
        }
        field(50030; "BBG TA Applicable on Associate"; Boolean)
        {
            Caption = 'TA Applicable on Associate';
            DataClassification = ToBeClassified;
            Description = 'BBG1.2 201213';
        }
        field(90030; "BBG Status"; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = ' ,Provisional,Active,Inactive';
            OptionMembers = " ",Provisional,Active,Inactive;

            trigger OnValidate()
            begin
                IF "BBG Status" = "BBG Status"::Active THEN BEGIN
                    "BBG In-Active Associate" := FALSE;
                    MODIFY;
                END;
            end;
        }
        field(50012; "BBG Vendor Category"; Option)
        {
            Caption = 'Vendor Category';
            DataClassification = ToBeClassified;
            Description = '--JPL';
            OptionCaption = ' ,Supplier,Consultant,Sub-Contractor,Transporter,Other Vendor,IBA(Associates),Land Owners,Contractor,Land Vendor,CP(Channel Partner)';
            OptionMembers = " ",Supplier,Consultant,"Sub-Contractor",Transporter,"Other Vendor","IBA(Associates)","Land Owners",Contractor,"Land Vendor","CP(Channel Partner)";

            trigger OnValidate()
            begin
                IF "BBG Vendor Category" = "BBG Vendor Category"::"IBA(Associates)" THEN BEGIN
                    CompanywiseAccount.RESET;
                    CompanywiseAccount.SETRANGE(CompanywiseAccount."MSC Company", TRUE);
                    IF CompanywiseAccount.FINDFIRST THEN BEGIN
                        IF COMPANYNAME <> CompanywiseAccount."Company Code" THEN
                            ERROR('Create Vendor from Master Company');
                    END;
                END;

                IF "BBG Vendor Category" = "BBG Vendor Category"::"Land Vendor" THEN
                    "BBG Land Master" := TRUE
                ELSE
                    "BBG Land Master" := FALSE;
            end;
        }
        field(50081; "BBG Land Master"; Boolean)
        {
            Caption = 'Land Master';
            DataClassification = ToBeClassified;
            Description = 'BBG2.0';
        }
        field(50017; "BBG Balance at Date (LCY)"; Decimal)
        {
            Caption = 'Balance at Date (LCY)';
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                  "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                  "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                  "Currency Code" = FIELD("Currency Filter")));
            Description = 'dds-added as Balance LCY fld is in reverse sign';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90029; "BBG Rank Code"; Decimal)
        {
            Caption = 'Rank Code';
            DataClassification = ToBeClassified;
            TableRelation = Rank;

            trigger OnValidate()
            var
                Rank: Record Rank;
            begin
                IF "BBG Status" IN [1, 2] THEN
                    IF Rank.GET("BBG Rank Code") THEN
                        Rank.TESTFIELD("Direct Entry", TRUE);

                IF "BBG Parent Code" = "No." THEN
                    ERROR(Text015);
                IF "BBG Parent Code" <> '' THEN
                    IF Vendor.GET("BBG Parent Code") THEN BEGIN
                        Vendor.TESTFIELD("BBG Rank Code");
                        IF Rec."BBG Rank Code" >= Vendor."BBG Rank Code" THEN
                            ERROR('Rank cannot be greater or equal with parent.');
                    END;
            end;
        }
        field(90060; "BBG Old No."; Code[10])
        {
            Caption = 'Old No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "BBG Old No." <> '' THEN BEGIN
                    RecVendor.RESET;
                    RecVendor.SETRANGE("BBG Old No.", "BBG Old No.");
                    IF RecVendor.FINDFIRST THEN
                        ERROR('Vendor No. already Exists');
                END;
            end;
        }
        field(50304; "BBG Team Code"; Code[50])
        {
            Caption = 'Team Code';
            DataClassification = ToBeClassified;
            TableRelation = "Team Master";
        }
        field(50100; "BBG Black List"; Boolean)
        {
            Caption = 'Black List';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Vendor_2: Record Vendor;
            begin
                Memberof.RESET;
                Memberof.SETRANGE(Memberof."User Name", USERID);
                Memberof.SETRANGE(Memberof."Role ID", 'BlackList');
                IF NOT Memberof.FINDFIRST THEN
                    ERROR('Please contact admin department');

                RecCompwiseAcc.RESET;
                RecCompwiseAcc.SETFILTER("Company Code", '<>%1', COMPANYNAME);
                IF RecCompwiseAcc.FINDSET THEN BEGIN
                    REPEAT
                        Vendor_2.RESET;
                        Vendor_2.CHANGECOMPANY(RecCompwiseAcc."Company Code");
                        IF Vendor_2.GET("No.") THEN BEGIN
                            Vendor_2."BBG Black List" := "BBG Black List";
                            Vendor_2.MODIFY;
                        END;
                    UNTIL RecCompwiseAcc.NEXT = 0;
                END;
            end;
        }
        field(90049; "BBG Hold Payables"; Boolean)
        {
            Caption = 'Hold Payables';
            DataClassification = ToBeClassified;
        }
        field(90019; "BBG BHEL"; Boolean)
        {
            Caption = 'BHEL';
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(90064; "BBG Commission Amount Qualified"; Decimal)
        {
            Caption = 'Commission Amount Qualified';
            CalcFormula = Sum("Commission Entry"."Commission Amount" WHERE("Associate Code" = FIELD("No."),
                                                                            "Voucher No." = FILTER('')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90065; "BBG Travel Amount Qualified"; Decimal)
        {
            Caption = 'Travel Amount Qualified';
            CalcFormula = Sum("Travel Payment Entry"."Amount to Pay" WHERE("Sub Associate Code" = FIELD("No."),
                                                                            "Voucher No." = FILTER('')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90066; "BBG Incentive Amount Qualified"; Decimal)
        {
            Caption = 'Incentive Amount Qualified';
            CalcFormula = Sum("Incentive Summary"."Payable Incentive Amount" WHERE("Associate Code" = FIELD("No."),
                                                                                    "Voucher No." = FILTER('')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90025; "BBG Broker %"; Decimal)
        {
            Caption = 'Broker %';
            DataClassification = ToBeClassified;
            Description = 'ALLRE';
        }
        field(90026; "BBG Validity till date"; Date)
        {
            Caption = 'Validity till date';
            DataClassification = ToBeClassified;
            Description = 'ALLERP KRN0014 19-08-2010:';

            trigger OnValidate()
            begin
                //ALLERP KRN0014 Start:
                ProductVendor.RESET;
                ProductVendor.SETRANGE("Vendor No.", "No.");
                IF ProductVendor.FINDSET(TRUE, FALSE) THEN
                    REPEAT
                        ProductVendor."Expiry Date" := "BBG Validity till date";
                        ProductVendor.MODIFY;
                    UNTIL ProductVendor.NEXT = 0;
                //ALLERP KRN0014 End:
            end;
        }
        field(90027; "BBG Authorized Agent of"; Code[20])
        {
            Caption = 'Authorized Agent of';
            DataClassification = ToBeClassified;
            Description = 'ALLE PS Added field for Agent';
            TableRelation = Vendor;
        }
        field(90028; "BBG Parent Code"; Code[20])
        {
            Caption = 'Parent Code';
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            var
                recRank: Record "Job Master";
            begin
                TESTFIELD("BBG Rank Code");
                IF "BBG Parent Code" = "No." THEN
                    ERROR(Text012);
                IF "BBG Parent Code" <> '' THEN
                    IF Vendor.GET("BBG Parent Code") THEN BEGIN
                        IF Vendor."BBG Status" = Vendor."BBG Status"::Inactive THEN
                            ERROR(Text013, Vendor."No.");
                        Vendor.TESTFIELD("BBG Rank Code");
                        IF "BBG Rank Code" >= Vendor."BBG Rank Code" THEN
                            ERROR(Text014);
                        "BBG Parent Rank" := Vendor."BBG Rank Code";
                        IF "BBG Introducer" = '' THEN
                            "BBG Introducer" := "BBG Parent Code";  //ALLEDK 040113
                        "BBG Old Parent Code" := Vendor."BBG Old No.";
                    END;



                IF "BBG Parent Code" = '' THEN
                    "BBG Parent Rank" := 0;
            end;
        }


        field(90031; "BBG Guardian Name"; Text[50])
        {
            Caption = 'Guardian Name';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "BBG Guardian Name" := UPPERCASE("BBG Guardian Name");
            end;
        }
        field(90032; "BBG Date of Birth"; Date)
        {
            Caption = 'Date of Birth';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF "BBG Date of Birth" > TODAY THEN  //Alledk 100821
                    ERROR('Date Of Birth can not be greater than Today');  //Alledk 100821

                /*IF "Date of Birth" = 0D THEN
                 Age := 0
                ELSE
                 BEGIN
                  Age :=ROUND(((TODAY-"Date of Birth")/365),1) ;
                  MODIFY;
                 END;
                */

            end;
        }

        field(90034; "BBG Sex"; Option)
        {
            Caption = 'Sex';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Male,Female';
            OptionMembers = " ",Male,Female;
        }
        field(90035; "BBG Marital Status"; Option)
        {
            Caption = 'Marital Status';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Unmarried,Married,Divorced,Widow,Widower,Unknown';
            OptionMembers = " ",Unmarried,Married,Divorced,Widow,Widower,Unknown;
        }
        field(90036; "BBG Present Occupation"; Text[50])
        {
            Caption = 'Present Occupation';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "BBG Present Occupation" := UPPERCASE("BBG Present Occupation");
                CASE "BBG Present Occupation" OF
                    'B':
                        VALIDATE("BBG Present Occupation", 'BUSINESS');
                    'S':
                        VALIDATE("BBG Present Occupation", 'SERVICE');
                    'H':
                        VALIDATE("BBG Present Occupation", 'HOUSEWIFE');
                    'C':
                        VALIDATE("BBG Present Occupation", 'CULTIVATION');
                    'ST':
                        VALIDATE("BBG Present Occupation", 'STUDENT');
                    'P':
                        VALIDATE("BBG Present Occupation", 'PROFESSIONAL');
                    'N':
                        VALIDATE("BBG Present Occupation", 'NIL');
                    'O':
                        VALIDATE("BBg Present Occupation", 'OTHER');
                END;
                "BBG Present Occupation" := UPPERCASE("BBG Present Occupation");
            end;
        }
        field(90037; "BBG Nationality"; Text[30])
        {
            Caption = 'Nationality';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "BBG Nationality" := UPPERCASE("BBG Nationality");
            end;
        }
        field(90038; "BBG Nominee Name"; Text[50])
        {
            Caption = 'Nominee Name';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "BBG Nominee Name" := UPPERCASE("BBG Nominee Name");
            end;
        }
        field(90039; "BBG Nominee Address"; Text[50])
        {
            Caption = 'Address';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CASE "BBG Nominee Address" OF
                    'A':
                        VALIDATE("BBG Nominee Address", 'AS ABOVE');
                END;
                "BBG Nominee Address" := UPPERCASE("BBG Nominee Address");
            end;
        }
        field(90040; "BBG Nominee Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "BBG Nominee Address 2" := UPPERCASE("BBG Nominee Address 2");
            end;
        }
        field(90041; "BBG Nominee District"; Text[30])
        {
            Caption = 'District';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "BBG Nominee District" := UPPERCASE("BBG Nominee District");
            end;
        }
        field(90042; "BBG Nominee Title"; Option)
        {
            Caption = 'Nominee Title';
            DataClassification = ToBeClassified;
            OptionCaption = 'Mr.,Mrs,Miss';
            OptionMembers = "Mr.",Mrs,Miss;
        }
        field(90043; "BBG Nominee Pin"; Code[6])
        {
            Caption = 'Nominee Pin';
            DataClassification = ToBeClassified;
        }
        field(90044; "BBG Nominee State"; Code[20])
        {
            Caption = 'Nominee State';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "BBG Nominee State" := UPPERCASE("BBG Nominee State");
                CASE "BBG Nominee State" OF
                    'W':
                        VALIDATE("BBG Nominee State", 'WESTBENGAL');
                    'A':
                        VALIDATE("BBG Nominee State", 'ASSAM');
                    'O':
                        VALIDATE("BBG Nominee State", 'ORISSA');
                    'B':
                        VALIDATE("BBG Nominee State", 'BIHAR');
                    'J':
                        VALIDATE("BBG Nominee State", 'JHARKHAND');
                    'U':
                        VALIDATE("BBG Nominee State", 'UTTARPRADESH');
                END;
                "BBG Nominee State" := UPPERCASE("BBG Nominee State");
            end;
        }
        field(90045; "BBG Nominee Age"; Integer)
        {
            Caption = 'Nominee Age';
            DataClassification = ToBeClassified;
            MaxValue = 99;
            MinValue = 1;
        }
        field(90046; "BBG Relation"; Text[30])
        {
            Caption = 'Relation';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "BBG Relation" := UPPERCASE("BBG Relation");
                CASE "BBG Relation" OF
                    'F':
                        VALIDATE("BBG Relation", 'FATHER');
                    'M':
                        VALIDATE("BBG Relation", 'MOTHER');
                    'H':
                        VALIDATE("BBG Relation", 'HUSBAND');
                    'W':
                        VALIDATE("BBG Relation", 'WIFE');
                    'U':
                        VALIDATE("BBG Relation", 'UNCLE');
                    'A':
                        VALIDATE("BBG Relation", 'AUNT');
                    'B':
                        VALIDATE("BBG Relation", 'BROTHER');
                    'S':
                        VALIDATE("BBG Relation", 'SON');
                    'D':
                        VALIDATE("BBG Relation", 'DAUGHTER');
                    'SI':
                        VALIDATE("BBG Relation", 'SISTER');
                    'G':
                        VALIDATE("BBG Relation", 'GRANDSON');
                    'N':
                        VALIDATE("BBG Relation", 'NEPHEW');
                    'NI':
                        VALIDATE("BBG Relation", 'NIECE');
                    'O':
                        VALIDATE("BBG Relation", 'OTHER');
                END;
                "BBG Relation" := UPPERCASE("BBG Relation");
            end;
        }
        field(90047; "BBG Nominee Sex"; Option)
        {
            Caption = 'Nominee Sex';
            DataClassification = ToBeClassified;
            OptionMembers = Male,Female;
        }
        field(90048; "BBG Suspended"; Boolean)
        {
            Caption = 'Suspended';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90050; "BBG No. of Joinings"; Integer)
        {
            Caption = 'No. of Joinings';
            CalcFormula = Count(Vendor WHERE("BBG Parent Code" = FIELD("No."),
                                              "BBG Date of Joining" = FIELD("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90051; "BBG Self Business Amount"; Decimal)
        {
            Caption = 'Self Business Amount';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90052; "BBG Commission Voucher Generated"; Boolean)
        {
            Caption = 'Commission Voucher Generated';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90053; "BBG Bonus Not Allowed"; Boolean)
        {
            Caption = 'Bonus Not Allowed';
            DataClassification = ToBeClassified;
        }
        field(90054; "BBG Parent Rank"; Decimal)
        {
            Caption = 'Parent Rank';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = Rank;

            trigger OnValidate()
            var
                recRank: Record "Job Master";
            begin
            end;
        }
        field(90055; "BBG Eligibility Rate"; Decimal)
        {
            Caption = 'Eligibility Rate';
            DataClassification = ToBeClassified;
        }
        field(90056; "BBG Eligibility Amount"; Decimal)
        {
            Caption = 'Eligibility Amount';
            DataClassification = ToBeClassified;
        }
        field(90057; "BBG Total Allocated"; Decimal)
        {
            Caption = 'Total Allocated';
            DataClassification = ToBeClassified;
        }
        field(90058; "BBG Balance to Allocate"; Decimal)
        {
            Caption = 'Balance to Allocate';
            DataClassification = ToBeClassified;
        }
        field(90059; "BBG Associate Level"; Integer)
        {
            Caption = 'Associate Level';
            DataClassification = ToBeClassified;
        }

        field(90061; "BBG Associate Creation"; Option)
        {
            Caption = 'Associate Creation';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Existing,New';
            OptionMembers = " ",Existing,New;
        }
        field(90062; "BBG Introducer"; Code[20])
        {
            Caption = 'Introducer';
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(90063; "BBG Old Parent Code"; Code[10])
        {
            Caption = 'Old Parent Code';
            DataClassification = ToBeClassified;
        }



        field(90067; "BBG Total Balance Amount"; Decimal)
        {
            Caption = 'Total Balance Amount';
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(90068; "BBG Old Introducer"; Code[10])
        {
            Caption = 'Old Introducer';
            DataClassification = ToBeClassified;
        }
        field(90069; "BBG Designation"; Text[30])
        {
            Caption = 'Designation';
            Description = 'ALLECK 040413';
        }
        field(90072; "BBG Version"; Integer)
        {
            Caption = 'Version';
            CalcFormula = Max("Archive Vendor".Version WHERE("No." = FIELD("No.")));
            Description = 'ALLECK 190413';
            FieldClass = FlowField;
        }
        field(90074; "BBG Archived"; Boolean)
        {
            Caption = 'Archived';
            DataClassification = ToBeClassified;
            Description = 'ALLECK 190413';
        }
        field(90075; "BBG Remarks"; Text[60])
        {
            Caption = 'Remarks';
            DataClassification = ToBeClassified;
            Description = 'ALLECK 200413';
        }
        field(90076; "BBG Message for Ass. Creation"; Boolean)
        {
            Caption = 'Message for Ass. Creation';
            DataClassification = ToBeClassified;
            Description = 'BBG1.00 250613';
            Editable = false;
        }
        field(90077; "BBG GTA"; Boolean)
        {
            Caption = 'GTA';
            DataClassification = ToBeClassified;
            Description = 'test';
        }
        field(90078; "BBG Old Nav Vend No."; Code[20])
        {
            Caption = 'Old Nav Vend No.';
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(90079; "BBG Copy IBA in Company"; Text[30])
        {
            Caption = 'Copy IBA in Company';
            DataClassification = ToBeClassified;
            TableRelation = Company;
        }
        field(90080; "BBG vendor not find"; Boolean)
        {
            Caption = 'vendor not find';
            DataClassification = ToBeClassified;
        }
        field(90081; "BBG Rank lookup Mode"; Code[1])
        {
            Caption = 'Rank lookup Mode';
            DataClassification = ToBeClassified;
            TableRelation = "Region wise Vendor" WHERE("No." = FIELD("No."));
        }
        field(90082; "BBG Comm Amount"; Decimal)
        {
            Caption = 'Comm Amount';
            DataClassification = ToBeClassified;
        }
        field(90083; "BBG RemComm Amt"; Decimal)
        {
            Caption = 'RemComm Amt';
            DataClassification = ToBeClassified;
        }
        field(90084; "BBG TA Amount"; Decimal)
        {
            Caption = 'TA Amount';
            DataClassification = ToBeClassified;
        }
        field(90085; "BBG RemTA Amt"; Decimal)
        {
            Caption = 'RemTA Amt';
            DataClassification = ToBeClassified;
        }
        field(90086; "BBG Ass Invoice Amt"; Decimal)
        {
            Caption = 'Ass Invoice Amt';
            DataClassification = ToBeClassified;
        }
        field(90087; "BBG Check Record"; Boolean)
        {
            Caption = 'Check Record';
            DataClassification = ToBeClassified;
        }
        field(90088; "BBG CommTA Eligible Amount"; Decimal)
        {
            Caption = 'CommTA Eligible Amount';
            DataClassification = ToBeClassified;
        }
        field(90089; "BBG Blocked New"; Option)
        {
            Caption = 'Blocked New';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Payment,All';
            OptionMembers = " ",Payment,All;
        }
        field(90090; "BBG CommAmt"; Decimal)
        {
            Caption = 'CommAmt';
            DataClassification = ToBeClassified;
        }
        field(90091; "BBG TDS Amt"; Decimal)
        {
            Caption = 'TDS Amt';
            DataClassification = ToBeClassified;
        }
        field(90092; "BBG Club9 Amt"; Decimal)
        {
            Caption = 'Club9 Amt';
            DataClassification = ToBeClassified;
        }
        field(90093; "BBG Payment Amount"; Decimal)
        {
            Caption = 'Payment Amount';
            DataClassification = ToBeClassified;
        }
        field(90094; "BBG CommTA Associate"; Boolean)
        {
            Caption = 'CommTA Associate';
            DataClassification = ToBeClassified;
        }
        field(90095; "BBG Comm Associate"; Code[20])
        {
            Caption = 'Comm Associate';
            CalcFormula = Lookup("Commission Entry"."Associate Code" WHERE("Associate Code" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(90096; "BBG TA Associate"; Code[20])
        {
            Caption = 'TA Associate';
            CalcFormula = Lookup("Travel Payment Entry"."Sub Associate Code" WHERE("Sub Associate Code" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(90016; "BBG Vend. Posting Group-Advance"; Code[10])
        {
            Caption = 'Vend. Posting Group-Advance';
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL';
            TableRelation = "Vendor Posting Group";
        }
        field(90017; "BBG Vend. Posting Group-Running"; Code[10])
        {
            Caption = 'Vend. Posting Group-Running';
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL';
            TableRelation = "Vendor Posting Group";

            trigger OnValidate()
            begin
                // ALLEAS02 << <<
                "Vendor Posting Group" := "BBG Vend. Posting Group-Running";
                // ALLEAS02 >> >>
            end;
        }
        field(90018; "BBG Vend. Posting Group-Retention"; Code[10])
        {
            Caption = 'Vend. Posting Group-Retention';
            DataClassification = ToBeClassified;
            Description = 'ALLEAS02--JPL';
            TableRelation = "Vendor Posting Group";
        }
        field(50201; "BBG Report 50011 Run for Associate"; Boolean)
        {
            Caption = 'Report 50011 Run for Associate';
            DataClassification = ToBeClassified;
        }
        field(50202; "BBG Report 50041 Run for Associate"; Boolean)
        {
            Caption = 'Report 50041 Run for Associate';
            DataClassification = ToBeClassified;
        }
        field(50203; "BBG Report 50082 Run for Associate"; Boolean)
        {
            Caption = 'Report 50082 Run for Associate';
            DataClassification = ToBeClassified;
        }
        field(50204; "BBG Report 57782 Run for Associate"; Boolean)
        {
            Caption = 'Report 57782 Run for Associate';
            DataClassification = ToBeClassified;
            Description = '97782 Report';
        }
        field(50205; "BBG Report 50096 Run for Associate"; Boolean)
        {
            Caption = 'Report 50096 Run for Associate';
            DataClassification = ToBeClassified;
        }
        field(90097; "BBG Commission Report for Associat"; Boolean)
        {
            Caption = 'Commission Report for Associat';
            DataClassification = ToBeClassified;
        }
        field(90098; "BBG In-Active Associate"; Boolean)
        {
            Caption = 'In-Active Associate';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90099; "BBG Data active for Associate"; Boolean)
        {
            Caption = 'Data active for Associate';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90100; "BBG Associate Password"; Text[30])
        {
            Caption = 'Associate Password';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                AssociateLoginDetails.RESET;
                AssociateLoginDetails.SETRANGE(Associate_ID, "No.");
                AssociateLoginDetails.SETRANGE("Mobile_ No", "BBG Mob. No.");
                IF AssociateLoginDetails.FINDFIRST THEN BEGIN
                    AssociateLoginDetails.Password := "BBG Associate Password";
                    AssociateLoginDetails.MODIFY;
                END;
            end;
        }
        field(50010; "BBG Mob. No."; Text[30])
        {
            Caption = 'Mob. No.';
            DataClassification = ToBeClassified;
            Description = '--JPL';

            trigger OnValidate()
            var
                OldVendor: Record Vendor;
            begin
                //ALLEDK 100821
                IF "BBG Mob. No." <> '' THEN BEGIN
                    pos := 1;
                    WHILE (pos <= STRLEN("BBG Mob. No.")) DO BEGIN
                        IsNumeric := "BBG Mob. No."[pos] IN ['a' .. 'z', ',', '.', '-', '+'];
                        IF NOT IsNumeric THEN
                            IsNumeric := "BBG Mob. No."[pos] IN ['A' .. 'Z', ',', '.', '-', '+'];

                        IF IsNumeric THEN
                            ERROR('Charactors not allow')
                        ELSE
                            result := result + FORMAT("BBG Mob. No."[pos]);
                        pos += 1;
                    END;
                END;
                //ALLEDK 100821

                OldVendor.RESET;
                OldVendor.SETCURRENTKEY("BBG Mob. No.");
                OldVendor.SETFILTER("No.", '<>%1', "No.");
                OldVendor.SETRANGE("BBG Mob. No.", "BBG Mob. No.");
                OldVendor.SETRANGE("BBG Vendor Category", OldVendor."BBG Vendor Category"::"IBA(Associates)");
                IF OldVendor.FINDFIRST THEN
                    ERROR('Mobile no. already exists for Associate ID-' + OldVendor."No.");
                AssociateLoginDetails.RESET;
                AssociateLoginDetails.SETRANGE(Associate_ID, "No.");
                IF AssociateLoginDetails.FINDFIRST THEN BEGIN
                    AssociateLoginDetails."Mobile_ No" := "BBG Mob. No.";
                    AssociateLoginDetails.MODIFY;
                END;
            end;
        }
        field(90101; "BBG Ass.Block forteam Pos. Report"; Boolean)
        {
            Caption = 'Ass.Block forteam Pos. Report';
            DataClassification = ToBeClassified;
            Description = 'Associate block for Team positive Report 97855';
        }
        field(90102; "BBG Allow All Pmt. to Land Vend"; Boolean)
        {
            Caption = 'Allow All Pmt. to Land Vend';
            DataClassification = ToBeClassified;
        }
        field(90103; "BBG Allow First Pmt. to Land Vend"; Boolean)
        {
            Caption = 'Allow First Pmt. to Land Vend';
            DataClassification = ToBeClassified;
        }
        field(90104; "BBG Old Mobile No."; Text[30])
        {
            Caption = 'Old Mobile No.';
            DataClassification = ToBeClassified;
        }
        field(90105; "BBG Old P.A.N. No."; Code[20])
        {
            Caption = 'P.A.N. No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF ("GST Registration No." <> '') AND ("P.A.N. No." <> COPYSTR("GST Registration No.", 3, 10)) THEN
                    ERROR(SamePANErr);
                //CheckGSTRegBlankInRef;


                //IF "P.A.N. Status" <> 0 THEN
                // ERROR(Text16500);

                IF ("P.A.N. No." <> '') AND
                  NOT ("P.A.N. Status" IN ["P.A.N. Status"::PANAPPLIED,
                    "P.A.N. Status"::PANINVALID, "P.A.N. Status"::PANNOTAVBL])
                THEN BEGIN
                    IF STRLEN("P.A.N. No.") <> 10 THEN
                        ERROR(Text018);

                    Vendor.RESET;
                    Vendor.SETFILTER("No.", '<>%1', "No.");
                    Vendor.SETRANGE("P.A.N. No.", "P.A.N. No.");
                    Vendor.SETRANGE("BBG Vendor Category", "BBG Vendor Category");//ALLETDK120413
                    IF Vendor.FINDFIRST THEN BEGIN
                        IF Vendor."P.A.N. No." <> 'PANAPPLIED' THEN
                            ERROR(Text016, "P.A.N. No.");
                    END;
                END;

                //IF "P.A.N. No." <> xRec."P.A.N. No." THEN  //170220
                //UpdateDedPAN;  //170220


                //ALLEDK 111012
                IF "P.A.N. No." <> 'PANAPPLIED' THEN BEGIN
                    IF "P.A.N. Status" = "P.A.N. Status"::" " THEN BEGIN
                        IF "P.A.N. No." <> '' THEN BEGIN
                            StartNo := COPYSTR("P.A.N. No.", 1, 1);
                            IF EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 2, 1);
                            IF EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 3, 1);
                            IF EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 4, 1);
                            IF EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 5, 1);
                            IF EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 6, 1);
                            IF NOT EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 7, 1);
                            IF NOT EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 8, 1);
                            IF NOT EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 9, 1);
                            IF NOT EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                            StartNo := COPYSTR("P.A.N. No.", 10, 1);
                            IF EVALUATE(VarInteger, StartNo) THEN
                                ERROR('Please define the right PAN No.');
                        END;
                    END;
                END;
                //ALLEDK 111012
            end;
        }
        field(90106; "BBG Age"; Integer)
        {
            Caption = 'Age';
            DataClassification = ToBeClassified;
        }
        field(90107; "BBG Father Name"; Text[50])
        {
            Caption = 'Father Name';
            DataClassification = ToBeClassified;
        }
        field(90108; "BBG Create from Web/Mobile"; Boolean)
        {
            Caption = 'Create from Web/Mobile';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90109; "BBG Send for Approval"; Boolean)
        {
            Caption = 'Send for Approval';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90110; "BBG Send for Aproval Date"; Date)
        {
            Caption = 'Send for Aproval Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90111; "BBG Approval Status"; Option)
        {
            Caption = 'Approval Status';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
        }
        field(90112; "BBG Send for Approval BlackList"; Boolean)
        {
            Caption = 'Send for Approval BlackList';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90113; "BBG Send for Aproval Date BList"; Date)
        {
            Caption = 'Send for Aproval Date BList';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90114; "BBG Approval Status BlackList"; Option)
        {
            Caption = 'Approval Status BlackList';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
        }
        field(90115; "BBG Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90116; "BBG Communication Address"; Text[50])
        {
            Caption = 'Communication Address';
            DataClassification = ToBeClassified;
        }
        field(90117; "BBG Communication Address 2"; Text[50])
        {
            Caption = 'Communication Address 2';
            DataClassification = ToBeClassified;
        }
        field(90118; "BBG CP Designation"; Option)
        {
            Caption = 'CP Designation';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Firm,Platinum,Gold,Silver';
            OptionMembers = " ",Firm,Platinum,Gold,Silver;
        }
        field(90119; "BBG Date of Incorporation"; Date)
        {
            Caption = 'Date of Incorporation';
            DataClassification = ToBeClassified;
        }
        field(90120; "BBG Website (for company)"; Text[50])
        {
            Caption = 'Website (for company)';
            DataClassification = ToBeClassified;
        }
        field(90121; "BBG Name (Point of Contact)"; Text[30])
        {
            Caption = 'Name (Point of Contact)';
            DataClassification = ToBeClassified;
        }
        field(90122; "BBG Address (Point of Contact)"; Text[100])
        {
            Caption = 'Address (Point of Contact)';
            DataClassification = ToBeClassified;
        }
        field(90123; "BBG Email (Point of Contact)"; Text[30])
        {
            Caption = 'Email (Point of Contact)';
            DataClassification = ToBeClassified;
        }
        field(90124; "BBG Membership of association"; Option)
        {
            Caption = 'Membership of association';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,CREDAI,TREDA,RERA,Other';
            OptionMembers = " ",CREDAI,TREDA,RERA,Other;
        }
        field(90125; "BBG Membership Number"; Text[30])
        {
            Caption = 'Membership Number';
            DataClassification = ToBeClassified;
        }
        field(90126; "BBG Registration No"; Text[30])
        {
            Caption = 'Registration No';
            DataClassification = ToBeClassified;
        }
        field(90127; "BBG Expiry date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = ToBeClassified;
        }
        field(90128; "BBG ESI NO"; Text[30])
        {
            Caption = 'ESI NO';
            DataClassification = ToBeClassified;
        }
        field(90129; "BBG PF No."; Text[30])
        {
            Caption = 'PF No.';
            DataClassification = ToBeClassified;
        }
        field(90130; "BBG Communication City"; Text[30])
        {
            Caption = 'City';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code".City
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
                //ALLEDK 100821
                IF City <> '' THEN BEGIN
                    pos := 1;
                    WHILE (pos <= STRLEN(City)) DO BEGIN
                        IsNumeric := City[pos] IN ['0' .. '9', '-', '+'];
                        IF IsNumeric THEN
                            ERROR('Number not allow')
                        ELSE
                            result := result + FORMAT(City[pos]);
                        pos += 1;
                    END;
                END;
                //ALLEDK 100821
            end;
        }
        field(90131; "BBG Communication State Code"; Code[10])
        {
            Caption = 'State Code';
            DataClassification = ToBeClassified;
            TableRelation = State;

            trigger OnValidate()
            begin
                IF NOT ("GST Vendor Type" IN ["GST Vendor Type"::Import, "GST Vendor Type"::Unregistered]) THEN
                    TESTFIELD("GST Registration No.", '');
                IF "GST Vendor Type" = "GST Vendor Type"::Import THEN
                    ERROR(GSTVendorTypeErr, "GST Vendor Type");
            end;
        }
        field(90132; "BBG Communication Post Code"; Code[20])
        {
            Caption = 'Post Code';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Country/Region Code" = CONST()) "Post Code"
            ELSE IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                v_PostCode: Record "Post Code";
            begin
                IF STRLEN("BBG Communication Post Code") > 6 THEN  //ALLEDK 100821
                    ERROR('Communication Post code can not be greater than 6 Digits');   //ALLEDK 100821
                PostCode.ValidatePostCode("BBG Communication City", "BBG Communication Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);

                v_PostCode.GET("BBG Communication Post Code", "BBG Communication City");  //ALLEDK 100821
                "BBG Communication State Code" := v_PostCode."State Code";  //ALLEDK 100821
            end;
        }
        field(90152; "BBG Entity Type"; Option)
        {
            Caption = 'Entity Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,individual,sales propritorship,partenership firm,LLP,public limited,private Limited,other any';
            OptionMembers = " ",individual,"sales propritorship","partenership firm",LLP,"public limited","private Limited","other any";
        }
        field(90153; "BBG CP Team Code"; Code[50])
        {
            Caption = 'CP Team Code';
            DataClassification = ToBeClassified;
            TableRelation = "CP Team Master"."Team Code";
        }
        field(90154; "BBG CP Leader Code"; Code[20])
        {
            Caption = 'CP Leader Code';
            DataClassification = ToBeClassified;
            TableRelation = "CP Leader Master"."Leader Code";
        }
        field(90155; "BBG Last Previous Year"; Decimal)
        {
            Caption = 'Last Previous Year';
            DataClassification = ToBeClassified;
        }
        field(90156; "BBG Second Previous Year"; Decimal)
        {
            Caption = 'Second Previous Year';
            DataClassification = ToBeClassified;
        }
        field(90157; "BBG Third Previous Year"; Decimal)
        {
            Caption = 'Third Previous Year';
            DataClassification = ToBeClassified;
        }
        field(90158; "BBG Aadhar No."; Code[15])  //251124 Added new field
        {
            Caption = 'BBG Aadhar No.';
            DataClassification = ToBeClassified;
        }
        field(50014; "BBG Select"; Boolean)
        {
            Caption = 'Select';
            DataClassification = ToBeClassified;
            Description = 'AlleDK NTPC';
        }
        field(50007; "BBG Address 3"; Text[30])
        {
            Caption = 'Address 3';
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(50013; "BBG MSMED Classification"; Option)
        {
            Caption = 'MSMED Classification';
            DataClassification = ToBeClassified;
            Description = 'added by DDS';
            OptionCaption = ' ,NONE,MICRO,SMALL,MEDIUM';
            OptionMembers = " ","NONE",MICRO,SMALL,MEDIUM;
        }
        field(50019; "BBG Verify P.A.N. No."; Boolean)
        {
            Caption = 'Verify P.A.N. No.';
            DataClassification = ToBeClassified;
            Description = 'ALLEPG 230812';
        }
        field(60001; "BBG Area of Expertise"; Code[20])
        {
            Caption = 'Area of Expertise';
            DataClassification = ToBeClassified;
            Description = 'ALLESP BCL0004 11-07-2007';
            TableRelation = "Bonus Entry Posted Adjustment"."Unit No." WHERE("Entry No." = FIELD("BBG Vendor Category"));
        }
        field(60005; "BBG Is Employee"; Boolean)
        {
            Caption = 'Is Employee';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
        }
        field(90020; "BBG ICB"; Boolean)
        {
            Caption = 'ICB';
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(90021; "BBG WCT No"; Code[20])
        {
            Caption = 'WCT No';
            DataClassification = ToBeClassified;
            Description = '--JPL';
        }
        field(90022; "BBG Order Value"; Decimal)
        {
            Caption = 'Order Value';
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Line Amount" WHERE("Document Type" = CONST(Order),
                                                                   "Pay-to Vendor No." = FIELD("No."),
                                                                   "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                   "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                   "Currency Code" = FIELD("Currency Filter")));
            Description = '--JPL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(90023; "BBG Posting Type Filter"; Option)
        {
            Caption = 'Posting Type Filter';
            Description = 'ALLEAS02--JPL';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Advance,Running,Retention,Secured Advance,Adhoc Advance,Provisional,LD,Mobilization Advance,Equipment Advance,,,,Commission,Travel Allowance,Bonanza,Incentive,CommAndTA';  //Added new options   130225
            OptionMembers = " ",Advance,Running,Retention,"Secured Advance","Adhoc Advance",Provisional,LD,"Mobilization Advance","Equipment Advance",,,,Commission,"Travel Allowance",Bonanza,Incentive,CommAndTA;
        }
        field(90024; "BBG TempBlocked"; Option)
        {
            Caption = 'TempBlocked';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionCaption = ' ,Payment,All';
            OptionMembers = " ",Payment,All;
        }
        field(50000; "BBG Related Party"; Boolean)
        {
            Caption = 'Related Party';
            DataClassification = ToBeClassified;
            Description = 'JPL0002 : indicator that party is related ie. group related--JPL';
        }
        field(50207; "BBG RERA Status"; Option)
        {
            Caption = 'RERA Status';
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Unregistered,Registered';
            OptionMembers = Unregistered,Registered;
        }
        field(50320; "BBG INOPERATIVE PAN"; Boolean)
        {
            Caption = 'INOPERATIVE PAN';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                IF CONFIRM('Do you want to use INOPERATIVE PAN functionality') THEN BEGIN
                    IF "BBG INOPERATIVE PAN" THEN BEGIN
                        IF ("P.A.N. No." <> '') AND ("P.A.N. No." <> 'PANAPPLIED') AND ("P.A.N. No." <> 'PANINVALID') AND ("P.A.N. No." <> 'PANNOTAVBL') THEN BEGIN
                            "BBG Old P.A.N. No." := "P.A.N. No.";
                            "P.A.N. No." := 'PANNOTAVBL';
                            "P.A.N. Reference No." := 'PANNOTAVBL';
                            "P.A.N. Status" := "P.A.N. Status"::PANNOTAVBL;
                            COMMIT;
                        END;
                    END;
                END;
            end;
        }
        field(50305; "BBG Leader Code"; Code[20])
        {
            Caption = 'Leader Code';
            DataClassification = ToBeClassified;
            TableRelation = "Leader Master";
        }
        field(50306; "BBG Sub Team Code"; Code[20])
        {
            Caption = 'Sub Team Code';
            DataClassification = ToBeClassified;
            TableRelation = "Sub Team Master";
        }

    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
        CompanywiseAccount: Record "Company wise G/L Account";
        Text015: Label 'Parent code should not be same as Code.';
        Vendor: Record Vendor;
        RecVendor: Record Vendor;
        Memberof: Record "Access Control";
        RecCompwiseAcc: Record "Company wise G/L Account";
        ProductVendor: Record "Product Vendor";
        Text012: Label 'Parent code should not be same as Code.';
        Text013: Label 'MM %1 is Inactive.';
        Text014: Label 'Rank cannot be greater or equal with parent.';
        AssociateLoginDetails: Record "Associate Login Details";
        pos: Integer;
        result: Text;
        IsNumeric: Boolean;
        SamePANErr: Label 'From postion 3 to 12 in GST Registration No. should be same as it is in PAN No. so delete and then update it.';
        Text016: Label 'ENU=Duplicate PAN No. %1';
        Text017: Label 'ENU=Duplicate Acknowledgement Receipt No.';
        Text018: Label 'ENU=P.A.N. No. should be of 10 digits.';
        StartNo: Text[10];
        VarInteger: Integer;
        PostCode: Record "Post Code";
        GSTVendorTypeErr: Label '@@@="%1=GST Vendor Type";State code should be empty,If GST Vendor Type %1.';

    PROCEDURE CreateNOD()
    VAR
    //BondSetup: Record 97788;
    //NODHeader: Record 13786;
    //NODLine: Record 13785;
    BEGIN
        TESTFIELD("Vendor Posting Group");
        // BondSetup.GET;
        // BondSetup.TESTFIELD("TDS Nature of Deduction");
        // IF NOT NODHeader.GET(NODHeader.Type::Vendor, "No.") THEN BEGIN
        //     NODHeader.INIT;
        //     NODHeader.Type := NODHeader.Type::Vendor;
        //     NODHeader."No." := "No.";
        //     NODHeader."Assesse Code" := 'IND';
        //     NODHeader.INSERT;
        // END;

        // IF NOT NODLine.GET(NODLine.Type::Vendor, "No.", BondSetup."TDS Nature of Deduction") THEN BEGIN
        //     NODLine.Type := NODLine.Type::Vendor;
        //     NODLine."No." := "No.";
        //     NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
        //     NODLine."Monthly Certificate" := TRUE;
        //     NODLine."Threshold Overlook" := TRUE;
        //     NODLine."Surcharge Overlook" := TRUE;
        //     NODLine.INSERT;
        // END;
    END;

    PROCEDURE HistoryFunction(FunctionNo: Integer; Comment: Text[30]);
    BEGIN
        //HistoryRec.HistoryFunction(Rec,FunctionNo,Comment);  //ALELDK 040313
    END;

    PROCEDURE NODExists(): Boolean;
    VAR
        BondSetup: Record "Unit Setup";
        //NODLine: Record 13785;
        AllowedSection: Record "Allowed Sections";
    BEGIN
        BondSetup.GET;
        BondSetup.TESTFIELD("TDS Nature of Deduction");
        //EXIT(NODLine.GET(NODLine.Type::Vendor, "No.", BondSetup."TDS Nature of Deduction"));//Need to check the code in UAT
        EXIT(AllowedSection.GET("No.", BondSetup."TDS Nature of Deduction"));
    END;
}