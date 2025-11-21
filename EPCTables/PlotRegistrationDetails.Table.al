table 60675 "Plot Registration Details"
{
    Caption = 'Plot Registration Details';
    DataPerCompany = false;

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
            NotBlank = true;
        }
        field(2; "Customer No."; Code[20])
        {
            Editable = false;
            TableRelation = Customer;
        }
        field(3; "Introducer Code"; Code[20])
        {
            Caption = 'IBA Code';
            Editable = false;
            TableRelation = Vendor WHERE("BBG Vendor Category" = FILTER("IBA(Associates)"),
                                          "BBG Status" = FILTER(Active | Provisional));
        }
        field(4; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(5; "User Code"; Code[50])
        {
            Editable = false;
            TableRelation = User;
        }
        field(6; Amount; Decimal)
        {
            Editable = false;
        }
        field(7; "Posting Date"; Date)
        {
            Editable = false;
        }
        field(8; "Document Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(9; "Amount Received"; Decimal)
        {
            Caption = 'Amount Received';
            Editable = false;
        }
        field(10; "Company Name"; Text[30])
        {
            Editable = false;
            TableRelation = Company;
        }
        field(11; "Unit Payment Plan"; Code[20])
        {
            Editable = false;
            TableRelation = "App. Charge Code".Code WHERE("Sub Payment Plan" = FILTER(true));
        }
        field(12; "Unit Plan Name"; Text[50])
        {
            Editable = false;
        }
        field(13; "Min. Allotment Amount"; Decimal)
        {
            Editable = false;
        }
        field(14; "Member Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Unit Code"; Code[20])
        {
            Editable = false;
        }
        field(16; "Application Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,,,,,,,,,,,,Registered,Cancelled,Vacate,Forfeit';
            OptionMembers = Open,Documented,"Cash Dispute","Documentation Dispute",Verified,Active,"Death Claim","Maturity Claim","Maturity Dispute",Matured,Dispute,"Blocked (Loan)",Registered,Cancelled,Vacate,Forfeit;
        }
        field(17; "Form32 Thumb impression form-1"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(1);
                UserSetup.RESET;
                UserSetup.GET(USERID);
                ResponsibilityCenter.RESET;
                IF ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter") THEN;
                IF "Form32 Thumb impression form-1" THEN BEGIN
                    "Form32 User Id" := USERID;
                    "Form 32 Responsibility Center" := ResponsibilityCenter.Name;
                    "Form32 Date Time" := CURRENTDATETIME;
                END ELSE BEGIN
                    "Form32 User Id" := '';
                    "Form 32 Responsibility Center" := '';
                    "Form32 Date Time" := 0DT;
                END;
            end;
        }
        field(18; "Plot Registration Req. form-1"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(1);
                UserSetup.RESET;
                UserSetup.GET(USERID);
                ResponsibilityCenter.RESET;
                IF ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter") THEN;
                IF "Plot Registration Req. form-1" THEN BEGIN
                    "Plot Reg User Id" := USERID;
                    "Plot Reg. Resp Center" := ResponsibilityCenter.Name;
                    "Plot Reg Date Time" := CURRENTDATETIME;
                END ELSE BEGIN
                    "Plot Reg User Id" := '';
                    "Plot Reg. Resp Center" := '';
                    "Plot Reg Date Time" := 0DT;
                END;
            end;
        }
        field(19; "Aadhar card details -1"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(1);
                UserSetup.RESET;
                UserSetup.GET(USERID);
                ResponsibilityCenter.RESET;
                IF ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter") THEN;
                IF "Aadhar card details -1" THEN BEGIN
                    "AAdhar Card User ID" := USERID;
                    "AAdhar Card Resp Center" := ResponsibilityCenter.Name;
                    "AAdhar Card Date Time" := CURRENTDATETIME;
                END ELSE BEGIN
                    "AAdhar Card User ID" := '';
                    "AAdhar Card Resp Center" := '';
                    "AAdhar Card Date Time" := 0DT;
                END;
            end;
        }
        field(20; "PAN card details -1"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(1);
                UserSetup.RESET;
                UserSetup.GET(USERID);
                ResponsibilityCenter.RESET;
                IF ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter") THEN;
                IF "PAN card details -1" THEN BEGIN
                    "PAN User Id" := USERID;
                    "PAN Resp Center" := ResponsibilityCenter.Name;
                    "PAN Date Time" := CURRENTDATETIME;
                END ELSE BEGIN
                    "PAN User Id" := '';
                    "PAN Resp Center" := '';
                    "PAN Date Time" := 0DT;
                END;
            end;
        }
        field(21; "Photo - 1"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(1);
                UserSetup.RESET;
                UserSetup.GET(USERID);
                ResponsibilityCenter.RESET;
                IF ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter") THEN;
                IF "Photo - 1" THEN BEGIN
                    "Photo User Id" := USERID;
                    "Photo Resp Center" := ResponsibilityCenter.Name;
                    "Photo Date Time" := CURRENTDATETIME;
                END ELSE BEGIN
                    "Photo User Id" := '';
                    "Photo Resp Center" := '';
                    "Photo Date Time" := 0DT;
                END;
            end;
        }
        field(22; "Form32 Thumb imp. form -2"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(2);
            end;
        }
        field(23; "Plot Registration Req. form-2"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(2);
            end;
        }
        field(24; "Aadhar card details -2"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(2);
            end;
        }
        field(25; "PAN card details -2"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(2);
            end;
        }
        field(26; "Photo -2"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(2);
            end;
        }
        field(27; Payment; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(3);
            end;
        }
        field(28; "Customer info"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
                UserSetup.RESET;
                UserSetup.GET(USERID);
                ResponsibilityCenter.RESET;
                IF ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter") THEN;
                IF "Customer info" THEN BEGIN
                    "Customer Info USERID" := USERID;
                    "Customer Info RespCenter" := ResponsibilityCenter.Name;
                    "Customer Info Date Time" := CURRENTDATETIME;
                END ELSE BEGIN
                    "Customer Info USERID" := '';
                    "Customer Info RespCenter" := '';
                    "Customer Info Date Time" := 0DT;
                END;

                NewConfirmedOrder.RESET;
                NewConfirmedOrder.GET("No.");
                v_Customer.RESET;
                v_Customer.GET("Customer No.");
                "Customer PAN No." := v_Customer."P.A.N. No.";
                "Customer Aadhar No." := v_Customer."BBG Aadhar No.";
            end;
        }
        field(29; "Organizational info"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
                UserSetup.RESET;
                UserSetup.GET(USERID);
                ResponsibilityCenter.RESET;
                IF ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter") THEN;
                IF "Organizational info" THEN BEGIN
                    "Org. info USERID" := USERID;
                    "Org. info RespCenter" := ResponsibilityCenter.Name;
                    "Org. info Date Time" := CURRENTDATETIME;
                END ELSE BEGIN
                    "Org. info USERID" := '';
                    "Org. info RespCenter" := '';
                    "Org. info Date Time" := 0DT;
                END;

                NewConfirmedOrder.RESET;
                NewConfirmedOrder.GET("No.");
                "LLP Name" := NewConfirmedOrder."Company Name";
                v_ComInfo.RESET;
                v_ComInfo.CHANGECOMPANY(NewConfirmedOrder."Company Name");
                v_ComInfo.GET;
                "LLP Address" := v_ComInfo.Address;
                "LLP Address 2" := v_ComInfo."Address 2";
            end;
        }
        field(30; "Project info"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
                UserSetup.RESET;
                UserSetup.GET(USERID);
                ResponsibilityCenter.RESET;
                IF ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter") THEN;
                IF "Project info" THEN BEGIN
                    "Proj. info USERID" := USERID;
                    "Proj. info RespCenter" := ResponsibilityCenter.Name;
                    "Proj. info Date Time" := CURRENTDATETIME;
                END ELSE BEGIN
                    "Proj. info USERID" := '';
                    "Proj. info RespCenter" := '';
                    "Proj. info Date Time" := 0DT;
                END;

                NewConfirmedOrder.RESET;
                NewConfirmedOrder.GET("No.");
                v_ResponsibilityCenter.RESET;
                v_ResponsibilityCenter.GET(NewConfirmedOrder."Shortcut Dimension 1 Code");
                "Project Name" := v_ResponsibilityCenter.Name;
                "Plot No." := NewConfirmedOrder."Unit Code";
                "Plot Extent" := NewConfirmedOrder."Saleable Area";
            end;
        }
        field(31; "Statutory info"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
                UserSetup.RESET;
                UserSetup.GET(USERID);
                ResponsibilityCenter.RESET;
                IF ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter") THEN;
                IF "Statutory info" THEN BEGIN
                    "Statury info USERID" := USERID;
                    "Statury info RespCenter" := ResponsibilityCenter.Name;
                    "Statury info Date Time" := CURRENTDATETIME;
                END ELSE BEGIN
                    "Statury info USERID" := '';
                    "Statury info RespCenter" := '';
                    "Statury info Date Time" := 0DT;
                END;
            end;
        }
        field(32; "Sale deed info etc."; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
                UserSetup.RESET;
                UserSetup.GET(USERID);
                ResponsibilityCenter.RESET;
                IF ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter") THEN;
                IF "Sale deed info etc." THEN BEGIN
                    "Sale Deed info USERID" := USERID;
                    "Sale Deed info RespCenter" := ResponsibilityCenter.Name;
                    "Sale Deed info Date Time" := CURRENTDATETIME;
                END ELSE BEGIN
                    "Sale Deed info USERID" := '';
                    "Sale Deed info RespCenter" := '';
                    "Sale Deed info Date Time" := 0DT;
                END;

                NewConfirmedOrder.RESET;
                NewConfirmedOrder.GET("No.");
                v_UnitMaster.RESET;
                v_UnitMaster.GET(NewConfirmedOrder."Unit Code");
                "Plot Dimension" := 'Size-East -' + FORMAT(v_UnitMaster."Size-East") + ', Size-West -' + FORMAT(v_UnitMaster."Size-West") + ', Size-North -' + FORMAT(v_UnitMaster."Size-North") + ', Size-South -' + FORMAT(v_UnitMaster."Size-South");
            end;
        }
        field(33; "Generation of Challan"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(5);
                UserSetup.RESET;
                UserSetup.GET(USERID);
                ResponsibilityCenter.RESET;
                IF ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter") THEN;
                IF "Generation of Challan" THEN BEGIN
                    "Gen of Challan USERID" := USERID;
                    "Gen of Challan RespCenter" := ResponsibilityCenter.Name;
                    "Gen of Challan Date Time" := CURRENTDATETIME;
                END ELSE BEGIN
                    "Gen of Challan USERID" := '';
                    "Gen of Challan RespCenter" := '';
                    "Gen of Challan Date Time" := 0DT;
                END;
            end;
        }
        field(34; "Doc send to SRO for Reg."; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(5);
                UserSetup.RESET;
                UserSetup.GET(USERID);
                ResponsibilityCenter.RESET;
                IF ResponsibilityCenter.GET(UserSetup."Purchase Resp. Ctr. Filter") THEN;
                IF "Doc send to SRO for Reg." THEN BEGIN
                    "Doc Send SRO USERID" := USERID;
                    "Doc Send SRO RespCenter" := ResponsibilityCenter.Name;
                    "Doc Send SRO Date Time" := CURRENTDATETIME;
                END ELSE BEGIN
                    "Doc Send SRO USERID" := '';
                    "Doc Send SRO RespCenter" := '';
                    "Doc Send SRO Date Time" := 0DT;
                END;
            end;
        }
        field(35; Registration; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(2);
            end;
        }
        field(36; "Registration No."; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
                UpdateFields('', 0D);
            end;
        }
        field(37; "Doc received from SRO"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
            end;
        }
        field(38; "Registration details in NAV"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(7);
            end;
        }
        field(39; "Reg. Doc. Customer Receipt"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(7);
            end;
        }
        field(40; "Send for Approval (Stage-1)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(1);
                IF "Send for Approval (Stage-1)" THEN BEGIN
                    "Sender USER Id (Stage-1)" := USERID;
                    "Send for Appl.Date(Stage-1)" := TODAY;
                END ELSE BEGIN
                    "Sender USER Id (Stage-1)" := '';
                    "Send for Appl.Date(Stage-1)" := 0D;
                END;
            end;
        }
        field(41; "Sender USER Id (Stage-1)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                CheckStagePermission(1);
            end;
        }
        field(42; "Approved By (Stage-1)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(43; "Approved (Stage-1)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(1);
                IF "Document Date" <> 0D THEN BEGIN
                    "Ageing Days 1" := FORMAT(TODAY - "Document Date") + 'D';
                END;
                IF "Approved (Stage-1)" THEN BEGIN
                    "Approved By (Stage-1)" := USERID;
                    "Approved Date (Stage-1)" := TODAY;
                END ELSE BEGIN
                    "Approved By (Stage-1)" := '';
                    "Approved Date (Stage-1)" := 0D;
                END;
            end;
        }
        field(44; "Approved Date (Stage-1)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(45; "Send for Appl.Date(Stage-1)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                CheckStagePermission(1);
            end;
        }
        field(46; "Send for Approval (Stage-2)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(2);
                NewApplicationPaymentEntry.RESET;
                NewApplicationPaymentEntry.SETRANGE("Document No.", "No.");
                NewApplicationPaymentEntry.SETFILTER("Cheque Status", '%1|%2', NewApplicationPaymentEntry."Cheque Status"::" ");
                IF NewApplicationPaymentEntry.FINDFIRST THEN
                    ERROR('Bank Reco pending against Cheque No.' + FORMAT(NewApplicationPaymentEntry."Cheque No./ Transaction No."));

                NewConfirmedOrder.RESET;
                NewConfirmedOrder.GET("No.");
                NewConfirmedOrder.CALCFIELDS("Total Received Amount");
                IF NewConfirmedOrder.Amount > NewConfirmedOrder."Total Received Amount" THEN
                    ERROR('Amount Pending');


                IF "Send for Approval (Stage-2)" THEN BEGIN
                    "Sender USER Id (Stage-2)" := USERID;
                    "Send for Appl.Date(Stage-2)" := TODAY;
                END ELSE BEGIN
                    "Sender USER Id (Stage-2)" := '';
                    "Send for Appl.Date(Stage-2)" := 0D;
                END;
            end;
        }
        field(47; "Sender USER Id (Stage-2)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(48; "Approved By (Stage-2)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(49; "Approved (Stage-2)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(2);
                IF "Approved Date (Stage-1)" <> 0D THEN BEGIN
                    "Ageing Days 2" := FORMAT(TODAY - "Approved Date (Stage-1)") + 'D';
                END;
                IF "Approved (Stage-2)" THEN BEGIN
                    "Approved By (Stage-2)" := USERID;
                    "Approved Date (Stage-2)" := TODAY;
                END ELSE BEGIN
                    "Approved By (Stage-2)" := '';
                    "Approved Date (Stage-2)" := 0D;
                END;
            end;
        }
        field(50; "Approved Date (Stage-2)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51; "Send for Appl.Date(Stage-2)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52; "Send for Approval (Stage-3)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(3);
                IF "Send for Approval (Stage-3)" THEN BEGIN
                    "Sender USER Id (Stage-3)" := USERID;
                    "Send for Appl.Date(Stage-3)" := TODAY;
                END ELSE BEGIN
                    "Sender USER Id (Stage-3)" := '';
                    "Send for Appl.Date(Stage-3)" := 0D;
                END;
            end;
        }
        field(53; "Sender USER Id (Stage-3)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(54; "Approved By (Stage-3)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(55; "Approved (Stage-3)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(3);
                IF "Approved Date (Stage-2)" <> 0D THEN BEGIN
                    "Ageing Days 3" := FORMAT(TODAY - "Approved Date (Stage-2)") + 'D';
                END;
                IF "Approved (Stage-3)" THEN BEGIN
                    "Approved By (Stage-3)" := USERID;
                    "Approved Date (Stage-3)" := TODAY;
                END ELSE BEGIN
                    "Approved By (Stage-3)" := '';
                    "Approved Date (Stage-3)" := 0D;
                END;
            end;
        }
        field(56; "Approved Date (Stage-3)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(57; "Send for Appl.Date(Stage-3)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                CheckStagePermission(3);
            end;
        }
        field(58; "Send for Approval (Stage-4)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
                IF "Send for Approval (Stage-4)" THEN BEGIN
                    "Sender USER Id (Stage-4)" := USERID;
                    "Send for Appl.Date(Stage-4)" := TODAY;
                END ELSE BEGIN
                    "Sender USER Id (Stage-4)" := '';
                    "Send for Appl.Date(Stage-4)" := 0D;
                END;
            end;
        }
        field(59; "Sender USER Id (Stage-4)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60; "Approved By (Stage-4)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(61; "Approved (Stage-4)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
                IF "Approved Date (Stage-3)" <> 0D THEN BEGIN
                    "Ageing Days 4" := FORMAT(TODAY - "Approved Date (Stage-3)") + 'D';
                END;
                IF "Approved (Stage-4)" THEN BEGIN
                    "Approved By (Stage-4)" := USERID;
                    "Approved Date (Stage-4)" := TODAY;
                END ELSE BEGIN
                    "Approved By (Stage-4)" := '';
                    "Approved Date (Stage-4)" := 0D;
                END;
            end;
        }
        field(62; "Approved Date (Stage-4)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(63; "Send for Appl.Date(Stage-4)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
            end;
        }
        field(64; "Send for Approval (Stage-5)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(5);
                IF "Send for Approval (Stage-5)" THEN BEGIN
                    "Sender USER Id (Stage-5)" := USERID;
                    "Send for Appl.Date(Stage-5)" := TODAY;
                END ELSE BEGIN
                    "Sender USER Id (Stage-5)" := '';
                    "Send for Appl.Date(Stage-5)" := 0D;
                END;
            end;
        }
        field(65; "Sender USER Id (Stage-5)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(66; "Approved By (Stage-5)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(67; "Approved (Stage-5)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(5);
                IF "Approved Date (Stage-4)" <> 0D THEN BEGIN
                    "Ageing Days 5" := FORMAT(TODAY - "Approved Date (Stage-4)") + 'D';
                END;
                IF "Approved (Stage-5)" THEN BEGIN
                    "Approved By (Stage-5)" := USERID;
                    "Approved Date (Stage-5)" := TODAY;
                END ELSE BEGIN
                    "Approved By (Stage-5)" := '';
                    "Approved Date (Stage-5)" := 0D;
                END;
            end;
        }
        field(68; "Approved Date (Stage-5)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(69; "Send for Appl.Date(Stage-5)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                CheckStagePermission(5);
            end;
        }
        field(70; "Send for Approval (Stage-6)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
                IF "Send for Approval (Stage-6)" THEN BEGIN
                    "Sender USER Id (Stage-6)" := USERID;
                    "Send for Appl.Date(Stage-6)" := TODAY;
                END ELSE BEGIN
                    "Sender USER Id (Stage-6)" := '';
                    "Send for Appl.Date(Stage-6)" := 0D;
                END;
            end;
        }
        field(71; "Sender USER Id (Stage-6)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(72; "Approved By (Stage-6)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(73; "Approved (Stage-6)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
                IF "Approved Date (Stage-5)" <> 0D THEN BEGIN
                    "Ageing Days 6" := FORMAT(TODAY - "Approved Date (Stage-5)") + 'D';
                END;
                IF "Approved (Stage-6)" THEN BEGIN
                    "Approved By (Stage-6)" := USERID;
                    "Approved Date (Stage-6)" := TODAY;
                END ELSE BEGIN
                    "Approved By (Stage-6)" := '';
                    "Approved Date (Stage-6)" := 0D;
                END;
            end;
        }
        field(74; "Approved Date (Stage-6)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(75; "Send for Appl.Date(Stage-6)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(76; "Send for Approval (Stage-7)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(7);
                IF "Send for Approval (Stage-7)" THEN BEGIN
                    "Sender USER Id (Stage-7)" := USERID;
                    "Send for Appl.Date(Stage-7)" := TODAY;
                END ELSE BEGIN
                    "Sender USER Id (Stage-7)" := '';
                    "Send for Appl.Date(Stage-7)" := 0D;
                END;
            end;
        }
        field(77; "Sender USER Id (Stage-7)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(78; "Approved By (Stage-7)"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(79; "Approved (Stage-7)"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(7);
                IF "Approved Date (Stage-6)" <> 0D THEN BEGIN
                    "Ageing Days 7" := FORMAT(TODAY - "Approved Date (Stage-6)") + 'D';
                END;
                IF "Approved (Stage-7)" THEN BEGIN
                    "Approved By (Stage-7)" := USERID;
                    "Approved Date (Stage-7)" := TODAY;
                END ELSE BEGIN
                    "Approved By (Stage-7)" := '';
                    "Approved Date (Stage-7)" := 0D;
                END;
            end;
        }
        field(80; "Approved Date (Stage-7)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(81; "Send for Appl.Date(Stage-7)"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(89; "Form32 User Id"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(90; "Form 32 Responsibility Center"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(91; "Plot Reg User Id"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(92; "Plot Reg. Resp Center"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(93; "AAdhar Card User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(94; "AAdhar Card Resp Center"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(95; "PAN User Id"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(96; "PAN Resp Center"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(97; "Photo User Id"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(98; "Photo Resp Center"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(99; "Form32 Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(100; "Plot Reg Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(101; "AAdhar Card Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(102; "PAN Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(103; "Photo Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(104; "Gen of Challan USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(105; "Gen of Challan RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(106; "Gen of Challan Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(107; "Doc Send SRO USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(108; "Doc Send SRO RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(109; "Doc Send SRO Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(110; "Customer Info USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(111; "Customer Info RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(112; "Customer Info Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(113; "Org. info USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(114; "Org. info RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(115; "Org. info Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(116; "Proj. info USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(117; "Proj. info RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(118; "Proj. info Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(119; "Statury info USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(120; "Statury info RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(121; "Statury info Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(122; "Sale Deed info USERID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(123; "Sale Deed info RespCenter"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(124; "Sale Deed info Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(125; "Stage 1 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(126; "Stage 2 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(127; "Stage 3 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(128; "Stage 4 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(129; "Stage 5 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(130; "Stage 6 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;
        }
        field(131; "Stage 7 Status"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Release';
            OptionMembers = Open,Release;

            trigger OnValidate()
            begin
                CheckStagePermission(7);
            end;
        }
        field(132; "Open Stage"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(134; "Registration Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
                UpdateFields('', 0D);
            end;
        }
        field(135; "Reg. Office"; Text[60])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
                UpdateFields('', 0D);
            end;
        }
        field(136; "Registration In Favour Of"; Text[60])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
                UpdateFields('', 0D);
            end;
        }
        field(137; "Registered/Office Name"; Text[70])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
                UpdateFields('', 0D);
            end;
        }
        field(138; "Reg. Address"; Text[80])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
                UpdateFields('', 0D);
            end;
        }
        field(139; "Father/Husband Name"; Text[60])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
                UpdateFields('', 0D);
            end;
        }
        field(140; "Branch Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
                UpdateFields('', 0D);
            end;
        }
        field(141; "Registered City"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
                UpdateFields('', 0D);
            end;
        }
        field(142; "Zip Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Post Code";

            trigger OnValidate()
            begin
                CheckStagePermission(6);
                UpdateFields('', 0D);
            end;
        }
        field(143; "Reg./Cancle Reg. No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(8);
                UpdateFields("Reg./Cancle Reg. No.", "Reg./Cancle Reg. Date");
            end;
        }
        field(144; "Reg./Cancle Reg. Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(8);
                UpdateFields("Reg./Cancle Reg. No.", "Reg./Cancle Reg. Date");
            end;
        }
        field(145; "Customer PAN No."; Code[10])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
            end;
        }
        field(146; "Customer Aadhar No."; Code[15])  //Change Integer to Code 190325
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
            end;
        }
        field(147; "LLP Name"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
            end;
        }
        field(148; "LLP Address"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
            end;
        }
        field(149; "LLP Address 2"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
            end;
        }
        field(150; "Project Name"; Text[100])
        {
            CalcFormula = Lookup("Responsibility Center".Name WHERE(Code = FIELD("Shortcut Dimension 1 Code")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
            end;
        }
        field(151; "Plot No."; Code[20])
        {
            CalcFormula = Lookup("New Confirmed Order"."Unit Code" WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
            end;
        }
        field(152; "Plot Extent"; Decimal)
        {
            CalcFormula = Lookup("New Confirmed Order"."Saleable Area" WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
            end;
        }
        field(153; "Representative Name"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(154; "LLP Registration Name"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
            end;
        }
        field(155; "Plot Dimension"; Text[70])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(4);
            end;
        }
        field(156; "Generation of Challan No."; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(5);
            end;
        }
        field(157; "Transaction ID"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(5);
            end;
        }
        field(158; "Transaction Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(5);
            end;
        }
        field(160; "Representative Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                CheckStagePermission(4);
                Employee.RESET;
                IF Employee.GET("Representative Code") THEN
                    "Representative Name" := Employee."First Name" + ' ' + Employee."Last Name"
                ELSE
                    "Representative Name" := '';
            end;
        }
        field(161; "Sale Deed Received Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(7);
            end;
        }
        field(162; "Customer Sale Deed"; Text[30])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(7);
            end;
        }
        field(163; "Link Book Received"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(7);
                IF "Link Book Received" THEN BEGIN
                    "Link Book Date" := TODAY;
                    "Link Book User ID" := USERID;
                END ELSE BEGIN
                    "Link Book Date" := 0D;
                    "Link Book User ID" := '';
                END;
            end;
        }
        field(164; "Link Book User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(165; "Link Book Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(166; "PRLC Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Rectification,Cancellation';
            OptionMembers = " ",Rectification,Cancellation;

            trigger OnValidate()
            begin
                CheckStagePermission(8);
            end;
        }
        field(167; "Send SMS Stage-1"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(1);
                IF "Send SMS Stage-1" THEN BEGIN
                    Compinformation.RESET;
                    Compinformation.GET;
                    IF Compinformation."Send SMS" THEN BEGIN
                        Customer.RESET;
                        IF Customer.GET("Customer No.") THEN BEGIN
                            IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                ResponsibilityCenter.RESET;
                                IF ResponsibilityCenter.GET("Shortcut Dimension 1 Code") THEN;
                                SmsText := '';
                                SmsText := 'Dear Customer, We acknowledge the Receipt of Thumb impression form to Plot Registration Dept. for the Appl No: ' + FORMAT("No.") +
                                ', Name: ' + Customer.Name + ', Project:' + FORMAT(ResponsibilityCenter.Name) + ', Date: ' + FORMAT(TODAY) + '.Thank you.BBGIND';
                                PostPayment.SendSMS(Customer."BBG Mobile No.", SmsText);
                                "Send SMS Stage-1 Date Time" := CURRENTDATETIME;
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(SmsText, 1, 250);
                                SmsMessage1 := COPYSTR(SmsText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Send SMS Stage-1', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                //ALLEDK15112022 END


                                Vendor.RESET;
                                Vendor.GET("Introducer Code");
                                SendVendorSMS(Vendor."BBG Mob. No.", SmsText);
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(SmsText, 1, 250);
                                SmsMessage1 := COPYSTR(SmsText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, 'Send SMS Stage-1', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                //ALLEDK15112022 END
                            END;
                        END;
                    END ELSE
                        MESSAGE('Nothing Send');
                END;
            end;
        }
        field(168; "Send SMS Stage-1 Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(169; "Send SMS Generation of Challan"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(5);
                IF "Send SMS Generation of Challan" THEN BEGIN
                    Compinformation.RESET;
                    Compinformation.GET;
                    IF Compinformation."Send SMS" THEN BEGIN
                        Customer.RESET;
                        IF Customer.GET("Customer No.") THEN BEGIN
                            IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                ResponsibilityCenter.RESET;
                                IF ResponsibilityCenter.GET("Shortcut Dimension 1 Code") THEN;
                                SmsText := '';
                                SmsText := 'Dear Customer, Your Application challan has been generated for the Appl No: ' + FORMAT("No.") + ', Name: ' + Customer.Name + ', Project:' +
                                 FORMAT(ResponsibilityCenter.Name) + ', Date: ' + FORMAT(TODAY) + '.Thank you.BBGIND';
                                PostPayment.SendSMS(Customer."BBG Mobile No.", SmsText);
                                "Send SMS Challan Date Time" := CURRENTDATETIME;
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(SmsText, 1, 250);
                                SmsMessage1 := COPYSTR(SmsText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Send SMS Generation of Challan', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                //ALLEDK15112022 END

                                Vendor.RESET;
                                Vendor.GET("Introducer Code");
                                SendVendorSMS(Vendor."BBG Mob. No.", SmsText);
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(SmsText, 1, 250);
                                SmsMessage1 := COPYSTR(SmsText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, 'Send SMS Generation of Challan', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                //ALLEDK15112022 END
                            END;
                        END;
                    END ELSE
                        MESSAGE('Nothing Send');
                END;
            end;
        }
        field(170; "Send SMS Challan Date Time"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(171; "Send SMS Doc send SRO for Reg."; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(5);
                IF "Send SMS Doc send SRO for Reg." THEN BEGIN
                    Compinformation.RESET;
                    Compinformation.GET;
                    IF Compinformation."Send SMS" THEN BEGIN
                        Customer.RESET;
                        IF Customer.GET("Customer No.") THEN BEGIN
                            IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                ResponsibilityCenter.RESET;
                                IF ResponsibilityCenter.GET("Shortcut Dimension 1 Code") THEN;
                                SmsText := '';
                                SmsText := 'Dear Customer, Your Application is out for Registration to SRO office, for the Appl No: ' + FORMAT("No.") +
                                ', Name: ' + Customer.Name + 'Project:' + FORMAT(ResponsibilityCenter.Name) + ', Date: ' + FORMAT(TODAY) + '.Thank you.BBGIND';
                                PostPayment.SendSMS(Customer."BBG Mobile No.", SmsText);
                                "Send SMS Doc SRO Reg. DateTime" := CURRENTDATETIME;
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(SmsText, 1, 250);
                                SmsMessage1 := COPYSTR(SmsText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Send SMS Doc send SRO for Reg', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                //ALLEDK15112022 END
                                Vendor.RESET;
                                Vendor.GET("Introducer Code");
                                SendVendorSMS(Vendor."BBG Mob. No.", SmsText);
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(SmsText, 1, 250);
                                SmsMessage1 := COPYSTR(SmsText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, 'Send SMS Doc send SRO for Reg', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                //ALLEDK15112022 END
                            END;
                        END;
                    END ELSE
                        MESSAGE('Nothing Send');
                END;
            end;
        }
        field(172; "Send SMS Doc SRO Reg. DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(173; "Send SMS Doc received from SRO"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
                IF "Send SMS Doc received from SRO" THEN BEGIN
                    Compinformation.RESET;
                    Compinformation.GET;
                    IF Compinformation."Send SMS" THEN BEGIN
                        Customer.RESET;
                        IF Customer.GET("Customer No.") THEN BEGIN
                            IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                ResponsibilityCenter.RESET;
                                IF ResponsibilityCenter.GET("Shortcut Dimension 1 Code") THEN;
                                SmsText := '';

                                SmsText := 'Dear : ' + Customer.Name + ' ,Congratulations! We are pleased to inform you that your Registration' +
                                ' Document is received from SRO, request you to kindly collect your Regd Document from respective BBG ' +
                                'Office. With best regards.BBGIND';





                                PostPayment.SendSMS(Customer."BBG Mobile No.", SmsText);
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(SmsText, 1, 250);
                                SmsMessage1 := COPYSTR(SmsText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Send SMS Doc received from SRO', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                //ALLEDK15112022 END
                                "Send SMS Doc received SRO Dt.T" := CURRENTDATETIME;
                                Vendor.RESET;
                                Vendor.GET("Introducer Code");
                                SendVendorSMS(Vendor."BBG Mob. No.", SmsText);
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(SmsText, 1, 250);
                                SmsMessage1 := COPYSTR(SmsText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, 'Send SMS Doc received from SRO', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                //ALLEDK15112022 END
                            END;
                        END;
                    END ELSE
                        MESSAGE('Nothing Send');
                END;
            end;
        }
        field(174; "Send SMS Doc received SRO Dt.T"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                CheckStagePermission(6);
            end;
        }
        field(175; "Send SMS Reg. Doc. Cust Rcpt"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                CheckStagePermission(7);
                IF "Send SMS Reg. Doc. Cust Rcpt" THEN BEGIN
                    Compinformation.RESET;
                    Compinformation.GET;
                    IF Compinformation."Send SMS" THEN BEGIN
                        Customer.RESET;
                        IF Customer.GET("Customer No.") THEN BEGIN
                            IF Customer."BBG Mobile No." <> '' THEN BEGIN
                                ResponsibilityCenter.RESET;
                                IF ResponsibilityCenter.GET("Shortcut Dimension 1 Code") THEN;
                                SmsText := '';
                                SmsText := 'Dear : ' + Customer.Name + ' ,your Registration Document has been delivered at Transaction' +     //250625 Code Open
                                ' Desk of respective BBG Office. Thanks for your Patronage with us and look forward for your future investments.BBGIND';  //1702 comment   //250625 Code Open

                                //1702 Added
                                //       SmsText := 'Dear : ' + Customer.Name + ' , your Registered Document will be delivered at the Transaction Desk of the respective BBG Office in' +  //250625 Code comemnt
                                //     ' 2 to 3 working days.Thanks for your Patronage with us and we look forward to your future investments in BBG Family';   //250625 Code comemnt

                                PostPayment.SendSMS(Customer."BBG Mobile No.", SmsText);
                                "Send SMS Reg Doc Cust DateTime" := CURRENTDATETIME;
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(SmsText, 1, 250);
                                SmsMessage1 := COPYSTR(SmsText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Customer', Customer."No.", Customer.Name, 'Send SMS Reg. Doc. Cust Rcpt', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                //ALLEDK15112022 END

                                Vendor.RESET;
                                Vendor.GET("Introducer Code");
                                SendVendorSMS(Vendor."BBG Mob. No.", SmsText);
                                //ALLEDK15112022 Start
                                CLEAR(SMSLogDetails);
                                SmsMessage := '';
                                SmsMessage1 := '';
                                SmsMessage := COPYSTR(SmsText, 1, 250);
                                SmsMessage1 := COPYSTR(SmsText, 251, 250);
                                SMSLogDetails.SMSValue(SmsMessage, SmsMessage1, 'Vendor', Vendor."No.", Vendor.Name, 'Send SMS Reg. Doc. Cust Rcpt', "Shortcut Dimension 1 Code", GetDescription.GetDimensionName("Shortcut Dimension 1 Code", 1), "No.");
                                //ALLEDK15112022 END

                            END;
                        END;
                    END ELSE
                        MESSAGE('Nothing Send');
                END;
            end;
        }
        field(176; "Send SMS Reg Doc Cust DateTime"; DateTime)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
                CheckStagePermission(7);
            end;
        }
        field(177; "Remarks 1"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Stage 1 Status", "Stage 1 Status"::Open);
                CheckStagePermission(1);
            end;
        }
        field(178; "Remarks 2"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Stage 2 Status", "Stage 2 Status"::Open);
                CheckStagePermission(2);
            end;
        }
        field(179; "Remarks 3"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Stage 3 Status", "Stage 3 Status"::Open);
                CheckStagePermission(3);
            end;
        }
        field(180; "Remarks 4"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Stage 4 Status", "Stage 4 Status"::Open);
                CheckStagePermission(4);
            end;
        }
        field(181; "Remarks 5"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Stage 5 Status", "Stage 5 Status"::Open);
                CheckStagePermission(5);
            end;
        }
        field(182; "Remarks 6"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Stage 6 Status", "Stage 6 Status"::Open);
                CheckStagePermission(6);
            end;
        }
        field(183; "Remarks 7"; Text[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Stage 7 Status", "Stage 7 Status"::Open);
                CheckStagePermission(7);
            end;
        }
        field(184; "Remarks 8"; Text[40])
        {
            DataClassification = ToBeClassified;
            Description = '//Length 50 to 40';

            trigger OnValidate()
            begin
                CheckStagePermission(8);
            end;
        }
        field(185; "Unit Facing"; Option)
        {
            CalcFormula = Lookup("Unit Master".Facing WHERE("No." = FIELD("Unit Code")));
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'NA,East,West,North,South,NorthWest,SouthEast,NorthEast,SouthWest';
            OptionMembers = NA,East,West,North,South,NorthWest,SouthEast,NorthEast,SouthWest;
        }
        field(186; "Ageing Days 1"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(187; "Ageing Days 2"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(188; "Ageing Days 3"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(189; "Ageing Days 4"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(190; "Ageing Days 5"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(191; "Ageing Days 6"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(192; "Ageing Days 7"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(193; "Current Remarks"; Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(194; "Current Days"; Code[5])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(195; "Version No."; Integer)
        {
            CalcFormula = Max("Archived Plot Reg Details"."Archive No." WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90075; "Registration Bonus Hold(BSP2)"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'BBG1.00 010413';
            Editable = true;

            trigger OnValidate()
            begin
                Memberof.RESET;
                Memberof.SETRANGE("User Name", USERID);
                Memberof.SETRANGE("Role ID", 'A_HOLDRB');
                IF NOT Memberof.FINDFIRST THEN
                    ERROR('You do not have permission of Role : A_HOLDRB');
                AmtComm := 0;

                CommissionEntry.RESET;
                CommissionEntry.CHANGECOMPANY("Company Name");
                CommissionEntry.SETRANGE(CommissionEntry."Application No.", "No.");
                CommissionEntry.SETRANGE(CommissionEntry."Introducer Code", "Introducer Code");
                CommissionEntry.SETRANGE(CommissionEntry.Posted, TRUE);
                CommissionEntry.SETRANGE(CommissionEntry."Opening Entries", FALSE);
                CommissionEntry.SETRANGE(CommissionEntry."Direct to Associate", TRUE);
                IF CommissionEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        AmtComm := AmtComm + CommissionEntry."Commission Amount";
                    UNTIL CommissionEntry.NEXT = 0;
                    IF AmtComm > 0 THEN BEGIN
                        IF "Registration Bonus Hold(BSP2)" THEN
                            ERROR('You have already paid Registration %1', "No.");
                    END;
                END;


                //
                NConfirmedOrder.RESET;
                IF NConfirmedOrder.GET("No.") THEN BEGIN
                    IF "Registration Bonus Hold(BSP2)" = FALSE THEN BEGIN
                        NConfirmedOrder."RB Release by User ID" := USERID;
                        NConfirmedOrder."Date/Time of RB Release" := CURRENTDATETIME;
                    END ELSE BEGIN
                        NConfirmedOrder."RB Release by User ID" := '';
                        NConfirmedOrder."Date/Time of RB Release" := 0DT;
                    END;
                    NConfirmedOrder.MODIFY;
                END;
                //

                ConfOrder.RESET;
                ConfOrder.CHANGECOMPANY("Company Name");
                IF ConfOrder.GET("No.") THEN BEGIN
                    ConfOrder."Registration Bonus Hold(BSP2)" := "Registration Bonus Hold(BSP2)";
                    ConfOrder."RB Release by User ID" := NConfirmedOrder."RB Release by User ID";
                    ConfOrder."Date/Time of RB Release" := NConfirmedOrder."Date/Time of RB Release";
                    ConfOrder.TESTFIELD("Registration No.");
                    ConfOrder.TESTFIELD("Registration Date");
                    ConfOrder.MODIFY;
                END;
            end;
        }
        field(90310; "Send for Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(90311; "Send for Approval Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(90312; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Approved,Rejected';
            OptionMembers = " ",Approved,Rejected;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        NewConfirmedOrder.RESET;
        IF NewConfirmedOrder.GET("No.") THEN BEGIN
            IF NewConfirmedOrder.Status = NewConfirmedOrder.Status::Registered THEN
                ERROR('Application already Registered');
        END;
    end;

    var
        NewConfirmedOrder: Record "New Confirmed Order";
        UserSetup: Record "User Setup";
        ResponsibilityCenter: Record "Responsibility Center 1";
        NewApplicationPaymentEntry: Record "NewApplication Payment Entry";
        v_Customer: Record Customer;
        v_ComInfo: Record "Company Information";
        v_ResponsibilityCenter: Record "Responsibility Center 1";
        v_UnitMaster: Record "Unit Master";
        PostPayment: Codeunit PostPayment;
        Customer: Record Customer;
        SmsText: Text;
        Compinformation: Record "Company Information";
        Vendor: Record Vendor;
        SMSLogDetails: Codeunit "SMS Log Details";
        SmsMessage: Text[250];
        SmsMessage1: Text[250];
        GetDescription: Codeunit GetDescription;
        AmtComm: Decimal;
        AppPaymentEntry: Record "NewApplication Payment Entry";
        CommissionEntry: Record "Commission Entry";
        CompanyWise: Record "Company wise G/L Account";
        ConfOrder: Record "Confirmed Order";
        Memberof: Record "Access Control";
        NConfirmedOrder: Record "New Confirmed Order";

    local procedure UpdateFields(NewRegNo: Code[30]; NewRegDate: Date)
    var
        v_NewConfirmedOrder: Record "New Confirmed Order";
        v_ConfirmedOrder: Record "Confirmed Order";
    begin
        v_NewConfirmedOrder.RESET;
        IF v_NewConfirmedOrder.GET("No.") THEN BEGIN
            v_NewConfirmedOrder."Reg. Office" := "Reg. Office";
            v_NewConfirmedOrder."Registration In Favour Of" := "Registration In Favour Of";
            v_NewConfirmedOrder."Registered/Office Name" := "Registered/Office Name";
            v_NewConfirmedOrder."Reg. Address" := "Reg. Address";
            v_NewConfirmedOrder."Father/Husband Name" := "Father/Husband Name";
            v_NewConfirmedOrder."Branch Code" := "Branch Code";
            v_NewConfirmedOrder."Registered City" := "Registered City";
            v_NewConfirmedOrder."Zip Code" := "Zip Code";
            IF NewRegNo = '' THEN BEGIN
                v_NewConfirmedOrder."Registration No." := "Registration No.";
                v_NewConfirmedOrder."Registration Date" := "Registration Date";
            END ELSE BEGIN
                v_NewConfirmedOrder."Registration No." := NewRegNo;
                v_NewConfirmedOrder."Registration Date" := NewRegDate;
            END;
            v_NewConfirmedOrder.MODIFY;

            v_ConfirmedOrder.RESET;
            v_ConfirmedOrder.CHANGECOMPANY(v_NewConfirmedOrder."Company Name");
            IF v_ConfirmedOrder.GET("No.") THEN BEGIN
                v_ConfirmedOrder."Reg. Office" := "Reg. Office";
                v_ConfirmedOrder."Registration In Favour Of" := "Registration In Favour Of";
                v_ConfirmedOrder."Registered/Office Name" := "Registered/Office Name";
                v_ConfirmedOrder."Reg. Address" := "Reg. Address";
                v_ConfirmedOrder."Father/Husband Name" := "Father/Husband Name";
                v_ConfirmedOrder."Branch Code" := "Branch Code";
                v_ConfirmedOrder."Registered City" := "Registered City";
                v_ConfirmedOrder."Zip Code" := "Zip Code";
                IF NewRegNo = '' THEN BEGIN
                    v_ConfirmedOrder."Registration No." := "Registration No.";
                    v_ConfirmedOrder."Registration Date" := "Registration Date";
                END ELSE BEGIN
                    v_ConfirmedOrder."Registration No." := NewRegNo;
                    v_ConfirmedOrder."Registration Date" := NewRegDate;
                END;
                v_ConfirmedOrder.MODIFY;
            END;
        END;
    end;

    local procedure CheckStagePermission(StageCode: Integer)
    var
        v_UserSetup: Record "User Setup";
    begin

        IF (StageCode = 1) OR (StageCode = 7) THEN BEGIN
            v_UserSetup.RESET;
            v_UserSetup.SETRANGE("User ID", USERID);
            v_UserSetup.SETRANGE("Plot Reg. Stage 1 and 7", TRUE);
            IF NOT v_UserSetup.FINDFIRST THEN
                ERROR('Contact Admin');
        END;

        IF (StageCode = 3) THEN BEGIN
            v_UserSetup.RESET;
            v_UserSetup.SETRANGE("User ID", USERID);
            v_UserSetup.SETRANGE("Plot Reg. Stage 3", TRUE);
            IF NOT v_UserSetup.FINDFIRST THEN
                ERROR('Contact Admin');
        END;

        IF (StageCode = 2) THEN BEGIN
            v_UserSetup.RESET;
            v_UserSetup.SETRANGE("User ID", USERID);
            v_UserSetup.SETRANGE("Plot Reg. Stage 2", TRUE);
            IF NOT v_UserSetup.FINDFIRST THEN
                ERROR('Contact Admin');
        END;

        IF (StageCode = 4) OR (StageCode = 5) OR (StageCode = 6) OR (StageCode = 8) THEN BEGIN
            v_UserSetup.RESET;
            v_UserSetup.SETRANGE("User ID", USERID);
            v_UserSetup.SETRANGE("Plot Reg. Stage 4_5_6_ 8", TRUE);
            IF NOT v_UserSetup.FINDFIRST THEN
                ERROR('Contact Admin');
        END;
    end;

    local procedure SendVendorSMS(VendMobNo: Text; SMSTextValue: Text)
    begin
        COMMIT;
        CLEAR(PostPayment);
        PostPayment.SendSMS(VendMobNo, SMSTextValue);
    end;
}

