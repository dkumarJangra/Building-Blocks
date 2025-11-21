page 97951 GLSubForm
{
    // //NDALLE 240108 Code to Update Global Dimension in GL objects

    Editable = false;
    PageType = Card;
    SourceTable = "G/L Entry";
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("G/L Account No."; Rec."G/L Account No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        OnActivatePAGE;
    end;

    var
        "DocNo.": Code[20];
        PostingDate: Date;
        CalledFrom: Integer;
        GlobalEntry1: Integer;
        GlobalEntry2: Integer;


    procedure SetEntryNo(DocNoP: Code[20]; PostingDateP: Date; Called: Integer)
    begin
        "DocNo." := DocNoP;
        PostingDate := PostingDateP;
        CalledFrom := Called
    end;


    procedure SetEntries(Entry1: Integer; Entry2: Integer; Called: Integer)
    begin
        GlobalEntry1 := Entry1;
        GlobalEntry2 := Entry2;
        CalledFrom := Called;
    end;

    local procedure OnActivatePAGE()
    begin
        IF CalledFrom = 1 THEN BEGIN
            IF ("DocNo." <> '') AND (PostingDate <> 0D) THEN BEGIN
                Rec.SETRANGE("Document No.", "DocNo.");
                Rec.SETRANGE("Posting Date", PostingDate);
            END;
        END ELSE
            IF CalledFrom = 2 THEN BEGIN
                IF (GlobalEntry1 <> 0) AND (GlobalEntry2 <> 0) THEN BEGIN
                    Rec.SETFILTER("Entry No.", '%1|%2', GlobalEntry1, GlobalEntry2);
                END;
            END;
        CurrPage.UPDATE(TRUE);
        Rec.FILTERGROUP(3);
    end;
}

