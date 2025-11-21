table 97728 "Purchase Request Header"
{
    // //JPL
    // //ALLE-SR-051107 : Responsibilty center added
    // //ALLE-PKS03 01for Setting the Send For Approval to the indent lines
    // //ALLE-PKS03 02 For Updating the Indent lines for Appoval
    // //ALLE-PKS 08 for short closing the indent
    // //ALLE-PKS17 For Document type Setup Errror
    // //ALLE-PKS36 for setting indent date as today
    // //added by dds for FA Indents
    // ALLEAB : New fields added
    // //AlleBLK : New fields added
    // //NDALLE061205 : Write code
    // ALLERP KRN0014 09-09-2010: Code added for inserting job No.
    // ALLERP BugFix  22-11-2010: Remove the option caption 'others' of Indent type
    // ALLERP BugFix  24-11-2010: Caption of all indent fields has been changed to purchase request
    // ALLERP BugFix  22-12-2010: Code added for checking supply and service lines

    DrillDownPageID = "Purchase Request List";
    LookupPageID = "Purchase Request List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'Indent';
            OptionMembers = Indent;

            trigger OnValidate()
            begin
                "Indent Date" := WORKDATE;
            end;
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                //MODIFY;
                DimValue.RESET;
                DimValue.SETRANGE(Code, "Shortcut Dimension 1 Code");
                IF DimValue.FIND('-') THEN
                    "Cost Centre Name" := DimValue.Name;

                //NDALLE061205

                IndLine.RESET;
                IndLine.SETFILTER(IndLine."Document Type", '%1', "Document Type");
                IndLine.SETRANGE("Document No.", "Document No.");
                IF IndLine.FIND('-') THEN BEGIN
                    IF CONFIRM('Are you sure you want to Change Cost Centre Code in Lines?', FALSE) THEN BEGIN
                        REPEAT
                            IndLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                            IndLine."Cost Centre Name" := "Cost Centre Name";
                            IndLine.MODIFY(TRUE);
                        UNTIL IndLine.NEXT = 0;
                    END;
                END;
                //NDALLE061205
            end;
        }
        field(4; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                /*//ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
                //MODIFY;
                
                //NDALLE061205
                DimValue.RESET;
                DimValue.SETRANGE(Code,"Shortcut Dimension 2 Code");
                IF DimValue.FIND('-') THEN
                  "Department Name" := DimValue.Name;
                
                IndLine.RESET;
                IndLine.SETFILTER(IndLine."Document Type",'%1',"Document Type");
                IndLine.SETRANGE("Document No.","Document No.");
                IF IndLine.FIND('-') THEN BEGIN
                  IF CONFIRM('Are you sure you want to Change Department Code in Lines?',FALSE) THEN BEGIN
                    REPEAT
                      IndLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                      IndLine."Department Name" := DimValue.Name;
                      IndLine.MODIFY(TRUE);
                    UNTIL IndLine.NEXT =0;
                  END;
                END;
                //NDALLE061205
                 */

            end;
        }
        field(5; "Indent Date"; Date)
        {
            Caption = 'Purch. Req. Date';

            trigger OnValidate()
            begin
                //NDALLE061205
                IndLine.RESET;
                IndLine.SETFILTER(IndLine."Document Type", '%1', "Document Type");
                IndLine.SETRANGE("Document No.", "Document No.");
                IF IndLine.FIND('-') THEN BEGIN
                    REPEAT
                        IndLine."Indent Date" := "Indent Date";
                        IndLine.MODIFY(TRUE);
                    UNTIL IndLine.NEXT = 0;
                END;
                //NDALLE061205
            end;
        }
        field(7; "Indent Status"; Option)
        {
            Caption = 'Purch. Req. Status';
            Description = 'ALLE-PKS 08 added an option short close for the same functionality';
            OptionCaption = 'Open,Closed,Cancelled,Short Closed';
            OptionMembers = Open,Closed,Cancelled,"Short Closed";

            trigger OnValidate()
            begin
                //NDALLE061205
                IndLine.RESET;
                IndLine.SETFILTER(IndLine."Document Type", '%1', "Document Type");
                IndLine.SETRANGE("Document No.", "Document No.");
                IF IndLine.FIND('-') THEN BEGIN
                    REPEAT
                        IndLine."Indent Status" := "Indent Status";
                        IndLine.MODIFY(TRUE);
                    UNTIL IndLine.NEXT = 0;
                END;
                //NDALLE061205
            end;
        }
        field(8; "Location code"; Code[20])
        {
            TableRelation = Location;

            trigger OnValidate()
            begin
                TESTFIELD(Approved, FALSE);
                //NDALLE061205
                IndLine.RESET;
                IndLine.SETFILTER(IndLine."Document Type", '%1', "Document Type");
                IndLine.SETRANGE("Document No.", "Document No.");
                IF IndLine.FIND('-') THEN BEGIN
                    REPEAT
                        IndLine."Location code" := "Location code";
                        IndLine.MODIFY(TRUE);
                    UNTIL IndLine.NEXT = 0;
                END;
                //NDALLE061205
            end;
        }
        field(9; Requirement; Option)
        {
            OptionCaption = 'Normal, Urgent, Most Urgent, Critical';
            OptionMembers = Normal," Urgent"," Most Urgent"," Critical";
        }
        field(10; "Indentors Justification"; Text[200])
        {
            Caption = 'Requestor Justification';
        }
        field(12; "Required By Date"; Date)
        {
            Caption = 'Required By Date';

            trigger OnValidate()
            var
                CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
            begin
            end;
        }
        field(13; "Item Category Code"; Code[20])
        {
            TableRelation = "Item Category";

            trigger OnValidate()
            begin
                ItemCategory.RESET;
                ItemCategory.SETRANGE(ItemCategory.Code, "Item Category Code");
                IF ItemCategory.FIND('-') THEN
                    "Item Category Name" := ItemCategory.Description;
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(50003; Approved; Boolean)
        {
            Description = 'AlleBLK';

            trigger OnValidate()
            begin
                IF Approved THEN BEGIN
                    TESTFIELD("Shortcut Dimension 1 Code");
                    //TESTFIELD("Shortcut Dimension 2 Code");
                    IndLine.RESET;
                    IndLine.SETRANGE("Document Type", "Document Type");
                    IndLine.SETRANGE("Document No.", "Document No.");
                    IF IndLine.FIND('-') THEN BEGIN
                        REPEAT

                            IF IndLine.Type = IndLine.Type::"Fixed Asset" THEN BEGIN
                                IndLine.TESTFIELD("FA SubGroup");
                            END;

                            IF (IndLine.Type = IndLine.Type::"G/L Account") OR (IndLine.Type = IndLine.Type::Item) THEN BEGIN
                                IndLine.TESTFIELD("No.");
                            END;

                            IndLine.TESTFIELD("Shortcut Dimension 1 Code");
                            //IndLine.TESTFIELD("Shortcut Dimension 2 Code");
                            //IndLine.TESTFIELD("Purchaser Code");
                            IndLine.Approved := TRUE;
                            ;
                            IndLine.MODIFY(TRUE);
                        UNTIL IndLine.NEXT = 0;
                    END;
                END;

                //ALLE-PKS03
                IndLine.RESET;
                IndLine.SETRANGE(IndLine."Document No.", "Document No.");
                IF IndLine.FIND('-') THEN
                    REPEAT
                        IndLine.VALIDATE(Approved, TRUE);
                    UNTIL IndLine.NEXT = 0;
                //ALLE-PKS03
            end;
        }
        field(50004; "Approved Date"; Date)
        {
            Description = 'AlleBLK';
        }
        field(50005; "Approved Time"; Time)
        {
            Description = 'AlleBLK';
        }
        field(50010; Indentor; Code[50])
        {
            Caption = 'Requestor';
            Description = 'AlleBLK';
            TableRelation = User."User Name";

            trigger OnValidate()
            begin
                //NDALLE071205
                IndLine.RESET;
                IndLine.SETRANGE("Document Type", "Document Type");
                IndLine.SETRANGE("Document No.", "Document No.");
                IF IndLine.FIND('-') THEN BEGIN
                    REPEAT
                        IndLine.Indentor := Indentor;
                        IndLine.MODIFY(TRUE);
                    UNTIL IndLine.NEXT = 0;
                END;
                //NDALLE071205
            end;
        }
        field(50016; "Sent for Approval"; Boolean)
        {
            Description = 'AlleBLK';

            trigger OnValidate()
            begin
                //ALLE-PKS03
                IndLine.RESET;
                IndLine.SETFILTER(IndLine."Document No.", "Document No.");
                IF IndLine.FIND('-') THEN
                    REPEAT
                        IndLine.VALIDATE("Sent for Approval", TRUE);
                        IndLine.MODIFY;
                    UNTIL IndLine.NEXT = 0;
                //ALLE-PKS03
            end;
        }
        field(50017; "Creation Date"; Date)
        {
            Description = 'AlleBLK';
        }
        field(50018; "Creation Time"; Time)
        {
            Description = 'AlleBLK';
        }
        field(50019; "Sent for Approval Date"; Date)
        {
            Description = 'AlleBLK';
        }
        field(50020; "Sent for Approval Time"; Time)
        {
            Description = 'AlleBLK';
        }
        field(50021; "Indent No. Series"; Code[20])
        {
            Caption = 'PR No. Series';
            Description = 'AlleBLK';
            TableRelation = "No. Series";
        }
        field(50022; "Cost Centre Name"; Text[60])
        {
            Description = 'AlleBLK';
        }
        field(50023; "Department Name"; Text[60])
        {
            Description = 'AlleBLK';
        }
        field(50024; "Purchaser Code"; Code[20])
        {
            Description = 'AlleBLK';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            begin
                /*
                IF "Purchaser Code"<>'' THEN
                  Employee.GET("Purchaser Code");
                
                "Purchaser Name" :=Employee."First Name" + ' ' + Employee."Middle Name" + ' ' +  Employee."Last Name";
                
                IndLine.RESET;
                IndLine.SETFILTER(IndLine."Document Type",'%1',"Document Type");
                IndLine.SETRANGE("Document No.","Document No.");
                IF IndLine.FIND('-') THEN BEGIN
                  //IF CONFIRM('Are you sure you want to change Purchaser Code in Lines?',FALSE) THEN BEGIN
                    REPEAT
                      IndLine."Purchaser Code" := "Purchaser Code";
                      IndLine.MODIFY(TRUE);
                    UNTIL IndLine.NEXT =0;
                  //END;
                END;
                //NDALLE061205
                 */

            end;
        }
        field(50025; "Indent Value"; Decimal)
        {
            CalcFormula = Sum("Purchase Request Line".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                                    "Document No." = FIELD("Document No.")));
            Caption = 'Purch. Req. Value';
            Description = 'AlleBLK';
            FieldClass = FlowField;
        }
        field(50026; "Indentor Name"; Text[90])
        {
            Caption = 'Requestor Name';
            Description = 'AlleBLK';
        }
        field(50027; "Item Category Name"; Text[60])
        {
            Description = 'AlleBLK';
        }
        field(50028; "Purchaser Name"; Text[90])
        {
            Description = 'AlleBLK';
        }
        field(50029; "Responsibility Center"; Code[10])
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

                VALIDATE("Location code", UserMgt.GetLocation(1, '', "Responsibility Center"));

                //ALLE-SR-051107 <<
            end;
        }
        field(50030; "FA Sub Group"; Text[50])
        {
            Description = 'added by dds for FA Indents';
            Editable = false;
        }
        field(50031; Item; Text[50])
        {
            Description = 'added by dds for FA Indents';
            Editable = false;
        }
        field(50032; "FA Code"; Code[10])
        {
            Description = 'added by dds for FA Indents';
            TableRelation = "Fixed Asset Sub Group"."FA Code";

            trigger OnValidate()
            begin
                //dds - added
                FAItem.RESET;
                Item := '';
                Capacity := '';
                "FA Sub Group" := '';

                FAItem.SETRANGE(FAItem."FA Code", "FA Code");
                IF FAItem.FIND('-') THEN BEGIN
                    Item := FAItem.Item;
                    Capacity := FAItem.Capacity;
                    "FA Sub Group" := FAItem."FA Sub Group";

                END;
            end;
        }
        field(50033; Capacity; Text[30])
        {
            Description = 'added by dds for FA Indents';
            Editable = false;
        }
        field(50036; "Job Code"; Code[20])
        {
            Description = 'AlleDK  NTPC';
            TableRelation = Job."No." WHERE("Global Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"));

            trigger OnValidate()
            begin
                TESTFIELD(Approved, FALSE);
            end;
        }
        field(50037; "Indent Type"; Option)
        {
            Caption = 'Purch. Req. Type';
            OptionCaption = 'Supply,Services';
            OptionMembers = Supply,Services,Others;

            trigger OnValidate()
            begin
                //CheckIndentStatus; // ALLEAA
                //ALLERP BugFix 22-12-2010: Start:
                IF "Indent Type" = "Indent Type"::Supply THEN BEGIN
                    IndLine.RESET;
                    IndLine.SETRANGE("Document Type", "Document Type");
                    IndLine.SETRANGE("Document No.", "Document No.");
                    IndLine.SETRANGE(Type, IndLine.Type::"G/L Account");
                    IF IndLine.FINDFIRST THEN
                        ERROR(Text50001)
                END ELSE BEGIN
                    IndLine.RESET;
                    IndLine.SETRANGE("Document Type", "Document Type");
                    IndLine.SETRANGE("Document No.", "Document No.");
                    IndLine.SETRANGE(Type, IndLine.Type::Item);
                    IF IndLine.FINDFIRST THEN
                        ERROR(Text50002);

                END;
                //ALLERP BugFix 22-12-2010: End:
            end;
        }
        field(50098; "Workflow Approval Status"; Option)
        {
            Caption = 'Workflow Approval Status';
            DataClassification = ToBeClassified;
            Description = 'X';
            Editable = true;
            OptionCaption = 'Open,Released,Pending Approval';
            OptionMembers = Open,Released,"Pending Approval";

            trigger OnValidate()
            begin
                TESTFIELD("Shortcut Dimension 1 Code");
                // IF ClientMgmt.Dimension2CodeMandatory THEN
                // TESTFIELD("Shortcut Dimension 2 Code");
                IndLine.RESET;
                IndLine.SETRANGE("Document Type", "Document Type");
                IndLine.SETRANGE("Document No.", "Document No.");
                IF IndLine.FIND('-') THEN BEGIN
                    REPEAT
                        //    IF IndLine.Type=IndLine.Type::"Fixed Asset" THEN
                        //    IndLine.TESTFIELD("FA Sub Group Code");
                        IF (IndLine.Type = IndLine.Type::"G/L Account") OR (IndLine.Type = IndLine.Type::Item) THEN BEGIN
                            IndLine.TESTFIELD("No.");
                        END;

                        IndLine.TESTFIELD("Shortcut Dimension 1 Code");
                        IndLine.TESTFIELD("Shortcut Dimension 2 Code");
                        IndLine."Workflow Approval Status" := "Workflow Approval Status";
                        IndLine.MODIFY;
                    UNTIL IndLine.NEXT = 0;
                END;

                IndLine.RESET;
                IndLine.SETRANGE(IndLine."Document No.", "Document No.");
                IF IndLine.FIND('-') THEN
                    REPEAT
                        IndLine.VALIDATE("Workflow Approval Status", "Workflow Approval Status");
                    UNTIL IndLine.NEXT = 0;
            end;
        }
        field(50099; "Workflow Sub Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'X';
            Editable = false;
            OptionCaption = ' ,FA,Regular,Direct,WorkOrder,Inward,Outward';
            OptionMembers = " ",FA,Regular,Direct,WorkOrder,Inward,Outward;
        }
        field(50110; "Initiator User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";

            trigger OnValidate()
            var
                AccessControl: Record "Access Control";
            begin
                IndLine.RESET;
                IndLine.SETRANGE("Document Type", "Document Type");
                IndLine.SETRANGE("Document No.", "Document No.");
                IF IndLine.FIND('-') THEN BEGIN
                    REPEAT
                        IndLine."Initiator User ID" := "Initiator User ID";
                        IndLine.MODIFY(TRUE);
                    UNTIL IndLine.NEXT = 0;
                END;
                /*
                AccessControl.RESET;
                AccessControl.SETRANGE("User Name","Initiator User ID");
                IF AccessControl.FINDFIRST THEN
                 "Indentor Name":= AccessControl."Full Name"
                ELSE
                  "Indentor Name":='';
                  */

            end;
        }
        field(500345; "Sub Document Type"; Option)
        {
            Description = 'ALLEAB';
            OptionCaption = ' ,WO-ICB,WO-NICB,Regular PO,Repeat PO,Confirmatory PO,Direct PO,GRN for PO,GRN for JSPL,GRN for Packages,GRN for Fabricated Material for WO,JES for WO,GRN-Direct Purchase,Freight Advice,Order,Invoice,Direct TO,Regular TO,Quote,FA,Man Power,Leave,Travel,Others,FA Sale,Hire';
            OptionMembers = " ","WO-ICB","WO-NICB","Regular PO","Repeat PO","Confirmatory PO","Direct PO","GRN for PO","GRN for JSPL","GRN for Packages","GRN for Fabricated Material for WO","JES for WO","GRN-Direct Purchase","Freight Advice","Order",Invoice,"Direct TO","Regular TO",Quote,FA,"Man Power",Leave,Travel,Others,"FA Sale",Hire;
        }
        field(500346; "PO code"; Code[20])
        {
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Order));

            trigger OnValidate()
            begin
                //MP1.0
                IF "PO code" <> '' THEN BEGIN
                    purchheader.GET(purchheader."Document Type"::Order, "PO code");
                    IF purchheader."Ending Date" < TODAY THEN
                        ERROR('The Wo has already expired. you cannot issue more quantity');
                    PRLine.RESET;
                    PRLine.SETRANGE("Document Type", "Document Type");
                    PRLine.SETRANGE("Document No.", "Document No.");
                    IF PRLine.FINDSET THEN
                        REPEAT
                            PRLine."WO / PO Code" := "PO code";
                            PRLine.MODIFY;
                        UNTIL PRLine.NEXT = 0;
                END;
                //MP1.0
            end;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "Indent Date")
        {
        }
        key(Key3; "Indent Date", "Document No.")
        {
        }
        key(Key4; "Approved Date", "Document No.")
        {
        }
        key(Key5; "Shortcut Dimension 1 Code")
        {
        }
        key(Key6; Indentor, "Shortcut Dimension 1 Code", "Document Type", "Indent Status")
        {
        }
        key(Key7; Indentor, "Responsibility Center", "Document Type", "Indent Status")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        DocApproval: Record "Document Type Approval";
    begin
        TESTFIELD("Sent for Approval", FALSE);
        //ALLE-SR-051107 >>
        IF NOT UserMgt.CheckRespCenter(1, "Responsibility Center") THEN
            ERROR(
              Text023,
              RespCenter.TABLECAPTION, UserMgt.GetPurchasesFilter());
        //ALLE-SR-051107 <<
        TESTFIELD(Approved, FALSE);
        TESTFIELD("Indent Status", "Indent Status"::Open);
        IndLine.RESET;
        IndLine.SETRANGE("Document Type", "Document Type");
        IndLine.SETRANGE("Document No.", "Document No.");
        IF IndLine.FIND('-') THEN
            IndLine.DELETEALL(TRUE);
    end;

    trigger OnInsert()
    var
        DocSetup: Record "Document Type Setup";
        DocInitiator: Record "Document Type Initiator";
        DocApproval: Record "Document Type Approval";
        DocumentApproval: Record "Document Type Approval";
    begin
        IF WORKDATE < 20080221D THEN
            ERROR('You can not work on this workdate');

        //JPL START
        Indentor := USERID;
        "Creation Date" := TODAY;
        "Creation Time" := TIME;
        "Indent Date" := TODAY; //ALLE-PKS36
        "Initiator User ID" := USERID;

        CompInfo.GET;
        "Location code" := CompInfo."Location Code";

        //Employee.GET(USERID);
        RecUserSetup.GET(USERID);
        //"Shortcut Dimension 2 Code":=Employee."Global Dimension 2 Code";
        "Shortcut Dimension 1 Code" := RecUserSetup."Purchase Resp. Ctr. Filter";
        "Shortcut Dimension 2 Code" := RecUserSetup."Shortcut Dimension 2 Code";
        //RecUser.GET(USERID);
        //"Indentor Name" :=Employee."First Name" + ' ' + Employee."Middle Name" + ' ' +  Employee."Last Name";
        "Indentor Name" := USERID;

        DimValue.RESET;
        DimValue.SETRANGE(Code, "Shortcut Dimension 2 Code");
        IF DimValue.FIND('-') THEN
            "Department Name" := DimValue.Name;

        //NDALLE061205
        IF "Document No." = '' THEN BEGIN
            PurAndPay.GET;
            PurAndPay.TESTFIELD("Indent Nos");
            NoSeriesMgt.InitSeries(PurAndPay."Indent Nos", xRec."Indent No. Series", WORKDATE, "Document No.", "Indent No. Series");
        END;
        //NDALLE061205
        "Responsibility Center" := UserMgt.GetRespCenter(1, "Responsibility Center");
        "Shortcut Dimension 1 Code" := UserMgt.GetRespCenter(1, "Responsibility Center");
        //ALLE-SR-051107 <<

        WorkflowMgmt.CheckWFDocumentTypeSetup(2, 1, "Workflow Sub Document Type", '', '', "Responsibility Center", FALSE);
        //ALLEND 191107
        RecUserSetup.RESET;
        RecUserSetup.SETRANGE("User ID", Indentor);
        IF RecUserSetup.FIND('-') THEN BEGIN
            //"Responsibility Center" := RecUserSetup."Purchase Resp. Ctr. Filter";
            RecRespCenter.RESET;
            RecRespCenter.SETRANGE(Code, RecUserSetup."Purchase Resp. Ctr. Filter");
            IF RecRespCenter.FIND('-') THEN BEGIN
                //    "Shortcut Dimension 1 Code" := RecRespCenter."Global Dimension 1 Code";
                "Location code" := RecRespCenter."Location Code";
            END;
        END;
        //ALLEND 191107
        //ALLERP Start:
        Job.RESET;
        Job.SETRANGE("Responsibility Center", "Responsibility Center");
        Job.SETRANGE("Global Dimension 1 Code", RecRespCenter."Global Dimension 1 Code");
        IF Job.FINDFIRST THEN
            "Job Code" := Job."No.";
        //ALLERP End:
    end;

    var
        IndLine: Record "Purchase Request Line";
        PurAndPay: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimValue: Record "Dimension Value";
        CompInfo: Record "Company Information";
        Employee: Record Employee;
        Text500: Label 'Indent once Short closed/cancelled will be removed from pending Indent list and appear as Short Closed/Cancelled Indent.\Do you want to %1 this Indent ?';
        ItemCategory: Record "Item Category";
        Location: Record Location;
        Text023: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text028: Label 'Your identification is set up to process from %1 %2 only.';
        PurchSetup: Record "Purchases & Payables Setup";
        GLSetup: Record "General Ledger Setup";
        UserMgt: Codeunit "EPC User Setup Management";
        RespCenter: Record "Responsibility Center 1";
        RecUser: Record User;
        Short1name: Text[30];
        Respname: Text[30];
        Locname: Text[30];
        RecDimValue: Record "Dimension Value";
        RecLocation: Record Location;
        RecRespCenter: Record "Responsibility Center 1";
        RecUserSetup: Record "User Setup";
        FAItem: Record "Fixed Asset Sub Group";
        Job: Record Job;
        Text50001: Label 'Delete the G/L account Lines for selecting Supply ';
        Text50002: Label 'Delete the Item Lines for selecting Services ';
        purchheader: Record "Purchase Header";
        PRLine: Record "Purchase Request Line";
        OldDimSetID: Integer;
        DimMgt: Codeunit DimensionManagement;
        Text051: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        StatusCheckSuspended: Boolean;
        WorkflowMgmt: Codeunit "Document Managment";


    procedure CloseIndent(Selection: Integer)
    var
        PurchaseHeader: Record "Purchase Header";
        TEXT0001: Label '&Cancel, &Short Close, Com&plete';
        PurchLine: Record "Purchase Line";
        SelectionText: Option " ",Cancel,"Short Close";
        DisplayError: Boolean;
    begin

        //Alle-AYN-250505: >>
        IndLine.RESET;
        IndLine.SETFILTER(IndLine."Document Type", '%1', "Document Type");
        IndLine.SETRANGE(IndLine."Document No.", "Document No.");
        IF IndLine.FIND('-') THEN BEGIN
            DisplayError := FALSE;
            REPEAT
                IndLine.CALCFIELDS("PO Qty", "Quantity Received", "Quantity Invoiced");
                IF (Selection = 1) THEN BEGIN //Cancel
                    IF (IndLine."PO Qty" > 0) THEN
                        DisplayError := TRUE;
                END
                ELSE IF (Selection = 2) THEN BEGIN
                    //Close

                    IF (IndLine."PO Qty" > IndLine."Quantity Invoiced") THEN
                        DisplayError := TRUE;
                    IF (IndLine."Quantity Received" <> IndLine."Quantity Invoiced") THEN
                        DisplayError := TRUE;
                END;
            UNTIL IndLine.NEXT = 0;

            IF (Selection = 1) AND (DisplayError) THEN
                ERROR('Indent cannot be Cancelled as PO has already been made for some quantity.');
            IF (Selection = 2) AND (DisplayError) THEN
                ERROR('Indent cannot be short Closed as either PO Qty is greater than Quantity Invoiced \' +
                      'or Quantity Received is not equal to Quantity Invoiced');
            SelectionText := Selection;
            IF CONFIRM(Text500, FALSE, SelectionText) THEN BEGIN
                IF Selection = 1 THEN
                    VALIDATE("Indent Status", "Indent Status"::Cancelled);
                //ALLE-PKS 08
                IF Selection = 2 THEN
                    VALIDATE("Indent Status", "Indent Status"::"Short Closed");
                MODIFY;
            END
            //ALLE-PKS 08

            ELSE
                ERROR('');

        END;
        //Alle-AYN-250505: <<
    end;


    procedure ShowDimensions()
    begin
        //TESTFIELD("Shortcut Dimension 1 Code");
        //TESTFIELD("Shortcut Dimension 2 Code");
        //TESTFIELD("Dimension Set ID");

        OldDimSetID := "Dimension Set ID";

        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2', "Document Type", "Document No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF LinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;


    procedure LinesExist(): Boolean
    begin
        IndLine.RESET;
        IndLine.SETRANGE("Document Type", "Document Type");
        IndLine.SETRANGE("Document No.", "Document No.");
        EXIT(IndLine.FINDFIRST);
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.
        IF NewParentDimSetID = OldParentDimSetID THEN
            EXIT;
        IF NOT CONFIRM(Text051) THEN
            EXIT;

        IndLine.RESET;
        IndLine.SETRANGE("Document Type", "Document Type");
        IndLine.SETRANGE("Document No.", "Document No.");
        IndLine.LOCKTABLE;
        IF IndLine.FIND('-') THEN
            REPEAT
                NewDimSetID := DimMgt.GetDeltaDimSetID(IndLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                IF IndLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
                    IndLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      IndLine."Dimension Set ID", IndLine."Shortcut Dimension 1 Code", IndLine."Shortcut Dimension 2 Code");
                    IndLine.VALIDATE("Shortcut Dimension 1 Code");
                    IndLine.VALIDATE("Shortcut Dimension 2 Code");
                    IndLine.MODIFY;
                END;
            UNTIL IndLine.NEXT = 0;
    end;


    procedure CheckBeforeRelease()
    var
        DimSetEntry: Record "Dimension Set Entry";
        RecordLink: Record "Record Link";
        Terms: Record Terms;
    begin
        //ALLE ANSH 220517
        RecordLink.RESET;
        RecordLink.SETCURRENTKEY("Record ID");
        RecordLink.SETFILTER("Record ID", FORMAT(RECORDID));
        IF NOT RecordLink.FINDFIRST THEN
            //ERROR(Text50004);

            TESTFIELD("Shortcut Dimension 1 Code");
        TESTFIELD("Shortcut Dimension 1 Code", "Responsibility Center");

        IndLine.RESET;
        IndLine.SETRANGE("Document Type", "Document Type");
        IndLine.SETRANGE("Document No.", "Document No.");
        IndLine.FINDFIRST;

        IndLine.RESET;
        IndLine.SETRANGE("Document Type", "Document Type");
        IndLine.SETRANGE("Document No.", "Document No.");
        IF IndLine.FINDSET THEN
            REPEAT
                IndLine.TESTFIELD("No.");
                IndLine.TESTFIELD("Shortcut Dimension 1 Code");
                IndLine.TESTFIELD("Shortcut Dimension 2 Code");
                IF "Workflow Sub Document Type" = "Workflow Sub Document Type"::" " THEN BEGIN
                    IndLine.TESTFIELD("Job No.");
                    IndLine.TESTFIELD("Job Task No.");
                    IndLine.TESTFIELD("Job Planning Line No.");
                END;
            UNTIL IndLine.NEXT = 0;
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;

    [IntegrationEvent(TRUE, false)]

    procedure OnCheckPurchasePostRestrictions()
    begin
    end;

    [IntegrationEvent(TRUE, false)]

    procedure OnCheckPurchaseReleaseRestrictions()
    begin
    end;
}

