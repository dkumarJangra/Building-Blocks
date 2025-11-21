table 97733 "Gate Pass Header"
{
    // //ALLE-PKS10 added code for to flow the Enter by name,Returned By
    // //AlleBLk : New fields added
    // //NDALLE : Write a code
    // //ALLE-SR : Write a code
    // //ALLEND : Write a code
    // //SC : this code writtenf for modify the location code
    // ALLEPG RIL1.14 080112 : Vendor name length changed from 30 to 50
    // RAHEE1.00 Come Location code automatically of Subcon/site location;
    // ALLEPG RAHEE1.00 020312 : Added field & create functions
    // // BBG1.01 ALLE_NB 251012 : Apply Vendor Category.
    // BBG1.00 260713 Added code for delete lines
    // 251121 Code added

    DrillDownPageID = "Regular Gold/Silver Issue List";
    LookupPageID = "Regular Gold/Silver Issue List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'MIN,Outward Gatepass,Material Return,Inward Gatepass,Consumption FOC,Consumption Chargable,Finished Goods';
            OptionMembers = "MIN","Outward Gatepass","Material Return","Inward Gatepass","Consumption FOC","Consumption Chargable","Finished Goods";

            trigger OnValidate()
            begin
                "Document Date" := WORKDATE;
                "Posting Date" := WORKDATE;
            end;
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4; "Document Date"; Date)
        {
        }
        field(5; "Posting Date"; Date)
        {
            Editable = true;
        }
        field(6; "Purchase Order No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = FILTER(Order),
                                                         "Sub Document Type" = FILTER('WO-NICB' | 'WO-ICB'));

            trigger OnValidate()
            begin
                //NDALLE 071205
                PurchHeader.RESET;
                PurchHeader.SETRANGE(PurchHeader."No.", "Purchase Order No.");
                IF PurchHeader.FIND('-') THEN BEGIN
                    "Vendor No." := PurchHeader."Buy-from Vendor No.";
                    "Vendor Name" := PurchHeader."Pay-to Name";
                    "Gen. Business Posting Group" := PurchHeader."Gen. Bus. Posting Group"; //ALLEAA
                                                                                            //VALIDATE("Shortcut Dimension 1 Code",PurchHeader."Shortcut Dimension 1 Code");
                    VALIDATE("Shortcut Dimension 2 Code", PurchHeader."Shortcut Dimension 2 Code");
                END;
                GatePassLine.RESET;
                GatePassLine.SETRANGE("Document No.", "Document No.");
                IF GatePassLine.FIND('-') THEN BEGIN
                    REPEAT
                        GatePassLine."Purchase Order No." := "Purchase Order No.";
                        GatePassLine."Location Code" := "Location Code";
                        IF GatePassLine."Purchase Order No." = '' THEN
                            GatePassLine."PO Line No." := 0;  //MP1.0
                        GatePassLine.MODIFY(TRUE);
                    UNTIL GatePassLine.NEXT = 0;
                END;
                //NDALLE 071205
            end;
        }
        field(7; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                MODIFY;
                //NDALLE 071205
                /*
                DimValue.RESET;
                DimValue.SETRANGE(Code,"Shortcut Dimension 1 Code");
                IF DimValue.FIND('-') THEN BEGIN
                  //"Cost Centre Name" := DimValue.Name;
                  VALIDATE("Gen. Business Posting Group",DimValue."Gen. Business Posting Group");
                END;
                 */
                GatePassLine.RESET;
                GatePassLine.SETRANGE("Document No.", "Document No.");
                IF GatePassLine.FIND('-') THEN BEGIN
                    REPEAT
                        GatePassLine.VALIDATE("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                        GatePassLine."Cost Centre Name" := "Cost Centre Name";
                        GatePassLine.VALIDATE("Gen. Bus. Posting Group", "Gen. Business Posting Group");
                        GatePassLine.MODIFY(TRUE);
                    UNTIL GatePassLine.NEXT = 0;
                END;
                //NDALLE 071205

            end;
        }
        field(8; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                MODIFY;
                //NDALLE 071205
                GatePassLine.RESET;
                GatePassLine.SETRANGE("Document No.", "Document No.");
                IF GatePassLine.FIND('-') THEN BEGIN
                    REPEAT
                        GatePassLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                        GatePassLine.MODIFY(TRUE);
                    UNTIL GatePassLine.NEXT = 0;
                END;
                //NDALLE 071205

                RecDimValue.RESET;
                RecDimValue.SETRANGE(RecDimValue.Code, "Shortcut Dimension 2 Code");
                IF RecDimValue.FIND('-') THEN BEGIN
                    "Cost Centre Name" := RecDimValue.Name;
                    //VALIDATE("Gen. Business Posting Group",RecDimValue."Gen. Business Posting Group");
                END
                ELSE
                    "Cost Centre Name" := '';
            end;
        }
        field(9; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            var
                regionWisevendor: Record "Region wise Vendor";
                Unitsetup: Record "Unit Setup";
            begin
                Unitsetup.GET;
                Unitsetup.TestField("Gift Vendor Rank Code");

                Vendor.RESET;
                IF Vendor.GET("Vendor No.") THEN;
                "Vendor Name" := Vendor.Name;

                If "Item Type" = "Item Type"::R194_Gift then begin
                    regionWisevendor.RESET;
                    regionWisevendor.SetRange("Region Code", 'R0001');
                    regionWisevendor.SetRange("No.", "Vendor No.");
                    IF regionWisevendor.FindFirst() THEN begin
                        IF (regionWisevendor."Rank Code" >= 1) AND (regionWisevendor."Rank Code" <= Unitsetup."Gift Vendor Rank Code") then begin
                        END ELSE
                            Error('Assocaite Rank code should be under=' + format(Unitsetup."Gift Vendor Rank Code"));
                    end;
                end;
            end;


        }
        field(10; "Vendor Name"; Text[50])
        {
            Description = 'ALLEPG Length changed from 30 to 50';
            Editable = false;
        }
        field(11; "Issue Type"; Option)
        {
            OptionCaption = 'Free,Chargeable';
            OptionMembers = Free,Chargeable;
        }
        field(12; "Entered By"; Code[50])
        {
            Editable = false;

            trigger OnValidate()
            begin
                //ALLE-PKS10
                IF "Entered By" <> '' THEN BEGIN
                    RecUser.RESET;
                    RecUser.SETRANGE("User Name", "Entered By");
                    IF RecUser.FINDFIRST THEN
                        "Entered By Name" := FORMAT(RecUser."User Name")
                    ELSE
                        "Entered By Name" := '';
                END;
                //ALLE-PKS10
            end;
        }
        field(13; "Issued By"; Code[50])
        {

            trigger OnValidate()
            begin
                IF "Issued By" <> '' THEN BEGIN
                    RecUser.RESET;
                    RecUser.SETRANGE("User Name", "Issued By");
                    IF RecUser.FINDFIRST THEN
                        "Issued By Name" := FORMAT(RecUser."User Name")
                    ELSE
                        "Issued By Name" := '';
                END;
            end;
        }
        field(14; "Received By"; Code[50])
        {
            TableRelation = IF ("Receiver Type" = CONST(Associate)) Vendor."No." WHERE("BBG Vendor Category" = CONST("IBA(Associates)"))
            ELSE IF ("Receiver Type" = CONST(Member)) Customer."No.";

            trigger OnValidate()
            begin
                IF "Received By" <> '' THEN BEGIN
                    RecUser.RESET;
                    RecUser.SETRANGE("User Name", "Received By");
                    IF RecUser.FINDFIRST THEN
                        "Received By Name" := FORMAT(RecUser."User Name")
                    ELSE
                        "Received By Name" := '';
                END;
            end;
        }
        field(15; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Close';
            OptionMembers = Open,Close;

            trigger OnValidate()
            begin
                //NDALLE 071205
                GatePassLine.RESET;
                GatePassLine.SETRANGE("Document No.", "Document No.");
                IF GatePassLine.FIND('-') THEN BEGIN
                    REPEAT
                        GatePassLine.Status := Status;
                        GatePassLine.MODIFY;
                    UNTIL GatePassLine.NEXT = 0;
                END;
                //NDALLE 071205
            end;
        }
        field(16; "Outward Gatepass Type"; Option)
        {
            OptionCaption = 'Returnable,Non-Returnable';
            OptionMembers = Returnable,"Non-Returnable";
        }
        field(50000; "Gen. Business Posting Group"; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                //NDALLE 071205
                GatePassLine.RESET;
                GatePassLine.SETRANGE("Document No.", "Document No.");
                IF GatePassLine.FIND('-') THEN BEGIN
                    REPEAT
                        GatePassLine.VALIDATE("Gen. Bus. Posting Group", "Gen. Business Posting Group");
                        GatePassLine.MODIFY(TRUE);
                    UNTIL GatePassLine.NEXT = 0;
                END;
                //NDALLE 071205
            end;
        }
        field(50001; "Cost Centre Name"; Text[60])
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50002; "MIN No. Series"; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = "No. Series";
        }
        field(50003; "MRN No. Series"; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = "No. Series";
        }
        field(50004; "OWGP No. Series"; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = "No. Series";
        }
        field(50005; "IWGP No. Series"; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = "No. Series";
        }
        field(50006; "Location Code"; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = Location;

            trigger OnValidate()
            begin
                //SC ->>
                GatePassLine.RESET;
                GatePassLine.SETRANGE("Document No.", "Document No.");
                IF GatePassLine.FIND('-') THEN BEGIN
                    REPEAT
                        GatePassLine.VALIDATE("Location Code", "Location Code");
                        GatePassLine.MODIFY(TRUE);
                    UNTIL GatePassLine.NEXT = 0;
                END;
                // <<--
            end;
        }
        field(50007; "Receiver Name"; Text[60])
        {
            Description = 'AlleBLK';
        }
        field(50008; Remarks; Text[80])
        {
            Description = 'AlleBLK';
        }
        field(50009; "Mode of Transport"; Option)
        {
            Description = 'AlleBLK';
            OptionMembers = Road,Rail;
        }
        field(50010; "Address of Despatch"; Text[80])
        {
            Description = 'AlleBLK';
        }
        field(50011; "Transporters Name"; Text[30])
        {
            Description = 'AlleBLK';
        }
        field(50012; "LR No."; Text[30])
        {
            Description = 'AlleBLK';
        }
        field(50013; "LR Date"; Date)
        {
            Description = 'AlleBLK';
        }
        field(50014; "Vehicle No."; Text[30])
        {
            Description = 'AlleBLK';
        }
        field(50015; "Reference No."; Text[30])
        {
            Description = 'AlleBLK';
        }
        field(50016; "Issued By Name"; Text[50])
        {
            Description = 'AlleBLK';
        }
        field(50017; "Received By Name"; Text[50])
        {
            Description = 'AlleBLK';
        }
        field(50018; "Vendor Contact Name"; Text[50])
        {
            Description = 'AlleBLK';
        }
        field(50019; "Sent for Verification"; Boolean)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50020; "Sent for Verification Date"; Date)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50021; "Sent For Verification Time"; Time)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50022; Verified; Boolean)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50023; "Verified Date"; Date)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50024; "Verified Time"; Time)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50025; "Sent for Verification By"; Code[20])
        {
            Description = 'AlleBLK';
            Editable = false;
            TableRelation = User;
        }
        field(50026; "Verified By"; Code[20])
        {
            Description = 'AlleBLK';
            Editable = false;
            TableRelation = User;
        }
        field(50027; "Total Value"; Decimal)
        {
            CalcFormula = Sum("Gate Pass Line".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                             "Document No." = FIELD("Document No.")));
            Description = 'AlleBLK';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50028; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'AlleBLK';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('CAPITALIZATION'));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                //MODIFY;
                //NDALLE 071205
                GatePassLine.RESET;
                GatePassLine.SETRANGE("Document No.", "Document No.");
                IF GatePassLine.FIND('-') THEN BEGIN
                    REPEAT
                        GatePassLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                        GatePassLine.MODIFY(TRUE);
                    UNTIL GatePassLine.NEXT = 0;
                END;
                //NDALLE 071205
            end;
        }
        field(50029; Narration; Text[200])
        {
            Description = 'AlleBLK';
        }
        field(50030; Returned; Boolean)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50031; "Returned Date"; Date)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50032; "Returned Time"; Time)
        {
            Description = 'AlleBLK';
            Editable = false;
        }
        field(50033; "Responsibility Center"; Code[10])
        {
            Description = 'AlleBLK';
            TableRelation = "Responsibility Center 1";

            trigger OnValidate()
            begin
                //ALLE-SR-051107 >>
                IF NOT UserMgt.CheckRespCenter(1, "Responsibility Center") THEN
                    ERROR(
                      Text028,
                       RespCenter.TABLECAPTION, UserMgt.GetPurchasesFilter());

                VALIDATE("Location Code", UserMgt.GetLocation(1, '', "Responsibility Center"));

                //ALLE-SR-051107 <<
            end;
        }
        field(50034; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            Description = 'AlleBLK';
            TableRelation = Job;
        }
        field(50035; "Entered By Name"; Text[50])
        {
            Description = 'ALLE-PKS10';
        }
        field(50036; "Returned By"; Code[50])
        {
            Description = 'ALLE-PKS10';
        }
        field(50039; "Consumption FOC Nos."; Code[20])
        {
            Description = 'RAHEE1.00 180412';
            TableRelation = "No. Series";
        }
        field(50040; "Consumption Chargeable Nos."; Code[20])
        {
            Description = 'RAHEE1.00 180412';
            TableRelation = "No. Series";
        }
        field(50041; "WO Invoice No"; Code[20])
        {
            Description = 'RAHEE1.00 180412';
            TableRelation = "No. Series";
        }
        field(50042; "FG Recipt Nos."; Code[20])
        {
            Description = 'RAHEE1.00 060512';
        }
        field(50043; "Customer No."; Code[20])
        {
            Description = 'AlleBBG';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                IF Customer.GET("Customer No.") THEN BEGIN
                    "Customer Name" := Customer.Name;
                    "Receiver Type" := "Receiver Type"::Member;
                    "Received By" := "Customer No.";
                    "Receiver Name" := Customer.Name;
                    MODIFY;
                    GatePassLine.RESET;
                    GatePassLine.SETRANGE("Document No.", "Document No.");
                    IF GatePassLine.FIND('-') THEN BEGIN
                        REPEAT
                            GatePassLine."Customer No." := "Customer No.";
                            GatePassLine.MODIFY(TRUE);
                        UNTIL GatePassLine.NEXT = 0;
                    END;
                END ELSE BEGIN
                    "Customer Name" := '';
                    "Receiver Type" := "Receiver Type"::" ";
                    "Received By" := '';
                    "Receiver Name" := '';
                    MODIFY;
                END;
            end;
        }
        field(50044; "Customer Name"; Text[60])
        {
            Description = 'AlleBBG';
        }
        field(50045; "Receiver Type"; Option)
        {
            Description = 'AlleBBG';
            OptionCaption = ' ,Member,Associate';
            OptionMembers = " ",Member,Associate;

            trigger OnValidate()
            begin
                // BBG1.01 ALLE 251012 START
                IF "Receiver Type" = "Receiver Type"::Member THEN BEGIN
                    IF Customer.GET("Customer No.") THEN BEGIN
                        "Received By" := Customer."No.";
                        "Receiver Name" := Customer.Name;
                    END;
                END ELSE BEGIN
                    "Received By" := '';
                    "Receiver Name" := '';
                END;
                // BBG1.01 ALLE 251012 END
            end;
        }
        field(50050; Type; Option)
        {
            Editable = false;
            OptionCaption = 'Regular,Direct';
            OptionMembers = Regular,Direct;
        }
        field(50051; "New Project Code"; Code[20])
        {
            Caption = 'Project Code for Gold Coin';
            DataClassification = ToBeClassified;
            Description = 'BBG2.0';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                IF "New Project Code" <> '' THEN BEGIN
                    GatePassLine.RESET;
                    GatePassLine.SETRANGE(GatePassLine."Document Type", "Document Type");
                    GatePassLine.SETRANGE("Document No.", "Document No.");
                    IF GatePassLine.FINDSET THEN
                        REPEAT
                            GatePassLine.VALIDATE("Location Code", "New Project Code");
                            GatePassLine.VALIDATE("Shortcut Dimension 1 Code", "New Project Code");
                            GatePassLine.MODIFY;
                        UNTIL GatePassLine.NEXT = 0;
                END;
            end;
        }
        field(50257; "Send for Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = '270923 Approval Workflow';
            Editable = false;
        }
        field(50258; "Send for Approval DT"; DateTime)
        {
            DataClassification = ToBeClassified;
            Description = '270923 Approval Workflow';
            Editable = false;
        }
        field(50259; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            Description = '270923 Approval Workflow';
            Editable = false;
            OptionCaption = ' ,Approved,Pending for Approval,Rejected';
            OptionMembers = " ",Approved,"Pending for Approval",Rejected;
        }
        field(80009; "Journal Lines Created"; Boolean)
        {
            Description = 'RAHEE1.00 020312';
        }
        field(80010; "Gold Coin"; Boolean)
        {
            Description = 'ALLEDK 220113';
            Editable = true;
        }
        field(80011; "Item Type"; Option)
        {
            OptionCaption = ' ,Gold,Silver,Gold_SilverVoucher,R194_Gift';
            OptionMembers = " ",Gold,Silver,Gold_SilverVoucher,R194_Gift;
        }
        field(80012; "Old Document No."; Code[20])
        {
        }
        field(80013; "Company Name"; Text[30])
        {
            Editable = true;
            TableRelation = Company;
        }
        field(80014; "Data TRansfered"; Boolean)
        {
        }
        field(80015; "App Transfer in LLp"; Boolean)
        {
            Editable = true;
        }
        field(80016; "Gold Post Date"; Date)
        {
        }
        field(80017; "Transfer LLP Name"; Text[50])
        {
            TableRelation = Company;
        }
        field(80028; "Silver Gram Eligibility"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(80029; "Application No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "New Confirmed Order"."No." WHERE("Customer No." = FIELD("Customer No."));
        }
        field(80030; "R194_Application No."; Text[500])
        {

            trigger OnLookup()
            var
                Conforder: Record "Confirmed Order";
                Conforder_2: Record "Confirmed Order";
                TotalClrAmt: Decimal;
                R194Giftsetup: Record "R194 Gift Setup";
                GatepassLines: Record "Gate Pass Line";
                R194UnitList: Page "R194 Unit List";


            begin
                GatepassLines.RESET;
                GatepassLines.SetRange("Document Type", "Document Type");
                GatepassLines.SetRange("Document No.", "Document No.");
                GatepassLines.SetFilter("Item No.", '<>%1', '');
                If GatepassLines.FindFirst() then
                    Error('Please delete the lines');

                R194Giftsetup.RESET;
                IF R194Giftsetup.FindFirst THEN BEGIN
                    Conforder.RESET;
                    Conforder.SetCurrentKey("Introducer Code", "Posting Date");
                    Conforder.SetRange("Introducer Code", "Vendor No.");
                    Conforder.SetFilter("Posting Date", '>=%1', R194Giftsetup."Start Date");
                    //  Conforder.SetRange("R194 Gift Issued", false);
                    //Conforder.CalcFields(Conforder."Total Cleared Received Amount");
                    IF Conforder.FindSet() then
                        repeat
                            Conforder.CalcFields(Conforder."Total Cleared Received Amount");
                            IF Conforder."Total Cleared Received Amount" >= Conforder.Amount THEN BEGIN
                                Conforder."App. applicable for issue R194" := True;
                                Conforder.Modify;
                                Commit;
                            END;
                        Until Conforder.Next = 0;
                END ELSE
                    Message('Setup is missing');


                Clear(R194UnitList);

                R194UnitList.LookupMode(True);
                //R194UnitList.SetRecord(Conforder_2);  //140525
                R194UnitList.SetAssociateValue(Rec."Vendor No.");
                IF R194UnitList.RUNMODAL = ACTION::LookupOK THEN
                    Rec."R194_Application No." := R194UnitList.GetSelectionFilter;


                IF Rec."R194_Application No." <> '' THEN
                    InsertEntriesintoGatepassline;


            end;


        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.")
        {
        }
        key(Key3; "Document No.", "Posting Date")
        {
        }
        key(Key4; "Cost Centre Name")
        {
        }
        key(Key5; "Purchase Order No.")
        {
        }
        key(Key6; "Shortcut Dimension 2 Code")
        {
        }
        key(Key7; "Issued By")
        {
        }
        key(Key8; "Shortcut Dimension 1 Code")
        {
        }
        key(Key9; "Posting Date", "Document No.", "Document Type")
        {
        }
        key(Key10; "Company Name", "Old Document No.")
        {
        }
        key(Key11; "App Transfer in LLp")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        MemberOf.RESET;
        MemberOf.SETRANGE("User Name", USERID);
        MemberOf.SETRANGE("Role ID", 'A_GOLDCOINHEADER');
        IF NOT MemberOf.FINDFIRST THEN
            ERROR('You do not have permission of role :A_GOLDCOINHEADER');

        //ERROR('You do not have permission to delete');
        TESTFIELD(Status, Status::Open);
        TESTFIELD("Sent for Verification", FALSE);
        //BBG1.00 260713
        GatePassLine.RESET;
        GatePassLine.SETRANGE(GatePassLine."Document Type", "Document Type");
        GatePassLine.SETRANGE(GatePassLine."Document No.", "Document No.");
        IF GatePassLine.FINDFIRST THEN
            GatePassLine.DELETEALL;
        //BBG1.00 260713
    end;

    trigger OnInsert()
    begin
        IF WORKDATE < 20080221D THEN
            ERROR('You can not work on this workdate');

        "Entered By" := USERID;
        CompInfo.GET;
        "Location Code" := CompInfo."Location Code";
        "Document Date" := WORKDATE;
        "Posting Date" := WORKDATE;
        "Entered By" := USERID;
        //NDALLE081205

        IF (("Document Type" = "Document Type"::MIN) AND ("Document No." = '')) THEN BEGIN
            PurAndPay.GET;
            PurAndPay.TESTFIELD("Material Issue Note");
            NoSeriesMgt.InitSeries(PurAndPay."Material Issue Note", xRec."MIN No. Series", WORKDATE, "Document No.", "MIN No. Series");
        END;

        IF (("Document Type" = "Document Type"::"Material Return") AND ("Document No." = '')) THEN BEGIN
            PurAndPay.GET;
            PurAndPay.TESTFIELD("Material Return Note");
            NoSeriesMgt.InitSeries(PurAndPay."Material Return Note", xRec."MRN No. Series", WORKDATE, "Document No.", "MRN No. Series");
        END;

        IF (("Document Type" = "Document Type"::"Outward Gatepass") AND ("Document No." = '')) THEN BEGIN
            PurAndPay.GET;
            PurAndPay.TESTFIELD("Outward Gate Pass");
            NoSeriesMgt.InitSeries(PurAndPay."Outward Gate Pass", xRec."OWGP No. Series", WORKDATE, "Document No.", "OWGP No. Series");
        END;

        IF (("Document Type" = "Document Type"::"Inward Gatepass") AND ("Document No." = '')) THEN BEGIN
            PurAndPay.GET;
            PurAndPay.TESTFIELD("Inward Gate Pass");
            NoSeriesMgt.InitSeries(PurAndPay."Inward Gate Pass", xRec."IWGP No. Series", WORKDATE, "Document No.", "IWGP No. Series");
        END;


        IF (("Document Type" = "Document Type"::"Consumption FOC") AND ("Document No." = '')) THEN BEGIN
            PurAndPay.GET;
            PurAndPay.TESTFIELD(PurAndPay."Consumption FOC Nos.");
            NoSeriesMgt.InitSeries(PurAndPay."Consumption FOC Nos.",
            xRec."Consumption FOC Nos.", WORKDATE, "Document No.", "Consumption FOC Nos.");

        END;

        IF (("Document Type" = "Document Type"::"Consumption Chargable") AND ("Document No." = '')) THEN BEGIN
            PurAndPay.GET;
            PurAndPay.TESTFIELD(PurAndPay."Consumption Chargable Nos.");
            NoSeriesMgt.InitSeries(PurAndPay."Consumption Chargable Nos.", xRec."Consumption Chargeable Nos.",
            WORKDATE, "Document No.", "Consumption Chargeable Nos.");
        END;

        //RAHEE1.00 060512
        IF (("Document Type" = "Document Type"::"Finished Goods") AND ("Document No." = '')) THEN BEGIN
            PurAndPay.GET;
            PurAndPay.TESTFIELD(PurAndPay."FG Recipt Nos.");
            NoSeriesMgt.InitSeries(PurAndPay."FG Recipt Nos.", xRec."Consumption Chargeable Nos.",
            WORKDATE, "Document No.", "FG Recipt Nos.");
        END;
        //RAHEE1.00 060512
        //NDALLE081205

        //ALLE-SR-051107 >>
        "Responsibility Center" := UserMgt.GetRespCenter(1, "Responsibility Center");
        //ALLE-SR-051107 <<

        //ALLEND 191107
        RecUserSetup.RESET;
        RecUserSetup.SETRANGE("User ID", "Entered By");
        IF RecUserSetup.FIND('-') THEN BEGIN
            RecRespCenter.RESET;
            RecRespCenter.SETRANGE(Code, RecUserSetup."Purchase Resp. Ctr. Filter");
            IF RecRespCenter.FIND('-') THEN BEGIN
                "Shortcut Dimension 1 Code" := RecRespCenter."Global Dimension 1 Code";
                "Location Code" := RecRespCenter."Location Code";
                "Job No." := RecRespCenter."Job Code";
                "New Project Code" := RecRespCenter."Global Dimension 1 Code";  //251121 Code added
            END;
        END;
        //ALLEND 191107
        //VALIDATE("Entered By")
    end;

    trigger OnModify()
    begin
        // TESTFIELD(Status,Status::Open);
    end;

    var
        GatePassLine: Record "Gate Pass Line";
        DimValue: Record "Dimension Value";
        Vendor: Record Vendor;
        PurchHeader: Record "Purchase Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurAndPay: Record "Purchases & Payables Setup";
        CompInfo: Record "Company Information";
        Employee: Record Employee;
        UserMgt: Codeunit "EPC User Setup Management";
        RespCenter: Record "Responsibility Center 1";
        DimMgt: Codeunit DimensionManagement;
        Text028: Label 'Your identification is set up to process from %1 %2 only.';
        Customer: Record Customer;
        Short1name: Text[30];
        Respname: Text[30];
        Locname: Text[30];
        RecDimValue: Record "Dimension Value";
        RecLocation: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        RecUserSetup: Record "User Setup";
        RecUser: Record User;
        Text50111: Label 'Journal line have been successfully %1.';
        MemberOf: Record "Access Control";


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);

        // ALLE MM Code Commented +
        /*
        IF "Document No." <> '' THEN BEGIN
          DimMgt.SaveDocDim(
            DATABASE::"Gate Pass Header","Document Type","Document No.",0,FieldNumber,ShortcutDimCode);
          MODIFY;
        END ELSE
          DimMgt.SaveTempDim(FieldNumber,ShortcutDimCode);
        */
        // ALLE MM Code Commented

    end;


    procedure CreateServiceItem(GatePassHdr: Record "Gate Pass Header")
    var
        GatePassLine2: Record "Gate Pass Line";
        ServItemComponent: Record "Service Item Component";
        ItemTrackingCode: Record "Item Tracking Code";
        BOMComp: Record "BOM Component";
        BOMComp2: Record "BOM Component";
        TrackingLinesExist: Boolean;
        x: Integer;
        ServMgtSetup: Record "Service Mgt. Setup";
        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        ServItemGr: Record "Service Item Group";
        ServiceItemTEMP: Record "Service Item" temporary;
        ServiceItemCompTEMP: Record "Service Item Component" temporary;
        ServItem: Record "Service Item";
        TempReservEntry: Record "Reservation Entry" temporary;
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        ServLogMgt: Codeunit ServLogManagement;
        Job: Record Job;
    begin
        // RAHEE1.00 020312 Start
        GatePassLine2.RESET;
        GatePassLine2.SETRANGE("Document Type", GatePassHdr."Document Type");
        GatePassLine2.SETRANGE("Document No.", GatePassHdr."Document No.");
        IF GatePassLine2.FINDFIRST THEN
            REPEAT
                ServMgtSetup.GET;
                GLSetup.GET;

                //IF (SalesLine.Type = SalesLine.Type::Item) AND (SalesLine."Qty. to Ship (Base)" > 0) THEN BEGIN
                Item.GET(GatePassLine2."Item No.");
                //IF NOT ItemTrackingCode.GET(Item."Item Tracking Code") THEN
                //ItemTrackingCode.INIT;
                IF ServItemGr.GET(Item."Service Item Group") AND ServItemGr."Create Service Item" THEN BEGIN
                    //IF SalesLine."Qty. to Ship (Base)" <> ROUND(SalesLine."Qty. to Ship (Base)",1) THEN
                    //ERROR(
                    //Text003,
                    //Item.TABLECAPTION,
                    //Item."No.",
                    //ServItemGr.TABLECAPTION,
                    //SalesLine.FIELDCAPTION("Qty. to Ship (Base)"));

                    TempReservEntry.SETRANGE("Item No.", GatePassLine2."Item No.");
                    TempReservEntry.SETRANGE("Location Code", GatePassLine2."Location Code");
                    //TempReservEntry.SETRANGE("Variant Code",GatePassLine2."Variant Code");
                    TempReservEntry.SETRANGE("Source Subtype", GatePassLine2."Document Type");
                    TempReservEntry.SETRANGE("Source ID", GatePassLine2."Document No.");
                    TempReservEntry.SETRANGE("Source Ref. No.", GatePassLine2."Line No.");
                    TrackingLinesExist := TempReservEntry.FINDFIRST;

                    ServiceItemTEMP.DELETEALL;
                    ServiceItemCompTEMP.DELETEALL;

                    FOR x := 1 TO GatePassLine2.Qty DO BEGIN
                        CLEAR(ServItem);
                        ServItem.INIT;
                        ServMgtSetup.TESTFIELD("Service Item Nos.");
                        NoSeriesMgt.InitSeries(
                          ServMgtSetup."Service Item Nos.", ServItem."No. Series", 0D, ServItem."No.", ServItem."No. Series");
                        ServItem.INSERT;
                        //ServItem."Sales/Serv. Shpt. Document No." := SalesShipmentLine."Document No.";
                        //ServItem."Sales/Serv. Shpt. Line No." := SalesShipmentLine."Line No.";
                        //ServItem."Shipment Type" := ServItem."Shipment Type"::Sales;
                        ServItem.VALIDATE(Description,
                          COPYSTR(GatePassLine2.Description, 1, MAXSTRLEN(ServItem.Description)));
                        ServItem."Description 2" := COPYSTR(
                            STRSUBSTNO('%1 %2', GatePassHdr."Document Type", GatePassHdr."Document No."),
                            1, MAXSTRLEN(ServItem."Description 2"));
                        IF Job.GET(GatePassHdr."Job No.") THEN
                            ServItem.VALIDATE("Customer No.", Job."Bill-to Customer No.");
                        //ServItem.VALIDATE("Ship-to Code",SalesHeader."Ship-to Code");
                        //ServItem.OmitAssignResSkills(TRUE);
                        ServItem.VALIDATE("Item No.", Item."No.");
                        //ServItem.OmitAssignResSkills(FALSE);
                        IF TrackingLinesExist THEN
                            ServItem."Serial No." := TempReservEntry."Serial No.";
                        //ServItem."Variant Code" := GatePassLine2."Variant Code";
                        ServItem."MIN No" := GatePassLine2."Document No.";
                        ServItem."MIN Line No" := GatePassLine2."Line No.";
                        // AIR0009 150211
                        //ServItem."Vendor Name" := TempReservEntry."Vendor Name";
                        //ServItem."Warranty Starting Date" := TempReservEntry."Purchase Warranty Start Date";
                        //ServItem."Warranty Ending Date" := TempReservEntry."Purchase Warranty End Date";
                        //ServItem."Vendor Invoice No." := TempReservEntry."Vendor Invoice No.";
                        //IF Customer.GET(SalesHeader."Sell-to Customer No.") THEN BEGIN
                        //ServItem."Phone No. 2" := Customer."Phone No. 2";
                        //ServItem."Phone No. 3" := Customer."Phone No. 3";
                        //END;
                        // AIR0009 150211

                        ItemUnitOfMeasure.GET(Item."No.", GatePassLine2."Unit of Measure");

                        ServItem.VALIDATE("Sales Unit Cost", ROUND(GatePassLine2."Unit Cost" /
                          ItemUnitOfMeasure."Qty. per Unit of Measure", GLSetup."Unit-Amount Rounding Precision"));
                        /*
                        IF SalesHeader."Currency Code" <> '' THEN
                          ServItem.VALIDATE(
                            "Sales Unit Price",
                            AmountToLCY(
                              ROUND(SalesLine."Unit Price"/
                                ItemUnitOfMeasure."Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision"),
                              SalesHeader."Currency Factor",
                              SalesHeader."Currency Code",
                              SalesHeader."Posting Date"))
                        */
                        //ELSE
                        //ServItem.VALIDATE("Sales Unit Price",ROUND(SalesLine."Unit Price"/
                        // ItemUnitOfMeasure."Qty. per Unit of Measure",GLSetup."Unit-Amount Rounding Precision"));
                        ServItem."Vendor No." := Item."Vendor No.";
                        ServItem."Vendor Item No." := Item."Vendor Item No.";
                        ServItem."Unit of Measure Code" := Item."Base Unit of Measure";
                        ServItem."Sales Date" := GatePassHdr."Posting Date";
                        ServItem."Installation Date" := GatePassHdr."Posting Date";
                        ServItem."Warranty % (Parts)" := ServMgtSetup."Warranty Disc. % (Parts)";
                        ServItem."Warranty % (Labor)" := ServMgtSetup."Warranty Disc. % (Labor)";
                        ServItem."Warranty Starting Date (Parts)" := GatePassHdr."Posting Date";
                        IF FORMAT(ItemTrackingCode."Warranty Date Formula") <> '' THEN
                            ServItem."Warranty Ending Date (Parts)" :=
                              CALCDATE(ItemTrackingCode."Warranty Date Formula", GatePassHdr."Posting Date")
                        ELSE
                            ServItem."Warranty Ending Date (Parts)" :=
                              CALCDATE(
                                ServMgtSetup."Default Warranty Duration",
                                GatePassHdr."Posting Date");
                        ServItem."Warranty Starting Date (Labor)" := GatePassHdr."Posting Date";
                        ServItem."Warranty Ending Date (Labor)" :=
                          CALCDATE(
                            ServMgtSetup."Default Warranty Duration",
                            GatePassHdr."Posting Date");

                        // AIR0010 160211
                        ServItem.Status := ServItem.Status::" ";
                        ServItem."Installation Date" := 0D;
                        ServItem."Warranty Starting Date (Labor)" := 0D;
                        ServItem."Warranty Ending Date (Labor)" := 0D;
                        // AIR0010 160211

                        ServItem.MODIFY;
                        CLEAR(ServiceItemTEMP);
                        ServiceItemTEMP := ServItem;
                        IF ServiceItemTEMP.INSERT THEN;
                        //ResSkillMgt.AssignServItemResSkills(ServItem);
                        /*
                        IF SalesLine."BOM Item No." <> '' THEN BEGIN
                          CLEAR(BOMComp);
                          BOMComp.SETRANGE("Parent Item No.",SalesLine."BOM Item No.");
                          BOMComp.SETRANGE(Type,BOMComp.Type::Item);
                          BOMComp.SETRANGE("No.",SalesLine."No.");
                          BOMComp.SETRANGE("Installed in Line No.",0);
                          IF BOMComp.FINDSET THEN
                            REPEAT
                              CLEAR(BOMComp2);
                              BOMComp2.SETRANGE("Parent Item No.",SalesLine."BOM Item No.");
                              BOMComp2.SETRANGE("Installed in Line No.",BOMComp."Line No.");
                              NextLineNo := 0;
                              IF BOMComp2.FINDSET THEN
                                REPEAT
                                  FOR Index := 1 TO ROUND(BOMComp2."Quantity per",1) DO BEGIN
                                    NextLineNo := NextLineNo + 10000;
                                    ServItemComponent.INIT;
                                    ServItemComponent.Active := TRUE;
                                    ServItemComponent."Parent Service Item No." := ServItem."No.";
                                    ServItemComponent."Line No." := NextLineNo;
                                    ServItemComponent.Type := ServItemComponent.Type::Item;
                                    ServItemComponent."No." := BOMComp2."No.";
                                    ServItemComponent."Date Installed" := SalesHeader."Posting Date";
                                    ServItemComponent.Description := BOMComp2.Description;
                                    ServItemComponent."Serial No." := '';
                                    ServItemComponent."Variant Code" := BOMComp2."Variant Code";
                                    ServItemComponent.INSERT;
                                    CLEAR(ServiceItemCompTEMP);
                                    ServiceItemCompTEMP := ServItemComponent;
                                    ServiceItemCompTEMP.INSERT;
                                  END;
                                UNTIL BOMComp2.NEXT = 0;
                            UNTIL BOMComp.NEXT = 0;
                        END;
                        */
                        CLEAR(ServLogMgt);
                        ServLogMgt.ServItemAutoCreated(ServItem);
                        TrackingLinesExist := TempReservEntry.NEXT = 1;
                    END;
                END;
            //END;

            UNTIL GatePassLine2.NEXT = 0;
        // RAHEE1.00 020312 End

    end;


    procedure DeleteJournalLine()
    var
        DelItemJournalLine: Record "Job Journal Line";
    begin
        // RAHEE1.00 020312 Start
        GatePassLine.RESET;
        GatePassLine.SETRANGE("Document Type", "Document Type");
        GatePassLine.SETRANGE("Document No.", "Document No.");
        GatePassLine.SETRANGE(GatePassLine."Journal Line Created", TRUE);
        IF GatePassLine.FIND('-') THEN
            REPEAT
                DelItemJournalLine.RESET;
                DelItemJournalLine.SETRANGE("Journal Template Name", 'MIN');
                DelItemJournalLine.SETRANGE("Journal Batch Name", 'Min');
                DelItemJournalLine.SETRANGE("Document No.", "Document No.");
                DelItemJournalLine.SETRANGE("MIN Line No.", GatePassLine."Line No.");
                IF DelItemJournalLine.FINDFIRST THEN
                    DelItemJournalLine.DELETE(TRUE);
                ;
                GatePassLine."Journal Line Created" := FALSE;
                GatePassLine.MODIFY;
            UNTIL GatePassLine.NEXT = 0;
        MESSAGE(Text50111, 'Deleted');
        // RAHEE1.00 020312 End
    end;

    procedure InsertEntriesintoGatepassline()
    Var

        R194GiftSetup: Record "R194 Gift Setup";
        GatePassLines: Record "Gate Pass Line";
        ConfOrder: Record "Confirmed Order";
        TotalExtent: Decimal;
        GatePassHeader: Record "Gate Pass Header";
        GiftTotalExt: Decimal;
        LineNo: integer;
        Confirmedorder: Record "Confirmed Order";
        IssuedTotalExtent: Decimal;
        Confirmedorder_1: Record "Confirmed Order";
        OldGatePassLine: Record "Gate Pass Line";
        OldGatePassHeader: Record "Gate Pass Header";
        Confirmedorder_2: Record "Confirmed Order";
        CurrentTotalExtent: Decimal;
        ElegTotalExtent: Decimal;
        UpdateCurrentExt: Decimal;


    begin

        TotalExtent := 0;
        GiftTotalExt := 0;
        CurrentTotalExtent := 0;
        Confirmedorder.RESET;
        Confirmedorder.SetFilter("No.", Rec."R194_Application No.");
        Confirmedorder.SetRange("R194 Gift Issued", False);
        IF Confirmedorder.FindSet() then
            repeat
                ElegTotalExtent := ElegTotalExtent + Confirmedorder."Saleable Area";


            Until Confirmedorder.Next = 0;

        UpdateCurrentExt := ElegTotalExtent;

        Confirmedorder_2.RESET;
        Confirmedorder_2.SetCurrentKey("Introducer Code");
        Confirmedorder_2.SetRange("Introducer Code", Rec."Vendor No.");
        //Confirmedorder_2.SetFilter("No.", OldGatePassHeader."R194_Application No.");
        Confirmedorder_2.SetRange("R194 Gift Issued", True);
        IF Confirmedorder_2.FindSet() then
            repeat
                CurrentTotalExtent := CurrentTotalExtent + Confirmedorder_2."Saleable Area";
            Until Confirmedorder_2.Next = 0;


        IF ElegTotalExtent > 0 THEN BEGIN
            OldGatePassHeader.RESET;
            OldGatePassHeader.SetCurrentKey("Document Type", "Vendor No.", "Item Type", Status);
            OldGatePassHeader.SetRange("Document Type", OldGatePassHeader."Document Type"::MIN);
            OldGatePassHeader.SetRange("Vendor No.", Rec."Vendor No.");
            OldGatePassHeader.SetRange("Item Type", OldGatePassHeader."Item Type"::R194_Gift);
            OldGatePassHeader.SetRange(Status, OldGatePassHeader.Status::Close);
            IF OldGatePassHeader.FindSet() then
                repeat
                    OldGatePassLine.RESET;
                    OldGatePassLine.SetRange("Document Type", Rec."Document Type");
                    OldGatePassLine.SetRange("Document No.", OldGatePassHeader."Document No.");
                    IF OldGatePassLine.FindSet() then
                        repeat
                            IssuedTotalExtent := IssuedTotalExtent + OldGatePassLine.Extent;
                        Until OldGatePassLine.Next = 0;


                Until OldGatePassHeader.Next = 0;


            if (CurrentTotalExtent - IssuedTotalExtent) > 2 THEN begin
                ElegTotalExtent := ElegTotalExtent + CurrentTotalExtent;
                UpdateCurrentExt := UpdateCurrentExt + CurrentTotalExtent - IssuedTotalExtent;
            END ELSE
                ElegTotalExtent := ElegTotalExtent + IssuedTotalExtent + 0.01;


            IssuedTotalExtent := IssuedTotalExtent + 0.01;

            R194GiftSetup.RESET;
            R194GiftSetup.SetFilter("Start Date", '<=%1', Rec."Posting Date");
            R194GiftSetup.SetRange(Extent, IssuedTotalExtent, ElegTotalExtent);
            IF R194GiftSetup.FindSet() then
                repeat
                    LineNo := LineNo + 10000;
                    GatePassLines.RESET;
                    GatePassLines.init;
                    GatePassLines."Document Type" := GatePassLines."Document Type"::MIN;
                    GatePassLines."Document No." := Rec."Document No.";
                    GatePassLines."Line No." := LineNo;
                    GatePassLines.insert;
                    GatePassLines.validate("Item No.", R194GiftSetup."Gift Item No.");
                    GatePassLines."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                    //GatePassLines."Shortcut Dimension 2 Code" := GatePassHeader."Shortcut Dimension 2 Code";
                    GatePassLines."Location Code" := Rec."Location Code";
                    GatePassLines."R194_Application No." := rec."R194_Application No.";
                    GatePassLines.Validate("Required Qty", 1);
                    GatePassLines.Validate(Qty, 1);
                    If LineNo = 10000 then
                        GatePassLines.Extent := UpdateCurrentExt;
                    GatePassLines.modify;
                Until R194GiftSetup.Next = 0;

        END ELSE BEGIN
            R194GiftSetup.RESET;
            R194GiftSetup.SetFilter("Start Date", '<=%1', Rec."Posting Date");
            R194GiftSetup.SetRange(Extent, 1, CurrentTotalExtent);
            IF R194GiftSetup.FindSet() then begin
                repeat
                    OldGatePassLine.RESET;
                    OldGatePassLine.SetRange("Document Type", Rec."Document Type");
                    //OldGatePassLine.SetRange("Document No.", OldGatePassHeader."Document No.");
                    OldGatePassLine.SetRange("Vendor No.", Rec."Vendor No.");
                    OldGatePassLine.SetRange("Item No.", R194GiftSetup."Gift Item No.");
                    IF NOT OldGatePassLine.FindFirst() then begin
                        LineNo := LineNo + 10000;
                        GatePassLines.RESET;
                        GatePassLines.init;
                        GatePassLines."Document Type" := GatePassLines."Document Type"::MIN;
                        GatePassLines."Document No." := Rec."Document No.";
                        GatePassLines."Line No." := LineNo;
                        GatePassLines.insert;
                        GatePassLines.validate("Item No.", R194GiftSetup."Gift Item No.");
                        GatePassLines."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                        //GatePassLines."Shortcut Dimension 2 Code" := GatePassHeader."Shortcut Dimension 2 Code";
                        GatePassLines."Location Code" := Rec."Location Code";
                        GatePassLines."R194_Application No." := rec."R194_Application No.";
                        GatePassLines.Validate("Required Qty", 1);
                        GatePassLines.Validate(Qty, 1);
                        GatePassLines.modify;
                    end;
                Until R194GiftSetup.Next = 0;
            END;

        END;
    END;

}

