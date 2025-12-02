xmlport 50102 "Project MIS Data Upload"
{
    Caption = 'Project MIS Detailed Data Upload';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'Integer';

                textelement(UnitMasterCode)
                {
                }
                textelement(TypeofDeed)
                {
                }
                textelement(DeedNo)
                {
                }
                textelement(PurchasingLLPName)
                {
                }

                trigger OnAfterInsertRecord()
                begin
                    SNo := SNo + 1;
                    IF SNo > 1 THEN BEGIN
                        UnitMaster.RESET;
                        UnitMaster.SetRange("No.", UnitMasterCode);
                        If UnitMaster.FindFirst() then begin
                            IF TypeofDeed = 'AGPA' then
                                UnitMaster."Type Of Deed" := UnitMaster."Type Of Deed"::AGPA
                            ELSE IF TypeofDeed = 'AOS' then
                                UnitMaster."Type Of Deed" := UnitMaster."Type Of Deed"::AOS
                            ELSE IF TypeofDeed = 'Sale Deed' then
                                UnitMaster."Type Of Deed" := UnitMaster."Type Of Deed"::"Sale Deed";

                            UnitMaster."Deed No" := DeedNo;
                            UnitMaster."Purchasing LLP Name" := PurchasingLLPName;
                            UnitMaster.Modify;
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

        SNo: Integer;
        UnitMaster: Record "Unit Master";
}

