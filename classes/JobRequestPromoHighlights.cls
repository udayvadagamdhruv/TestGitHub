public with sharing class JobRequestPromoHighlights
{
    // Global variables
    public List<JobWrapper> wrappers{get;set;}
    public static Integer toDelIdent {get;set;}
    public static Integer addCount{get;set;}
    private Integer nextIdent = 1;
    
    String MTName, ScheduleTemp,ClientName,CCName, SpecTempName, strClientContact;
    public String getScheduleTemp() {  return ScheduleTemp; }
    public void setScheduleTemp(String s) {  this.ScheduleTemp = s; }
    
    public String getMTName() { return MTName; }
    public void setMTName(String s) {  this.MTname = s; }
    
    public String getClientName() { return ClientName; }
    public void setClientName(String s) {  this.Clientname = s; }
    
    public String getCCName() {  return CCName; }
    public void setCCName(String s) {  this.CCName = s; }
    
    public String getSpecTempName() { return SpecTempName; }
    public void setSpecTempName(String s) {  this.SpecTempName = s; }
    
    Client_Contact__c c;
    // End of Global variables
    
    // Wrapper class
    public class JobWrapper
    {
        public Job__c objJob{get;set;}
        public Integer ident{get;set;}
        public String media{get;set;}
        public String mediaError{get;set;}
          
        public JobWrapper(Integer indent, String m1)
        {    
            ident = indent;
            media = m1;
            mediaError='';
            System.debug('Media Type @@@ '+media);
            objJob = new Job__c(Media_Types__c = media);
        }
    }
    // End of Wrapper class
    
    // Start constructor
    public JobRequestPromoHighlights()
    {
        strClientContact=UserInfo.getUserName();
        c=[select Id,Name, Client__r.Name, Client__c, Email__c from Client_Contact__c where Email__c =: strClientContact LIMIT 1];
        
        wrappers = new List<JobWrapper>();
        for(Integer idx = 0; idx <1 ; idx++)
        {
            wrappers.add(new JobWrapper(nextIdent++, MTname));
        }
    }
    // End of constructor
    
   public void delWrapper()
    {
        Integer toDelPos = -1;
        for(Integer idx = 0; idx < wrappers.size() ; idx++)
        {
            if(wrappers[idx].ident == toDelIdent)
            {
                toDelPos = idx;
            }
            
        }
        if(-1 != toDelPos)
        {
            wrappers.remove(toDelPos);
        }
    }
    
    public void addRows()
    {
        for(Integer idx = 0; idx < addCount ; idx++)
        {
            wrappers.add(new JobWrapper(nextIdent++, MTName));
        }
    }
    
    // This method is called on to save each Job request
    public pagereference save()
    {
       for (JobWrapper wrap : wrappers)
        {
               List<Job__c> lstJob = new List<Job__c>(); 
               if(NULL==wrap.media)
               {
                   wrap.mediaError = 'Please select Media Type';
               }
               else
               {
                   wrap.objJob.Media_Types__c = wrap.media;
                   wrap.objJob.Client__c = c.Client__c;
                   wrap.objJob.Client_Contact__c = c.Id;
               }    
               lstJob.add(wrap.objJob);
               try
                {
                    insert lstJob;  
               }
               catch(Exception e)
               {
                    return NULL;
               }
                System.debug('Job@@@ '+lstJob);
        }
        return null;
    }
    // End of method save
    
    public List<selectOption> getMediaTypes() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Media_Type__c a : [SELECT Id, Name FROM Media_Type__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    
      public List<selectOption> getScheduleTemplates()
    {
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('', '- None -')); 
        for (Schedule_Template__c r : [SELECT Id,Name FROM Schedule_Template__c where Media_Types__c=: MTName and Active__c=True order by Name]) 
        { 
            optionList.add(new selectOption(r.Id, r.Name));  
        }
        return optionList;
    }
    
        // This method is called on to retrieve All the Clients
      public List<selectOption> getClients() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Client__c a : [SELECT Id, name FROM Client__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    // End of method getClients
    
     // This method is called on to retrieve Client Contacts
     public List<selectOption> getClientContacts()
    {
        List<selectOption> optionList = new List<selectOption>();   
        optionList.add(new selectOption('', '- None -')); 
        for (Client_Contact__c r : [SELECT Id,Name FROM Client_Contact__c where Client__c =: Clientname order by Name]) 
        { 
            optionList.add(new selectOption(r.Id, r.Name));  
        }
        return optionList;
    }
    // End of method getClientContacts
    
     public List<selectOption> getSpecificationTemplates() 
    {
        List<selectOption> optionList = new List<selectOption>();
        optionList.add(new selectOption('', '- None -'));  
        for (Specification_Template__c a : [SELECT Id, name FROM Specification_Template__c order by Name]) 
        {  
            optionList.add(new selectOption(a.Id, a.Name));  
        }
        return optionList;  
    }
    
}// End of class