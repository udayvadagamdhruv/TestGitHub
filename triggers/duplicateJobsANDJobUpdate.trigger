trigger duplicateJobsANDJobUpdate on Job__c(before insert, before update, after insert, after update, before delete, after delete) {
    
    set < Id > CampIds = new set < Id > ();
    List < Job__c > lstAllJobs = new List < Job__c > ();
    //When adding new Job or updating existing Jobs
    if (trigger.isInsert || trigger.isUpdate) {
        lstAllJobs = trigger.new;
    }
    
    // Old Values when updating and Deleting the jobs.
    if (trigger.isUpdate || trigger.isDelete) {
        lstAllJobs = trigger.old;
        
    }
    if((Trigger.isAfter) && (Trigger.isInsert || trigger.isUpdate || trigger.isDelete)){
        
        for (Job__c job: lstAllJobs) {
            if (job.Campaign__c != NULL) {
                CampIds.add(job.Campaign__c);
            }
        }
        
        //Map will contain one Campaign Id to one sum value
        map < Id, Double > Camp_BA_Map = new map < Id, Double > ();
        map < Id, Double > Camp_AC_Map = new map < Id, Double > ();
        map < Id, Double > Camp_ES_Map = new map < Id, Double > (); //added by yogini on 7May13
        
        //Produce a sum of Budgeted_Cost__c of Job and add them to the map
        //use group by to have a single Campaign Id with a single sum value
        //Yogini 07May13 - changed the query added aggrigate funtion for estimate total
        
        list <AggregateResult> Agg = [select Campaign__c, sum(Budgeted_Cost__c), sum(Invoice_Actual_Amounts__c), sum(Estimate_Total__c) from Job__c where Campaign__c IN: CampIds WITH SECURITY_ENFORCED group by Campaign__c];
        for (AggregateResult q: Agg) {
            Camp_BA_Map.put(String.valueOf(q.get('Campaign__c')), Double.valueOf((q.get('expr0') == null) ? 0 : q.get('expr0')));
            Camp_AC_Map.put(String.valueOf(q.get('Campaign__c')), Double.valueOf((q.get('expr1') == null) ? 0 : q.get('expr1')));
            Camp_ES_Map.put(String.valueOf(q.get('Campaign__c')), Double.valueOf((q.get('expr2') == null) ? 0 : q.get('expr2'))); //added by yogini 07May13
        }
        system.debug('map for estimate---->' + Camp_ES_Map);
        
        List<Campaign__c> CampaignToUpdate = new List<Campaign__c>();
        
        //Run the for loop on Campaign using the non-duplicate set of Campaigns Ids
        //Get the sum value from the map and create a list of Campaigns to update
        //07May13 - yogini added job estimate field in select - 08May13 Dummy_Currency_2__c
        for (Campaign__c o: [Select Id, Budgeted_Cost__c,Actual_Cost__c, Job_Estimates__c from Campaign__c where Id IN: CampIds WITH SECURITY_ENFORCED]) {
            Double BudgetedSum = Camp_BA_Map.get(o.Id);
            Double ActualCost = Camp_AC_Map.get(o.Id);
            Double EstimateTotal = Camp_ES_Map.get(o.Id); //added by yogini on 07May13
            if(Schema.sObjectType.Campaign__c.fields.Actual_Cost__c.isUpdateable()){
                o.Actual_Cost__c = ActualCost;}
            if (o.Actual_Cost__c == Null) {
                if(Schema.sObjectType.Campaign__c.fields.Actual_Cost__c.isUpdateable()){
                    o.Actual_Cost__c = 0.00;}
            }
            
            if(Schema.sObjectType.Campaign__c.fields.Budgeted_Cost__c.isUpdateable()){
                o.Budgeted_Cost__c = BudgetedSum;}
            if (o.Budgeted_Cost__c == Null) {
                if(Schema.sObjectType.Campaign__c.fields.Budgeted_Cost__c.isUpdateable()){
                    o.Budgeted_Cost__c = 0.00;}
            }
            
            //Yogini - 08May13 changes done for campaign estimate field - Dummy_Currency_2__c
            if(Schema.sObjectType.Campaign__c.fields.Job_Estimates__c.isUpdateable()){
                o.Job_Estimates__c = EstimateTotal;}
            if (o.Job_Estimates__c == Null) {
                if(Schema.sObjectType.Campaign__c.fields.Job_Estimates__c.isUpdateable()){
                    o.Job_Estimates__c = 0.00;}
            }
            CampaignToUpdate.add(o);
        }
        
        
        
        if (CampaignToUpdate.Size() > 0) {
            if(Schema.sObjectType.Campaign__c.isUpdateable()){
                update CampaignToUpdate;}
        }
        
    }    
    
    // To check for duplicate Jobs
    
    If((Trigger.isBefore && Trigger.isInsert) || (Trigger.isBefore && Trigger.isUpdate) && JobCostReport.firstrun) {
        Map < String, Job__c > jobMap = new Map < String, Job__c > ();
        JobCostReport.firstrun = false;
    } 
    // End of checking for Duplicate Jobs.
    
    
    
    If((Trigger.isBefore && Trigger.isInsert)) {
        
        Boolean jobFlag; //added by yogini on 23-nov-12
        
        for (Job__c j: Trigger.New) {
            jobFlag = j.flag__c;
        }
        
        if (jobFlag == False) {
            
            List < Job__c > lstForNumber=new list<Job__c>();
            //if(UserInfo.getOrganizationId() == '00DG0000000kpp2' || UserInfo.getOrganizationId() == '00DG0000000kpp2MAA')
            //Epson org if condition and first org id in below if condition belongs to chumash sandbox and second org id belongs to fire eye sandbox.
            if(UserInfo.getOrganizationId()  == '00D7f0000000sfHEAQ' || UserInfo.getOrganizationId() == '00D2f0000008dS0EAI' || UserInfo.getOrganizationId() == '00Dm00000002kRBEAY' || UserInfo.getOrganizationId() == '00D190000004wT0EAI' || UserInfo.getOrganizationId() == '00Dj0000000HwwREAS' || UserInfo.getOrganizationId() == '00DA0000000Cir8MAC' || UserInfo.getOrganizationId() == '00D3F0000004b48UAA' || UserInfo.getOrganizationId() == '00Dm000000092khEAA')
            {
                lstForNumber = [Select Id, Name, Job_Auto_Number__c, Job_Id__c from Job__c where Revision__c != true and Reprint__c != true WITH SECURITY_ENFORCED ORDER BY CreatedDate DESC, Job_Auto_Number__c DESC LIMIT 1];
            }else{
                system.debug('lstForNumber-else-->'+lstForNumber);
                lstForNumber = [Select Id, Name, Job_Auto_Number__c from Job__c where CreatedDate=LAST_N_Days:180 WITH SECURITY_ENFORCED ORDER BY CreatedDate DESC, Job_Auto_Number__c DESC LIMIT 1];
            }
            system.debug('lstForNumber--->'+lstForNumber);
            //  List < Job__c > lstForNumber = [Select Id, Name, Job_Auto_Number__c, Job_Id__c from Job__c where CreatedDate=LAST_N_Days:771 ORDER BY CreatedDate DESC, Job_Auto_Number__c DESC LIMIT 1]; 
            
            String autoFormat, previousJobNumber, separator, strIncre, appendZero, Custom_Setting_Name, Custom_Setting_Format;
            
            Datetime dt;
            
            Integer incre;
            
            List<Job_Number_Setting__c> jc = Job_Number_Setting__c.getall().values();
            if (!jc.isEmpty()) {
                
                Custom_Setting_Name = jc[0].Name;
                if (jc[0].JobNumberFormat__c != null) Custom_Setting_Format = jc[0].JobNumberFormat__c;
            } else {
                Custom_Setting_Name = 'NO';
            }
            
            System.debug('Job Custom Setting Name : ' + Custom_Setting_Name);
            system.debug('Custom setting :' + jc);
            //Integer len=Custom_Setting_Name.length(); // Calculate length of Custom Setting          //commented by yogini on 26-nov-12          
            
            if (lstForNumber.size() == 0) {
                incre = 0;
                if (Custom_Setting_Name == 'NO') {
                    previousJobNumber = '1';
                    autoFormat = '';
                    separator = '';
                } else {
                    separator = Label.JobNumberSeparator;
                    previousJobNumber = '1';
                }
            } else {
                if (Custom_Setting_Name == 'NO') {
                    previousJobNumber = String.valueOf(lstForNumber[0].Job_Auto_Number__c);
                    separator = '';
                } else {
                    //added condition for BMHCC Job# format
                    if (Custom_Setting_Format != null && (UserInfo.getOrganizationId() == '00DE0000000cpPYMAY' || UserInfo.getOrganizationId() == '00DM00000013RmDMAU')) {
                        
                        previousJobNumber = String.valueOf(Custom_Setting_Format);
                        separator = Label.JobNumberSeparator;
                        
                    } else {
                        previousJobNumber = String.valueOf(lstForNumber[0].Job_Auto_Number__c); //added by yogini on 26-nov-12
                        separator = Label.JobNumberSeparator;
                        //String previousJobAuto=String.valueOf(lstForNumber[0].Job_Auto_Number__c);
                        //commented by yogini on 26-nov-12
                        //Integer z=previousJobAuto.length();
                        //previousJobNumber=previousJobAuto.subString(len+1,z); // Fetch NUmber part from previous AutoNUmber
                    }
                    
                }
                //following code is to check whether jobno contains separator..if yes then take the autono only.
                if (previousJobNumber.contains(Label.JobNumberSeparator) == True) //added by yogini on 26-nov-12
                {
                    system.debug('previous job value : ' + previousJobNumber);
                    String JobAutoNoAfterSep = previousJobNumber.substringAfterLast(Label.JobNumberSeparator);
                    previousJobNumber = JobAutoNoAfterSep;
                } //end
                system.debug('New job auto :' + previousJobNumber);
                /*  if(previousJobNumber.contains(' ')){
previousJobNumber=previousJobNumber.split(' ')[0];
}
else{*/
                previousJobNumber=previousJobNumber;
                // }
                system.debug('New job auto :' + previousJobNumber);
                incre = Integer.valueOf(previousJobNumber);
            }
            
            
            
            
            for (Job__c j: Trigger.New) {
                if (j.flag__c == False) {
                    if (Custom_Setting_Name == 'NO') {
                        autoFormat = '';
                        separator = '';
                    }
                    //added condition for BMHCC Job# format - added by yogini on 18-Oct-13
                    else //if(UserInfo.getOrganizationId()== '00DE0000000cpPYMAY' || UserInfo.getOrganizationId()== '00DM00000013RmDMAU'  ) 
                    {
                        autoFormat = Custom_Setting_Name;
                        system.debug('Date Is =====' + autoFormat);
                        separator = Label.JobNumberSeparator;
                    }
                    
                    
                    incre++;
                    strIncre = String.ValueOf(incre);
                    
                    if (strIncre.length() == 1) {
                        appendZero = '00000';
                    } else if (strIncre.length() == 2) {
                        appendZero = '0000';
                    } else if (strIncre.length() == 3) {
                        appendZero = '000';
                    } else if (strIncre.length() == 4) {
                        appendZero = '00';
                    } else if (strIncre.length() == 5) {
                        appendZero = '0';
                    }
                    else{
                        appendZero='';
                    }
                    system.debug('appendZero === '+appendZero);
                    System.debug('New Job Number ' + autoFormat + separator + appendZero + incre);
                    
                    
                    if (UserInfo.getOrganizationId() == '00DE0000000ZEOuMAO') {
                        
                        DateTime dTnow = System.now();
                        Date myDate = date.newinstance(dTnow.year(), dTnow.month(), dTnow.day());
                        string iy = string.valueOf(mydate.year());
                        string iy1 = iy.right(2);
                        autoFormat = iy1;
                        
                        if (j.JS_Client__c != null) {
                            Id str = j.JS_Client__c;
                            system.debug('!!!!!!!!!!!!!!!' + str);
                            Client__c cc = [select Name, Fax__c, id from Client__c where Id = : str WITH SECURITY_ENFORCED];
                            string code = cc.Fax__c;
                            if (code != null) {
                                //j.Job_Auto_Number__c = autoFormat+separator+code+separator+appendZero+incre;
                                if(Schema.sObjectType.Job__c.fields.Job_Auto_Number__c.isCreateable()){
                                    j.Job_Auto_Number__c = autoFormat + separator + code + separator + incre;}
                            } else {
                                if(Schema.sObjectType.Job__c.fields.Job_Auto_Number__c.isCreateable()){
                                    j.Job_Auto_Number__c = autoFormat + separator + incre;}
                            }
                        } else {
                            
                            // j.Job_Auto_Number__c = autoFormat+separator+appendZero+incre;
                            if(Schema.sObjectType.Job__c.fields.Job_Auto_Number__c.isCreateable()){
                                j.Job_Auto_Number__c = autoFormat + separator + incre;}
                        }
                    }
                    //added condition for BMHCC Job# format - added by yogini on 18-Oct-13
                    //patch org- 00DA0000000gmzdMAA
                    //baptist sbox - 00DM00000013RmDMAU
                    //baptist production - 00DE0000000cpPYMAY
                    else if (UserInfo.getOrganizationId() == '00DE0000000cpPYMAY' || UserInfo.getOrganizationId() == '00DM00000013RmDMAU') {
                        if(Schema.sObjectType.Job__c.fields.Job_Auto_Number__c.isCreateable()){
                            j.Job_Auto_Number__c = autoFormat + separator + (appendZero + incre).right(4);}
                    }
                    
                    //for fox& CNE organization
                    else if (UserInfo.getOrganizationId() == '00DJ000000371J9MAI' || UserInfo.getOrganizationId() == '00DG0000000k48JMAQ' || UserInfo.getOrganizationId() == '00Di0000000h2KcEAI' || UserInfo.getOrganizationId() == '00De0000005VAQMEA4')
                        
                    {
                        if(Schema.sObjectType.Job__c.fields.Job_Auto_Number__c.isCreateable()){
                            j.Job_Auto_Number__c = autoFormat + separator + incre;}
                    }
                    
                    //Epson org job# Revision
                    else if ((UserInfo.getOrganizationId() == '00Dm00000002kRBEAY' || UserInfo.getOrganizationId() == '00D190000004wT0EAI' || UserInfo.getOrganizationId() == '00DA0000000Cir8MAC' || UserInfo.getOrganizationId() == '00Dj0000000HwwREAS' || UserInfo.getOrganizationId() == '00D3F0000004b48UAA' || UserInfo.getOrganizationId() == '00Dm000000092khEAA') && j.Revision__c == true) {
                        if(Schema.sObjectType.Job__c.fields.Job_Auto_Number__c.isCreateable()){
                            j.Job_Auto_Number__c = j.Jobidbackend__c.split(' R')[0] + ' R' + j.Revision_Increment__c;}
                        system.debug('The auto number === '+j.Job_Auto_Number__c);
                    }
                    
                    //Epson org job# Reprint
                    else if ((UserInfo.getOrganizationId() == '00Dm00000002kRBEAY' || UserInfo.getOrganizationId() == '00D190000004wT0EAI' || UserInfo.getOrganizationId() == '00Dj0000000HwwREAS' || UserInfo.getOrganizationId() == '00D3F0000004b48UAA' || UserInfo.getOrganizationId() == '00Dm000000092khEAA') && j.Reprint__c == true) {
                        if(Schema.sObjectType.Job__c.fields.Job_Auto_Number__c.isCreateable()){
                            j.Job_Auto_Number__c = j.Jobidbackend__c.split(' X')[0] + ' X' + j.Reprint_Increment__c;}
                    } else {
                        if(Schema.sObjectType.Job__c.fields.Job_Auto_Number__c.isCreateable()){
                            j.Job_Auto_Number__c = autoFormat + separator + appendZero + incre;
                        }
                        //j.Job_Auto_Number__c = autoFormat+separator+incre; 
                    }
                }
            }
        }
    }
    
    // Trigger Code executed After Job creation
    If(Trigger.isAfter && Trigger.isInsert) {
        // Global variables
        
        SET <Id> specificationTemplateId = new SET <Id> ();
        Map<Id,List<Spec_Item__c>> STempwithSpecItems=new Map<Id,List<Spec_Item__c>>();
        List < Job_Spec__c > lstJobSpec = new List < Job_Spec__c > ();
        List < Specification_Template__c > lstTemp = new List < Specification_Template__c > ();
        String strJobId, strSpecTempId;
        Id userId;
        
        SET < Id > stScheduleTemplateId = new SET < Id > ();
        SET < Id > stScheduleTaskId = new SET < Id > ();
        SET < Id > stJobTaskId = new SET < Id > ();
        Map < String, Id > mp1 = new Map < String, Id > ();
        Map < Id, Id > mp2 = new Map < Id, Id > ();
        
        // End of Global variables 
        
        //added condition for BMHCC Job# format 
        List < Job_Number_Setting__c > jc = Job_Number_Setting__c.getall().values();
        if (!jc.isEmpty() && (UserInfo.getOrganizationId() == '00DE0000000cpPYMAY' || UserInfo.getOrganizationId() == '00DM00000013RmDMAU')) {
            if (jc[0].JobNumberFormat__c != null){
                if(Schema.sObjectType.Job_Number_Setting__c.fields.JobNumberFormat__c.isUpdateable()){
                    jc[0].JobNumberFormat__c = null;}
            }
            if(Schema.sObjectType.Job_Number_Setting__c.isUpdateable()){ update jc;}
        }
        
        // Capture Job Id
        for (Job__c j: Trigger.New) {
            stScheduleTemplateId.add(j.Schedule_Template__c); // retreive Schedule Template Id 
            specificationTemplateId.add(j.Specification_Template__c); //retrieve Specification Template Id
            strJobId = j.Id; // retreive JobId 
            userId = j.CreatedById;
            
        }
        System.debug('Set..' + stScheduleTemplateId);
        List < Schedule_Task__c > lstScheduleTask = new List < Schedule_Task__c > ();
        
        // Retrive Schedule Task related to selected Schedule Template
        lstScheduleTask = [Select Name, Days__c, GL_Code__c, Locked__c, Report__c, Task_Order__c from Schedule_Task__c where Schedule_Template__c IN: stScheduleTemplateId WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
        
        for (Schedule_Task__c s: lstScheduleTask) {
            stScheduleTaskId.add(s.Id);
        }
        
        List < ScheduleTaskRole__c > lstScheduleTaskRole = new List < ScheduleTaskRole__c > ();
        
        // Create Team 
        /*  List<Job_Team__c>lstJobTeam=new List<Job_Team__c>();

for(AggregateResult ar:[Select Name from ScheduleTaskRole__c  where Schedule_Task__c IN : stScheduleTaskId Group By Name])
{
Job_Team__c objJobTeam=new Job_Team__c();
objJobTeam.Job__c=strJobId;
objJobTeam.Role__c=String.valueOf(ar.get('Name'));
objJobTeam.Flag__c='S'; //Created Role by pulling Roles from Schedule Template
lstJobTeam.add(objJobTeam);
}
insert lstJobTeam;

System.debug('Job Team record inserted..'+lstJobTeam);
*/
        
        // End of Create Team   Commented by Subhranshu as per steve instructions
        
        System.Debug('Set....' + specificationTemplateId);
        List < Spec_Item__c > lstSpecItems = new List < Spec_Item__c > ();
        
        // Retrive Spec Items related to selected Specification Template
        user usr = [select Name, userType from User where Id = : userId ];//WITH SECURITY_ENFORCED
        
        if (usr.userType != 'Guest') //user type  check for job creation from sites :done by shashi 10/30/13
        {
            lstSpecItems = [Select Name, Description__c, Value__c, Lock__c, sort_order__c,Specification_Template__c, Specification_Template__r.name from Spec_Item__c where Specification_Template__c In: specificationTemplateId WITH SECURITY_ENFORCED ORDER BY CreatedDate];
            for(Spec_Item__c SItem:lstSpecItems){
                if(STempwithSpecItems.containsKey(SItem.Specification_Template__c)){
                    List<Spec_Item__c> addedItems=STempwithSpecItems.get(SItem.Specification_Template__c);
                    addedItems.add(SItem);
                    STempwithSpecItems.put(SItem.Specification_Template__c,addedItems);
                }
                else{
                    STempwithSpecItems.put(SItem.Specification_Template__c, new list<Spec_Item__c>{SItem});
                }
            }
            for(Job__c jb: Trigger.New){
                if(jb.Specification_Template__c!=null){
                    if(STempwithSpecItems.containsKey(jb.Specification_Template__c)){
                        for (Spec_Item__c sp:STempwithSpecItems.get(jb.Specification_Template__c)){
                            Job_Spec__c js = new Job_Spec__c();
                            if(Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()){
                                js.Name = sp.Name;}
                            if(Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()){
                                js.Description__c = sp.Description__c;}
                            if(Schema.sObjectType.Job_Spec__c.fields.Value__c.isCreateable()){
                                js.Value__c = sp.Value__c;}
                            if(Schema.sObjectType.Job_Spec__c.fields.Lock__c.isCreateable()){
                                js.Lock__c = sp.Lock__c;}
                            if(Schema.sObjectType.Job_Spec__c.fields.sort_order__c.isCreateable()){
                                js.sort_order__c = sp.sort_order__c;}
                            if(Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()){
                                js.Job__c = jb.Id;}
                            if(Schema.sObjectType.Job_Spec__c.fields.Creative_Brief_Template__c.isCreateable()){
                                js.Creative_Brief_Template__c = sp.Specification_Template__r.name;}
                            lstJobSpec.add(js);
                        }
                    }
                }
            }
            if(Schema.sObjectType.Job_Spec__c.isCreateable()){
                insert lstJobSpec;}
            System.debug('Job Specs are inserted' + lstJobSpec);
        }
        
    } // End of Code that wil execute after creating a Job record
    
    // Trigger Code executed After Updation of Job record
    If(Trigger.isAfter && Trigger.isUpdate) {
        List < Job_Task__c > updatelstJT = new List < Job_Task__c > ();
        List < Job_Task__c > lstJobTask = new List < Job_Task__c > ();
        List < Job_Team__c > lstJobTeam = new List < Job_Team__c > ();
        List < Job_Team__c > lstJobTeamInsert = new List < Job_Team__c > ();
        List < ScheduleTaskRole__c > lstScheduleTaskRole = new List < ScheduleTaskRole__c > ();
        List < Job_Spec__c > lstJobSpec = new List < Job_Spec__c > ();
        List < Job_Spec__c > lstJobSpec1 = new List < Job_Spec__c > ();
        List < Campaign__c > updateCampaign = new List < Campaign__c > ();
        
        String newSpecId, oldSpecId, newScheduleId, oldScheduleId, strJobId, newCampId, oldCampId, newScheduleCalc, oldScheduleCalc, status, oldstatus;
        Boolean markedDone, SchedUpdateChecknew,SchedUpdateCheckCalendar, ApprovePe;
        Job__c oldJob;
        Date newStartDate, oldStartDate, newDueDate, oldDueDate;
        Double newInvAmt = 0, oldInvAmt = 0;
        
        for (Job__c j: Trigger.New) {
            strJobId = j.id;
            oldJob = Trigger.oldMap.get(j.Id);
            newSpecId = j.Specification_Template__c;
            oldSpecId = oldJob.Specification_Template__c;
            newScheduleId = j.Schedule_Template__c;
            oldScheduleId = oldJob.Schedule_Template__c;
            newStartDate = j.Start_Date__c;
            oldStartDate = oldJob.Start_Date__c;
            newDueDate = j.Due_Date__c;
            oldDueDate = oldJob.Due_Date__c;
            newInvAmt = j.Invoice_Actual_Amounts__c;
            oldInvAmt = oldJob.Invoice_Actual_Amounts__c;
            newCampId = j.Campaign__c;
            oldCampId = oldJob.Campaign__c;
            status = j.Status__c;
            markedDone = j.marked_Done__c;
            ApprovePe = j.Approve_PE__c;
            SchedUpdateChecknew = j.UpdateSchedDateFieldCheck__c;
            //SchedUpdateCheckCalendar=j.ReSchedule_Calendar__c;
            //code added for the schedule calc
            newScheduleCalc = j.Schedule_Calc__c;
            oldScheduleCalc = oldJob.Schedule_Calc__c;
            
            oldstatus = trigger.oldmap.get(j.id).Status__c;
            
        }
        
        /***********/
        
        if (oldstatus != status && Status == 'Completed') {
            
            UnFollowJobRecordHandler.UnfollowJobRecord(Trigger.newMap, 'update');
            
        }
        
        if (Status == 'Completed') {
            Set < Id > jobsId = new set < Id > ();
            list < Job__c > jobList = new list < Job__c > ();
            for (Job__c job: trigger.New) {
                
                jobsId.add(job.id);
                jobList.add(job);
                
            }
            if (markedDone == true) {
                List < Job_Task__c > taskList = new List < Job_Task__c > ();
                taskList = [select Marked_Done__c, Name, Status__c, Job__c from Job_Task__c where Job__c in : jobsId and Marked_Done__c = : False WITH SECURITY_ENFORCED];
                List < Job_Task__c > taskUpdate = new List < Job_Task__c > ();
                //DateTime dTnow = System.Today();
                //Date myDate = date.newinstance(dTnow.month(),dTnow.day(),dTnow.year());
                
                for (Job_Task__c objTask: taskList) {
                    if(Schema.sObjectType.Job_Task__c.fields.Status__c.isUpdateable()){
                        objTask.Status__c = 'Completed';}
                    if(Schema.sObjectType.Job_Task__c.fields.Marked_Done__c.isUpdateable()){
                        objTask.Marked_Done__c = true;}
                    if(Schema.sObjectType.Job_Task__c.fields.Completion_Date__c.isUpdateable()){
                        objTask.Completion_Date__c = System.Today();}
                    taskUpdate.add(objTask);
                }
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                    update taskUpdate;}
            }
            
            if (ApprovePe == true) {
                
                List < Production_Estimate__c > PEList = new List < Production_Estimate__c > ();
                PEList = [select Approved__c, Name, Job__c from Production_Estimate__c where Job__c in : jobsId and Approved__c = : False WITH SECURITY_ENFORCED];
                List < Production_Estimate__c > PEUpdate = new List < Production_Estimate__c > ();
                
                for (Production_Estimate__c objPE: PEList) {
                    if(Schema.sObjectType.Production_Estimate__c.fields.Approved__c.isUpdateable()){
                        objPE.Approved__c = true;}
                    PEUpdate.add(objPE);
                }
                if(Schema.sObjectType.Production_Estimate__c.isUpdateable()){
                    
                    update PEUpdate;}
                
            }
            
        }
        
        /***************/
        
        Boolean isFirst = true;
        
        /*     if(newCampId!=oldCampId)
{
if(newCampId!=NULL)
{
Campaign__c objC1=[Select Id,Actual_Cost__c from Campaign__c where Id=: newCampId];
objC1.Actual_Cost__c=objC1.Actual_Cost__c + newInvAmt;
update objC1;
}                
if(oldCampId!=NULL)
{
Campaign__c objC2=[Select Id,Actual_Cost__c from Campaign__c where Id=: oldCampId];
objC2.Actual_Cost__c=objC2.Actual_Cost__c - newInvAmt;
update objC2;
}

}  */
        
        // When specification Template is updated, following code gets executed
        If(newSpecId != oldSpecId) {
            Set < Id > specificationTemplateId = new Set < Id > ();
            specificationTemplateId.add(newSpecId);
            System.Debug('Set....' + specificationTemplateId);
            lstJobSpec = [select id from Job_Spec__c where Job__c = : strJobId WITH SECURITY_ENFORCED];
            List < Spec_Item__c > lstSpecItems = new List < Spec_Item__c > ();
            lstSpecItems = [Select Name, Description__c, Value__c, Lock__c, sort_order__c, Specification_Template__r.name from Spec_Item__c where Specification_Template__c In: specificationTemplateId WITH SECURITY_ENFORCED ORDER BY CreatedDate];
            
            for (Spec_Item__c sp: lstSpecItems) {
                Job_Spec__c js = new Job_Spec__c();
                if(Schema.sObjectType.Job_Spec__c.fields.Name.isCreateable()){
                    js.Name = sp.Name;}
                if(Schema.sObjectType.Job_Spec__c.fields.Description__c.isCreateable()){
                    js.Description__c = sp.Description__c;}
                if(Schema.sObjectType.Job_Spec__c.fields.Value__c.isCreateable()){
                    js.Value__c = sp.Value__c;}
                if(Schema.sObjectType.Job_Spec__c.fields.Lock__c.isCreateable()){
                    js.Lock__c = sp.Lock__c;}
                if(Schema.sObjectType.Job_Spec__c.fields.sort_order__c.isCreateable()){
                    js.sort_order__c = sp.sort_order__c;}
                if(Schema.sObjectType.Job_Spec__c.fields.Job__c.isCreateable()){
                    js.Job__c = strJobId;}
                if(Schema.sObjectType.Job_Spec__c.fields.Creative_Brief_Template__c.isCreateable()){
                    js.Creative_Brief_Template__c = sp.Specification_Template__r.name;}
                lstJobSpec1.add(js);
            }
            if(Schema.sObjectType.Job_Spec__c.isDeletable()){
                delete lstJobSpec;}
            if(Schema.sObjectType.Job_Spec__c.isCreateable()){
                insert lstJobSpec1;}
        }
        
        // When Schedule Template is updated, following code gets executed
        
        If(newScheduleId != oldScheduleId) {
            //  lstJobTeam=[select id from Job_Team__c where Job__c =: strJobId];
            lstJobTask = [select id from Job_Task__c where Job__c = : strJobId WITH SECURITY_ENFORCED];
            SET < Id > stScheduleTemplateId = new SET < Id > ();
            SET < Id > stScheduleTaskId = new SET < Id > ();
            SET < Id > stJobTaskId = new SET < Id > ();
            Map < String, Id > mp1 = new Map < String, Id > ();
            Map < Id, Id > mp2 = new Map < Id, Id > ();
            
            stscheduleTemplateId.add(newScheduleId);
            
            System.debug('Set..' + stScheduleTemplateId);
            
            List < Schedule_Task__c > lstScheduleTask = new List < Schedule_Task__c > ();
            
            lstScheduleTask = [Select Name, Days__c, GL_Code__c, Locked__c, Report__c, Task_Order__c from Schedule_Task__c where Schedule_Template__c IN: stScheduleTemplateId WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
            
            for (Schedule_Task__c s: lstScheduleTask) {
                stScheduleTaskId.add(s.Id);
            }
            
            /* for(AggregateResult ar:[Select Name from ScheduleTaskRole__c  where Schedule_Task__c IN : stScheduleTaskId Group By Name])
{
Job_Team__c objJobTeam=new Job_Team__c();
objJobTeam.Job__c=strJobId;
objJobTeam.Role__c=String.valueOf(ar.get('Name'));
objJobTeam.Flag__c='S'; //Created Role by pulling Roles from Schedule Template
lstJobTeamInsert.add(objJobTeam);
}
insert lstJobTeamInsert; */
            // Commented by Subhranshu as per steve instructions  
            /*** Added for dev item 1674 **/
            // delete lstJobTeam;
            if(Schema.sObjectType.Job_Task__c.isDeletable()){
                delete lstJobTask;}
            
        }
        
        // End of code for Schedule Template Update
        
        //Code for the change in the Job Schedule calcuation change
        
        If(newScheduleCalc != oldScheduleCalc) {
            if (oldScheduleCalc == Null) {
                
            } else {
                Date NTSD;
                List < Job_Task__c > lstJobTask2 = new List < Job_Task__c > ();
                List < Job_Task__c > lst = new List < Job_Task__c > {};
                    System.debug('Number of retrieved Task ' + lstJobTask2.size());
                set < Date > holidays = new set < Date > ();
                Boolean blnFroward = true;
                if (newScheduleCalc == 'End Date') {
                    blnFroward = false;
                }
                
                if (blnFroward) {
                    lstJobTask2 = [Select Id, Job__c, Start_Date__c, Due_Date__c, Days__c, Revised_Due_Date__c from Job_Task__c where Job__c = : strJobId WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
                } else {
                    lstJobTask2 = [Select Id, Job__c, Start_Date__c, Due_Date__c, Days__c, Revised_Due_Date__c, Task_Order__c from Job_Task__c where Job__c = : strJobId WITH SECURITY_ENFORCED ORDER BY Task_Order__c DESC];
                }
                
                Date std;
                if (blnFroward) {
                    std = Date.newInstance(newStartDate.Year(), newStartDate.month(), newStartDate.Day());
                } else {
                    std = Date.newInstance(newDueDate.Year(), newDueDate.month(), newDueDate.Day());
                }
                
                for (Holiday__c hc: [Select Date__c from Holiday__c where Date__c != null WITH SECURITY_ENFORCED]) {
                    holidays.add(hc.Date__c);
                }
                
                for (Job_Task__c jt: lstJobTask2) {
                    if (isFirst) {
                        System.debug('This is First');
                        if (blnFroward) {
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                jt.Start_Date__c = std;}
                        } else {
                            if(Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isUpdateable()){
                                jt.Due_Date__c = std;}
                        }
                        isFirst = False;
                    } else {
                        System.debug('This is Not the First');
                        //Date d3 = Date.newInstance(NTSD.Year(),NTSD.Month(),NTSD.Day());
                        if (blnFroward) {
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                jt.Start_Date__c = NTSD;}
                        } else {
                            if(Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isUpdateable()){
                                jt.Due_Date__c = NTSD;}
                        }
                    }
                    
                    Datetime dtStartDate1;
                    if (blnFroward) {
                        dtStartDate1 = DateTime.newInstance(jt.Start_Date__c.Year(), jt.Start_Date__c.Month(), jt.Start_Date__c.Day());
                    } else {
                        dtStartDate1 = DateTime.newInstance(jt.Due_Date__c.Year(), jt.Due_Date__c.Month(), jt.Due_Date__c.Day());
                    }
                    
                    system.debug('Start or Due Date is : ' + dtStartDate1);
                    Integer jCount = 0;
                    System.debug('jCount value ' + jCount);
                    
                    while (true) {
                        Date d3 = Date.newInstance(dtStartDate1.Year(), dtStartDate1.Month(), dtStartDate1.Day());
                        If((dtStartDate1.format('E') != 'Sat' && dtStartDate1.format('E') != 'Sun') && (!holidays.contains(d3))) {
                            jCount = jCount + 1;
                            if (jCount > jt.Days__c) {
                                break;
                            }
                            system.debug('jCount======' + jCount);
                            system.debug('==========' + dtStartDate1);
                            system.debug('===========' + dtStartDate1.format('E'));
                            if (blnFroward) {
                                dtStartDate1 = dtStartDate1.addDays(1);
                            } else {
                                dtStartDate1 = dtStartDate1.addDays(-1);
                            }
                            // dtStartDate1=dtStartDate1.addDays(1);
                            system.debug('after calculating 1 day==========' + dtStartDate1);
                        } else {
                            system.debug('==========' + dtStartDate1);
                            if (blnFroward) {
                                dtStartDate1 = dtStartDate1.addDays(1);
                            } else {
                                dtStartDate1 = dtStartDate1.addDays(-1);
                            }
                            //dtStartDate1=dtStartDate1.addDays(1);
                            continue;
                        }
                    }
                    
                    Date d1 = Date.newInstance(dtStartDate1.Year(), dtStartDate1.Month(), dtStartDate1.Day());
                    System.debug('D1 is as follows : ' + d1);
                    if (blnFroward) {
                        if(Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isUpdateable()){
                            jt.Due_Date__c = d1;}
                    } else {
                        if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                            jt.Start_Date__c = d1;}
                    }
                    //jt.Due_Date__c=d1;
                    //jt.Revised_Due_Date__c=d1;
                    if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                        jt.Revised_Due_Date__c = jt.Due_Date__c;}
                    //NTSD=d1;
                    NTSD = Date.valueOf(dtStartDate1);
                    system.debug('NTSD ' + NTSD);
                    system.debug('due date ' + jt.Due_Date__c);
                    if (jt.Marked_Done__c = true) {
                        if(Schema.sObjectType.Job_Task__c.fields.Marked_Done__c.isUpdateable()){
                            jt.Marked_Done__c = False;}
                        if(Schema.sObjectType.Job_Task__c.fields.Completion_Date__c.isUpdateable()){
                            jt.Completion_Date__c = null;}
                        if(Schema.sObjectType.Job_Task__c.fields.Status__c.isUpdateable()){
                            jt.Status__c = 'Active';}
                    }
                    updatelstJT.add(jt);
                    
                }
                if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                    update updatelstJT;}
            }
        }
        
        // Job Start Date or Due date  has changed : Update Schedule Date
        if ((newStartDate != oldStartDate) || (newDueDate != oldDueDate)) {
            if (SchedUpdateChecknew == true) {
                If(newScheduleCalc != oldScheduleCalc) {
                    
                } else {
                    
                    Date NTSD;
                    List < Job_Task__c > lstJobTask2 = new List < Job_Task__c > ();
                    List < Job_Task__c > lst = new List < Job_Task__c > {};
                        System.debug('Number of retrieved Task ' + lstJobTask2.size());
                    set < Date > holidays = new set < Date > ();
                    Boolean blnFroward = true;
                    if (oldJOb.Schedule_Calc__c == 'End Date') {
                        blnFroward = false;
                    }
                    
                    if (blnFroward) {
                        lstJobTask2 = [Select Id, Job__c, Start_Date__c, Due_Date__c, Days__c, Marked_Done__c, Completion_Date__c, Revised_Due_Date__c from Job_Task__c where Job__c = : strJobId WITH SECURITY_ENFORCED ORDER BY Task_Order__c];
                    } else {
                        lstJobTask2 = [Select Id, Job__c, Start_Date__c, Due_Date__c, Days__c, Marked_Done__c, Completion_Date__c, Revised_Due_Date__c, Task_Order__c from Job_Task__c where Job__c = : strJobId WITH SECURITY_ENFORCED ORDER BY Task_Order__c DESC];
                    }
                    
                    Date std;
                    if (blnFroward) {
                        std = Date.newInstance(newStartDate.Year(), newStartDate.month(), newStartDate.Day());
                    } else {
                        std = Date.newInstance(newDueDate.Year(), newDueDate.month(), newDueDate.Day());
                    }
                    
                    for (Holiday__c hc: [Select Date__c from Holiday__c where Date__c != null WITH SECURITY_ENFORCED]) {
                        holidays.add(hc.Date__c);
                    }
                    
                    for (Job_Task__c jt: lstJobTask2) {
                        Datetime dtStartDate1;
                        if (isFirst) {
                            System.debug('This is First');
                            if (blnFroward) {
                                dtStartDate1 = jt.Start_Date__c = std;
                                //  = DateTime.newInstance(jt.Start_Date__c.Year(),jt.Start_Date__c.Month(),jt.Start_Date__c.Day());
                            } else {
                                dtStartDate1 = jt.Due_Date__c = std;
                            }
                            isFirst = False;
                        } else {
                            System.debug('This is Not the First');
                            Date d3 = Date.newInstance(NTSD.Year(), NTSD.Month(), NTSD.Day());
                            if (blnFroward) {
                                if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                    jt.Start_Date__c = NTSD;}
                                dtStartDate1 = d3;
                            } else {
                                if(Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isUpdateable()){
                                    jt.Due_Date__c = NTSD;}
                                dtStartDate1 = d3;
                            }
                        }
                        
                        if (blnFroward) {
                            //  dtStartDate1 = DateTime.newInstance(jt.Start_Date__c.Year(),jt.Start_Date__c.Month(),jt.Start_Date__c.Day());
                        } else {
                            // dtStartDate1 = DateTime.newInstance(jt.Due_Date__c.Year(),jt.Due_Date__c.Month(),jt.Due_Date__c.Day());
                        }
                        
                        system.debug('Start or Due Date is : ' + dtStartDate1);
                        Integer jCount = 0;
                        System.debug('jCount value ' + jCount);
                        
                        while (true) {
                            Date d3 = Date.newInstance(dtStartDate1.Year(), dtStartDate1.Month(), dtStartDate1.Day());
                            If((dtStartDate1.format('E') != 'Sat' && dtStartDate1.format('E') != 'Sun') && (!holidays.contains(d3))) {
                                jCount = jCount + 1;
                                if (jCount > jt.Days__c) {
                                    break;
                                }
                                system.debug('jCount======' + jCount);
                                system.debug('==========' + dtStartDate1);
                                system.debug('===========' + dtStartDate1.format('E'));
                                if (blnFroward) {
                                    dtStartDate1 = dtStartDate1.addDays(1);
                                } else {
                                    dtStartDate1 = dtStartDate1.addDays(-1);
                                }
                                // dtStartDate1=dtStartDate1.addDays(1);
                                system.debug('after calculating 1 day==========' + dtStartDate1);
                            } else {
                                system.debug('==========' + dtStartDate1);
                                if (blnFroward) {
                                    dtStartDate1 = dtStartDate1.addDays(1);
                                } else {
                                    dtStartDate1 = dtStartDate1.addDays(-1);
                                }
                                //dtStartDate1=dtStartDate1.addDays(1);
                                continue;
                            }
                        }
                        
                        Date d1 = Date.newInstance(dtStartDate1.Year(), dtStartDate1.Month(), dtStartDate1.Day());
                        System.debug('D1 is as follows : ' + d1);
                        if (blnFroward) {
                            if(Schema.sObjectType.Job_Task__c.fields.Due_Date__c.isUpdateable()){
                                jt.Due_Date__c = d1;}
                        } else {
                            if(Schema.sObjectType.Job_Task__c.fields.Start_Date__c.isUpdateable()){
                                jt.Start_Date__c = d1;}
                        }
                        //jt.Due_Date__c=d1;
                        //jt.Revised_Due_Date__c=d1;
                        if(Schema.sObjectType.Job_Task__c.fields.Revised_Due_Date__c.isUpdateable()){
                            jt.Revised_Due_Date__c = jt.Due_Date__c;}
                        //jt.Revised_Due_Date__c=d1;
                        //NTSD=d1;
                        NTSD = Date.valueOf(dtStartDate1);
                        system.debug('NTSD ' + NTSD);
                        system.debug('due date ' + jt.Due_Date__c);
                        if (jt.Marked_Done__c = true) {
                            if(Schema.sObjectType.Job_Task__c.fields.Marked_Done__c.isUpdateable()){ 
                                jt.Marked_Done__c = False;}
                            if(Schema.sObjectType.Job_Task__c.fields.Completion_Date__c.isUpdateable()){
                                jt.Completion_Date__c = null;}
                            if(Schema.sObjectType.Job_Task__c.fields.Status__c.isUpdateable()){
                                jt.Status__c = 'Active';}
                        }
                        updatelstJT.add(jt);
                        
                    }
                    
                    /*List<Job_Task__c> lstJMrkdTask=new List<Job_Task__c>();
lstJMrkdTask = [Select Id,Job__c,Start_Date__c,Due_Date__c,Days__c,Revised_Due_Date__c,Marked_Done__c,Completion_Date__c from Job_Task__c where Job__c =: strJobId and Marked_Done__c =:True];
for(Job_Task__c Mjt:lstJobTask2)
{ 
//Mjt.Completion_Date__c = '';

Mjt.Marked_Done__c = False;
updatelstJT.add(Mjt);
}*/
                    if(Schema.sObjectType.Job_Task__c.isUpdateable()){
                        update updatelstJT;}
                }
            }
        } //End of code for when User updates Start Date fo the Job 
        //}
        
        /*     If(newInvAmt!=oldInvAmt)
{        
If(newcampId!=NULL)
{  
Campaign__c c=[Select id,Actual_Cost__c from Campaign__c where id=: newcampId];
c.Actual_Cost__c=c.Actual_Cost__c-oldInvAmt+newInvAmt;
updateCampaign.add(c);
}
update updateCampaign;
}  */
        
    } // End of Code for Job After Update Event
    
    /*     If(Trigger.isBefore && Trigger.isDelete)
{
List<Campaign__c> updateCampaign=new List<Campaign__c>();
String strJobId,campId;
Double invAmt;
for(Job__c j:Trigger.old)
{
// If Job gets deleted then Job's Invoice Amount must be reduced from related Campaign Actual Cost
strJobId=j.id;
invAmt=j.Invoice_Actual_Amounts__c;
campId=j.Campaign__c;
}

if(campId!=NULL)
{  
Campaign__c c=[Select id,Actual_Cost__c from Campaign__c where id=: campId];
c.Actual_Cost__c=c.Actual_Cost__c-invAmt;
updateCampaign.add(c);
}
update updateCampaign;
}   */
    
    // End of Code to be executed after deleting a Job record
    
    // Trigger code to be executed before Job Delete
    // Job record will not be deleted if any of the following is created : JobTask, Job Spec, Quotes, Estimates, PO's
    
    SET < Id > Job_JT_Ids = new SET < Id > ();
    SET < Id > Job_PO_Ids = new SET < Id > ();
    SET < Id > Job_IN_Ids = new SET < Id > ();
    
    if (Trigger.isDelete && Trigger.isBefore) {
        /* ****************** If any Job Task is there for this Job then job will not be deleted ****************** */
        List < Id > JTids = new List < Id > ();
        Job_JT_Ids = trigger.oldMap.keyset();
        
        //check Job Task associated
        for (Job_Task__c a: [SELECT Id, Name, Job__c FROM Job_Task__c WHERE Job__c IN: Job_JT_Ids WITH SECURITY_ENFORCED]) {
            JTids.add(a.Job__c);
            
            // get the object from the Trigger Context
            Job__c errorObj = Trigger.oldMap.get(a.Job__c);
            
            if (errorObj != null) {
                // add an error to the object which will prevent this object from being deleted
                errorObj.addError('You cannot delete "' + errorObj.Name + '".Because either Schedules, Specs, Quotes, Estimates, Purchase Orders or Vendor Invoices are associated with this Job');
                /*   for(Job_Task__c jt: [SELECT Id,Name,Job__c FROM Job_Task__c WHERE Job__c =: errorObj.id])
{
errorObj.addError('Job Task "'+jt.Name+'" is associated. ');
}
*/
            } else {
                System.debug('Somehow, Trigger.oldMap does not contain a Job that is linked to Job Task, even though that Job ID is in the Trigger.oldMap keyset');
                System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                System.debug('-- Job Task: ' + a);
            }
        }
        
        //Remove Job_PO_Ids from delete list that has Job association
        Job_JT_Ids.removeAll(JTids);
        /* ******************End of Job Task association part***************** */
        
        /* ****************** If any Job Spec is there for this Job then job will not be delted ****************** */
        Set < Id > Job_JS_Ids = new Set < Id > ();
        List < Id > JSids = new List < Id > ();
        Job_JS_Ids = trigger.oldMap.keyset();
        
        //check Job Specs associated
        for (Job_Spec__c a: [SELECT Id, Name, Job__c FROM Job_Spec__c WHERE Job__c IN: Job_JS_Ids WITH SECURITY_ENFORCED]) {
            JSids.add(a.Job__c);
            
            // get the object from the Trigger Context
            Job__c errorObj = Trigger.oldMap.get(a.Job__c);
            
            If(errorObj != null) {
                // add an error to the object which will prevent this object from being deleted
                errorObj.addError('You cannot delete "' + errorObj.Name + '".Because either Schedules, Specs, Quotes, Estimates, Purchase Orders or Vendor Invoices are associated with this Job');
                /* for(Job_Spec__c js : [select id,Name,Job__c from Job_Spec__c where Job__c =: errorObj.id])
{
errorObj.addError('Job Spec "'+js.Name+'" is associated. ');
}*/
            } else {
                System.debug('Somehow, Trigger.oldMap does not contain a Job that is linked to Job Spec, even though that Job ID is in the Trigger.oldMap keyset');
                System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                System.debug('-- Job Spec: ' + a);
            }
        }
        
        //Remove Job_PO_Ids from delete list that has Job association
        Job_JS_Ids.removeAll(JSids);
        
        /* ****************** END OF JOB SPEC PART ****************** */
        
        /* ****************** If any Quote is there for this Job then job will not be delted ****************** */
        Set < Id > Job_JQ_Ids = new Set < Id > ();
        List < Id > JQids = new List < Id > ();
        Job_JQ_Ids = trigger.oldMap.keyset();
        
        //check Quotes associated
        for (Quote__c a: [SELECT Id, Name, Job__c FROM Quote__c WHERE Job__c IN: Job_JQ_Ids WITH SECURITY_ENFORCED]) {
            JQids.add(a.Job__c);
            
            // get the object from the Trigger Context
            Job__c errorObj = Trigger.oldMap.get(a.Job__c);
            
            If(errorObj != null) {
                // add an error to the object which will prevent this object from being deleted
                errorObj.addError('You cannot delete "' + errorObj.Name + '".Because either Schedules, Specs, Quotes, Estimates, Purchase Orders or Vendor Invoices are associated with this Job');
                /*
for(Quote__c q: [select id,Name,Job__c from Quote__c where Job__c =: errorObj.id])
{
errorObj.addError('Quote "'+q.Name+'" is associated.');
}

*/
            } else {
                System.debug('Somehow, Trigger.oldMap does not contain a Job that is linked to Quote, even though that Job ID is in the Trigger.oldMap keyset');
                System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                System.debug('-- Quote: ' + a);
            }
        }
        
        //Remove Job_PO_Ids from delete list that has Job association
        Job_JQ_Ids.removeAll(JQids);
        
        /* ****************** END OF JOB QUOTE PART ****************** */
        
        /* ****************** If any Estimate Line Item is there for this Job then job will not be delted ****************** */
        SET < Id > Job_ELI_Ids = new SET < Id > ();
        List < Id > ELIids = new List < Id > ();
        Job_ELI_Ids = trigger.oldMap.keyset();
        
        //check Estimate Line Items associated
        for (Estimate_Line_Items__c a: [SELECT Id, Name, Job__c FROM Estimate_Line_Items__c WHERE Job__c IN: Job_ELI_Ids WITH SECURITY_ENFORCED]) {
            ELIids.add(a.Job__c);
            
            // get the object from the Trigger Context
            Job__c errorObj = Trigger.oldMap.get(a.Job__c);
            
            If(errorObj != null) {
                // add an error to the object which will prevent this object from being deleted
                errorObj.addError('You cannot delete "' + errorObj.Name + '".Because either Schedules, Specs, Quotes, Estimates, Purchase Orders or Vendor Invoices are associated with this Job');
                /*
for(Estimate_Line_Items__c eli: [SELECT Id,Name,Job__c FROM Estimate_Line_Items__c WHERE Job__c =: errorObj.id])
{
errorObj.addError('Estimate Line Item "'+eli.Name+'" is associated.');
}
*/
            } else {
                System.debug('Somehow, Trigger.oldMap does not contain a Job that is linked to Estimate Line Item, even though that Job ID is in the Trigger.oldMap keyset');
                System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                System.debug('-- Estimate Line Item: ' + a);
            }
        }
        
        //Remove Job_PO_Ids from delete list that has Job association
        Job_ELI_Ids.removeAll(ELIids);
        
        /* ****************** END OF ESTIMATE LINE PART ****************** */
        
        /* ****************** If any Purchase Order is there for this Job then job will not be delted ****************** */
        List < Id > POids = new List < Id > ();
        Job_PO_Ids = trigger.oldMap.keyset();
        
        //check Purchase Order associated
        for (Purchase_Order__c a: [SELECT Id, Name, Job__c FROM Purchase_Order__c WHERE Job__c IN: Job_PO_Ids WITH SECURITY_ENFORCED]) {
            POids.add(a.Job__c);
            
            // get the object from the Trigger Context
            Job__c errorObj = Trigger.oldMap.get(a.Job__c);
            
            If(errorObj != null) {
                // add an error to the object which will prevent this object from being deleted
                errorObj.addError('You cannot delete "' + errorObj.Name + '".Because either Schedules, Specs, Quotes, Estimates, Purchase Orders or Vendor Invoices are associated with this Job');
                /*
for(Purchase_Order__c po: [SELECT Id,Name,Job__c FROM Purchase_Order__c WHERE Job__c =: errorObj.id])
{
errorObj.addError('Purchase Order "'+po.Name+'" is associated.');
}
*/
            } else {
                System.debug('Somehow, Trigger.oldMap does not contain a Job that is linked to PO, even though that Job ID is in the Trigger.oldMap keyset');
                System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                System.debug('-- PO: ' + a);
            }
        }
        
        //Remove Job_PO_Ids from delete list that has Job association
        Job_PO_Ids.removeAll(POids);
        
        /* ***********End of Purchase Order association part************ */
        
        /* ****************** If any Invoice is there for this Job then job will not be delted ****************** */
        List < Id > INids = new List < Id > ();
        Job_IN_Ids = trigger.oldMap.keyset();
        
        //check invoice associated
        for (Invoice__c a: [SELECT Id, Name, Job__c FROM Invoice__c WHERE Job__c IN: Job_IN_Ids WITH SECURITY_ENFORCED]) {
            INids.add(a.Job__c);
            
            // get the object from the Trigger Context
            Job__c errorObj = Trigger.oldMap.get(a.Job__c);
            
            If(errorObj != null) {
                // add an error to the object which will prevent this object from being deleted
                errorObj.addError('You cannot delete "' + errorObj.Name + '".Because either Schedules, Specs, Quotes, Estimates, Purchase Orders or Vendor Invoices are associated with this Job');
                
                /*      for(Invoice__c inv : [SELECT Id,Name,Job__c FROM Invoice__c WHERE Job__c =: errorObj.id])
{
errorObj.addError('Invoice "'+inv.Name+'" is associated. ');
}
*/
            } else {
                System.debug('Somehow, Trigger.oldMap does not contain a Job that is linked to Invoice, even though that Job ID is in the Trigger.oldMap keyset');
                System.debug('-- Trigger.oldMap: ' + Trigger.oldMap);
                System.debug('-- IN: ' + a);
            }
        }
        
        //Remove STIDs from delete list that has Job association
        Job_IN_Ids.removeAll(INids);
        /* ***********End of Invoice association part************ */
    } // End of Trigger code for Before Delete event
    
    //Code for calculating the days taken to complete ---Navaneeth
    
    if ((trigger.isInsert || trigger.isUpdate) && trigger.isbefore) {
        //list<job__c> jobdaysupdatelist = new list<job__c>();
        //for(job__c jobdays : lstAllJobs )
        //{
        
        //job__c jobdays = new job__c();
        list < job__c > jobdaysupdatelist = trigger.new;
        /*---logic addded on 1 sep 2020---*/
        list<Job_Task__C> jobTasksList=[SELECT Id, Name,  Completion_Date__c,Marked_Done__c,Revised_Due_Date__c,Job__c FROM Job_Task__c where Job__c in: Trigger.New WITH SECURITY_ENFORCED];
        system.debug('---tasklistsize for totaldysupate---'+jobTasksList.size());
        map<id,list<Job_Task__C>> jobidWithTasksMap=new map<id,list<Job_Task__C>>();
        for(Job_Task__C task:jobTasksList){
            if(jobidWithTasksMap.containsKey(task.Job__c)){
                jobidWithTasksMap.get(task.Job__c).add(task);
            }else{
                list<Job_Task__C> taskslist=new list<Job_Task__C>();
                taskslist.add(task);
                jobidWithTasksMap.put(task.Job__c,taskslist);
            }
        }
        system.debug('---jobidWithTasksMap----'+jobidWithTasksMap);
        /*-----logic ended------*/
        list < Holiday__c > hldlist = [select id, Date__c from Holiday__c WITH SECURITY_ENFORCED];
        set < Date > dtlist = new set < Date > ();
        for (Holiday__c hl: hldlist)
            dtlist.add(hl.Date__c);
        for (job__c jobdays: jobdaysupdatelist) {
            if (jobdays.Status__c == 'Completed') {
                /*---logic addded on 1 sep 2020---*/ 
                if(jobidWithTasksMap!=null && jobidWithTasksMap.get(jobdays.id)!=null && jobidWithTasksMap.get(jobdays.id).size()>0){                        
                    list<job_task__c> jobtask= jobidWithTasksMap.get(jobdays.id);
                    //system.debug(jobtask.size());  
                    date ftaskduedate=jobtask[0].Revised_Due_Date__c;
                    //system.debug('ftaskduedate---'+ftaskduedate);
                    date ltaskcmpdate=jobtask[jobtask.size()-1].Completion_Date__c;
                    //system.debug('ltaskcmpdate---'+ltaskcmpdate);
                    if(ftaskduedate!=null && ltaskcmpdate!=null)
                    {                   
                        Integer workingDays = 0;  
                        
                        for(integer i=0; i <= ftaskduedate.daysBetween(ltaskcmpdate); i++)  
                        {  
                            Date dt = ftaskduedate + i;  
                            DateTime currDate = DateTime.newInstance(dt.year(), dt.month(), dt.day());  
                            String todayDay = currDate.format('EEEE');  
                            if(todayDay != 'Saturday' && todayDay !='Sunday' && (!dtlist.contains(dt)))  
                            {  
                                workingDays = workingDays + 1;                              
                            }  
                        }  
                        if(Schema.sObjectType.job__c.fields.Task_Days_Completed__c.isUpdateable()){
                            jobdays.Task_Days_Completed__c=workingDays-1;}
                        //System.debug('--Working days'+workingDays); 
                    }   
                    else{
                        if(Schema.sObjectType.job__c.fields.Task_Days_Completed__c.isUpdateable()){
                            jobdays.Task_Days_Completed__c=0  ;}
                    }
                }
                else{
                    if(Schema.sObjectType.job__c.fields.Task_Days_Completed__c.isUpdateable()){
                        jobdays.Task_Days_Completed__c=0  ;}
                }
                /*-----logic ended ------*/
                if (jobdays.Completion_Date__c != NULL && jobdays.Start_Date__c != NULL && (jobdays.Start_Date__c <= jobdays.Completion_Date__c)) {
                    Datetime myDate = DateTime.newInstance(jobdays.Start_Date__c.Year(), jobdays.Start_Date__c.Month(), jobdays.Start_Date__c.Day(), 3, 3, 3);
                    Datetime myDatecomp = DateTime.newInstance(jobdays.Completion_Date__c.Year(), jobdays.Completion_Date__c.Month(), jobdays.Completion_Date__c.Day(), 3, 3, 3);
                    Date mydate1 = date.newInstance(jobdays.Start_Date__c.Year(), jobdays.Start_Date__c.Month(), jobdays.Start_Date__c.Day());
                    Date mydatecomp1 = date.newInstance(jobdays.Completion_Date__c.Year(), jobdays.Completion_Date__c.Month(), jobdays.Completion_Date__c.Day());
                    Date sttempdt = Date.newInstance(jobdays.Start_Date__c.Year(), jobdays.Start_Date__c.Month(), jobdays.Start_Date__c.Day());
                    integer countdays = 0;
                    system.debug('::::::::::::::::::mydate:::::::::::::' + mydate);
                    system.debug('::::::::::::::::::mydatecomp:::::::::::::' + mydatecomp);
                    while (myDate1 != myDatecomp1) {
                        if ((myDate.format('E') != 'Sat' && myDate.format('E') != 'Sun') && !(dtlist.contains(sttempdt))) {
                            // && ! (holidaysNew.contains(myDate ))
                            system.debug('::::::::::::::::::mydate:::::::::::::' + mydate);
                            system.debug('::::::::::::::::::mydatecomp:::::::::::::' + mydatecomp);
                            countdays += 1;
                            myDate = myDate.addDays(1);
                            mydate1 = mydate1.addDays(1);
                            sttempdt = sttempdt.addDays(1);
                        } else {
                            system.debug('::::::::::::::::::mydate:::::::::::::' + mydate);
                            system.debug('::::::::::::::::::mydatecomp:::::::::::::' + mydatecomp);
                            myDate = myDate.addDays(1);
                            mydate1 = mydate1.addDays(1);
                            sttempdt = sttempdt.addDays(1);
                        }
                    }
                    if(Schema.sObjectType.job__c.fields.Days_to_Complete__c.isUpdateable()){
                        jobdays.Days_to_Complete__c = countdays;}
                    // jobdaysupdatelist.add(jobdays);
                    //upsert jobdays;
                }
            } else {
                if(Schema.sObjectType.job__c.fields.Days_to_Complete__c.isUpdateable()){
                    jobdays.Days_to_Complete__c = null;}
            }
        }
    }
    
    //End Code for calculating the days taken to complete ---Navaneeth
    
    // Sharing the job record with client under client contacts
    
    if (trigger.isafter && (trigger.isinsert)) {
        
        List < Job__share > jobShares = new List < Job__share > ();
        
        for (Job__c t: trigger.new) {
            if (t.JS_Client_Contact__c != null && t.JS_Client__c != null) {
                string CC = t.JS_Client_Contact__c;
                
                list < Client_Contact__c > CCname = [select id, name, Client__c, UserName__c from Client_Contact__c where id = : CC WITH SECURITY_ENFORCED limit 1];
                
                string CCN = CCname[0].UserName__c;
                
                system.debug('>>>>>>>>>>>>CCN>>>>>>>>>>>>' + CCN);
                
                list < user > u = [select id, name, IsActive, Profile.name from user where Username = : CCN  limit 1];//WITH SECURITY_ENFORCED
                if (u.size() > 0) {
                    if (u[0].Profile.name == 'SP Client Contact') {
                        
                        set < String > ClientId = new set < String > ();
                        
                        ClientId.add(t.JS_Client__c);
                        
                        system.debug('>>>>>>>>>>>>ClientId>>>>>>>>>>>>' + ClientId);
                        
                        List < Client_Contact__c > Ccon = [select id, name, Client__c, UserName__c from Client_Contact__c where Client__c in : ClientId WITH SECURITY_ENFORCED];
                        set < string > CConname = new set < string > ();
                        
                        for (Client_Contact__c jt: Ccon) {
                            CConname.add(jt.UserName__c);
                        }
                        system.debug('>>>>>>>>>>>>CConname >>>>>>>>>>>>' + CConname);
                        
                        list < user > user = [select id, name, IsActive, Profile.name from user where Username in : CConname and IsActive = : true ];//WITH SECURITY_ENFORCED
                        
                        set < Id > UId = new set < Id > ();
                        
                        for (user uu: user) {
                            UId.add(uu.id);
                        }
                        system.debug('>>>>>>>>>>>>UId>>>>>>>>>>>>' + UId);
                        system.debug('>>>>>>>>>>>>Job Id>>>>>>>>>>>>' + t.Id);
                        
                        for (Id a: UId) {
                            if (t.ownerid != a) {
                                Job__share JobRecord = new Job__share();
                                if(Schema.sObjectType.Job__share.fields.ParentId.isCreateable()){  JobRecord.ParentId = t.id;}
                                if(Schema.sObjectType.Job__share.fields.UserOrGroupId.isCreateable()){ JobRecord.UserOrGroupId = a;}
                                if(Schema.sObjectType.Job__share.fields.AccessLevel.isCreateable()){ JobRecord.AccessLevel = 'Read';}
                                if(Schema.sObjectType.Job__share.fields.RowCause.isCreateable()){ JobRecord.RowCause = Schema.Job__share.RowCause.Manual;}
                                jobShares.add(JobRecord);
                            }
                        }
                        
                    }
                }
            }
            
            if (t.JS_Client__c != null) {
                set < String > ClientId = new set < String > ();
                
                ClientId.add(t.JS_Client__c);
                
                system.debug('>>>>>>>>>>>>ClientId>>>>>>>>>>>>' + ClientId);
                
                List < Client_Contact__c > Ccon = [select id, name, Client__c, UserName__c from Client_Contact__c where Client__c in : ClientId WITH SECURITY_ENFORCED];
                set < string > CConname = new set < string > ();
                
                for (Client_Contact__c jt: Ccon) {
                    CConname.add(jt.UserName__c);
                }
                system.debug('>>>>>>>>>>>>CConname >>>>>>>>>>>>' + CConname);
                
                list < user > user = [select id, name, IsActive, Profile.name from user where Username in : CConname and IsActive = : true];//WITH SECURITY_ENFORCED
                
                set < Id > UId = new set < Id > ();
                
                for (user uu: user) {
                    UId.add(uu.id);
                }
                system.debug('>>>>>>>>>>>>UId>>>>>>>>>>>>' + UId);
                system.debug('>>>>>>>>>>>>Job Id>>>>>>>>>>>>' + t.Id);
                
                for (Id a: UId) {
                    if (t.ownerid != a) {
                        Job__share JobRecord = new Job__share();
                        if(Schema.sObjectType.Job__share.fields.ParentId.isCreateable()){ JobRecord.ParentId = t.id;}
                        if(Schema.sObjectType.Job__share.fields.UserOrGroupId.isCreateable()){ JobRecord.UserOrGroupId = a;}
                        if(Schema.sObjectType.Job__share.fields.AccessLevel.isCreateable()){ JobRecord.AccessLevel = 'Read';}
                        if(Schema.sObjectType.Job__share.fields.RowCause.isCreateable()){ JobRecord.RowCause = Schema.Job__share.RowCause.Manual;}
                        jobShares.add(JobRecord);
                    }
                }
            }
            
        }
        if (jobShares.size() > 0){
            if(Schema.sObjectType.Job__share.isCreateable()){  insert jobShares;}
        }
    }
    
    if (trigger.isafter && (trigger.isupdate)) {
        set < string > Jobids = new set < string > ();
        for (Job__c Jo: trigger.new) {
            Jobids.add(Jo.id);
        }
        
        List < Job__share > jobShares = new List < Job__share > ();
        
        map < string, list < Client_Contact__c >> MapCC = new map < string, list < Client_Contact__c >> ();
        Map < String, Client_Contact__c > MapCCCC = new map < String, Client_Contact__c > ();
        
        for (Client_Contact__c cv: [select id, name, Client__c, UserName__c from Client_Contact__c WITH SECURITY_ENFORCED]) {
            MapCCCC.put(cv.id, cv);
            if (cv.Client__c != null) {
                if (MapCC.containskey(cv.Client__c)) {
                    list < Client_Contact__c > jcc = MapCC.get(cv.Client__c);
                    jcc.add(cv);
                    MapCC.put(cv.Client__c, jcc);
                } else {
                    list < Client_Contact__c > jcc = new list < Client_Contact__c > ();
                    jcc.add(cv);
                    MapCC.put(cv.Client__c, jcc);
                }
            }
        }
        
        map < string, List < Job__share >> MapShare = new map < string, List < Job__share >> ();
        for (Job__share jobshare: [select id, ParentId, UserOrGroupId from Job__share where RowCause != 'owner'
                                             and RowCause != 'Rule' and RowCause != 'GuestRule'
                                             and ParentId IN: Jobids WITH SECURITY_ENFORCED
                                            ]) {
                                                if (jobshare.ParentId != null) {
                                                    if (MapShare.containskey(jobshare.ParentId)) {
                                                        list < Job__share > JobSharing = MapShare.get(jobshare.ParentId);
                                                        JobSharing.add(jobshare);
                                                        MapShare.put(jobshare.ParentId, JobSharing);
                                                    } else {
                                                        list < Job__share > JobSharing = new list < Job__share > ();
                                                        JobSharing.add(jobshare);
                                                        MapShare.put(jobshare.ParentId, JobSharing);
                                                    }
                                                }
                                                
                                            }
        Map < String, user > UserMap = new Map < String, user > ();
        
        for (user us: [select id, name, IsActive, Username, Profile.name from user where IsActive = true]) {//WITH SECURITY_ENFORCED
            UserMap.put(us.Username, us);
        }  
        
        for (Job__c t: trigger.new) {
            
            //  if(t.JS_Client__c!= trigger.oldmap.get(t.id).JS_Client__c)
            //    {
            
            list < Job__share > JobSh = new list < Job__share > ();
            if (MapShare.containskey(t.id)) {
                JobSh = MapShare.get(t.id);
                if(Schema.sObjectType.Job__share.isDeletable()){
                    delete JobSh;
                }
            }
            
            if (t.JS_Client__c != null) {
                set < String > ClientId = new set < String > ();
                
                ClientId.add(t.JS_Client__c);
                
                system.debug('>>>>>>>>>>>>ClientId>>>>>>>>>>>>' + ClientId);
                
                List < Client_Contact__c > Ccon = new List < Client_Contact__c > ();
                if (MapCC.containskey(t.JS_Client__c)) {
                    Ccon = MapCC.get(t.JS_Client__c);
                }
                set < string > CConname = new set < string > ();
                
                for (Client_Contact__c jt: Ccon) {
                    CConname.add(jt.UserName__c);
                }
                system.debug('>>>>>>>>>>>>CConname >>>>>>>>>>>>' + CConname);
                
                //list<user> user=[select id,name,IsActive, Profile.name from user where Username in :CConname and IsActive=:true];
                list < user > user = new list < user > ();
                for (string CCCC: CConname) {
                    if (UserMap.containskey(CCCC)) {
                        user.add(UserMap.get(CCCC));
                    }
                }
                set < Id > UId = new set < Id > ();
                
                for (user uu: user) {
                    UId.add(uu.id);
                }
                system.debug('>>>>>>>>>>>>UId>>>>>>>>>>>>' + UId);
                system.debug('>>>>>>>>>>>>Job Id>>>>>>>>>>>>' + t.Id);
                
                for (Id a: UId) {
                    if (t.ownerid != a) {
                        Job__share JobRecord = new Job__share();
                        if(Schema.sObjectType.Job__share.fields.ParentId.isCreateable()){ JobRecord.ParentId = t.id;}
                        if(Schema.sObjectType.Job__share.fields.UserOrGroupId.isCreateable()){ JobRecord.UserOrGroupId = a;}
                        if(Schema.sObjectType.Job__share.fields.AccessLevel.isCreateable()){JobRecord.AccessLevel = 'Read';}
                        if(Schema.sObjectType.Job__share.fields.RowCause.isCreateable()){JobRecord.RowCause = Schema.Job__share.RowCause.Manual;}
                        jobShares.add(JobRecord);
                    }
                }
            }
            
            if (t.JS_Client_Contact__c != null && t.JS_Client__c != null) {
                
                string CC = t.JS_Client_Contact__c;
                
                list < Client_Contact__c > CCname = new list < Client_Contact__c > ();
                if (MapCCCC.containskey(CC)) {
                    CCname.add(MapCCCC.get(CC));
                }
                
                string CCN = CCname[0].UserName__c;
                
                system.debug('>>>>>>>>>>>>Client>>>>>>>>>>>>' + t.JS_Client__c);
                system.debug('>>>>>>>>>>>>Client>>>>>>>>>>>>' + trigger.oldmap.get(t.id).JS_Client__c);
                
                system.debug('>>>>>>>>>>>>CCN>>>>>>>>>>>>' + CCN);
                
                List < user > u = new List < user > ();
                if (UserMap.containskey(CCN)) {
                    u.add(UserMap.get(CCN));
                }
                
                if (u.size() > 0) {
                    if (u[0].Profile.name == 'SP Client Contact') {
                        
                        set < String > ClientId = new set < String > ();
                        
                        ClientId.add(t.JS_Client__c);
                        
                        system.debug('>>>>>>>>>>>>ClientId>>>>>>>>>>>>' + ClientId);
                        
                        //List<Client_Contact__c> Ccon = [select id, name,Client__c,UserName__c from Client_Contact__c where Client__c in :ClientId];
                        List < Client_Contact__c > Ccon = new List < Client_Contact__c > ();
                        if (MapCC.containskey(t.JS_Client__c)) {
                            Ccon = MapCC.get(t.JS_Client__c);
                        }
                        set < string > CConname = new set < string > ();
                        
                        for (Client_Contact__c jt: Ccon) {
                            CConname.add(jt.UserName__c);
                        }
                        system.debug('>>>>>>>>>>>>CConname >>>>>>>>>>>>' + CConname);
                        
                        //list<user> user=[select id,name,IsActive, Profile.name from user where Username in :CConname and IsActive=:true];
                        list < user > user = new list < user > ();
                        for (string CCCC: CConname) {
                            if (UserMap.containskey(CCCC)) {
                                user.add(UserMap.get(CCCC));
                            }
                        }
                        
                        set < Id > UId = new set < Id > ();
                        
                        for (user uu: user) {
                            UId.add(uu.id);
                        }
                        system.debug('>>>>>>>>>>>>UId>>>>>>>>>>>>' + UId);
                        system.debug('>>>>>>>>>>>>Job Id>>>>>>>>>>>>' + t.Id);
                        
                        for (Id a: UId) {
                            
                            if (t.ownerid != a) {
                                Job__share JobRecord = new Job__share();
                                if(Schema.sObjectType.Job__share.fields.ParentId.isCreateable()){  JobRecord.ParentId = t.id;}
                                if(Schema.sObjectType.Job__share.fields.UserOrGroupId.isCreateable()){ JobRecord.UserOrGroupId = a;}
                                if(Schema.sObjectType.Job__share.fields.AccessLevel.isCreateable()){ JobRecord.AccessLevel = 'Read';}
                                if(Schema.sObjectType.Job__share.fields.RowCause.isCreateable()){ JobRecord.RowCause = Schema.Job__share.RowCause.Manual;}
                                jobShares.add(JobRecord);
                            }
                        }
                        
                    }
                }
            }
            //}
        }
        if (jobShares.size() > 0){
            if(Schema.sObjectType.Job__share.isCreateable()){ insert jobShares;}}
        
        
    }  // End of Sharing the job record with client under client contacts
    
    If((Trigger.isInsert|| Trigger.isUpdate) && Trigger.isAfter) {
        //Below epson and base org ids for asana api
        if(UserInfo.getOrganizationId() == '00D190000004wT0EAI' || UserInfo.getOrganizationId() == '00Dj0000000HwwREAS' || UserInfo.getOrganizationId() == '00DA0000000Cir8MAC'){
            List<Id> idList = new List<Id>();
            for(Id tid :trigger.newMap.keySet()){
                if(Trigger.isInsert) idList.add(tid);
                else if(Trigger.isUpdate && Trigger.oldMap.get(tid).Assana_ExtenalId__c!=null){
                    idList.add(tid);
                }
                
            }
            if(idList.size()>0 && !Test.isRunningTest() && !system.isFuture() && !system.isBatch()){
                integratedjobrcds.createOrUpdateTaskRecordsinAsana(idList,Trigger.isInsert ? 'POST':'PUT');
            }
        }
    }
}    // End of Trigger Logic