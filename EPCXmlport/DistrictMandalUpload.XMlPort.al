xmlport 50201 "District and Mandal uploader"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'District_Mandalupload';
                textelement(StateCode)
                {
                }
                textelement(DistrictCode)
                {
                }
                textelement(MandalCode)
                {
                }
                textelement(VillageCode)
                {
                }


                trigger OnPreXmlItem()
                begin

                    MESSAGE('Batch Run Successfully');
                end;

                trigger OnAfterInsertRecord()
                begin
                    ValidateVariable();
                    DistrictTb.RESET;
                    IF NOT DistrictTb.get(DistrictCode1, StateCode1) THEN begin
                        NewDistrictTb.init;
                        NewDistrictTb.Code := DistrictCode1;
                        NewDistrictTb."State Code" := StateCode1;
                        NewDistrictTb.Validate("State Code", StateCode1);
                        NewDistrictTb.insert;
                    end;

                    MandalTb.RESET;
                    IF NOT MandalTb.GET(MandalCode1, StateCode1, DistrictCode1) THEN begin
                        NewMandalTb.Init();
                        NewMandalTb.Code := MandalCode1;
                        NewMandalTb."State Code" := StateCode1;
                        NewMandalTb."District Code" := DistrictCode1;
                        NewMandalTb.Validate("State Code", StateCode1);
                        NewMandalTb.insert;
                    end;

                    VillageTb.RESET;
                    IF NOT VillageTb.GET(VillageCode1, StateCode1, DistrictCode1, MandalCode1) THEN begin
                        NewVillageTb.Init();
                        NewVillageTb.Code := VillageCode1;
                        NewVillageTb."Mandal Code" := MandalCode1;
                        NewVillageTb."State Code" := StateCode1;
                        NewVillageTb."District Code" := DistrictCode1;
                        NewVillageTb.Validate("State Code", StateCode1);
                        NewVillageTb.insert;
                    end;


                    // MESSAGE('Uploaded Successfully %1',SrcCode1);
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

    var

        MandalTb: Record "Mandal Details";
        NewMandalTb: Record "Mandal Details";
        DistrictTb: Record "District Details";
        NewDistrictTb: Record "District Details";
        VillageTb: Record "Village Details";
        NewVillageTb: Record "Village Details";
        StateCode1: code[10];
        DistrictCode1: Code[50];
        MandalCode1: code[50];
        VillageCode1: code[50];



    local procedure ValidateVariable()
    begin
        EVALUATE(StateCode1, StateCode);
        EVALUATE(DistrictCode1, DistrictCode);
        EVALUATE(MandalCode1, MandalCode);
        Evaluate(VillageCode1, VillageCode);

    end;
}

