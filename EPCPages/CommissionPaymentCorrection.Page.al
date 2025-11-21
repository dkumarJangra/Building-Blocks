page 97941 "Commission Payment Correction"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            group(General)
            {
                field(PostedDocNo; PostedDocNo)
                {
                    Caption = 'Posted Document No.';
                }
                field(UnitOfficeCodeCorr; UnitOfficeCodeCorr)
                {
                    Caption = 'Unit Office Code Correction';

                    trigger OnValidate()
                    begin
                        UnitOfficeCodeCorrOnPush;
                    end;
                }
                field(UnitOfficeCode; UnitOfficeCode)
                {
                    Caption = 'New Unit Office Code';
                    Enabled = UnitOfficeCodeEnable;
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
                }
                field(PaidToCorr; PaidToCorr)
                {
                    Caption = 'Paid To Code Correction';

                    trigger OnValidate()
                    begin
                        PaidToCorrOnPush;
                    end;
                }
                field(ReceivedFrom; ReceivedFrom)
                {
                    Caption = 'Paid To';
                    Enabled = ReceivedFromEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Vendor.RESET;
                        IF PAGE.RUNMODAL(PAGE::"Vendor List", Vendor) = ACTION::LookupOK THEN BEGIN
                            ReceivedFrom := Vendor."No.";
                            ReceivedFromName := Vendor.Name;
                            Vendor.GET(ReceivedFrom);
                            IF Vendor."BBG Status" = Vendor."BBG Status"::Inactive THEN BEGIN
                                ReceivedFrom := '';
                                ReceivedFromName := '';
                                ERROR('Inactive');
                            END;
                        END ELSE
                            EXIT(FALSE);
                    end;

                    trigger OnValidate()
                    begin
                        Vendor.RESET;
                        IF Vendor.GET(ReceivedFrom) THEN BEGIN
                            IF Vendor."BBG Status" = Vendor."BBG Status"::Inactive THEN BEGIN
                                ReceivedFrom := '';
                                ERROR('Inactive');
                            END;
                            ReceivedFromName := Vendor.Name;
                        END ELSE
                            ReceivedFromName := '';
                    end;
                }
                field(ReceivedFromName; ReceivedFromName)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        ReceivedFromEnable := TRUE;
        UnitOfficeCodeEnable := TRUE;
    end;

    trigger OnOpenPage()
    begin
        CurrPAGEUpdateControl;
    end;

    var
        UnitOfficeCodeCorr: Boolean;
        UnitOfficeCode: Code[20];
        PaidToCorr: Boolean;
        ReceivedFrom: Code[20];
        PostedDocNo: Code[20];
        Vendor: Record Vendor;
        Customer: Record Customer;
        ReceivedFromName: Text[50];

        UnitOfficeCodeEnable: Boolean;

        ReceivedFromEnable: Boolean;


    procedure CurrPAGEUpdateControl()
    begin
        UnitOfficeCodeEnable := UnitOfficeCodeCorr;
        ReceivedFromEnable := PaidToCorr;
    end;

    local procedure UnitOfficeCodeCorrOnPush()
    begin
        CurrPAGEUpdateControl;
    end;

    local procedure PaidToCorrOnPush()
    begin
        CurrPAGEUpdateControl;
    end;
}

