// This class is used as a extension to display Job Specs under Creative Brief SubTab in Job Tab 
public with sharing class RetrieveJobSpec {

 // pop up for New page
 public Decimal NewSortOrder {set;get;}
 public string  Newspecname  {set;get;}
 public string  Newdiscription {set;get;}
 public boolean  NewisPopup {set;get;}
 public string Newsectionstring {set;get;}
 

 // pop up for eidt page
 
 public string  jobname  {set;get;}
 public Decimal SortOrder {set;get;}
 public string  specname  {set;get;}
 public string  discription {set;get;}
 public string  jobspeid  {get;set;}
 public string  test_jobspeid  {get;set;}
 public boolean  isPopup {set;get;}
 public string secionstring {set;get;}



    // Global variables
    
   public boolean isLtng{
                         
                         private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4d')?true:false;
                                          }
                         }
     public boolean isMob{
                         
                         private set; get{
                                            String theme = UserInfo.getUITheme();
                                            return (theme=='Theme4t')?true:false;
                                          }
                         }
                         
                         
    public Id jobId{get;set;}
    public List<Job_Spec__c> lstJobSpec{get;set;}
    public Job__c job{get;set;}
    public String specId{get;set;}
    public String SpecTempName{get;set;}
    public Boolean ShowSpecorder{get;set;}
    public map<string,list<Job_Spec__c>> MapCB{get;set;}
    public map<string,id> MapSec{set;get;}
    
    public Boolean EditSpecs{get;set;}
    public Boolean SaveButton{get;set;}
    public Boolean CancelButton{get;set;}
    public Boolean EditAllButton{get;set;}
    
    
    // End of Global variables
    
    // Start Constructor
    public RetrieveJobSpec(ApexPages.StandardController st) {
        job = (Job__c) st.getRecord();
        jobId = ApexPages.currentPage().getParameters().get('id');
        Job__c objJob1 = [Select id, Name from Job__c where id = : jobId];
        jobname = objJob1.Name;
        jobspeid = '';

        isPopup = false;
        NewisPopup = false;
        EditSpecs = false;
        SaveButton = false;
        CancelButton = false;
        EditAllButton = True;
        LoadSpecs();

    }
    // End Constructor

public void editAll() {
    EditSpecs = True;
    SaveButton = True;
    CancelButton = True;
    EditAllButton = False;

}

public void shownewFileds() {
    NewisPopup = true;
    Newspecname = '';
    NewSortOrder = null;
    Newdiscription = 'Enter Spec Description here';
}

//newly Added for Job Spec Pop Up

public void showEditFields() {
    /*jobspeid = ApexPages.currentPage().getParameters().get('nickName123');
    secionstring = ApexPages.currentPage().getParameters().get('nickName1123');*/

    isPopup = true;
    Job_Spec__c jbspec = new Job_Spec__c();
    jbspec = [select id, name, Sort_Order__c, Description__c From Job_Spec__c where id = : jobspeid];
    specname = jbspec.name;
    SortOrder = jbspec.Sort_Order__c;
    discription = jbspec.Description__c;

}

public void savejobspec() {

    jobId = ApexPages.currentPage().getParameters().get('id');
    try {
        Job_Spec__c jbs = new Job_Spec__c();
        jbs = [select id, name, Sort_Order__c, Description__c From Job_Spec__c where id = : jobspeid];
        jbs.id = jbs.id;
        jbs.name = specname;
        jbs.Sort_Order__c = sortorder.intValue();
        jbs.Description__c = discription;

        update jbs;
        isPopup = false;

        LoadSpecs();

        /*   PageReference p; 
              if(secionstring=='' || secionstring==null)
                   p= new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=CreativeBrief');
              else
                   p= new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section='+secionstring);
                   p.setRedirect(true);
                   return p; 
         */
    } catch (DMLException e) {
        Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error, '' + e.getMessage()));
        //return null;
    }

}

