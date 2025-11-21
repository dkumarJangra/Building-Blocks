page 97844 "Property Availability Matrix"
{
    PageType = Card;
    SourceTable = "Dimension Code Buffer";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
    }

    actions
    {
    }

    var
        ShopNo: Code[250];
        PriceGrpNo: Code[20];
        PPG: Record "Document Master";
        ItemRec: Record "Unit Master";
        DimBuf: Record "Dimension Code Buffer" temporary;
        TempDimBuf: Record "Dimension Code Buffer" temporary;
        SalesBooked: Boolean;
        LeaseBooked: Boolean;
        NotExist: Boolean;
        SuperArea: Decimal;
        ShowArea: Boolean;
        ShowCustomer: Boolean;
        ShowBroker: Boolean;
        SaleHdr: Record "Sales Header";
        OnlySales: Integer;
        OnlyLease: Integer;
        BothSaleLease: Integer;
        Available: Integer;
        TotCount: Integer;
        Vendor: Record Vendor;
        OnlySalesB: Boolean;
        OnlyLeaseB: Boolean;
        BothSaleLeaseB: Boolean;
        AvailableB: Boolean;
        OnlySalesA: Decimal;
        OnlyLeaseA: Decimal;
        BothSaleLeaseA: Decimal;
        AvailableA: Decimal;
        TotArea: Decimal;
        ProjectCodeFilter: Code[20];
        Job: Record Job;


    procedure InitMatrix()
    begin
    end;


    procedure PreInit()
    begin
    end;


    procedure SetProjectFilter()
    begin
    end;
}

