xmlport 50558 "Update GLEntry Cheque No."
{
    Format = VariableText;
    Permissions = tabledata "G/L Entry" = RM;
    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Integer';
                textelement(EntryNo)
                {
                }
                textelement(CheueNo)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    IF UserId <> 'BCUSER' then
                        Error('Contact Admin');
                    SLNo := SLNo + 1;
                    IF SLNo > 1 THEN BEGIN
                        IF CheueNo <> '' THEN BEGIN
                            Evaluate(EntryNo1, EntryNo);
                            GLEntry.RESET;
                            GLEntry.SetRange("Entry No.", EntryNo1);
                            IF GLEntry.FindFirst() then begin
                                GLEntry."BBG Cheque No." := CheueNo;
                                GLEntry.Modify;
                            END;
                        end;

                    END;
                end;


            }
        }
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

    trigger OnPostXmlPort()
    begin
        MESSAGE('%1', 'Process Done');
    end;

    var

        GLEntry: Record "G/L Entry";
        SLNo: Integer;
        EntryNo1: Integer;
}

