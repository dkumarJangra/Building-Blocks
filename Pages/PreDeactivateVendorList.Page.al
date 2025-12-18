page 50183 "Pre-Deactivate Vendor List"
{
    PageType = List;
    SourceTable = "Pre- De-activate Vendors";
    UsageCategory = Lists;
    ApplicationArea = All;

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
                RunObject = Report "Associate Data of Non Trans.";
            }
            action("Process and Send Mail")
            {

                trigger OnAction()
                begin
                    //ERROR('WIP');
                    IF (USERID = 'NAVUSER4') OR (USERID = 'BCUSER') THEN BEGIN
                        IF CONFIRM('Do you want to continue the Process.') THEN BEGIN
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
                                    END ELSE BEGIN
                                        RecVendor_1.RESET;
                                        IF RecVendor_1.GET(PreDeactivateVendors."No.") THEN;
                                        DeActivateVendors.RESET;
                                        IF NOT DeActivateVendors.GET(PreDeactivateVendors."No.") THEN BEGIN
                                            DeActivateVendors.INIT;
                                            DeActivateVendors.TRANSFERFIELDS(RecVendor_1);
                                            DeActivateVendors."Batch Run By" := USERID;
                                            DeActivateVendors."Batch Run Date" := TODAY;
                                            DeActivateVendors."Batch Run Time" := TIME;
                                            DeActivateVendors.INSERT;
                                        END;
                                    END;
                                    COMMIT;
                                UNTIL PreDeactivateVendors.NEXT = 0;


                            //Added code 16122025 Start
                            DeActivateVendors.RESET;
                            DeActivateVendors.SetRange("Batch Run Date", Today);
                            IF DeActivateVendors.FindSet() then
                                repeat
                                    RegionwisevendOld.RESET;
                                    RegionwisevendOld.SetRange("Parent Code", DeActivateVendors."No.");
                                    IF RegionwisevendOld.Findset then
                                        repeat
                                            ArchiveRegionwiseVendor.RESET;
                                            ArchiveRegionwiseVendor.SETRANGE("Region Code", RegionwisevendOld."Region Code");
                                            ArchiveRegionwiseVendor.SETRANGE("No.", RegionwisevendOld."No.");
                                            IF ArchiveRegionwiseVendor.FINDLAST THEN
                                                ArchiveNo := ArchiveRegionwiseVendor."Version No."
                                            ELSE
                                                ArchiveNo := 1;

                                            ArchiveRegionwiseVendor.RESET;
                                            ArchiveRegionwiseVendor.INIT;
                                            ArchiveRegionwiseVendor.TRANSFERFIELDS(RegionwisevendOld);
                                            ArchiveRegionwiseVendor."Version No." := ArchiveNo + 1;
                                            ArchiveRegionwiseVendor."Creation Date" := Today;
                                            ArchiveRegionwiseVendor.INSERT;
                                        Until RegionwisevendOld.Next = 0;

                                    Regionwisevend.RESET;
                                    Regionwisevend.SetRange("Parent Code", DeActivateVendors."No.");
                                    IF Regionwisevend.Findset then
                                        repeat
                                            Clear(OtherEventMgnt);
                                            Newparentcode := '';
                                            Newparentcode := OtherEventMgnt.ReturnParentCode(DeActivateVendors."No.", Regionwisevend."Region Code", True);

                                            IF Newparentcode <> '' then BEGIN
                                                Regionwisevend.Validate("Parent Code", Newparentcode);

                                                Updatevendor.RESET;
                                                IF Updatevendor.GET(Regionwisevend."No.") THEN begin
                                                    Newregionwisevend.RESET;
                                                    IF Newregionwisevend.GET(Regionwisevend."Region Code", Newparentcode) then
                                                        Updatevendor."BBG Team Code" := Newregionwisevend."Team Code";
                                                    Updatevendor.Modify;
                                                end;
                                                Regionwisevend."Team Code" := Newregionwisevend."Team Code";
                                                Regionwisevend.Modify;
                                            END;
                                        Until Regionwisevend.Next = 0;
                                Until DeActivateVendors.Next = 0;

                            // DeActivateVendors.RESET;
                            // DeActivateVendors.SetRange("Batch Run Date", Today);
                            // IF DeActivateVendors.FindSet() then
                            //     repeat
                            //         RegionwisevendOld.RESET;
                            //         RegionwisevendOld.SetRange("No.", DeActivateVendors."No.");
                            //         IF RegionwisevendOld.Findset then
                            //             repeat
                            //                 Clear(Teamcodeupdatedownline);
                            //                 Teamcodeupdatedownline.UpdateTeamNameatDownline(DeActivateVendors."No.", RegionwisevendOld."Region Code", RegionwisevendOld."Team Code");
                            //             Until Regionwisevend.Next = 0;

                            //     Until DeActivateVendors.Next = 0;


                            //Added code 16122025 END
                            COMMIT;

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

                                PreDeactivateVendors.RESET;
                                PreDeactivateVendors.SETRANGE(Selected, TRUE);
                                PreDeactivateVendors.SETRANGE(Type, PreDeactivateVendors.Type::Delete);
                                IF PreDeactivateVendors.findset then
                                    repeat
                                        DeActivateVendors.RESET;
                                        IF DeActivateVendors.GET(PreDeactivateVendors."No.") THEN BEGIN
                                            RecVendor.RESET;
                                            IF RecVendor.GET(PreDeactivateVendors."No.") THEN
                                                RecVendor.DELETE;
                                        END;
                                    Until PreDeactivateVendors.Next = 0;

                                //251124 Code END
                                PreDeactivateVendors.RESET;
                                IF PreDeactivateVendors.FINDSET THEN
                                    PreDeactivateVendors.DELETEALL;
                            END;
                        END ELSE
                            MESSAGE('Nothing Process');
                    END ELSE
                        MESSAGE('Contact Admin');
                end;
            }
            action("Un-Select All")
            {
                trigger OnAction()
                var
                    PReDactiveVendors: Record "Pre- De-activate Vendors";
                begin
                    PReDactiveVendors.RESET;
                    IF PReDactiveVendors.FindSet() then
                        repeat
                            PReDactiveVendors.Selected := False;
                            PReDactiveVendors.Modify;
                        until PReDactiveVendors.Next = 0;
                    Message('Done');
                end;
            }
        }
    }

    var
        PreDeactivateVendors: Record "Pre- De-activate Vendors";
        DeActivateVendors: Record "De-Activate Vendors";
        Company: Record Company;
        RecVendor: Record Vendor;
        RecVendor_1: Record Vendor;
        PostPayment: Codeunit PostPayment;
        BBGSetups: Record "BBG Setups";
        CompanyInformation: Record "Company Information";
        ArchiveRegionwiseVendor: Record "Archive Region wise Vendor";
        AssociateLoginDetails: Record "Associate Login Details";
        OtherEventMgnt: Codeunit "Other Event Mgnt";
        Regionwisevend: Record "Region wise Vendor";
        RegionwisevendOld: Record "Region wise Vendor";
        Newparentcode: code[20];
        ArchiveNo: Integer;
        Teamcodeupdatedownline: codeunit "Team codeupdate at downline";
        Updatevendor: Record vendor;
        Newregionwisevend: Record "Region wise Vendor";

    local procedure UpdateRankWiseVendorData(VendorCode: Code[20])
    var
        RegionwiseVendor: Record "Region wise Vendor";
        ParentCode: Code[20];
        UpdateRegionwiseVendor: Record "Region wise Vendor";
        DeleteRegionwiseVendor: Record "Region wise Vendor";
        Region: Code[20];
        Vendors: Text;
        OldDeactivateRegionwiseVendor: Record "Deactivate Region wise Vendor";
        DeactivateRegionwiseVendor: Record "Deactivate Region wise Vendor";
        ArchiveNo: Integer;
        Vendor_L: Record Vendor;
        RegionwiseVendor_L: Record "Region wise Vendor";
    begin
        CLEAR(Region);
        RegionwiseVendor.RESET;
        RegionwiseVendor.SETRANGE("No.", VendorCode);
        IF RegionwiseVendor.FINDFIRST THEN
            REPEAT
                IF Region <> RegionwiseVendor."Region Code" THEN BEGIN
                    ParentCode := RegionwiseVendor."Parent Code";
                    Region := RegionwiseVendor."Region Code";
                    OldDeactivateRegionwiseVendor.RESET;
                    OldDeactivateRegionwiseVendor.SETRANGE("Region Code", RegionwiseVendor."Region Code");
                    OldDeactivateRegionwiseVendor.SETRANGE("No.", VendorCode);
                    IF NOT OldDeactivateRegionwiseVendor.FINDFIRST THEN BEGIN
                        DeactivateRegionwiseVendor.INIT;
                        DeactivateRegionwiseVendor.TRANSFERFIELDS(RegionwiseVendor);
                        DeactivateRegionwiseVendor.INSERT;
                    END;

                    IF ParentCode <> '' THEN BEGIN
                        UpdateRegionwiseVendor.RESET;
                        UpdateRegionwiseVendor.SETRANGE("Parent Code", VendorCode);
                        UpdateRegionwiseVendor.SETRANGE("Region Code", Region);
                        IF UpdateRegionwiseVendor.FINDFIRST THEN
                            REPEAT

                                ArchiveRegionwiseVendor.RESET;
                                ArchiveRegionwiseVendor.SETRANGE("Region Code", UpdateRegionwiseVendor."Region Code");
                                ArchiveRegionwiseVendor.SETRANGE("No.", UpdateRegionwiseVendor."No.");
                                IF ArchiveRegionwiseVendor.FINDLAST THEN
                                    ArchiveNo := ArchiveRegionwiseVendor."Version No."
                                ELSE
                                    ArchiveNo := 1;

                                ArchiveRegionwiseVendor.RESET;
                                ArchiveRegionwiseVendor.INIT;
                                ArchiveRegionwiseVendor.TRANSFERFIELDS(UpdateRegionwiseVendor);
                                ArchiveRegionwiseVendor."Version No." := ArchiveNo + 1;
                                ArchiveRegionwiseVendor.INSERT;
                                IF Vendor_L.GET(ParentCode) THEN
                                    UpdateRegionwiseVendor.VALIDATE("Parent Code", ParentCode)
                                ELSE BEGIN
                                    UpdateRegionwiseVendor."Parent Code" := ParentCode;
                                    RegionwiseVendor_L.RESET;
                                    IF RegionwiseVendor_L.GET(Region, ParentCode) THEN BEGIN
                                        UpdateRegionwiseVendor."Parent Rank" := RegionwiseVendor_L."Rank Code";
                                        UpdateRegionwiseVendor."Parent Description" := RegionwiseVendor_L."Rank Description";
                                    END;

                                END;
                                UpdateRegionwiseVendor.MODIFY;
                            UNTIL UpdateRegionwiseVendor.NEXT = 0;
                    END;
                END;
            UNTIL RegionwiseVendor.NEXT = 0;

        /*
        
        DeleteRegionwiseVendor.RESET;
        DeleteRegionwiseVendor.SETRANGE("No.",VendorCode);
        IF DeleteRegionwiseVendor.FINDFIRST THEN
        REPEAT
          DeleteRegionwiseVendor.DELETE();
        UNTIL DeleteRegionwiseVendor.NEXT=0;
        */

    end;
}

