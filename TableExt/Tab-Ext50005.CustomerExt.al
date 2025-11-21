tableextension 50005 "BBG Customer Ext" extends Customer
{
    fields
    {
        // Add changes to table fields here
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                IF STRLEN(Name) < 3 THEN
                    ERROR('Please define actual Name');
                //ALLEDK 100821
                IF Name <> '' THEN BEGIN
                    pos := 1;
                    WHILE (pos <= STRLEN(Name)) DO BEGIN
                        IsNumeric := Name[pos] IN ['0' .. '9', '-', '+'];
                        IF IsNumeric THEN
                            ERROR('Number not allow')
                        ELSE
                            result := result + FORMAT(Name[pos]);
                        pos += 1;
                    END;
                    "BBG Name Modify By" := USERID;  //121021
                    "BBG Name Modify Date_Time" := CURRENTDATETIME;  //121021
                END;
                //ALLEDK 100821
            end;
        }
        modify("Name 2")
        {
            trigger OnAfterValidate()
            begin

                IF "Name 2" <> '' THEN BEGIN
                    pos := 1;
                    WHILE (pos <= STRLEN("Name 2")) DO BEGIN
                        IsNumeric := "Name 2"[pos] IN ['0' .. '9', '-', '+'];
                        IF IsNumeric THEN
                            ERROR('Number not allow')
                        ELSE
                            result := result + FORMAT("Name 2"[pos]);
                        pos += 1;
                    END;
                END;
                //ALLEDK 100821
            end;
        }
        modify(City)
        {
            trigger OnAfterValidate()
            begin
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
        modify("Customer Posting Group")
        {
            trigger OnAfterValidate()
            begin
                TESTFIELD(Name);  //310821
            end;
        }
        modify("Gen. Bus. Posting Group")
        {
            trigger OnAfterValidate()
            begin
                TESTFIELD(Name);  //310821
            end;
        }
        modify("Post Code")
        {
            trigger OnAfterValidate()
            var
                v_PostCode: Record "Post Code";
                PostCode: Record "Post Code";
            begin
                IF STRLEN("Post Code") > 6 THEN  //ALLEDK 100821
                    ERROR('Post code can not be greater than 6 Digits');   //ALLEDK 100821

                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);

                v_PostCode.GET("Post Code", City);  //ALLEDK 100821
                "State Code" := v_PostCode."State Code";  //ALLEDK 100821
            end;
        }
        modify("Responsibility Center")
        {
            TableRelation = "Responsibility Center 1";
        }
        modify("P.A.N. No.")
        {
            trigger OnAfterValidate()
            begin
                //ALLEDK 111012
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
                //ALLEDK 111012
            end;
        }
        field(50000; "BBG Related Party"; Boolean)
        {
            Caption = 'Related Party';
            DataClassification = ToBeClassified;
            Description = 'JPL0002 : indicator that party is related ie. group related--JPL';
        }

        field(50002; "BBG New Credit Amount (LCY)"; Decimal)
        {
            Caption = 'New Credit Amount (LCY)';
            BlankZero = true;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Credit Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                        "Entry Type" = FILTER(<> Application),
                                                                                        "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                        "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                        "Posting Date" = FIELD("Date Filter"),
                                                                                        "Currency Code" = FIELD("Currency Filter"),
                                                                                        "Posting Type" = FIELD("BBG Posting Type Filter")));
            Description = 'AlleDK 200308 For report Customer Ledger';
            FieldClass = FlowField;
        }

        field(50004; "BBG Phone No. 2"; Text[30])
        {
            Caption = 'Phone No. 2';
            DataClassification = ToBeClassified;
            Description = 'AlleDK 190608';
        }
        field(50006; "BBG Occupation"; Text[30])
        {
            Caption = 'Occupation';
            DataClassification = ToBeClassified;
            Description = 'BBG1.00';
        }
        field(50007; "BBG Nominee"; Text[50])
        {
            Caption = 'Nominee';
            DataClassification = ToBeClassified;
            Description = 'BBG1.00';
        }
        field(50008; "BBG Nominee Relation"; Text[20])
        {
            Caption = 'Nominee Relation';
            DataClassification = ToBeClassified;
            Description = 'BBG1.00';
        }
        field(50009; "BBG Marriage Date"; Date)
        {
            Caption = 'Marriage Date';
            DataClassification = ToBeClassified;
            Description = 'BBG1.00';
        }
        field(50010; "BBG MSC Cust Code"; Code[20])
        {
            Caption = 'MSC Cust Code';
            DataClassification = ToBeClassified;
        }
        field(50011; "BBG Old Nav Cust No."; Code[20])
        {
            Caption = 'Old Nav Cust No.';
            DataClassification = ToBeClassified;
            Description = 'BBG 041214';
            Editable = false;
        }
        field(50020; "BBG Remark"; Text[50])
        {
            Caption = 'Remark';
            DataClassification = ToBeClassified;
        }
        field(50021; "BBG Nominee Age"; Integer)
        {
            Caption = 'Nominee Age';
            DataClassification = ToBeClassified;
        }
        field(50022; "BBG Name Modify By"; Code[50])
        {
            Caption = 'Name Modify By';
            DataClassification = ToBeClassified;
            Description = '121021';
            Editable = false;
        }
        field(50023; "BBG Name Modify Date_Time"; DateTime)
        {
            Caption = 'Name Modify Date_Time';
            DataClassification = ToBeClassified;
            Description = '121021';
            Editable = false;
        }

        field(50025; "BBG District"; Text[30])
        {
            Caption = 'District';
            DataClassification = ToBeClassified;
        }
        field(50050; "BBG Address Updated By Customer"; Boolean)
        {
            Caption = 'Address Updated By Customer';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50051; "BBG Customer Password"; Text[30])
        {
            Caption = 'Customer Password';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                CustomerLoginDetails: Record "Customer Login Details";
            begin
                CustomerLoginDetails.RESET;
                CustomerLoginDetails.SETRANGE("Customer No.", "No.");
                CustomerLoginDetails.SETRANGE("Mobile No.", "BBG Mobile No.");
                IF CustomerLoginDetails.FINDFIRST THEN BEGIN
                    CustomerLoginDetails.Password := "BBG Customer Password";
                    CustomerLoginDetails.MODIFY;
                END;
            end;
        }
        field(60006; "BBG Net Change - Advance (LCY)"; Decimal)
        {
            Caption = 'Net Change - Advance (LCY)';
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                 "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                 "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                                 "Currency Code" = FIELD("Currency Filter"),
                                                                                 "Posting Type" = FILTER(Advance)));
            Description = 'AlleBLK';
            FieldClass = FlowField;
        }
        field(60007; "BBG Net Change - Running (LCY)"; Decimal)
        {
            Caption = 'Net Change - Running (LCY)';
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                 "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                 "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                                 "Currency Code" = FIELD("Currency Filter"),
                                                                                 "Posting Type" = FILTER(Running)));
            Description = 'AlleBLK';
            FieldClass = FlowField;
        }
        field(60008; "BBG Net Change - Retention (LCY)"; Decimal)
        {
            Caption = 'Net Change - Retention (LCY)';
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                 "Initial Entry Global Dim. 1" = FIELD("Global Dimension 1 Filter"),
                                                                                 "Initial Entry Global Dim. 2" = FIELD("Global Dimension 2 Filter"),
                                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                                 "Currency Code" = FIELD("Currency Filter"),
                                                                                 "Posting Type" = FILTER(Retention)));
            Description = 'AlleBLK';
            FieldClass = FlowField;
        }
        field(60009; "BBG Update Address"; Text[50])
        {
            Caption = 'Update Address';
            DataClassification = ToBeClassified;
            Description = 'BBG2.11 230714';
        }
        field(60010; "BBG Update Address 2"; Text[50])
        {
            Caption = 'Update Address 2';
            DataClassification = ToBeClassified;
            Description = 'BBG2.11 230714';
        }
        field(60011; "BBG Update Address 3"; Text[30])
        {
            Caption = 'Update Address 3';
            DataClassification = ToBeClassified;
            Description = 'BBG2.11 230714';
        }
        field(60012; "BBG Update Mobile No."; Text[30])
        {
            Caption = 'Update Mobile No.';
            DataClassification = ToBeClassified;
            Description = 'BBG2.11 230714';
        }



        field(90024; "BBG TempBlocked"; Option)
        {
            Caption = 'TempBlocked';
            DataClassification = ToBeClassified;
            Description = 'AlleBLK';
            OptionCaption = ' ,Payment,All';
            OptionMembers = " ",Payment,All;
        }
        field(90025; "BBG Address 3"; Text[80])
        {
            Caption = 'Address 3';
            DataClassification = ToBeClassified;
            Description = 'ALLEAB for soul space';
        }
        field(50052; "BBG IC Partner Code"; Code[20])
        {
            Caption = 'BBG IC Partner Code';
            TableRelation = "IC Partner";

            trigger OnValidate()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                AccountingPeriod: Record "Accounting Period";
                ICPartner: Record "IC Partner";
                ConfirmManagement: Codeunit "Confirm Management";
            begin
                if xRec."BBG IC Partner Code" <> "BBG IC Partner Code" then begin
                    if not CustLedgEntry.SetCurrentKey("Customer No.", Open) then
                        CustLedgEntry.SetCurrentKey("Customer No.");
                    CustLedgEntry.SetRange("Customer No.", "No.");
                    CustLedgEntry.SetRange(Open, true);
                    if CustLedgEntry.FindLast() then;
                    //Error(Text012, FieldCaption("IC Partner Code"), TableCaption);

                    CustLedgEntry.Reset();
                    CustLedgEntry.SetCurrentKey("Customer No.", "Posting Date");
                    CustLedgEntry.SetRange("Customer No.", "No.");
                    AccountingPeriod.SetRange(Closed, false);
                    if AccountingPeriod.FindFirst() then begin
                        CustLedgEntry.SetFilter("Posting Date", '>=%1', AccountingPeriod."Starting Date");
                        if CustLedgEntry.FindFirst() then;
                        //if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(Text011, TableCaption), true) then
                        //  "IC Partner Code" := xRec."IC Partner Code";
                    end;
                end;

                if "BBG IC Partner Code" <> '' then begin
                    ICPartner.Get("BBG IC Partner Code");
                    if (ICPartner."Customer No." <> '') and (ICPartner."Customer No." <> "No.") then
                        Error(Text010, FieldCaption("BBG IC Partner Code"), "BBG IC Partner Code", TableCaption(), ICPartner."Customer No.");
                    ICPartner."Customer No." := "No.";
                    ICPartner.Modify();
                end;

                if (xRec."BBG IC Partner Code" <> "BBG IC Partner Code") and ICPartner.Get(xRec."BBG IC Partner Code") then begin
                    ICPartner."Customer No." := '';
                    ICPartner.Modify();
                end;
            end;
        }

        field(60040; "District Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'District Code';
            DataClassification = ToBeClassified;
            TableRelation = "District Details".Code where("State Code" = field("State Code"));
        }
        field(60041; "Mandal Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Mandal Code';
            DataClassification = ToBeClassified;
            TableRelation = "Mandal Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"));
        }
        field(60042; "Village Code"; Code[50])           //23072025 Added new field
        {
            Caption = 'Village Code';
            DataClassification = ToBeClassified;
            TableRelation = "Village Details".Code where("State Code" = field("State Code"), "District Code" = field("District Code"), "Mandal Code" = field("Mandal Code"));
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
        "-------------Alle--------------------": Integer;
        Text010: Label 'The %1 %2 has been assigned to %3 %4.\The same %1 cannot be entered on more than one %3. Enter another code.';

        MasterSetup: Record "Master Mandatory Setup";
        RecRef: RecordRef;
        StartNo: Text[10];
        VarInteger: Integer;
        Cust: Record Customer;
        Memberof: Record "Access Control";
        "--------------------": Integer;
        pos: Integer;
        result: Text;
        IsNumeric: Boolean;

    trigger OnAfterInsert()

    begin
        ////NDALLE 051107 begin
        RecRef.GETTABLE(Rec);
        MasterSetup.MasterValidate(RecRef);
        Rec."Country/Region Code" := 'IN'; //Code added 23072025
        ////NDALLE 051107 END
        //"Date of Joining" := TODAY; //ALLECK 130313
    end;

    trigger OnAfterModify()
    var
        Company: Record Company;
        V_Customer: Record Customer;

    begin
        ////NDALLE 051107 begin
        RecRef.GETTABLE(Rec);
        MasterSetup.MasterValidate(RecRef);
        ////NDALLE 051107 END

    end;
}