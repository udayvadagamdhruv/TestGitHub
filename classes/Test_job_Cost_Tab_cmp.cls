@IsTest

public class Test_job_Cost_Tab_cmp {
    
    @testSetup public static void SetupData(){
        
        Client__c c=new Client__c(name='Manikanta Kurella');
        insert c;
        
        Vendor__c v=new Vendor__c(name='test Vendor');
        insert v;
        
        GL_Department__c testGLD = new GL_Department__c(Name='GLD1232');
        insert testGLD;
        
        GL_Code__c testGL=new GL_Code__c(Name='GLC1232',GL_ID__c='GLC1232',GL_Department__c = testGLD.id,Unit_Cost__c=200);
        insert testGL;
        
        Campaign__c testCampaign1=new Campaign__c(Name='C1232',Active__c=True,Status__c='Active',Budgeted_Cost__c=5000,Actual_Cost__c=6000);
        insert testCampaign1;
        
        Media_Type__c testMedia=new Media_Type__c(Name='Test Media 614');
        insert testMedia;
        
        Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 614',Media_Types__c=testMedia.Id);
        insert testST;
        
        Schedule_Task__c testSchedule1=new Schedule_Task__C(Name='Test Schedule Task 914',Schedule_Template__c=testST.id,Days__c=3);
        insert testSchedule1;
        
        Schedule_Task__c testSchedule2=new Schedule_Task__C(Name='Test Schedule Task 915',Schedule_Template__c=testST.id,Days__c=3);
        insert testSchedule2;
        
        ScheduleTaskRole__c testSTR1=new ScheduleTaskRole__c(Name='Designer',Schedule_Task__c=testSchedule1.id);
        insert testSTR1;
        
        Job__c testJob1=new Job__c(Name='Test Job 614',Campaign__c=testCampaign1.Id,Start_Date__c=System.Today(),Status__c='Active',Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,JS_Client__c=c.id,Schedule_Calc__c='Start Date');
        insert testJob1;
        
        test.startTest();
        
        Job_Task__c testJobTask1=new Job_Task__c(Name='Job Task 615',Job__c=testJob1.Id,Marked_Done__c=True,Days__c=2,Task_Order__c = 1,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        insert testJobTask1;
        
        list<Job_Task__c> Jobtasklist=new list<Job_Task__c>();
        
        Job_Task__c testJobTask2=new Job_Task__c(Name='Job Task 616',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 2,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        Jobtasklist.add(testJobTask2);
        
        Job_Task__c testJobTask3=new Job_Task__c(Name='Job Task 617',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=3,Task_Order__c = 3,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        Jobtasklist.add(testJobTask3);
        
        insert Jobtasklist;    
        
        Job_Task_Role__c testJTR1=new Job_Task_Role__c(Name='Designer',Job_Task__c=testJobTask1.Id,User__c='Sugunakar Routhu');
        insert testJTR1;
        
        Job_Task_Role__c testJTR11=new Job_Task_Role__c(Name='Designer',Job_Task__c=testJobTask1.Id,User__c='Upendra Routhu');
        insert testJTR11;
        
        Job_Task_Role__c testJTR111=new Job_Task_Role__c(Name='Designer',Job_Task__c=testJobTask1.Id,User__c='Manikanta Kurella');
        insert testJTR111;
        
        Job_Task_Role__c testJTR22=new Job_Task_Role__c(Name='Project Manager',Job_Task__c=testJobTask2.Id,User__c='Sugunakar Routhu');
        insert testJTR22;
        
        Job_Task__c taskViewJobTask1=new Job_Task__c(Name='Job Task View',Job__c=testJob1.Id,Marked_Done__c=False,Days__c=2,Task_Order__c = 1,Start_Date__c=System.Today(),Due_Date__c=System.Today()+15,Revised_Due_Date__c=System.Today()+15,Email__C='mani@gmail.com,sugu@gmail.com');
        insert taskViewJobTask1;
        
        Job_Task_Role__c tViewJTR1=new Job_Task_Role__c(Name='Designer',Job_Task__c=taskViewJobTask1.Id);
        insert tViewJTR1;
        
        Job_Task_Role__c tViewJTR2=new Job_Task_Role__c(Name='Project Manager',Job_Task__c=taskViewJobTask1.Id);
        insert tViewJTR2;
        
        Tag__c testTag = new Tag__c(Name='Test Tag 622',Job__c=testjob1.Id);
        insert testTag;
        
        Quote__c Quote=new Quote__c(Name='Quote 606',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Approved__c=false,Quantity__c=5000.00,GL_Code__c=testGL.Id);
        insert Quote;
        
        Quote__c Quote1=new Quote__c(Name='Quote 303',Job__c=testjob1.Id,GL_Department__c=testGLD.id,Approved__c=false,Quantity__c=5000.00,GL_Code__c=testGL.Id);
        insert Quote1;
        
        Quote_Spec_Item__c QuoteSpec=new Quote_Spec_Item__c(Name='Spec1', Quote__c=Quote.Id);
        insert QuoteSpec;
        
        Quote_Spec_Item__c QuoteSpec1=new Quote_Spec_Item__c(Name='Spec2', Quote__c=Quote.Id);
        insert QuoteSpec1;
        
        Quote_Spec_Item__c QuoteSpec2=new Quote_Spec_Item__c(Name='Spec3', Quote__c=Quote1.Id);
        insert QuoteSpec2;
        
        Vendor_GL_Code__c VGLC=new Vendor_GL_Code__c(Vendor__c=v.Id,GL_Code__c=testGL.Id);
        insert VGLC;
        
        Vendor_Quote__c VQ=new Vendor_Quote__c(Quote__c=Quote.Id,Vendor__c=v.Id,Date__c=System.Today(),Amount__c=500,Restrict__c = true);
        insert VQ;
        
        Vendor_Quote__c VQ1=new Vendor_Quote__c(Quote__c=Quote1.Id,Vendor__c=v.Id,Date__c=System.Today(),Amount__c=500,Restrict__c = true);
        insert VQ1;
        
        Estimate_Line_Items__c est1=new Estimate_Line_Items__c(Name='Estimate test-1',Vendor__c=v.Id,Quantity__c=2,Job__c= testJob1.id,Quote__c=Quote.Id,Shippment_status__c='In Progress'	);
        insert est1;
        
        Estimate_Line_Items__c est2=new Estimate_Line_Items__c(Name='Estimate test-2',Job__c= testJob1.id,Quote__c=Quote.Id);
        insert est2;
        
        Production_Estimate__c pesttag1 = new Production_Estimate__c (Name='pe1 test',Quantity__c=2,Job__c= testJob1.id,Quote__c=Quote.Id,Shippment_status__c='In Progress');
        insert pesttag1 ;
        
        Production_Estimate__c pesttag2 = new Production_Estimate__c (Name ='pe2 test',Job__c= testJob1.id,Quote__c=Quote.Id) ;
        insert pesttag2 ;
        
        Shipment__c testI=new Shipment__c(Client__c=c.Id,Job__c=testJob1.Id);
        insert testI;
        
        Shipment_Line_Item__c sli=new Shipment_Line_Item__c(Shipment__c=testI.id,Production_Estimate__c=pesttag1.id);
        insert sli;
        
        Vendor_Contact__c VC=new Vendor_Contact__c(first_name__c='Vendor',Vendor__c=v.id,last_name__c='Con');
        insert VC;
        
        Purchase_Order__c testpo=new Purchase_Order__c(name='Sugunakar',job__c=testJob1.id,Vendor__c=v.id,Vendor_Contact__c=VC.id);
        insert testpo;
        
        job_Cost_Tab_cmp.duplicateProEst((string)pesttag1.Id);
        job_Cost_Tab_cmp.updateQuoteSpecs(new list<Quote_Spec_Item__c>{QuoteSpec});
        Material_Item__c mi=new Material_Item__c(name='mi');
         insert mi;
        Production_Estimate_Template__c petemps=new Production_Estimate_Template__c(name='temp');
        insert petemps;
         Production_Estimate_Temp_Line_Items__c petemp=new Production_Estimate_Temp_Line_Items__c(Name='peTemp1',Calc_Unit__c='Each',Sort_Order__c=1,SheetQtyUpforUsed__c=1,EachQtyUpforUsed__c=2,
            GL_Code__c=testGL.id,GL_Department__c=testGLD.id,Vendor__c=v.id,Material_Item__c=mi.id,Qty_Up__c=3,Production_Estimate_Template__c=petemps.id,Quantity__c=2,of_Pages__c=1,Width_in_Inches__c=1);
         insert petemp;
        job_Cost_Tab_cmp.ImportProEstTemp(petemps.id,testJob1.id);
        test.stopTest();
        
    }
    
    public static testMethod void Test_job_Cost_Tab_Quote(){    
        
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];  
        List<Quote__c> QuoteList=[Select id,name from Quote__c where job__c=:testJob1.Id];
        List<Vendor_Quote__c> VQList=[select Id,Name,Date__c,Amount__c,Vendor__c,Vendor__r.Id,Vendor__r.Name,Restrict__c,Quote__c from Vendor_Quote__c];
        GL_Department__c GlDep =[SELECT Id,Name FROM GL_Department__c where Name='GLD1232'];
        GL_Code__c GlC =[SELECT Id,Name FROM GL_Code__c where Name='GLC1232'];
        Production_Spec_Template__c testPST=new Production_Spec_Template__c(Name='PST0001');
        insert testPST;
        Production_Spec_Item__c testPSI=new Production_Spec_Item__c(Name='TestPSI0001',Production_Spec_Template__c=testPST.Id);
        insert testPSI;
        Production_Estimate__c pe=[select id from Production_Estimate__c where name ='pe1 test'];
        Production_Estimate_Spec_Item__c pspec=new Production_Estimate_Spec_Item__c(Name='pspec',Production_Estimate__c=pe.id);
        insert(pspec);
        test.startTest();
        job_Cost_Tab_cmp.getQuotePermiossions();       
        job_Cost_Tab_cmp.getPEPermiossions();
        job_Cost_Tab_cmp.getLabelforAllObjects();
        job_Cost_Tab_cmp.getquoterecords(testJob1.Id);
        job_Cost_Tab_cmp.updateQuotes(QuoteList);
        job_Cost_Tab_cmp.importProTemplateSpecsForQuotes(QuoteList[0].Id,testPST.Id);
        job_Cost_Tab_cmp.OrganizationIdsBasedOnpages('InvoiceFromPo');
        job_Cost_Tab_cmp.showProductionEstimate();
        job_Cost_Tab_cmp.getFieldsforObject('Job__c');
        job_Cost_Tab_cmp.geLabelforObject('Account');
        job_Cost_Tab_cmp.getGLDepartments();
        job_Cost_Tab_cmp.getGLCodes(GlDep.Name);
        job_Cost_Tab_cmp.getamount(GlC.Id);
        job_Cost_Tab_cmp.getVendors(GlC.Id);
        job_Cost_Tab_cmp.getquotespecList(QuoteList[0].Id);
        job_Cost_Tab_cmp.getEstPermiossions();
        job_Cost_Tab_cmp.getShipPermiossions();
        job_Cost_Tab_cmp.getPOPermiossions();
        job_Cost_Tab_cmp.getVIPermiossions();
        job_Cost_Tab_cmp.getObjectType(new list<string>{'job__c'});
        job_Cost_Tab_cmp.getProductioneEstimateSpecItems(pspec.id);
        job_Cost_Tab_cmp.updateProEstimateSpecs(new list<Production_Estimate_Spec_Item__c>{pspec});
        job_Cost_Tab_cmp.deleteProductionEstimateSpecItem(pspec.id);
        test.stopTest();
    }
    
    public static testMethod void Test_job_Cost_Tab_VendorQuote(){    
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];  
        List<Quote__c> QuoteList=[Select id,name from Quote__c where job__c=:testJob1.Id]; 
        List<Vendor_Quote__c> VQList=[select Id,Name,Date__c,Amount__c,Vendor__c,Vendor__r.Id,Vendor__r.Name,Restrict__c,Quote__c from Vendor_Quote__c];
        Quote_Spec_Item__c QS=[SELECT Id,Name FROM Quote_Spec_Item__c where Name='Spec3'];
        
        test.startTest();
        
        job_Cost_Tab_cmp.getVendorQuoteList(QuoteList[0].Id);
        job_Cost_Tab_cmp.updateVendorQuotes(VQList);
        job_Cost_Tab_cmp.getVendorQuote(QuoteList[0].Id);
        job_Cost_Tab_cmp.vendorUnapproved(QuoteList[0].Id);
        job_Cost_Tab_cmp.vendorapproved(VQList[0].Id);
        //job_Cost_Tab_cmp.vendorQuoteDelete(VQList[0].Id);
        
        ProductionEstimate__c jscntrls= new  ProductionEstimate__c(Active__c= True);
        insert jscntrls;
        
        job_Cost_Tab_cmp.vendorUnapproved(QuoteList[1].Id);
        job_Cost_Tab_cmp.vendorapproved(VQList[0].Id);
        
        
        job_Cost_Tab_cmp.vendorQuoteDelete(VQList[0].Id);
        job_Cost_Tab_cmp.deleteQuoteSpec(QS.Id);
        job_Cost_Tab_cmp.DeleteQuote(QuoteList[0].Id);
        test.stopTest();
    }
    
    public static testMethod void Test_job_Cost_Tab_DeleteTask(){  
        test.startTest();
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];  
        list<Job_Task__c> Jobtsklist=[Select id,name from Job_Task__c where job__c=:testJob1.Id]; 
        job_Cost_Tab_cmp.DeleteTaskDetail(Jobtsklist[0].Id);
        job_Cost_Tab_cmp.getEstimateRecords(testJob1.Id);
        test.stopTest();
    }
    
