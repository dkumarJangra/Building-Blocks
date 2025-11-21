pageextension 50009 "BBG Vendor Card Ext" extends "Vendor Card"
{
    InsertAllowed = false;
    DeleteAllowed = false;
    layout
    {

        // Add changes to page layout here
        modify(Name)
        {
            ShowMandatory = true;
            trigger OnAfterValidate()
            begin
                IF Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)" THEN BEGIN
                    Rec.TESTFIELD("BBG Reporting Office");
                    IF Rec."BBG New Cluster Code" = '' THEN
                        ERROR('Please enter a value in Cluster Code');
                END;
            end;
        }
        modify("Name 2")
        {
            Enabled = NameVisible;
            Editable = NameVisible;
        }
        modify(Address)
        {
            Visible = AddVisible;
            ShowMandatory = TRUE;
            trigger OnAfterValidate()
            begin
                Rec.TESTFIELD(Name); //310821
            end;
        }
        modify("Address 2")
        {
            Visible = Add2Visible;
        }
        modify("Vendor Posting Group")
        {
            ShowMandatory = true;
            trigger OnAfterValidate()
            begin
                Rec.TESTFIELD(Name); //310821
            end;
        }
        modify("Country/Region Code")
        {
            ShowMandatory = TRUE;
        }
        modify("State Code")
        {
            ShowMandatory = TRUE;
        }
        //AlleDG
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        modify(BalanceAsCustomer)
        {
            Visible = false;
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify("Document Sending Profile")
        {
            Visible = false;
        }
        modify("Search Name")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("Disable Search by Name")
        {
            Visible = false;
        }
        modify("Company Size Code")
        {
            Visible = false;
        }
        modify("Phone No.")
        {
            ShowMandatory = true;
        }
        modify("Gen. Bus. Posting Group")
        {
            ShowMandatory = true;
        }
        modify("P.A.N. No.")
        {
            ShowMandatory = true;
        }
        modify("Post Code")
        {
            ShowMandatory = true;
        }
        modify(City)
        {
            ShowMandatory = true;
        }
        modify("E-Mail")
        {
            ShowMandatory = true;
        }

        addafter(General)
        {
            group("BBG Fields 2")
            {
                Caption = 'Document Approval Details';
                part("Document Approval Details"; "Document Approval Details")
                {
                    SubPageLink = "Document No." = FIELD("No."),
                            "Document Type" = CONST(Vendor);
                    ApplicationArea = All;
                    // PagePartID =Page 60729;
                    // PartType =Page;
                }
            }
            group("BBG Fields 3")
            {
                Caption = 'Communication';
                field("BBG Phone No. 2"; Rec."BBG Phone No. 2")
                {
                    Visible = PhVisible;
                    ShowMandatory = TRUE;
                    ApplicationArea = All;
                }
                field("BBG Net Change - Advance (LCY)"; Rec."BBG Net Change - Advance (LCY)")
                {
                    ApplicationArea = All;

                }
                field("BBG Net Change - Running (LCY)"; Rec."BBG Net Change - Running (LCY)")
                {
                    ApplicationArea = All;

                }
                field("BBG Net Change - Retention (LCY)"; Rec."BBG Net Change - Retention (LCY)")
                {
                    ApplicationArea = All;

                }
                field("BBG Net Change - Secured Adv (LCY)"; Rec."BBG Net Change - Secured Adv (LCY)")
                {
                    ApplicationArea = All;

                }
                field("Net Change - Adhoc Adv (LCY)"; Rec."Net Change - Adhoc Adv (LCY)")
                {
                    ApplicationArea = All;

                }
                field("BBG Net Change - Provisional (LCY)"; Rec."BBG Net Change - Provisional (LCY)")
                {
                    ApplicationArea = All;

                }
                field("BBG Net Change - LD (LCY)"; Rec."BBG Net Change - LD (LCY)")
                {
                    ApplicationArea = All;

                }
                field("BBG Net Change - Commision"; Rec."BBG Net Change - Commision")
                {
                    ApplicationArea = All;

                }
                field("BBG Net Change - Travel Allow."; Rec."BBG Net Change - Travel Allow.")
                {
                    ApplicationArea = All;

                }
                field("BBG Net Change - Bonanza"; Rec."BBG Net Change - Bonanza")
                {
                    ApplicationArea = All;

                }
                field("BBG Net Change - Incentive"; Rec."BBG Net Change - Incentive")
                {
                    ApplicationArea = All;

                }
                field("BBG Rank Code"; Rec."BBG Rank Code")
                {
                    ApplicationArea = All;

                }
                field("Parent Code"; Rec."BBG Parent Code")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
        //AlleDG
        addafter("No.")
        {
            field("BBG Vendor Category"; Rec."BBG Vendor Category")
            {
                ShowMandatory = TRUE;
                ApplicationArea = All;
                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    IF Rec."Sub Vendor Category" <> '' then  //02062025 Code Added
                        Rec.TestField("BBG Vendor Category", Rec."BBG Vendor Category"::"CP(Channel Partner)");   //02062025 Code Added
                end;
            }
            field("Sub Vendor Category"; Rec."Sub Vendor Category")
            {
                ShowMandatory = TRUE;
                ApplicationArea = All;
            }
        }
        moveafter(Name; "Name 2")
        moveafter("Name 2"; Address)
        moveafter(Address; "Address 2")
        addafter("Address 2")
        {
            field("BBG Mob. No."; Rec."BBG Mob. No.")
            {
                Visible = MobVisible;
                ShowMandatory = TRUE;
                ApplicationArea = All;
                trigger OnValidate()
                var
                    ExitMessage: Boolean;
                    CheckMobileNoforSMS: Codeunit "Check Mobile No for SMS";
                begin
                    Rec.TESTFIELD(Name); //310821
                    IF Rec."BBG Mob. No." <> '' THEN
                        ExitMessage := CheckMobileNoforSMS.CheckMobileNo(Rec."BBG Mob. No.", TRUE);
                end;
            }
            field("BBG Associate Password"; Rec."BBG Associate Password")
            {
                ApplicationArea = All;

            }
        }
        moveafter("BBG Associate Password"; "Vendor Posting Group")
        moveafter("Vendor Posting Group"; "Country/Region Code")
        moveafter("Country/Region Code"; "State Code")
        moveafter("State Code"; "Balance (LCY)")
        addafter("State Code")
        {
            field("District Code"; Rec."District Code")
            {
                ApplicationArea = All;

            }
            field("Mandal Code"; Rec."Mandal Code")
            {
                ApplicationArea = All;

            }
            field("Village Code"; Rec."Village Code")
            {
                ApplicationArea = All;
            }
        }
        moveafter("Balance (LCY)"; Blocked)
        addafter(Blocked)
        {
            field("BBG Archived"; Rec."BBG Archived")
            {
                ApplicationArea = All;

            }
            field("BBG Status"; Rec."BBG Status")
            {
                ShowMandatory = TRUE;
                ApplicationArea = All;
                trigger OnValidate()
                var
                    RegionwiseVendor: Record "Region wise Vendor";
                begin
                    //120321
                    RegionwiseVendor.RESET;
                    RegionwiseVendor.SETRANGE(RegionwiseVendor."No.", Rec."No.");
                    IF RegionwiseVendor.FINDSET THEN
                        REPEAT
                            IF Rec."BBG Status" = Rec."BBG Status"::Active THEN
                                RegionwiseVendor.Status := RegionwiseVendor.Status::Active
                            ELSE IF Rec."BBG Status" = Rec."BBG Status"::Inactive THEN
                                RegionwiseVendor.Status := RegionwiseVendor.Status::Inactive;
                            RegionwiseVendor.MODIFY;

                        UNTIL RegionwiseVendor.NEXT = 0
                    //120321
                end;
            }
            field("BBG Associate Type"; Rec."BBG Associate Type")
            {
                ApplicationArea = All;

            }
            field("BBG Version"; Rec."BBG Version")
            {
                ApplicationArea = All;

            }
            field("BBG Aadhar No."; Rec."BBG Aadhar No.")  //251124 new field
            {
                Caption = 'Aadhar No.';
                ApplicationArea = All;

            }
            field("BBG Associate Responcbility Center"; Rec."BBG Associate Responcbility Center")
            {
                Caption = 'Associate Responsibility Center';
                ApplicationArea = All;

            }
            field("BBG In-Active Associate"; Rec."BBG In-Active Associate")
            {
                ApplicationArea = All;

            }
            field("BBG Reporting Office"; Rec."BBG Reporting Office")
            {
                ShowMandatory = true;
                ApplicationArea = All;

            }
            field("BBG New Cluster Code"; Rec."BBG New Cluster Code")
            {
                Caption = 'Cluster Code';
                ApplicationArea = All;
            }
            field("BBG Team Code"; Rec."BBG Team Code")
            {
                Caption = 'Team Name';
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    memberof.RESET;
                    memberof.SETRANGE("User Name", USERID);
                    memberof.SETRANGE("Role ID", 'VendInfoVisible');
                    IF NOT memberof.FINDFIRST THEN BEGIN
                        ERROR('Please contact Admin');
                    END;
                end;
            }
            field("BBG Leader Code"; Rec."BBG Leader Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    memberof.RESET;
                    memberof.SETRANGE("User Name", USERID);
                    memberof.SETRANGE("Role ID", 'VendInfoVisible');
                    IF NOT memberof.FINDFIRST THEN BEGIN
                        ERROR('Please contact Admin');
                    END;
                end;
            }
            field("BBG Sub Team Code"; Rec."BBG Sub Team Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    memberof.RESET;
                    memberof.SETRANGE("User Name", USERID);
                    memberof.SETRANGE("Role ID", 'VendInfoVisible');
                    IF NOT memberof.FINDFIRST THEN BEGIN
                        ERROR('Please contact Admin');
                    END;
                end;
            }
            field("BBG Reporting Leader"; Rec."BBG Reporting Leader")
            {
                ApplicationArea = All;

            }
            field("Region/Districts Code"; Rec."Region/Districts Code")
            {
                ApplicationArea = All;

            }
            field("BBG Is Help Desk User"; Rec."BBG Is Help Desk User")
            {
                ApplicationArea = All;

            }
            field("BBG Send for Approval"; Rec."BBG Send for Approval")
            {
                ApplicationArea = All;

            }
            field("BBG Send for Aproval Date"; Rec."BBG Send for Aproval Date")
            {
                ApplicationArea = All;

            }
            field("BBG Approval Status"; Rec."BBG Approval Status")
            {
                ApplicationArea = All;

            }
        }
        movebefore("BBG Phone No. 2"; "Phone No.")
        moveafter("BBG Phone No. 2"; "Fax No.")
        moveafter("Fax No."; "Home Page")
        moveafter("Home Page"; "IC Partner Code")
        addafter("IC Partner Code")
        {
            field("BBG IC Partner Code"; Rec."BBG IC Partner Code")
            {
                ApplicationArea = all;
            }
            field("BBG Temp Address"; Rec."BBG Temp Address")
            {
                Caption = 'Update Address';
                ApplicationArea = All;

            }
            field("BBG Temp Address 2"; Rec."BBG Temp Address 2")
            {
                Caption = 'Update Address 2';
                ApplicationArea = All;

            }
            field("BBG Temp Address 3"; Rec."BBG Temp Address 3")
            {
                Caption = 'Update Address 3';
                ApplicationArea = All;

            }
            field("BBG Temp Mob. No."; Rec."BBG Temp Mob. No.")
            {
                Caption = 'Update Mob. No.';
                ApplicationArea = All;
            }
            field("BBG Alternate Name"; Rec."BBG Alternate Name")
            {
                ApplicationArea = All;
            }
        }


        movebefore("VAT Registration No."; "Pay-to Vendor No.")
        moveafter(GLN; "Tax Liable")
        moveafter("Tax Liable"; "Gen. Bus. Posting Group")
        moveafter("Gen. Bus. Posting Group"; "VAT Bus. Posting Group")
        moveafter("VAT Bus. Posting Group"; "Invoice Disc. Code")
        moveafter("Invoice Disc. Code"; "Prices Including VAT")
        moveafter("Prices Including VAT"; "Prepayment %")
        addafter("Prepayment %")
        {
            field("BBG Credit Limit"; Rec."BBG Credit Limit")
            {
                ApplicationArea = All;
            }
        }

        moveafter("Application Method"; "Partner Type")
        moveafter(Priority; "Cash Flow Payment Terms Code")
        moveafter("Cash Flow Payment Terms Code"; "Our Account No.")
        moveafter("Our Account No."; "Block Payment Tolerance")
        moveafter("Block Payment Tolerance"; "Creditor No.")

        addafter(Receiving)
        {
            group("BBG Foreign Trade")
            {
                Caption = 'Foreign Trade';

            }

        }
        movefirst("BBG Foreign Trade"; "Currency Code", "Language Code")

        addafter("P.A.N. Reference No.")
        {
            field("BBG Old P.A.N. No."; Rec."BBG Old P.A.N. No.")
            {
                ApplicationArea = All;
            }
            field("BBG 206AB"; Rec."BBG 206AB")
            {
                ApplicationArea = All;

            }
            field("BBG INOPERATIVE PAN"; Rec."BBG INOPERATIVE PAN")
            {
                ApplicationArea = All;

            }
        }

        addafter(GST)
        {
            group("BBG Credentials")
            {
                Caption = 'Credentials';
                field(Picture; Rec.Image)
                {
                    ApplicationArea = All;

                }
            }

        }

        addafter("Tax Information")
        {
            group("BBG Other CP Details")
            {
                Caption = 'Other CP Details';
                field("BBG Communication Address"; Rec."BBG Communication Address")
                {
                    ApplicationArea = All;

                }
                field("BBG Communication Address 2"; Rec."BBG Communication Address 2")
                {
                    ApplicationArea = All;

                }
                field("BBG CP Designation"; Rec."BBG CP Designation")
                {
                    ApplicationArea = All;

                }
                field("BBG Date of Incorporation"; Rec."BBG Date of Incorporation")
                {
                    ApplicationArea = All;

                }
                field("BBG Website (for company)"; Rec."BBG Website (for company)")
                {
                    ApplicationArea = All;

                }
                field("BBG Name (Point of Contact)"; Rec."BBG Name (Point of Contact)")
                {
                    ApplicationArea = All;

                }
                field("BBG Address (Point of Contact)"; Rec."BBG Address (Point of Contact)")
                {
                    ApplicationArea = All;

                }
                field("BBG Email (Point of Contact)"; Rec."BBG Email (Point of Contact)")
                {
                    ApplicationArea = All;

                }
                field("BBG Membership of association"; Rec."BBG Membership of association")
                {
                    ApplicationArea = All;

                }
                field("BBG Membership Number"; Rec."BBG Membership Number")
                {
                    ApplicationArea = All;

                }
                field("BBG Registration No"; Rec."BBG Registration No")
                {
                    ApplicationArea = All;

                }
                field("BBG Expiry date"; Rec."BBG Expiry date")
                {
                    ApplicationArea = All;

                }
                field("BBG ESI NO"; Rec."BBG ESI NO")
                {
                    ApplicationArea = All;

                }
                field("BBG PF No."; Rec."BBG PF No.")
                {
                    ApplicationArea = All;

                }
                field("BBG Communication City"; Rec."BBG Communication City")
                {
                    ApplicationArea = All;

                }
                field("BBG Communication State Code"; Rec."BBG Communication State Code")
                {
                    ApplicationArea = All;

                }
                field("BBG Communication Post Code"; Rec."BBG Communication Post Code")
                {
                    ApplicationArea = All;

                }
                field("BBG Entity Type"; Rec."BBG Entity Type")
                {
                    ApplicationArea = All;

                }
                field("BBG Last Previous Year"; Rec."BBG Last Previous Year")
                {
                    ApplicationArea = All;

                }
                field("BBG Second Previous Year"; Rec."BBG Second Previous Year")
                {
                    ApplicationArea = All;

                }
                field("BBG Third Previous Year"; Rec."BBG Third Previous Year")
                {
                    ApplicationArea = All;

                }

            }
            group("BBG IBA Associate")
            {
                Caption = 'IBA Associate';
                field("NOD Exists"; GetDescription.GetNODExist(Rec."No."))
                {
                    ApplicationArea = All;

                }
                field("BBG TA Applicable on Associate"; Rec."BBG TA Applicable on Associate")
                {
                    ApplicationArea = All;

                }
                field("BBG Print Associate Name/Mobile"; Rec."BBG Print Associate Name/Mobile")
                {
                    ApplicationArea = All;

                }
                field("BBG Sex"; Rec."BBG Sex")
                {
                    Caption = 'Gender';
                    ApplicationArea = All;

                }
                field("BBG Nominee Name"; Rec."BBG Nominee Name")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;

                }
                field("BBG Nominee Age"; Rec."BBG Nominee Age")
                {
                    ApplicationArea = All;

                }
                field("BBG Designation"; Rec."BBG Designation")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;

                }
                field("BBG Age"; Rec."BBG Age")
                {
                    ApplicationArea = All;

                }
                field("BBG Father Name"; Rec."BBG Father Name")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;

                }
                field("BBG Presence on Social Media"; Rec."BBG Presence on Social Media")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;

                }
                field("BBG Black List"; Rec."BBG Black List")
                {
                    ApplicationArea = All;

                }
                field("BBG Suspended"; Rec."BBG Suspended")
                {
                    ApplicationArea = All;

                }
                field("BBG Web Associate Payment Active"; Rec."BBG Web Associate Payment Active")
                {
                    ApplicationArea = All;

                }
                field("BBG Bonus Not Allowed"; Rec."BBG Bonus Not Allowed")
                {
                    ApplicationArea = All;

                }
                field("BBG Hold Payables"; Rec."BBG Hold Payables")
                {
                    ApplicationArea = All;

                }
                field("BBG Salary Applicable"; Rec."BBG Salary Applicable")
                {
                    ApplicationArea = All;

                }
                field("BBG Address 3"; Rec."BBG Address 3")
                {
                    ApplicationArea = All;

                }
                field("BBG Copy IBA in Company"; Rec."BBG Copy IBA in Company")
                {
                    ApplicationArea = All;

                }
                field("BBG Cluster Type"; Rec."BBG Cluster Type")
                {
                    ApplicationArea = All;

                }
                field("BBG Introducer"; Rec."BBG Introducer")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;

                }
                field("BBG Old No."; Rec."BBG Old No.")
                {
                    ApplicationArea = All;

                }
                field("BBG No. of Joinings"; Rec."BBG No. of Joinings")
                {
                    ApplicationArea = all;
                }
                field("IBA Responsibility Center"; Rec."Responsibility Center")
                {
                    Caption = 'Responsibility Center';
                    ApplicationArea = all;
                }
                field("Marital Status"; Rec."BBG Marital Status")
                {
                    ApplicationArea = All;
                }
                field("Date of Birth"; Rec."BBG Date of Birth")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."BBG Creation Date")
                {
                    ApplicationArea = All;
                }
                field("IBA Last Date Modified"; Rec."Last Date Modified")
                {
                    Caption = 'Last Date Modified';
                    ApplicationArea = all;
                }
                field("Date of Joining"; Rec."BBG Date of Joining")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                    //251124 Add below code Start
                    trigger OnValidate()
                    var
                        NewConfirmedOrder: Record "New Confirmed Order";
                    begin
                        NewConfirmedOrder.RESET;
                        NewConfirmedOrder.SETRANGE("Introducer Code", Rec."No.");
                        IF NewConfirmedOrder.FINDFIRST THEN
                            ERROR('You can not change DOJ. Application already created');
                    END;
                    //251124 Add below code End
                }
                field("Validity till date"; Rec."BBG Validity till date")
                {
                    ApplicationArea = All;
                }
                field(Nationality; Rec."BBG Nationality")
                {
                    ApplicationArea = All;
                }
                field("Associate Creation"; Rec."BBG Associate Creation")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Balance on Date"; BalAmount)
                {
                    ApplicationArea = All;
                }
                field("Commission Amount Qualified"; Rec."BBG Commission Amount Qualified")
                {
                    ApplicationArea = All;
                }
                field("Travel Amount Qualified"; Rec."BBG Travel Amount Qualified")
                {
                    ApplicationArea = All;
                }
                field("Incentive Amount Qualified"; Rec."BBG Incentive Amount Qualified")
                {
                    ApplicationArea = All;
                }
                field("Net Bal. incl. Elegilibility"; Rec."BBG Total Balance Amount")
                {
                    Caption = 'Net Bal. incl. Elegilibility';
                    ApplicationArea = All;
                }
                field("RERA No."; Rec."BBG RERA No.")
                {
                    ApplicationArea = All;
                }
                field("RERA Status"; Rec."BBG RERA Status")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Rec."BBG Remarks")
                {
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
                field("Land Master"; Rec."BBG Land Master")
                {
                    ApplicationArea = All;
                }
                field("Old Nav Vend No."; Rec."BBG Old Nav Vend No.")
                {
                    ApplicationArea = All;
                }
                field("Ass.Block forteam Pos. Report"; Rec."BBG Ass.Block forteam Pos. Report")
                {
                    Caption = 'Associate block for Team positive Report';
                    ApplicationArea = All;
                }
                field("Allow All Pmt. to Land Vend"; Rec."BBG Allow All Pmt. to Land Vend")
                {
                    ApplicationArea = All;
                }
                field("Allow First Pmt. to Land Vend"; Rec."BBG Allow First Pmt. to Land Vend")
                {
                    ApplicationArea = All;
                }

            }
        }
        moveafter("BBG Nominee Age"; "Post Code")
        moveafter("Post Code"; City)
        moveafter(City; "E-Mail")
        moveafter("BBG Black List"; Transporter)
        moveafter("BBG Address 3"; Contact)
        movebefore("Marital Status"; "Responsibility Center")
        moveafter("Creation Date"; "Last Date Modified")


        //AlleDG



    }

    actions
    {
        // Add changes to page actions here
        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        modify(CancelApprovalRequest)
        {
            Visible = false;
        }
        addafter("F&unctions")
        {

            action(Confirm)
            {
                Caption = 'Confirm';
                Image = "1099Form";
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = All;

                trigger OnAction()
                var
                    LandVendorloginDtld: Record "Land vendor Login Details";
                begin
                    IF (Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)") OR (Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"CP(Channel Partner)") THEN BEGIN
                        Rec.TESTFIELD("BBG Sex");
                        Rec.TESTFIELD("BBG Nominee Name");
                        Rec.TESTFIELD("BBG Age");
                        Rec.TESTFIELD("BBG Father Name");
                        Rec.TESTFIELD(City);
                        Rec.TESTFIELD("Post Code");
                        Rec.TESTFIELD("BBG Designation");
                        Rec.TESTFIELD("E-Mail");
                    END;
                    //NDALLE 051107 Begin
                    IF NOT Rec.INSERT(TRUE) THEN
                        Rec.MODIFY(TRUE);

                    IF Rec."BBG Land Master" THEN begin
                        REc.TestField("P.A.N. No.");
                        REc.TestField("BBG Aadhar No.");

                        LandVendorloginDtld.RESET;
                        LandVendorloginDtld.SETRANGE("P.A.N. No.", Rec."P.A.N. No.");
                        LandVendorloginDtld.SETRANGE("Aadhar No.", Rec."BBG Aadhar No.");
                        IF LandVendorloginDtld.FindFirst() THEN BEGIN
                            LandVendorloginDtld."State Code" := Rec."State Code";
                            LandVendorloginDtld."District Code" := REc."District Code";
                            LandVendorloginDtld."Mandal Code" := Rec."Mandal Code";
                            LandVendorloginDtld."Village Code" := Rec."Village Code";
                            LandVendorloginDtld.Modify;
                        end ELSE begin
                            Rec.CreateLandVendorlogin;
                            Message('%1', 'Land Vendor login details has been created');
                        end;
                    END;



                    //NDALLE 051107 End
                end;
            }
            action(Replicate)
            {
                Caption = 'Replicate';
                Image = "1099Form";
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction()
                var
                    VendorBankAccount: Record "Vendor Bank Account";
                    RecVendorBankAccount: Record "Vendor Bank Account";
                    //RecNODHdr: Record 13786;
                    //RecNODLines: Record 13785;
                    WebAppService: Codeunit "Web App Service";
                    RankCodeMaster: Record "Rank Code";
                    AssStatus: Text;
                    WRegionwiseVendor: record "Region wise Vendor";
                    CompanyWiseGL: Record "Company wise G/L Account";
                    AllowedSection: Record "Allowed Sections";
                    AllowedSectionRep: Record "Allowed Sections";
                begin
                    Rec.TESTFIELD("BBG Sex");
                    Rec.TESTFIELD("BBG Nominee Name");
                    Rec.TESTFIELD("BBG Age");
                    Rec.TESTFIELD("BBG Father Name");
                    Rec.TESTFIELD(City);
                    Rec.TESTFIELD("Post Code");
                    Rec.TESTFIELD("BBG Designation");
                    Rec.TESTFIELD("E-Mail");

                    Rec.TESTFIELD("Gen. Bus. Posting Group");  //090821
                    Rec.TestField("State Code");
                    Rec.TestField("Mandal Code");
                    Rec.TestField("District Code");
                    Rec.TestField("Village Code");

                    IF (Rec."BBG Vendor Category" <> Rec."BBG Vendor Category"::"IBA(Associates)")
                      AND (Rec."BBG Vendor Category" <> Rec."BBG Vendor Category"::"CP(Channel Partner)") THEN
                        ERROR('Vendor category either be IBA(Associates) OR CP(Channel Partner)');  //280824 Added new code
                                                                                                    //TESTFIELD("Vendor Category","Vendor Category"::"IBA(Associates)");  //280824 code commented

                    //IF "Vendor Category" <> "Vendor Category"::"IBA(Associates)" THEN  //280824 code commented
                    // ERROR('Replaction not required');   //280824 code commented

                    If Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"CP(Channel Partner)" then  //02062025 Adde new Code
                        Rec.TestField("Sub Vendor Category");     //02062025 Adde new Code

                    IF CONFIRM('Do you want to replicate this Vendor?') THEN BEGIN
                        /*
                        RecNODHdr.RESET;
                        IF NOT RecNODHdr.GET(RecNODHdr.Type::Vendor, Rec."No.") THEN BEGIN
                            Rec.CreateNOD;
                        END;
                        *///Need to check the code in UAT

                        CompanyWiseGL.RESET;
                        CompanyWiseGL.SETFILTER("Company Code", '<>%1', COMPANYNAME);
                        IF CompanyWiseGL.FINDSET THEN BEGIN
                            REPEAT
                                Comp.Get(CompanyWiseGL."Company Code");
                                Vend.RESET;
                                Vend.CHANGECOMPANY(Comp.Name);
                                Vend.SETRANGE("No.", Rec."No.");
                                IF NOT Vend.FINDFIRST THEN BEGIN
                                    Vend.INIT;
                                    Vend.TRANSFERFIELDS(Rec);
                                    Vend.INSERT;
                                END;
                                BondSetup.CHANGECOMPANY(Comp.Name);
                                BondSetup.GET;
                                BondSetup.TESTFIELD("TDS Nature of Deduction");

                                AllowedSection.Reset();
                                AllowedSection.SetRange("Vendor No", Rec."No.");
                                IF AllowedSection.FindFirst() then begin
                                    repeat
                                        AllowedSectionRep.Reset();
                                        AllowedSectionRep.ChangeCompany(Comp.Name);
                                        AllowedSectionRep.SetRange("Vendor No", AllowedSection."Vendor No");
                                        AllowedSectionRep.SetRange("TDS Section", AllowedSection."TDS Section");
                                        IF Not AllowedSectionRep.FindFirst() Then begin
                                            AllowedSectionRep.Init();
                                            AllowedSectionRep.TransferFields(AllowedSection);
                                            AllowedSectionRep.Insert();
                                        end;
                                    until AllowedSection.Next = 0;
                                end;
                                /*
                                NODHeader.RESET;
                                NODHeader.CHANGECOMPANY(Comp.Name);
                                IF NOT NODHeader.GET(NODHeader.Type::Vendor, Vend."No.") THEN BEGIN
                                    NODHeader.INIT;
                                    NODHeader.Type := NODHeader.Type::Vendor;
                                    NODHeader."No." := Vend."No.";
                                    NODHeader."Assesse Code" := 'IND';
                                    NODHeader.INSERT;
                                END;

                                NODLine.CHANGECOMPANY(Comp.Name);
                                IF NOT NODLine.GET(NODLine.Type::Vendor, Rec."No.", BondSetup."TDS Nature of Deduction") THEN BEGIN
                                    NODLine.Type := NODLine.Type::Vendor;
                                    NODLine."No." := Rec."No.";
                                    NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                                    NODLine."Monthly Certificate" := TRUE;
                                    NODLine."Threshold Overlook" := TRUE;
                                    NODLine."Surcharge Overlook" := TRUE;
                                    NODLine.INSERT;
                                END;
                                *///Need to check the code in UAT

                                RecVendorBankAccount.RESET;
                                RecVendorBankAccount.SETRANGE("Vendor No.", Rec."No.");
                                IF RecVendorBankAccount.FINDSET THEN
                                    REPEAT
                                        VendorBankAccount.RESET;
                                        VendorBankAccount.CHANGECOMPANY(Comp.Name);
                                        VendorBankAccount.INIT;
                                        VendorBankAccount := RecVendorBankAccount;
                                        VendorBankAccount.INSERT;
                                    UNTIL RecVendorBankAccount.NEXT = 0;

                                CLEAR(Vend);
                                Vend.RESET;
                                Vend.CHANGECOMPANY(Comp.Name);
                                Vend.SETRANGE("No.", Rec."No.");
                                IF Vend.FINDFIRST THEN BEGIN
                                    Vend."Vendor Posting Group" := Rec."Vendor Posting Group";
                                    Vend."BBG Status" := Rec."BBG Status";
                                    Vend."BBG Date of Birth" := Rec."BBG Date of Birth";
                                    Vend."BBG Date of Joining" := Rec."BBG Date of Joining";
                                    Vend."BBG Sex" := Rec."BBG Sex";
                                    Vend."BBG Marital Status" := Rec."BBG Marital Status";
                                    Vend."BBG Nationality" := Rec."BBG Nationality";
                                    Vend."BBG Associate Creation" := Rec."BBG Associate Creation";
                                    Vend."Tax Liable" := Rec."Tax Liable";
                                    Vend.VALIDATE("P.A.N. No.", Rec."P.A.N. No.");
                                    Vend."P.A.N. Status" := Rec."P.A.N. Status";
                                    Vend."Gen. Bus. Posting Group" := Rec."Gen. Bus. Posting Group";
                                    vend."Assessee Code" := Rec."Assessee Code";
                                    Vend.Blocked := Rec.Blocked;
                                    Vend.MODIFY;
                                END;
                            UNTIL CompanyWiseGL.NEXT = 0;
                        END;

                        MESSAGE('%1', 'Vendor Replicate successfully');

                        //Web Start
                        AssociateLoginDetails.RESET;
                        AssociateLoginDetails.SETCURRENTKEY(Associate_ID);
                        AssociateLoginDetails.SETRANGE(Associate_ID, Rec."No.");
                        IF AssociateLoginDetails.FINDFIRST THEN BEGIN
                            AssociateLoginDetails."Is Active" := TRUE;
                            AssociateLoginDetails.MODIFY;
                        END ELSE BEGIN
                            AssociateLoginDetails.RESET;
                            IF AssociateLoginDetails.FINDLAST THEN BEGIN
                                AssocLoginDetails.INIT;
                                AssocLoginDetails.USER_ID := AssociateLoginDetails.USER_ID + 1;
                                AssocLoginDetails."Mobile_ No" := Rec."BBG Mob. No.";
                                AssocLoginDetails.Password := Rec."BBG Associate Password";
                                AssocLoginDetails.Associate_ID := Rec."No.";
                                WRegionwiseVendor.RESET;
                                WRegionwiseVendor.SETRANGE("No.", Rec."No.");
                                IF Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"CP(Channel Partner)" THEN  //280824 code Added
                                    WRegionwiseVendor.SETRANGE("Region Code", Rec."Sub Vendor Category")
                                //WRegionwiseVendor.SETRANGE("Region Code", 'R0003')     //280824 code Added  //02062025 Code comment
                                ELSE
                                    WRegionwiseVendor.SETRANGE("Region Code", 'R0001');
                                IF WRegionwiseVendor.FINDFIRST THEN BEGIN
                                    AssocLoginDetails.Rank_Code := WRegionwiseVendor."Rank Code";
                                    AssocLoginDetails.Parent_ID := WRegionwiseVendor."Parent Code";
                                END;

                                AssocLoginDetails.Status := AssocLoginDetails.Status::Approved;
                                AssocLoginDetails.Date_OF_Birth := Rec."BBG Date of Birth";
                                AssocLoginDetails.Name := Rec.Name;
                                AssocLoginDetails.Address := Rec.Address;
                                AssocLoginDetails.City := Rec.City;
                                AssocLoginDetails.Post_Code := Rec."Post Code";
                                AssocLoginDetails.PAN_No := Rec."P.A.N. No.";
                                AssocLoginDetails.Introducer_Code := Rec."BBG Introducer";
                                AssocLoginDetails.Date_OF_Joining := Rec."BBG Date of Joining";

                                AssocLoginDetails."Creation Date" := TODAY;
                                AssocLoginDetails."NAV-Associate Created" := TRUE;
                                AssocLoginDetails."NAV-Associate Creation Date" := TODAY;
                                AssocLoginDetails."Is Active" := TRUE;
                                AssocLoginDetails."State Code" := Rec."State Code";
                                AssocLoginDetails."District Code" := Rec."District Code";
                                AssocLoginDetails."Mandal Code" := Rec."Mandal Code";
                                AssocLoginDetails."Village Code" := Rec."Village Code";
                                IF Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"CP(Channel Partner)" THEN  //280824 code Added
                                    AssocLoginDetails."Vendor Type" := AssocLoginDetails."Vendor Type"::"CP(Channel Partner)";
                                IF Rec."BBG Aadhar No." <> '' then
                                    AssociateLoginDetails."Aadhaar Number" := Rec."BBG Aadhar No.";  //Code added 23072025    
                                AssocLoginDetails.INSERT;
                            END;
                        END;
                        //Web End

                        //ALLEDK 221123

                        CLEAR(WebAppService);
                        RegionwiseVendor.RESET;
                        RegionwiseVendor.SETCURRENTKEY(RegionwiseVendor."No.");
                        RegionwiseVendor.SETRANGE("No.", Rec."No.");
                        IF RegionwiseVendor.FINDFIRST THEN;


                        RankCodeMaster.RESET;
                        RankCodeMaster.SETRANGE("Rank Batch Code", RegionwiseVendor."Region Code");
                        RankCodeMaster.SETRANGE(Code, RegionwiseVendor."Rank Code");
                        IF RankCodeMaster.FINDFIRST THEN;
                        IF Vendor."BBG Black List" THEN
                            AssStatus := 'Deactivate'
                        ELSE
                            AssStatus := 'Active';

                        //ALLEDK 160922
                        IF Rec."BBG Team Code" = '' THEN BEGIN
                            WRegionwiseVendor.RESET;
                            WRegionwiseVendor.SETRANGE("No.", Rec."No.");
                            WRegionwiseVendor.SETFILTER("Region Code", '<>%1', '');
                            IF WRegionwiseVendor.FINDFIRST THEN BEGIN
                                CLEAR(AssociateTeamforGamifiction);
                                AssociateTeamforGamifiction.ReportValues(Rec."No.", WRegionwiseVendor."Region Code");
                                AssociateTeamforGamifiction.RUNMODAL;
                            END;
                        END;
                        CreateAssocaiteLead(Rec);  //280525 Added new function.


                        IF (Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)") THEN
                            WebAppService.Post_data('', Rec."No.", Rec.Name, Rec."BBG Mob. No.", Rec."E-Mail", Rec."BBG Team Code", Rec."BBG Leader Code", RegionwiseVendor."Parent Code",
                            FORMAT(AssStatus), FORMAT(RegionwiseVendor."Rank Code"), RankCodeMaster.Description);

                        //ALLEDK 160922

                    END;
                end;
            }
            Action(CreateAssociateLead)
            {
                Caption = 'Create Assocaite Lead';
                Promoted = True;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    myInt: Integer;
                begin
                    If Confirm('Do you want to create Assocaite Lead') then BEGIN
                        CreateAssocaiteLead(Rec);
                        Message('Process Done');
                    ENd ELSE
                        Message('Nothing Process');
                end;
            }
            action(Edit)
            {
                Caption = 'Edit';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    memberof.RESET;
                    memberof.SETRANGE(memberof."User Name", USERID);
                    memberof.SETRANGE(memberof."Role ID", 'DDS-PNP-VENDOR, EDIT');
                    IF memberof.FIND('-') THEN
                        CurrPage.Editable := TRUE;

                    memberof.RESET;
                    memberof.SETRANGE(memberof."User Name", USERID);
                    memberof.SETRANGE(memberof."Role ID", 'SUPER');
                    IF memberof.FIND('-') THEN
                        CurrPage.Editable := TRUE;
                end;
            }
            action("&Attach Documents")
            {
                Caption = '&Attach Documents';
                Promoted = true;
                RunObject = Page Documents;
                RunPageLink = "Table No." = CONST(23),
                              "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
            group(Images)
            {
                Caption = 'Images';
                Image = Vendor;
                action("Show Images")
                {
                    Caption = 'Show Images';
                    RunObject = Page "User Document Attachment";
                    RunPageLink = "Associate ID" = FIELD("No.");
                    ApplicationArea = All;
                }
            }
            action("Send For Approval")
            {
                Caption = 'Send For Approval (For Vendor)';
                Image = SendApprovalRequest;
                ApplicationArea = All;

                trigger OnAction()
                var
                    LineNo: Integer;
                begin
                    //Vendor

                    IF CONFIRM('Do  you want to send Document Send for Approval') THEN BEGIN
                        Rec.TESTFIELD("BBG Send for Approval", FALSE);
                        LineNo := 0;
                        RequesttoApproveDocuments.RESET;
                        RequesttoApproveDocuments.SETRANGE("Document Type", RequesttoApproveDocuments."Document Type"::Vendor);
                        RequesttoApproveDocuments.SETRANGE("Document No.", Rec."No.");
                        IF RequesttoApproveDocuments.FINDLAST THEN
                            LineNo := RequesttoApproveDocuments."Line No.";

                        ApprovalWorkflowforAuditPr.RESET;
                        ApprovalWorkflowforAuditPr.SETRANGE("Document Type", ApprovalWorkflowforAuditPr."Document Type"::Vendor);
                        ApprovalWorkflowforAuditPr.SETRANGE("Requester ID", USERID);
                        IF ApprovalWorkflowforAuditPr.FINDSET THEN BEGIN
                            REPEAT
                                RequesttoApproveDocuments.RESET;
                                RequesttoApproveDocuments.INIT;
                                RequesttoApproveDocuments."Document Type" := RequesttoApproveDocuments."Document Type"::Vendor;
                                RequesttoApproveDocuments."Document No." := Rec."No.";
                                //RequesttoApproveDocuments."Document Line No." := "Line No.";
                                RequesttoApproveDocuments."Line No." := LineNo + 10000;
                                //RequesttoApproveDocuments.Amount := Amount;
                                //RequesttoApproveDocuments."Posting Date" := "Posting Date";
                                RequesttoApproveDocuments."Requester ID" := USERID;
                                RequesttoApproveDocuments."Approver ID" := ApprovalWorkflowforAuditPr."Approver ID";
                                RequesttoApproveDocuments.Sequence := ApprovalWorkflowforAuditPr.Sequence;
                                RequesttoApproveDocuments."Requester DateTime" := CURRENTDATETIME;
                                RequesttoApproveDocuments.INSERT;
                                LineNo := RequesttoApproveDocuments."Line No."
                          UNTIL ApprovalWorkflowforAuditPr.NEXT = 0;
                            Rec."BBG Send for Approval" := TRUE;
                            Rec."BBG Send for Aproval Date" := TODAY;
                            Rec."BBG Approval Status" := Rec."BBG Approval Status"::" ";
                            Rec.Blocked := Rec.Blocked::All;
                            Rec.MODIFY;
                        END ELSE
                            ERROR('Approver not found against this Sender');
                    END ELSE
                        MESSAGE('Nothing Process');
                end;
            }
            action(Reopen)
            {
                Caption = 'Reopen (For Vendor)';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("BBG Approval Status", "Approval Status"::Approved);
                    Rec."BBG Approval Status" := Rec."BBG Approval Status"::" ";
                    Rec."BBG Send for Approval" := FALSE;
                    Rec."BBG Send for Aproval Date" := 0D;
                    Rec.Blocked := Rec.Blocked::All;
                end;
            }
            action("Show Document Attachments")
            {
                Caption = '&Attach Documents (For 7 Server)';
                Promoted = true;
                RunObject = Page "Document file Upload";
                RunPageLink = "Table No." = CONST(23),
                                  "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
            action("Create NOD Lines for Commisison")
            {
                Caption = 'Create NOD Lines for Commisison';
                Image = "1099Form";
                Promoted = true;
                PromotedCategory = Category4;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("BBG Archived", FALSE);//ALLECK 220413
                    IF CONFIRM(Text006, TRUE, Rec."No.") THEN
                        Rec.CreateNOD;
                end;
            }
            action(Master)
            {
                Caption = 'Master';
                Image = "1099Form";
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = All;
            }
            action("Vendor Rank List")
            {
                Caption = 'Vendor Rank List';
                Image = "Page";
                Promoted = true;
                PromotedCategory = Category7;
                RunObject = Page "Regin and Rank wise vendor";
                ApplicationArea = All;
            }
            action("Vendor Tree")
            {
                Caption = 'Vendor Tree';
                Image = "Page";
                Promoted = true;
                PromotedCategory = Category7;
                RunObject = Page "Vendor Tree";
                RunPageLink = "Introducer Code" = FIELD("No.");
                ApplicationArea = All;
            }
            action("Rank Relation")
            {
                Caption = 'Rank Relation';
                Image = "Page";
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Region and Rank wise Associate";
                RunPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
                // trigger OnAction()
                // var
                //     PageRegionandRankwise: Page "Region and Rank wise Associate";
                //     RegionwiseAssociate: Record "Region wise Vendor";
                //     RankMaster: Record "Rank Code Master";
                //     RecordFind: Boolean;
                // begin

                //     RankMaster.RESET;
                //     IF RankMaster.FindSet THEN
                //         repeat
                //             RecordFind := false;
                //             RegionwiseAssociate.RESET;
                //             RegionwiseAssociate.SetRange("Region Code", RankMaster.Code);
                //             RegionwiseAssociate.SetRange("No.", Rec."No.");
                //             IF RegionwiseAssociate.FindFirst then
                //                 RecordFind := true;
                //         Until (RankMaster.Next = 0) OR (RecordFind);
                //     If RecordFind then begin
                //         PAGE.RUN(PAGE::"Region and Rank wise Associate", RegionwiseAssociate);
                //     end ELSE begin
                //         RegionwiseAssociate.Init;
                //         RegionwiseAssociate."Region Code" := 'R0001';
                //         RegionwiseAssociate."Region Description" := '12 Ranks';
                //         RegionwiseAssociate."No." := Rec."No.";
                //         RegionwiseAssociate.Name := Rec.Name;
                //         RegionwiseAssociate.insert;
                //         commit;
                //         PAGE.RUN(PAGE::"Region and Rank wise Associate", RegionwiseAssociate);
                //     end;
                // END;
            }
            action("Region/Rank Master")
            {
                Caption = 'Region/Rank Master';
                Image = "Page";
                Promoted = true;
                PromotedCategory = Category7;
                RunObject = Page "Rank Code";
                ApplicationArea = All;
            }
            action("Update NOD Lines in other company")
            {
                Caption = 'Update NOD Lines in other company';
                Image = Process;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin

                    Comp.RESET;
                    Comp.SETFILTER(Comp.Name, '<>%1', COMPANYNAME);
                    IF Comp.FINDSET THEN BEGIN
                        REPEAT
                        /*
                        BondSetup.CHANGECOMPANY(Comp.Name);
                        BondSetup.GET;
                        BondSetup.TESTFIELD("TDS Nature of Deduction");
                        NODHeader.CHANGECOMPANY(Comp.Name);
                        IF NOT NODHeader.GET(NODHeader.Type::Vendor, Rec."No.") THEN BEGIN
                            NODHeader.INIT;
                            NODHeader.Type := NODHeader.Type::Vendor;
                            NODHeader."No." := Rec."No.";
                            NODHeader."Assesse Code" := 'IND';
                            NODHeader.INSERT;
                        END;
                        NODLine.CHANGECOMPANY(Comp.Name);
                        IF NOT NODLine.GET(NODLine.Type::Vendor, Rec."No.", BondSetup."TDS Nature of Deduction") THEN BEGIN
                            NODLine.Type := NODLine.Type::Vendor;
                            NODLine."No." := Rec."No.";
                            NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                            NODLine."Monthly Certificate" := TRUE;
                            NODLine."Threshold Overlook" := TRUE;
                            NODLine."Surcharge Overlook" := TRUE;
                            NODLine.INSERT;
                        END;
                        *///Need to check the code in UAT

                        UNTIL Comp.NEXT = 0;
                    END;
                    MESSAGE('%1', 'Update NOD Lines');
                end;
            }
            action("Create NOD for Commission")
            {
                Caption = 'Create NOD for Commission';
                Image = Process;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    Rec.TESTFIELD("BBG Archived", FALSE);//ALLECK 220413
                    IF CONFIRM(Text006, TRUE, Rec."No.") THEN
                        Rec.CreateNOD;
                end;
            }
            action("Rank History")
            {
                Caption = 'Rank History';
                Image = Process;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Change Rank History";
                RunPageLink = MMCode = FIELD("No.");
                Visible = false;
                ApplicationArea = All;
            }
            action(Tree)
            {
                Caption = 'Tree';
                Image = "1099Form";
                Promoted = true;
                PromotedCategory = Category7;
                RunObject = Page "Vendor Tree";
                RunPageLink = "Introducer Code" = FIELD("No.");
                ApplicationArea = All;
            }
            action("&Picture")
            {
                Caption = '&Picture';
                RunObject = Page "Vendor  Picture";
                ApplicationArea = All;
            }
            action("NOD/NOC List")
            {
                Caption = 'NOD/NOC List';
                Image = Document;
                Promoted = true;
                PromotedCategory = Category7;
                ApplicationArea = All;
                // RunObject = Page 13708;
                // RunPageLink = Type = CONST(Vendor),
                //                   "No." = FIELD("No.");
            }
            action("&Release")
            {
                Caption = '&Release';
                Image = Approval;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = All;

                trigger OnAction()
                var
                    VendorBankAccount: Record "Vendor Bank Account";
                    RecVendorBankAccount: Record "Vendor Bank Account";
                    RegionwiseVendor: Record "Region wise Vendor";
                    RegionwiseVendor_1: Record "Region wise Vendor";
                    CompanyInfo: Record "Company Information";
                begin

                    IF (Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)") OR (Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"CP(Channel Partner)") THEN BEGIN
                        //TESTFIELD("Vendor Category","Vendor Category"::"IBA(Associates)");  //280824 code commented

                        //IF "Vendor Category" = "Vendor Category"::"IBA(Associates)" THEN BEGIN


                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", USERID);
                        UserSetup.SETRANGE("Associate Approval", TRUE);
                        IF NOT UserSetup.FINDFIRST THEN
                            ERROR('Please contact Admin');

                        RegionwiseVendor_1.RESET;
                        RegionwiseVendor_1.SETRANGE("No.", Rec."No.");
                        IF RegionwiseVendor_1.FINDSET THEN
                            REPEAT
                                RegionwiseVendor_1.TESTFIELD("Vendor Check Status", RegionwiseVendor_1."Vendor Check Status"::Release);
                            UNTIL RegionwiseVendor_1.NEXT = 0;

                        Comp.RESET;
                        Comp.SETFILTER(Comp.Name, '<>%1', COMPANYNAME);
                        IF Comp.FINDSET THEN BEGIN
                            REPEAT
                                Vend.INIT;
                                Vend := Rec;
                                Vend.CHANGECOMPANY(Comp.Name);
                                Vend.SETRANGE("No.", Rec."No.");
                                IF NOT Vend.FINDFIRST THEN BEGIN
                                    Vend.INSERT;
                                    BondSetup.CHANGECOMPANY(Comp.Name);
                                    BondSetup.GET;
                                    BondSetup.TESTFIELD("TDS Nature of Deduction");
                                    /*
                                    NODHeader.CHANGECOMPANY(Comp.Name);
                                    IF NOT NODHeader.GET(NODHeader.Type::Vendor, Vend."No.") THEN BEGIN
                                        NODHeader.INIT;
                                        NODHeader.Type := NODHeader.Type::Vendor;
                                        NODHeader."No." := Vend."No.";
                                        NODHeader."Assesse Code" := 'IND';
                                        NODHeader.INSERT;
                                    END;

                                    NODLine.CHANGECOMPANY(Comp.Name);
                                    IF NOT NODLine.GET(NODLine.Type::Vendor, Rec."No.", BondSetup."TDS Nature of Deduction") THEN BEGIN
                                        NODLine.Type := NODLine.Type::Vendor;
                                        NODLine."No." := Rec."No.";
                                        NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                                        NODLine."Monthly Certificate" := TRUE;
                                        NODLine."Threshold Overlook" := TRUE;
                                        NODLine."Surcharge Overlook" := TRUE;
                                        NODLine.INSERT;
                                    END;
                                    *///Need to check the code in UAT

                                    RecVendorBankAccount.RESET;
                                    RecVendorBankAccount.SETRANGE("Vendor No.", Rec."No.");
                                    IF RecVendorBankAccount.FINDSET THEN
                                        REPEAT
                                            VendorBankAccount.RESET;
                                            VendorBankAccount.CHANGECOMPANY(Comp.Name);
                                            VendorBankAccount.INIT;
                                            VendorBankAccount := RecVendorBankAccount;
                                            VendorBankAccount.INSERT;
                                        UNTIL RecVendorBankAccount.NEXT = 0;
                                END ELSE BEGIN
                                    Vend.CHANGECOMPANY(Comp.Name);
                                    Vend.SETRANGE("No.", Rec."No.");
                                    IF Vend.FINDFIRST THEN BEGIN
                                        Vend."Vendor Posting Group" := Rec."Vendor Posting Group";
                                        Vend."BBG Status" := Rec."BBG Status";
                                        Vend."BBG Date of Birth" := Rec."BBG Date of Birth";
                                        Vend."BBG Date of Joining" := Rec."BBG Date of Joining";
                                        Vend."BBG Sex" := Rec."BBG Sex";
                                        Vend."BBG Marital Status" := Rec."BBG Marital Status";
                                        Vend."BBG Nationality" := Rec."BBG Nationality";
                                        Vend."BBG Associate Creation" := Rec."BBG Associate Creation";
                                        Vend."Tax Liable" := Rec."Tax Liable";
                                        Vend.VALIDATE("P.A.N. No.", Rec."P.A.N. No.");
                                        Vend."P.A.N. Status" := Rec."P.A.N. Status";
                                        Vend."Gen. Bus. Posting Group" := Rec."Gen. Bus. Posting Group";
                                        Vend.Blocked := Rec.Blocked;
                                        vend."Assessee Code" := Rec."Assessee Code";
                                        Vend.MODIFY;
                                    END;
                                END;
                            UNTIL Comp.NEXT = 0;
                        END;
                        MESSAGE('%1', 'Vendor Replicate successfully');


                        RegionwiseVendor.RESET;
                        RegionwiseVendor.SETRANGE("No.", Rec."No.");
                        IF NOT RegionwiseVendor.FINDFIRST THEN
                            ERROR('Please complete details');
                    END;

                    //TESTFIELD(Remarks);
                    Archived := TRUE;
                    Rec.MODIFY;
                    CurrPage.Editable(FALSE);//ALLECK 200413



                    IF (Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)") OR (Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"CP(Channel Partner)") THEN BEGIN  //280824 code Added
                                                                                                                                                                                                //IF "Vendor Category" = "Vendor Category"::"IBA(Associates)" THEN BEGIN  //280824 code commented
                        CompanyInfo.RESET;
                        CompanyInfo.SETRANGE("Send SMS", TRUE);
                        IF CompanyInfo.FINDFIRST THEN BEGIN
                            IF NOT Rec."BBG Message for Ass. Creation" THEN BEGIN
                                IF Rec."BBG Mob. No." <> '' THEN BEGIN
                                    CustMobileNo := Rec."BBG Mob. No.";

                                    //Comment MEssage 150224
                                    // CustSMSText :='Dear Mr/Ms: '+Name+'. Congrats and Welcome to BBG Family. Your Business ID '+"No."+' PWD is ' + FORMAT("Associate Password")+' Thank you and '+
                                    //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official BBG WhatsApp channel '+
                                    //'for updates https://shorturl.at/dgDQV BBGIND.';

                                    //Added New MEssage 150224

                                    IF (Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)") THEN
                                        //    CustSMSText := 'Dear Mr/Ms: ' + Rec.Name + ' Congrats and Welcome to BBG Family.Your Business ID ' + Rec."No." + ' PWD is BBG@1234 Thank you and Assure' +  //240625 code comment
                                        //  ' you of our Best Support in Transforming Your Dreams into Reality.Please join the official BBG WhatsApp channel for updateshttps://shorturl.at/dgDQV BBG Family.';  //240625 code comment
                                        CustSMSText := 'Dear Mr/Ms: ' + Rec.Name + ' Congrats and Welcome to BBG Family. Your Business ID is ' + Rec."No." + ' PWD is BBG@1234.' +
                                               ' We Assure you of our Best Support in Transforming Your Dreams into Reality. Please join our BBG WhatsApp channel for updates https://whatsapp.com/channel/0029Va9v5xP6rsQkBNMHFw2V BBGIND.';  //240625 code Added  


                                    IF (Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"CP(Channel Partner)") THEN
                                        CustSMSText := 'Dear Mr/Ms: ' + Rec.Name + ' Congrats and Welcome to BBG Family.Your Channel Partner ID NO :' + Rec."No." + ' PWD is BBG@1234. Thank and Assure' +
                                        ' you of our Best Support in Transforming Your Dreams into Reality. Good Luck and God Bless. BBG Family';

                                    //          CustSMSText :=  'Dear Mr/Ms: '+Name+'. Congrats and Welcome to BBG Family. Your Business ID '+"No."+ 'PWD is ' + FORMAT("Associate Password")+'. Thank you and '+
                                    //'Assure you of our Best Support in Transforming Your Dreams into Reality. Please join the official telegram channel '+
                                    //'(BBG Post Office) for updates https://t.me/BBGPostoffice BBGIND.';

                                    //'Dear Mr/Ms:' + Name+ ''+'. Congrats and Welcome to Building Blocks Family. Your Bussiness ID NO: '+ "No." + ','+
                                    // ' Dt:' + FORMAT("Date of Joining") +'. Thank and Assure you of our Best Support in Transforming Your Dreams into'+
                                    // ' '+'Reality. Good Luck and God Bless.BBGIND';

                                    MESSAGE('%1', CustSMSText);

                                    PostPayment.SendSMS(CustMobileNo, CustSMSText);
                                END ELSE
                                    MESSAGE('%1', 'Mobile No. not Found');
                                Rec."BBG Message for Ass. Creation" := TRUE;
                                Rec.MODIFY;
                            END;
                        END;
                    END;

                    Rec."BBG Vendor Card Status" := Rec."BBG Vendor Card Status"::Release;
                    Rec.MODIFY;
                end;
            }
            action("Re&Open")
            {
                Caption = 'Re&Open';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = All;

                trigger OnAction()
                var
                    companywisegl: Record "Company wise G/L Account";
                begin

                    //ALLECK 190413 START
                    Rec.TESTFIELD("BBG Vendor Category", Rec."BBG Vendor Category"::"IBA(Associates)");

                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", USERID);
                    UserSetup.SETRANGE("Associate Re-Open", TRUE);
                    IF NOT UserSetup.FINDFIRST THEN
                        ERROR('Please contact Admin');

                    ArchiveVndr.RESET;
                    ArchiveVndr.SETRANGE("No.", Rec."No.");
                    IF ArchiveVndr.FINDLAST THEN
                        Vrsn := ArchiveVndr.Version
                    ELSE
                        Vrsn := 0;

                    ArchiveVndr.RESET;
                    ArchiveVndr.INIT;
                    ArchiveVndr.TRANSFERFIELDS(Rec);
                    ArchiveVndr."Archive Date" := TODAY;
                    ArchiveVndr."Archive Time" := TIME;
                    ArchiveVndr.Version += 1;
                    ArchiveVndr."User Id" := USERID;
                    ArchiveVndr.INSERT;
                    Archived := FALSE;
                    Rec.MODIFY;

                    IF Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)" THEN BEGIN
                        CLEAR(memberof);
                        memberof.RESET;
                        memberof.SETRANGE("User Name", USERID);
                        memberof.SETRANGE("Role ID", 'A_IBACREATION');
                        IF memberof.FINDFIRST THEN
                            CurrPage.EDITable(TRUE)
                        ELSE
                            CurrPage.EDITable(FALSE);

                        companywisegl.RESET;
                        companywisegl.SETRANGE(companywisegl."MSC Company", TRUE);
                        IF companywisegl.FINDFIRST THEN BEGIN
                            IF COMPANYNAME <> companywisegl."Company Code" THEN
                                CurrPage.EDITable(FALSE);
                        END;
                    END ELSE BEGIN
                        CLEAR(memberof);
                        memberof.RESET;
                        memberof.SETRANGE("User Name", USERID);
                        memberof.SETRANGE("Role ID", 'A_OTHERVENDCREATION');
                        IF memberof.FINDFIRST THEN
                            CurrPage.EDITable(TRUE)
                        ELSE
                            CurrPage.EDITable(FALSE);
                    END;
                    //ALLECK 190413 END
                end;
            }
            action("Update Address")
            {
                Caption = 'Update Address';
                Image = Description;
                Promoted = true;
                PromotedCategory = Category7;
                ApplicationArea = All;

                trigger OnAction()
                begin

                    //BBG2.10
                    IF Rec.Address = '' THEN BEGIN
                        IF Rec."BBG Temp Address" <> '' THEN
                            Rec.Address := Rec."BBG Temp Address";
                    END ELSE
                        MESSAGE('Address already Exists. Contact to Admin');

                    IF Rec."Address 2" = '' THEN BEGIN
                        IF Rec."BBG Temp Address 2" <> '' THEN
                            Rec."Address 2" := Rec."BBG Temp Address 2";
                    END ELSE
                        MESSAGE('Address already Exists. Contact to Admin');


                    IF Rec."BBG Address 3" = '' THEN BEGIN
                        IF Rec."BBG Temp Address 3" <> '' THEN
                            Rec."BBG Address 3" := Rec."BBG Temp Address 3";
                    END ELSE
                        MESSAGE('Address already Exists. Contact to Admin');

                    IF Rec."BBG Mob. No." = '' THEN BEGIN
                        IF Rec."BBG Temp Mob. No." <> '' THEN
                            Rec."BBG Mob. No." := Rec."BBG Temp Mob. No.";
                    END ELSE
                        MESSAGE('Mobile No. already Exists. Contact to Admin');


                    Rec."BBG Temp Address" := '';
                    Rec."BBG Temp Address 2" := '';
                    Rec."BBG Temp Address 3" := '';
                    Rec."BBG Temp Mob. No." := '';
                    Rec.MODIFY;
                    //BBG2.10
                end;
            }
            action("Copy All IBA in Company")
            {
                Caption = 'Copy All IBA in Company';
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecVendorBankAccount: Record "Vendor Bank Account";
                    VendorBankAccount: Record "Vendor Bank Account";
                begin
                    Rec.TESTFIELD("BBG Sex");
                    Rec.TESTFIELD("BBG Nominee Name");
                    Rec.TESTFIELD("BBG Age");
                    Rec.TESTFIELD("BBG Father Name");
                    Rec.TESTFIELD(City);
                    Rec.TESTFIELD("Post Code");
                    Rec.TESTFIELD("BBG Designation");
                    Rec.TESTFIELD("E-Mail");

                    Rec.TESTFIELD("Gen. Bus. Posting Group");  //090821
                    Rec.TESTFIELD("BBG Copy IBA in Company");

                    IF (Rec."BBG Vendor Category" <> Rec."BBG Vendor Category"::"IBA(Associates)") OR (Rec."BBG Vendor Category" <> Rec."BBG Vendor Category"::"CP(Channel Partner)") THEN
                        ERROR('Vendor category either be IBA(Associates) OR CP(Channel Partner)');  //280824 Added new code
                                                                                                    //TESTFIELD("Vendor Category","Vendor Category"::"IBA(Associates)");  //280824 code commented

                    CopyVend.RESET;
                    //CopyVend.SETRANGE("Vendor Category","Vendor Category"::"IBA(Associates)");  //280824 code commented
                    CopyVend.SETFILTER("BBG Vendor Category", '%1|%2', CopyVend."BBG Vendor Category"::"IBA(Associates)", CopyVend."BBG Vendor Category"::"CP(Channel Partner)");//280824 Added new code
                    IF CopyVend.FINDFIRST THEN BEGIN
                        REPEAT
                            Vend.RESET;
                            //Vend.CHANGECOMPANY("BBG Copy IBA in Company");
                            Vend.SETRANGE("No.", CopyVend."No.");
                            //Vend.SETFILTER("Vendor Category",'%1',Vend."Vendor Category"::"IBA(Associates)");
                            IF NOT Vend.FINDFIRST THEN BEGIN
                                Vend.INIT;
                                Vend.TRANSFERFIELDS(CopyVend);
                                Vend.INSERT;
                                //BondSetup.CHANGECOMPANY("Copy IBA in Company");
                                BondSetup.GET;
                                BondSetup.TESTFIELD("TDS Nature of Deduction");
                                /*
                                NODHeader.CHANGECOMPANY("Copy IBA in Company");
                                IF NOT NODHeader.GET(NODHeader.Type::Vendor, Vend."No.") THEN BEGIN

                                    NODHeader.INIT;
                                    NODHeader.Type := NODHeader.Type::Vendor;
                                    NODHeader."No." := Vend."No.";
                                    NODHeader."Assesse Code" := 'IND';
                                    NODHeader.INSERT;
                                    

                            END;

                            NODLine.CHANGECOMPANY("Copy IBA in Company");
                            IF NOT NODLine.GET(NODLine.Type::Vendor, CopyVend."No.", BondSetup."TDS Nature of Deduction") THEN BEGIN
                                NODLine.Type := NODLine.Type::Vendor;
                                NODLine."No." := CopyVend."No.";
                                NODLine.VALIDATE("NOD/NOC", BondSetup."TDS Nature of Deduction");
                                NODLine."Monthly Certificate" := TRUE;
                                NODLine."Threshold Overlook" := TRUE;
                                NODLine."Surcharge Overlook" := TRUE;
                                NODLine.INSERT;
                            END;
                            *///Need to check the code in UAT
                                RecVendorBankAccount.RESET;
                                RecVendorBankAccount.SETRANGE("Vendor No.", CopyVend."No.");
                                IF RecVendorBankAccount.FINDSET THEN
                                    REPEAT
                                        VendorBankAccount.RESET;
                                        //VendorBankAccount.CHANGECOMPANY("Copy IBA in Company");
                                        VendorBankAccount.INIT;
                                        VendorBankAccount := RecVendorBankAccount;
                                        VendorBankAccount.INSERT;
                                    UNTIL RecVendorBankAccount.NEXT = 0;
                            END;
                            CLEAR(Vend);
                            Vend.RESET;
                            //Vend.CHANGECOMPANY("BBG Copy IBA in Company");
                            Vend.SETRANGE("No.", CopyVend."No.");
                            //Vend.SETFILTER("Vendor Category",'%1',Vend."Vendor Category"::"IBA(Associates)");
                            IF Vend.FINDFIRST THEN BEGIN
                                Vend."Vendor Posting Group" := CopyVend."Vendor Posting Group";
                                Vend."BBG Status" := CopyVend."BBG Status";
                                Vend."BBG Date of Birth" := CopyVend."BBG Date of Birth";
                                Vend."BBG Date of Joining" := CopyVend."BBG Date of Joining";
                                Vend."BBG Sex" := CopyVend."BBG Sex";
                                Vend."BBG Marital Status" := CopyVend."BBG Marital Status";
                                Vend."BBG Nationality" := CopyVend."BBG Nationality";
                                Vend."BBG Associate Creation" := CopyVend."BBG Associate Creation";
                                Vend."Tax Liable" := CopyVend."Tax Liable";
                                Vend.Blocked := CopyVend.Blocked;
                                vend."Assessee Code" := Rec."Assessee Code";
                                Vend.MODIFY;
                            END;
                        UNTIL CopyVend.NEXT = 0;
                        MESSAGE('%1', 'Copy all IBA in all companies');
                    END;
                end;
            }
            action("Vendor Hierarchy")
            {
                Caption = 'Vendor Hierarchy';
                RunObject = Page "Regin and Rank wise vendor";
                ApplicationArea = All;
            }
            action("Send SMS")
            {
                Caption = 'Send SMS';
                ApplicationArea = All;

                trigger OnAction()
                var
                    RegionwiseVendor: Record "Region wise Vendor";
                    CompanyInfo: Record "Company Information";
                    NewAssociateBottom: Report "New Associate Bottom To Top_1";
                begin
                    IF Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)" THEN BEGIN
                        COMMIT;
                        RegionwiseVendor.RESET;
                        RegionwiseVendor.SETRANGE("No.", Rec."No.");
                        IF NOT RegionwiseVendor.FINDFIRST THEN
                            ERROR('Please complete details');

                        CompanyInfo.RESET;
                        CompanyInfo.SETRANGE("Send SMS", TRUE);
                        IF CompanyInfo.FINDFIRST THEN BEGIN
                            CLEAR(NewAssociateBottom);
                            NewAssociateBottom.SetfValues(Rec."No.", RegionwiseVendor."Region Code", TRUE, FALSE, FALSE, FALSE, '', TODAY);
                            NewAssociateBottom.RUNMODAL;
                        END;
                    END;
                end;
            }

        }
    }

    var
        myInt: Integer;
        GetDescription: Codeunit GetDescription;
        memberof: Record "Access Control";
        UserSetup: Record "User Setup";
        //SuspendHold: Report 50020;
        ParamType: Option Suspend,Release,Hold,Unhold;
        InactiveMM: Report "Sales invoice DAta";
        Vendor: Record Vendor;
        BalAmount: Decimal;
        ArchiveVndr: Record "Archive Vendor";
        Vrsn: Integer;
        Archived: Boolean;
        CustMobileNo: Text[30];
        CustSMSText: Text[800];
        PostPayment: Codeunit PostPayment;
        Comp: Record Company;
        Vend: Record Vendor;
        BondSetup: Record "Unit Setup";
        //NODHeader: Record 13786;
        //NODLine: Record 13785;
        CompanywiseAccount: Record "Company wise G/L Account";
        CopyVend: Record Vendor;
        MSVendor: Record Vendor;
        MobVisible: Boolean;
        AddVisible: Boolean;
        Add2Visible: Boolean;
        Add3Visible: Boolean;
        PhVisible: Boolean;
        Ph2Visible: Boolean;
        ContactVisible: Boolean;
        Text003: Label 'The vendor %1 does not exist.';
        Text006: label 'Do you want to create NOD for Commission for the Marketing Member No. %1?';
        Text007: label 'Do you want to suspend the Marketing Member No. %1?';
        Text008: label 'Do you want to release suspension for the Marketing Member No. %1?';
        Text009: label 'Do you want to hold the payables for the Marketing Member No. %1?';
        Text010: label 'Do you want to unhold payables for the Marketing Member No. %1?';
        Text011: label 'Do you want to change the Status of the Marketing Member No. %1?';
        Text012: label 'Do you want to change chain for the Marketing Member No. %1?';
        Text013: label 'Do you want to inactive the Marketing Member No. %1?';
        Text004: label 'Invalid Permission.';
        Text005: label 'Do you want to change the rank for the Marketing Member No. %1?';
        Text014: label 'Do you want to change the Parent for the Marketing Member No. %1?';
        AssociateLoginDetails: Record "Associate Login Details";
        AssocLoginDetails: Record "Associate Login Details";

        NameVisible: Boolean;
        AssociateTeamforGamifiction: Report "Team Head Name Update";
        RequesttoApproveDocuments: Record "Request to Approve Documents";
        ApprovalWorkflowforAuditPr: Record "Approval Workflow for Audit Pr";
        RegionwiseVendor: Record "Region wise Vendor";
        RankCodeMaster: Record "Rank Code";
        kMobileNoforSMS: Codeunit "Check Mobile No for SMS";
        compwiseGL: record "Company wise G/L Account";


    trigger OnOpenPage()
    begin
        //BBG2.01 22/07/14
        CLEAR(memberof);
        memberof.RESET;
        memberof.SETRANGE("User Name", USERID);
        memberof.SETRANGE("Role ID", 'VendInfoVisible');
        IF NOT memberof.FINDFIRST THEN BEGIN
            MobVisible := FALSE;
            AddVisible := FALSE;
            Add2Visible := FALSE;
            Add3Visible := FALSE;
            PhVisible := FALSE;
            Ph2Visible := FALSE;
            ContactVisible := FALSE;
            NameVisible := FALSE;
            // ALLE MM NAV 2009 Code Commented

            // ALLE MM NAV 2009 Code Commented
        END ELSE BEGIN
            MobVisible := TRUE;
            AddVisible := TRUE;
            Add2Visible := TRUE;
            Add3Visible := TRUE;
            PhVisible := TRUE;
            Ph2Visible := TRUE;
            ContactVisible := TRUE;
            NameVisible := TRUE;
            // ALLE MM NAV 2009 Code Commented

            // ALLE MM NAV 2009 Code Commented
        END;
        //BBG2.01 22/07/14
    end;

    trigger OnAfterGetRecord()
    Begin
        Rec.SETRANGE("No.");

        SetSecurity(FALSE);

        Rec.CALCFIELDS("BBG Commission Amount Qualified");
        Rec.CALCFIELDS("BBG Travel Amount Qualified");
        Rec.CALCFIELDS("BBG Incentive Amount Qualified");
        Rec.CALCFIELDS("BBG Balance at Date (LCY)");

        BalAmount := -1 * Rec."BBG Balance at Date (LCY)";
        Rec."BBG Total Balance Amount" := Rec."BBG Commission Amount Qualified" + Rec."BBG Travel Amount Qualified" + Rec."BBG Incentive Amount Qualified" -
                                    Rec."BBG Balance at Date (LCY)";
    End;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UserSetup.RESET;
        UserSetup.SETRANGE("User ID", USERID);
        UserSetup.SETRANGE("Associate Creation", TRUE);
        IF NOT UserSetup.FINDFIRST THEN
            ERROR('Please contact Admin');
        Rec."BBG Vendor Category" := Rec."BBG Vendor Category"::"IBA(Associates)";

        IF Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)" THEN BEGIN
            CompanywiseAccount.RESET;
            CompanywiseAccount.SETRANGE(CompanywiseAccount."MSC Company", TRUE);
            IF CompanywiseAccount.FINDFIRST THEN BEGIN
                IF COMPANYNAME <> CompanywiseAccount."Company Code" THEN
                    ERROR('Create Vendor from Master Company');
            END;
        END;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."BBG Vendor Category" := Rec."BBG Vendor Category"::"IBA(Associates)";
        IF Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)" THEN BEGIN
            UserSetup.RESET;
            UserSetup.SETRANGE("User ID", USERID);
            UserSetup.SETRANGE(UserSetup."Associate Creation", TRUE);
            IF NOT UserSetup.FINDFIRST THEN
                ERROR('You do not have permission for Associate Creation in user setup');//Please contact Admin

            CompanywiseAccount.RESET;
            CompanywiseAccount.SETRANGE(CompanywiseAccount."MSC Company", TRUE);
            IF CompanywiseAccount.FINDFIRST THEN BEGIN
                IF COMPANYNAME <> CompanywiseAccount."Company Code" THEN
                    ERROR('Create Vendor from Master Company');
            END;
        END;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        memberof.RESET;
        memberof.SETRANGE("User Name", USERID);
        memberof.SETRANGE("Role ID", 'VendInfoVisible');
        IF memberof.FINDFIRST THEN
            Rec.TESTFIELD(Name);  //310821

        compwiseGL.RESET;
        compwiseGL.SetRange("Company Code", CompanyName);
        compwiseGL.SetRange("MSC Company", True);
        If compwiseGL.FindFirst() THEN begin
            IF Rec."BBG Vendor Category" = Rec."BBG Vendor Category"::"IBA(Associates)" THEN BEGIN
                Rec.TESTFIELD("BBG Reporting Office");
                IF Rec."BBG New Cluster Code" = '' THEN
                    ERROR('Please enter a value in Cluster Code');
            END;
        end;
    end;

    LOCAL PROCEDURE SetSecurity(OpenForm: Boolean);
    BEGIN
        //ALLEDK 030313      
        //ALLEDK 030313
    END;

    //280525 Create New lead for Manual Associate creation.
    local procedure CreateAssocaiteLead(VendLead: Record Vendor)
    var
        CustomersLead: Record "Customers Lead_2";
        RegionwiseVendor_1: Record "Region wise Vendor";
    begin

        CustomersLead.RESET;
        CustomersLead.SetRange("Mobile Phone No.", VendLead."BBG Mob. No.");
        CustomersLead.SetRange("Request From", CustomersLead."Request From"::Vendor);
        If NOT CustomersLead.FindFirst() THEN BEGIN
            CustomersLead.INIT;
            CustomersLead."No." := '';
            CustomersLead.INSERT(TRUE);
            CustomersLead.Address := CopyStr(VendLead.Address, 1, 50);
            CustomersLead."Address 2" := CopyStr(VendLead."Address 2", 1, 50);
            CustomersLead."First Name" := CopyStr(VendLead.Name, 1, 30);
            CustomersLead."Middle Name" := CopyStr(VendLead.Name, 31, 30);
            CustomersLead.Surname := CopyStr(VendLead.Name, 61, 30);
            CustomersLead.Name := CopyStr(VendLead.Name, 1, 50);
            CustomersLead.Gender := VendLead."BBG Sex";
            CustomersLead.DOB := VendLead."BBG Date of Birth";
            CustomersLead."State Code" := VendLead."State Code";
            CustomersLead."District Code" := VendLead."District Code";
            CustomersLead."Mandal Code" := VendLead."Mandal Code";
            CustomersLead."Village Code" := VendLead."Village Code";
            RegionwiseVendor_1.Reset();
            RegionwiseVendor_1.setrange("No.", VendLead."No.");
            IF RegionwiseVendor_1.FindFirst() then
                CustomersLead."Associate ID" := RegionwiseVendor_1."Parent Code";
            CustomersLead."Associate Name" := RegionwiseVendor_1."Parent Name";
            CustomersLead.Rank_Code := RegionwiseVendor_1."Rank Code";

            CustomersLead."Post Code" := VendLead."Post Code";
            CustomersLead."Mobile Phone No." := VendLead."BBG Mob. No.";
            CustomersLead.City := VendLead.City;
            CustomersLead."E-Mail" := VendLead."E-Mail";
            CustomersLead.Status := CustomersLead.Status::Approved;
            CustomersLead."Request From" := CustomersLead."Request From"::Vendor;
            IF VendLead."BBG Aadhar No." <> '' then
                CustomersLead."Aadhaar Number" := VendLead."BBG Aadhar No.";
            CustomersLead."Pan Number" := VendLead."P.A.N. No.";
            CustomersLead."Lead Associate / Customer Id" := VendLead."No.";
            CustomersLead."Reporting Office Name" := VendLead."BBG Reporting Office"; //301123  Added   //020524 added new code
                                                                                      //CustomersLead."Reporting Office ID" := BranchId;  //301123 Added   //020524 added new code

            // CustomersLead."Cluster Description" := Rec."BBG Cluster Type"; //020524 added new code
            // CustomersLead."Cluster Code" := clusterId;  //020524 added new code
            // IF VendState = 1 THEN
            //     CustomersLead."Region Code" := 'TS';
            // IF VendState = 2 THEN
            //     CustomersLead."Region Code" := 'AP';

            CustomersLead.MODIFY;
        END;
    end;
}