public void newsavejobspecs() {

    jobId = ApexPages.currentPage().getParameters().get('id');
    Job_Spec__c jbs1 = new Job_Spec__c(Job__c = jobId, Name = Newspecname, Description__c = Newdiscription, Sort_Order__c = NewSortOrder.intValue());
    //Job__c=jobId,Name=objJobSpec.Name,Description__c=objJobSpec.Description__c
    try {
        insert jbs1;
        NewisPopup = false;
        /* PageReference p= new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=CreativeBrief');
         p.setRedirect(true);
         return p;
         */
    } catch (DMLException e) {
        Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error, '' + e.getMessage()));
        //return null;
    }
    LoadSpecs();
}

public void canceljobspec() {
    isPopup = false;
    NewisPopup = false;
}

public void LoadSpecs() {
    jobId = ApexPages.currentPage().getParameters().get('id');

    lstJobSpec = [Select id, Name, Description__c, Sort_Order__c, Creative_Brief_Template__c from Job_Spec__c where Job__c = : jobId ORDER BY Sort_Order__c];

    MapCB = new map < string, list < Job_Spec__c >> ();
    //Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.info,''+MapCB ));

    for (Job_Spec__c JS: lstJobSpec) {
        // Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.info,''+MapCB ));
        if (MapCB.containsKey(js.Creative_Brief_Template__c)) {

            // Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.info,''+MapCB ));
            //Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.info,''+MapCB.size()));

            //Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.info,''+MapCB ));
            List < Job_Spec__c > jSpeclist = MapCB.get(js.Creative_Brief_Template__c);
            jSpeclist.add(js);
            MapCB.put(js.Creative_Brief_Template__c, jSpeclist);

        } else {
            MapCB.put(js.Creative_Brief_Template__c, new List < Job_Spec__c > {
                js
            });
        }

    }

}

// This method is called on to handle Save button
public PageReference save() {
        try {
            // update job ;
            update lstJobSpec;
        } catch (System.DMLException e) {
            return null;
        }

        if (isMob) {
            PageReference p = new Pagereference('/apex/JobRequestFormdetailpageMobile?id=' + jobId + '&tab=RelatedList' + '&section=CreativeBrief');
            p.setRedirect(true);
            return p;
        } else if (isLtng) {
            PageReference p = new Pagereference('/apex/JobdetailpageLightening07?id=' + jobId + '&section=CreativeBrief');
            p.setRedirect(true);
            return p;
        } else {
            // After inserting Job Spec, navigate to Creative Brief Tab        
            /*  PageReference p =  new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=3');
              p.setRedirect(true);
              return p;*/

            PageReference p = new Pagereference('/apex/DisplayJobSpecInJobTabLightning?id=' + jobId);
            p.setRedirect(true);
            return p;
        }

    }
    // End of method Save

public void editsave() {
    try {
        // update job ;
        update lstJobSpec;
        LoadSpecs();
    } catch (System.DMLException e) {

    }
    EditSpecs = False;
    SaveButton = False;
    CancelButton = False;
    EditAllButton = True;
}

public void editCancel() {

    EditSpecs = False;
    SaveButton = False;
    CancelButton = False;
    EditAllButton = True;
}

// This method is called on to handle SaveNotes button
public PageReference saveNotes() {
    try {
        update job;

    } catch (System.DMLException e) {
        return null;
    }

    if (isMob) {
        PageReference p = new Pagereference('/apex/JobRequestFormdetailpageMobile?id=' + jobId + '&tab=RelatedList' + '&section=CreativeBrief');
        p.setRedirect(true);
        return p;
    } else if (isLtng) {
        PageReference p = new Pagereference('/apex/JobdetailpageLightening07?id=' + jobId + '&section=CreativeBrief');
        p.setRedirect(true);
        return p;
    } else {
        // After inserting Job Spec, navigate to Creative Brief Tab        
        PageReference p = new Pagereference('/apex/jobListView?id=' + jobId + '&intFocus=3');
        p.setRedirect(true);
        return p;
    }

}

// This method is called on to handle Cancel button
Public PageReference cancelme() {
        if (isMob) {
            PageReference p = new Pagereference('/apex/JobRequestFormdetailpageMobile?id=' + jobId + '&tab=RelatedList' + '&section=CreativeBrief');
            p.setRedirect(true);
            return p;
        } else if (isLtng) {
            PageReference p = new Pagereference('/apex/JobdetailpageLightening07?id=' + jobId + '&section=CreativeBrief');
            p.setRedirect(true);
            return p;
        } else {
            // After inserting Job Spec, navigate to Creative Brief Tab        
            PageReference p = new Pagereference('/apex/DisplayJobSpecInJobTabLightning?id=' + jobId + '&intFocus=3');
            p.setRedirect(true);
            return p;
        }

    }
    // End Cancel method

