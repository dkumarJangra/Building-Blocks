page 50120 "Associate Profile Update"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Associate Login Details";
    SourceTableView = WHERE("Vendor Profile Status" = CONST(Open));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Send for Profile Update"; Rec."Send for Profile Update")
                {
                }
                field(USER_ID; Rec.USER_ID)
                {
                }
                field("Mobile_ No"; Rec."Mobile_ No")
                {
                }
                field(Associate_ID; Rec.Associate_ID)
                {
                }
                field(Rank_Code; Rec.Rank_Code)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field(Date_OF_Birth; Rec.Date_OF_Birth)
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Address; Rec.Address)
                {
                }
                field(City; Rec.City)
                {
                }
                field(Post_Code; Rec.Post_Code)
                {
                }
                field(PAN_No; Rec.PAN_No)
                {
                }
                field(Introducer_Code; Rec.Introducer_Code)
                {
                }
                field(Date_OF_Joining; Rec.Date_OF_Joining)
                {
                }
                field(Of_User_ID; Rec.Of_User_ID)
                {
                }
                field(Parent_ID; Rec.Parent_ID)
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("NAV-Associate Created"; Rec."NAV-Associate Created")
                {
                }
                field("NAV-Associate Creation Date"; Rec."NAV-Associate Creation Date")
                {
                }
                field("Is Active"; Rec."Is Active")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Associate Profile")
            {

                trigger OnAction()
                var
                    RecVendor: Record Vendor;
                    Company: Record Company;
                    AssociateLoginDetails: Record "Associate Login Details";
                begin
                    AssociateLoginDetails.RESET;
                    AssociateLoginDetails.SETRANGE("Vendor Profile Status", AssociateLoginDetails."Vendor Profile Status"::Open);
                    IF AssociateLoginDetails.FINDSET THEN
                        REPEAT
                            Company.RESET;
                            IF Company.FINDSET THEN
                                REPEAT
                                    RecVendor.RESET;
                                    RecVendor.CHANGECOMPANY(Company.Name);
                                    RecVendor.SETRANGE("No.", AssociateLoginDetails.Associate_ID);
                                    IF RecVendor.FINDFIRST THEN BEGIN
                                        RecVendor."BBG Date of Birth" := AssociateLoginDetails.Date_OF_Birth;
                                        RecVendor.Name := AssociateLoginDetails.Name;
                                        RecVendor.Address := COPYSTR(AssociateLoginDetails.Address, 1, 50);
                                        RecVendor."Address 2" := COPYSTR(AssociateLoginDetails.Address, 51, 100);
                                        RecVendor."BBG Address 3" := COPYSTR(AssociateLoginDetails.Address, 101, 150);
                                        RecVendor.City := AssociateLoginDetails.City;
                                        RecVendor."Post Code" := AssociateLoginDetails.Post_Code;
                                        RecVendor."P.A.N. No." := AssociateLoginDetails.PAN_No;
                                        RecVendor."BBG Introducer" := AssociateLoginDetails.Introducer_Code;
                                        RecVendor."District Code" := AssociateLoginDetails."District Code";
                                        RecVendor."Mandal Code" := AssociateLoginDetails."Mandal Code";
                                        RecVendor."Village Code" := AssociateLoginDetails."Village Code";
                                        RecVendor."State Code" := AssociateLoginDetails."Village Code";
                                        If AssociateLoginDetails."Aadhaar Number" <> '' then
                                            RecVendor."BBG Aadhar No." := AssociateLoginDetails."Aadhaar Number";
                                        //RecVendor.Date_OF_Joining := Date_OF_Joining;
                                        RecVendor.MODIFY;
                                    END;
                                UNTIL Company.NEXT = 0;
                            AssociateLoginDetails."Vendor Profile Status" := AssociateLoginDetails."Vendor Profile Status"::Close;
                            AssociateLoginDetails.MODIFY;
                        UNTIL AssociateLoginDetails.NEXT = 0;
                end;
            }
        }
    }

    var
        Vendor: Record Vendor;
        RegionwiseVendor: Record "Region wise Vendor";
        CompanywiseGLAccount: Record "Company wise G/L Account";
        AssociateLoginDetails: Record "Associate Login Details";
        NoSeriesManagement: Codeunit NoSeriesManagement;
    // BondSetup: Record 97788;
    // NODHeader: Record 13786;
    // NODLine: Record 13785;
}

