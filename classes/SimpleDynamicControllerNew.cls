public with sharing class SimpleDynamicControllerNew {

    public Component.Apex.detail getDynamicHeader() {
        Component.Apex.detail page1 = new Component.Apex.detail();
        return page1;
    }
     
    //csr__JobDetails__c lst1 = [Select Name,csr__Order__c from csr__JobDetails__c where csr__Selected_Order__c=:true limit 1];
   
    public Component.Apex.TabPanel getDynamicDetail() {

//List<UserRecordAccess> listUserRecordAccess = [SELECT RecordId, HasReadAccess, HasEditAccess, HasDeleteAccess FROM UserRecordAccess WHERE UserId=:UserInfo.getUserId() AND RecordId =: Account.Id];
            // Defining all tabs contents here
            
            if (Schema.sObjectType.Job__c.isAccessible()) 
            {
              System.debug('The object Job is accessible to this profile');
            }
            Component.Apex.Detail detail = new Component.Apex.Detail();
                    detail.expressions.subject = '{!job}';
                    detail.relatedList = false;
                    detail.title = true;
            component.apex.iframe ifm = new component.apex.iframe();
                    string str = '/apex/Schedulepage?id='+job.Id;
                    ifm.src= str;//'https://jobsuite.na7.visual.force.com/apex/DisplayJobTaskInJobTabNew?id='+job.id;
                    ifm.scrolling=true;
                    ifm.height='400px';
            component.apex.iframe ifmcb = new component.apex.iframe();
                    string strcb = '/apex/DisplayJobSpecInJobTab?id='+job.Id;
                    ifmcb.src= strcb;
                    ifmcb.scrolling=true;
                    ifmcb.height='400px'; 
            component.apex.iframe ifmQ = new component.apex.iframe();
                    string strQ = '/apex/QuotesPage';//?id='+job.Id;
                    ifmQ.src= strQ;
                    ifmQ.scrolling=true;
                    ifmQ.height='400px'; 
            component.apex.iframe ifmEst = new component.apex.iframe();
                    string strEst = '/apex/EstimatePage';//?id='+job.Id;
                    ifmEst.src= strEst;
                    ifmEst.scrolling=true;
                    ifmEst.height='400px';
            
            //Defining All Tabs here 
            Component.Apex.Tab myTab1 = new Component.Apex.Tab();

            
            //Defining Tab Panel     
            Component.Apex.TabPanel panel = new Component.Apex.TabPanel();
                panel.switchType='client';
                panel.tabClass='activeTab';
                panel.inactiveTabClass='inactiveTab';
                panel.activeTabClass='activeTab';
                panel.contentClass='tabContent';
                panel.styleClass='theTabPanel';
                panel.width='100%';

            list<JobDetails__c> lst1 = [Select Name, Active__c, Order__c,Tabs_Order__c from JobDetails__c order by Order__c];

            
            for(JobDetails__c i: lst1) 
                {
                if(i.Active__c == true){
                 
                       myTab1 = new Component.Apex.Tab();
                       myTab1.label = i.Tabs_Order__c;
                       myTab1.style='font-size:0.9em;font-style:normal;font-family: \'Calibri\';font-weight:bold; color:black;white-space:nowrap;width:100px;center;text-align:bottom';
                       if(i.name == 'Details' && (Schema.sObjectType.Job__c.isAccessible()))
                       {
                           System.debug('The object Job Details is accessible to this profile :::' + Schema.sObjectType.Job__c.isAccessible());
                           myTab1.childComponents.add(Detail);
                           panel.childComponents.add(myTab1);
                       }else if(i.name == 'Schedule' && (Schema.sObjectType.Job_Task__c.isAccessible()))
                       {
                          System.debug('The object Schedule is accessible to this profile:::'+ Schema.sObjectType.Job_Task__c.isAccessible());
                           myTab1.childComponents.add(ifm);
                           panel.childComponents.add(myTab1);
                       }else if(i.name == 'Quotes' && (Schema.sObjectType.Quote__c.isAccessible()))
                       {
                          System.debug('The object Quotes is accessible to this profile ::'+Schema.sObjectType.Quote__c.isAccessible());
                           myTab1.childComponents.add(ifmQ);
                           panel.childComponents.add(myTab1);
                       }else if(i.name == 'Estimates' && (Schema.sObjectType.Estimate_Line_Items__c.isAccessible()))
                       {
                           System.debug('The object Estimates is accessible to this profile:::'+Schema.sObjectType.Estimate_Line_Items__c.isAccessible());
                           myTab1.childComponents.add(ifmEst);
                           panel.childComponents.add(myTab1);
                       }else if(i.name == 'Creative Brief' && (Schema.sObjectType.Job_Spec__c.isAccessible()))
                       {
                          System.debug('The object Creative Brief is accessible to this profile::'+Schema.sObjectType.Job_Spec__c.isAccessible());
                           myTab1.childComponents.add(ifmcb);
                           panel.childComponents.add(myTab1);
                       }
                       else if(i.name == 'Notes and Files' && (Schema.sObjectType.Job__c.isAccessible()))
                       {
                          System.debug('The object Notes and Files is accessible to this profile::'+Schema.sObjectType.Job__c.isAccessible());
                           //myTab1.childComponents.add(ifmcb);
                           panel.childComponents.add(myTab1);
                       }
                       else if(i.name == 'Deliverables' && (Schema.sObjectType.Graphics_Deliverables__c.isAccessible()))
                       {
                          System.debug('The object Deliverables is accessible to this profile::'+Schema.sObjectType.Graphics_Deliverables__c.isAccessible());
                           //myTab1.childComponents.add(ifmcb);
                           panel.childComponents.add(myTab1);
                       }
                       else if(i.name == 'Music Usage' && (Schema.sObjectType.Music_Usage__c.isAccessible()))
                       {
                          System.debug('The object Music Usage is accessible to this profile::'+Schema.sObjectType.Music_Usage__c.isAccessible());
                           //myTab1.childComponents.add(ifmcb);
                           panel.childComponents.add(myTab1);
                       }
                       else if(i.name == 'Purchase Order' && (Schema.sObjectType.Purchase_Order__c.isAccessible()))
                       {
                          System.debug('The object Purchase Order is accessible to this profile::'+Schema.sObjectType.Purchase_Order__c.isAccessible());
                           //myTab1.childComponents.add(ifmcb);
                           panel.childComponents.add(myTab1);
                       }
                       else if(i.name == 'Sessions' && (Schema.sObjectType.Session__c.isAccessible()))
                       {
                          System.debug('The object Sessions is accessible to this profile::'+Schema.sObjectType.Session__c.isAccessible());
                           //myTab1.childComponents.add(ifmcb);
                           panel.childComponents.add(myTab1);
                       }
                       else if(i.name == 'Tags' && (Schema.sObjectType.Tag__c.isAccessible()))
                       {
                          System.debug('The object Tags is accessible to this profile::'+Schema.sObjectType.Tag__c.isAccessible());
                           //myTab1.childComponents.add(ifmcb);
                           panel.childComponents.add(myTab1);
                       }
                       else if(i.name == 'Vendor Invoice' && (Schema.sObjectType.Invoice__c.isAccessible()))
                       {
                          System.debug('The object Vendor Invoice is accessible to this profile::'+Schema.sObjectType.Invoice__c.isAccessible());
                           //myTab1.childComponents.add(ifmcb);
                           panel.childComponents.add(myTab1);
                       }
                }
            }
                  
        return panel;
    }

    public Job__c job {
        get { return [SELECT Name FROM Job__c where Name=:'Summer brochure']; }
    }
    
    
}