// This method is called on to edit Job Spec
public Pagereference editJobSpec() {

        PageReference p;

        if (isLtng || ismob) {

            p = new Pagereference('/apex/editJobspecmobile?id=' + specId);

        } else {
            p = new Pagereference('/apex/editJobspec?id=' + specId);
        }

        p.setRedirect(true);
        return p;
    }
    // End method editJobSpec

// This method is called on to DeleteJobSpec
public Pagereference deleteJobSpec() {
        Pagereference p = new Pagereference('/apex/DeleteJobSpec?id=' + specId);
        p.setRedirect(true);
        return p;
    }
    // End method DeleteJobSpec

public void deljobspec() {

    list < Job_Spec__c > deletespecs = [select id, name from Job_Spec__c Where id = : specid limit 1];

    try {
        if (deletespecs.size() > 0) {
            Database.delete(deletespecs);
            LoadSpecs();
        }
    }
    Catch(System.DMLException e) {
        ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR, '' + e.getMessage());
        ApexPages.addMessage(msg1);
    }
}

// This method is called on to add New Job Spec
public pagereference addNewJobSpec() {
        jobId = ApexPages.currentPage().getParameters().get('id');

        PageReference p;
        if (isMob) {
            p = new Pagereference('/apex/createnewjobspecMobile');
        } else if (isLtng) {
            p = new Pagereference('/apex/createnewjobspecLightning');
        } else {
            p = Page.createnewjobspec;
        }
        p.setRedirect(true);
        p.getParameters().put('jobId', jobId);
        return p;

    }
    // End of method addNewJobSpec

// This method is called on to Import Specs
public void importSpecs() {
        //LoadSpecs();
        List < Job_Spec__c > insertJobSpecs = new List < Job_Spec__c > ();
        MapSec = new map < string, id > ();
        list < Specification_Template__c > spectemp = [select id, Name From Specification_Template__c Where id = : SpecTempName LIMIT 1];

        if (SpecTempName == NULL || SpecTempName == '-None-') {
            ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Creative Brief : You must select a Template.');
            ApexPages.addMessage(msg1);
            CancelButton = True;
            //return null;
        } else if (spectemp.size() > 0) {
            if (MapCB.ContainsKey(spectemp[0].Name)) {
                ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR, '\'' + spectemp[0].Name + '\' : This Template Already selected for this Job.');
                ApexPages.addMessage(msg1);
                CancelButton = True;
                // return null;
            } else {
                CancelButton = false;
                try {
                    List < Spec_Item__c > lstSpecs = [Select id, Name, Description__c, Value__c, Lock__c, Sort_Order__c, Specification_Template__r.name, Specification_Template__r.id from Spec_Item__c where Specification_Template__c = : SpecTempName Order By Sort_Order__c]; //CreatedDate ];

                    for (Spec_Item__c sp: lstSpecs) {
                        Job_Spec__c js = new Job_Spec__c();
                        js.Name = sp.Name;
                        js.Description__c = sp.Description__c;
                        js.Value__c = sp.Value__c;
                        js.Lock__c = sp.Lock__c;
                        js.Sort_Order__c = sp.Sort_Order__c;
                        js.Job__c = jobId;
                        js.Creative_Brief_Template__c = sp.Specification_Template__r.name;
                        insertJobSpecs.add(js);

                    }
                    insert insertJobSpecs;
                } catch (System.DMLException e) {
                    Apexpages.addMessage(New Apexpages.Message(Apexpages.Severity.Error, '' + e.getMessage()));
                }

                LoadSpecs();
                SpecTempName = '';

                /*  if(isMob)
                      {
                           PageReference p =  new Pagereference('/apex/JobRequestFormdetailpageMobile?id='+jobId+'&tab=RelatedList'+'&section=CreativeBrief');
                           p.setRedirect(true);
                           return p; 
                      }

                      else if(isLtng)
                      {
                           PageReference p =  new Pagereference('/apex/JobdetailpageLightening07?id='+jobId+'&section=CreativeBrief');
                           p.setRedirect(true);
                           return p; 
                      }
                      else
                      {
                              // After inserting Job Spec, navigate to Creative Brief Tab        
                              PageReference p =  new Pagereference('/apex/jobListView?id='+jobId+'&intFocus=3');
                              p.setRedirect(true);
                              return p;
                      }
                  */
            }

        }

    }
    // End of method Import Specs

