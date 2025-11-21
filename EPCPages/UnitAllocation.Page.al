page 50015 "Unit Allocation"
{
    // Upgrade140118 code comment
    // AllEDK 210921 21.09
    // code Comment 251121
    // Code Added 271023

    PageType = Document;
    SourceTable = "Confirmed Order";
    SourceTableView = WHERE("Application Transfered" = FILTER(false));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group("Confirmed application")
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Introducer Code"; Rec."Introducer Code")
                {
                    Editable = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Editable = false;
                }
                field("Project Type"; Rec."Project Type")
                {
                    Caption = 'Commission Code';
                    Editable = false;
                }
                field("Unit Code"; Rec."Unit Code")
                {
                    Editable = false;
                }
                field("Unit Payment Plan"; Rec."Unit Payment Plan")
                {
                    Editable = false;
                }
                field("Unit Plan Name"; Rec."Unit Plan Name")
                {
                }
                field("Min. Allotment Amount"; Rec."Min. Allotment Amount")
                {
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    Caption = 'Total Amount';
                    Editable = false;
                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    Editable = false;
                }
                field("Net Amount"; Rec.Amount - Rec."Discount Amount")
                {
                    Editable = false;
                }
                field("Total Received Amount"; Rec."Total Received Amount")
                {
                    Editable = false;
                }
                field("Due Amount"; Rec.Amount + Rec."Service Charge Amount" - Rec."Discount Amount" - Rec."Total Received Amount")
                {
                    Editable = false;
                }
                field("Saleable Area"; Rec."Saleable Area")
                {
                    Editable = false;
                }
                field(Status; Rec.Status)
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field("Send for Approval (Unit Allot)"; Rec."Send for Approval (Unit Allot)")
                {
                }
                field("Send for Aproval Dt (UnitAllt)"; Rec."Send for Aproval Dt (UnitAllt)")
                {
                }
                field("Approval Status (Unit Allot)"; Rec."Approval Status (Unit Allot)")
                {
                }
            }
            group("Unit Allocation")
            {
                Field("New Region code"; Rec."New Region code")
                {
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        Rec."New Project" := '';
                    end;

                }
                field("New Project"; Rec."New Project")
                {
                    trigger OnValidate()
                    var
                        ProjectwiseRank: Record "Project wise Appl. Setup";
                        Vendor: Record vendor;
                        RegionwiseRank: Record "Region wise Vendor";
                        RankCodeMaster: Record "Rank Code Master";
                        CommStrAmtBase: Record "Commission Structr Amount Base";
                    begin
                        //Code added Start 01072025
                        Rec.TestField("New Region code");
                        RegionwiseRank.RESET;
                        RegionwiseRank.GET(Rec."New Region code", Rec."Introducer Code");

                        RankCodeMaster.RESET;
                        IF RankCodeMaster.GET(Rec."New Region code") then begin
                            IF RankCodeMaster."Applicable New commission Str." then begin
                                CommStrAmtBase.Reset;
                                CommStrAmtBase.SetRange("Project Code", Rec."New Project");
                                CommStrAmtBase.SetFilter("Start Date", '<=%1', Rec."Posting Date");
                                CommStrAmtBase.SetFilter("End Date", '>=%1', Rec."Posting Date");
                                CommStrAmtBase.SetRange("Rank Code", Rec."New Region code");
                                IF NOT CommStrAmtBase.FindFirst() then
                                    Error('Project wise commission structure not define');
                            end;
                        end;


                        // Vendor.RESET;  //Code commented 01072025
                        // If Vendor.GET(Rec."Introducer Code") then  //Code commented 01072025
                        //     If Vendor."BBG Vendor Category" = Vendor."BBG Vendor Category"::"IBA(Associates)" THEN begin   //Code commented 01072025
                        ProjectwiseRank.RESET;
                        ProjectwiseRank.SetRange("Project Code", Rec."New Project");
                        ProjectwiseRank.SetFilter("Effective From Date", '<=%1', Rec."Posting Date");
                        ProjectwiseRank.SetFilter("Effective To Date", '>=%1', Rec."Posting Date");
                        ProjectwiseRank.SetRange("Project Rank Code", Rec."New Region code");
                        IF ProjectwiseRank.FindSet() THEN begin
                            repeat
                                Rec."Travel applicable" := ProjectwiseRank."Travel Applicable";
                                Rec."Registration Bouns (BSP2)" := ProjectwiseRank."Registration Bonus (BSP2)";
                                Rec."Region Code" := ProjectwiseRank."Project Rank Code";
                            Until ProjectwiseRank.Next = 0;
                        END ELSE
                            Rec."Region Code" := Rec."New Region code";
                    end;
                    // END;  //Code commented 01072025
                    //Code added END 01072025

                }
                field("New Unit No."; Rec."New Unit No.")
                {
                    Enabled = NewUnitEditable;


                    trigger OnValidate()

                    begin

                        Rec.TESTFIELD("Registration Status", Rec."Registration Status"::" ");  //ALLEDK 090921

                        RecApplication.RESET;
                        RecApplication.SETRANGE("Application No.", Rec."No.");
                        IF RecApplication.FINDFIRST THEN BEGIN
                            RecApplication.DELETE;
                        END;
                    end;
                }
                field("New Unit Payment Plan"; Rec."New Unit Payment Plan")
                {

                }
                field("Unit Payment Name"; UPName)
                {
                    Editable = false;
                }
                field("Project change Comment"; Rec."Project change Comment")
                {
                }
            }
            part("Receipt Lines"; "Unit Payment Entry  Subform")
            {
                SubPageLink = "Document Type" = CONST(BOND),
                              "Document No." = FIELD("No.");
                SubPageView = WHERE(Posted = CONST(false));
                UpdatePropagation = Both;
                Visible = false;
            }
            part(""; "Document Approval Details")
            {
                SubPageLink = "Document No." = FIELD("No."),
                              "Document Type" = CONST("Unit Allocation");
            }
            part(PostedUnitPayEntrySubform; "Posted Unit Pay Entry Subform")
            {
                Caption = 'Posted Receipt';
                SubPageLink = "Document Type" = CONST(BOND),
                              "Document No." = FIELD("No.");
                SubPageView = WHERE(Posted = CONST(true));
            }
            part(History; "Unit History Subform")
            {
                SubPageLink = "Unit No." = FIELD("No.");
                Visible = false;
            }
            part(Comment; "Unit Comment Sheet")
            {
                SubPageLink = "Table Name" = CONST("Confirmed order"),
                              "No." = FIELD("No.");
                Visible = false;
            }
            part("Print Log"; "Unit Print Log Subform")
            {
                SubPageLink = "Unit No." = FIELD("No.");
                Visible = false;
            }
            group("Unit Holder")
            {
                Visible = false;
                group("Unit Holder1")
                {
                    Editable = false;
                    Visible = false;
                    field(Name; Customer.Name)
                    {
                        Editable = false;
                    }
                    field(Relation; Customer.Contact)
                    {
                        Editable = false;
                    }
                    field(Address; Customer.Address)
                    {
                        Editable = false;
                    }
                    field("Address 2"; Customer."Address 2")
                    {
                    }
                    field(City; Customer.City)
                    {
                    }
                    field("Post Code"; Customer."Post Code")
                    {
                    }
                }
                group("Unit Holder Bank Detail")
                {
                    Editable = false;
                    field("Customer Bank Branch"; GetDescription.GetCustBankBranchName(Rec."Customer No.", Rec."Application No."))
                    {
                    }
                    field("Customer Bank Account No."; GetDescription.GetCustBankAccountNo(Rec."Customer No.", Rec."Application No."))
                    {
                    }
                }
                group("2nd Applicant")
                {
                    Editable = false;
                    Visible = false;
                    field("No1."; Customer2."No.")
                    {
                        Caption = 'No.';
                    }
                    field(Customer2Name; Customer2.Name)
                    {
                        Caption = 'Name';
                    }
                    field(Relation1; Customer2.Contact)
                    {
                        Caption = 'Relation';
                    }
                    field(Address1; Customer2.Address)
                    {
                        Caption = 'Address';
                    }
                    field(Address2; Customer2."Address 2")
                    {
                        Caption = 'Address 2';
                    }
                    field(City1; Customer2.City)
                    {
                        Caption = 'City';
                    }
                    field(PostCode; Customer2."Post Code")
                    {
                        Caption = 'Post Code';
                    }
                }
            }
            group(Nominee)
            {
                Editable = false;
                Visible = false;
                field(Title; FORMAT(BondNominee.Title))
                {
                }
                field(Name3; BondNominee.Name)
                {
                    Caption = 'Name';
                }
                field(Address4; BondNominee.Address)
                {
                    Caption = 'Address';
                }
                field("Address4-2"; BondNominee."Address 2")
                {
                    Caption = 'Address 2';
                }
                field(City3; BondNominee.City)
                {
                    Caption = 'City';
                }
                field(PostCode2; BondNominee."Post Code")
                {
                    Caption = 'Post Code';
                }
                field(Age; BondNominee.Age)
                {
                }
                field(Relation4; BondNominee.Relation)
                {
                    Caption = 'Relation';
                }
            }
            group(Registration)
            {
                Editable = false;
                Visible = false;
                field("Registration No."; Rec."Registration No.")
                {
                }
                field("Registration Date"; Rec."Registration Date")
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
            }
            group(NEFT)
            {
                Editable = false;
                Visible = false;
                field("Bank Name"; CustomerBankAccount.Name)
                {
                }
                field("IFSC Code"; CustomerBankAccount."SWIFT Code")
                {
                }
                field("Bank Branch No."; CustomerBankAccount."Bank Branch No.")
                {
                }
                field("Bank Branch Name"; CustomerBankAccount."Name 2")
                {
                }
                field("Account No."; CustomerBankAccount."Bank Account No.")
                {
                }
                field("UserID"; CustomerBankAccount."USER ID")
                {
                }
                field("Entry Status"; CustomerBankAccount."Entry Completed")
                {
                }
            }
            group("Other Informations")
            {
                Editable = false;
                field(Type; Rec.Type)
                {
                }
                field("Dummay Unit Code"; Rec."Dummay Unit Code")
                {
                }
                field("User Id"; Rec."User Id")
                {
                }
                field("Scheme Code"; Rec."Scheme Code")
                {
                }
                field("Version No."; Rec."Version No.")
                {
                }
                field("Received From Code"; Rec."Received From Code")
                {
                }
                field("Return Payment Mode"; Rec."Return Payment Mode")
                {
                }
                field("Dispute Remark"; Rec."Dispute Remark")
                {
                }
                field("Application Type"; Rec."Application Type")
                {
                }
                field("Maturity Date"; Rec."Maturity Date")
                {
                }
                field("Posted Doc No."; Rec."Posted Doc No.")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field("Commission Amount"; Rec."Commission Amount")
                {
                }
                field("Commission Paid"; Rec."Commission Paid")
                {
                }
                field("Gold Coin Generated"; Rec."Gold Coin Generated")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Print)
            {
                action("Commission Print")
                {
                    Image = "1099Form";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    begin

                        ComEntry.RESET;
                        ComEntry.SETRANGE("Application No.", Rec."Application No.");
                        IF ComEntry.FINDFIRST THEN
                            REPORT.RUN(50061, TRUE, FALSE, ComEntry);
                    end;
                }
                action("Associate Eligibility")
                {

                    trigger OnAction()
                    begin

                        Vendor.RESET;
                        Vendor.SETRANGE("No.", Rec."Introducer Code");
                        IF Vendor.FINDFIRST THEN
                            REPORT.RUNMODAL(50081, TRUE, FALSE, Vendor);
                    end;
                }
            }
            group("Function")
            {
                action("Payment Plan Details")
                {
                    RunObject = Page "Payment Plan Details Master";
                    RunPageLink = "Document No." = FIELD("Application No."),
                                  "Project Code" = FIELD("Shortcut Dimension 1 Code");
                }
                action("Payment Milestones")
                {
                    Image = PaymentForecast;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Payment Terms Line Sale";
                    RunPageLink = "Document No." = FIELD("Application No."),
                                  "Transaction Type" = CONST(Sale);
                }
                action("Applicable Charges")
                {
                    RunObject = Page "Charge Type Applicable";
                    RunPageLink = "Item No." = FIELD("Unit Code"),
                                  "Project Code" = FIELD("Shortcut Dimension 1 Code"),
                                  "Document No." = FIELD("Application No.");
                }
                action("Opening Commission Generate")
                {

                    trigger OnAction()
                    begin

                        Rec.TESTFIELD("Application Transfered", FALSE);
                        IF Rec."User Id" = '1003' THEN BEGIN
                            Rec.SETRANGE("No.", Rec."No.");
                            IF Rec.FINDFIRST THEN
                                REPORT.RUNMODAL(50029, TRUE, FALSE, Rec);
                        END;
                    end;
                }
                action("Reassign New Project Unit")
                {
                    Image = Restore;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        APE: Record "Application Payment Entry";
                        CreatUPEryfromConfOrderAPP: Codeunit "Creat UPEry from ConfOrder/APP";
                        VersionNo: Integer;
                        BReversal: Codeunit "Unit Reversal";
                        CommisionGen: Codeunit "Unit and Comm. Creation Job";
                        OldUPEntry: Record "Unit Payment Entry";
                        CommHold: Boolean;
                        ComHoldDate: Date;
                        CommEntry_1: Record "Commission Entry";
                        AppPayentry_1: Record "Application Payment Entry";
                        UnitReversal_2: Codeunit "Unit Reversal";
                        UnitMaster_2: Record "Unit Master";
                        Job_2: Record Job;
                        CompanywiseGLAccount: Record "Company wise G/L Account";
                        v_ConfirmedOrder: Record "Confirmed Order";
                        ProjectwiseDevelopmentCharg: Record "Project wise Development Charg";
                        EndDate: Date;
                        V_CompanyInformation: Record "Company Information";
                        v_ConfirmedOrder1: Record "Confirmed Order";
                        recCustomer: Record Customer;
                        New_UnitMaster: Record "Unit Master";  //251124 Added
                        NoInvoiceandCrMemoCreate: Boolean;  //251124 Added
                        UpdateTAGenerate: Boolean;
                        Conforder_2: Record "Confirmed Order";
                    begin
                        Rec.TESTFIELD("Approval Status (Unit Allot)", Rec."Approval Status (Unit Allot)"::Approved);
                        Rec.TESTFIELD("Registration Status", Rec."Registration Status"::" ");  //ALLEDK 090921
                        Rec.TESTFIELD("Application Closed", FALSE);  //190820
                                                                     //UnitReversal_2.ProjectChanges(Rec); new code

                        Rec.TESTFIELD("Application Transfered", FALSE);

                        UnitSetup.GET;
                        UnitSetup.TESTFIELD("Gold No. Series for Proj Chang");
                        RecApplication.RESET;
                        RecApplication.SETRANGE("Application No.", Rec."No.");
                        IF RecApplication.FINDFIRST THEN
                            RecApplication.DELETE;

                        //290425 Code added Start
                        OldUPmtEntry.RESET;
                        OldUPmtEntry.SETRANGE("Document Type", OldUPmtEntry."Document Type"::BOND);
                        OldUPmtEntry.SETRANGE("Document No.", Rec."No.");
                        //OldUPmtEntry.SETRANGE(Posted, TRUE);
                        IF OldUPmtEntry.FindSet then begin
                            OldUPmtEntry.DeleteAll;

                        END;
                        //290425 Code added END


                        //ERROR('Please contact to Admin');
                        Vend_1.RESET;
                        Vend_1.SETRANGE("No.", Rec."Introducer Code");
                        IF Vend_1.FINDFIRST THEN
                            Vend_1.TESTFIELD("BBG Black List", FALSE);


                        OldProject := '';
                        NewProject := '';
                        OldProject := Rec."Shortcut Dimension 1 Code";
                        NewProject := Rec."New Project";

                        OldAppExists.RESET;
                        OldAppExists.SETRANGE("Application No.", Rec."No.");
                        IF OldAppExists.FINDFIRST THEN
                            OldAppExists.DELETE;

                        Rec.TESTFIELD("Project change Comment");
                        Rec.TESTFIELD("New Unit Payment Plan");

                        ProjectMilestoneHdr.RESET;
                        ProjectMilestoneHdr.SETRANGE("Project Code", Rec."New Project");
                        IF ProjectMilestoneHdr.FINDSET THEN BEGIN
                            REPEAT
                                ProjectMilestoneHdr.TESTFIELD(Status, ProjectMilestoneHdr.Status::Release);
                                ProjMilestoneLine.RESET;
                                ProjMilestoneLine.SETRANGE("Document No.", ProjectMilestoneHdr."Document No.");
                                ProjMilestoneLine.SETRANGE(Code, 'PPLAN');
                                IF NOT ProjMilestoneLine.FINDFIRST THEN
                                    ERROR('Please define PPlan on Project milstone setup for document No. - ' + FORMAT(ProjectMilestoneHdr."Document No."));
                            UNTIL ProjectMilestoneHdr.NEXT = 0;
                        END ELSE
                            ERROR('Please define Project milestone for Project Code' + ' ' + Rec."New Project");

                        IF Rec."Introducer Code" <> 'IBA9999999' THEN BEGIN
                            TotAppAmt := 0;
                            //251124 Code comment Start
                            // IF Rec."User Id" = '1003' THEN BEGIN
                            //     AppPaymentEntry.RESET;
                            //     AppPaymentEntry.SETRANGE("Document No.", Rec."No.");
                            //     AppPaymentEntry.SETRANGE("User ID", '1003');
                            //     IF AppPaymentEntry.FINDSET THEN
                            //         REPEAT
                            //             TotAppAmt += AppPaymentEntry.Amount;
                            //         UNTIL AppPaymentEntry.NEXT = 0;
                            //     //IF TotAppAmt >= "Min. Allotment Amount" THEN BEGIN
                            //     IF TotAppAmt >= CommisionGen.CheckMinAmountOpng(Rec) THEN BEGIN
                            //         IF Rec."User Id" = '1003' THEN BEGIN
                            //             CommissionEntry.RESET;
                            //             CommissionEntry.SETRANGE("Application No.", Rec."No.");
                            //             CommissionEntry.SETRANGE("Opening Entries", TRUE);
                            //             CommissionEntry.SETFILTER("Commission Amount", '<>%1', 0);
                            //             IF NOT CommissionEntry.FINDFIRST THEN
                            //                 ERROR('Please create Commission for opening Application');
                            //         END;
                            //     END;
                            // END;
                            //251124 Code comment End
                        END;
                        APE.RESET;
                        APE.SETRANGE("Document No.", Rec."No.");
                        APE.SETRANGE(Posted, FALSE);
                        IF APE.FINDFIRST THEN
                            ERROR('Post/Delete Unposted %1 Entries', FORMAT(APE."Payment Mode"));

                        APE.RESET;
                        APE.SETRANGE("Document No.", Rec."No.");
                        APE.SETRANGE("Cheque Status", APE."Cheque Status"::" ");
                        IF APE.FINDFIRST THEN
                            ERROR('Pending Cheques must be Cleared/Bounced');

                        //ALLECK 060313 START
                        Memberof.RESET;
                        Memberof.SETRANGE(Memberof."User Name", USERID);
                        Memberof.SETRANGE(Memberof."Role ID", 'A_UNITCHANGE');
                        IF NOT Memberof.FINDFIRST THEN
                            ERROR('You do not have permission of role :A_UNITCHANGE');
                        //ALLECK 060313 End

                        COMMIT;

                        IF CONFIRM('Do you want to upload new unit?', TRUE) THEN BEGIN
                            //ALLECK 020313 START
                            AmountToWords.InitTextVariable;
                            AmountToWords.FormatNoText(AmountText1, ApplicationForm.CheckPaymentAmount(Rec."Application No."), '');
                            IF CONFIRM(STRSUBSTNO(Text006, Rec."Unit Code", Rec."New Unit No.")) THEN BEGIN
                                //    IF CONFIRM(Text006) THEN BEGIN //ALLECK020313
                                //ALLECK 020313 END


                                Companywise.RESET;
                                Companywise.SETRANGE("MSC Company", TRUE);
                                IF Companywise.FINDFIRST THEN;
                                OldUnitMaster.RESET;
                                OldUnitMaster.CHANGECOMPANY(Companywise."Company Code");
                                OldUnitMaster.SETRANGE("Project Code", Rec."New Project");
                                OldUnitMaster.SETRANGE("No.", Rec."New Unit No.");
                                IF NOT OldUnitMaster.FINDFIRST THEN
                                    ERROR('The MSCompany have not this unit. Please update in MSCompany')
                                ELSE
                                    OldUnitMaster.TESTFIELD(Status, OldUnitMaster.Status::Open);

                                /*
                                IF "Application Type" = "Application Type"::"Non Trading" THEN BEGIN
                                  IF Newconforder.GET("No.") THEN
                                    IF Newconforder."Project Change" THEN
                                      ERROR('Please run the Replication batch for Project Change in MSCompany');
                                END;
                                */

                                Rec.Status := Rec.Status::Open;
                                Commholforoldprocess := Rec."Comm hold for Old Process"; //280219
                                Rec."Comm hold for Old Process" := FALSE;
                                Rec.MODIFY;

                                CLEAR(ProjChngJVAmt);
                                APE.RESET;
                                APE.SETRANGE("Document No.", Rec."No.");
                                APE.SETRANGE("Cheque Status", APE."Cheque Status"::Cleared);
                                APE.SETRANGE(Posted, TRUE);
                                IF APE.FINDSET THEN
                                    REPEAT
                                        ProjChngJVAmt += APE.Amount;
                                    UNTIL APE.NEXT = 0;

                                CLEAR(APE);
                                APE.RESET;
                                APE.SETRANGE("Document No.", Rec."No.");
                                APE.SETRANGE("Cheque Status", APE."Cheque Status"::Cleared);
                                IF APE.FINDLAST THEN
                                    PostPayment.CreateProjectChangeLines(APE, FALSE, ProjChngJVAmt);

                                CLEAR(VersionNo);
                                Rec.TESTFIELD(Type, Rec.Type::Normal);
                                Rec.TESTFIELD("New Unit No.");
                                NPaymentPlanDetails1.RESET;
                                NPaymentPlanDetails1.SETCURRENTKEY("Document No.", "Version No.");
                                NPaymentPlanDetails1.SETRANGE("Document No.", Rec."No.");
                                IF NPaymentPlanDetails1.FINDSET THEN
                                    REPEAT
                                        IF VersionNo < NPaymentPlanDetails1."Version No." THEN
                                            VersionNo := NPaymentPlanDetails1."Version No.";
                                    UNTIL NPaymentPlanDetails1.NEXT = 0;

                                NPaymentPlanDetails.RESET;
                                NPaymentPlanDetails.SETRANGE("Document No.", Rec."No.");
                                IF NPaymentPlanDetails.FINDSET THEN
                                    REPEAT

                                        NPaymentPlanDetails1.RESET;
                                        NPaymentPlanDetails1.SETRANGE("Project Code", NPaymentPlanDetails."Project Code");
                                        NPaymentPlanDetails1.SETRANGE("Payment Plan Code", NPaymentPlanDetails."Payment Plan Code");
                                        NPaymentPlanDetails1.SETRANGE("Milestone Code", NPaymentPlanDetails."Milestone Code");
                                        NPaymentPlanDetails1.SETRANGE("Charge Code", NPaymentPlanDetails."Charge Code");
                                        NPaymentPlanDetails1.SETRANGE("Document No.", NPaymentPlanDetails."Document No.");
                                        NPaymentPlanDetails1.SETRANGE("Sale/Lease", NPaymentPlanDetails."Sale/Lease");
                                        NPaymentPlanDetails1.SETRANGE("Version No.", VersionNo);
                                        IF NOT NPaymentPlanDetails1.FINDFIRST THEN BEGIN
                                            NPaymentPlanDetails1.INIT;
                                            NPaymentPlanDetails1.TRANSFERFIELDS(NPaymentPlanDetails);
                                            NPaymentPlanDetails1."Version No." := VersionNo + 1;
                                            NPaymentPlanDetails1.INSERT;
                                        END;
                                    UNTIL NPaymentPlanDetails.NEXT = 0;
                                //END;
                                CLEAR(VersionNo);
                                NApplicableCharges1.RESET;
                                NApplicableCharges1.SETRANGE("Document No.", Rec."No.");
                                IF NApplicableCharges1.FINDSET THEN
                                    REPEAT
                                        IF VersionNo < NApplicableCharges1."Version No." THEN
                                            VersionNo := NApplicableCharges1."Version No.";
                                    UNTIL NApplicableCharges1.NEXT = 0;


                                NApplicableCharges.RESET;
                                NApplicableCharges.SETRANGE("Document No.", Rec."No.");
                                IF NApplicableCharges.FINDSET THEN
                                    REPEAT
                                        NApplicableCharges1.INIT;
                                        NApplicableCharges1.TRANSFERFIELDS(NApplicableCharges);
                                        NApplicableCharges1."Version No." := VersionNo + 1;
                                        NApplicableCharges1.INSERT;
                                    UNTIL NApplicableCharges.NEXT = 0;
                                //END;


                                CLEAR(VersionNo);
                                NArchivePaymentTermsLine1.RESET;
                                NArchivePaymentTermsLine1.SETRANGE("Document No.", Rec."No.");
                                IF NArchivePaymentTermsLine1.FINDSET THEN
                                    REPEAT
                                        IF VersionNo < NArchivePaymentTermsLine1."Version No." THEN
                                            VersionNo := NArchivePaymentTermsLine1."Version No.";
                                    UNTIL NArchivePaymentTermsLine1.NEXT = 0;


                                NArchivePaymentTermsLine.RESET;
                                NArchivePaymentTermsLine.SETRANGE("Document No.", Rec."No.");
                                IF NArchivePaymentTermsLine.FINDSET THEN
                                    REPEAT
                                        NArchivePaymentTermsLine.CALCFIELDS("Received Amt");
                                        NArchivePaymentTermsLine1.INIT;
                                        NArchivePaymentTermsLine1.TRANSFERFIELDS(NArchivePaymentTermsLine);
                                        NArchivePaymentTermsLine1."Received Amt" := NArchivePaymentTermsLine."Received Amt";
                                        NArchivePaymentTermsLine1."Version No." := VersionNo + 1;
                                        NArchivePaymentTermsLine1.INSERT;
                                    UNTIL NArchivePaymentTermsLine.NEXT = 0;
                                //END;
                                UpdateUnitwithApplicablecharge;
                                UnitCommCreationJob.UpdateMilestonePercentage(Rec."No.", FALSE);
                                //ALLETDK>>>>
                                Rec.CALCFIELDS("Total Received Amount");
                                CLEAR(ExcessAmount);
                                IF Rec.Amount < Rec."Total Received Amount" THEN
                                    ExcessAmount := Rec."Total Received Amount" - Rec.Amount;
                                IF ExcessAmount <> 0 THEN
                                    CreatUPEryfromConfOrderAPP.CreateExcessPaymentTermsLine(Rec."No.", ExcessAmount);
                                //ALLETDK<<<<
                                PostPayment.CreateProjectChangeLines(APE, TRUE, ProjChngJVAmt);
                                //BReversal.CheckandReverseTA(Rec."No.", FALSE);
                                UpdateTAGenerate := BReversal.CheckandReverseTA(Rec."No.", FALSE);
                                IF NOT UpdateTAGenerate THEN begin//220125
                                    IF Rec."Travel Generate" THEN begin
                                        Rec."Travel Generate" := FALSE;    //220125
                                        Rec.Modify;
                                    end;

                                END;
                                IF NOT Rec."Vizag datA" THEN
                                    UnitPost.NewUpdateTEAMHierarcy(Rec, TRUE); //BBG1.00 050613  //221223
                                                                               //211114

                                // IF OldProject = NewProject THEN BEGIN
                                OldUPmtEntry.RESET;
                                OldUPmtEntry.SETRANGE("Document Type", OldUPmtEntry."Document Type"::BOND);
                                OldUPmtEntry.SETRANGE("Document No.", Rec."No.");
                                OldUPmtEntry.SETRANGE(Posted, TRUE);
                                OldUPmtEntry.SETFILTER("Payment Mode", '=%1', OldUPmtEntry."Payment Mode"::JV);
                                IF OldUPmtEntry.FINDLAST THEN BEGIN
                                    OldUPEntry.RESET;
                                    OldUPEntry.SETRANGE("Document Type", OldUPEntry."Document Type"::BOND);
                                    OldUPEntry.SETRANGE("Document No.", Rec."No.");
                                    OldUPEntry.SETRANGE(Posted, TRUE);
                                    OldUPEntry.SETRANGE("Posted Document No.", OldUPmtEntry."Posted Document No.");
                                    OldUPEntry.SETFILTER(Amount, '>%1', 0);
                                    OldUPEntry.SETRANGE("Commision Applicable", TRUE);     //110219
                                    IF OldUPEntry.FINDSET THEN
                                        REPEAT
                                            ComHoldDate := 0D;
                                            ComHoldDate := DMY2DATE(31, 10, 2014);
                                            IF OldUPEntry."Posting date" > ComHoldDate THEN
                                                CommHold := TRUE;
                                            IF Rec."Posting Date" > ComHoldDate THEN
                                                CommHold := FALSE;
                                            PostPayment.CreateStagingTableAppBond(Rec, OldUPEntry."Line No." / 10000, 1, OldUPEntry.Sequence,
                                            OldUPEntry."Cheque No./ Transaction No.", OldUPEntry."Commision Applicable", OldUPEntry."Direct Associate",
                                            OldUPEntry."Posting date", OldUPEntry.Amount, OldUPEntry, CommHold, Rec."Old Process");
                                        UNTIL OldUPEntry.NEXT = 0;
                                    OldUPEntry.RESET;
                                    OldUPEntry.SETRANGE("Document Type", OldUPEntry."Document Type"::BOND);
                                    OldUPEntry.SETRANGE("Document No.", Rec."No.");
                                    OldUPEntry.SETRANGE(Posted, TRUE);
                                    OldUPEntry.SETRANGE("Posted Document No.", OldUPmtEntry."Posted Document No.");
                                    OldUPEntry.SETFILTER(Amount, '>%1', 0);
                                    OldUPEntry.SETRANGE("Direct Associate", TRUE);
                                    IF OldUPEntry.FINDSET THEN
                                        REPEAT
                                            ComHoldDate := 0D;
                                            ComHoldDate := DMY2DATE(31, 10, 2014);
                                            IF OldUPEntry."Posting date" > ComHoldDate THEN
                                                CommHold := TRUE;
                                            IF Rec."Posting Date" > ComHoldDate THEN
                                                CommHold := FALSE;
                                            PostPayment.CreateStagingTableAppBond(Rec, OldUPEntry."Line No." / 10000, 1, OldUPEntry.Sequence,
                                            OldUPEntry."Cheque No./ Transaction No.", OldUPEntry."Commision Applicable", OldUPEntry."Direct Associate",
                                            OldUPEntry."Posting date", OldUPEntry.Amount, OldUPEntry, CommHold, Rec."Old Process");
                                        UNTIL OldUPEntry.NEXT = 0;

                                END;
                                CLEAR(CommisionGen);
                                RecCommissionEntry.RESET;
                                RecCommissionEntry.SETCURRENTKEY("Commission Run Date");
                                RecCommissionEntry.SETFILTER("Commission Run Date", '<>%1', 0D);
                                IF RecCommissionEntry.FINDLAST THEN
                                    CommisionGen.CreateBondandCommission(RecCommissionEntry."Commission Run Date", Rec."Introducer Code", Rec."No.", '', '', TRUE)
                                ELSE
                                    CommisionGen.CreateBondandCommission(WORKDATE, Rec."Introducer Code", Rec."No.", '', '', TRUE);

                                //   END;
                            END;//ALLECK 030313
                        END;//ALLECK 030313
                            //BBG2.01 231214
                        ArchiveConfirmedOrder.RESET;
                        ArchiveConfirmedOrder.SETRANGE("No.", Rec."No.");
                        IF ArchiveConfirmedOrder.FINDLAST THEN BEGIN
                            IF ArchiveConfirmedOrder."Shortcut Dimension 1 Code" <> Rec."Shortcut Dimension 1 Code" THEN BEGIN
                                IF Newconforder.GET(Rec."No.") THEN BEGIN
                                    IF Rec."Application Type" = Rec."Application Type"::"Non Trading" THEN BEGIN
                                        Newconforder."Project Change" := TRUE;
                                        Newconforder."Old Project Code" := Newconforder."Shortcut Dimension 1 Code";
                                        Newconforder.MODIFY;
                                    END ELSE BEGIN
                                        AppPayentry_1.RESET;
                                        AppPayentry_1.SETRANGE("Document No.", Rec."No.");
                                        AppPayentry_1.SETFILTER(Amount, '<%1', 0);
                                        IF AppPayentry_1.FINDLAST THEN
                                            UnitReversal.CreateProjectChangeEntriesTR(Rec."No.", AppPayentry_1."Line No.");
                                    END;
                                END;
                            END;
                        END;
                        IF Newconforder.GET(Rec."No.") THEN BEGIN
                            Newconforder."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                            Newconforder."Unit Code" := Rec."Unit Code";
                            Newconforder."Saleable Area" := Rec."Saleable Area";
                            Newconforder."Min. Allotment Amount" := Rec."Min. Allotment Amount";
                            Newconforder.Amount := Rec.Amount;
                            Newconforder."Project change Comment" := Rec."Project change Comment";
                            Newconforder.Status := Newconforder.Status::Open;
                            Newconforder."Project Type" := Rec."Project Type";
                            Newconforder."Unit Payment Plan" := Rec."Unit Payment Plan";
                            Newconforder.Status := Rec.Status;
                            Newconforder."Unit Plan Name" := Rec."Unit Plan Name";
                            Newconforder."60 feet road" := Rec."60 feet road";  //090921
                            Newconforder."100 feet road" := Rec."100 feet road"; //090921
                            Newconforder.MODIFY;
                            //BBG2.0
                            UnitMaster_2.GET(Rec."Unit Code");
                            CompanywiseGLAccount.RESET;
                            CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
                            IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                                ProjectwiseDevelopmentCharg.RESET;
                                ProjectwiseDevelopmentCharg.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                                ProjectwiseDevelopmentCharg.SETRANGE("Project Code", Rec."Shortcut Dimension 1 Code");
                                IF ProjectwiseDevelopmentCharg.FINDSET THEN
                                    REPEAT
                                        IF ProjectwiseDevelopmentCharg."End Date" = 0D THEN
                                            EndDate := TODAY
                                        ELSE
                                            EndDate := ProjectwiseDevelopmentCharg."End Date";
                                        IF (Rec."Posting Date" > ProjectwiseDevelopmentCharg."Start Date") AND (Rec."Posting Date" < EndDate) THEN
                                            Newconforder."Development Charges" := ProjectwiseDevelopmentCharg.Amount * UnitMaster_2."Saleable Area";
                                    UNTIL ProjectwiseDevelopmentCharg.NEXT = 0;
                            END;

                            //Newconforder.MODIFY;
                            /*  //160921
                            V_CompanyInformation.RESET;
                            V_CompanyInformation.CHANGECOMPANY(Newconforder."Company Name");
                            IF V_CompanyInformation.FINDFIRST THEN BEGIN
                              v_ConfirmedOrder.RESET;
                              v_ConfirmedOrder.CHANGECOMPANY(V_CompanyInformation."Development Company Name");
                              IF v_ConfirmedOrder.GET(Newconforder."No.") THEN BEGIN
                                v_ConfirmedOrder."Development Charges" := Newconforder."Development Charges";
                                v_ConfirmedOrder.MODIFY;
                              END;
                            END;
                            */  //160921
                                //BBG2.0
                        END;
                        CreateUnitLifeCycle; //040919
                        UnitReversal.CreateCommCreditMemo(Rec."No.", TRUE);  //BBG2.0   030321
                        UnitReversal.CreateTACreditMemo(Rec."Introducer Code", 0, Rec."No.", TRUE);  //BBG2.0

                        v_ConfirmedOrder1.RESET;
                        IF v_ConfirmedOrder1.GET(Rec."No.") THEN BEGIN
                            v_ConfirmedOrder1."Comm hold for Old Process" := Commholforoldprocess;  //280219
                            v_ConfirmedOrder1."Development Charges" := Newconforder."Development Charges";
                            IF v_ConfirmedOrder1."Travel applicable" then
                                v_ConfirmedOrder1."Send for Approval (Unit Vacte)" := FALSE;
                            v_ConfirmedOrder1."Send for Aproval Dt (UnitVct)" := 0D;
                            v_ConfirmedOrder1."Approval Status (Unit Vacte)" := Rec."Approval Status (Unit Vacte)"::" ";
                            /*  //280121
                            //ALLEDK 210921 Start
                            CompanywiseGLAccount.RESET;
                            CompanywiseGLAccount.SETRANGE("MSC Company",TRUE);
                            IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
                              v_ResponsibilityCenter.RESET;
                              v_ResponsibilityCenter.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
                            END;
                               v_ResponsibilityCenter.GET(v_ConfirmedOrder1."Shortcut Dimension 1 Code");
                               v_ResponsibilityCenter.TESTFIELD("Min. Allotment %");
                               v_ConfirmedOrder1."Development Charges" := Newconforder."Development Charges";
                              v_ConfirmedOrder1."Min. Allotment Amount" := ROUND(((v_ConfirmedOrder1.Amount + v_ConfirmedOrder1."Development Charges") * v_ResponsibilityCenter."Min. Allotment %"/100),1,'=');
                              //MESSAGE('%1..%2',v_ConfirmedOrder1.Amount,v_ConfirmedOrder1."Min. Allotment Amount");
                              */  //280121


                            v_ConfirmedOrder1.MODIFY;
                            // Newconforder.RESET;   //Code commented 25082025
                            // IF Newconforder.GET(Rec."No.") THEN BEGIN    //Code commented 25082025
                            //     Newconforder."Min. Allotment Amount" := v_ConfirmedOrder1."Min. Allotment Amount";    //Code commented 25082025
                            //     Newconforder.MODIFY;
                            UnitMaster_2.GET(v_ConfirmedOrder1."Unit Code");
                            UnitMaster_2."Customer Code" := v_ConfirmedOrder1."Customer No.";
                            IF recCustomer.GET(v_ConfirmedOrder1."Customer No.") THEN BEGIN
                                UnitMaster_2."Customer Name" := recCustomer.Name;
                                UnitMaster_2.MODIFY;
                            END;
                            // END;      //Code commented 25082025                                    
                        END;


                        //PostGoldGLEEntry("No.",OldProject,"New Project");  //BBG2.0   310720  Comment 251121
                        //BBG2.01 231214

                        //HK
                        // Conforder_2.RESET;  //25082025
                        // IF Conforder_2.GET(Rec."No.") THEN BEGIN  //25082025
                        //     Conforder_2."Travel applicable" :=
                        //         Conforder_2."Send for Approval (Unit Vacte)" := FALSE;
                        //     Conforder_2."Send for Aproval Dt (UnitVct)" := 0D;
                        //     Conforder_2."Approval Status (Unit Vacte)" := Rec."Approval Status (Unit Vacte)"::" ";
                        //     Conforder_2.MODIFY;
                        // END;
                        //251124 Code added start
                        Commit;

                        New_UnitMaster.RESET;  //041024 Added new code
                        IF New_UnitMaster.GET(Rec."New Unit No.") THEN
                            WebAppService.UpdateUnitStatus(New_UnitMaster);
                        //WebAppService.UpdateUnitStatus(UnitMaster_2);  

                        //251124 Code added END
                        MESSAGE('%1', 'Process done successful');

                    end;
                }
                action("Send for Approval")
                {
                    Caption = 'Send for Approval (For Unit Allot)';

                    trigger OnAction()
                    var
                        LineNo: Integer;
                        v_RequesttoApproveDocuments_1: Record "Request to Approve Documents";

                    begin
                        //Unit Allot
                        //IF Rec."Approval Status (Unit Allot)" = Rec."Approval Status (Unit Allot)"::Approved THEN  //24102025 Code commented
                        //  ERROR('Document already approved.');    //24102025 Code commented
                        IF (Rec."Approval Status (Unit Allot)" = Rec."Approval Status (Unit Allot)"::" ") AND (Rec."Send for Approval (Unit Allot)") then
                            Message('Document already send for Approval');
                        Rec."Send for Approval (Unit Allot)" := False;
                        Rec.Modify();
                        Commit();

                        IF CONFIRM('Do  you want to send Document Send for Approval') THEN BEGIN




                            LineNo := 0;
                            RequesttoApproveDocuments.RESET;
                            RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::"Unit Allocation");
                            RequesttoApproveDocuments.SETRANGE("Document No.", Rec."No.");
                            //RequesttoApproveDocuments.SETRANGE("Document Line No.","Line No.");
                            IF RequesttoApproveDocuments.FINDLAST THEN
                                LineNo := RequesttoApproveDocuments."Line No.";

                            ApprovalWorkflowforAuditPr.RESET;
                            ApprovalWorkflowforAuditPr.SETRANGE("Document Type", ApprovalWorkflowforAuditPr."Document Type"::"Unit Allocation");
                            ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", USERID);
                            IF ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
                                REPEAT
                                    RequesttoApproveDocuments.RESET;
                                    RequesttoApproveDocuments.INIT;
                                    RequesttoApproveDocuments."Document Type" := RequesttoApproveDocuments."Document Type"::"Unit Allocation";
                                    RequesttoApproveDocuments."Document No." := Rec."No.";
                                    //RequesttoApproveDocuments."Document Line No." := "Line No.";
                                    RequesttoApproveDocuments."Line No." := LineNo + 10000;
                                    RequesttoApproveDocuments.Amount := Rec.Amount;
                                    RequesttoApproveDocuments."Posting Date" := Rec."Posting Date";
                                    RequesttoApproveDocuments."Requester ID" := USERID;
                                    RequesttoApproveDocuments."Approver ID" := ApprovalWorkflowforAuditPr."Approver ID";
                                    RequesttoApproveDocuments.Sequence := ApprovalWorkflowforAuditPr.Sequence;
                                    RequesttoApproveDocuments."Requester DateTime" := CURRENTDATETIME;
                                    RequesttoApproveDocuments.INSERT;
                                    LineNo := RequesttoApproveDocuments."Line No."
                              UNTIL ApprovalWorkflowforAuditPr.NEXT = 0;
                                Rec."Send for Approval (Unit Allot)" := TRUE;
                                Rec."Send for Aproval Dt (UnitAllt)" := TODAY;
                                // IF Rec."Approval Status (Unit Allot)" = Rec."Approval Status (Unit Allot)"::Rejected THEN   //24102025 Code comment
                                Rec."Approval Status (Unit Allot)" := Rec."Approval Status (Unit Allot)"::" ";

                                Rec.MODIFY;
                            END ELSE
                                ERROR('Approver not found against this Sender');
                        END ELSE
                            MESSAGE('Nothing Process');
                    end;
                }
                action("&Attach Documents")
                {
                    Caption = '&Attach Documents';
                    Promoted = true;
                    RunObject = Page "Document file Upload";
                    RunPageLink = "Table No." = CONST(97793),
                                  "Document No." = FIELD("No.");
                }
                action("View Document")
                {
                    Visible = false;

                    trigger OnAction()
                    begin
                        DocumentSetup.GET;
                        DocumentSetup.TESTFIELD("Audit File Upload Path");
                        //HYPERLINK('\\192.168.1.10\dms\BBG_DocumentUpload\wwwroot\Uploaded\AddressProof\scaled_IMG-20230812-WA0017.jpg');
                    end;
                }
                action(Navigate)
                {
                    Image = Navigate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrPage.PostedUnitPayEntrySubform.PAGE.NavigateEntry;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin

        UpdateApplicationInfo;
        Rec.SETRANGE("No.");
    end;

    trigger OnOpenPage()
    begin

        Memberof.SETRANGE("User Name", USERID);
        Memberof.SETRANGE(Memberof."Role ID", 'A_UNITCHANGE');
        IF NOT Memberof.FINDFIRST THEN
            ERROR('You do not have permission of role  :A_UNITCHANGE');


        IF Rec.Type = Rec.Type::Normal THEN BEGIN
            IF Rec."Unit Code" = '' THEN BEGIN
                NewUnitEditable := TRUE;
                NewProjectEditable := TRUE;
            END ELSE BEGIN
                NewUnitEditable := FALSE;
                NewProjectEditable := FALSE;
            END;
        END ELSE BEGIN
            NewUnitEditable := TRUE;
            NewProjectEditable := TRUE;
        END;
    end;

    var
        Text000: Label '&First Unit Holder,&Second Unit Holder,First &and Second Unit Holder';
        Text001: Label 'Do you want to reassign Marketing Member for the Unit No. %1 ?';
        Text002: Label 'Do you want to change %1 for the Unit No. %2 ?';
        Text003: Label 'Release the Neft details.';
        Text004: Label 'Please enter bank details.';
        Text005: Label 'Do you want to Cancell the Unit and Post Commission Reversal?';
        Text006: Label 'Are you sure you want to post the entries';
        Text007: Label 'Posting Done';
        Text008: Label 'Do you want to register the Unit %1?';
        Text009: Label 'Registration Done';
        Text010: Label 'Do you want the reverse the Commision';
        Text011: Label 'Cancellation Done';
        Text012: Label 'Do you want to Vacate the Plot %1?';
        Text013: Label 'you sure you want to post the entries';
        Text014: Label 'Please check and confirm.\You are going to transfer\Amount            :%1\from Customer :%2 to %3\%4:%5\Posting Date    : %6.';
        ReceivableAmount: Decimal;
        AmountReceived: Decimal;
        DueAmount: Decimal;
        ReleaseBondApplication: Codeunit "Release Unit Application";
        Dummy: Text[30];
        BondHolderName: Text[50];
        BondHolderName2: Text[50];
        Customer: Record Customer;
        Customer2: Record Customer;
        BondNominee: Record "Unit Nominee";
        Vendor: Record Vendor;
        SchemeHeader: Record "Document Type Initiator";
        BondMaturity: Record "Unit Maturity";
        ReassignType: Option FirstBondHolder,SecondBondHolder,BothBondHolder,MarketingMember;
        Selection: Integer;
        BondChangeType: Option Scheme,"Investment Frequency","Return Frequency","Return Payment Mode","Bond Holder","Co Bond Holder","Marketing Member","Business Transfer";
        GetDescription: Codeunit GetDescription;
        CustomerBankAccount: Record "Customer Bank Account";
        Unitmaster: Record "Unit Master";
        UserSetup: Record "User Setup";
        UnpostedInstallment: Integer;
        BondSetup: Record "Unit Setup";
        BondpaymentEntry: Record "Unit Payment Entry";
        PaymentTermLines: Record "Payment Terms Line Sale";
        LineNo: Integer;
        PostPayment: Codeunit PostPayment;
        MsgDialog: Dialog;
        PenaltyAmount: Decimal;
        ReverseComm: Boolean;
        Bond: Record "Confirmed Order";
        ComEntry: Record "Commission Entry";
        ReceivedAmount: Decimal;
        TotalAmount: Decimal;
        ExcessAmount: Decimal;
        ConOrder: Record "Confirmed Order";
        UnitPaymentEntry: Record "Unit Payment Entry";
        BondReversal: Codeunit "Unit Reversal";
        UnitCommCreationJob: Codeunit "Unit and Comm. Creation Job";
        ArchiveConfirmedOrder: Record "Archive Confirmed Order";
        LastVersion: Integer;
        ConfirmOrder: Record "Confirmed Order";
        NPaymentPlanDetails: Record "Payment Plan Details";
        NPaymentPlanDetails1: Record "Archive Payment Plan Details";
        NApplicableCharges: Record "Applicable Charges";
        NApplicableCharges1: Record "Archive Applicable Charges";
        NArchivePaymentTermsLine: Record "Payment Terms Line Sale";
        NArchivePaymentTermsLine1: Record "Archive Payment Terms Line";
        "-----------------UNIT INSERT -": Integer;
        AppCharges: Record "Applicable Charges";
        Docmaster: Record "Document Master";
        PPGD: Record "Project Price Group Details";
        UnitMasterRec: Record "Unit Master";
        Plcrec: Record "PLC Details";
        totalamount1: Decimal;
        PaymentDetails: Record "Payment Plan Details";
        Sno: Code[10];
        PaymentPlanDetails2: Record "Payment Plan Details" temporary;
        Applicablecharge: Record "Applicable Charges";
        MilestoneCodeG: Code[10];
        LoopingAmount: Decimal;
        InLoop: Boolean;
        PaymentPlanDetails: Record "Payment Plan Details";
        PaymentPlanDetails1: Record "Payment Plan Details";
        UnitCode: Code[20];
        OldCust: Code[20];
        UnitpayEntry: Record "Unit Payment Entry";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
        CustLedgEntry: Record "Cust. Ledger Entry";
        GenJnlLine: Record "Gen. Journal Line" temporary;
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        DocNo1: Code[20];
        Amt: Decimal;
        UnitSetup: Record "Unit Setup";
        LineNo2: Integer;
        DocNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Job: Record Job;
        ConfOrder: Record "Confirmed Order";
        BondInvestmentAmt: Decimal;
        ByCheque: Boolean;
        AppPaymentEntry: Record "Application Payment Entry";
        GLSetup: Record "General Ledger Setup";
        Vend: Record Vendor;
        AmountToWords: Codeunit "Amount To Words";
        AmountText1: array[2] of Text[300];
        ApplicationForm: Page Application;
        Memberof: Record "Access Control";
        ProjChngJVAmt: Decimal;
        CommissionEntry: Record "Commission Entry";
        TotAppAmt: Decimal;
        UnitPost: Codeunit "Unit Post";
        RecCommissionEntry: Record "Commission Entry";
        ProjChngJVAmt1: Decimal;
        UnitReversal: Codeunit "Unit Reversal";
        Newconforder: Record "New Confirmed Order";
        RecUnitMaster: Record "Unit Master";
        Companywise: Record "Company wise G/L Account";
        OldUPmtEntry: Record "Unit Payment Entry";
        OldUnitMaster: Record "Unit Master";
        OldAppExists: Record Application;
        RespCenter: Record "Responsibility Center 1";
        ProjectMilestoneHdr: Record "Project Milestone Header";
        UpdateChargesAssPmt: Codeunit "UpdateCharges /Post/Rev AssPmt";
        UPName: Text[30];
        TotalValue: Decimal;
        TotalFixed: Decimal;
        AlltAmount: Decimal;
        ProjMilestoneLine: Record "Project Milestone Line";
        Vend_1: Record Vendor;
        NewUnitEditable: Boolean;
        NewProjectEditable: Boolean;
        NewProject: Code[20];
        OldProject: Code[20];
        Commholforoldprocess: Boolean;
        RecConforders: Record "Confirmed Order";
        RecApplication: Record Application;
        v_Conforder: Record "Confirmed Order";
        v_ResponsibilityCenter: Record "Responsibility Center 1";
        MasterCompany: Text[50];
        NewUnitTaged: Boolean;
        RequesttoApproveDocuments: Record "Request to Approve Documents";
        ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        DocumentSetup: Record "Document Setup";
        Docmaster_3: Record "Document Master";
        WebAppService: Codeunit "Web App Service";

    local procedure UpdateApplicationInfo()
    begin
        ReceivableAmount := Rec.TotalApplicationAmount;
        AmountReceived := Rec.Amount;  //"Amount Received";
        DueAmount := ReceivableAmount - AmountReceived;

        IF Rec."Introducer Code" <> '' THEN
            IF Vend.GET(Rec."Introducer Code") THEN;
        IF Rec."Customer No." <> '' THEN
            Customer.GET(Rec."Customer No."); //23/213
    end;


    procedure ConfirmNeft()
    var
        CustomerBankAccount: Record "Customer Bank Account";
        Customer: Record Customer;
        Application: Record Application;
    begin
        IF CONFIRM(Text003) THEN BEGIN
            IF Rec."Return Payment Mode" = Rec."Return Payment Mode"::NEFT THEN BEGIN
                IF CustomerBankAccount.GET(Rec."Customer No.", Rec."Return Bank Account Code") THEN BEGIN
                    IF NOT CustomerBankAccount."Entry Completed" THEN BEGIN
                        CustomerBankAccount.TESTFIELD(Code);
                        CustomerBankAccount.TESTFIELD(Name);      //Bank Name
                        CustomerBankAccount.TESTFIELD("SWIFT Code");
                        CustomerBankAccount.TESTFIELD("Bank Branch No.");
                        CustomerBankAccount.TESTFIELD("Name 2");  //Branch Name
                        CustomerBankAccount.TESTFIELD("Bank Account No.");
                        CustomerBankAccount."Entry Completed" := TRUE;
                        CustomerBankAccount.MODIFY;
                    END;
                END ELSE
                    ERROR(Text004);
            END;
        END;
    end;


    procedure NeftDetail()
    var
        CustomerBankAccount: Record "Customer Bank Account";
        //CustomerBankInformation: Page 82;
        BankCode: Code[20];
    begin
        CustomerBankAccount.RESET;

        CustomerBankAccount.SETRANGE("Customer No.", Rec."Customer No.");
        IF Rec."Return Bank Account Code" <> '' THEN
            CustomerBankAccount.SETRANGE(Code, Rec."Return Bank Account Code")
        ELSE
            CustomerBankAccount.SETRANGE(Code, Rec."No.");

        IF PAGE.RUNMODAL(82, CustomerBankAccount) = ACTION::LookupOK THEN BEGIN
            Rec."Return Bank Account Code" := CustomerBankAccount.Code;
            Rec.MODIFY;
        END;
    end;


    procedure SplitAppPaymnetEntries()
    var
        AppPaymentEntry: Record "Application Payment Entry";
        TempBondPaymentEntry: Record "Application Payment Entry" temporary;
        DifferenceAmount: Decimal;
        LoopingDifferAmount: Decimal;
        BondPayLineAmt: Decimal;
        TotalBondAmount: Decimal;
        AppliPaymentAmount: Decimal;
    begin
        TotalBondAmount := 0;
        AppliPaymentAmount := 0;
        BondSetup.GET;

        AppPaymentEntry.RESET;
        AppPaymentEntry.SETRANGE("Document Type", AppPaymentEntry."Document Type"::BOND);
        AppPaymentEntry.SETRANGE("Document No.", Rec."No.");
        AppPaymentEntry.SETRANGE("Explode BOM", FALSE);
        AppPaymentEntry.SETRANGE(Posted, FALSE);
        IF AppPaymentEntry.FINDSET THEN BEGIN
            AppliPaymentAmount := AppPaymentEntry.Amount;
            REPEAT
                //IF AppPaymentEntry."Posting date" <> WORKDATE THEN
                //  ERROR('Payment Entry Posting Date must be same as WORK DATE');
                TotalBondAmount := TotalBondAmount + AppPaymentEntry.Amount;
            UNTIL AppPaymentEntry.NEXT = 0;
        END
        ELSE
            ERROR('You must enter the payment lines');

        IF Rec.Type = Rec.Type::Priority THEN BEGIN
            IF Rec."New Unit No." <> '' THEN
                Unitmaster.GET(Rec."New Unit No.")  //ALLEDK 231112
            ELSE
                Unitmaster.GET(Rec."Unit Code");
        END ELSE
            Unitmaster.GET(Rec."Unit Code");

        IF AppPaymentEntry.FINDSET THEN;
        GetLastLineNo(AppPaymentEntry);
        DifferenceAmount := 0;
        PaymentTermLines.RESET;
        PaymentTermLines.SETRANGE("Document No.", Rec."Application No.");
        PaymentTermLines.SETRANGE("Payment Plan", Unitmaster."Payment Plan"); //ALLEDK 231112
        IF PaymentTermLines.FIND('-') THEN
            REPEAT
                PaymentTermLines.CALCFIELDS("Received Amt");
                DifferenceAmount := PaymentTermLines."Due Amount" - PaymentTermLines."Received Amt";
                LoopingDifferAmount := 0;
                REPEAT
                    IF DifferenceAmount < AppliPaymentAmount THEN BEGIN
                        IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                            BondPayLineAmt := AppliPaymentAmount;
                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                        END ELSE BEGIN
                            BondPayLineAmt := DifferenceAmount;
                            AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                        END;
                        TotalBondAmount := TotalBondAmount - BondPayLineAmt;//ALLE PS
                        LoopingDifferAmount := DifferenceAmount - BondPayLineAmt;
                    END ELSE
                        IF DifferenceAmount > AppliPaymentAmount THEN BEGIN
                            IF AppliPaymentAmount < DifferenceAmount THEN BEGIN
                                BondPayLineAmt := AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                            END ELSE BEGIN
                                BondPayLineAmt := AppliPaymentAmount - AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                            END;
                            TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                            DifferenceAmount := DifferenceAmount - BondPayLineAmt;
                            LoopingDifferAmount := DifferenceAmount - TotalBondAmount;
                        END ELSE
                            IF DifferenceAmount = AppliPaymentAmount THEN BEGIN
                                BondPayLineAmt := AppliPaymentAmount;
                                AppliPaymentAmount := AppliPaymentAmount - BondPayLineAmt;
                                TotalBondAmount := TotalBondAmount - BondPayLineAmt;
                            END;
                    IF BondPayLineAmt <> 0 THEN
                        CreatePaymentEntryLine(BondPayLineAmt, AppPaymentEntry);
                    IF AppliPaymentAmount = 0 THEN BEGIN
                        AppPaymentEntry."Explode BOM" := TRUE;
                        AppPaymentEntry.MODIFY;
                        AppPaymentEntry.NEXT;
                        AppliPaymentAmount := AppPaymentEntry.Amount;
                    END;
                UNTIL (LoopingDifferAmount = 0) OR (TotalBondAmount = 0);
            UNTIL (PaymentTermLines.NEXT = 0) OR (TotalBondAmount = 0);
    end;


    procedure CreatePaymentEntryLine(Amt: Decimal; BondPaymentEntryRec: Record "Application Payment Entry")
    var
        UserSetup: Record "User Setup";
        LBondPaymentEntry: Record "Unit Payment Entry";
    begin
        BondpaymentEntry.INIT;
        BondpaymentEntry."Document Type" := BondPaymentEntryRec."Document Type";
        BondpaymentEntry."Document No." := Rec."Application No.";
        BondpaymentEntry."Line No." := LineNo;
        LineNo += 10000;
        BondpaymentEntry.VALIDATE("Unit Code", BondPaymentEntryRec."Unit Code"); //ALLETDK141112
        BondpaymentEntry.VALIDATE("Payment Mode", BondPaymentEntryRec."Payment Mode");
        BondpaymentEntry."Application No." := BondPaymentEntryRec."Document No.";
        BondpaymentEntry."Document Date" := BondPaymentEntryRec."Document Date";
        BondpaymentEntry."Posting date" := BondPaymentEntryRec."Posting date";
        BondpaymentEntry.Type := BondPaymentEntryRec.Type;
        BondpaymentEntry.Sequence := PaymentTermLines.Sequence; //ALLETDK221112
        BondpaymentEntry."Charge Code" := PaymentTermLines."Charge Code"; //ALLETDK081112
        BondpaymentEntry."Actual Milestone" := PaymentTermLines."Actual Milestone"; //ALLETDK221112
        BondpaymentEntry."Commision Applicable" := PaymentTermLines."Commision Applicable";
        BondpaymentEntry."Direct Associate" := PaymentTermLines."Direct Associate";
        BondpaymentEntry."Priority Payment" := BondPaymentEntryRec."Priority Payment";
        IF ((BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::Bank)
            // BBG1.01 251012 START
            OR (BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.C./C.C./Net Banking")) THEN BEGIN
            // BBG1.01 251012 END
            BondpaymentEntry.VALIDATE("Cheque No./ Transaction No.", BondPaymentEntryRec."Cheque No./ Transaction No.");
            BondpaymentEntry.VALIDATE("Cheque Date", BondPaymentEntryRec."Cheque Date");
            BondpaymentEntry.VALIDATE("Cheque Bank and Branch", BondPaymentEntryRec."Cheque Bank and Branch");
            BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");
            BondpaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.", BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
            BondpaymentEntry.VALIDATE("Deposit/Paid Bank", BondPaymentEntryRec."Deposit/Paid Bank");
        END;

        IF BondPaymentEntryRec."Payment Mode" = BondPaymentEntryRec."Payment Mode"::"D.D." THEN BEGIN
            BondpaymentEntry.VALIDATE("Cheque No./ Transaction No.", BondPaymentEntryRec."Cheque No./ Transaction No.");
            BondpaymentEntry.VALIDATE("Cheque Date", BondPaymentEntryRec."Cheque Date");
            BondpaymentEntry.VALIDATE("Cheque Bank and Branch", BondPaymentEntryRec."Cheque Bank and Branch");
            BondpaymentEntry.VALIDATE("Cheque Status", BondPaymentEntryRec."Cheque Status");
            BondpaymentEntry.VALIDATE("Chq. Cl / Bounce Dt.", BondPaymentEntryRec."Chq. Cl / Bounce Dt.");
            BondpaymentEntry.VALIDATE("Deposit/Paid Bank", BondPaymentEntryRec."Deposit/Paid Bank");
        END;
        BondpaymentEntry.Amount := Amt;
        UserSetup.GET(USERID);
        BondpaymentEntry."Shortcut Dimension 1 Code" := UserSetup."Responsibility Center";
        BondpaymentEntry."Shortcut Dimension 2 Code" := UserSetup."Shortcut Dimension 2 Code";
        BondpaymentEntry."Explode BOM" := TRUE;
        //BondpaymentEntry.Posted := TRUE; //ALLEDK 230213
        BondpaymentEntry."Cheque Status" := BondPaymentEntryRec."Cheque Status";  //ALLEDK 070313
        BondpaymentEntry."Branch Code" := BondPaymentEntryRec."User Branch Code"; //ALLETDK141112
        BondpaymentEntry."User ID" := BondPaymentEntryRec."User ID"; //ALLEDK271212
        BondpaymentEntry."App. Pay. Entry Line No." := BondPaymentEntryRec."Line No."; //ALLETDK141112
        BondpaymentEntry.INSERT;
    end;


    procedure GetLastLineNo(BondPaymentEntryRec: Record "Application Payment Entry")
    var
        BPayEntry: Record "Unit Payment Entry";
    begin
        LineNo := 0;
        BPayEntry.RESET;
        BPayEntry.SETRANGE("Document Type", BondPaymentEntryRec."Document Type");
        BPayEntry.SETFILTER(BPayEntry."Document No.", BondPaymentEntryRec."Document No.");
        IF BPayEntry.FINDLAST THEN
            LineNo := BPayEntry."Line No." + 10000
        ELSE
            LineNo := 10000;
    end;


    procedure CheckExcessAmount(ConfirmOrder: Record "Confirmed Order"): Boolean
    var
        RecDueAmount: Decimal;
        ApplPayEntry: Record "Application Payment Entry";
        CurrPayAmount: Decimal;
    begin
        CLEAR(RecDueAmount);
        CLEAR(CurrPayAmount);
        CLEAR(ExcessAmount);
        Rec.CALCFIELDS("Total Received Amount");
        RecDueAmount := Rec.Amount + Rec."Service Charge Amount" - Rec."Discount Amount" - Rec."Total Received Amount";
        IF RecDueAmount > 0 THEN BEGIN
            ApplPayEntry.RESET;
            ApplPayEntry.SETRANGE("Document Type", ApplPayEntry."Document Type"::BOND);
            ApplPayEntry.SETRANGE("Document No.", Rec."No.");
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


    procedure CreateExcessPaymentTermsLine()
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
        PaymentTermLines1.SETRANGE("Document No.", Rec."No.");
        IF PaymentTermLines1.FINDLAST THEN BEGIN
            IF PaymentTermLines1."Charge Code" <> ExcessCode THEN BEGIN
                PaymentTermLines.INIT;
                PaymentTermLines."Document Type" := PaymentTermLines1."Document Type";
                PaymentTermLines."Document No." := Rec."No.";
                PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
                PaymentTermLines.Sequence := INCSTR(PaymentTermLines1.Sequence); //ALLETDK221112
                PaymentTermLines."Actual Milestone" := PaymentTermLines1."Actual Milestone";
                PaymentTermLines."Payment Plan" := PaymentTermLines1."Payment Plan";
                PaymentTermLines.Description := 'Excess Payment';
                PaymentTermLines."Due Date" := PaymentTermLines1."Due Date";
                PaymentTermLines."Project Code" := Rec."Shortcut Dimension 1 Code";
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


    procedure CreateUnitPaymentApplication()
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        AmountRecd: Decimal;
        InstallmentNo: Integer;
        YearCode: Integer;
        ChequeNo: Code[10];
        DirectAss: Boolean;
    begin
        UnitpayEntry.RESET;
        UnitpayEntry.SETRANGE("Document Type", UnitpayEntry."Document Type"::BOND);
        UnitpayEntry.SETRANGE("Document No.", Rec."No.");
        UnitpayEntry.SETRANGE(Posted, FALSE);
        //  UnitpayEntry.SETRANGE("Priority Payment",FALSE);
        IF UnitpayEntry.FINDSET THEN
            REPEAT
                CLEAR(BondInvestmentAmt);
                BondInvestmentAmt := UnitpayEntry.Amount;
                CLEAR(ByCheque);
                IF (UnitpayEntry."Payment Mode" IN [UnitpayEntry."Payment Mode"::Bank,
                UnitpayEntry."Payment Mode"::"D.C./C.C./Net Banking", UnitpayEntry."Payment Mode"::"D.D."]) THEN
                    ByCheque := TRUE
                ELSE
                    ByCheque := FALSE;
                CreateStagingTableAppBond(Rec, UnitpayEntry."Line No." / 10000, 1, UnitpayEntry.Sequence,
                  UnitpayEntry."Cheque No./ Transaction No.", UnitpayEntry."Commision Applicable", UnitpayEntry."Direct Associate");
                UnitpayEntry.Posted := TRUE; //230213
                UnitpayEntry.MODIFY;
            UNTIL UnitpayEntry.NEXT = 0;
    end;


    procedure CheckRefundAmount()
    var
        ApplicableCharges: Record "Applicable Charges";
        AppPayEntry: Record "Application Payment Entry";
        TotRefundAmt: Decimal;
        AdminCharges: Decimal;
    begin
        Rec.CALCFIELDS("Total Received Amount");
        CLEAR(TotRefundAmt);
        CLEAR(AdminCharges);
        AppPayEntry.RESET;
        AppPayEntry.SETRANGE("Document Type", AppPayEntry."Document Type"::BOND);
        AppPayEntry.SETRANGE("Document No.", Rec."No.");
        AppPayEntry.SETRANGE("Payment Mode", 6, 7); //Refund Cash,Refund Cheque
        AppPayEntry.SETRANGE("Explode BOM", FALSE);
        AppPayEntry.SETRANGE(Posted, FALSE);
        IF AppPayEntry.FINDSET THEN
            REPEAT
                TotRefundAmt += ABS(AppPayEntry.Amount);
            UNTIL AppPayEntry.NEXT = 0;

        ApplicableCharges.RESET;
        ApplicableCharges.SETRANGE("Document No.", Rec."No.");
        ApplicableCharges.SETRANGE(Code, 'ADMIN');
        IF ApplicableCharges.FINDFIRST THEN
            AdminCharges := ApplicableCharges."Net Amount";

        IF (TotRefundAmt > (Rec."Total Received Amount" - AdminCharges)) THEN
            ERROR('Full Refund Amount must be %1', (Rec."Total Received Amount" - AdminCharges));
    end;


    procedure UpdateUnitwithApplicablecharge()
    var
        AppCharge_1: Record "App. Charge Code";
        AppCharge_2: Record "App. Charge Code";
        CompanywiseGLAccount: Record "Company wise G/L Account";
        UnitSetup1: Record "Unit Setup";
        v_UnitMasters: Record "Unit Master";
        ArchiveConfirmedOrder: Record "Archive Confirmed Order";
    begin
        Rec."Unit Code" := Rec."New Unit No.";
        Rec."Unit Payment Plan" := Rec."New Unit Payment Plan";
        AppCharge_2.RESET;
        AppCharge_2.SETRANGE(Code, Rec."New Unit Payment Plan");
        IF AppCharge_2.FINDFIRST THEN
            Rec."Unit Plan Name" := AppCharge_2.Description;

        Unitmaster.GET(Rec."New Unit No.");
        Rec."Saleable Area" := Unitmaster."Saleable Area";
        Rec."Shortcut Dimension 1 Code" := Unitmaster."Project Code";
        IF Job.GET(Unitmaster."Project Code") THEN
            Rec."Project Type" := Job."Default Project Type";

        //"Min. Allotment Amount" := Unitmaster."Min. Allotment Amount";

        IF Rec."Unit Code" <> '' THEN BEGIN

            Docmaster_3.RESET;
            Docmaster_3.SETRANGE(Docmaster_3."Document Type", Docmaster_3."Document Type"::Charge);
            Docmaster_3.SETFILTER(Docmaster_3."Project Code", Rec."Shortcut Dimension 1 Code");
            Docmaster_3.SETFILTER(Docmaster_3."Unit Code", Rec."Unit Code");
            Docmaster_3.SETFILTER(Code, 'BSP4');   //040424
            IF Docmaster_3.FINDSET THEN BEGIN
                Docmaster.RESET;
                Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
                Docmaster.SETFILTER(Docmaster."Project Code", Rec."Shortcut Dimension 1 Code");
                Docmaster.SETRANGE(Docmaster."Unit Code", '');
                Docmaster.SETRANGE("App. Charge Code", Rec."Unit Payment Plan");
                Docmaster.SETFILTER("Rate/Sq. Yd", '<>%1', 0);
                IF Docmaster.FINDFIRST THEN BEGIN
                    IF (Job."BSP4 Plan wise Applicable") AND (Rec."Posting Date" >= Job."BSP4 Plan wise St. Date") THEN BEGIN
                        Docmaster_3."Rate/Sq. Yd" := Docmaster."BSP4 Plan wise Rate / Sq. Yd";
                        Docmaster_3."Total Charge Amount" := Docmaster."BSP4 Plan wise Rate / Sq. Yd" * Unitmaster."Saleable Area";
                        Docmaster_3.MODIFY;
                    END ELSE BEGIN
                        Docmaster.RESET;
                        Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
                        Docmaster.SETFILTER(Docmaster."Project Code", Rec."Shortcut Dimension 1 Code");
                        Docmaster.SETRANGE(Docmaster."Unit Code", '');
                        Docmaster.SETRANGE(Code, 'BSP4');
                        Docmaster.SETFILTER("Rate/Sq. Yd", '<>%1', 0);
                        IF Docmaster.FINDFIRST THEN BEGIN
                            Docmaster_3."Rate/Sq. Yd" := Docmaster."Rate/Sq. Yd";
                            Docmaster_3."Total Charge Amount" := Docmaster."Rate/Sq. Yd" * Unitmaster."Saleable Area";
                            Docmaster_3.MODIFY;
                        END;
                    END;
                END;
            END;




            AppCharges.RESET;
            AppCharges.SETRANGE(AppCharges."Document No.", Rec."No.");
            IF AppCharges.FIND('-') THEN
                AppCharges.DELETEALL;

            Docmaster.RESET;
            Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
            Docmaster.SETFILTER(Docmaster."Project Code", Rec."Shortcut Dimension 1 Code");
            Docmaster.SETFILTER(Docmaster."Unit Code", Rec."Unit Code");
            Docmaster.SETFILTER("Total Charge Amount", '<>%1', 0);  //270317
                                                                    //IF "New Unit Payment Plan" <> '1008' THEN
            Docmaster.SETFILTER(Code, '<>%1&<>%2', 'PPLAN', 'PPLAN1');
            IF Docmaster.FINDFIRST THEN
                REPEAT
                    AppCharges.RESET;
                    AppCharges.INIT;
                    AppCharges."Document Type" := Docmaster."Document Type"::Charge;
                    AppCharges.Code := Docmaster.Code;

                    AppCharges.Description := Docmaster.Description;
                    AppCharges."Document No." := Rec."No.";
                    AppCharges."Item No." := Rec."Unit Code";
                    AppCharges."Membership Fee" := Docmaster."Membership Fee";
                    IF Docmaster."Project Price Dependency Code" <> '' THEN BEGIN
                        PPGD.RESET;
                        PPGD.SETFILTER(PPGD."Project Code", Rec."Shortcut Dimension 1 Code");
                        PPGD.SETRANGE(PPGD."Project Price Group", Docmaster."Project Price Dependency Code");
                        PPGD.SETFILTER(PPGD."Starting Date", '<=%1', Rec."Document Date");
                        IF PPGD.FINDLAST THEN BEGIN
                            IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Sale THEN
                                AppCharges."Rate/UOM" := PPGD."Sales Rate (per sq ft)";
                            IF Docmaster."Sale/Lease" = Docmaster."Sale/Lease"::Lease THEN
                                AppCharges."Rate/UOM" := PPGD."Lease Rate (per sq ft)";

                        END;
                    END
                    ELSE
                        AppCharges."Rate/UOM" := Docmaster."Rate/Sq. Yd";

                    AppCharges."Project Code" := Docmaster."Project Code";
                    AppCharges."Fixed Price" := Docmaster."Fixed Price";
                    AppCharges."BP Dependency" := Docmaster."BP Dependency";
                    AppCharges."Rate Not Allowed" := Docmaster."Rate Not Allowed";
                    AppCharges."Project Price Dependency Code" := Docmaster."Project Price Dependency Code";
                    IF AppCharges."Rate/UOM" <> 0 THEN BEGIN
                        UnitMasterRec.GET(Rec."Unit Code");
                        AppCharges."Net Amount" := UnitMasterRec."Saleable Area" * AppCharges."Rate/UOM"; //ALLEDK 030313
                    END
                    ELSE
                        AppCharges."Net Amount" := AppCharges."Fixed Price";
                    AppCharges.Sequence := Docmaster.Sequence;
                    IF AppCharges.Code = 'PLC' THEN BEGIN
                        Plcrec.SETFILTER("Item Code", Rec."Unit Code");
                        Plcrec.SETFILTER("Job Code", Rec."Shortcut Dimension 1 Code");
                        IF Plcrec.FINDFIRST THEN
                            REPEAT
                                AppCharges."Fixed Price" := AppCharges."Fixed Price" + Plcrec.Amount;
                                AppCharges."Net Amount" := AppCharges."Fixed Price";
                            UNTIL Plcrec.NEXT = 0;
                    END;
                    AppCharges."Commision Applicable" := Docmaster."Commision Applicable";
                    AppCharges."Direct Associate" := Docmaster."Direct Associate";
                    AppCharges.Applicable := TRUE;
                    AppCharges.INSERT;
                UNTIL Docmaster.NEXT = 0;






            //IF "New Unit Payment Plan" <> '1008' THEN BEGIN
            Docmaster.RESET;
            Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
            Docmaster.SETFILTER(Docmaster."Project Code", Rec."Shortcut Dimension 1 Code");
            Docmaster.SETRANGE(Docmaster."Unit Code", '');
            Docmaster.SETRANGE("App. Charge Code", Rec."New Unit Payment Plan");
            IF Docmaster.FINDFIRST THEN BEGIN
                AppCharges.RESET;
                AppCharges.INIT;
                AppCharges."Document Type" := Docmaster."Document Type"::Charge;
                AppCharges.Code := Docmaster.Code;

                AppCharges.Description := Docmaster.Description;
                AppCharges."Document No." := Rec."No.";
                AppCharges."Item No." := Rec."Unit Code";
                AppCharges."Membership Fee" := Docmaster."Membership Fee";
                IF Docmaster."Project Price Dependency Code" <> '' THEN BEGIN
                    PPGD.RESET;
                    PPGD.SETFILTER(PPGD."Project Code", Rec."Shortcut Dimension 1 Code");
                    PPGD.SETRANGE(PPGD."Project Price Group", Docmaster."Project Price Dependency Code");
                    PPGD.SETFILTER(PPGD."Starting Date", '<=%1', Rec."Document Date");
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
                    UnitMasterRec.GET(Rec."Unit Code");
                    AppCharges."Net Amount" := UnitMasterRec."Saleable Area" * AppCharges."Rate/UOM"; //ALLEDK 030313
                END
                ELSE
                    AppCharges."Net Amount" := AppCharges."Fixed Price";
                AppCharges.Sequence := Docmaster.Sequence;
                AppCharges."Commision Applicable" := Docmaster."Commision Applicable";
                AppCharges."Direct Associate" := Docmaster."Direct Associate";
                AppCharges.Applicable := TRUE;
                AppCharges.INSERT;
            END;
            //END; 281119

        END;

        AlltAmount := 0;
        Rec.Amount := CalculateAllotAmt;
        AlltAmount := Rec.Amount;
        Rec."Payment Plan" := Unitmaster."Payment Plan";
        Rec.VALIDATE(Amount);


        //291221 Code start

        UnitSetup.GET;

        ArchiveConfirmedOrder.RESET;
        ArchiveConfirmedOrder.SETRANGE("No.", Rec."No.");
        IF ArchiveConfirmedOrder.FINDLAST THEN
            IF Rec."New Unit No." <> ArchiveConfirmedOrder."Unit Code" THEN
                NewUnitTaged := TRUE;

        IF v_UnitMasters.GET(Rec."Unit Code") THEN  //291221
            Rec."Min. Allotment Amount" := CalculateMinAllotAmt(v_UnitMasters, Rec."Posting Date", Rec."Min. Allotment Amount", Rec.Amount, NewUnitTaged); //291221

        /* Code comment 291221
        //280121
          //ALLEDK 210921 Start
          CompanywiseGLAccount.RESET;
          CompanywiseGLAccount.SETRANGE("MSC Company",TRUE);
          IF CompanywiseGLAccount.FINDFIRST THEN BEGIN
            v_ResponsibilityCenter.RESET;
            v_ResponsibilityCenter.CHANGECOMPANY(CompanywiseGLAccount."Company Code");
             v_ResponsibilityCenter.GET("Shortcut Dimension 1 Code");
             IF v_ResponsibilityCenter."Min. Allotment %" <> 0 THEN BEGIN
              "Min. Allotment Amount" := ROUND(((Amount + "Development Charges") * v_ResponsibilityCenter."Min. Allotment %"/100),1,'=');
             END ELSE
               "Min. Allotment Amount" := Unitmaster."Min. Allotment Amount";
          END;
           //280121
           */ //Code comment 291221
              //291221 Code End
        Rec.MODIFY;

        /*
            Docmaster.RESET;
            Docmaster.SETRANGE(Docmaster."Document Type",Docmaster."Document Type"::Charge);
            Docmaster.SETFILTER(Docmaster."Project Code","Shortcut Dimension 1 Code");
            Docmaster.SETRANGE(Docmaster."Unit Code",'');
            Docmaster.SETRANGE("Sub Sub Payment Plan Code","New Unit Payment Plan");
            IF Docmaster.FINDFIRST THEN BEGIN
               AppCharges.RESET;
               AppCharges.INIT;
               AppCharges."Document Type":=Docmaster."Document Type"::Charge;
               AppCharges.Code:=Docmaster.Code;
        
               AppCharges.Description:=Docmaster.Description;
               AppCharges."Document No." := "No.";
               AppCharges."Item No." := "Unit Code";
               AppCharges."Membership Fee" := Docmaster."Membership Fee";
               IF Docmaster."Project Price Dependency Code"<>'' THEN
                 BEGIN
                  PPGD.RESET;
                  PPGD.SETFILTER(PPGD."Project Code","Shortcut Dimension 1 Code");
                  PPGD.SETRANGE(PPGD."Project Price Group",Docmaster."Project Price Dependency Code");
                  PPGD.SETFILTER(PPGD."Starting Date",'<=%1',"Document Date");
                  IF PPGD.FINDLAST THEN
                     BEGIN
                      IF Docmaster."Sale/Lease"=Docmaster."Sale/Lease"::Sale THEN
                       AppCharges."Rate/UOM":=PPGD."Sales Rate (per sq ft)";
                      IF Docmaster."Sale/Lease"=Docmaster."Sale/Lease"::Lease THEN
                       AppCharges."Rate/UOM":=PPGD."Lease Rate (per sq ft)";
        
                     END;
                 END ELSE
                   AppCharges."Rate/UOM":=Docmaster."Rate/Sq. Yd";
        
               AppCharges."Project Code":=Docmaster."Project Code";
               AppCharges."Fixed Price":=Docmaster."Fixed Price";
               AppCharges."BP Dependency":=Docmaster."BP Dependency";
               AppCharges."Rate Not Allowed":=Docmaster."Rate Not Allowed";
               AppCharges."Project Price Dependency Code":=Docmaster."Project Price Dependency Code";
               IF AppCharges."Rate/UOM"<>0 THEN
                  BEGIN
                   UnitMasterRec.GET("Unit Code");
                   AppCharges."Net Amount":=UnitMasterRec."Saleable Area"*AppCharges."Rate/UOM"; //ALLEDK 030313
                  END
                ELSE
                  AppCharges."Net Amount":=AppCharges."Fixed Price";
              AppCharges.Sequence := Docmaster.Sequence;
              AppCharges."Commision Applicable" := Docmaster."Commision Applicable";
              AppCharges."Direct Associate" := Docmaster."Direct Associate" ;
              AppCharges.Applicable := TRUE;
              AppCharges.INSERT;
             END;
        
         Docmaster.RESET;
                  Docmaster.SETRANGE(Docmaster."Document Type",Docmaster."Document Type"::Charge);
                  Docmaster.SETFILTER(Docmaster."Project Code","Shortcut Dimension 1 Code");
                  Docmaster.SETRANGE(Docmaster."Unit Code",'');
                  Docmaster.SETRANGE("Sub Sub Payment Plan Code","New Unit Payment Plan");
                  IF Docmaster.FINDFIRST THEN BEGIN
                     AppCharges.RESET;
                     AppCharges.INIT;
                     AppCharges."Document Type":=Docmaster."Document Type"::Charge;
                     AppCharges.Code:=Docmaster.Code;
        
                     AppCharges.Description:=Docmaster.Description;
                     AppCharges."Document No." := "No.";
                     AppCharges."Item No." := "Unit Code";
                     AppCharges."Membership Fee" := Docmaster."Membership Fee";
                     IF Docmaster."Project Price Dependency Code"<>'' THEN
                       BEGIN
                        PPGD.RESET;
                        PPGD.SETFILTER(PPGD."Project Code","Shortcut Dimension 1 Code");
                        PPGD.SETRANGE(PPGD."Project Price Group",Docmaster."Project Price Dependency Code");
                        PPGD.SETFILTER(PPGD."Starting Date",'<=%1',"Document Date");
                        IF PPGD.FINDLAST THEN
                           BEGIN
                            IF Docmaster."Sale/Lease"=Docmaster."Sale/Lease"::Sale THEN
                             AppCharges."Rate/UOM":=PPGD."Sales Rate (per sq ft)";
                            IF Docmaster."Sale/Lease"=Docmaster."Sale/Lease"::Lease THEN
                             AppCharges."Rate/UOM":=PPGD."Lease Rate (per sq ft)";
        
                           END;
                       END ELSE
                         AppCharges."Rate/UOM":=Docmaster."Rate/Sq. Yd";
        
                     AppCharges."Project Code":=Docmaster."Project Code";
                     AppCharges."Fixed Price":=Docmaster."Fixed Price";
                     AppCharges."BP Dependency":=Docmaster."BP Dependency";
                     AppCharges."Rate Not Allowed":=Docmaster."Rate Not Allowed";
                     AppCharges."Project Price Dependency Code":=Docmaster."Project Price Dependency Code";
                     IF AppCharges."Rate/UOM"<>0 THEN
                        BEGIN
                         UnitMasterRec.GET("Unit Code");
                         AppCharges."Net Amount":=UnitMasterRec."Saleable Area"*AppCharges."Rate/UOM"; //ALLEDK 030313
                        END
                      ELSE
                        AppCharges."Net Amount":=AppCharges."Fixed Price";
                    AppCharges.Sequence := Docmaster.Sequence;
                    AppCharges."Commision Applicable" := Docmaster."Commision Applicable";
                    AppCharges."Direct Associate" := Docmaster."Direct Associate" ;
                    AppCharges.Applicable := TRUE;
                    AppCharges.INSERT;
                   END;
                   */  //281119

        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Document No.", Rec."No.");
        IF PaymentPlanDetails.FIND('-') THEN
            REPEAT
                PaymentPlanDetails.DELETE;
            UNTIL PaymentPlanDetails.NEXT = 0;

        PaymentTermLines.RESET;
        PaymentTermLines.SETRANGE("Document No.", Rec."No.");
        IF PaymentTermLines.FINDSET THEN
            REPEAT
                PaymentTermLines.DELETE;
            UNTIL PaymentTermLines.NEXT = 0;


        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Project Code", Rec."Shortcut Dimension 1 Code");
        PaymentPlanDetails.SETRANGE("Payment Plan Code", Unitmaster."Payment Plan");
        PaymentPlanDetails.SETRANGE("Document No.", '');
        PaymentPlanDetails.SETRANGE("Sub Payment Plan", Rec."New Unit Payment Plan");
        IF PaymentPlanDetails.FIND('-') THEN
            REPEAT
                PaymentPlanDetails1.INIT;
                PaymentPlanDetails1.COPY(PaymentPlanDetails);
                PaymentPlanDetails1."Document No." := Rec."No.";
                PaymentPlanDetails1."Project Milestone Due Date" :=
                CALCDATE(PaymentPlanDetails1."Due Date Calculation", Rec."Posting Date"); //ALLETDK221112
                IF FORMAT(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat") <> '' THEN //ALLEDK 040821
                    PaymentPlanDetails1."Auto Plot Vacate Due Date" := CALCDATE(PaymentPlanDetails1."Buffer Days for AutoPlot Vacat", PaymentPlanDetails1."Project Milestone Due Date") //ALLEDK 040821
                ELSE
                    PaymentPlanDetails1."Auto Plot Vacate Due Date" := PaymentPlanDetails1."Project Milestone Due Date";  //ALLEDK 040821

                PaymentPlanDetails1.INSERT;
            UNTIL PaymentPlanDetails.NEXT = 0;

        Unitmaster.TESTFIELD("Total Value");

        totalamount1 := 0;
        PaymentDetails.RESET;
        PaymentDetails.SETFILTER("Project Code", Rec."Shortcut Dimension 1 Code");
        PaymentDetails.SETFILTER("Document No.", Rec."No.");
        PaymentDetails.SETRANGE("Payment Plan Code", Unitmaster."Payment Plan");
        IF PaymentDetails.FINDFIRST THEN
            REPEAT
                IF PaymentDetails."Percentage Cum" > 0 THEN BEGIN
                    IF PaymentDetails."Percentage Cum" = 100 THEN
                        PaymentDetails."Total Charge Amount" := (AlltAmount - totalamount1)
                    ELSE
                        PaymentDetails."Total Charge Amount" := (AlltAmount * PaymentDetails."Percentage Cum" / 100) - totalamount1;
                END;
                IF PaymentDetails."Fixed Amount" <> 0 THEN BEGIN
                    PaymentDetails."Total Charge Amount" := PaymentDetails."Fixed Amount";
                END;

                totalamount1 := PaymentDetails."Total Charge Amount" + totalamount1;
                PaymentDetails.VALIDATE("Total Charge Amount");
                PaymentDetails.MODIFY;
            UNTIL PaymentDetails.NEXT = 0;




        Sno := '001';
        PaymentPlanDetails2.RESET;
        PaymentPlanDetails2.DELETEALL;

        TotalAmount := 0;
        PaymentPlanDetails.RESET;
        PaymentPlanDetails.SETRANGE("Payment Plan Code", Unitmaster."Payment Plan");
        PaymentPlanDetails.SETRANGE("Document No.", Rec."No.");
        IF PaymentPlanDetails.FINDSET THEN
            REPEAT
                PaymentPlanDetails2.COPY(PaymentPlanDetails);
                TotalAmount := TotalAmount + PaymentPlanDetails2."Milestone Charge Amount";
                PaymentPlanDetails2.INSERT;
            UNTIL PaymentPlanDetails.NEXT = 0;

        Applicablecharge.RESET;
        Applicablecharge.SETCURRENTKEY("Document No.", Applicablecharge.Sequence);
        Applicablecharge.SETRANGE("Document No.", Rec."No.");
        Applicablecharge.SETRANGE(Applicable, TRUE);
        Applicablecharge.SETFILTER("Net Amount", '<>%1', 0);  //070317
        IF Applicablecharge.FINDSET THEN BEGIN
            MilestoneCodeG := '1';
            PaymentPlanDetails2.RESET;
            PaymentPlanDetails2.SETRANGE("Payment Plan Code", Unitmaster."Payment Plan");
            PaymentPlanDetails2.SETRANGE("Document No.", Rec."No.");
            PaymentPlanDetails2.SETRANGE(Checked, FALSE);
            IF PaymentPlanDetails2.FINDSET THEN
                REPEAT
                    LoopingAmount := 0;
                    REPEAT
                        IF Applicablecharge."Net Amount" = PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                            CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                            PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                            Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate", PaymentPlanDetails2."Buffer Days for AutoPlot Vacat", PaymentPlanDetails2."Auto Plot Vacate Due Date"); //ALLEDK040821
                            PaymentPlanDetails2.Checked := TRUE;
                            PaymentPlanDetails2.MODIFY;
                            TotalAmount := TotalAmount - PaymentPlanDetails2."Milestone Charge Amount";
                            Applicablecharge."Net Amount" := 0;
                            InLoop := TRUE;
                        END;
                        IF Applicablecharge."Net Amount" > PaymentPlanDetails2."Milestone Charge Amount" THEN BEGIN
                            CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                            PaymentPlanDetails2."Project Milestone Due Date", PaymentPlanDetails2."Milestone Charge Amount",
                            Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate", PaymentPlanDetails2."Buffer Days for AutoPlot Vacat", PaymentPlanDetails2."Auto Plot Vacate Due Date");  //ALLEDK040821
                            PaymentPlanDetails2.Checked := TRUE;
                            PaymentPlanDetails2.MODIFY;

                            TotalAmount := TotalAmount - PaymentPlanDetails2."Milestone Charge Amount";//ALLE PS
                            LoopingAmount := 0;

                            Applicablecharge."Net Amount" := Applicablecharge."Net Amount" -
                              PaymentPlanDetails2."Milestone Charge Amount";

                            InLoop := TRUE;
                        END ELSE
                            IF (Applicablecharge."Net Amount" < PaymentPlanDetails2."Milestone Charge Amount") AND
                              (Applicablecharge."Net Amount" <> 0) THEN BEGIN
                                CreatePaymentTermsLine(PaymentPlanDetails2."Milestone Code", PaymentPlanDetails2."Milestone Description",
                                PaymentPlanDetails2."Project Milestone Due Date", Applicablecharge."Net Amount",
                                Applicablecharge.Code, Applicablecharge."Commision Applicable", Applicablecharge."Direct Associate", PaymentPlanDetails2."Buffer Days for AutoPlot Vacat", PaymentPlanDetails2."Auto Plot Vacate Due Date"); //ALLEDK 040821

                                TotalAmount := TotalAmount - Applicablecharge."Net Amount";//ALLE PS
                                LoopingAmount := PaymentPlanDetails2."Milestone Charge Amount" - Applicablecharge."Net Amount";

                                PaymentPlanDetails2."Milestone Charge Amount" := PaymentPlanDetails2."Milestone Charge Amount" -
                                Applicablecharge."Net Amount";
                                PaymentPlanDetails2.MODIFY;
                                Applicablecharge."Net Amount" := 0;
                                InLoop := TRUE;
                            END;
                        IF Applicablecharge."Net Amount" = 0 THEN BEGIN
                            Applicablecharge.NEXT;
                        END;
                        IF TotalAmount < 1 THEN
                            TotalAmount := 0;
                    UNTIL (LoopingAmount = 0) OR (TotalAmount = 0);
                UNTIL (PaymentPlanDetails2.NEXT = 0) OR (TotalAmount = 0);
        END;

        Unitmaster.VALIDATE(Status, Unitmaster.Status::Booked);
        IF Customer.GET(Rec."Customer No.") THEN  //121021
            Unitmaster."Customer Name" := Customer.Name;   //121021
        Unitmaster.MODIFY;

        //"New Unit No." := '';//ALLETDK120413
        Rec.MODIFY;

    end;


    procedure CreatePaymentTermsLine(MilestoneCode: Code[10]; MilestoneDescription: Text[50]; MilestoneDueDate: Date; Milestoneamt: Decimal; ChargeCode: Code[10]; CommisionApplicable: Boolean; DirectAssociate: Boolean; BufferDaysAutoPlot: DateFormula; AutoPlotVacateDueDate: Date)
    begin

        PaymentTermLines.INIT;
        PaymentTermLines."Document No." := Rec."No.";
        PaymentTermLines."Payment Type" := PaymentTermLines."Payment Type"::Advance;
        PaymentTermLines.Sequence := Sno;
        Sno := INCSTR(Sno);
        PaymentTermLines."Actual Milestone" := MilestoneCode;
        PaymentTermLines."Payment Plan" := PaymentPlanDetails."Payment Plan Code";
        PaymentTermLines.Description := MilestoneDescription;
        PaymentTermLines."Due Date" := MilestoneDueDate;
        PaymentTermLines."Auto Plot Vacate Due Date" := AutoPlotVacateDueDate; //ALLEDK040821
        PaymentTermLines."Buffer Days for AutoPlot Vacat" := BufferDaysAutoPlot; //ALLEDK040821
        PaymentTermLines."Project Code" := Rec."Shortcut Dimension 1 Code";
        PaymentTermLines."Calculation Type" := PaymentTermLines."Calculation Type"::"% age";
        PaymentTermLines."Criteria Value / Base Amount" := Milestoneamt;
        PaymentTermLines."Calculation Value" := 100;
        PaymentTermLines."Due Amount" := ROUND(Milestoneamt, 0.01, '=');
        PaymentTermLines."Charge Code" := ChargeCode;
        PaymentTermLines."Commision Applicable" := CommisionApplicable;
        PaymentTermLines."Direct Associate" := DirectAssociate;
        PaymentTermLines.INSERT(TRUE);
    end;


    procedure TransferMemberAmount()
    begin
        Amt := 0;

        IF OldCust <> '' THEN BEGIN

            CustLedgEntry.RESET;
            CustLedgEntry.SETRANGE("Customer No.", OldCust);
            CustLedgEntry.SETRANGE("BBG App. No. / Order Ref No.", Rec."No.");
            IF CustLedgEntry.FINDSET THEN
                REPEAT
                    CustLedgEntry.CALCFIELDS(CustLedgEntry."Amount (LCY)");
                    Amt := Amt + CustLedgEntry."Amount (LCY)";
                UNTIL CustLedgEntry.NEXT = 0;

            UnitSetup.GET;
            UnitSetup.TESTFIELD("Transfer Member Temp Name");
            UnitSetup.TESTFIELD("Transfer Member Batch Name");
            UnitSetup.TESTFIELD("Transfer Control Account");
            GenJnlLine.DELETEALL;
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", UnitSetup."Transfer Member Temp Name");
            GenJnlLine.SETRANGE("Journal Batch Name", UnitSetup."Transfer Member Batch Name");
            IF GenJnlLine.FINDLAST THEN
                LineNo2 := GenJnlLine."Line No.";

            GenJnlLine.INIT;
            LineNo2 += 10000;

            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";

            IF GenJnlBatch.GET(UnitSetup."Transfer Member Temp Name", UnitSetup."Transfer Member Batch Name") THEN
                DocNo := NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", WORKDATE, TRUE);

            GenJnlLine."Document No." := DocNo;
            GenJnlLine."Line No." := LineNo2;
            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::" ");
            //GenJnlLine.VALIDATE("Posting Date","Posting Date");
            GenJnlLine.VALIDATE("Posting Date", WORKDATE); //ALLETDK160213
            GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", OldCust);
            GenJnlLine.VALIDATE("Debit Amount", ABS(Amt));
            GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::Running);
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := UnitSetup."Transfer Control Account";
            GenJnlLine."Source Code" := 'GENJNL';
            GenJnlLine."Order Ref No." := Rec."No.";
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.INSERT;

            InsertJnDimension(GenJnlLine); //ALLEDK 310113
            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", 'Member Change');

            PostGenJnlLines;

            GenJnlLine.INIT;
            LineNo2 += 10000;

            GenJnlLine."Journal Template Name" := UnitSetup."Transfer Member Temp Name";
            GenJnlLine."Journal Batch Name" := UnitSetup."Transfer Member Batch Name";
            GenJnlLine."Document No." := DocNo;
            GenJnlLine."Line No." := LineNo2;
            GenJnlLine.VALIDATE(GenJnlLine."Document Type", GenJnlLine."Document Type"::" ");
            //GenJnlLine.VALIDATE("Posting Date","Posting Date");
            GenJnlLine.VALIDATE("Posting Date", WORKDATE); //ALLETDK160213
            GenJnlLine.VALIDATE("Document Date", Rec."Document Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", Rec."New Member");
            GenJnlLine.VALIDATE("Credit Amount", ABS(Amt));
            GenJnlLine."Order Ref No." := Rec."No.";
            GenJnlLine.VALIDATE("Posting Type", GenJnlLine."Posting Type"::Running);
            GenJnlLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Shortcut Dimension 1 Code");
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
            GenJnlLine."Bal. Account No." := UnitSetup."Transfer Control Account";
            GenJnlLine."Source Code" := 'GENJNL';
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.INSERT;

            InitVoucherNarration(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", GenJnlLine."Document No.",
              GenJnlLine."Line No.", GenJnlLine."Line No.", 'Member Change');

            InsertJnDimension(GenJnlLine); //ALLEDK 310113

            PostGenJnlLines;

            Rec."Customer No." := Rec."New Member";
            Rec."New Member" := '';
            Rec.MODIFY;

        END;
    end;


    procedure PostGenJnlLines()
    begin
        CLEAR(GenJnlPostLine);
        CLEAR(GenJnlPostBatch);
        UnitSetup.GET;
        GenJnlLine.RESET;
        IF GenJnlLine.FINDSET THEN
            REPEAT
            //GenJnlPostLine.SetDocumentNo(GenJnlLine."Document No.");
            //GenJnlPostLine.RUN(GenJnlLine);                              //ALLEDK 310113
            //GenJnlPostLine.RunWithCheck(GenJnlLine,JournalLineDimension);  Upgrade140118
            UNTIL GenJnlLine.NEXT = 0;
        //GenJnlPostBatch.DeleteGenJournalNarration(GenJnlLine);
        GenJnlLine.DELETEALL;                                           //ALLEDK 310113
        //JournalLineDimension.DELETEALL;  Upgrade140118
    end;


    procedure InitVoucherNarration(JnlTemplate: Code[10]; JnlBatch: Code[10]; DocumentNo: Code[20]; GenJnlLineNo: Integer; NarrationLineNo: Integer; LineNarrationText: Text[50])
    var
        GenJnlNarration: Record "Gen. Journal Narration";// 16549;
        LineNo: Integer;
        PayToName: Text[50];
        Cust: Record Customer;
        Vend: Record Vendor;
    begin
        GenJnlNarration.INIT;
        GenJnlNarration."Journal Template Name" := JnlTemplate;
        GenJnlNarration."Journal Batch Name" := JnlBatch;
        GenJnlNarration."Document No." := DocumentNo;
        GenJnlNarration."Gen. Journal Line No." := GenJnlLineNo;
        GenJnlNarration."Line No." := NarrationLineNo;
        GenJnlNarration.Narration := LineNarrationText;
        GenJnlNarration.INSERT;
    end;


    procedure CreateStagingTableAppBond(Application: Record "Confirmed Order"; InstallmentNo: Integer; YearCode: Integer; MilestoneCode: Code[10]; ChequeNo: Code[10]; CommTree: Boolean; DirectAss: Boolean)
    var
        InitialStagingTab: Record "Unit & Comm. Creation Buffer";
        Bond: Record "Confirmed Order";
        CommEntry: Record "Commission Entry";
        AmountRecd: Decimal;
    begin
        Bond.GET(Application."No.");                                                              //ALLETDK
        AmountRecd := Bond.AmountRecdAppl(Application."No.");             //ALLETDK
        InitialStagingTab.INIT;
        InitialStagingTab."Unit No." := Application."No.";           //ALLETDk
        InitialStagingTab."Installment No." := InstallmentNo + 1;
        InitialStagingTab."Posting Date" := Application."Posting Date";
        InitialStagingTab.VALIDATE("Introducer Code", Application."Introducer Code");//ALLETDK
        InitialStagingTab."Base Amount" := BondInvestmentAmt;      //ALLETDK
        InitialStagingTab.VALIDATE("Project Type", Application."Project Type");
        InitialStagingTab.Duration := Application.Duration;
        InitialStagingTab."Year Code" := YearCode;
        InitialStagingTab.VALIDATE("Investment Type", Application."Investment Type");
        InitialStagingTab.VALIDATE("Shortcut Dimension 1 Code", Application."Shortcut Dimension 1 Code");
        InitialStagingTab.VALIDATE("Shortcut Dimension 2 Code", Application."Shortcut Dimension 2 Code");
        InitialStagingTab."Application No." := Application."No."; //ALLETDK
        InitialStagingTab."Paid by cheque" := ByCheque;                   //ALLETDK
        InitialStagingTab."Cheque No." := ChequeNo;
        InitialStagingTab."Milestone Code" := MilestoneCode;
        InitialStagingTab."Bond Created" := TRUE;
        IF AmountRecd < Bond."Min. Allotment Amount" THEN
            InitialStagingTab."Min. Allotment Amount Not Paid" := TRUE;

        IF (CommTree = FALSE) AND (DirectAss = FALSE) THEN
            InitialStagingTab."Commission Created" := TRUE;

        IF InitialStagingTab."Paid by cheque" THEN BEGIN
            InitialStagingTab."Cheque not Cleared" := TRUE;
        END;

        IF MilestoneCode = '001' THEN BEGIN
            InitialStagingTab."Min. Allotment Amount Not Paid" := FALSE;
            InitialStagingTab."Cheque not Cleared" := FALSE;
        END;

        InitialStagingTab."Direct Associate" := DirectAss;
        InitialStagingTab.INSERT;
    end;


    procedure CalculateTDSPercentage(): Decimal
    var
        TDSPercent: Decimal;
        eCessPercent: Decimal;
        SheCessPercent: Decimal;
    //RecTDSSetup: Record 13728;
    //RecNODHeader: Record 13786;
    //RecNODLines: Record 13785;
    begin
        /*
        RecTDSSetup.RESET;
        RecTDSSetup.SETRANGE("TDS Nature of Deduction","TDS Nature of Deduction");
        RecTDSSetup.SETRANGE("Assessee Code","Assessee Code");
        RecTDSSetup.SETRANGE("TDS Group","TDS Group");
        RecTDSSetup.SETRANGE("Effective Date",0D,"Posting Date");
        RecNODLines.RESET;
        RecNODLines.SETRANGE(Type,"Party Type");
        RecNODLines.SETRANGE("No.","Party Code");
        RecNODLines.SETRANGE("NOD/NOC","TDS Nature of Deduction");
        IF RecNODLines.FINDFIRST THEN BEGIN
          IF RecNODLines."Concessional Code" <> '' THEN
            RecTDSSetup.SETRANGE("Concessional Code",RecNODLines."Concessional Code")
          ELSE
            RecTDSSetup.SETRANGE("Concessional Code",'');
          IF RecTDSSetup.FINDLAST THEN BEGIN
            IF "Party Type" = "Party Type"::Vendor THEN BEGIN
              Vend.GET("Party Code");
              IF (Vend."P.A.N. Status" = Vend."P.A.N. Status"::" ") AND (Vend."P.A.N. No." <> '') THEN
                TDSPercent := RecTDSSetup."TDS %"
              ELSE
                TDSPercent := RecTDSSetup."Non PAN TDS %";
        
              eCessPercent := RecTDSSetup."eCESS %";
              SheCessPercent :=RecTDSSetup."SHE Cess %";
              EXIT(((10000*TDSPercent)+(100*TDSPercent*eCessPercent)+(100*TDSPercent*SheCessPercent)+
                (TDSPercent*eCessPercent*SheCessPercent))/10000);
            END ELSE
               ERROR('Party Type must be Vendor');
          END ELSE
            ERROR('TDS Setup does not exist');
        END ELSE
        ERROR('TDS Setup does not exist');
         */

    end;


    procedure InsertJnDimension(RecGenLine: Record "Gen. Journal Line")
    begin
        GLSetup.GET;
        UserSetup.GET(USERID);
        //BBG1.00 ALLEDK 180313
        /*
        JournalLineDimension.INIT;
        JournalLineDimension."Table ID" := 81;
        JournalLineDimension."Journal Template Name" := RecGenLine."Journal Template Name";
        JournalLineDimension."Journal Batch Name" := RecGenLine."Journal Batch Name";
        JournalLineDimension."Journal Line No." := RecGenLine."Line No.";
        JournalLineDimension."Dimension Code" := GLSetup."Shortcut Dimension 3 Code";
        JournalLineDimension."Dimension Value Code" := UserSetup."User Branch";
        JournalLineDimension.INSERT;
         */  //BBG1.00 ALLEDK 180313

        /* Upgrade140118
        GLSetup.GET;
        UserSetup.GET(USERID);
        JournalLineDimension.INIT;
        JournalLineDimension."Table ID" := 81;
        JournalLineDimension."Journal Template Name" := RecGenLine."Journal Template Name";
        JournalLineDimension."Journal Batch Name" := RecGenLine."Journal Batch Name";
        JournalLineDimension."Journal Line No." := RecGenLine."Line No.";
        JournalLineDimension."Dimension Code" := GLSetup."Shortcut Dimension 1 Code";
        JournalLineDimension."Dimension Value Code" := "Shortcut Dimension 1 Code";
        JournalLineDimension.INSERT;
        */ //Upgrade140118

    end;


    procedure CheckandReverseTA(AppNo: Code[20])
    var
        TravelPayDetails: Record "Travel Payment Details";
        TravelPaymentEntry: Record "Travel Payment Entry";
        LNo: Decimal;
        TravelPaymentEntry1: Record "Travel Payment Entry";
    begin
        TravelPayDetails.RESET;
        TravelPayDetails.SETRANGE("Application No.", AppNo);
        TravelPayDetails.SETRANGE(Reverse, FALSE);
        IF TravelPayDetails.FINDFIRST THEN BEGIN
            CLEAR(LNo);
            TravelPaymentEntry.RESET;
            TravelPaymentEntry.SETRANGE("Document No.", TravelPayDetails."Document No.");
            IF TravelPaymentEntry.FINDLAST THEN
                LNo := TravelPaymentEntry."Line No.";
            TravelPaymentEntry.RESET;
            TravelPaymentEntry.SETRANGE("Document No.", TravelPayDetails."Document No.");
            TravelPaymentEntry.SETRANGE(Reverse, FALSE);
            IF TravelPaymentEntry.FINDSET THEN
                REPEAT
                    LNo := LNo + 1000;
                    TravelPaymentEntry1.RESET;
                    TravelPaymentEntry1.INIT;
                    TravelPaymentEntry1.COPY(TravelPaymentEntry);
                    TravelPaymentEntry1."Line No." := LNo;
                    TravelPaymentEntry1.INSERT;
                    TravelPaymentEntry1."Total Area" := TravelPayDetails."Saleable Area";
                    TravelPaymentEntry1."Amount to Pay" := -TravelPayDetails."Saleable Area" * TravelPaymentEntry1."TA Rate";
                    TravelPaymentEntry1."Post Payment" := FALSE;
                    TravelPaymentEntry1.Reverse := TRUE;
                    TravelPaymentEntry1."Application No." := AppNo;
                    TravelPaymentEntry1.MODIFY;
                //TravelPaymentEntry.Reverse := TRUE;
                //TravelPaymentEntry.MODIFY;
                UNTIL TravelPaymentEntry.NEXT = 0;
            TravelPayDetails.Reverse := TRUE;
            TravelPayDetails.MODIFY;
            Rec."Travel Generate" := FALSE;
            Rec.MODIFY;
        END;
    end;


    procedure CalculateAllotAmt(): Decimal
    var
        CalDocMaster: Record "Document Master";
        AppCharge: Record "App. Charge Code";
        UnitMaster_1: Record "Unit Master";
    begin



        /*  281119 Comment
        TotalValue := 0;
        TotalFixed := 0;
        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY("Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type","Project Code",Code,"Sale/Lease","Unit Code","App. Charge Code");
        CalDocMaster.SETRANGE("Project Code","Shortcut Dimension 1 Code");
        CalDocMaster.SETRANGE("Unit Code","Unit Code");
        IF CalDocMaster.FINDFIRST THEN
          REPEAT
            AppCharge.RESET;
            AppCharge.SETRANGE(Code,CalDocMaster."App. Charge Code");
            AppCharge.SETRANGE("Sub Payment Plan",TRUE);
            IF NOT AppCharge.FINDFIRST THEN BEGIN
              TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
              TotalFixed := TotalFixed + CalDocMaster."Fixed Price";
            END;
          UNTIL CalDocMaster.NEXT = 0;
        
        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY("Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type","Project Code",Code,"Sale/Lease","Unit Code","App. Charge Code");
        CalDocMaster.SETRANGE("Project Code","Shortcut Dimension 1 Code");
        CalDocMaster.SETRANGE("Unit Code",'');
        CalDocMaster.SETRANGE("App. Charge Code","New Unit Payment Plan");
        IF CalDocMaster.FINDFIRST THEN
          REPEAT
            TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
          UNTIL CalDocMaster.NEXT = 0;
        
        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY("Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type","Project Code",Code,"Sale/Lease","Unit Code","App. Charge Code");
        CalDocMaster.SETRANGE("Project Code","Shortcut Dimension 1 Code");
        CalDocMaster.SETRANGE("Unit Code",'');
        CalDocMaster.SETRANGE("Sub Sub Payment Plan Code","New Unit Payment Plan");
        IF CalDocMaster.FINDFIRST THEN
          REPEAT
            TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
          UNTIL CalDocMaster.NEXT = 0;
        
        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY("Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type","Project Code",Code,"Sale/Lease","Unit Code","App. Charge Code");
        CalDocMaster.SETRANGE("Project Code","Shortcut Dimension 1 Code");
        CalDocMaster.SETRANGE("Unit Code",'');
        CalDocMaster.SETRANGE("Sub Sub Payment Plan Code","New Unit Payment Plan");
        IF CalDocMaster.FINDFIRST THEN
          REPEAT
            TotalValue := TotalValue + CalDocMaster."Rate/Sq. Yd";
          UNTIL CalDocMaster.NEXT = 0;
        
        
        UnitMaster_1.RESET;
        UnitMaster_1.CHANGECOMPANY("Company Name");
        UnitMaster_1.SETRANGE("No.","Unit Code");
        UnitMaster_1.SETRANGE("Project Code","Shortcut Dimension 1 Code");
        IF UnitMaster_1.FINDFIRST THEN BEGIN
          TotalValue := TotalFixed + (TotalValue * UnitMaster_1."Saleable Area");
        END;
        
        TotalValue := ROUND(TotalValue,1,'=');
        */  //271119 Comment


        Applicablecharge.RESET;
        Applicablecharge.SETRANGE("Document No.", Rec."No.");
        IF Applicablecharge.FINDSET THEN
            REPEAT
                TotalValue := TotalValue + Applicablecharge."Net Amount";
            UNTIL Applicablecharge.NEXT = 0;

        TotalValue := ROUND(TotalValue, 1, '=');
        EXIT(TotalValue);

    end;

    local procedure CreateUnitLifeCycle()
    var
        UnitLifeCycle: Record "Unit Life Cycle";
        OldUnitLifeCycle: Record "Unit Life Cycle";
        LineNo: Integer;
        ExistUnitLifeCycle: Record "Unit Life Cycle";
        UnitMaster_1: Record "Unit Master";
        NewconfirmedOrders: Record "New Confirmed Order";
    begin
        LineNo := 0;
        OldUnitLifeCycle.RESET;
        OldUnitLifeCycle.SETRANGE("Unit Code", Rec."Unit Code");
        IF OldUnitLifeCycle.FINDLAST THEN
            LineNo := OldUnitLifeCycle."Line No.";

        UnitLifeCycle.INIT;
        UnitLifeCycle.TRANSFERFIELDS(OldUnitLifeCycle);
        UnitLifeCycle."Unit Code" := Rec."Unit Code";
        UnitLifeCycle."Line No." := LineNo + 1;
        UnitLifeCycle."Unit Re-Allot Date" := TODAY;
        UnitLifeCycle."Unit Re-Allot Time" := TIME;
        UnitLifeCycle."Unit Payment Plan" := Rec."Unit Payment Plan";
        IF UnitMaster_1.GET(Rec."Unit Code") THEN
            UnitLifeCycle."Unit Cost" := UnitMaster_1."Total Value";
        UnitLifeCycle."Application Unit Cost" := Rec.Amount;
        UnitLifeCycle."Type of Transaction" := UnitLifeCycle."Type of Transaction"::"Unit Re-Assigned";
        UnitLifeCycle.INSERT;
    end;

    local procedure "-------------------------"()
    begin
    end;

    local procedure PostGoldGLEEntry(P_AppNo: Code[20]; P_OldProject: Code[20]; P_NewProject: Code[20])
    var
        GatePassLine: Record "Gate Pass Line";
        GenJournalLine: Record "Gen. Journal Line";
        DocumentNo: Code[20];
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        GatePassLine.RESET;
        GatePassLine.SETRANGE("Application No.", P_AppNo);
        IF GatePassLine.FINDSET THEN
            REPEAT
                IF GatePassLine."Shortcut Dimension 1 Code" <> P_OldProject THEN BEGIN
                    UnitSetup.GET;
                    DocumentNo := NoSeriesMgt.GetNextNo(UnitSetup."Gold No. Series for Proj Chang", TODAY, TRUE);
                    GenJournalLine.INIT;
                    GenJournalLine."Document No." := DocumentNo;
                    GenJournalLine."Line No." := 10000;
                    GenJournalLine."Posting Date" := TODAY;
                    GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
                    GenJournalLine.VALIDATE("Account No.", '102500');
                    GenJournalLine.VALIDATE(Amount, GatePassLine.Amount);
                    GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                    GenJournalLine.VALIDATE("Bal. Account No.", '138700');
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", OldProject);
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GatePassLine."Shortcut Dimension 2 Code");
                    GenJournalLine.Description := 'Project Change of GOLD/Silver';
                    GenJournalLine."Posting Type" := GenJournalLine."Posting Type"::Running;
                    GenJnlPostLine.RunWithCheck(GenJournalLine);
                    GenJournalLine.INIT;
                    GenJournalLine."Document No." := DocumentNo;
                    GenJournalLine."Line No." := 20000;
                    GenJournalLine."Posting Date" := TODAY;
                    GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::"G/L Account");
                    GenJournalLine.VALIDATE("Account No.", '138700');
                    GenJournalLine.VALIDATE(Amount, GatePassLine.Amount);
                    GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::"G/L Account");
                    GenJournalLine.VALIDATE("Bal. Account No.", '102500');
                    GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", NewProject);
                    GenJournalLine.VALIDATE("Shortcut Dimension 2 Code", GatePassLine."Shortcut Dimension 2 Code");
                    GenJournalLine.Description := 'Project Change of GOLD/Silver';
                    GenJournalLine."Posting Type" := GenJournalLine."Posting Type"::Running;
                    GenJnlPostLine.RunWithCheck(GenJournalLine);
                    //GenJournalLine.INSERT;
                END;
            UNTIL GatePassLine.NEXT = 0;
    end;

    local procedure "---------------------"()
    begin
    end;


    procedure CalculateMinAllotAmt(UnitMstr: Record "Unit Master"; PostingDate: Date; MinAllotmentfromOrder: Decimal; ConfirmedOrderAmount: Decimal; UnitChange: Boolean): Decimal
    var
        MembershipFee: Decimal;
        CalDocMaster: Record "Document Master";
        AppCharge: Record "App. Charge Code";
        UnitMaster_1: Record "Unit Master";
        MinAllotmentsAmount: Decimal;
        ProjectwiseDevelopmentCharg: Record "Project wise Development Charg";
        EndDate: Date;
        TotalValue1: Decimal;
        TotalFixed1: Decimal;
        DEvlopmentAmt: Decimal;
        vUnitSetup: Record "Unit Setup";
        CompanywiseGLAccount: Record "Company wise G/L Account";
        ArchiveConfirmedOrder: Record "Archive Confirmed Order";
        DataFind: Boolean;
    begin
        CompanywiseGLAccount.RESET;
        CompanywiseGLAccount.SETRANGE("MSC Company", TRUE);
        IF CompanywiseGLAccount.FINDFIRST THEN;
        MasterCompany := CompanywiseGLAccount."Company Code";
        vUnitSetup.RESET;
        vUnitSetup.GET;
        DataFind := FALSE;  //271023

        Job.GET(UnitMstr."Project Code");
        Docmaster_3.RESET;
        Docmaster_3.SETRANGE(Docmaster_3."Document Type", Docmaster_3."Document Type"::Charge);
        Docmaster_3.SETFILTER(Docmaster_3."Project Code", UnitMstr."Project Code");
        Docmaster_3.SETFILTER(Docmaster_3."Unit Code", UnitMstr."No.");
        Docmaster_3.SETFILTER(Code, 'BSP4');   //040424
        IF Docmaster_3.FINDSET THEN BEGIN
            Docmaster.RESET;
            Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
            Docmaster.SETFILTER(Docmaster."Project Code", UnitMstr."Project Code");
            Docmaster.SETRANGE(Docmaster."Unit Code", '');
            Docmaster.SETRANGE("App. Charge Code", '1006');
            Docmaster.SETFILTER("Rate/Sq. Yd", '<>%1', 0);
            IF Docmaster.FINDFIRST THEN BEGIN
                IF (Job."BSP4 Plan wise Applicable") AND (Rec."Posting Date" >= Job."BSP4 Plan wise St. Date") THEN BEGIN
                    Docmaster_3."Rate/Sq. Yd" := Docmaster."BSP4 Plan wise Rate / Sq. Yd";
                    Docmaster_3."Total Charge Amount" := Docmaster."BSP4 Plan wise Rate / Sq. Yd" * Unitmaster."Saleable Area";
                    Docmaster_3.MODIFY;
                END ELSE BEGIN
                    Docmaster.RESET;
                    Docmaster.SETRANGE(Docmaster."Document Type", Docmaster."Document Type"::Charge);
                    Docmaster.SETFILTER(Docmaster."Project Code", Rec."Shortcut Dimension 1 Code");
                    Docmaster.SETRANGE(Docmaster."Unit Code", '');
                    Docmaster.SETRANGE(Code, 'BSP4');
                    Docmaster.SETFILTER("Rate/Sq. Yd", '<>%1', 0);
                    IF Docmaster.FINDFIRST THEN BEGIN
                        Docmaster_3."Rate/Sq. Yd" := Docmaster."Rate/Sq. Yd";
                        Docmaster_3."Total Charge Amount" := Docmaster."Rate/Sq. Yd" * Unitmaster."Saleable Area";
                        Docmaster_3.MODIFY;
                    END;
                END;
            END;
        END;
        TotalValue1 := 0;
        TotalFixed1 := 0;
        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY(Rec."Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
        CalDocMaster.SETRANGE("Project Code", UnitMstr."Project Code");
        CalDocMaster.SETRANGE("Unit Code", UnitMstr."No.");
        IF CalDocMaster.FINDFIRST THEN
            REPEAT
                AppCharge.RESET;
                AppCharge.SETRANGE(Code, CalDocMaster."App. Charge Code");
                AppCharge.SETRANGE("Sub Payment Plan", TRUE);
                IF NOT AppCharge.FINDFIRST THEN BEGIN
                    TotalValue1 := TotalValue1 + CalDocMaster."Rate/Sq. Yd";
                    TotalFixed1 := TotalFixed1 + CalDocMaster."Fixed Price";
                END;
                //271023 Start
                IF CalDocMaster."App. Charge Code" = '1006' THEN BEGIN
                    TotalValue1 := TotalValue1 + CalDocMaster."Rate/Sq. Yd";
                    DataFind := TRUE;
                END;
            //271023 END
            UNTIL CalDocMaster.NEXT = 0;

        IF NOT DataFind THEN BEGIN  //271023
            CalDocMaster.RESET;
            CalDocMaster.CHANGECOMPANY(Rec."Company Name");
            CalDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
            CalDocMaster.SETRANGE("Project Code", UnitMstr."Project Code");
            CalDocMaster.SETRANGE("Unit Code", '');
            CalDocMaster.SETRANGE("App. Charge Code", '1006');
            IF CalDocMaster.FINDFIRST THEN
                REPEAT
                    TotalValue1 := TotalValue1 + CalDocMaster."Rate/Sq. Yd";
                UNTIL CalDocMaster.NEXT = 0;
        END;    //271023
        CalDocMaster.RESET;
        CalDocMaster.CHANGECOMPANY(Rec."Company Name");
        CalDocMaster.SETCURRENTKEY("Document Type", "Project Code", Code, "Sale/Lease", "Unit Code", "App. Charge Code");
        CalDocMaster.SETRANGE("Project Code", UnitMstr."Project Code");
        CalDocMaster.SETRANGE("Unit Code", '');
        CalDocMaster.SETRANGE("Sub Sub Payment Plan Code", '1006');
        IF CalDocMaster.FINDFIRST THEN
            REPEAT
                TotalValue1 := TotalValue1 + CalDocMaster."Rate/Sq. Yd";
            UNTIL CalDocMaster.NEXT = 0;


        UnitMaster_1.RESET;
        UnitMaster_1.CHANGECOMPANY(Rec."Company Name");
        UnitMaster_1.SETRANGE("No.", UnitMstr."No.");
        UnitMaster_1.SETRANGE("Project Code", UnitMstr."Project Code");
        IF UnitMaster_1.FINDFIRST THEN BEGIN
            TotalValue1 := TotalFixed1 + (TotalValue1 * UnitMaster_1."Saleable Area");
        END;

        TotalValue1 := ROUND(TotalValue1, 1, '=');

        IF Unitmaster.GET(UnitMstr."No.") THEN BEGIN
            EndDate := 0D;
            ProjectwiseDevelopmentCharg.RESET;
            ProjectwiseDevelopmentCharg.SETRANGE("Project Code", UnitMstr."Project Code");
            IF ProjectwiseDevelopmentCharg.FINDSET THEN BEGIN
                REPEAT
                    IF ProjectwiseDevelopmentCharg."End Date" = 0D THEN
                        EndDate := TODAY
                    ELSE
                        EndDate := ProjectwiseDevelopmentCharg."End Date";
                    IF (PostingDate > ProjectwiseDevelopmentCharg."Start Date") AND (PostingDate <= EndDate) THEN BEGIN
                        Rec."Development Charges" := ProjectwiseDevelopmentCharg.Amount * UnitMstr."Saleable Area";
                        DEvlopmentAmt := ProjectwiseDevelopmentCharg.Amount * UnitMstr."Saleable Area";
                    END;
                UNTIL ProjectwiseDevelopmentCharg.NEXT = 0;
            END;

            MinAllotmentsAmount := 0;
            v_ResponsibilityCenter.RESET;
            v_ResponsibilityCenter.CHANGECOMPANY(MasterCompany);
            v_ResponsibilityCenter.GET(UnitMstr."Project Code");
            IF v_ResponsibilityCenter."Min. Allotment %" <> 0 THEN
                MinAllotmentsAmount := ROUND(((TotalValue1 + DEvlopmentAmt) * v_ResponsibilityCenter."Min. Allotment %" / 100), 1, '=')
            ELSE
                MinAllotmentsAmount := UnitMstr."Min. Allotment Amount";
        END;

        IF PostingDate < vUnitSetup."Start Process Date for A-B-C" THEN BEGIN
            IF UnitChange THEN BEGIN
                v_ResponsibilityCenter.RESET;
                v_ResponsibilityCenter.CHANGECOMPANY(MasterCompany);
                v_ResponsibilityCenter.GET(UnitMstr."Project Code");
                IF v_ResponsibilityCenter."Min. Allotment %" <> 0 THEN
                    MinAllotmentsAmount := ROUND(((ConfirmedOrderAmount + DEvlopmentAmt) * v_ResponsibilityCenter."Min. Allotment %" / 100), 1, '=')
                ELSE
                    MinAllotmentsAmount := UnitMstr."Min. Allotment Amount";
            END ELSE
                MinAllotmentsAmount := MinAllotmentfromOrder;
        END;

        MinAllotmentsAmount := ROUND(MinAllotmentsAmount, 1, '=');
        EXIT(MinAllotmentsAmount);
    end;
}

