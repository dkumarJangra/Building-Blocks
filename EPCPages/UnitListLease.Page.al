page 97837 "Unit List - Lease"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Item;
    SourceTableView = SORTING("No.")
                      ORDER(Ascending)
                      WHERE("Property Unit" = FILTER(true),
                            "Lease Blocked" = CONST(false));
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            field(PropertyStatus; SalesPropertyStatus)
            {
                Caption = 'Sales Property Status';
                Visible = PropertyStatusVisible;

                trigger OnValidate()
                begin
                    FilterPropertyUnits;
                    //CurrPAGE.UPDATECONTROLS;
                    SalesPropertyStatusOnAfterVali;
                end;
            }
            field(LegendLbl1; 'Lease Booked')
            {
                Caption = 'Sold';
                Editable = false;
                Style = Strong;
                StyleExpr = TRUE;
            }
            repeater(Group)
            {
                Editable = false;
                field(NoC; Rec."No.")
                {
                    Editable = NoCEditable;
                    Lookup = false;
                    Visible = NoCVisible;
                }
                field("Sales Blocked"; Rec."Sales Blocked")
                {
                    Editable = "Sales BlockedEditable";
                    Visible = "Sales BlockedVisible";
                }
                field("Lease Blocked"; Rec."Lease Blocked")
                {
                    Editable = "Lease BlockedEditable";
                    Visible = "Lease BlockedVisible";
                }
                field(LeaseBooked; LeaseBooked)
                {
                    Caption = 'Lease Booked';
                    Editable = false;
                }
                field("Project Code"; Rec."Project Code")
                {
                    Editable = "Project CodeEditable";
                    Visible = "Project CodeVisible";
                }
                field("Sub Project Code"; Rec."Sub Project Code")
                {
                    Editable = "Sub Project CodeEditable";
                    Visible = "Sub Project CodeVisible";
                }
                field("Floor No."; Rec."Floor No.")
                {
                    Editable = "Floor No.Editable";
                    Visible = "Floor No.Visible";
                }
                field(Type; Rec.Type)
                {
                    Editable = TypeEditable;
                    Visible = TypeVisible;
                }
                field("Saleable Area (sq ft)"; Rec."Saleable Area (sq ft)")
                {
                    Editable = "Saleable Area (sq ft)Editable";
                    Visible = "Saleable Area (sq ft)Visible";
                }
                field("Carpet Area (sq ft)"; Rec."Carpet Area (sq ft)")
                {
                    Editable = "Carpet Area (sq ft)Editable";
                    Visible = "Carpet Area (sq ft)Visible";
                }
                field("Efficiency (%)"; Rec."Efficiency (%)")
                {
                    Editable = "Efficiency (%)Editable";
                    Visible = "Efficiency (%)Visible";
                }
                field("Job No."; Rec."Job No.")
                {
                    Editable = "Job No.Editable";
                    Visible = "Job No.Visible";
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Unit)
            {
                Caption = 'Unit';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Associate Advance Payment Form";
                    RunPageLink = "Document No." = FIELD("No.");
                    // Field64 = FIELD("Date Filter"),
                    // Field65 = FIELD("Global Dimension 1 Filter"),
                    // Field66 = FIELD("Global Dimension 2 Filter"),
                    // Field67 = FIELD("Location Filter"),
                    // Field89 = FIELD("Drop Shipment Filter");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
        area(processing)
        {
            action(History)
            {
                Caption = 'History';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'History';

                trigger OnAction()
                begin
                    Rec.HistoryFunction(-50128, '');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        SetSecurity(FALSE);
        NoOnFormat;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        SetSecurity(FALSE);
        EXIT(Rec.FIND(Which));
    end;

    trigger OnInit()
    begin
        "Floor No.Editable" := TRUE;
        "Sub Project CodeEditable" := TRUE;
        "Project CodeEditable" := TRUE;
        TypeEditable := TRUE;
        "Efficiency (%)Editable" := TRUE;
        "Carpet Area (sq ft)Editable" := TRUE;
        "Saleable Area (sq ft)Editable" := TRUE;
        "Job No.Editable" := TRUE;
        NoCEditable := TRUE;
        "Floor No.Visible" := TRUE;
        "Sub Project CodeVisible" := TRUE;
        "Project CodeVisible" := TRUE;
        TypeVisible := TRUE;
        "Lease BlockedVisible" := TRUE;
        "Sales BlockedVisible" := TRUE;
        "Efficiency (%)Visible" := TRUE;
        "Carpet Area (sq ft)Visible" := TRUE;
        "Saleable Area (sq ft)Visible" := TRUE;
        NoCVisible := TRUE;
        PropertyStatusVisible := TRUE;
    end;

    trigger OnOpenPage()
    begin
        SalesPropertyStatus := SalesPropertyStatus::Both;
        IF CurrPage.LOOKUPMODE THEN BEGIN
            SalesPropertyStatus := SalesPropertyStatus::Available;
            PropertyStatusVisible := FALSE;
        END
        ELSE BEGIN
            ItemRec.COPYFILTERS(Rec);
            FilterPropertyUnits;
        END
        ;

        SetSecurity(TRUE);
    end;

    var
        SalesBooked: Boolean;
        SalesPropertyStatus: Option Booked,Available,Both;
        ItemRec: Record Item;
        LeaseBooked: Boolean;

        PropertyStatusVisible: Boolean;

        NoCEmphasize: Boolean;

        NoCVisible: Boolean;

        "Job No.Visible": Boolean;

        "Saleable Area (sq ft)Visible": Boolean;

        "Carpet Area (sq ft)Visible": Boolean;

        "Efficiency (%)Visible": Boolean;

        "Sales BlockedVisible": Boolean;

        "Lease BlockedVisible": Boolean;

        TypeVisible: Boolean;

        "Project CodeVisible": Boolean;

        "Sub Project CodeVisible": Boolean;

        "Floor No.Visible": Boolean;

        NoCEditable: Boolean;

        "Job No.Editable": Boolean;

        "Saleable Area (sq ft)Editable": Boolean;

        "Carpet Area (sq ft)Editable": Boolean;

        "Efficiency (%)Editable": Boolean;

        "Sales BlockedEditable": Boolean;

        "Lease BlockedEditable": Boolean;

        TypeEditable: Boolean;

        "Project CodeEditable": Boolean;

        "Sub Project CodeEditable": Boolean;

        "Floor No.Editable": Boolean;


    procedure FilterPropertyUnits()
    begin
        Rec.RESET;
        Rec.SETRANGE("Property Unit", TRUE);
        Rec.COPYFILTERS(ItemRec);
        IF Rec.FIND('-') THEN
            REPEAT

                //CALCFIELDS("Purchase Order Count","Sales Order Count","Lease Order Count");
                IF SalesPropertyStatus = SalesPropertyStatus::Both THEN
                    Rec.MARK(TRUE);

            UNTIL Rec.NEXT = 0;
        Rec.MARKEDONLY(TRUE);
    end;

    local procedure SetSecurity(OpenPAGE: Boolean)
    begin
        // ALLE MM Code Commented
        /*
        IF OpenPAGE THEN BEGIN
          IF NOT TableSecurity.GetTableSecurity(PAGE::"Unit List - Lease") THEN
            EXIT;
        
          IF TableSecurity."Form General Permission" = TableSecurity."Form General Permission"::"1" THEN
            CurrPage.EDITABLE(FALSE);
        
          TableSecurity.SetFieldFilters(Rec);
        END ELSE
          IF TableSecurity."Security for Form No." = 0 THEN
            EXIT;
        
        IF NoCEditable THEN
          NoCEditable := TableSecurity."No." = 0;
        IF TableSecurity."No." IN [2,5] THEN BEGIN
          NoCVisible := FALSE;
          SETRANGE("No.");
        END;
        IF "Job No.Editable" THEN
          "Job No.Editable" := TableSecurity."Job No." = 0;
        IF TableSecurity."Job No." IN [2,5] THEN BEGIN
          "Job No.Visible" := FALSE;
          SETRANGE("Job No.");
        END;
        IF "Saleable Area (sq ft)Editable" THEN
          "Saleable Area (sq ft)Editable" := TableSecurity."Saleable Area (sq ft)" = 0;
        IF TableSecurity."Saleable Area (sq ft)" IN [2,5] THEN BEGIN
          "Saleable Area (sq ft)Visible" := FALSE;
          SETRANGE("Saleable Area (sq ft)");
        END;
        IF "Carpet Area (sq ft)Editable" THEN
          "Carpet Area (sq ft)Editable" := TableSecurity."Carpet Area (sq ft)" = 0;
        IF TableSecurity."Carpet Area (sq ft)" IN [2,5] THEN BEGIN
          "Carpet Area (sq ft)Visible" := FALSE;
          SETRANGE("Carpet Area (sq ft)");
        END;
        IF "Efficiency (%)Editable" THEN
          "Efficiency (%)Editable" := TableSecurity."Efficiency (%)" = 0;
        IF TableSecurity."Efficiency (%)" IN [2,5] THEN BEGIN
          "Efficiency (%)Visible" := FALSE;
          SETRANGE("Efficiency (%)");
        END;
        IF "Sales BlockedEditable" THEN
          "Sales BlockedEditable" := TableSecurity."Sales Blocked" = 0;
        IF TableSecurity."Sales Blocked" IN [2,5] THEN BEGIN
          "Sales BlockedVisible" := FALSE;
          SETRANGE("Sales Blocked");
        END;
        IF "Lease BlockedEditable" THEN
          "Lease BlockedEditable" := TableSecurity."Lease Blocked" = 0;
        IF TableSecurity."Lease Blocked" IN [2,5] THEN BEGIN
          "Lease BlockedVisible" := FALSE;
          SETRANGE("Lease Blocked");
        END;
        IF TypeEditable THEN
          TypeEditable := TableSecurity.Type = 0;
        IF TableSecurity.Type IN [2,5] THEN BEGIN
          TypeVisible := FALSE;
          SETRANGE(Type);
        END;
        IF "Project CodeEditable" THEN
          "Project CodeEditable" := TableSecurity."Project Code" = 0;
        IF TableSecurity."Project Code" IN [2,5] THEN BEGIN
          "Project CodeVisible" := FALSE;
          SETRANGE("Project Code");
        END;
        IF "Sub Project CodeEditable" THEN
          "Sub Project CodeEditable" := TableSecurity."Sub Project Code" = 0;
        IF TableSecurity."Sub Project Code" IN [2,5] THEN BEGIN
          "Sub Project CodeVisible" := FALSE;
          SETRANGE("Sub Project Code");
        END;
        IF "Floor No.Editable" THEN
          "Floor No.Editable" := TableSecurity."Floor No." = 0;
        IF TableSecurity."Floor No." IN [2,5] THEN BEGIN
          "Floor No.Visible" := FALSE;
          SETRANGE("Floor No.");
        END;
        */
        // ALLE MM Code Commented

    end;

    local procedure SalesPropertyStatusOnAfterVali()
    begin
        CurrPage.UPDATE(FALSE);
    end;

    local procedure NoOnFormat()
    begin

        IF (Rec."Sales Blocked" = TRUE) AND (Rec."Lease Blocked" = FALSE) THEN BEGIN
            NoCEmphasize := TRUE;
        END

        ELSE IF (Rec."Sales Blocked" = FALSE) AND (Rec."Lease Blocked" = FALSE) AND (LeaseBooked = FALSE) THEN BEGIN
            NoCEmphasize := TRUE;
        END

        ELSE BEGIN
            NoCEmphasize := FALSE;
        END;
    end;
}