    public static testMethod void Test_job_Cost_Tab_Est(){  
        test.startTest();
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];  
        List <Estimate_Line_Items__c> EstList=[select id,Name,Job__c from Estimate_Line_Items__c where job__c=:testJob1.Id];
        
        Production_Spec_Template__c testPST=new Production_Spec_Template__c(Name='PST0001');
        insert testPST;
        
        Production_Spec_Item__c testPSI=new Production_Spec_Item__c(Name='TestPSI0001',Production_Spec_Template__c=testPST.Id);
        insert testPSI;
        
        Estimate_Spec_Item__c EstSpecItem=new Estimate_Spec_Item__c(Name='TestPSI0001',Estimates__c=EstList[0].Id);
        insert EstSpecItem;
        
        Production_Estimate__c pesttag1 = new Production_Estimate__c (Name='pe1 test',Job__c= testJob1.id);
        insert pesttag1 ;
        
        Production_Estimate__c pesttag2 = new Production_Estimate__c (Name ='pe2 test',Job__c= testJob1.id) ;
        insert pesttag2 ;
        Material_Item__c mi=new Material_Item__c();
         insert mi;
        Material_Usage_line_item__c mu1=new Material_Usage_line_item__c(Material_Item__c=mi.id,Qty_On_Hand__c=2,Production_Estimate__c=pesttag1.Id);
        insert mu1;
       