// This method is called on to populate all Specification Template into drop down list
public List < selectOption > getSpecificationTemplates() {
        // jobId = ApexPages.currentPage().getParameters().get('id');   
        Job__c objJob = [Select id, Specification_Template__c from Job__c where id = : jobId];
        Id specTempId = objJob.Specification_Template__c;

        List < selectOption > optionList = new List < selectOption > ();
        optionList.add(new SelectOption('', '-None-'));
        for (Specification_Template__c a: [SELECT Id, name FROM Specification_Template__c where id != : specTempId ORDER BY Name]) {
            optionList.add(new selectOption(a.Id, a.Name));
        }
        return optionList;
    }
    // End of method getSpecificationTemplates

// Start Test Coverage
/*   static testMethod void Test_RetrieveJobSpec()
   {
       Job_Number_Setting__c customSetting1310 = new  Job_Number_Setting__c(Name='NO');

           insert customSetting1310;

       Media_Type__c testMedia=new Media_Type__c(Name='Test Media 1310');

               insert testMedia;

       Schedule_Template__c testST=new Schedule_Template__c(Name='Test Schedule Template 1310',Media_Types__c=testMedia.Id);

                insert testST;

       Specification_Template__c testSpec1=new Specification_Template__c(Name='Testing Spcification Template 1310');
               insert testSpec1;

       Spec_Item__c testSPI1=new Spec_Item__c(Name='Test SPI 1310',Description__c='Test Desc 1310',Specification_Template__c=testSpec1.id);
            insert testSPI1;     

        Specification_Template__c testSpec2=new Specification_Template__c(Name='Testing Spcification Template 1311');
               insert testSpec2;

       Spec_Item__c testSPI2=new Spec_Item__c(Name='Test SPI 1311',Description__c='Test Desc 1310',Specification_Template__c=testSpec2.id);
            insert testSPI2;            

       Job__c testJob1=new Job__c(Name='Test Job 1310',Start_Date__c=System.Today(),Media_Types__c=testMedia.Id,Schedule_Template__c=testST.Id,Specification_Template__c=testSpec1.Id);

                insert testJob1;

       System.assertEquals('Test Job 1310',testJob1.Name);        

       Job_Spec__c testJobSpec=new Job_Spec__c(Name='Job Spec 1310',Job__c=testJob1.id);        

                insert testJobSpec;

       ApexPages.currentPage().getParameters().put('id',testJob1.Id); 

      // Instantiate the standard controller with the Job
       ApexPages.StandardController con=new ApexPages.StandardController(testJob1);

       // Instantiate the extention instance with the standard controller 

       RetrieveJobSpec ext1=new RetrieveJobSpec(con);

       ext1.specId=testJobSpec.id;

       // Invoke the primary method on the extension

       ApexPages.Pagereference result=ext1.editJobSpec();

       result=ext1.save();
       result=ext1.importSpecs();

       ext1.SpecTempName=testSpec2.Id;
       result=ext1.importSpecs();
       result=ext1.addNewJobSpec();

       List<SelectOption> lst=ext1.getSpecificationTemplates();

       result=ext1.cancelme();

       result=ext1.deleteJobSpec();

       List<Job_Spec__c> lstJobSpec=[Select id from Job_Spec__c where Job__r.Name=:'Test Job 1310'];
       delete lstJobSpec;
       result=ext1.save();

       Job__c obj=[Select Id from Job__c where Name=:'Test Job 1310'];
       delete obj;

       Specification_Template__c specTemp1=[Select id from Specification_Template__c where Name=:'Testing Spcification Template 1310'];
       delete specTemp1;

       Specification_Template__c specTemp2=[Select id from Specification_Template__c where Name=:'Testing Spcification Template 1311'];
       delete specTemp2;

       result=ext1.importSpecs();
   }*/
// End Test Coverage
}
// End of Class