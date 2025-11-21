page 97760 "FA Purchase Request Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Purchase Request Line";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Send for Enquiry"; Rec."Send for Enquiry")
                {
                }
                field(Type; Rec.Type)
                {
                    Editable = TypeEditable;
                    Visible = false;
                }
                field("No."; Rec."No.")
                {
                    Editable = "No.Editable";
                    Visible = false;
                }
                field("Job No."; Rec."Job No.")
                {
                    Visible = false;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    Editable = IsLineDescriptionEditable;
                }
                field("Description 2"; Rec."Description 2")
                {
                    Editable = IsLineDescriptionEditable;
                }
                field("Description 3"; Rec."Description 3")
                {
                    Editable = IsLineDescriptionEditable;
                }
                field("Description 4"; Rec."Description 4")
                {
                    Editable = IsLineDescriptionEditable;
                }
                field("Current Stock"; Rec."Current Stock")
                {
                    Visible = false;
                }
                field("Location code"; Rec."Location code")
                {
                    Editable = true;
                    Visible = false;
                }
                field("Indent UOM"; Rec."Indent UOM")
                {
                    Editable = "Indent UOMEditable";
                }
                field("Indented Quantity"; Rec."Indented Quantity")
                {
                    Caption = 'Indented Qty';
                    Editable = "Indented QuantityEditable";
                }
                field("Approved Qty"; Rec."Approved Qty")
                {
                    Caption = 'Approved Qty';
                }
                field("Direct Unit Cost"; Rec."Direct Unit Cost")
                {
                    Editable = "Direct Unit CostEditable";
                }
                field(Amount; Rec.Amount)
                {
                    Editable = AmountEditable;
                }
                field("Quantity Base"; Rec."Quantity Base")
                {
                }
                field("Qty Per Unit Of Measure"; Rec."Qty Per Unit Of Measure")
                {
                }
                field("Purch Qty Per Unit Of Measure"; Rec."Purch Qty Per Unit Of Measure")
                {
                    Visible = false;
                }
                field("Quantity (Purchase UOM)"; Rec."Quantity (Purchase UOM)")
                {
                    Visible = false;
                }
                field("Outstanding PO Amount"; Rec."Outstanding PO Amount")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = ShortcutDimension1CodeEditable;
                    Visible = true;

                    trigger OnValidate()
                    begin
                        IF Rec."Shortcut Dimension 1 Code" = 'DUMMY' THEN
                            ERROR('You can not select DUMMY cost center..');

                        dimvalue.RESET;
                        dimvalue.SETRANGE(dimvalue."Dimension Code", 'COST CENTER');
                        dimvalue.SETRANGE(dimvalue.Code, Rec."Shortcut Dimension 1 Code");
                        IF dimvalue.FIND('-') THEN
                            IF dimvalue.Blocked = TRUE THEN
                                ERROR('This cost center is blocked....');
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CurrPage.EDITABLE(Rec.Approved);
        IF IndHdr.GET(Rec."Document Type", Rec."Document No.") THEN;
        //IsLineDescriptionEditable :=LineDescriptionEditable;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        IndHdr.GET(Rec."Document Type", Rec."Document No.");
        AccessControl.RESET;
        AccessControl.SETRANGE(AccessControl."User Security ID", ClientManagement.GetWindowID);
        AccessControl.SETFILTER("Role ID", 'SUPERPO');
        IF NOT AccessControl.FIND('-') THEN BEGIN
            IndHdr.TESTFIELD("Sent for Approval", FALSE);
            IndHdr.TESTFIELD(Approved, FALSE);
        END;
    end;

    trigger OnInit()
    begin
        ShortcutDimension1CodeEditable := TRUE;
        "Direct Unit CostEditable" := TRUE;
        "Indented QuantityEditable" := TRUE;
        "Indent UOMEditable" := TRUE;
        "No.Editable" := TRUE;
        TypeEditable := TRUE;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        IndHdr.GET(Rec."Document Type", Rec."Document No.");

        AccessControl.RESET;
        AccessControl.SETRANGE(AccessControl."User Security ID", ClientManagement.GetWindowID);
        IF NOT AccessControl.FIND('-') THEN BEGIN
            IndHdr.TESTFIELD(Approved, FALSE);
            IndHdr.TESTFIELD("Sent for Approval", FALSE);
        END;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IndHdr.GET(Rec."Document Type", Rec."Document No.");
        AccessControl.RESET;
        AccessControl.SETRANGE(AccessControl."User Security ID", ClientManagement.GetWindowID);
        IF NOT AccessControl.FIND('-') THEN
            IndHdr.TESTFIELD(Approved, FALSE);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        TempIndentLine := xRec;
        Rec.INIT;
        Rec.Type := xRec.Type;
    end;

    var
        TempIndentLine: Record "Purchase Request Line";
        IndHdr: Record "Purchase Request Header";
        dimvalue: Record "Dimension Value";
        AccessControl: Record "Access Control";

        TypeEditable: Boolean;

        "No.Editable": Boolean;

        "Indent UOMEditable": Boolean;

        "Indented QuantityEditable": Boolean;

        "Direct Unit CostEditable": Boolean;

        AmountEditable: Boolean;

        ShortcutDimension1CodeEditable: Boolean;
        ClientManagement: Codeunit "Client Management";
        IsLineDescriptionEditable: Boolean;
}

