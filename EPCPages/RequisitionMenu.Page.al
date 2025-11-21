page 97856 "Requisition Menu"
{
    Caption = 'Inventory Menu';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            label("")
            {
                CaptionClass = Text19037141;
                Style = Attention;
                StyleExpr = TRUE;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Requisition)
            {
                Caption = 'Requisition';
                action("FA-Purchase/Transfer Requisition")
                {
                    Caption = 'FA-Purchase/Transfer Requisition';

                    trigger OnAction()
                    begin
                        //ALLE-PKS35
                        DocApproval.RESET;
                        DocApproval.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, "Line No");
                        DocApproval.SETRANGE(DocApproval."Document Type", DocApproval."Document Type"::Indent);
                        DocApproval.SETRANGE(DocApproval."Document No", '');
                        DocApproval.SETRANGE(DocApproval."Sub Document Type", DocApproval."Sub Document Type"::FA);
                        DocApproval.SETRANGE(DocApproval.Initiator, USERID);
                        DocApproval.SETRANGE("Document No", '');
                        DocApproval.SETFILTER("Line No", '<>%1', 0);
                        DocApproval.SETFILTER(DocApproval."Approvar ID", '<>%1', '');
                        //IF DocApproval.FIND('-') THEN
                        IF DocApproval.COUNT = 0 THEN
                            ERROR('There is no Appover for this document');
                        //ALLE-PKS35


                        //NDALLE 040208
                        RecuserSetup2.RESET;
                        RecuserSetup2.SETCURRENTKEY(RecuserSetup2."Purchase Resp. Ctr. Filter", RecuserSetup2."User ID");
                        RecuserSetup2.SETRANGE("User ID", USERID);
                        RecuserSetup2.SETFILTER("Purchase Resp. Ctr. Filter", '<>%1', '');
                        IF RecuserSetup2.FINDFIRST THEN BEGIN
                            IF RecResponsibilityCenter2.GET(RecuserSetup2."Purchase Resp. Ctr. Filter") THEN
                                RespCode := RecResponsibilityCenter2.Code;
                        END;

                        PoHdr2.RESET;
                        PoHdr2.SETCURRENTKEY(Indentor, "Shortcut Dimension 1 Code", "Document Type", "Indent Status");
                        PoHdr2.SETFILTER(Indentor, USERID);
                        PoHdr2.SETFILTER(PoHdr2."Shortcut Dimension 1 Code", '=%1', RespCode);
                        PoHdr2.SETFILTER("Document Type", '=%1', PoHdr2."Document Type"::Indent);
                        PoHdr2.SETFILTER("Indent Status", '=%1', PoHdr2."Indent Status"::Open);
                        PoHdr2.SETFILTER("Sub Document Type", '=%1', PoHdr2."Sub Document Type"::FA);
                        IF PoHdr2.FINDFIRST THEN BEGIN
                            REPEAT
                                PoLn2.RESET;
                                PoLn2.SETRANGE("Document Type", PoHdr2."Document Type");
                                PoLn2.SETRANGE("Document No.", PoHdr2."Document No.");
                                IF NOT PoLn2.FINDFIRST THEN
                                    ERROR('Please check there is already a Blank Indent \No.= %1 \USERID = %2', PoHdr2."Document No.", USERID);
                            UNTIL PoHdr2.NEXT = 0;
                        END;
                        //NDALLE 040208


                        IF CONFIRM('Are you sure you want to create Indent', TRUE) THEN BEGIN
                            //JPL03 START
                            IndHdr.INIT;
                            IndHdr."Document Type" := IndHdr."Document Type"::Indent;
                            IndHdr."Document No." := '';
                            IndHdr."Sub Document Type" := IndHdr."Sub Document Type"::FA;
                            IndHdr.INSERT(TRUE);
                            PAGE.RUN(PAGE::"Requisition Header", IndHdr);
                        END;
                    end;
                }
                action("FA-Sale Requisition")
                {
                    Caption = 'FA-Sale Requisition';

                    trigger OnAction()
                    begin
                        //ALLE-PKS35
                        DocApproval.RESET;
                        DocApproval.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, "Line No");
                        DocApproval.SETRANGE(DocApproval."Document Type", DocApproval."Document Type"::Indent);
                        DocApproval.SETRANGE(DocApproval."Document No", '');
                        DocApproval.SETRANGE(DocApproval."Sub Document Type", DocApproval."Sub Document Type"::"FA Sale");
                        DocApproval.SETRANGE(DocApproval.Initiator, USERID);
                        DocApproval.SETRANGE("Document No", '');
                        DocApproval.SETFILTER("Line No", '<>%1', 0);
                        DocApproval.SETFILTER(DocApproval."Approvar ID", '<>%1', '');
                        //IF DocApproval.FIND('-') THEN
                        IF DocApproval.COUNT = 0 THEN
                            ERROR('There is no Appover for this document');
                        //ALLE-PKS35


                        //NDALLE 040208
                        RecuserSetup2.RESET;
                        RecuserSetup2.SETCURRENTKEY(RecuserSetup2."Purchase Resp. Ctr. Filter", RecuserSetup2."User ID");
                        RecuserSetup2.SETRANGE("User ID", USERID);
                        RecuserSetup2.SETFILTER("Purchase Resp. Ctr. Filter", '<>%1', '');
                        IF RecuserSetup2.FINDFIRST THEN BEGIN
                            IF RecResponsibilityCenter2.GET(RecuserSetup2."Purchase Resp. Ctr. Filter") THEN
                                RespCode := RecResponsibilityCenter2.Code;
                        END;

                        PoHdr2.RESET;
                        PoHdr2.SETCURRENTKEY(Indentor, "Shortcut Dimension 1 Code", "Document Type", "Indent Status");
                        PoHdr2.SETFILTER(Indentor, USERID);
                        PoHdr2.SETFILTER(PoHdr2."Shortcut Dimension 1 Code", '=%1', RespCode);
                        PoHdr2.SETFILTER("Document Type", '=%1', PoHdr2."Document Type"::Indent);
                        PoHdr2.SETFILTER("Indent Status", '=%1', PoHdr2."Indent Status"::Open);
                        PoHdr2.SETFILTER("Sub Document Type", '=%1', PoHdr2."Sub Document Type"::"FA Sale");
                        IF PoHdr2.FINDFIRST THEN BEGIN
                            REPEAT
                                PoLn2.RESET;
                                PoLn2.SETRANGE("Document Type", PoHdr2."Document Type");
                                PoLn2.SETRANGE("Document No.", PoHdr2."Document No.");
                                IF NOT PoLn2.FINDFIRST THEN
                                    ERROR('Please check there is already a Blank Indent \No.= %1 \USERID = %2', PoHdr2."Document No.", USERID);
                            UNTIL PoHdr2.NEXT = 0;
                        END;
                        //NDALLE 040208


                        IF CONFIRM('Are you sure you want to create Indent', TRUE) THEN BEGIN
                            //JPL03 START
                            IndHdr.INIT;
                            IndHdr."Document Type" := IndHdr."Document Type"::Indent;
                            IndHdr."Document No." := '';
                            IndHdr."Sub Document Type" := IndHdr."Sub Document Type"::"FA Sale";
                            IndHdr.INSERT(TRUE);
                            PAGE.RUN(PAGE::"Requisition Header", IndHdr);
                        END;
                    end;
                }
                action("Man Power Requisition")
                {
                    Caption = 'Man Power Requisition';

                    trigger OnAction()
                    begin
                        //ALLE-PKS35
                        DocApproval.RESET;
                        DocApproval.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, "Line No");
                        DocApproval.SETRANGE(DocApproval."Document Type", DocApproval."Document Type"::Indent);
                        DocApproval.SETRANGE(DocApproval."Document No", '');
                        DocApproval.SETRANGE(DocApproval."Sub Document Type", DocApproval."Sub Document Type"::"Man Power");
                        DocApproval.SETRANGE(DocApproval.Initiator, USERID);
                        DocApproval.SETRANGE("Document No", '');
                        DocApproval.SETFILTER("Line No", '<>%1', 0);
                        DocApproval.SETFILTER(DocApproval."Approvar ID", '<>%1', '');
                        //IF DocApproval.FIND('-') THEN
                        IF DocApproval.COUNT = 0 THEN
                            ERROR('There is no Appover for this document');
                        //ALLE-PKS35


                        //NDALLE 040208
                        RecuserSetup2.RESET;
                        RecuserSetup2.SETCURRENTKEY(RecuserSetup2."Purchase Resp. Ctr. Filter", RecuserSetup2."User ID");
                        RecuserSetup2.SETRANGE("User ID", USERID);
                        RecuserSetup2.SETFILTER("Purchase Resp. Ctr. Filter", '<>%1', '');
                        IF RecuserSetup2.FINDFIRST THEN BEGIN
                            IF RecResponsibilityCenter2.GET(RecuserSetup2."Purchase Resp. Ctr. Filter") THEN
                                RespCode := RecResponsibilityCenter2.Code;
                        END;

                        PoHdr2.RESET;
                        PoHdr2.SETCURRENTKEY(Indentor, "Shortcut Dimension 1 Code", "Document Type", "Indent Status");
                        PoHdr2.SETFILTER(Indentor, USERID);
                        PoHdr2.SETFILTER(PoHdr2."Shortcut Dimension 1 Code", '=%1', RespCode);
                        PoHdr2.SETFILTER("Document Type", '=%1', PoHdr2."Document Type"::Indent);
                        PoHdr2.SETFILTER("Indent Status", '=%1', PoHdr2."Indent Status"::Open);
                        PoHdr2.SETFILTER("Sub Document Type", '=%1', PoHdr2."Sub Document Type"::"Man Power");
                        IF PoHdr2.FINDFIRST THEN BEGIN
                            REPEAT
                                PoLn2.RESET;
                                PoLn2.SETRANGE("Document Type", PoHdr2."Document Type");
                                PoLn2.SETRANGE("Document No.", PoHdr2."Document No.");
                                IF NOT PoLn2.FINDFIRST THEN
                                    ERROR('Please check there is already a Blank Indent \No.= %1 \USERID = %2', PoHdr2."Document No.", USERID);
                            UNTIL PoHdr2.NEXT = 0;
                        END;
                        //NDALLE 040208


                        IF CONFIRM('Are you sure you want to create Indent', TRUE) THEN BEGIN
                            //JPL03 START
                            IndHdr.INIT;
                            IndHdr."Document Type" := IndHdr."Document Type"::Indent;
                            IndHdr."Document No." := '';
                            IndHdr."Sub Document Type" := IndHdr."Sub Document Type"::"Man Power";
                            IndHdr.INSERT(TRUE);
                            PAGE.RUN(PAGE::"Requisition Header", IndHdr);
                        END;
                    end;
                }
                action("Hire Requisition")
                {
                    Caption = 'Hire Requisition';

                    trigger OnAction()
                    begin
                        //ALLE-PKS35
                        DocApproval.RESET;
                        DocApproval.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, "Line No");
                        DocApproval.SETRANGE(DocApproval."Document Type", DocApproval."Document Type"::Indent);
                        DocApproval.SETRANGE(DocApproval."Document No", '');
                        DocApproval.SETRANGE(DocApproval."Sub Document Type", DocApproval."Sub Document Type"::Hire);
                        DocApproval.SETRANGE(DocApproval.Initiator, USERID);
                        DocApproval.SETRANGE("Document No", '');
                        DocApproval.SETFILTER("Line No", '<>%1', 0);
                        DocApproval.SETFILTER(DocApproval."Approvar ID", '<>%1', '');
                        //IF DocApproval.FIND('-') THEN
                        IF DocApproval.COUNT = 0 THEN
                            ERROR('There is no Appover for this document');
                        //ALLE-PKS35


                        //NDALLE 040208
                        RecuserSetup2.RESET;
                        RecuserSetup2.SETCURRENTKEY(RecuserSetup2."Purchase Resp. Ctr. Filter", RecuserSetup2."User ID");
                        RecuserSetup2.SETRANGE("User ID", USERID);
                        RecuserSetup2.SETFILTER("Purchase Resp. Ctr. Filter", '<>%1', '');
                        IF RecuserSetup2.FINDFIRST THEN BEGIN
                            IF RecResponsibilityCenter2.GET(RecuserSetup2."Purchase Resp. Ctr. Filter") THEN
                                RespCode := RecResponsibilityCenter2.Code;
                        END;

                        PoHdr2.RESET;
                        PoHdr2.SETCURRENTKEY(Indentor, "Shortcut Dimension 1 Code", "Document Type", "Indent Status");
                        PoHdr2.SETFILTER(Indentor, USERID);
                        PoHdr2.SETFILTER(PoHdr2."Shortcut Dimension 1 Code", '=%1', RespCode);
                        PoHdr2.SETFILTER("Document Type", '=%1', PoHdr2."Document Type"::Indent);
                        PoHdr2.SETFILTER("Indent Status", '=%1', PoHdr2."Indent Status"::Open);
                        PoHdr2.SETFILTER("Sub Document Type", '=%1', PoHdr2."Sub Document Type"::Hire);
                        IF PoHdr2.FINDFIRST THEN BEGIN
                            REPEAT
                                PoLn2.RESET;
                                PoLn2.SETRANGE("Document Type", PoHdr2."Document Type");
                                PoLn2.SETRANGE("Document No.", PoHdr2."Document No.");
                                IF NOT PoLn2.FINDFIRST THEN
                                    ERROR('Please check there is already a Blank Indent \No.= %1 \USERID = %2', PoHdr2."Document No.", USERID);
                            UNTIL PoHdr2.NEXT = 0;
                        END;
                        //NDALLE 040208


                        IF CONFIRM('Are you sure you want to create Indent', TRUE) THEN BEGIN
                            //JPL03 START
                            IndHdr.INIT;
                            IndHdr."Document Type" := IndHdr."Document Type"::Indent;
                            IndHdr."Document No." := '';
                            IndHdr."Sub Document Type" := IndHdr."Sub Document Type"::Hire;
                            IndHdr.INSERT(TRUE);
                            PAGE.RUN(PAGE::"Requisition Header", IndHdr);
                        END;
                    end;
                }
                action("Travel Requisition")
                {
                    Caption = 'Travel Requisition';
                    Visible = false;

                    trigger OnAction()
                    begin
                        //ALLE-PKS35
                        DocApproval.RESET;
                        DocApproval.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, "Line No");
                        DocApproval.SETRANGE(DocApproval."Document Type", DocApproval."Document Type"::Indent);
                        DocApproval.SETRANGE(DocApproval."Document No", '');
                        DocApproval.SETRANGE(DocApproval."Sub Document Type", DocApproval."Sub Document Type"::Travel);
                        DocApproval.SETRANGE(DocApproval.Initiator, USERID);
                        DocApproval.SETRANGE("Document No", '');
                        DocApproval.SETFILTER("Line No", '<>%1', 0);
                        DocApproval.SETFILTER(DocApproval."Approvar ID", '<>%1', '');
                        //IF DocApproval.FIND('-') THEN
                        IF DocApproval.COUNT = 0 THEN
                            ERROR('There is no Appover for this document');
                        //ALLE-PKS35


                        //NDALLE 040208
                        RecuserSetup2.RESET;
                        RecuserSetup2.SETCURRENTKEY(RecuserSetup2."Purchase Resp. Ctr. Filter", RecuserSetup2."User ID");
                        RecuserSetup2.SETRANGE("User ID", USERID);
                        RecuserSetup2.SETFILTER("Purchase Resp. Ctr. Filter", '<>%1', '');
                        IF RecuserSetup2.FINDFIRST THEN BEGIN
                            IF RecResponsibilityCenter2.GET(RecuserSetup2."Purchase Resp. Ctr. Filter") THEN
                                RespCode := RecResponsibilityCenter2.Code;
                        END;

                        PoHdr2.RESET;
                        PoHdr2.SETCURRENTKEY(Indentor, "Shortcut Dimension 1 Code", "Document Type", "Indent Status");
                        PoHdr2.SETFILTER(Indentor, USERID);
                        PoHdr2.SETFILTER(PoHdr2."Shortcut Dimension 1 Code", '=%1', RespCode);
                        PoHdr2.SETFILTER("Document Type", '=%1', PoHdr2."Document Type"::Indent);
                        PoHdr2.SETFILTER("Indent Status", '=%1', PoHdr2."Indent Status"::Open);
                        PoHdr2.SETFILTER("Sub Document Type", '=%1', PoHdr2."Sub Document Type"::Travel);
                        IF PoHdr2.FINDFIRST THEN BEGIN
                            REPEAT
                                PoLn2.RESET;
                                PoLn2.SETRANGE("Document Type", PoHdr2."Document Type");
                                PoLn2.SETRANGE("Document No.", PoHdr2."Document No.");
                                IF NOT PoLn2.FINDFIRST THEN
                                    ERROR('Please check there is already a Blank Indent \No.= %1 \USERID = %2', PoHdr2."Document No.", USERID);
                            UNTIL PoHdr2.NEXT = 0;
                        END;
                        //NDALLE 040208


                        IF CONFIRM('Are you sure you want to create Indent', TRUE) THEN BEGIN
                            //JPL03 START
                            IndHdr.INIT;
                            IndHdr."Document Type" := IndHdr."Document Type"::Indent;
                            IndHdr."Document No." := '';
                            IndHdr."Sub Document Type" := IndHdr."Sub Document Type"::Travel;
                            IndHdr.INSERT(TRUE);
                            PAGE.RUN(PAGE::"Requisition Header", IndHdr);
                        END;
                    end;
                }
                action("Leave Requisition")
                {
                    Caption = 'Leave Requisition';
                    Visible = false;

                    trigger OnAction()
                    begin
                        //ALLE-PKS35
                        DocApproval.RESET;
                        DocApproval.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, "Line No");
                        DocApproval.SETRANGE(DocApproval."Document Type", DocApproval."Document Type"::Indent);
                        DocApproval.SETRANGE(DocApproval."Document No", '');
                        DocApproval.SETRANGE(DocApproval."Sub Document Type", DocApproval."Sub Document Type"::Leave);
                        DocApproval.SETRANGE(DocApproval.Initiator, USERID);
                        DocApproval.SETRANGE("Document No", '');
                        DocApproval.SETFILTER("Line No", '<>%1', 0);
                        DocApproval.SETFILTER(DocApproval."Approvar ID", '<>%1', '');
                        //IF DocApproval.FIND('-') THEN
                        IF DocApproval.COUNT = 0 THEN
                            ERROR('There is no Appover for this document');
                        //ALLE-PKS35


                        //NDALLE 040208
                        RecuserSetup2.RESET;
                        RecuserSetup2.SETCURRENTKEY(RecuserSetup2."Purchase Resp. Ctr. Filter", RecuserSetup2."User ID");
                        RecuserSetup2.SETRANGE("User ID", USERID);
                        RecuserSetup2.SETFILTER("Purchase Resp. Ctr. Filter", '<>%1', '');
                        IF RecuserSetup2.FINDFIRST THEN BEGIN
                            IF RecResponsibilityCenter2.GET(RecuserSetup2."Purchase Resp. Ctr. Filter") THEN
                                RespCode := RecResponsibilityCenter2.Code;
                        END;

                        PoHdr2.RESET;
                        PoHdr2.SETCURRENTKEY(Indentor, "Shortcut Dimension 1 Code", "Document Type", "Indent Status");
                        PoHdr2.SETFILTER(Indentor, USERID);
                        PoHdr2.SETFILTER(PoHdr2."Shortcut Dimension 1 Code", '=%1', RespCode);
                        PoHdr2.SETFILTER("Document Type", '=%1', PoHdr2."Document Type"::Indent);
                        PoHdr2.SETFILTER("Indent Status", '=%1', PoHdr2."Indent Status"::Open);
                        PoHdr2.SETFILTER("Sub Document Type", '=%1', PoHdr2."Sub Document Type"::Leave);
                        IF PoHdr2.FINDFIRST THEN BEGIN
                            REPEAT
                                PoLn2.RESET;
                                PoLn2.SETRANGE("Document Type", PoHdr2."Document Type");
                                PoLn2.SETRANGE("Document No.", PoHdr2."Document No.");
                                IF NOT PoLn2.FINDFIRST THEN
                                    ERROR('Please check there is already a Blank Indent \No.= %1 \USERID = %2', PoHdr2."Document No.", USERID);
                            UNTIL PoHdr2.NEXT = 0;
                        END;
                        //NDALLE 040208


                        IF CONFIRM('Are you sure you want to create Indent', TRUE) THEN BEGIN
                            //JPL03 START
                            IndHdr.INIT;
                            IndHdr."Document Type" := IndHdr."Document Type"::Indent;
                            IndHdr."Document No." := '';
                            IndHdr."Sub Document Type" := IndHdr."Sub Document Type"::Leave;
                            IndHdr.INSERT(TRUE);
                            PAGE.RUN(PAGE::"Requisition Header", IndHdr);
                        END;
                    end;
                }
                action("Other Requisition")
                {
                    Caption = 'Other Requisition';

                    trigger OnAction()
                    begin
                        //ALLE-PKS35
                        DocApproval.RESET;
                        DocApproval.SETCURRENTKEY("Document Type", "Sub Document Type", "Document No", Initiator, "Line No");
                        DocApproval.SETRANGE(DocApproval."Document Type", DocApproval."Document Type"::Indent);
                        DocApproval.SETRANGE(DocApproval."Document No", '');
                        DocApproval.SETRANGE(DocApproval."Sub Document Type", DocApproval."Sub Document Type"::Others);
                        DocApproval.SETRANGE(DocApproval.Initiator, USERID);
                        DocApproval.SETRANGE("Document No", '');
                        DocApproval.SETFILTER("Line No", '<>%1', 0);
                        DocApproval.SETFILTER(DocApproval."Approvar ID", '<>%1', '');
                        //IF DocApproval.FIND('-') THEN
                        IF DocApproval.COUNT = 0 THEN
                            ERROR('There is no Appover for this document');
                        //ALLE-PKS35


                        //NDALLE 040208
                        RecuserSetup2.RESET;
                        RecuserSetup2.SETCURRENTKEY(RecuserSetup2."Purchase Resp. Ctr. Filter", RecuserSetup2."User ID");
                        RecuserSetup2.SETRANGE("User ID", USERID);
                        RecuserSetup2.SETFILTER("Purchase Resp. Ctr. Filter", '<>%1', '');
                        IF RecuserSetup2.FINDFIRST THEN BEGIN
                            IF RecResponsibilityCenter2.GET(RecuserSetup2."Purchase Resp. Ctr. Filter") THEN
                                RespCode := RecResponsibilityCenter2.Code;
                        END;

                        PoHdr2.RESET;
                        PoHdr2.SETCURRENTKEY(Indentor, "Shortcut Dimension 1 Code", "Document Type", "Indent Status");
                        PoHdr2.SETFILTER(Indentor, USERID);
                        PoHdr2.SETFILTER(PoHdr2."Shortcut Dimension 1 Code", '=%1', RespCode);
                        PoHdr2.SETFILTER("Document Type", '=%1', PoHdr2."Document Type"::Indent);
                        PoHdr2.SETFILTER("Indent Status", '=%1', PoHdr2."Indent Status"::Open);
                        PoHdr2.SETFILTER("Sub Document Type", '=%1', PoHdr2."Sub Document Type"::Others);
                        IF PoHdr2.FINDFIRST THEN BEGIN
                            REPEAT
                                PoLn2.RESET;
                                PoLn2.SETRANGE("Document Type", PoHdr2."Document Type");
                                PoLn2.SETRANGE("Document No.", PoHdr2."Document No.");
                                IF NOT PoLn2.FINDFIRST THEN
                                    ERROR('Please check there is already a Blank Indent \No.= %1 \USERID = %2', PoHdr2."Document No.", USERID);
                            UNTIL PoHdr2.NEXT = 0;
                        END;
                        //NDALLE 040208


                        IF CONFIRM('Are you sure you want to create Indent', TRUE) THEN BEGIN
                            //JPL03 START
                            IndHdr.INIT;
                            IndHdr."Document Type" := IndHdr."Document Type"::Indent;
                            IndHdr."Document No." := '';
                            IndHdr."Sub Document Type" := IndHdr."Sub Document Type"::Others;
                            IndHdr.INSERT(TRUE);
                            PAGE.RUN(PAGE::"Requisition Header", IndHdr);
                        END;
                    end;
                }
            }
            group("Requisition Pending")
            {
                Caption = 'Requisition Pending';
                action("FA-Purchase/Transfer Requisition Pending")
                {
                    Caption = 'FA-Purchase/Transfer Requisition Pending';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(false),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER(FA));
                }
                action("FA-Sale Requisition Pending")
                {
                    Caption = 'FA-Sale Requisition Pending';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(false),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER("FA Sale"));
                }
                action("Man Power Requisition Pending")
                {
                    Caption = 'Man Power Requisition Pending';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(false),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER("Man Power"));
                }
                action("Hire Requisition pending")
                {
                    Caption = 'Hire Requisition pending';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(false),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER(Hire));
                }
                action("Travel Requisition Pending")
                {
                    Caption = 'Travel Requisition Pending';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(false),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER(Travel));
                    Visible = false;
                }
                action("Leave Requisition Pending")
                {
                    Caption = 'Leave Requisition Pending';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(false),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER(Leave));
                    Visible = false;
                }
                action("Other Requisition Pending")
                {
                    Caption = 'Other Requisition Pending';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(false),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER(Others));
                }
            }
            group("Requisition Approved")
            {
                Caption = 'Requisition Approved';
                action("FA-Purchase/Transfer Requisition Approved")
                {
                    Caption = 'FA-Purchase/Transfer Requisition Approved';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(true),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER(FA));
                }
                action("FA-Sale Requisition Approved")
                {
                    Caption = 'FA-Sale Requisition Approved';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(true),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER("FA Sale"));
                }
                action("Man Power Requisition Approved")
                {
                    Caption = 'Man Power Requisition Approved';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(true),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER("Man Power"));
                }
                action("Hire Requisition Approved")
                {
                    Caption = 'Hire Requisition Approved';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(true),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER(Hire));
                }
                action("Travel Requisition Approved")
                {
                    Caption = 'Travel Requisition Approved';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(true),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER(Travel));
                    Visible = false;
                }
                action("Leave Requisition Approved")
                {
                    Caption = 'Leave Requisition Approved';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(true),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER(Leave));
                    Visible = false;
                }
                action("Other Requisition Approved")
                {
                    Caption = 'Other Requisition Approved';
                    RunObject = Page "Requisition Header";
                    RunPageView = SORTING("Document Type", "Document No.")
                                  ORDER(Ascending)
                                  WHERE("Document Type" = FILTER(Indent),
                                        Approved = FILTER(true),
                                        "Indent Status" = FILTER(Open),
                                        "Sub Document Type" = FILTER(Others));
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        /*
        CurrPAGE.Items.ENABLED :=
          MainMenuPermissionMgt.EnableMenuItem(DATABASE::Item,PAGE::"Item Card");
        CurrPAGE."Transfer Orders".ENABLED :=
          MainMenuPermissionMgt.EnableMenuItem(DATABASE::"Transfer Header",PAGE::"Transfer Order");
        CurrPAGE."Posted Transfer Shipments".ENABLED :=
          MainMenuPermissionMgt.EnableMenuItem(DATABASE::"Transfer Shipment Header",PAGE::"Posted Transfer Shipment");
        CurrPAGE."Posted Transfer Receipts".ENABLED :=
          MainMenuPermissionMgt.EnableMenuItem(DATABASE::"Transfer Receipt Header",PAGE::"Posted Transfer Receipt");
        CurrPAGE."Item Registers".ENABLED :=
          MainMenuPermissionMgt.EnableMenuItem(DATABASE::"G/L Register",PAGE::"G/L Registers");
        CurrPAGE.Navigate.ENABLED :=
          MainMenuPermissionMgt.EnableMenuItem(DATABASE::"Document Entry",PAGE::Navigate);
         */
        //ALLEAB
        RecuserSetup.RESET;
        RecuserSetup.SETRANGE("User ID", USERID);
        RecuserSetup.SETFILTER(RecuserSetup."Purchase Resp. Ctr. Filter", '<>%1', '');
        IF RecuserSetup.FIND('-') THEN BEGIN
            IF RecResponsibilityCenter.GET(RecuserSetup."Purchase Resp. Ctr. Filter") THEN
                CurrPage.CAPTION := RecResponsibilityCenter.Code + '  ' + RecResponsibilityCenter.Name;
        END
        ELSE
            ERROR('Sorry, You have not selected Proper Responsibility Center, Please LOGIN again with proper Responsibility Center');
        //ALLEAB

    end;

    var
        ItemJnlManagement: Codeunit ItemJnlManagement;
        GRNHeader: Record "GRN Header";
        RecuserSetup: Record "User Setup";
        TransHead: Record "Transfer Header";
        IndHdr: Record "Purchase Request Header";
        RecResponsibilityCenter: Record "Responsibility Center 1";
        DocApproval: Record "Document Type Approval";
        PoHdr2: Record "Purchase Request Header";
        PoLn2: Record "Purchase Request Line";
        RecuserSetup2: Record "User Setup";
        RecResponsibilityCenter2: Record "Responsibility Center 1";
        RespCode: Code[20];
        GRNHeader2: Record "GRN Header";
        GRNLine2: Record "GRN Line";
        Text19037141: Label 'Requisition';
}

