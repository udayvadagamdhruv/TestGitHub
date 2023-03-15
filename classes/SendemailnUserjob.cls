public with sharing class SendemailnUserjob {
    
   /* public String BID {get;set;}
    public String email {get;set;}
    public String emailSubject {get;set;}
    public String emailBody {get;set;}
    public string filename1{get; set;}
    public Transient blob commandbutton1{get; set;}
    public string EServiceName;
    public string EServiceAddress;
    Public Set<string> emailset=new Set<string>();
    public string user;
    public blob b;
    
    
    public SendemailnUserjob (ApexPages.StandardController controller) {
        
        BID = ApexPages.CurrentPage().getParameters().get('id');
        user = userinfo.getusername();
        ProductionEstimate__c  activeSettings = ProductionEstimate__c.getOrgDefaults();
        EServiceName=activeSettings.Email_Service_Address_Name__c;
        EServiceAddress=activeSettings.Email_Service_address__c;
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'If you want to send email more than one user then use comma in between email Ids'));
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Like :  abc@gmail.com,xyz@yahoo.com'));
        
    }
    
    
    
    
    public PageReference sendmail() {
        
        string fruit = email;
        string[] split = fruit.Split(',');
        
        
        
        for(string item :split)
        {
            emailset.add(item);
        }
        
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        
        attach.setFileName(filename1);
        
        attach.Body=commandbutton1;
        
        
        for(string email1:emailset){
            
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new String[] { email1 });
            mail.setSubject(emailSubject+'['+'ref'+':'+BID+']' );
            mail.setHtmlBody(emailBody );
            mail.setReplyTo(EServiceAddress);
            mail.setSenderDisplayName(EServiceName);
            
            if(filename1!=null ){
                
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
                
            }
            
            // Send the email
            
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
            // mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach.Body=null });
            
            
            
        }
        
        
        
        Task t=new Task();
        if (Schema.sObjectType.Task.fields.whatid.isCreateable()) { t.whatid=BID;}
        if (Schema.sObjectType.Task.fields.subject.isCreateable()) { t.subject=emailSubject;}
        if (Schema.sObjectType.Task.fields.Description.isCreateable()) {  t.Description=emailBody ;}
        if (Schema.sObjectType.Task.fields.Email_Address__c.isCreateable()) { t.Email_Address__c=email;}
        if (Schema.sObjectType.Task.fields.sender_address__c.isCreateable()) {  t.sender_address__c = user;}
        if (Schema.sObjectType.Task.fields.status.isCreateable()) {  t.status='Completed';}
        if(Schema.sObjectType.Task.isCreateable()){insert t;}
        
        if(filename1!=null ){
            
            
            Attachment TaskAttachment=new Attachment();
            if (Schema.sObjectType.Attachment.fields.parentId.isCreateable()) { 
                TaskAttachment.parentId=t.Id;}
            if (Schema.sObjectType.Attachment.fields.name.isCreateable()) { 
                TaskAttachment.name=filename1;}
            if (Schema.sObjectType.Attachment.fields.body.isCreateable()) { 
                TaskAttachment.body=commandButton1;} //Create instance of Attachment and add fields to it
            
            if(Schema.sObjectType.Attachment.isCreateable()){ insert TaskAttachment;}
            TaskAttachment.body = null; // clears the viewstate
            
        }
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email sent to '+email));
        
        PageReference  p= new PageReference ('/'+BID ); 
        return p;
        
    }
    public PageReference cancel() {
        PageReference p= new PageReference ('/'+BID ); 
        return p;
    }
    */
    
}