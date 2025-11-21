report 80004 "Update TAApplicable"
{
    Caption = 'Update TRApplicable';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where("Number" = const(1));

            trigger OnAfterGetRecord()

            begin
                Comp.RESET;
                IF Comp.FindSet() then
                    repeat
                        Corder.RESET;
                        Corder.ChangeCompany(Comp.Name);
                        //Corder.SetRange("Posting Date", 20010101D, 20250630D);
                        If Corder.FindSet() then
                            repeat
                                Corder."Travel applicable" := True;
                                Corder."Registration Bouns (BSP2)" := True;

                                Jobs.Reset();
                                jobs.ChangeCompany(Comp.Name);
                                IF Jobs.GET(Corder."Shortcut Dimension 1 Code") then
                                    Corder."Region Code" := jobs."Region Code for Rank Hierarcy";
                                Corder.Modify;
                                nCorder.RESET;
                                //nCorder.SetRange("Posting Date", 20010101D, 20250630D);
                                nCorder.SetRange("No.", Corder."No.");
                                If nCorder.FindFirst() then begin
                                    nCorder."Travel applicable" := True;
                                    nCorder."Registration Bouns (BSP2)" := True;
                                    nCorder."Region Code" := Corder."Region Code";
                                    nCorder.Modify;
                                END;

                            until Corder.Next = 0;
                    Until Comp.Next = 0;



                NewAppBooking.RESET;
                //NewAppBooking.SetRange("Posting Date", 20010101D, 20250630D);
                If NewAppBooking.FindSet() then
                    repeat
                        NewAppBooking."Travel applicable" := True;
                        NewAppBooking."Registration Bouns (BSP2)" := True;
                        Jobs.Reset();
                        //jobs.ChangeCompany(Comp.Name);
                        IF Jobs.GET(NewAppBooking."Shortcut Dimension 1 Code") then
                            NewAppBooking."Rank Code" := jobs."Region Code for Rank Hierarcy";
                        NewAppBooking.Modify;
                    until NewAppBooking.Next = 0;

                TravelsetupLine.RESET;
                IF TravelsetupLine.FindSet() then
                    repeat
                        TravelsetupLine.CalcFields("Region/Rank Code");
                        TravelsetupLinenew.Init;
                        TravelsetupLinenew.TransferFields(TravelsetupLine);
                        TravelsetupLinenew."New Region / Rank Code" := TravelsetupLine."Region/Rank Code";
                        TravelsetupLinenew.insert;
                    Until TravelsetupLine.Next = 0;

            end;
        }
    }


    trigger OnPostReport()
    Begin
        Message('Done');
    End;

    var
        Corder: Record "Confirmed Order";
        nCorder: Record "New Confirmed Order";
        Comp: Record company;
        NewAppBooking: record "New Application Booking";
        Jobs: Record job;
        TravelsetupLine: Record "Travel Setup Line";
        TravelsetupLinenew: Record "Travel Setup Line New";

}