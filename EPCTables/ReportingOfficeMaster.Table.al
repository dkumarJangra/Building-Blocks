table 50045 "Reporting Office Master"
{
    DataPerCompany = false;

    fields
    {
        field(1; "Cluster Code"; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Mobile Cluster Name" := "Cluster Code";
            end;
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(3; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(4; Sequence; Integer)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(5; "Mobile Cluster Name"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Mobile State Name"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Mobile Cluster Sequence"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(8; "Mobile State Id"; Integer)
        {
            DataClassification = ToBeClassified;
            TableRelation = "Cluster State Master";

            trigger OnValidate()
            begin
                IF "Mobile State Id" <> 0 THEN BEGIN
                    ClusterStateMaster.RESET;
                    IF ClusterStateMaster.GET("Mobile State Id") THEN
                        "Mobile State Name" := ClusterStateMaster."State Name";
                    ClusterMaster.RESET;
                    ClusterMaster.SETCURRENTKEY("Mobile State Id", "Mobile Cluster Sequence");
                    ClusterMaster.SETRANGE("Mobile State Id", "Mobile State Id");
                    ClusterMaster.SETFILTER("Mobile Cluster Sequence", '>%1', 0);
                    IF ClusterMaster.FINDLAST THEN
                        "Mobile Cluster Sequence" := ClusterMaster."Mobile Cluster Sequence" + 1
                    ELSE
                        "Mobile Cluster Sequence" := 1;
                END ELSE
                    "Mobile Cluster Sequence" := 0;
            end;
        }
        field(9; "Region Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'Not in use 070824 now data come from new cluster master';
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
    }

    keys
    {
        key(Key1; "Cluster Code")
        {
            Clustered = true;
        }
        key(Key2; Sequence)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Status, Status::Open);
    end;

    var
        ClusterMaster: Record "Reporting Office Master";
        ClusterStateMaster: Record "Cluster State Master";
}

