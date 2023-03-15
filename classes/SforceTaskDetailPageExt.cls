public with sharing class SforceTaskDetailPageExt {

    /*Public Boolean Reply{Set;Get;}
    Public String ReplayBody{Set;get;}
    
    Public Boolean Replylink{Set;Get;}
    Public Task t{get;set;}
    public LIST<Attachment> n2{get;set;}
    public String BID {get;set;}
    public String email {get;set;}
    public String emailSubject {get;set;}
    public String emailBody {get;set;}
    public string filename1{get; set;}
    public Transient blob commandbutton1{get; set;}
    public string EServiceName;
    public string EServiceAddress;
    Public Set<string> emailset=new Set<string>();
    public string user;
    
    
    
    
    public SforceTaskDetailPageExt(ApexPages.StandardController controller) 
    {
        Reply=false;
        ReplayBody='';
         this.t=(Task)controller.getRecord();
         
         user= userinfo.getusername();

        n2 = [select id, Name from Attachment where parentid=:t.id];
    
    
        if(t.Subject.StartsWith('Re'))
        {
            Replylink=true;
        }    
        else
        {
            Replylink=false;
        }

        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
    EServiceName=activeSettings.Email_Service_Address_Name__c;
    EServiceAddress=activeSettings.Email_Service_address__c;
    }
   
   Public PageReference back()
   {
   
           PageReference p=new PageReference('/'+t.whatid);
           p.setRedirect(true);
           return p;
           
   }
   
   Public PageReference Del()
   {
   
        if(Task.sObjectType.getDescribe().isDeletable()){
        Delete t;}
       PageReference p=new PageReference('/'+t.whatid);
       p.setRedirect(true);
       return p;
       
   }
   Public void SendReplayMethod()
   {
       Reply=true;
       system.debug('replay clicked');
   }
   
   
   
   
    public void sendmail() 
    {
    Reply=false;
    
     Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
   
    attach.setFileName(filename1);
    
    attach.Body=commandbutton1;
    
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    mail.setUseSignature(false);
    mail.setToAddresses(new String[] { t.Sender_Address__c});
    mail.setSubject( t.Subject+'['+'ref'+':'+BID+']' );
    mail.setHtmlBody(ReplayBody);
    mail.setReplyTo(EServiceAddress);
    mail.setSenderDisplayName(EServiceName);
    
    if(filename1!=null ){
    
     mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
     
    }
    
    if(!test.isRunningTest()) Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    t.Description = ReplayBody +'\n'+t.Description;
    
    
     
    Task t1=new Task();
        if (Schema.sObjectType.Task.fields.whatid.isCreateable()) {   
            t1.whatid=t.whatid;}
        if (Schema.sObjectType.Task.fields.subject.isCreateable()) {   
            t1.subject=t.Subject;}
        if (Schema.sObjectType.Task.fields.Description.isCreateable()) {   
            t1.Description=t.Description;}
        if (Schema.sObjectType.Task.fields.Email_Address__c.isCreateable()) {   
            t1.Email_Address__c=t.Sender_Address__c;}
        if (Schema.sObjectType.Task.fields.Sender_Address__c.isCreateable()) {   
            t1.Sender_Address__c=user;}
        if (Schema.sObjectType.Task.fields.status.isCreateable()) {   
            t1.status='Completed';}
        if(Schema.sObjectType.Task.isCreateable()){ insert t1;}
    
               if(filename1!=null ){
        
       
                Attachment TaskAttachment=new Attachment();
                if (Schema.sObjectType.Attachment.fields.parentId.isCreateable()) { 
                TaskAttachment.parentId=t1.Id;}
                if (Schema.sObjectType.Attachment.fields.name.isCreateable()) {
                 TaskAttachment.name=filename1;}
                if (Schema.sObjectType.Attachment.fields.body.isCreateable()) { 
                TaskAttachment.body=commandButton1;} //Create instance of Attachment and add fields to it
              
               
                   if(Schema.sObjectType.Attachment.isCreateable()){insert TaskAttachment;}
                TaskAttachment.body = null; // clears the viewstate

               }

  
   
    }
   
   */
   
   
   
}