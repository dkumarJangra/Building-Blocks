page 60805 "Yearly Pre-Deactivate VendList"
{
    PageType = List;
    SourceTable = "Yearly De-Activate Vendor list";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Yearly Pre-Deactivate VendList';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Selected; Rec.Selected)
                {
                }
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field(Address; Rec.Address)
                {
                    Editable = false;
                }
                field("Address 2"; Rec."Address 2")
                {
                    Editable = false;
                }
                field(City; Rec.City)
                {
                    Editable = false;
                }
                field("Post Code"; Rec."Post Code")
                {
                    Editable = false;
                }
                field(County; Rec.County)
                {
                    Editable = false;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    Editable = false;
                }
                field("P.A.N. No."; Rec."P.A.N. No.")
                {
                    Editable = false;
                }
                field("State Code"; Rec."State Code")
                {
                    Editable = false;
                }
                field("P.A.N. Reference No."; Rec."P.A.N. Reference No.")
                {
                    Editable = false;
                }
                field("P.A.N. Status"; Rec."P.A.N. Status")
                {
                    Editable = false;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    Editable = false;
                }
                field("Cluster Type"; Rec."Cluster Type")
                {
                    Editable = false;
                }
                field("Cluster Code"; Rec."Cluster Code")
                {
                    Editable = false;
                }
                field("Team Code"; Rec."Team Code")
                {
                    Editable = false;
                }
                field("Leader Code"; Rec."Leader Code")
                {
                    Editable = false;
                }
                field("Sub Team Code"; Rec."Sub Team Code")
                {
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    Editable = false;
                }
                field("Batch Run Date"; Rec."Batch Run Date")
                {
                    Editable = false;
                }
                field("Batch Run By"; Rec."Batch Run By")
                {
                    Editable = false;
                }
                field("Batch Run Time"; Rec."Batch Run Time")
                {
                    Editable = false;
                }
                field("Date of Joining"; Rec."Date of Joining")
                {
                }
                field("Mob. No."; Rec."Mob. No.")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Insert Data")
            {
                RunObject = Report "Yearly De-Activate Vendor";
            }
            action("Process and Send Mail")
            {

                trigger OnAction()
                begin
                    //ERROR('WIP');
                    IF CONFIRM('Do you want to run the process.') THEN BEGIN
                        IF (USERID = 'NAVUSER4') OR (USERID = 'BCUSER') THEN BEGIN
                            IF CONFIRM('Do you want to Send the Mail and Update Mobile No.') THEN BEGIN
                                PreDeactivateVendors.RESET;
                                PreDeactivateVendors.SETRANGE(Selected, TRUE);
                                IF PreDeactivateVendors.FINDSET THEN
                                    REPEAT
                                        IF PreDeactivateVendors.Type = PreDeactivateVendors.Type::"Black List" THEN BEGIN
                                            Company.RESET;
                                            IF Company.FINDSET THEN
                                                REPEAT
                                                    RecVendor.RESET;
                                                    RecVendor.CHANGECOMPANY(Company.Name);
                                                    RecVendor.SETRANGE("No.", PreDeactivateVendors."No.");
                                                    IF RecVendor.FINDFIRST THEN BEGIN
                                                        RecVendor."BBG Black List" := TRUE;
                                                        RecVendor."BBG Mob. No." := 'R' + RecVendor."BBG Mob. No.";
                                                        RecVendor.MODIFY;
                                                    END;
                                                UNTIL Company.NEXT = 0;

                                            AssociateLoginDetails.RESET;
                                            AssociateLoginDetails.SETRANGE(Associate_ID, PreDeactivateVendors."No.");
                                            IF AssociateLoginDetails.FINDFIRST THEN BEGIN
                                                AssociateLoginDetails."Mobile_ No" := 'R' + AssociateLoginDetails."Mobile_ No";
                                                AssociateLoginDetails.MODIFY;
                                            END;
                                        END;
                                        COMMIT;
                                    UNTIL PreDeactivateVendors.NEXT = 0;

                                //------------------------SEND SMS--------------

                                CompanyInformation.GET;
                                IF CompanyInformation."Send SMS" THEN BEGIN
                                    BBGSetups.GET;
                                    PreDeactivateVendors.RESET;
                                    PreDeactivateVendors.SETRANGE(Selected, TRUE);
                                    IF PreDeactivateVendors.FINDSET THEN
                                        REPEAT
                                            PostPayment.SendSMS_DeActivate(PreDeactivateVendors."Mob. No.", BBGSetups.SMS);
                                            COMMIT;
                                        UNTIL PreDeactivateVendors.NEXT = 0;
                                END;
                                OldYearlyDeActivateVendorlist.DELETEALL;
                            END ELSE
                                MESSAGE('Nothing Process');
                        END ELSE
                            MESSAGE('Contact Admin');
                    END;
                end;
            }
        }
    }

    var
        PreDeactivateVendors: Record "Yearly De-Activate Vendor list";
        Company: Record Company;
        RecVendor: Record Vendor;
        RecVendor_1: Record Vendor;
        PostPayment: Codeunit PostPayment;
        BBGSetups: Record "BBG Setups";
        CompanyInformation: Record "Company Information";
        ArchiveRegionwiseVendor: Record "Archive Region wise Vendor";
        AssociateLoginDetails: Record "Associate Login Details";
        OldYearlyDeActivateVendorlist: Record "Yearly De-Activate Vendor list";
}

