report 50126 "Land Appl. Management Proxy"
{
    // version Done

    DefaultLayout = RDLC;
    RDLCLayout = './Reports/Land Appl. Management Proxy.rdl';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        OfficeVersion: Integer;

    local procedure InitOfficeVersion()
    begin
    end;

    procedure IsEditAppl(FileExt: Text[10]): Integer
    begin
    end;

    procedure Close(ApplNo: Integer): Boolean
    var
        Ok: Boolean;
    begin
    end;

    procedure Load(ApplNo: Integer; var DocumentRec: Record "Land Document Attachment"; Caption: Text[128]; ViewOnly: Boolean)
    begin
    end;

    procedure ReplaceText(ApplNo: Integer; FindValue: Text[250]; ReplaceValue: Text[250])
    var
        ReplaceAll: Variant;
    begin
    end;

    procedure InsertText(ApplNo: Integer; Value: Text[250])
    begin
    end;
}