        job_Cost_Tab_cmp.updateEst(EstList);
        job_Cost_Tab_cmp.duplicateEtimate(EstList[0].Id);
        job_Cost_Tab_cmp.getestimateSpecItems(EstList[0].Id);
        job_Cost_Tab_cmp.getProductionSpecTemplate();
        job_Cost_Tab_cmp.importProTemplateSpecs(EstList[0].Id,testPST.Id);
        job_Cost_Tab_cmp.DeleteEstSpecRecord(EstSpecItem.Id);
        
        job_Cost_Tab_cmp.getProductionEstimateRecords(pesttag1.Id);
        job_Cost_Tab_cmp.approveProEst((string)pesttag1.Id);
        job_Cost_Tab_cmp.unApproveProEst((string)pesttag1.Id);
        
        job_Cost_Tab_cmp.getProEstTempforProEst();
        test.stopTest();
    }
   
    public static testMethod void Test_job_Cost_Tab_Est2(){    
        test.startTest();
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];  
        List <Estimate_Line_Items__c> EstList=[select id,Name,Job__c from Estimate_Line_Items__c where job__c=:testJob1.Id];
        job_Cost_Tab_cmp.approveEstimate(EstList[0].Id);
        job_Cost_Tab_cmp.unapproveEstimate(EstList[0].Id);
        job_Cost_Tab_cmp.deleteEst(EstList[0].Id);
        job_Cost_Tab_cmp.getTotalAmountForSections('Est',testJob1.Id);
        job_Cost_Tab_cmp.getTotalAmountForSections('PO',testJob1.Id);
        job_Cost_Tab_cmp.getTotalAmountForSections('Inv',testJob1.Id);
        job_Cost_Tab_cmp.getTotalAmountForSections('ProEst',testJob1.Id);
        job_Cost_Tab_cmp.getApprovedEstLI('test Vendor',testJob1.Id);
        test.stopTest();
    }
    
    public static testMethod void Test_job_Tags(){    
        test.startTest();
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];  
        Tag__c testTag1 = new Tag__c(Name='Test Tag 62',Job__c=testjob1.Id);
        insert testTag1;
        Graphics_Deliverables__c testGD1=new Graphics_Deliverables__c(Name='Test Graphics 1777',Job__c=testjob1.Id,Graphics_Description__c='Test Graphics Desc 1777',Graphics_Note__c='Test Graphics Note 1777',Graphics_Type__c='Test Graphics Type 1777');   
        insert testGD1;
        Timesheet_Entries__c objJSTS = new Timesheet_Entries__c();
        objJSTS.Job__c = testjob1.Id;
        objJSTS.Date__c = Date.Today();
        objJSTS.Notes__c = 'Test-Worked on task 1 today';
        objJSTS.Hours_Worked__c = 10;
        objJSTS.User__c = UserInfo.getUserId();
        insert objJSTS;
        
        Client__c Cl=new Client__c(Name='test Client');
        insert Cl;
        Client_Invoice__c testClientInv = new Client_Invoice__c (Name='INV01March',Job__c=testJob1.Id,Client_Name__c=Cl.Id);
        insert testClientInv;
        job_Cost_Tab_cmp.DeleteTag(testTag1.Id);
        job_Cost_Tab_cmp.DeleteGD(testGD1.Id);
        job_Cost_Tab_cmp.DeleteCLI(testClientInv.Id);
        job_Cost_Tab_cmp.DeleteTSDetail(objJSTS.Id);
        test.stopTest();
    }
    
    public static testMethod void Test_job_Cost_Tab_PO(){    
        test.startTest();
        Vendor__c v=new Vendor__c(name='test Vendor1');
        insert v;
        
        Vendor_Contact__c VC=new Vendor_Contact__c(first_name__c='Vendor',Vendor__c=v.id,last_name__c='Con');
        insert VC;
        
        Job__c testJob1=[select Id,Name from Job__c where Name='Test Job 614'];  
        
        Purchase_Order__c testpo=new Purchase_Order__c(name='Sugunakar',job__c=testJob1.id,Vendor__c=v.id,Vendor_Contact__c=VC.id);
        insert testpo;
        
        Purchase_Order__c testpo1=new Purchase_Order__c(name='Mani',job__c=testJob1.id,Vendor__c=v.id,Vendor_Contact__c=VC.id);
        insert testpo1;
      	Production_Estimate__c pe=[select id,Quantity__c,Job__c,Total_Cost__c,GL_Code__c from Production_Estimate__c where name='pe1 test'];
       List <Estimate_Line_Items__c> EstList=[select id,Name,Job__c,Total_Amount__c,GL_Code__c from Estimate_Line_Items__c where job__r.name='Test Job 614'];
        List <Purchase_Order__c> POList=[select id,Name,Job__c from Purchase_Order__c where job__c=:testJob1.Id];
        PO_Line_Item__c poli=new PO_Line_Item__c(Purchase_Order__c=testpo1.id,Estimate_Line_Item__c=EstList[0].id,Production_Estimate__c=pe.id);
        insert poli;
        job_Cost_Tab_cmp.getPORecords(testJob1.Id);
        job_Cost_Tab_cmp.updatePO(POList);
        job_Cost_Tab_cmp.getPOVendors(testJob1.Id);
        job_Cost_Tab_cmp.getVendorContact(VC.Name);
        
        job_Cost_Tab_cmp.getPOLineItems(testpo1.Id);
        job_Cost_Tab_cmp.insertEstLI_PELI(testpo1.Id,new list<SObject>{EstList[0]});
       
        job_Cost_Tab_cmp.PoLineItemsFromPo(testpo1.Id);
         ProductionEstimate__c jscntrls= new  ProductionEstimate__c(Active__c=true);
        insert jscntrls;
        job_Cost_Tab_cmp.getPOVendors(testJob1.Id);
          job_Cost_Tab_cmp.PoLineItemsFromPo(testpo1.Id);
        job_Cost_Tab_cmp.insertEstLI_PELI(testpo1.Id,new list<SObject>{pe});
       
        job_Cost_Tab_cmp.deletePOLI(poli.id);
        job_Cost_Tab_cmp.deletePO(testpo1.Id);
        job_Cost_Tab_cmp.getStaffs();
        job_Cost_Tab_cmp.getINVLIGLCode(v.Id);
        test.stopTest();
    }
    
    public static testMethod void Test_job_Cost_Tab_Inv(){    
        test.startTest();
        job__c job=new job__c(Name='testjob');
        insert job;
        Invoice__c Inv=new Invoice__c(Name='Inv',job__c=job.id);
       // insert Inv;
        Invoice__c Inv1=new Invoice__c(Name='Inv1',job__c=job.id);
        insert Inv1;
        
        Invoice__c ESI = new Invoice__c(Name='INV01March',Job__c=job.id);
        insert ESI;
        string theid=ESI.id;
        GL_Department__c testGLD = new GL_Department__c(Name='TestGLD1101');
        insert testGLD;
        
        GL_Code__c testGL=new GL_Code__c(Name='GL Code 1101',GL_ID__c='TestGL9988',GL_Department__c = testGLD.id);
        insert testGL;
        
        Vendor__c v = new Vendor__c(Name = 'Tset');
        
        Estimate_Line_Items__c eli = new Estimate_Line_Items__c(Name = 'Test Eli', GL_Department__c = testGLD.Id, GL_Code__c = testGL.Id,Job__c = job.Id,Quantity__c = 12,Vendor__c = v.Id);
        
        Invoice_Line_Item__c ili = new Invoice_Line_Item__c(Invoice__c = ESI.Id,GL_Code__c = testGL.Id,Amount__c = 100,Estimate_Line_Item__c = eli.Id );
        insert ili;
        
        
        List <Invoice__c> InvList=[select id,name,job__c from Invoice__c where job__c=:job.id];
        List <Invoice_Line_Item__c> InvLIList=[select id,name,Invoice__c from Invoice_Line_Item__c where Invoice__c=:ESI.id];
        
        job_Cost_Tab_cmp.getVendorInvRecords(job.Id);
        job_Cost_Tab_cmp.getInvVendors();
        job_Cost_Tab_cmp.updateInv(InvList);
        job_Cost_Tab_cmp.getInvLineItems(ESI.Id);
        job_Cost_Tab_cmp.updateInvLI(InvLiList);
        job_Cost_Tab_cmp.deleteInvLI(ili.Id);
        job_Cost_Tab_cmp.deleteInv(Inv1.Id);
        test.stopTest();
    }
  
    
    public static testMethod void Test_job_Cost_Tab_Shp(){    
        test.startTest();
        job__c job=new job__c(Name='testjob');
        insert job;
        
        Client__c c=new Client__c(name='Manikanta K');
        insert c; 
        
        Shipment__c testI=new Shipment__c(Client__c=c.Id,Job__c=job.Id);
        insert testI;
        
        Shipment__c testI2=new Shipment__c(Client__c=c.Id,Job__c=job.Id);
        insert testI2;
        
        Shipment__c testI3=new Shipment__c(Client__c=c.Id,Job__c=job.Id);
        insert testI3;
        
        list<Shipment__c> ShpList=[select id,name from Shipment__c];
        
        Shipment_Line_Item__c sli=new Shipment_Line_Item__c(Shipment__c=testI.id);
        insert sli;
        
        Shipment_Line_Item__c shpli=new Shipment_Line_Item__c(Shipment__c=testI.id);
        insert shpli;
        
        list<Shipment_Line_Item__c> listShipmentitems = new list<Shipment_Line_Item__c>();
        listShipmentitems = [SELECT id,name,Shipment__c,Item_Status__c FROM Shipment_Line_Item__c WHERE Shipment__c=:testI.id];
        
        job_Cost_Tab_cmp.getShipmentrecords(testI.Id);
        job_Cost_Tab_cmp.updateShp(ShpList);
        job_Cost_Tab_cmp.DeleteShp(testI2.Id);
        job_Cost_Tab_cmp.getShipmentLIrecords(sli.Id);
        job_Cost_Tab_cmp.updateShpLI(listShipmentitems);
        job_Cost_Tab_cmp.deleteShpLI(shpli.Id);
        ProductionEstimate__c jscntrls= new  ProductionEstimate__c(Active__c=true);
        insert jscntrls;
        job_Cost_Tab_cmp.deleteShpLI(sli.Id);
        job_Cost_Tab_cmp.getMatereialItems('Size');
        job_Cost_Tab_cmp.AddShipmentLIrecords(testI.Id);
        //job_Cost_Tab_cmp.SaveShpLineItems();
        test.stopTest();
    }
     public static testMethod void deletemethod(){
         
         Production_Estimate__c pe=[select id,Quantity__c,Job__c from Production_Estimate__c where name='pe1 test'];
         Shipment__c ship=[select id from Shipment__c ];
         Estimate_Line_Items__c est=[select id,Quantity__c from Estimate_Line_Items__c where name='Estimate test-1'];

         job_Cost_Tab_cmp.SaveShpLineItems(new list<sobject>{est},ship.id);
         ProductionEstimate__c jscntrls= new  ProductionEstimate__c(Active__c=true);
         insert jscntrls;
         job_Cost_Tab_cmp.SaveShpLineItems(new list<sobject>{pe},ship.id);
       
         job_Cost_Tab_cmp.deleteProEst(pe.Id);
    }
    
}