page 97757 "Project Card"
{
    // ALLESSS 20/12/23 : Added Field "Land Item"and Changed record of varibale BUpload1 as Xmlport 50075-Unit Master Upload New
    // ALLESSS 16/02/24 : Adedd Field "Joint Venture" and its related code

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Job;
    ApplicationArea = All;
    UsageCategory = Documents;
    PromotedActionCategories = 'New,Approve,Report,Process,Release,Posting,Prepare,Invoice,Request Approval';
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                }
                field("Search Description"; Rec."Search Description")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Description 2"; Rec."Description 2")
                {
                }
                field("Land No."; Rec."Land No.")
                {
                }
                field("Last Job Archive Date"; Rec."Last Job Archive Date")
                {
                }
                field("Last Job Archive By"; Rec."Last Job Archive By")
                {
                }
                field("Last Job Archive Time"; Rec."Last Job Archive Time")
                {
                }
                field("Total No. of Units"; Rec."Total No. of Units")
                {
                }
                field("Total Unit Sold"; Rec."Total Unit Sold")
                {
                }
                field("Last Total No. of Units"; Rec."Last Total No. of Units")
                {
                }
                field("Last Total Project Cost"; Rec."Last Total Project Cost")
                {
                }
                field("Last Total Unit Sold"; Rec."Last Total Unit Sold")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Project Development Charge"; Rec."Project Development Charge")
                {
                }
                field("Job Archive No."; Rec."Job Archive No.")
                {
                }
                field("Project Saleable Area"; Rec."Project Saleable Area")
                {
                }
                field("Last Project Saleable Area"; Rec."Last Project Saleable Area")
                {
                }
                field("Verita Applicable"; Rec."Verita Applicable")
                {
                }
                field("Region Code for Rank Hierarcy"; Rec."Region Code for Rank Hierarcy")
                {
                }
                field("New commission Str. Applicable"; Rec."New commission Str. Applicable")
                {

                    trigger OnValidate()
                    begin

                        IF Rec."New commission Str. Applicable" THEN
                            Rec."New commission Str. StartDate" := TODAY
                        ELSE
                            Rec."New commission Str. StartDate" := 0D;

                        ComanyWiseGL.RESET;
                        ComanyWiseGL.SETRANGE("MSC Company", TRUE);
                        IF ComanyWiseGL.FINDFIRST THEN BEGIN
                            IF ComanyWiseGL."Company Code" = COMPANYNAME THEN
                                ERROR('This process will do from LLP Company');
                            recJob_1.RESET;
                            recJob_1.CHANGECOMPANY(ComanyWiseGL."Company Code");
                            recJob_1.SETRANGE("No.", Rec."No.");
                            IF recJob_1.FINDFIRST THEN BEGIN
                                recJob_1."New commission Str. Applicable" := Rec."New commission Str. Applicable";
                                recJob_1."New commission Str. StartDate" := Rec."New commission Str. StartDate";
                                recJob_1.MODIFY;
                            END;
                        END;
                    end;
                }
                field("New commission Str. StartDate"; Rec."New commission Str. StartDate")
                {
                    Editable = false;
                }
                field("Land Item"; Rec."Land Item")
                {
                }
                field("Joint Venture"; Rec."Joint Venture")
                {
                }
                field("Approval Status"; Rec."Approval Status")
                {
                }
                field("BSP4 Plan wise Applicable"; Rec."BSP4 Plan wise Applicable")
                {

                    trigger OnValidate()
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("BSP4 Update on Project Mster", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Contact Admin');
                    end;
                }
                field("BSP4 Plan wise St. Date"; Rec."BSP4 Plan wise St. Date")
                {

                    trigger OnValidate()
                    begin
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("BSP4 Update on Project Mster", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Contact Admin');
                    end;
                }
            }
            part("Project Details1"; "Project Details1")
            {
                SubPageLink = "Project Code" = FIELD("No."),
                              "Sub Project Code" = FIELD("Sub Project Code");
            }

            Group("Other Information")
            {
                field("Project Creation Date"; Rec."Project Creation Date")
                {
                }
                field("Cluster Name"; Rec."Cluster Name")
                {

                }
                field("Deed LLp Name"; Rec."Deed LLp Name")
                {

                }

                field("Bank APF"; Rec."Bank APF")
                {

                }
                field("Bank Loan Project"; Rec."Bank Loan Project")
                {

                }
                field("Draft LP No"; Rec."Draft LP No")
                {

                }
                field("Extent of Layout (Acres)"; Rec."Extent of Layout (Acres)")
                {

                }
                field("Extent of Layout(Guntas/Cents)"; Rec."Extent of Layout(Guntas/Cents)")
                {

                }
                field("Approval Type"; Rec."Approval Type")
                {

                }
                field("Project Type"; Rec."Project Type")
                {

                }
                field(Village; Rec.Village)
                {

                }
                field("Rera No"; Rec."Rera No")
                {

                }
                field("Rera From"; Rec."Rera From")
                {

                }
                field("Rera To"; Rec."Rera To")
                {

                }
                field("RERA Registration Date"; Rec."RERA Registration Date")
                {

                }
                field("RERA Expire Date"; Rec."RERA Expire Date")
                {

                }
                field("Final Layout (OC)"; Rec."Final Layout (OC)")
                {

                }
                field("Bank APF PER SQYD VALUE"; Rec."Bank APF PER SQYD VALUE")
                {

                }
                field("Purchasing LLP Name"; Rec."Purchasing LLP Name")
                {

                }

            }



        }
    }

    actions
    {
        area(processing)
        {
            action("Milestone &Updation")
            {
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Payment Plan Master";
                Visible = false;
            }
            action("Unit Master")
            {
                Image = Item;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Unit Master List";
                RunPageLink = "Project Code" = FIELD("No.");
                Visible = true;
            }
            action("Unit Masters")
            {
                Promoted = true;
                PromotedCategory = Category4;
            }
            action("Customer Master")
            {
                RunObject = Page "Customer List";
                Visible = false;
            }
            action("Vendor Master")
            {
                RunObject = Page "Vendor List";
                Visible = false;
            }
            action("Sales Order List")
            {
                RunObject = Page "Sales List";
                RunPageLink = "Shortcut Dimension 1 Code" = FIELD("No.");
                RunPageView = WHERE("Sub Document Type" = FILTER(Sales));
                Visible = false;
            }
            action("Lease Order List")
            {
                RunObject = Page "Sales List";
                RunPageLink = "Shortcut Dimension 1 Code" = FIELD("No.");
                RunPageView = WHERE("Sub Document Type" = FILTER(Lease));
                Visible = false;
            }
            action("Charge Type")
            {
                Image = Check;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Charge Type for Project";
                RunPageLink = "Project Code" = FIELD("No."),
                              "Document Type" = CONST(Charge),
                              "Unit Code" = FILTER('');
            }
            action("Payment Plans")
            {
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Payment Plan Master";
                RunPageLink = "Project Code" = FIELD("No."),
                              "Document Type" = CONST("Payment Plan");
                RunPageView = SORTING("Document Type", "Project Code", Code)
                              ORDER(Ascending);
            }
            action("Bulk Unit Allotment Modification")
            {
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    Rec.TESTFIELD(Status, Rec.Status::Order);
                    BUploadAllocation.SetProject(Rec."No.");
                    BUploadAllocation.RUN;
                end;
            }
            action("Project Price &Groups")
            {
                RunObject = Page "Price Group Master";
                RunPageLink = "Project Code" = FIELD("No."),
                              "Document Type" = CONST("Project Price Groups");
                RunPageView = SORTING("Document Type", "Project Code", Code)
                              ORDER(Ascending);
                Visible = false;
            }
            action("C&ar Parking")
            {
                RunObject = Page "Assocaite Web Staging Form";
                //RunPageLink = "Entry No." = FIELD("No.");
                Visible = false;
            }
            action("Unit Types Master")
            {
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                RunObject = Page "Document Master";
                RunPageLink = "Project Code" = FIELD("No."),
                              "Document Type" = CONST(Unit);
                RunPageView = SORTING("Document Type", "Project Code", Code)
                              ORDER(Ascending);
            }
            action("Approve Units")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Unit Approval Form";
            }
            action("Job List (Trading/ Non-Trading)")
            {
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Job List (All Projects)";
            }
            action("Project wise Milestone List")
            {
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Project wise Milestone Details";
                RunPageLink = "Project Code" = FIELD("No.");
            }
            action("Reopen 3-2/2-1")
            {
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    ComanyWiseGL.RESET;
                    ComanyWiseGL.SETRANGE("MSC Company", TRUE);
                    IF ComanyWiseGL.FINDFIRST THEN BEGIN
                        IF ComanyWiseGL."Company Code" = COMPANYNAME THEN BEGIN
                            RespCenter_1.RESET;
                            RespCenter_1.SETRANGE(Code, Rec."No.");
                            IF RespCenter_1.FINDFIRST THEN BEGIN
                                IF RespCenter_1."Company Name" <> ComanyWiseGL."Company Code" THEN
                                    ERROR('This process will done from LLPS');
                            END;
                        END;
                    END;


                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", USERID);
                    UserSetup.SETRANGE("Project Re-Open", TRUE);
                    IF NOT UserSetup.FINDFIRST THEN
                        ERROR('Please contact Admin Department');

                    /*
                    CurrForm."Launch Date".EDITABLE(TRUE);
                    CurrForm."Starting Date".EDITABLE(TRUE);
                    CurrForm."Ending Date".EDITABLE(TRUE);
                    CurrForm."Default Project Type".EDITABLE(TRUE);
                    CurrForm."Project Layout Area".EDITABLE(TRUE);
                    CurrForm."Efficency %".EDITABLE(TRUE);
                    CurrForm."Region Code for Rank Hierarcy".EDITABLE(TRUE);
                    */
                    IF Rec.Status = Rec.Status::Approved THEN
                        Rec.Status := Rec.Status::Order
                    ELSE IF Rec.Status = Rec.Status::Order THEN
                        Rec.Status := Rec.Status::Planning;
                    Rec.MODIFY;
                    COMMIT;
                    ComanyWiseGL.RESET;
                    ComanyWiseGL.SETRANGE(ComanyWiseGL."MSC Company", TRUE);
                    IF ComanyWiseGL.FINDFIRST THEN BEGIN
                        IF ComanyWiseGL."Company Code" <> COMPANYNAME THEN BEGIN
                            JobMSC.RESET;
                            JobMSC.CHANGECOMPANY(ComanyWiseGL."Company Code");
                            JobMSC.SETRANGE("No.", Rec."No.");
                            IF JobMSC.FINDFIRST THEN BEGIN
                                JobMSC.Status := Rec.Status;
                                JobMSC.MODIFY;
                            END;
                        END;
                    END;

                end;
            }
            action("Approve 2-3")
            {
                Image = Approval;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    PPdetails_1: Record "Payment Plan Details";
                begin

                    ComanyWiseGL.RESET;
                    ComanyWiseGL.SETRANGE("MSC Company", TRUE);
                    IF ComanyWiseGL.FINDFIRST THEN BEGIN
                        IF ComanyWiseGL."Company Code" = COMPANYNAME THEN BEGIN
                            RespCenter_1.RESET;
                            RespCenter_1.SETRANGE(Code, Rec."No.");
                            IF RespCenter_1.FINDFIRST THEN BEGIN
                                IF RespCenter_1."Company Name" <> ComanyWiseGL."Company Code" THEN
                                    ERROR('This process will done from LLPS');
                            END;
                        END;
                    END;


                    ProjUnitMaster.RESET;
                    ProjUnitMaster.SETRANGE("Project Code", Rec."No.");
                    ProjUnitMaster.SETRANGE(Archived, ProjUnitMaster.Archived::No);
                    IF ProjUnitMaster.FINDFIRST THEN
                        ERROR('Please approve the units');

                    Rec.TESTFIELD(Status, Rec.Status::Order);
                    Rec.TESTFIELD("Region Code for Rank Hierarcy");
                    Rec.TESTFIELD("Default Project Type");

                    DocMaster_1.RESET;
                    DocMaster_1.SETRANGE(DocMaster_1."Project Code", Rec."No.");
                    DocMaster_1.SETRANGE("Document Type", DocMaster_1."Document Type"::Charge);
                    DocMaster_1.SETRANGE("Unit Code", '');
                    DocMaster_1.SETFILTER(DocMaster_1."Rate/Sq. Yd", '<>%1', 0);
                    IF NOT DocMaster_1.FINDFIRST THEN
                        ERROR('Please define Project Charges');

                    DocMaster_1.RESET;
                    DocMaster_1.SETRANGE(DocMaster_1."Project Code", Rec."No.");
                    DocMaster_1.SETRANGE("Document Type", DocMaster_1."Document Type"::"Payment Plan");
                    DocMaster_1.SETRANGE("Unit Code", '');
                    IF NOT DocMaster_1.FINDFIRST THEN
                        ERROR('Please define Project Charges');

                    DocMaster_1.RESET;
                    DocMaster_1.SETRANGE(DocMaster_1."Project Code", Rec."No.");
                    DocMaster_1.SETRANGE("Document Type", DocMaster_1."Document Type"::"Payment Plan");
                    DocMaster_1.SETRANGE("Unit Code", '');
                    IF DocMaster_1.FINDFIRST THEN
                        REPEAT
                            PPdetails_1.RESET;
                            PPdetails_1.SETRANGE(PPdetails_1."Project Code", Rec."No.");
                            PPdetails_1.SETRANGE("Payment Plan Code", DocMaster_1.Code);
                            PPdetails_1.SETRANGE("Document No.", '');
                            IF NOT PPdetails_1.FINDFIRST THEN
                                ERROR('Please create Payment plan Details');
                        UNTIL DocMaster_1.NEXT = 0;




                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", USERID);
                    UserSetup.SETRANGE("Project Approve", TRUE);
                    IF NOT UserSetup.FINDFIRST THEN
                        ERROR('Please contact Admin Department');

                    Rec.Status := Rec.Status::Approved;
                    Rec.MODIFY;

                    ComanyWiseGL.RESET;
                    ComanyWiseGL.SETRANGE(ComanyWiseGL."MSC Company", TRUE);
                    IF ComanyWiseGL.FINDFIRST THEN BEGIN
                        IF ComanyWiseGL."Company Code" <> COMPANYNAME THEN BEGIN
                            JobMSC.RESET;
                            JobMSC.CHANGECOMPANY(ComanyWiseGL."Company Code");
                            JobMSC.SETRANGE("No.", Rec."No.");
                            IF JobMSC.FINDFIRST THEN BEGIN
                                JobMSC.TRANSFERFIELDS(Rec);
                                JobMSC.MODIFY;
                            END;
                        END;
                    END;
                end;
            }
            action("Release 1-2")
            {
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin

                    ComanyWiseGL.RESET;
                    ComanyWiseGL.SETRANGE("MSC Company", TRUE);
                    IF ComanyWiseGL.FINDFIRST THEN BEGIN
                        IF ComanyWiseGL."Company Code" = COMPANYNAME THEN BEGIN
                            RespCenter_1.RESET;
                            RespCenter_1.SETRANGE(Code, Rec."No.");
                            IF RespCenter_1.FINDFIRST THEN BEGIN
                                IF RespCenter_1."Company Name" <> ComanyWiseGL."Company Code" THEN
                                    ERROR('This process will done from LLPS');
                            END;
                        END;
                    END;

                    ProjcSaleabArea := 0;
                    TotalNoofUnits := 0;
                    Totalunitsold := 0;
                    TotalprojCost := 0;

                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", USERID);
                    UserSetup.SETRANGE("Project Release", TRUE);
                    IF NOT UserSetup.FINDFIRST THEN
                        ERROR('Please contact Admin Department');

                    IF Rec.Status <> Rec.Status::Order THEN BEGIN
                        JobArchive_1.RESET;
                        JobArchive_1.SETRANGE("No.", Rec."No.");
                        IF JobArchive_1.FINDLAST THEN;


                        Rec.CALCFIELDS("Project Saleable Area");
                        Rec.CALCFIELDS("Total No. of Units");
                        Rec.CALCFIELDS("Total Unit Sold");
                        Rec.CALCFIELDS("Total Project Cost");
                        ProjcSaleabArea := 0;
                        ProjcSaleabArea := Rec."Project Saleable Area";
                        TotalNoofUnits := Rec."Total No. of Units";
                        Totalunitsold := Rec."Total Unit Sold";
                        TotalprojCost := Rec."Total Project Cost";
                        Rec."Last Date Modified" := TODAY;
                        Rec."Last Job Archive By" := USERID;
                        Rec."Last Job Archive Time" := TIME;


                        Rec."Last Total No. of Units" := JobArchive_1."Total No. of Units";
                        Rec."Last Project Saleable Area" := JobArchive_1."Project Saleable Area";
                        Rec."Last Total Project Cost" := JobArchive_1."Total Project Cost";
                        Rec."Last Total Unit Sold" := JobArchive_1."Total Unit Sold";



                        JobArchive.INIT;
                        JobArchive.TRANSFERFIELDS(Rec);
                        JobArchive."Version No." := JobArchive_1."Version No." + 1;
                        JobArchive."Date Archived" := TODAY;
                        JobArchive."Archived By" := USERID;
                        JobArchive."Project Saleable Area" := ProjcSaleabArea;
                        JobArchive."Total No. of Units" := TotalNoofUnits;
                        JobArchive."Total Unit Sold" := Totalunitsold;
                        JobArchive."Total Project Cost" := TotalprojCost;
                        JobArchive."Time Archived" := TIME;
                        JobArchive.INSERT;
                    END;

                    Rec.Status := Rec.Status::Order;

                    /*
                    CurrForm."Launch Date".EDITABLE(FALSE);
                    CurrForm."Starting Date".EDITABLE(FALSE);
                    CurrForm."Ending Date".EDITABLE(FALSE);
                    CurrForm."Default Project Type".EDITABLE(FALSE);
                    CurrForm."Project Layout Area".EDITABLE(FALSE);
                    CurrForm."Efficency %".EDITABLE(FALSE);
                    CurrForm."Region Code for Rank Hierarcy".EDITABLE(FALSE);
                    */
                    //Code commented 01072025 Start

                    // DocMaster.RESET;
                    // DocMaster.SETRANGE("Unit Code", '');
                    // DocMaster.SETRANGE("Project Code", Rec."No.");
                    // IF DocMaster.FINDSET THEN
                    //     REPEAT
                    //         DocMaster.Status := DocMaster.Status::Release;
                    //         DocMaster.MODIFY;
                    //     UNTIL DocMaster.NEXT = 0;    

                    //Code commented END 01072025


                    Rec.MODIFY;

                    ComanyWiseGL.RESET;
                    ComanyWiseGL.SETRANGE(ComanyWiseGL."MSC Company", TRUE);
                    IF ComanyWiseGL.FINDFIRST THEN BEGIN
                        IF ComanyWiseGL."Company Code" <> COMPANYNAME THEN BEGIN
                            JobMSC.RESET;
                            JobMSC.CHANGECOMPANY(ComanyWiseGL."Company Code");
                            JobMSC.SETRANGE("No.", Rec."No.");
                            IF JobMSC.FINDFIRST THEN BEGIN
                                JobMSC.TRANSFERFIELDS(Rec);
                                JobMSC.MODIFY;
                            END;
                        END;
                    END;

                end;
            }
            action("Project Launch")
            {
                Visible = false;

                trigger OnAction()
                begin

                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", USERID);
                    UserSetup.SETRANGE("Project Approve", TRUE);
                    IF NOT UserSetup.FINDFIRST THEN
                        ERROR('Please contact Admin Department');

                    Rec."Project Launch" := TRUE;
                    Rec.MODIFY;
                end;
            }
            action("Project UnLaunch")
            {
                Visible = false;

                trigger OnAction()
                begin

                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", USERID);
                    UserSetup.SETRANGE("Project Approve", TRUE);
                    IF NOT UserSetup.FINDFIRST THEN
                        ERROR('Please contact Admin Department');

                    Rec."Project Launch" := FALSE;
                    Rec.MODIFY;
                end;
            }
            action("Bulk Unit Project Upload")
            {
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    DocumentMaster: Record "Document Master";
                begin
                    //IF "Joint Venture" THEN
                    // ERROR('Please select Bulk Update Unit Master for Joint Venture');

                    Rec.TESTFIELD(Status, Rec.Status::Order);
                    //TESTFIELD("Joint Venture","Joint Venture"::"0");

                    DocumentMaster.RESET;
                    DocumentMaster.SETRANGE("Project Code", Rec."No.");
                    DocumentMaster.SETRANGE("Unit Code", '');
                    DocumentMaster.SETRANGE(DocumentMaster."Document Type", DocumentMaster."Document Type"::Charge);
                    IF NOT DocumentMaster.FINDFIRST THEN
                        ERROR('Please upload Charge first');

                    Rec.TESTFIELD(Status, Rec.Status::Order);
                    CLEAR(BUpload1);
                    BUpload1.SetProject(Rec."No.");
                    BUpload1.RUN;
                end;
            }
            action(BulkmodifyPPBufferDay)
            {
                Caption = 'Bulk modify PP Buffer Day';

                trigger OnAction()
                begin
                    BulkmodifyPPBufferDay.RUN;
                end;
            }
            action(BulkUploadPPBufferDay)
            {
                Caption = 'Bulk Upload PP Buffer Day';

                trigger OnAction()
                begin
                    BulkUploadPPBufferDay.RUN;
                end;
            }
            group("Project Accounting")
            {
                action("Ref. LLP Details")
                {
                    Image = View;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        RefLLPDetails.RESET;
                        RefLLPDetails.SETRANGE("Project Code", Rec."No.");
                        IF RefLLPDetails.FINDSET THEN BEGIN
                            PAGE.RUNMODAL(Page::"Ref. LLP Details", RefLLPDetails);
                        END
                        ELSE BEGIN
                            RefLLPDetails.INIT;
                            RefLLPDetails."Project Code" := Rec."No.";
                            RefLLPDetails.INSERT;
                            COMMIT;

                            PAGE.RUNMODAL(Page::"Ref. LLP Details", RefLLPDetails);
                        END;
                    end;
                }
                action("Bulk Update Unit Master for JV")
                {
                    Caption = 'Bulk Update Unit Master for Joint Venture';
                    Image = UpdateXML;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        UnitMasterUpdateforJV: XMLport "Unit Master Update for JV";
                        UnitMaster: Record "Unit Master";
                    begin
                        IF NOT Rec."Joint Venture" THEN
                            ERROR('Please select Bulk Unit Project Upload');

                        Rec.TESTFIELD(Status, Rec.Status::Order);
                        Rec.TESTFIELD("Joint Venture", true);

                        DocumentMaster.RESET;
                        DocumentMaster.SETRANGE("Project Code", Rec."No.");
                        DocumentMaster.SETRANGE("Unit Code", '');
                        DocumentMaster.SETRANGE(DocumentMaster."Document Type", DocumentMaster."Document Type"::Charge);
                        IF NOT DocumentMaster.FINDFIRST THEN
                            ERROR('Please upload Charge first');


                        UnitMaster.RESET;
                        UnitMaster.SETRANGE("Project Code", Rec."No.");
                        UnitMaster.FINDFIRST;
                        CLEAR(UnitMasterUpdateforJV);
                        UnitMasterUpdateforJV.SETTABLEVIEW(UnitMaster);
                        UnitMasterUpdateforJV.RUN;
                    end;
                }
                action("Test Report")
                {
                    Image = TestReport;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Job_2.RESET;
                        Job_2.SETRANGE("No.", Rec."No.");
                        IF Job_2.FIND('-') THEN;
                        REPORT.RUN(Report::"Unit Master Test Report", TRUE, FALSE, Job_2);
                    end;
                }
            }
            group("Approve Project")
            {
                Image = Approve;
                action("Send for Approval")
                {
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        IF Rec."Joint Venture" then
                            Rec.TESTFIELD("Test Report Run", TRUE); //Need to check the code in UAT
                        BBGSetups.GET;
                        BBGSetups.TESTFIELD("Project Approver 1");
                        BBGSetups.TESTFIELD("Project Approver 2");

                        IF CONFIRM('Do you want to Send this Project for Approval') THEN BEGIN
                            IF Rec."Approval Status" = Rec."Approval Status"::Rejected THEN
                                ERROR('Project is already Rejected')
                            ELSE IF Rec."Approval Status" = Rec."Approval Status"::Approved THEN
                                ERROR('Project is already approved.');

                            Rec."Approval Status" := Rec."Approval Status"::"Pending For Approval";
                            Rec."Pending From USER ID" := BBGSetups."Project Approver 1";
                            MESSAGE('Project is under Pending for Approval');
                        END;
                    end;
                }
                action(Approve)
                {
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::"Pending For Approval");


                        CheckUnitMaster.RESET;
                        CheckUnitMaster.SETRANGE("Project Code", Rec."No.");
                        CheckUnitMaster.SETFILTER("Ref. LLP Name", '<>%1', '');
                        IF CheckUnitMaster.FINDFIRST THEN BEGIN
                            TotalPlotSize := 0;
                            LandAgreementHeader.RESET;
                            LandAgreementHeader.CHANGECOMPANY(CheckUnitMaster."Ref. LLP Name");
                            LandAgreementHeader.SETRANGE("FG Item No.", CheckUnitMaster."Ref. LLP Item No.");
                            IF LandAgreementHeader.FINDFIRST THEN BEGIN
                                TotalSize := 0;
                                LandAgreementLine.RESET;
                                LandAgreementLine.CHANGECOMPANY(CheckUnitMaster."Ref. LLP Name");
                                LandAgreementLine.SETRANGE("Document No.", LandAgreementHeader."Document No.");
                                IF LandAgreementLine.FINDSET THEN
                                    REPEAT
                                        TotalSize := TotalSize + LandAgreementLine."Quantity in SQYD";
                                    UNTIL LandAgreementLine.NEXT = 0;
                            END;
                            REPEAT
                                TotalPlotSize := TotalPlotSize + CheckUnitMaster."Saleable Area";
                            UNTIL CheckUnitMaster.NEXT = 0;
                        END;


                        IF Rec."Joint Venture" THEN BEGIN
                            IF TotalPlotSize > TotalSize THEN
                                ERROR('Plot Size is greater than Land agreement size with differ value= ' + FORMAT(TotalPlotSize - TotalSize));
                        END;



                        IF CONFIRM('Do you want to Approve this Project') THEN BEGIN
                            BBGSetups.GET();

                            IF USERID = BBGSetups."Project Approver 1" THEN BEGIN
                                Rec."Approval Status" := Rec."Approval Status"::"Pending For Approval";
                                Rec."Pending From USER ID" := BBGSetups."Project Approver 2";
                                MESSAGE('Project is under Pending for Approval');
                            END ELSE IF BBGSetups."Project Approver 2" <> Rec."Pending From USER ID" THEN
                                    ERROR('Approver 1 must approve');

                            IF USERID = BBGSetups."Project Approver 2" THEN BEGIN
                                Rec."Approval Status" := Rec."Approval Status"::Approved;
                                Rec."Pending From USER ID" := '';

                                MESSAGE('Project Approved');
                            END;
                        END;
                    end;
                }
                action("Re-Open")
                {
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        IF Rec."Approval Status" = Rec."Approval Status"::Open THEN
                            ERROR('Project is already opened');

                        IF CONFIRM('Do you want to Re-open Request') THEN BEGIN
                            Rec."Pending From USER ID" := '';
                            Rec."Approval Status" := Rec."Approval Status"::Open;
                            MESSAGE('Project Re-Opened');
                        END;
                    end;
                }
                action(Reject)
                {
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Approval Status", Rec."Approval Status"::"Pending For Approval");

                        IF CONFIRM('Do you want to Reject this Project') THEN BEGIN
                            IF Rec."Approval Status" = Rec."Approval Status"::Approved THEN
                                ERROR('Project is already approved.');

                            IF Rec."Pending From USER ID" <> '' THEN
                                IF USERID <> Rec."Pending From USER ID" THEN
                                    ERROR('User - ' + Rec."Pending From USER ID" + ' can only Reject this Project');
                        END;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateRefItemInventory; //ALLESSS 02/02/24
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow Unit/Project", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;

    trigger OnOpenPage()
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Allow Unit/Project", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Contact Admin');
    end;

    var
        UserMgt: Codeunit "EPC User Setup Management";
        ItemRec: Record Item;
        SLineRec: Record "Sales Line";
        JLEREC: Record "Job Ledger Entry";
        JobAmt: Decimal;
        SUBProjectName: Text[30];
        DimValrec: Record "Dimension Value";
        ShRec: Record "Sales Header";
        RecJob: Record Job;
        "Form Project Unit": Page "Project Unit";
        FUnitMatrix: Page "Property Availability Matrix";
        DocumentMaster: Record "Document Master";
        UserSetup: Record "User Setup";
        DocMaster: Record "Document Master";
        JobArchive: Record "EPC Job Archive";
        JobArchive_1: Record "EPC Job Archive";
        ProjcSaleabArea: Decimal;
        TotalNoofUnits: Decimal;
        Totalunitsold: Decimal;
        TotalprojCost: Decimal;
        JobMSC: Record Job;
        ComanyWiseGL: Record "Company wise G/L Account";
        RespCenter_1: Record "Responsibility Center 1";
        BUpload1: XMLport "Unit Master Upload New";
        ProjUnitMaster: Record "Unit Master";
        DocMaster_1: Record "Document Master";
        BUploadAllocation: XMLport "Unit allotment";
        BulkmodifyPPBufferDay: Report "Bulk modify PP Buffer Day";
        BulkUploadPPBufferDay: XMLport "Bulk Upload PP Buffer Day";
        Job_2: Record Job;
        recJob_1: Record Job;
        RefLLPDetails: Record "Ref. LLP Details";
        PageRefLLPDetails: Page "Ref. LLP Details";
        Text0001: Label 'Please run Test Report to check Unit Master error';
        UnitMasterUploadNew: XMLport "Unit Master Upload New";
        BBGSetups: Record "BBG Setups";
        LandAgreementLine: Record "Land Agreement Line";
        LandAgreementHeader: Record "Land Agreement Header";
        CheckUnitMaster: Record "Unit Master";
        TotalSize: Decimal;
        TotalPlotSize: Decimal;
        Job: Record Job;


    procedure EnableControl()
    begin
    end;

    local procedure UpdateRefItemInventory()
    var
        RefLLPItemDetails: Record "Ref. LLP Item Details";
        Item: Record Item;
        RefLLPItemDetails1: Record "Ref. LLP Item Details";
        CompanyInformation: Record "Company Information";
    begin
        RefLLPItemDetails.RESET;
        RefLLPItemDetails.SETRANGE("Project Code", Rec."No.");
        IF RefLLPItemDetails.FINDSET THEN
            REPEAT
                Item.RESET;
                Item.CHANGECOMPANY(RefLLPItemDetails."Ref. LLP Name");
                Item.SETRANGE("No.", RefLLPItemDetails."Ref. LLP Item No.");
                IF Item.FINDFIRST THEN BEGIN
                    RefLLPItemDetails1 := RefLLPItemDetails;
                    //Item.CALCFIELDS(Inventory);
                    //RefLLPItemDetails1."Available Inventory" := Item.Inventory;
                    LandAgreementHeader.RESET;
                    LandAgreementHeader.CHANGECOMPANY(RefLLPItemDetails1."Ref. LLP Name");
                    LandAgreementHeader.SETRANGE("FG Item No.", RefLLPItemDetails1."Ref. LLP Item No.");
                    IF LandAgreementHeader.FINDFIRST THEN BEGIN
                        TotalSize := 0;
                        LandAgreementLine.RESET;
                        LandAgreementLine.CHANGECOMPANY(RefLLPItemDetails1."Ref. LLP Name");
                        LandAgreementLine.SETRANGE("Document No.", LandAgreementHeader."Document No.");
                        IF LandAgreementLine.FINDSET THEN
                            REPEAT
                                TotalSize := TotalSize + LandAgreementLine."Quantity in SQYD";
                            UNTIL LandAgreementLine.NEXT = 0;
                    END;

                    RefLLPItemDetails1."Available Inventory" := TotalSize;

                    RefLLPItemDetails1."Ref. LLP Item Project Code" := Item."Global Dimension 1 Code";

                    CompanyInformation.CHANGECOMPANY(RefLLPItemDetails."Ref. LLP Name");
                    CompanyInformation.GET();
                    //RefLLPItemDetails1."IC Partner Code" := CompanyInformation."IC Partner Code";
                    RefLLPItemDetails1.MODIFY;
                END;
            UNTIL RefLLPItemDetails.NEXT = 0;
        COMMIT;
    end;
}

