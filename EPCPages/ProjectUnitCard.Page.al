page 97826 "Project Unit Card"
{
    // //GKG - commented assist edit on Item Code
    // BBG1.00/AD/150712/TAB-OTHER INFORMATION ADDED WITH FEW COLUMNS MADE VISIBLE-FACING,SIZE-N/E/W/S
    // //ALLECK 200313: Added Code for Unit Master Archive
    // //BBG1.1 181213 Added code for in case of Block check Reserve

    Caption = 'Project Unit Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Unit Master";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                    Editable = false;
                }
                field("Sub Project Code"; Rec."Sub Project Code")
                {
                    Editable = false;
                }
                field("Unit Type"; Rec."Unit Type")
                {
                }
                field("Floor No."; Rec."Floor No.")
                {
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                }
                field("Payment Plan"; Rec."Payment Plan")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                }
                field("Total Value"; Rec."Total Value")
                {
                }
                field("No. of Plots"; Rec."No. of Plots")
                {
                }
                field("No. of Plots for Incentive Cal"; Rec."No. of Plots for Incentive Cal")
                {
                }
                field("Old No."; Rec."Old No.")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Modify Date"; Rec."Modify Date")
                {
                    Caption = 'Modified Date';
                }
                field("Modify Time"; Rec."Modify Time")
                {
                    Caption = 'Modified Time';
                }
                field("Modified By"; Rec."Modified By")
                {
                }
                field(Version; Rec.Version)
                {
                    Editable = false;
                }
                field(Archived; Rec.Archived)
                {
                    Editable = false;
                }
                field("Constructed Property"; Rec."Constructed Property")
                {
                    Editable = false;
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                    Caption = 'Saleable Area';

                    trigger OnValidate()
                    begin
                        IF CONFIRM('You are changing saleable area!!!\ Are you sure?') THEN BEGIN
                            //DDS
                            IF Rec."Efficiency (%)" <> 0 THEN
                                //"Super Area":=(("Saleable Area"/"Efficiency (%)")*100);//ALLECK 180313
                                Rec."Carpet Area" := ((Rec."Saleable Area" / Rec."Efficiency (%)") * 100);
                            MESSAGE('Now please update applicabel charges from Unit Menu');
                        END;
                    end;
                }
                field("Efficiency (%)"; Rec."Efficiency (%)")
                {
                }
                field("Carpet Area"; Rec."Carpet Area")
                {
                    Editable = false;
                }
                field("Lease Blocked"; Rec."Lease Blocked")
                {
                }
                field("Sales Blocked"; Rec."Sales Blocked")
                {
                }
                field(LeaseBooked; LeaseBooked)
                {
                    Caption = 'Lease Booked';
                    Editable = false;
                }
                field(SalesBooked; SalesBooked)
                {
                    Caption = 'Sales Booked';
                    Editable = false;
                }
                field(Mortgage; Rec.Mortgage)
                {
                }
                field("Non Usable"; Rec."Non Usable")
                {
                    Editable = false;
                }
                field(Reserve; Rec.Reserve)
                {
                    Editable = false;
                }
                field(Freeze; Rec.Freeze)
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Web Portal Status"; Rec."Web Portal Status")
                {
                }
                field("Block SubType"; Rec."Block SubType")
                {
                }
                field("Unit Category"; Rec."Unit Category")
                {
                }
                field("Minimum Booking Amount"; Rec."Minimum Booking Amount")
                {
                }
                field("Associate Code"; Rec."Associate Code")
                {
                }
                field("Associate Name"; Rec."Associate Name")
                {
                    Editable = false;
                }
                field("Comment for Unit Block"; Rec."Comment for Unit Block")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
                field("Special Units"; Rec."Special Units")
                {
                }
            }
            group("Other Information")
            {
                Caption = 'Other Information';
                field(Facing; Rec.Facing)
                {
                }
                field("Size-East"; Rec."Size-East")
                {
                }
                field("Size-West"; Rec."Size-West")
                {
                }
                field("Size-North"; Rec."Size-North")
                {
                }
                field("Size-South"; Rec."Size-South")
                {
                }
                field("60 feet Road"; Rec."60 feet Road")
                {
                }
                field("100 feet Road"; Rec."100 feet Road")
                {
                }
                field(Corner; Rec.Corner)
                {
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                    Visible = false;
                }
                field("PLC Applicable"; Rec."PLC Applicable")
                {
                }
                field("East Boundary"; Rec."East Boundary")
                {
                }
                field("West Boundary"; Rec."West Boundary")
                {
                }
                field("North Boundary"; Rec."North Boundary")
                {
                }
                field("South Boundary"; Rec."South Boundary")
                {
                }
                field("Type Of Deed"; Rec."Type Of Deed")
                {

                }
                field("Deed No"; Rec."Deed No")
                {

                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Function")
            {
                Caption = '&Function';
                action("Data Push to Online Status")
                {

                    trigger OnAction()

                    begin
                        CLEAR(WebAppService);
                        WebAppService.UpdateUnitStatus(Rec);
                        COMMIT;
                        MESSAGE('Process Done');
                    end;
                }
                action("Unit Charge Break Up")
                {
                    Caption = 'Unit Charge Break Up';

                    trigger OnAction()
                    begin

                        DocumentMaster.RESET;
                        DocumentMaster.SETRANGE("Project Code", Rec."Project Code");
                        DocumentMaster.SETRANGE("Unit Code", Rec."No.");
                        IF DocumentMaster.FINDFIRST THEN BEGIN
                            REPORT.RUN(50003, TRUE, FALSE, DocumentMaster);
                        END;
                    end;
                }
                action("Release/Approve")
                {
                    Caption = 'Release/Approve';

                    trigger OnAction()
                    begin
                        Rec.TESTFIELD("Total Value");

                        Usersetup.RESET;
                        Usersetup.SETRANGE("User ID", USERID);
                        Usersetup.SETRANGE("Unit Approval", TRUE);
                        IF NOT Usersetup.FINDFIRST THEN
                            ERROR('Please contact to Admin');


                        Rec.TESTFIELD(Archived, Rec.Archived::No);
                        IF Rec."Unit Category" = Rec."Unit Category"::Normal THEN
                            Rec.TESTFIELD("Min. Allotment Amount");

                        //UMaster.RESET;
                        //UMaster.SETRANGE("No.","No.");
                        //IF UMaster.FINDSET THEN
                        //  REPEAT
                        //    UMaster.Archived := UMaster.Archived :: Yes;
                        //    UMaster.MODIFY;
                        //  UNTIL UMaster.NEXT = 0;

                        //ReleaseUnit.Updateunitmaster(Rec);


                        Rec.Archived := Rec.Archived::Yes;
                        Rec.MODIFY;
                        CurrPage.EDITABLE := FALSE;
                        CurrPage.UPDATE;
                    end;
                }
                action(ReOpen)
                {
                    Caption = 'ReOpen';

                    trigger OnAction()
                    var
                        RecJob_1: Record Job;
                    begin

                        Usersetup.RESET;
                        Usersetup.SETRANGE("User ID", USERID);
                        Usersetup.SETRANGE("Unit Re-Open", TRUE);
                        IF NOT Usersetup.FINDFIRST THEN
                            ERROR('Please contact to Admin');

                        /*
                        CompanyWise.RESET;
                        CompanyWise.SETRANGE(CompanyWise."MSC Company",TRUE);
                        IF CompanyWise.FINDFIRST THEN
                          IF CompanyWise."Company Code" = COMPANYNAME THEN
                            ERROR('This process will do from LLP company');
                         */

                        RecJob_1.RESET;
                        RecJob_1.SETRANGE("No.", Rec."Project Code");
                        IF RecJob_1.FINDFIRST THEN
                            RecJob_1.TESTFIELD(Status, RecJob_1.Status::Order);

                        //TESTFIELD(Archived,Archived :: Yes );
                        //TESTFIELD(Status, Status :: Open);
                        ArchUnitMaster.RESET;
                        ArchUnitMaster.SETCURRENTKEY("Project Code", "No.", Version);
                        ArchUnitMaster.SETRANGE("No.", Rec."No.");
                        ArchUnitMaster.SETRANGE("Project Code", Rec."Project Code");
                        IF ArchUnitMaster.FINDLAST THEN
                            Versn := ArchUnitMaster.Version
                        ELSE
                            Versn := 0;

                        ArchUnitMaster.INIT;
                        ArchUnitMaster.TRANSFERFIELDS(Rec);
                        ArchUnitMaster.Version := Versn + 1;
                        ArchUnitMaster."User ID" := USERID;
                        ArchUnitMaster."Archive Date" := TODAY;
                        ArchUnitMaster."Archive Time" := TIME;
                        ArchUnitMaster.INSERT;

                        ArchDocMaster.RESET;
                        ArchDocMaster.SETCURRENTKEY("Project Code", "Unit Code", Version);
                        ArchDocMaster.SETRANGE("Unit Code", Rec."No.");
                        ArchDocMaster.SETRANGE("Project Code", Rec."Project Code");
                        IF ArchDocMaster.FINDLAST THEN
                            Versn := ArchDocMaster.Version
                        ELSE
                            Versn := 0;

                        DocMaster.RESET;
                        DocMaster.SETRANGE("Unit Code", Rec."No.");
                        DocMaster.SETRANGE("Project Code", Rec."Project Code");
                        IF DocMaster.FINDSET THEN
                            REPEAT
                                DocumentMaster.RESET;
                                DocumentMaster.SETRANGE("Document Type", DocMaster."Document Type");
                                DocumentMaster.SETRANGE("Project Code", DocMaster."Project Code");
                                DocumentMaster.SETRANGE(Code, DocMaster.Code);
                                DocumentMaster.SETRANGE("Sale/Lease", DocMaster."Sale/Lease");
                                DocumentMaster.SETRANGE("Unit Code", DocMaster."Unit Code");
                                DocumentMaster.SETRANGE("App. Charge Code", DocMaster."App. Charge Code");
                                IF DocumentMaster.FINDSET THEN BEGIN
                                    ArchDocMaster.INIT;
                                    ArchDocMaster.TRANSFERFIELDS(DocumentMaster);
                                    ArchDocMaster.Version := Versn + 1;
                                    ArchDocMaster."User ID" := USERID;
                                    ArchDocMaster."Archive Date" := TODAY;
                                    ArchDocMaster."Archive Time" := TIME;
                                    ArchDocMaster.INSERT;
                                END;
                            UNTIL DocMaster.NEXT = 0;


                        //----------ARCHIVE APPLICABLE CHARGES-----------ALLECK 200313 END
                        Rec.Archived := Rec.Archived::No;
                        Rec.MODIFY;

                        CurrPage.EDITABLE(TRUE);
                        //CurrPage.UPDATE;

                    end;
                }
                action("Copy Unit in MSCompany")
                {
                    Caption = 'Copy Unit in MSCompany';

                    trigger OnAction()
                    begin
                        CompanyWise.RESET;
                        CompanyWise.SETRANGE(CompanyWise."MSC Company", TRUE);
                        IF CompanyWise.FINDFIRST THEN BEGIN
                            NewUnitMaster.RESET;
                            NewUnitMaster.CHANGECOMPANY(CompanyWise."Company Code");
                            IF NOT NewUnitMaster.GET(Rec."No.") THEN BEGIN
                                NewUnitMaster.INIT;
                                NewUnitMaster.TRANSFERFIELDS(Rec);
                                NewUnitMaster.INSERT;
                                MESSAGE('%1', 'Unit Master update');
                            END ELSE
                                MESSAGE('%1', 'This unit already exist in MSCompany');
                        END;
                    end;
                }
                action(UnFreeze)
                {
                    Caption = 'UnFreeze';

                    trigger OnAction()
                    begin
                        Memberof.RESET;
                        Memberof.SETRANGE("User Name", USERID);
                        Memberof.SETRANGE(Memberof."Role ID", 'A_UnitClosed');
                        IF NOT Memberof.FINDFIRST THEN
                            ERROR('You do not have permission of Role: A_UnitClosed');

                        Rec.Freeze := FALSE;
                        Rec.MODIFY;
                    end;
                }
                action("Status Open")
                {
                    Caption = 'Status Open';

                    trigger OnAction()
                    begin
                        IF Rec.Status = Rec.Status::Transfered THEN
                            ERROR('Do not open this unit.');
                        Memberof.RESET;
                        Memberof.SETRANGE(Memberof."User Name", USERID);
                        Memberof.SETRANGE(Memberof."Role ID", 'A_UnitClosed');
                        IF NOT Memberof.FINDFIRST THEN
                            ERROR('You do not have permission of Role: A_UnitClosed');

                        CheckUnitConforder.RESET;
                        CheckUnitConforder.SETRANGE("Shortcut Dimension 1 Code", Rec."Project Code");
                        CheckUnitConforder.SETRANGE("Unit Code", Rec."No.");
                        IF CheckUnitConforder.FINDFIRST THEN
                            ERROR('This unit No already attached on application No.' + CheckUnitConforder."No.");  //190924 change with new confirmed order

                        Rec.Status := Rec.Status::Open;
                        Rec."Web Portal Status" := Rec."Web Portal Status"::Available;
                        Rec.MODIFY;

                        CLEAR(WebAppService);
                        WebAppService.UpdateUnitStatus(Rec);  //210624
                    end;
                }
                action("Transfer to Old LLP")
                {
                    Caption = 'Transfer to Old LLP';

                    trigger OnAction()
                    var
                        CompWiseGL: Record "Company wise G/L Account";
                        RespCenter: Record "Responsibility Center 1";
                    begin

                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        Usersetup.RESET;
                        Usersetup.SETRANGE(Usersetup."User ID", USERID);
                        Usersetup.SETRANGE("Unit Creation", TRUE);
                        IF NOT Usersetup.FINDFIRST THEN
                            ERROR('Please contact admin department');

                        IF CONFIRM('Do you want to transfer this unit') THEN BEGIN

                            CompWiseGL.RESET;
                            CompWiseGL.SETRANGE(CompWiseGL."Other LLPS", TRUE);
                            IF CompWiseGL.FINDSET THEN
                                REPEAT
                                    RespCenter.RESET;
                                    RespCenter.CHANGECOMPANY(CompWiseGL."Company Code");
                                    RespCenter.SETRANGE(Code, Rec."Project Code");
                                    IF RespCenter.FINDFIRST THEN BEGIN
                                        Rec."Company Name" := CompWiseGL."Company Code";
                                        Rec.MODIFY;
                                        MESSAGE('%1', 'This unit is available in Company- ' + CompWiseGL."Company Code");
                                    END;
                                UNTIL CompWiseGL.NEXT = 0;
                        END;
                    end;
                }
                action("Transfer to BBG India Developers LLP")
                {
                    Caption = 'Transfer to BBG India Developers LLP';

                    trigger OnAction()
                    begin

                        Rec.TESTFIELD(Status, Rec.Status::Open);
                        Usersetup.RESET;
                        Usersetup.SETRANGE(Usersetup."User ID", USERID);
                        Usersetup.SETRANGE("Unit Creation", TRUE);
                        IF NOT Usersetup.FINDFIRST THEN
                            ERROR('Please contact admin department');

                        IF CONFIRM('Do you want to transfer this unit') THEN BEGIN
                            Rec."Company Name" := 'BBG India Developers LLP';
                            Rec.MODIFY;
                            MESSAGE('%1', 'This unit is available in Company- ' + 'BBG India Developers LLP');
                        END;
                    end;
                }
            }
            group("&Unit")
            {
                Caption = '&Unit';
                action("&Documents")
                {
                    Caption = '&Documents';
                    RunObject = Page Documents;
                    RunPageLink = "Table No." = CONST(50106),
                                  "Reference No. 1" = FIELD("No.");
                }
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(50106),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    Visible = false;
                }
                action("PLC Details")
                {
                    Caption = 'PLC Details';
                    RunObject = Page "TravelPayment Details";
                    Visible = false;
                }
                action("&Unit Payment Plan Details")
                {
                    Caption = '&Unit Payment Plan Details';
                    RunObject = Report "OD Adjustment in Companies";
                }
                action("Car Parking Alloted")
                {
                    Caption = 'Car Parking Alloted';
                    RunObject = Page "Assocaite Web Staging Form";
                    Visible = false;
                }
                action("Applicable Charges")
                {
                    Caption = 'Applicable Charges';
                    RunObject = Page "Charge Type";
                    RunPageLink = "Project Code" = FIELD("Project Code"),
                                  "Document Type" = CONST(Charge),
                                  "Unit Code" = FIELD("No.");
                }
                action("Update Applicable Charges")
                {
                    Caption = 'Update Applicable Charges';

                    trigger OnAction()
                    begin
                        //ALLECK 190313 START
                        IF Rec.Status = Rec.Status::Open THEN BEGIN
                            DocMaster.RESET;
                            DocMaster.SETRANGE("Project Code", Rec."Project Code");
                            DocMaster.SETRANGE("Unit Code", Rec."No.");
                            DocMaster.SETFILTER(Code, '<>%1', 'OTH');
                            IF DocMaster.FINDSET THEN
                                REPEAT
                                    IF DocMaster."Fixed Price" <> 0 THEN BEGIN
                                        DocMaster."Total Charge Amount" := DocMaster."Fixed Price";
                                        Total := Total + DocMaster."Total Charge Amount";
                                    END;
                                    IF DocMaster."Rate/Sq. Yd" <> 0 THEN BEGIN
                                        DocMaster."Total Charge Amount" := Rec."Saleable Area" * DocMaster."Rate/Sq. Yd";
                                        Total := Total + DocMaster."Total Charge Amount";
                                    END;
                                    DocMaster.MODIFY;
                                UNTIL DocMaster.NEXT = 0;
                            //ALLECK 190313 END
                            IF Total <> 0 THEN BEGIN
                                RoundOffAmt := 0;
                                RoundOffAmt := ROUND(Total, 1, '>') - Total;

                                IF RoundOffAmt <> 0 THEN BEGIN
                                    DocumentMaster1.RESET;
                                    DocumentMaster1.SETRANGE("Document Type", DocumentMaster1."Document Type"::Charge);
                                    DocumentMaster1.SETRANGE("Project Code", Rec."Project Code");
                                    DocumentMaster1.SETRANGE("Unit Code", Rec."No.");
                                    DocumentMaster1.SETRANGE(Code, 'OTH');
                                    IF DocumentMaster1.FINDFIRST THEN BEGIN
                                        DocumentMaster1.VALIDATE("Fixed Price", (RoundOffAmt));
                                        DocumentMaster1.MODIFY;
                                    END;
                                END;
                                Rec."Total Value" := ROUND(Total, 1, '>');
                                Rec.MODIFY;
                            END;
                            Total := 0;
                        END;

                        ReleaseUnit.Updateunitmaster(Rec);
                    end;
                }
                group(Reservation)
                {
                    Caption = 'Reservation';
                    action("&Reserve")
                    {
                        Caption = 'Reserve';

                        trigger OnAction()
                        var
                            AccessControl: Record "Access Control";
                        begin

                            AccessControl.RESET;
                            AccessControl.SETRANGE(AccessControl."User Name", USERID);
                            AccessControl.SETRANGE("Role ID", 'UNITRESERVE');
                            IF NOT AccessControl.FINDFIRST THEN
                                ERROR('Please contact to Admin');

                            /*
                            //ALLECK 070112 START
                            Usersetup.SETRANGE("User ID",USERID);
                            Usersetup.SETRANGE("Unit Approval",TRUE);
                            IF NOT Usersetup.FINDFIRST THEN
                              ERROR('Please contact to Admin');
                              */
                            IF (Rec.Status IN [Rec.Status::Booked, Rec.Status::Registered]) THEN
                                ERROR('Status must be Open/Blocked');

                            CompanyWise.RESET;
                            CompanyWise.SETRANGE(CompanyWise."MSC Company", TRUE);
                            IF CompanyWise.FINDFIRST THEN
                                NewUnitMaster.RESET;
                            NewUnitMaster.CHANGECOMPANY(CompanyWise."Company Code");
                            IF NewUnitMaster.GET(Rec."No.") THEN
                                NewUnitMaster.TESTFIELD(Status, Rec.Status::Open);

                            Rec.TESTFIELD(Status, Rec.Status::Open);
                            Rec.Reserve := TRUE;
                            Rec.Status := Rec.Status::Blocked;
                            Rec."Web Portal Status" := Rec."Web Portal Status"::Booked;
                            Rec."Last Unit Blocked By" := USERID;
                            Rec."Last Unit Blocked DT" := CURRENTDATETIME;
                            Rec.MODIFY;

                            ReleaseUnit.Updateunitmaster(Rec);  //BBG2.01 291214
                            CLEAR(WebAppService);
                            WebAppService.UpdateUnitStatus(Rec);  //210624  comment 230624

                            CurrPage.UPDATE;
                            //ALLECK 070112 END

                        end;
                    }
                    action(Unreserve)
                    {
                        Caption = 'Unreserve';

                        trigger OnAction()
                        var
                            AccessControl: Record "Access Control";
                        begin
                            //ALLECK 070112 START
                            /*
                            Usersetup.SETRANGE("User ID",USERID);
                            Usersetup.SETRANGE("Unit Approval",TRUE);
                            IF NOT Usersetup.FINDFIRST THEN
                              ERROR('Please contact to Admin');
                              */

                            AccessControl.RESET;
                            AccessControl.SETRANGE(AccessControl."User Name", USERID);
                            AccessControl.SETRANGE("Role ID", 'UNITRESERVE');
                            IF NOT AccessControl.FINDFIRST THEN
                                ERROR('Please contact to Admin');

                            IF (Rec.Status IN [Rec.Status::Booked, Rec.Status::Registered]) THEN
                                ERROR('Status must be Open/Blocked');

                            Rec.TESTFIELD(Reserve, TRUE); //BBG1.1 181213
                            Rec.Reserve := FALSE;
                            Rec.Status := Rec.Status::Open;
                            Rec."Web Portal Status" := Rec."Web Portal Status"::Available;
                            Rec.MODIFY;
                            ReleaseUnit.Updateunitmaster(Rec);  //BBG2.01 291214

                            CLEAR(WebAppService);
                            WebAppService.UpdateUnitStatus(Rec);  //210624

                            CurrPage.UPDATE;

                            //ALLECK 070112 END

                        end;
                    }
                }
                group("Unit Block")
                {
                    Caption = 'Unit Block';
                    action(Blocked)
                    {
                        Caption = 'Blocked';

                        trigger OnAction()
                        var
                            AccessControl: Record "Access Control";
                        begin
                            /*
                            Usersetup.SETRANGE("User ID",USERID);
                            Usersetup.SETRANGE("Unit Approval",TRUE);
                            IF NOT Usersetup.FINDFIRST THEN
                              ERROR('Please contact to Admin');
                              */

                            AccessControl.RESET;
                            AccessControl.SETRANGE(AccessControl."User Name", USERID);
                            AccessControl.SETRANGE("Role ID", 'UNITBLOCK');
                            IF NOT AccessControl.FINDFIRST THEN
                                ERROR('Please contact to Admin');

                            IF (Rec.Status IN [Rec.Status::Booked, Rec.Status::Registered]) THEN
                                ERROR('Status must be Open/Blocked');


                            CompanyWise.RESET;
                            CompanyWise.SETRANGE(CompanyWise."MSC Company", TRUE);
                            IF CompanyWise.FINDFIRST THEN
                                NewUnitMaster.RESET;
                            NewUnitMaster.CHANGECOMPANY(CompanyWise."Company Code");
                            IF NewUnitMaster.GET(Rec."No.") THEN
                                NewUnitMaster.TESTFIELD(Status, Rec.Status::Open);


                            Rec.TESTFIELD("Block SubType");// = "Block Subtype" ::"" THEN //BBG1.1 181213
                            //  Error('Please define the Block SubType');   //BBG1.1 181213
                            Rec.TESTFIELD(Status, Rec.Status::Open);
                            Rec.TESTFIELD("Comment for Unit Block");
                            Rec.Status := Rec.Status::Blocked;
                            Rec."Web Portal Status" := Rec."Web Portal Status"::Booked;
                            Rec."Non Usable" := TRUE;
                            Rec."Last Unit Blocked By" := USERID;
                            Rec."Last Unit Blocked DT" := CURRENTDATETIME;
                            Rec.MODIFY;
                            ReleaseUnit.Updateunitmaster(Rec);  //BBG2.01 291214
                            CLEAR(WebAppService);
                            WebAppService.UpdateUnitStatus(Rec);  //210624
                            CurrPage.UPDATE;

                        end;
                    }
                    action(UnBlocked)
                    {
                        Caption = 'UnBlocked';

                        trigger OnAction()
                        var
                            AccessControl: Record "Access Control";
                        begin
                            /*
                            Usersetup.SETRANGE("User ID",USERID);
                            Usersetup.SETRANGE("Unit Approval",TRUE);
                            IF NOT Usersetup.FINDFIRST THEN
                              ERROR('Please contact to Admin');
                              */

                            AccessControl.RESET;
                            AccessControl.SETRANGE(AccessControl."User Name", USERID);
                            AccessControl.SETRANGE("Role ID", 'UNITBLOCK');
                            IF NOT AccessControl.FINDFIRST THEN
                                ERROR('Please contact to Admin');

                            IF (Rec.Status IN [Rec.Status::Booked, Rec.Status::Registered]) THEN
                                ERROR('Status must be Open/Blocked');

                            Rec.TESTFIELD(Reserve, FALSE);  //BBG1.1 181213
                            Rec.Status := Rec.Status::Open;
                            Rec."Web Portal Status" := Rec."Web Portal Status"::Available;
                            Rec."Block SubType" := Rec."Block SubType"::" "; //BBG1.1 181213
                            Rec."Comment for Unit Block" := '';  //BBG1.1 181213
                            Rec."Non Usable" := FALSE;          //BBG1.1 181213
                            Rec.MODIFY;
                            ReleaseUnit.Updateunitmaster(Rec);  //BBG2.01 291214
                            CLEAR(WebAppService);
                            WebAppService.UpdateUnitStatus(Rec);  //210624

                            CurrPage.UPDATE;

                        end;
                    }
                }
                group("Unit Mortgage")
                {
                    Caption = 'Unit Mortgage';
                    action("&Mortgage")
                    {
                        Caption = 'Mortgage';

                        trigger OnAction()
                        begin
                            Usersetup.SETRANGE("User ID", USERID);
                            Usersetup.SETRANGE("Unit Approval", TRUE);
                            IF NOT Usersetup.FINDFIRST THEN
                                ERROR('Please contact to Admin');


                            Rec.Mortgage := TRUE;
                            Rec.MODIFY;

                            CLEAR(WebAppService);
                            WebAppService.UpdateUnitStatus(Rec);  //210624
                            CurrPage.UPDATE;
                        end;
                    }
                    action(UnMortgage)
                    {
                        Caption = 'UnMortgage';

                        trigger OnAction()
                        begin

                            Usersetup.SETRANGE("User ID", USERID);
                            Usersetup.SETRANGE("Unit Approval", TRUE);
                            IF NOT Usersetup.FINDFIRST THEN
                                ERROR('Please contact to Admin');
                            Rec.Mortgage := FALSE;
                            Rec.MODIFY;

                            CLEAR(WebAppService);
                            WebAppService.UpdateUnitStatus(Rec);  //210624
                            CurrPage.UPDATE;
                        end;
                    }
                }
            }
            group("S&ales")
            {
                Caption = 'S&ales';
                action("Project Price Group - Prices")
                {
                    Caption = 'Project Price Group - Prices';
                    RunObject = Page "Project Price Group Details";
                    RunPageLink = "Project Code" = FIELD("Project Code"),
                                  "Project Price Group" = FIELD("Project Price Group");
                }
                separator("---")
                {
                    Caption = '---';
                }
                action("Return Orders")
                {
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Sales Return Orders";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", Type, "No.");
                }
                action("Orders-Sales")
                {
                    Caption = 'Orders-Sales';
                    RunObject = Page "Sales List";
                    RunPageLink = "Sub Document Type" = FILTER(Sales),
                                  "Item Code" = FIELD("No.");
                    RunPageView = SORTING("Document Type", "No.")
                                  ORDER(Ascending);
                }
                action("Orders-Lease")
                {
                    Caption = 'Orders-Lease';
                    RunObject = Page "Sales List";
                    RunPageLink = "Sub Document Type" = FILTER(Lease),
                                  "Item Code" = FIELD("No.");
                    RunPageView = SORTING("Document Type", "No.")
                                  ORDER(Ascending);
                }
            }
            group("&Purchases")
            {
                Caption = '&Purchases';
                action("Ven&dors")
                {
                    Caption = 'Ven&dors';
                    RunObject = Page "Item Vendor Catalog";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.");
                }
                action(Prices)
                {
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Purchase Prices";
                    RunPageLink = "Item No." = FIELD("No.");
                    RunPageView = SORTING("Item No.");
                    Visible = false;
                }
                action("Line Discounts")
                {
                    Caption = 'Line Discounts';
                    RunObject = Page "Purchase Line Discounts";
                    RunPageLink = "Item No." = FIELD("No.");
                    Visible = false;
                }
                action(Orders)
                {
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Purchase Orders";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", Type, "No.");
                }
                action("&Return Orders")
                {
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Purchase Return Orders";
                    RunPageLink = Type = CONST(Item),
                                  "No." = FIELD("No.");
                    RunPageView = SORTING("Document Type", Type, "No.");
                    Visible = false;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //SETRANGE("No.");
        Rec.CALCFIELDS("Sales Order Count", "Lease Order Count");
        //AEREN105 START
        IF Rec."Sales Order Count" > 0 THEN BEGIN
            SalesBooked := TRUE;
        END
        ELSE BEGIN
            SalesBooked := FALSE;
        END;

        IF Rec."Lease Order Count" > 0 THEN BEGIN
            LeaseBooked := TRUE;
        END
        ELSE BEGIN
            LeaseBooked := FALSE;
        END;
        //AEREN105 STOp

        //IF Archived = Archived :: Yes THEN
        //  CurrPage.EDITABLE(FALSE)
        //ELSE
        //  CurrPage.EDITABLE(TRUE);

        /*
        IF Status = Status::Booked THEN
          CurrPAGE.EDITABLE(FALSE)
        ELSE
          CurrPAGE.EDITABLE(TRUE);
         */

    end;

    trigger OnOpenPage()
    var
        Companywise: Record "Company wise G/L Account";
    begin

        //IF Archived = Archived :: Yes THEN
        //CurrPage.EDITABLE(FALSE)
        //ELSE
        //  CurrPage.EDITABLE(TRUE);

        Usersetup.RESET;
        Usersetup.SETRANGE("User ID", USERID);
        Usersetup.SETRANGE("Allow Unit/Project", TRUE);
        IF NOT Usersetup.FINDFIRST THEN
            ERROR('Contact Admin');



        Companywise.RESET;
        Companywise.SETRANGE(Companywise."MSC Company", TRUE);
        IF Companywise.FINDFIRST THEN BEGIN
            IF Companywise."Company Code" <> COMPANYNAME THEN
                Rec.SETRANGE("Company Name", COMPANYNAME);
        END;
    end;

    var
        TroubleshHeader: Record "Troubleshooting Header";
        SkilledResourceList: Page "Skilled Resource List";
        ItemCostMgt: Codeunit ItemCostManagement;
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        AverageCostLCY: Decimal;
        AverageCostACY: Decimal;
        SalesBooked: Boolean;
        LeaseBooked: Boolean;
        ItemCat: Record "Item Category";
        DocumentMaster: Record "Document Master";
        TotalChAmt: Decimal;
        RoundOffAmt: Decimal;
        TotalChAmt1: Decimal;
        DocumentMaster1: Record "Document Master";
        RUAmount: Decimal;
        DocMaster: Record "Document Master";
        Total: Decimal;
        UnitMaster: Record "Unit Master";
        ArchUnitMaster: Record "Archive Unit Master";
        Versn: Integer;
        UMaster: Record "Unit Master";
        ArchDocMaster: Record "Archive Document Master";
        Memberof: Record "Access Control";
        ReleaseUnit: Codeunit "Release Unit Application";
        CompanyWise: Record "Company wise G/L Account";
        NewUnitMaster: Record "Unit Master";
        CheckUnitConforder: Record "New Confirmed Order";
        Usersetup: Record "User Setup";
        WebAppService: Codeunit "Web App Service";
        NewConfirmedOrder: Record "New Confirmed Order";
}

